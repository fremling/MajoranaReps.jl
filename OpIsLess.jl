if !@isdefined(TabLevel)
    TabLevel = ""
end
println(TabLevel*"Open OpIsLess.jl")
TabLevel=TabLevel*"    "

import Base.isless

###Inequality used for sorting
isless(x::MajElem, y::MajElem) = OpIsLess(x,y)
isless(x::MajoranaOp,y ::MajoranaOp) = OpIsLess(x,y)

function OpIsLess(a::MajoranaOp,b::MajoranaOp) ###Check if operators are ordered
    if a.OpList < b.OpList ##Smaller
        return true
    else ###Check for the reverse
        if a.OpList > b.OpList ##larger
            return false
        else ###Check if they are the same
            if b.OpList == a.OpList ##larger
                return true
            else
                error("Elements $a and $b cannot be ordered!")
            end
        end
    end
end


function OpIsLess(ElemA::MajElem,ElemB::MajElem)
    ###Check if majorana elements are ordered
    if ElemA.Type == ElemB.Type ##Same Operator
        return ElemA.Index < ElemB.Index ###Order by the second index
    else  ###Order by the first index
        return do_OpOrdered(ElemA.Type,ElemB.Type) ##If OpA < OpB?
    end
end


function OpOrdered(a::MajoranaOp,b::MajoranaOp) ###Check if operators are ordered
    return a.OpList <= b.OpList
end

function do_OpOrdered(OpA::String,OpB::String)
    ####Check if OpA<=OpB? (If they are the same we assume they are ordered)
    ###The order is bx < c < by < bz such that by and bz get pushed to the right and can be converted if necessary...
    ###We assume that OpA and OpB is in the desired range
    if OpA == "bx"
        return true ###bx is always first
    elseif OpA == "c"
        if OpB == "bx"
            return false
        else
            return true
        end
    elseif OpA == "by"
        if OpB == "bx" || OpB == "c"
            return false
        else
            return true
        end
    elseif OpA == "bz"
        if OpB == "bz"
            return true
        else
            return false
        end
    else
        error("Elements $OpA and $OpB cannot be ordered!")
    end
end




TabLevel=TabLevel[1:end-4]
println(TabLevel*"Close OpIsLess.jl")
