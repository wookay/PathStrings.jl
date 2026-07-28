module test_pathstrings_base_file

using Test
using PathStrings

dir = Path.pwd()
@test dir isa PathString
cd(dir)

end # module test_pathstrings_base_file
