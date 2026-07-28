module PathStrings

export Path, PathString, @Path_str

include("Path.jl")
using .Path: PathString, @Path_str

end # module PathStrings
