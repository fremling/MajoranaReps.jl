if !@isdefined(TabLevel)
    TabLevel = ""
end
println(TabLevel*"Open OpEqual.jl")
TabLevel=TabLevel*"    "

import Base.==

==(x::Union{MajoranaOp,MajoranaSp,MajElem},
   y::Union{MajoranaOp,MajoranaSp,MajElem}) = do_OpEqual(x,y)

==(x::Number,y::Union{MajoranaOp,MajoranaSp,MajElem}) = do_OpEqual(x,y)
==(y::Union{MajoranaOp,MajoranaSp,MajElem},x::Number) = do_OpEqual(y,x)


function OpEqual(a,b;strict=true)
    same = do_OpEqual(a,b)
    if strict && !same
        throw(ErrorException("a="*OpToStr(a)*"\nis not equal to\nb="*OpToStr(b)))
    end
    return same
end

isapprox(a::MajoranaOp,b::MajoranaOp;atol=sqrt(eps())) = do_OpEqual(a,b,atol=atol)
isapprox(a::MajoranaSp,b::MajoranaOp;atol=sqrt(eps())) = do_OpEqual(a,b,atol=atol)
isapprox(a::MajoranaOp,b::MajoranaSp;atol=sqrt(eps())) = do_OpEqual(a,b,atol=atol)
isapprox(a::MajoranaSp,b::MajoranaSp;atol=sqrt(eps())) = do_OpEqual(a,b,atol=atol)



do_OpEqual(b::MajoranaOp,a::Number)=do_OpEqual(a,b)
function do_OpEqual(a::Number,b::MajoranaOp)
    ###There two can only be the same if the majorna operator is actually a number (of if both are zero)
    if a == 0
        ###If the scale is zero they are the same
        return b.scale == 0
    else
        ##They can still be zero if there the operators list is empty and there are ket numbers
        if b.KetState
            return false
        else
            return a == b.scale && length(b.OpList)==0
        end
    end        
end

do_OpEqual(b::MajoranaSp,a::Number) =  do_OpEqual(a,b)
do_OpEqual(a::Number,b::MajoranaSp) = (MajScalar(a) == b)

function do_OpEqual(a::MajoranaOp,b::MajoranaOp;atol=0)
    #println("1: Check a="*OpToStr(a)*" vs b="*OpToStr(b))
    same=OpProp(a,b)
    if same
        if atol!=0
            return isapprox(a.scale,b.scale,atol=atol)
        else
            return (a.scale==b.scale)
        end
    else
        return false
    end
end

do_OpEqual(a::MajoranaSp,b::MajoranaOp;atol=0) = do_OpEqual(b,a,atol=atol)
function do_OpEqual(a::MajoranaOp,b::MajoranaSp;atol=0)
    #println("2: Check:\na=$a vs \nb=$b")
    if length(b.SpList)!=1
        if atol==0
            return false
        else ###It could be that some elements are (approximately) equal to zero
            ###That should be ok
            EqOp=false
            for j in 1:length(b.SpList)
                #println("Tets j=$j")
                TestEqOp=do_OpEqual(b.SpList[j],a,atol=atol)
                if TestEqOp ###This was equal to the one term
                    EqOp=true
                else ###if now it zould be approximately zero
                    TestZeroOp=isapprox(b.SpList[j].scale,0.0,atol=atol)
                    if !TestZeroOp
                        return false
                    end
                end
            end
            return EqOp
        end
    else
        return do_OpEqual(b.SpList[1],a,atol=atol)        
    end
end
function do_OpEqual(a::MajoranaSp,b::MajoranaSp;atol=0)
    #println("3: Check a=\n"*OpToStr(a)*" vs b=\n"*OpToStr(b))
    if length(b.SpList)!=length(a.SpList)
        return false
    else
        for indx in 1:length(a.SpList)
            if !do_OpEqual(a.SpList[indx],b.SpList[indx],atol=atol)
                return false
            end
        end
    end
    return true
end


function do_OpEqual(a::MajElem,b::MajElem)
    return a.Type == b.Type && a.Index == b.Index
end

do_OpEqual(a::MajElem,b::MajoranaOp) = MajoranaOp(1,[a])==b
do_OpEqual(b::MajoranaOp,a::MajElem) = MajoranaOp(1,[a])==b




TabLevel=TabLevel[1:end-4]
println(TabLevel*"Close OpEqual.jl")






