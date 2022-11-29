if !@isdefined(TabLevel)
    TabLevel = ""
end
println(TabLevel*"Open OpSqrt.jl")
TabLevel=TabLevel*"    "


using Primes

IntegerTypes = Union{Integer,Complex{Integer},Complex{Int64},
                     Rational,Complex{Rational{Integer}},
                     Complex{Rational{UInt64}},
                     Complex{Rational{Int64}},Complex{Bool}}

struct OpSqrt ###Define Single Majorana Element
    ###Each majorana is characterized by a string giving the current type
    scale::Complex{Rational{Int64}}
    sqrt::Integer ###This should be non-negative
    OpSqrt(x,y) = y<0 ? error("Number $y under square-root should be non-negative") : new(x,y)
end


function OpSqrt(x::Complex)
    if imag(x) != 0
        throw(DomainError("OpSqrt for complex x=$x is not implemented yet. "*
                          "In the future this should be the principal root of $x"))
    else
        OpSqrt(real(x))
    end
end

function OpSqrt(x::OpSqrt)
    xsq = OpSqrt(x.sqrt)
    if typeof(xsq) == OpSqrt
        return OpSqrt(x.scale*xsq.scale,xsq.sqrt)
    else
        return x.scale*xsq
    end
end

### Defining a special charcter function
√(x) = OpSqrt(x) ###Looks nice but maybe not so useful

OpSqrt(x::AbstractFloat) = sqrt(x)
function OpSqrt(x::Integer)
    if x < 0
        throw(DomainError("OpSqrt for x=$x < 0 is not implemented yet. In the future this should be $im"))
    elseif x == 0
        return 0
    elseif x == 1
        return 1
    end
    ###Work out the powers
    ###Collect the factors
    Factors=collect(factor(x))
    #println("OpSqrt($x)")
    #println("Factors:" ,Factors)
    Scale = 1
    Sqrt = 1
    for (num,pow) in Factors
        #println("(num,pow) = " ,(num,pow))
        Scale *= num^div(pow,2)
        Sqrt  *= num^rem(pow,2)
        #println("(Scale,Sqrt) = " ,(Scale,Sqrt))
    end
    if Sqrt == 1
        return Scale
    else
        OpSqrt(Scale,Sqrt)
    end
end


function OpSqrt(x::Rational) ###How to handle rationals
    ###We use the convention that it is only the numerator that carry the square root. Thus we simply add an extra factor of the denominator at the  numerator and the denominator.
    return OpSqrt(x.num*x.den)//x.den
end
    

import Base.==
==(y::OpSqrt,x::Number) = (x == y)
function ==(x::Number,y::OpSqrt)
    ###Comparisson is made numerically to actual numbers
    x == y.scale*sqrt(y.sqrt)
end

function (==)(x::OpSqrt,y::OpSqrt)
    if x.scale == y.scale && x.sqrt == y.sqrt
        return true ###Both correct
    elseif x.scale != y.scale && x.sqrt == y.sqrt
        return false ###One Mismatch
    elseif x.scale == y.scale && x.sqrt != y.sqrt
        return false ###One Mismatch
    else  ## ( x.scale != y.scale && x.sqrt != y.sqrt )
        ###Both mismatch.. here the could be a reduction error
        return x.scale^2*x.sqrt == y.scale^2*y.sqrt
    end
end


import Base.*
function *(x::OpSqrt,y::OpSqrt)
    NewScale = (x.scale*y.scale)
    NewSqrt = OpSqrt(x.sqrt*y.sqrt)
    NewProd = NewScale*NewSqrt
    return NewProd
end

*(y::OpSqrt,x::IntegerTypes) = x*y
function *(x::IntegerTypes,y::OpSqrt)
    NewScale=x*y.scale
    OpSqrt(NewScale,y.sqrt)
end
*(x::AbstractFloat,y::OpSqrt) = x*y.scale*sqrt(y.sqrt)


import Base.//
//(x::OpSqrt,y::IntegerTypes) = x*(1//y)
//(y::Union{OpSqrt,IntegerTypes},x::OpSqrt) = y*(inv(x))


