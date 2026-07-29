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
    Base.cd(path.s)
end

function chmod(path::PathString, mode::Integer; recursive::Bool=false)
    Base.chmod(path.s, mode; recursive)
end

function chown(path::PathString, owner::Integer, group::Integer=-1)
    Base.chown(path.s, owner, group)
end

function cp(src::PathString, dst::PathString; force::Bool=false, follow_symlinks::Bool=false)
    Base.cp(src.s, dst.s; force, follow_symlinks)
end

function cptree(src::PathString, dst::PathString; force::Bool=false, follow_symlinks::Bool=false)
    Base.cptree(src.s, dst.s; force, follow_symlinks)
end

function diskstat(path::PathString)
    Base.diskstat(path.s)
end

function hardlink(src::PathString, dst::PathString)
    Base.hardlink(src.s, dst.s)
end

function mkdir(path::PathString; mode::Integer = 0o777)
    Base.mkdir(path.s; mode)
end

function mkpath(path::PathString; mode::Integer = 0o777)
    Base.mkpath(path.s; mode)
end

const temp_prefix = "jl_"
function mktempdir(parent::PathString; prefix::AbstractString=temp_prefix, cleanup::Bool=true)
    Base.mktempdir(parent.s; prefix, cleanup)
end

function mv(src::PathString, dst::PathString; force::Bool=false)
    Base.mv(src.s, dst.s; force)
end

function rename(oldpath::PathString, newpath::PathString)
    Base.rename(oldpath.s, newpath.s)
end

function readlink(path::PathString)::PathString
    (PathString ∘ Base.readlink)(path.s)
end

function readdir(dir::PathString; kwargs...)::Vector{PathString}
    files = Base.readdir(dir.s; kwargs...)
    map(PathString, files)
end

if VERSION >= v"1.14.0-DEV.2415" # julia commit 129432def9
    readdir(dir::PathString, ::Type{DirEntry}; sort::Bool=true)::Vector{DirEntry} = readdir(dir.s, DirEntry; sort)
end

function rm(path::PathString; force::Bool=false, recursive::Bool=false, allow_delayed_delete::Bool=true)
    Base.rm(path.s; force, recursive, allow_delayed_delete)
end

# from julia/base/stat.jl
function samefile(a::PathString, b::PathString)::Bool
    Base.samefile(a.s, b.s)
end

function sendfile(src::PathString, dst::PathString; force::Bool=true)
    Base.sendfile(src.s, dst.s; force)
end

function symlink(target::PathString, link::PathString; dir_target::Bool = false)
    Base.symlink(target.s, link.s; dir_target)
end

function tempname(parent::PathString; max_tries::Int = 100, cleanup::Bool=true, suffix::AbstractString="")
    Base.tempname(parent.s; max_tries, cleanup, suffix)
end

function touch(path::PathString)
    Base.touch(path.s)
end

function unlink(p::PathString)
    Base.unlink(p.s)
end

function Path_walkdir(path::PathString; kwargs...)
    Base.walkdir(path.s; kwargs...)
end

function Base.walkdir(path::PathString; topdown=true, follow_symlinks=false, onerror=throw)
    Path_walkdir(path; topdown, follow_symlinks, onerror)
end

# static functions
function pwd()::PathString
    (PathString ∘ Base.pwd)()
end

function tempdir()::PathString
    (PathString ∘ Base.tempdir)()
end

function walkdir(path::PathString = Path.pwd(); topdown=true, follow_symlinks=false, onerror=throw)
    Path_walkdir(path; topdown, follow_symlinks, onerror)
end

# module PathStrings.Path
