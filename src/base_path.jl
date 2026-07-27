# module PathStrings

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

function abspath(path::Path)::Path
    Path(abspath(path.s))
end

function basename(path::Path)::Path
    Path(basename(path.s))
end

function dirname(path::Path)::Path
    Path(dirname(path.s))
end

function expanduser(path::Path)::Path
    Path(expanduser(path.s))
end

function contractuser(path::Path)::Path
    Path(contractuser(path.s))
end

function homedir(path::Path)::Union{Path,Nothing}
    dir = homedir(path.s)
    dir === nothing ? nothing : Path(dir)
end

function isabspath(path::Path)::Bool
    isabspath(path.s)
end

function isdirpath(path::Path)::Bool
    isdirpath(path.s)
end

function joinpath(paths::Path...)::Path
    args = map(paths) do path
        path.s
    end
    Path(joinpath(args...))
end

function normpath(path::Path)::Path
    Path(normpath(path.s))
end

function realpath(path::Path)::Path
    Path(realpath(path.s))
end

function relpath(path::Path)::Path
    Path(relpath(path.s))
end

function splitdir(path::Path)::Tuple{Path, Path}
    dir, file = splitdir(path.s)
    (Path(dir), Path(file))
end

function splitdrive(path::Path)::Tuple{Path, Path}
    drive_letter_part, path_part = splitdrive(path.s)
    (Path(drive_letter_part), Path(path_part))
end

function splitext(path::Path)::Tuple{Path, Path}
    path_without_extension, extension = splitdrive(path.s)
    (Path(path_without_extension), Path(extension))
end

function splitpath(path::Path)::Vector{Path}
    path_components = splitpath(path.s)
    map(Path, path_components)
end

# module PathStrings
