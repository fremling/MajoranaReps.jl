if !@isdefined(TabLevel)
    TabLevel = ""
end
println(TabLevel*"Open OpScaleType.jl")
TabLevel=TabLevel*"    "

OpScaleType(Op::MajoranaOp) = return typeof(Op.scale)

function OpScaleType(Sp::MajoranaSp)
    ##Here we return the type one would get is all the terms were added together
    typeof(sum([one(OpScaleType(op)) for op in Sp.SpList]))
end


function OpScaleType(Arr::Array)
    AllScales=[one(OpScaleType(op)) for op in Arr]
    typeof(sum(AllScales))
end



TabLevel=TabLevel[1:end-4]
println(TabLevel*"Close OpScaleType.jl")
