if !@isdefined(TabLevel)
    TabLevel = ""
end
println(TabLevel*"Open OpMul.jl")
TabLevel=TabLevel*"    "

import Base.*
import Base.^


*(x::MajTypes,y::MajTypes) = OpMul(x,y)
*(x::Scalars,y::MajTypes) = OpScale(x,y)
*(x::MajTypes,y::Scalars) = OpScale(y,x)
^(x::MajTypes,y::Integer) = OpPower(x,y)


function OpMul(A) return OpCopy(A) end ##Of only one factor then the result is trivial

function OpMul(a::MajoranaSp,b::MajoranaSp)
    ###When both terms are superpositoins we add them term by term
    
    tot=OpScale(0)
    #print("tot=")
    #OpPrintln(tot)
    #println("tot=",tot)
    #print("b=")
    #OpPrintln(b)
    for aOP in a.SpList
        #print("aOP=")
        #OpPrintln(aOP)
        aOPb=aOP*b
        #print("aOPb=")
        #OpPrintln(aOPb)
        tot=aOPb+tot
        #print("tot=")
        #OpPrintln(tot)
    end
    return tot
end

function OpMul(a::MajoranaOp,b_in::MajoranaSp)
    if a == 0
        return 0
    end
    b = OpCopy(b_in)
    for indx in 1:length(b.SpList)
        b.SpList[indx]=a*b.SpList[indx]
    end
    return OpReduce(b)

end

function OpMul(a_in::MajoranaSp,b::MajoranaOp)
    if b == 0
        return 0
    end
    a = OpCopy(a_in)
    ###Loop over the term an multiply the on by one
    for indx in 1:length(a.SpList)
        a.SpList[indx]=a.SpList[indx]*b
    end
    return OpReduce(a)
end


function OpMul(a::MajoranaOp,b::MajoranaOp)
    ##Check that a is not a ket state
    if a.KetState
        error("The state "*OpToStr(a)*" may not be to the left of a matrix multiplication ")
    end
    OpReduce(MajoranaOp(a.scale*b.scale,vcat(a.OpList,b.OpList),b.KetState))
end

function OpMul(a::MajElem,b::MajElem)
    OpReduce(MajoranaOp(1,[a,b]))
end

OpMul(a::MajElem,b::MajoranaOp) = MajoranaOp(1,[a])*b
OpMul(b::MajoranaOp,a::MajElem) = b*MajoranaOp(1,[a])


###  Methods to Make majoranas equal
#### Scaling operators
function OpScale(scale::Scalars)
    return scale
end

function OpScale(scale::Scalars,a_in::MajoranaSp;verbose=false)
    verbose && println("Scale $a_in by  $scale")
    if a_in.Reduced ###Reduce the Majorana first
        a = OpCopy(a_in)
    else
        a = OpReduce(a_in,verbose=verbose)
    end
    for indx in 1:length(a.SpList) ###Updated the terms one by one
        a.SpList[indx]=OpScale(scale,a.SpList[indx],verbose=verbose)
    end
    return a
end

function OpScale(scale::Scalars,a_in::MajoranaOp;verbose=false)
    verbose && println("Scale $a_in by  $scale")
    if scale == 0
        return 0
    end
    a = OpReduce(a_in)
    a.scale*=scale
    return a
end

function OpScale(scale::Scalars,a::MajElem;verbose=false)
    verbose && println("Scale $a_in by  $scale")
    if scale == 0
        return 0
    else
        return MajoranaOp(scale,[a])
    end
end




function OpPower(x::Union{MajoranaOp,MajoranaSp,MajElem},y::Integer)
    if y < 0
        throw(DomainError("Majorana cannot be raised to a negative power $y"))
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


TabLevel=TabLevel[1:end-4]
println(TabLevel*"Close OpMul.jl")






