This README gives a brief introduction to the MajoranaReps package.


For the time being there are only 4 types of majoranas `bx`, `by`, `bz` and `c`,
since the package was developed with the Kitaev Honeycomb Model in mind.

The vacuums thus organised such that

    by(j)|0> = i*bx(j)|0>
    bz(j)|0> = i*c(j)|0>

And therse transforamtions are applied automatically.

The package supports inner products through the constructions

    IP = OpInnerProd(State1,State2)

    IP = OpInnerProd(State1,Operator,State2)

The package also supports the use of [MathLink](https://github.com/JuliaInterop/MathLink.jl) and [MathLinkExtras](https://github.com/fremling/MajoranaReps.jl) syntax for algebraic prefactors.
This allows for constructions like  `W"a"*bx(1)` or ```W`-I b`*by(1)```

NB: `MathLink` needs to be loaded before invoking `MajoranaReps` the first time.
