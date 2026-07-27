# module PathStrings

# from julia/base/file.jl
#      julia/base/stat.jl

import Base: cd,
             chmod,
             chown,
             cp,
             cptree,
             # DirEntry,
             diskstat,
             hardlink,
             mkdir,
             mkpath,
             mktemp,
             mktempdir,
             mv,
             # pwd,
             rename,
             readlink,
             readdir,
             rm,
             samefile,
             sendfile,
             symlink,
             # tempdir,
             tempname,
             touch,
             unlink,
             walkdir

function cd(path::Path)
    cd(path.s)
end

function chmod(path::Path, mode::Integer; recursive::Bool=false)
    chmod(path.s, mode; recursive)
end

function chown(path::Path, owner::Integer, group::Integer=-1)
    chown(path.s, owner, group)
end

function cp(src::Path, dst::Path; force::Bool=false, follow_symlinks::Bool=false)
    cp(src.s, dst.s; force, follow_symlinks)
end

function cptree(src::Path, dst::Path; force::Bool=false, follow_symlinks::Bool=false)
    cptree(src.s, dst.s; force, follow_symlinks)
end

function diskstat(path::Path)
    diskstat(path.s)
end

function hardlink(src::Path, dst::Path)
    hardlink(src.s, dst.s)
end

function mkdir(path::Path; mode::Integer = 0o777)
    mkdir(path.s; mode)
end

function mkpath(path::Path; mode::Integer = 0o777)
    mkpath(path.s; mode)
end

const temp_prefix = "jl_"
function mktempdir(parent::Path; prefix::AbstractString=temp_prefix, cleanup::Bool=true)
    mktempdir(parent.s; prefix, cleanup)
end

function mv(src::Path, dst::Path; force::Bool=false)
    mv(src.s, dst.s; force)
end

function rename(oldpath::Path, newpath::Path)
    rename(oldpath.s, newpath.s)
end

function readlink(path::Path)::Path
    Path(readlink(path.s))
end

function readdir(dir::Path; kwargs...)::Vector{Path}
    files = readdir(dir.s; kwargs...)
    map(Path, files)
end

function rm(path::Path; force::Bool=false, recursive::Bool=false, allow_delayed_delete::Bool=true)
    rm(path.s; force, recursive, allow_delayed_delete)
end

# from julia/base/stat.jl
function samefile(a::Path, b::Path)::Bool
    samefile(a.s, b.s)
end

function sendfile(src::Path, dst::Path; force::Bool=true)
    sendfile(src.s, dst.s; force)
end

function symlink(target::Path, link::Path; dir_target::Bool = false)
    symlink(target.s, link.s; dir_target)
end

function tempname(parent::Path; max_tries::Int = 100, cleanup::Bool=true, suffix::AbstractString="")
    tempname(parent.s; max_tries, cleanup, suffix)
end

function touch(path::Path)
    touch(path.s)
end

function unlink(p::Path)
    unlink(p.s)
end

# from julia/base/file.jl
# function _walkdir(chnl, path, topdown, follow_symlinks, onerror)
function _path_walkdir(chnl, path, topdown, follow_symlinks, onerror)
    tryf(f, p) = try
            f(p)
        catch err
            isa(err, IOError) || rethrow()
            try
                onerror(err)
            catch err2
                close(chnl, err2)
            end
            return
        end
    entries = tryf(p -> readdir(p, DirEntry), path)
    entries === nothing && return
    dirs = Vector{Path}()
    files = Vector{Path}()
    for entry in entries
        # If we're not following symlinks, then treat all symlinks as files
        if (!follow_symlinks && something(tryf(islink, entry), true)) || !something(tryf(isdir, entry), false)
            push!(files, basename(entry))
        else
            push!(dirs, basename(entry))
        end
    end

    if topdown
        push!(chnl, (path, dirs, files))
    end
    for dir in dirs
        _path_walkdir(chnl, joinpath(path, dir), topdown, follow_symlinks, onerror)
    end
    if !topdown
        push!(chnl, (path, dirs, files))
    end
    nothing
end

function walkdir(path::Path; topdown=true, follow_symlinks=false, onerror=throw)
    return Channel{Tuple{Path,Vector{Path},Vector{Path}}}(chnl ->
        _path_walkdir(chnl, path, topdown, follow_symlinks, onerror))
end

function path_pwd()::Path
    Path(pwd())
end

function path_tempdir()::Path
    Path(tempdir())
end

function path_walkdir(path::Path = path_pwd(); topdown=true, follow_symlinks=false, onerror=throw)
    walkdir(path; topdown, follow_symlinks, onerror)
end

function Base.getproperty(x::Type{Path}, field::Symbol)
    if field === :pwd
        path_pwd
    elseif field === :tempdir
        path_tempdir
    elseif field === :walkdir
        path_walkdir
    else
        getfield(x, field)
    end
end

# module PathStrings
