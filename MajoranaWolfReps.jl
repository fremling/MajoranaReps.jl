if !@isdefined(TabLevel)
    TabLevel = ""
end
println(TabLevel*"Open MajoranaWolfReps.jl")
TabLevel=TabLevel*"    "

include("MajoranaReps.jl")


using MathLinkExtras

function ScaleToStr(scale::Union{MathLink.WExpr,MathLink.WSymbol},tex::Bool,KetState::Bool,NumOps::Int,FirstTerm::Bool)
    if FirstTerm
        return "$(scale)*"
    else
        return "+ $(scale)*"
    end
end




TabLevel=TabLevel[1:end-4]
println(TabLevel*"Close MajoranaWolfReps.jl")
