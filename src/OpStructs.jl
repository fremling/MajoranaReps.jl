if !@isdefined(TabLevel)
    TabLevel = ""
end
println(TabLevel*"Open OpStructs.jl")
TabLevel=TabLevel*"    "

struct MajElem ###Define Single Majorana Element
    ###Each majorana is characterized by a string giving the current type
    Type::String
    Index::Union{Integer,String} ###Typically an integer or maybe a string
end
mutable struct MajoranaOp ###Define a majoarana operator
scale ### The prefactor of the majorana
OpList::Array{MajElem}###A list of Majorana Elements
###This could be a string and a number or something different
KetState::Bool ###Keep tarck if this is a ket state
end

###Introduce a bunch of auxillary constructors
MajoranaOp(scale,OpList::Array{MajElem}) = MajoranaOp(scale,OpList,false)
MajoranaOp(OpList::Array{MajElem}) = MajoranaOp(1.0,OpList)


#### Majorna Super Positions

mutable struct MajoranaSp ###Define a majorana superposition
SpList::Array{MajoranaOp} ###The superposition is a list of majoranas
Reduced::Bool
end
MajoranaSp(SpList) = OpReduce(MajoranaSp(SpList,false))
MajoranaSp(SpList::MajoranaOp) = OpReduce(SpList)




MajTypes=Union{MajoranaOp,MajoranaSp,MajElem}    



TabLevel=TabLevel[1:end-4]
println(TabLevel*"Close OpStructs.jl")
