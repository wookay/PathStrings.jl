module test_pathstrings_base_file

using Test
using PathStrings

dir = Path.pwd()
@test dir isa PathString
cd(dir)

@test Path.tempdir().s == tempdir()

c1 = Path.walkdir(dir)
c2 = Path.walkdir()
c3 = walkdir(dir)
c4 = walkdir(dir.s)

@test Base.n_avail(c1) ==
      Base.n_avail(c2) ==
      Base.n_avail(c3) ==
      Base.n_avail(c4)

if VERSION >= v"1.12"
c5 = walkdir()
@test Base.n_avail(c2) ==
      Base.n_avail(c5)
end

end # module test_pathstrings_base_file
