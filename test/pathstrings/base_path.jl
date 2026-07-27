module test_pathstrings_base_path

using Test
using PathStrings

tilde = Path"~"
@test contractuser(expanduser(tilde)) == tilde

@test splitpath(Path"a/b") == [Path"a", Path"b"]

end # module test_pathstrings_base_path
