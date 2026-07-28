# module PathStrings.Path

# from julia/base/path.jl

import Base: abspath,
             basename,
             dirname,
             expanduser,
             contractuser,
             homedir,
             isabspath,
             isdirpath,
             joinpath,
             normpath,
             realpath,
             relpath,
             splitdir,
             splitdrive,
             splitext,
             splitpath

function abspath(path::PathString)::PathString
    PathString(abspath(path.s))
end

function basename(path::PathString)::PathString
    PathString(basename(path.s))
end

function dirname(path::PathString)::PathString
    PathString(dirname(path.s))
end

function expanduser(path::PathString)::PathString
    PathString(expanduser(path.s))
end

function contractuser(path::PathString)::PathString
    PathString(contractuser(path.s))
end

function homedir(path::PathString)::Union{PathString,Nothing}
    dir = homedir(path.s)
    dir === nothing ? nothing : PathString(dir)
end

function isabspath(path::PathString)::Bool
    isabspath(path.s)
end

function isdirpath(path::PathString)::Bool
    isdirpath(path.s)
end

function joinpath(paths::PathString...)::PathString
    args = map(paths) do path
        path.s
    end
    PathString(joinpath(args...))
end

function normpath(path::PathString)::PathString
    PathString(normpath(path.s))
end

function realpath(path::PathString)::PathString
    PathString(realpath(path.s))
end

function relpath(path::PathString)::PathString
    PathString(relpath(path.s))
end

function splitdir(path::PathString)::Tuple{PathString, PathString}
    dir, file = splitdir(path.s)
    (PathString(dir), PathString(file))
end

function splitdrive(path::PathString)::Tuple{PathString, PathString}
    drive_letter_part, path_part = splitdrive(path.s)
    (PathString(drive_letter_part), PathString(path_part))
end

function splitext(path::PathString)::Tuple{PathString, PathString}
    path_without_extension, extension = splitdrive(path.s)
    (PathString(path_without_extension), PathString(extension))
end

function splitpath(path::PathString)::Vector{PathString}
    path_components = splitpath(path.s)
    map(PathString, path_components)
end

# module PathStrings.Path
