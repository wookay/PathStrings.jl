# module PathStrings.Path

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
             unlink
             # walkdir

function cd(path::PathString)
    cd(path.s)
end

function chmod(path::PathString, mode::Integer; recursive::Bool=false)
    chmod(path.s, mode; recursive)
end

function chown(path::PathString, owner::Integer, group::Integer=-1)
    chown(path.s, owner, group)
end

function cp(src::PathString, dst::PathString; force::Bool=false, follow_symlinks::Bool=false)
    cp(src.s, dst.s; force, follow_symlinks)
end

function cptree(src::PathString, dst::PathString; force::Bool=false, follow_symlinks::Bool=false)
    cptree(src.s, dst.s; force, follow_symlinks)
end

function diskstat(path::PathString)
    diskstat(path.s)
end

function hardlink(src::PathString, dst::PathString)
    hardlink(src.s, dst.s)
end

function mkdir(path::PathString; mode::Integer = 0o777)
    mkdir(path.s; mode)
end

function mkpath(path::PathString; mode::Integer = 0o777)
    mkpath(path.s; mode)
end

const temp_prefix = "jl_"
function mktempdir(parent::PathString; prefix::AbstractString=temp_prefix, cleanup::Bool=true)
    mktempdir(parent.s; prefix, cleanup)
end

function mv(src::PathString, dst::PathString; force::Bool=false)
    mv(src.s, dst.s; force)
end

function rename(oldpath::PathString, newpath::PathString)
    rename(oldpath.s, newpath.s)
end

function readlink(path::PathString)::PathString
    PathString(readlink(path.s))
end

function readdir(dir::PathString; kwargs...)::Vector{PathString}
    files = readdir(dir.s; kwargs...)
    map(PathString, files)
end

function rm(path::PathString; force::Bool=false, recursive::Bool=false, allow_delayed_delete::Bool=true)
    rm(path.s; force, recursive, allow_delayed_delete)
end

# from julia/base/stat.jl
function samefile(a::PathString, b::PathString)::Bool
    samefile(a.s, b.s)
end

function sendfile(src::PathString, dst::PathString; force::Bool=true)
    sendfile(src.s, dst.s; force)
end

function symlink(target::PathString, link::PathString; dir_target::Bool = false)
    symlink(target.s, link.s; dir_target)
end

function tempname(parent::PathString; max_tries::Int = 100, cleanup::Bool=true, suffix::AbstractString="")
    tempname(parent.s; max_tries, cleanup, suffix)
end

function touch(path::PathString)
    touch(path.s)
end

function unlink(p::PathString)
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
    dirs = Vector{PathString}()
    files = Vector{PathString}()
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

function Base.walkdir(path::PathString; topdown=true, follow_symlinks=false, onerror=throw)
    return Channel{Tuple{PathString,Vector{PathString},Vector{PathString}}}(chnl ->
        _path_walkdir(chnl, path, topdown, follow_symlinks, onerror))
end

# static functions
function pwd()::PathString
    PathString(Base.pwd())
end

function tempdir()::PathString
    PathString(Base.tempdir())
end

function walkdir(path::PathString = Path.pwd(); topdown=true, follow_symlinks=false, onerror=throw)
    walkdir(path; topdown, follow_symlinks, onerror)
end

# module PathStrings.Path
