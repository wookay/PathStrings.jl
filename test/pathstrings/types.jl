module test_pathstrings_types

using Test
using PathStrings

@test Path"" isa PathString
@test PathString("") isa PathString
@test_throws MethodError PathString(nothing)

@test PathString("") == Path""
@test PathString("") != Path"/home"

@test PathString("").s == Path"".s == ""

end # module test_pathstrings_types
