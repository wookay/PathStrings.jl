module test_pathstrings_base_file

using Test
using PathStrings

dir = Path.pwd()
@test dir isa Path
cd(dir)

end # module test_pathstrings_base_file
