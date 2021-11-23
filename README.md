This README gives a brief introduction to the MajoranaReps package.

## The Majoranas ##

For the time being there are only 4 types of majoranas `bx`, `by`, `bz` and `c`,
since the package was developed with the Kitaev Honeycomb Model in mind.

The vacuums is thus organised such that `by(j)|0> == -i*bx(j)|0>`, `bz(j)|0> == -i*c(j)|0>`. There transforamtions are applied automatically.
This both of these lines will evaluate to true

    im*bx(1)*Ket() == -by(1)*Ket()
    im*c(1)*Ket() == -bz(1)*Ket()

## Inner products ##

The package supports inner products through the constructions

    IP = OpInnerProd(State1,State2)

    IP = OpInnerProd(State1,Operator,State2)

The inner product automatically handles vector quantities. For instance, if one defines two different bases

    Basis1 = [ bx(1)*Ket(), bx(2)*Ket(), bx(3)*Ket(),bx(1)*bx(2)*bx(3)*Ket()]
    Basis2 = [ by(1)*Ket(), by(2)*Ket(), by(3)*Ket(),by(1)*by(2)*by(3)*Ket()]

and then apply `OpInnerProd(Basis1,Basis2)` one will as a result get the 4x4 array

    4×4 Array{Complex{Int64},2}:
     0-1im  0+0im  0+0im  0+0im
     0+0im  0-1im  0+0im  0+0im
     0+0im  0+0im  0-1im  0+0im
     0+0im  0+0im  0+0im  0+1im

## MathLink ##

The package also supports the use of [MathLink](https://github.com/JuliaInterop/MathLink.jl) and [MathLinkExtras](https://github.com/fremling/MathLinkExtras.jl) syntax for algebraic prefactors.
This allows for constructions like  `W"a"*bx(1)` or ```W`-I b`*by(1)```

NB: `MathLink` needs to be loaded before invoking `MajoranaReps` the first time.
