if !@isdefined(TabLevel)
    TabLevel = ""
end
println(TabLevel*"Open OpReduce.jl")
TabLevel=TabLevel*"    "




##### Reducing expressions


function OpReduce(MajSp_in::MajoranaSp;verbose=false)
    verbose && println(" ........................  ")
    verbose && println("Reduce MajoranaSp")
    verbose && println("MajSp_in=")
    verbose && OpPrintln(MajSp_in)
    ###loop over all the terms and then reduce them
    MajSp=OpCopy(MajSp_in)
    for indx in 1:length(MajSp.SpList)
        #println("indx=",indx)
        #println("MajSp.SpList[$indx]=")
        #OpPrintln(MajSp.SpList[indx])
        MajSp.SpList[indx]=OpReduce(MajSp.SpList[indx])
        #println("MajSp.SpList[$indx]=")
        #OpPrintln(MajSp.SpList[indx])
    end
    verbose && println("Reduced the terms")
    ###Loop over the terms again and check that they are correctly ordered
    NumElems=length(MajSp.SpList)
    CheckStep=NumElems-1
    while CheckStep>0
        verbose && println("CheckStep=",CheckStep," of ",NumElems)
        if CheckStep==NumElems
            verbose && println("moved to faar to right")
            ###Move to the left and continue
            CheckStep-=1
            continue
        end
        ElemA=MajSp.SpList[CheckStep]
        ElemB=MajSp.SpList[CheckStep+1]
        verbose && println("ElemA:",ElemA," ElemB:",ElemB)
        if OpProp(ElemA,ElemB) ###If the elements are proportional merge them
            deleteat!(MajSp.SpList,CheckStep)
            ###Remove on of the elements
            MajSp.SpList[CheckStep]=ElemA+ElemB
            NumElems-=1
            verbose && println("Proprtional - merge pair")
        elseif OpOrdered(ElemA,ElemB)
            ###Ordered move to the left and continute
            verbose && println("Correctly ordered")
            CheckStep-=1
            continue
        else ###Reverse order
            MajSp.SpList[CheckStep]=ElemB
            MajSp.SpList[CheckStep+1]=ElemA
            verbose && println("Reverse order")
            CheckStep+=1
            continue
        end
        CheckStep-=1
    end
    MajSp.Reduced=true
    #println("MajoranaSp-reduced")
    return MajSp
end

function OpReduce(MajOp_in::MajoranaOp;verbose=false)
    MajOp=OpCopy(MajOp_in)
    scale=MajOp.scale
    OpList=MajOp.OpList
    NumElems=length(OpList)
    verbose && print("----------------\nReduce the expresison:")
    verbose && OpPrintln(MajOp)
    CheckStep=NumElems
    while CheckStep>0
        verbose && println("CheckStep=",CheckStep," of ",NumElems)
        ElemA=OpList[CheckStep]
        if CheckStep==NumElems
            verbose && println("movement to the left not possible")
            if MajOp.KetState
                verbose && println("There is a |0> at the end. Can the operator $ElemA be transformed?")
                OpType=ElemA.Type
                if OpType == "by"
                    verbose && println("Transforming $ElemA as by")
                    scale*=-im
                    OpList[CheckStep]=MajElem("bx",ElemA.Index)
                elseif OpType == "bz"
                    verbose && println("Transforming $ElemA as bz")
                    scale*=-im
                    OpList[CheckStep]=MajElem("c",ElemA.Index)
                elseif OpType == "bx" || OpType == "c"
                    verbose && println("Not Transforming $ElemA")
                else
                    error("Unknown operators $Op")
                end
            else
            end
            ###Move to the left and continue
            CheckStep-=1
            continue
        end
        ElemB=OpList[CheckStep+1]
        verbose && println("ElemA:",ElemA," ElemB:",ElemB)
        if ElemA==ElemB ###If the elements are the same remove them
            deleteat!(OpList,CheckStep)
            deleteat!(OpList,CheckStep)
            NumElems-=2
            verbose && OpPrintln(MajoranaOp(scale,OpList))
            verbose && println("remove pair")
        elseif ElemA < ElemB
            ###Ordered move to the left and continute
            verbose && println("Correctly ordered")
            CheckStep-=1
            continue
        else ###Reverse order
            OpList[CheckStep]=ElemB
            OpList[CheckStep+1]=ElemA
            scale*=-1
            verbose && println("Reverse order")
            verbose && OpPrintln(MajoranaOp(scale,OpList))
            CheckStep+=1
            continue
        end
        CheckStep-=1
    end
    MajOp.scale=scale
    MajOp.OpList=OpList
    return MajOp
end



TabLevel=TabLevel[1:end-4]
println(TabLevel*"Close OpReduce.jl")



