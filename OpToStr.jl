if !@isdefined(TabLevel)
    TabLevel = ""
end
println(TabLevel*"Open OpToStr.jl")
TabLevel=TabLevel*"    "



###Pretty print for the operatos
function OpPrintln(Op;tex=false,bl=false)
    println(OpToStr(Op;tex=tex,bl=bl))
end
function OpPrint(Op;tex=false,bl=false)
    print(OpToStr(Op;tex=tex,bl=bl))
end

function OpToStr(Num::Number;tex::Bool=false,bl::Bool=false)
    return "$Num"
end
function OpToStr(OP::MajoranaSp;tex::Bool=false,bl::Bool=false)
    n=0
    Str=""
    for B in OP.SpList
        if n==0
            Str *= OpToStr(B,tex=tex)
        else
            if tex
                Str *= " "
            elseif bl
                Str *= "\n"
            else
                Str *= "  "
            end
            Str *= OpToStr(B,tex=tex,FirstTerm=false)
        end
        n+=1
    end
    return Str
end


function OpRealToStr(scale,KetState,NumOps,FirstTerm)
    Rscale=real(scale)
    Str=""
    if Rscale == 1
        ###do nothing except if the list is
        if FirstTerm
            if NumOps==0 && !KetState
                Str*="1"
            end
        else
            Str*="+"
        end
    elseif Rscale ==-1
        if NumOps==0 && !KetState
            Str*="-1"
        else
            Str*="-"
        end
    else
        if FirstTerm ;
            Str*=string(Rscale)*" "
        elseif Rscale >=0
            Str*="+"*string(Rscale)*" "
        else
            Str*=string(Rscale)*" "
        end
    end
    return Str
end

function OpImagToStr(scale,tex,FirstTerm)
    ImScale=imag(scale)
    Str=""
    if ImScale >= 0
        if FirstTerm
            if tex
                Str*=string(ImScale)*"\\i "
            else
                Str*=string(ImScale)*"i "
            end
        else
            if tex
                Str*="+"*string(ImScale)*"\\i "
            else
                    Str*="+"*string(ImScale)*"i "
            end
        end
    else
        if tex
            Str*=string(ImScale)*"\\i "
        else
            Str*=string(ImScale)*"i "
        end
    end
end

function ImStr(FirstTerm,tex)
    if FirstTerm
        if tex
            Str="\\i "
        else
            Str="i "
            end
    else
        if tex
            Str="+\\i "
        else
            Str="+i "
        end
    end
    return Str
end

function ScaleToStr(scale,tex::Bool,KetState::Bool,NumOps::Int,FirstTerm::Bool)
    Str=""
    if isreal(scale)
        Str*=OpRealToStr(scale,KetState,NumOps,FirstTerm)
    elseif scale == im
        Str*=ImStr(FirstTerm,tex)
    elseif scale ==-im
        if tex
            Str*="-\\i "
        else
            Str*="-i "
        end
    elseif isreal(im*scale)
        Str*=OpImagToStr(scale,tex,FirstTerm)
    else
        if !FirstTerm ; Str*="+" end
        Str*="("*string(scale)*") "
    end
    return Str
end

###Prints the Operator list
function OpToStr(OP::MajoranaOp;tex::Bool=false,FirstTerm=true,bl::Bool=true)
    scale=OP.scale
    NumOps=length(OP.OpList)
    Str=ScaleToStr(scale,tex,OP.KetState,NumOps,FirstTerm)
    for j in 1:NumOps
        Str*=MajToStr(OP.OpList[j],tex=tex)
        if j!=NumOps
            Str*=" "
        end
    end
    if OP.KetState
        Str*=KetStr(tex)
    end
    return Str
end

function KetStr(tex::Bool=false)
    if tex
        return "\\left|0\\right\\rangle"
    else
        return "|0>"
    end
end
        
function MajToStr(Elem::MajElem;tex::Bool=false)
    A = Elem.Type
    if !tex
        Str=string(A)
    else
        if A=="bx"
            Str="b^x"
        elseif A=="by"
            Str="b^y"
        elseif A=="bz"
            Str="b^z"
        elseif A=="c"
            Str="c"
        else
            error("Unknown symbol: $A")
        end
    end
    if Elem.Index == ""
        return Str
    else
        if tex
            return Str*"_{"*string(Elem.Index)*"}"
        else
            return Str*"_"*string(Elem.Index)
        end
    end
end







TabLevel=TabLevel[1:end-4]
println(TabLevel*"Close OpToStr.jl")
