module test_pathstrings_types

using Test
using PathStrings

@test Path"" isa PathString
@test PathString("") isa PathString
@test_throws MethodError PathString(nothing)

end # module test_pathstrings_types
