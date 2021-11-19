if !@isdefined(TabLevel)
    TabLevel = ""
end
println(TabLevel*"Open OpInnerProd.jl")
TabLevel=TabLevel*"    "


function OpInnerProd(State1,MiddleOp,State2)
    OpInnerProd(State1,MiddleOp*State2)
end

function OpInnerProd(State1::Array,State2::Array)
    ###Work out the desired scale
    MyType=typeof(one(OpScaleType(State1))+one(OpScaleType(State2)))
    IPMat=zeros(MyType,length(State1),length(State2))
    for I1 in 1:length(State1)
        for I2 in 1:length(State2)
            IPMat[I1,I2]=OpInnerProd(State1[I1],State2[I2])
        end
    end
    return IPMat
end

function OpInnerProd(x::Number,OP::MajoranaOp)
    if x == 0
        return 0
    else
        OpInnerProd(MajScale(x),OP)
    end
end
function OpInnerProd(OP::MajoranaOp,x::Number)
    if x == 0
        return 0
    else
        OpInnerProd(OP,MajScale(x))
    end
end


function OpInnerProd(State2::MajoranaSp,OP1::MajoranaOp)
    ##Complex conjugate
    return conj(OpInnerProd(OP1,State2))
end


function OpInnerProd(OP1::MajoranaOp,State2::MajoranaSp)
    ###Sum over all the inner product terms
    sum=0im
    for OP2 in State2.SpList
        sum+=OpInnerProd(OP1,OP2)
    end
    return sum
end

function OpInnerProd(State1::MajoranaSp,State2::MajoranaSp)
    ###Sum over all the inner product terms
    sum=0im
    for OP1 in State1.SpList
        sum+=OpInnerProd(OP1,State2)
    end
    return sum
end

function OpInnerProd(State1::MajoranaOp,State2::MajoranaOp)
    if State1.scale == 0 || State2.scale == 0
        return 0  ###If one is zero the inner product can safely be taken to be zero.
    elseif !State1.KetState ||  !State2.KetState
        ###The states need to be ket-states
        throw(BoundsError("Enclosing elements of the inner product should be kets!"))
    end
    if State1.scale==0 || State2.scale==0
        return 0
    end
    ### Peel of the last element of state1, reverse the order and conjugate the scale
    #print("State1: ")
    #OpPrintln(State1)
    ConjState1=MajoranaOp(conj(State1.scale),State1.OpList[end:-1:1])
    #print("ConjState1: ")
    #OpPrintln(ConjState1)
    ReducedState=ConjState1*State2
    #print("ReducedState: ")
    #OpPrintln(ReducedState)
    if length(ReducedState.OpList)==0
        ###If all the elements cancel then there is an inner product
        return ReducedState.scale
    else
        ### Otherwise not
        return 0
    end  
end



TabLevel=TabLevel[1:end-4]
println(TabLevel*"Close OpInnerProd.jl")
