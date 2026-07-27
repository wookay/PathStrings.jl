module test_pathstrings_types

using Test
using PathStrings

@test Path"" isa Path
@test Path("") isa Path
@test_throws MethodError Path(nothing)

end # module test_pathstrings_types
