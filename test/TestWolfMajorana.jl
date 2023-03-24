
using MathLink

using MajoranaReps

using Test


@test W"a"*bx(1) == W"a"*bx(1)
@test W"a"*W"b"*bx(1) == W`a b`*bx(1)


@test W"a"*bx(1)*Ket() == W"a"*bx(1)*Ket()
@test W"a"*W"b"*bx(1)*Ket() == W`a b`*bx(1)*Ket()



####At the end also test the usual logic
include("TestMajoranas.jl")
