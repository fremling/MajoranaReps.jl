if !@isdefined(TabLevel)
    TabLevel = ""
end
println(TabLevel*"Open MajBase.jl")
TabLevel=TabLevel*"    "


import Base.convert
import Base.show
import Base.zero
import Base.isapprox
import Base.length
import Base.iterate

include("OpSqrt.jl")
include("OpStructs.jl")
include("OpAdd.jl")
include("OpMul.jl")
include("OpEqual.jl")
include("OpReduce.jl")
include("OpIsLess.jl")
include("OpScaleType.jl")
include("OpToStr.jl")
#include("MajoranaWolfReps.jl")
   


MajScalar(x::Number)=MajoranaOp(x,fill(MajElem("a",1),0))


###Overloading multiplication and additions of majoranas


zero(x::MajoranaSp) = 0
zero(x::MajoranaOp) = 0

length(x::MajoranaSp) = 1
length(x::MajoranaOp) = 1

iterate(x::MajoranaSp) = (x,nothing)
iterate(x::MajoranaOp) = (x,nothing)
iterate(x::MajoranaSp,nothing) = nothing
iterate(x::MajoranaOp,nothing) = nothing


###Convert Between Marorna Sp and Op

convert(::Type{MajoranaOp}, x::Number) = MajScalar(x)
convert(::Type{MajoranaSp}, Op::MajoranaOp) = MajoranaSp([OpReduce(Op)],true)
convert(::Type{MajoranaSp}, Op::MajoranaSp) = MajoranaSp(Op.SpList)
function convert(::Type{MajoranaOp}, Op::MajoranaSp)
    if length(Op.SpList)==1
        return OpReduce(Op.SpList[1])
    else
        throw(DomainError("MajoranaSp=$Op contains more than one term"))
    end
end


###Copy a majorana
function OpCopy(a::MajoranaOp)
    ###Create a new marorana with a copy of the OpList of the old one
    return MajoranaOp(a.scale,copy(a.OpList),a.KetState)
end

function OpCopy(a::MajoranaSp)
    return MajoranaSp([OpCopy(x) for x in a.SpList],a.Reduced)
end


function OpProp(a::MajoranaOp,b::MajoranaOp)
    SameKet = (a.KetState == b.KetState)
    SameOps = (a.OpList == b.OpList)
    return SameKet && SameOps
end


function OpCheck(Elem::MajElem)
    if Elem.Type == "bx" || Elem.Type == "by" || Elem.Type == "bz" || Elem.Type == "c"
        return Elem
    else
        error("Unknown majorana type $Elem")
    end
end




TabLevel=TabLevel[1:end-4]
println(TabLevel*"Close MajornaBase.jl")