import Base.^
function ^(x::OpSqrt,y::Integer)
    if y < 0
        (1//OpSqrt)^(-y)
    elseif y==0
        return 1
    elseif y==1
        return 1*x ###To make sure it copied and reduced
    elseif y==2
        return x*x ###To make sure it copied and reduced
    else
        return x*(x^(y-1)) ###Recursively apply the product
    end
end


import Base.inv
inv(x::OpSqrt) = (1//(x.sqrt*x.scale))*OpSqrt(x.sqrt)

import Base.show
function Base.show(io::IO,x::OpSqrt)
    RatScale=x.scale*1//1    
    if isreal(RatScale)
        RatScale = real(RatScale)
        if RatScale.num == 1
            Str = ""
        else
            Str = "$(RatScale.num)"
        end
        RatDenom = RatScale.den
    else ###This number if complex and has fractional structure
        RatDenom=RatScale.re.den*RatScale.im.den
        RatScale=(RatScale.re.num*RatScale.im.den+
                  im*RatScale.im.num*RatScale.re.den)
        if RatScale == 1
            Str = ""
        elseif RatScale == im
            Str = "im"
        elseif RatScale == -im
            Str = "-im"
        else
            Str="($(RatScale))"
        end
    end
    Str*="√($(x.sqrt))"
    if RatDenom == 1
        Str *= ""
    else
        Str *= "//$RatDenom"
    end
    print(io,Str)
end


import Base.isreal
isreal(x::OpSqrt) = isreal(x.scale)
import Base.real
real(x::OpSqrt) = OpSqrt(real(x.scale),x.sqrt)
import Base.imag
imag(x::OpSqrt) = OpSqrt(imag(x.scale),x.sqrt)

import Base.+
import Base.-
-(x::OpSqrt) = (-1)*x
-(x::IntegerTypes,y::OpSqrt)  = OpSqrt(x,1) - y
-(y::OpSqrt,x::IntegerTypes)  = y - OpSqrt(x,1)
-(x::OpSqrt,y::OpSqrt)  = x + (-y)
+(x::IntegerTypes,y::OpSqrt)  = OpSqrt(x,1) + y
+(y::OpSqrt,x::IntegerTypes)  = OpSqrt(x,1) + y


function +(x::OpSqrt,y::OpSqrt)
    ###Check for zeros
    if x==0
        return OpSqrt(y)
    elseif y==0
        return OpSqrt(x)
    end
        
    ###First make sure functions is reduced
    RedX = OpSqrt(x.sqrt)
    RedY = OpSqrt(y.sqrt)
    if typeof(RedX) == OpSqrt
        RSqX = RedX.sqrt
        RScX = RedX.scale
    else
        RSqX = 1
        RScX = RedX
    end
    if typeof(RedY) == OpSqrt
        RSqY = RedY.sqrt
        RScY = RedY.scale
    else
        RSqY = 1
        RScY = RedY
    end
    #println("RSqX:",RSqX)
    #println("RScX:",RScX)
    #println("RSqY:",RSqY)
    #println("RScY:",RScY)
    #println("x.scale:",x.scale)
    #println("y.scale:",y.scale)
    if RSqX != RSqY
        error("$x cannot be added to $y since the square-roots are different")
    else
        if RSqX == 1
            return x.scale*RScX+y.scale*RScY
        else
            return OpSqrt(x.scale*RScX+y.scale*RScY,RSqX)
        end
    end
end


import Base.conj
function conj(x::OpSqrt)
    cx=conj(x.scale)*OpSqrt(x.sqrt)
    return cx
end

import Base.isless
function isless(y::OpSqrt,x::Number)
    if isreal(y.scale)
        x > real(y.scale)*sqrt(y.sqrt)
    else
        error("$y is complex. Comparison makes no sense")
    end
end
function isless(x::Number,y::OpSqrt)
    if isreal(y.scale)
        x < real(y.scale)*sqrt(y.sqrt)
    else
        error("$y is complex. Comparison makes no sense")
    end
end
function isless(x::OpSqrt,y::OpSqrt)
    if !isreal(x.scale)
        error("$x is complex. Comparison makes no sense")
    elseif !isreal(y.scale)
        error("$y is complex. Comparison makes no sense")
    else
        real(x.scale)*sqrt(x.sqrt) < real(y.scale)*sqrt(y.sqrt)
    end
end

        


TabLevel=TabLevel[1:end-4]
println(TabLevel*"Close OpSqrt.jl")
