module MajoranaReps


export bx,by,bz,c,Sx,Sy,Sz,Ket


if !@isdefined(TabLevel)
    TabLevel = ""
end
println(TabLevel*"Open MajoranaReps.jl")
TabLevel=TabLevel*"    "



include("MajoranaBase.jl")
include("OpInnerProd.jl")


####We will also overlaod the show
###We will fix the strings later
import Base.show
function Base.show(io::IO,object::MajoranaOp)
    print(io,OpToStr(object))
end
function Base.show(io::IO,object::MajoranaSp)
    print(io,OpToStr(object))
end

NumStr = Union{Number,String}

###The spin represenations
Majorana(A,i::NumStr) = MajoranaOp(1,[MajElem(A,i)])
bx(i::NumStr) = Majorana("bx",i); bx() = bx("")
by(i::NumStr) = Majorana("by",i); by() = by("")
bz(i::NumStr) = Majorana("bz",i); bz() = bz("")
c(i::NumStr) = Majorana("c",i); c() = c("")
Sx(i::NumStr) = im*bx(i)*c(i)
Sy(i::NumStr) = im*by(i)*c(i)
Sz(i::NumStr) = im*bz(i)*c(i)
Ket() = MajoranaOp(1,fill(MajElem("",0),0),true)
Down() = Ket()

function Up(iList...)
    OpCollect=Down()
    for i in iList
        OpCollect= Sx(i)*OpCollect
    end
    return OpCollect
end
###The parity operator
function ParityOp(i)
    bx(i)*by(i)*bz(i)*c(i)
end




function ValidateOp(Op)
    if !(Op=="bx" || Op=="by" || Op=="bz" ||Op=="c")
        thow(DomainError(Op,"Not a valid operator name"))
    end
end

function OpOrderedOld(ElemA,ElemB) ###Check if operators are ordered
    ###We implement the following ordering
    ## bx_j < c_j and (bx/c)_k < (bx/c)_j if k<j
    ## by_j < bz_j and (by/bz)_k < (by/bz)_j if k<j
    ## (bx/c)_j < (by/bz)_k for all j,k
    (OpA,iA)=ElemA
    (OpB,iB)=ElemB
    ValidateOp(OpA)
    ValidateOp(OpB)
    if OpA=="bx"
        if (OpB=="by" || OpB=="bz")
            return true ###correctly ordered
        elseif OpB=="bx" ###Check indexes
            return iA <= iB 
        elseif OpB=="c" ###Check indexes
            return  iA <= iB
        end
    elseif OpA=="c"
        if (OpB=="by" || OpB=="bz")
            return true ###correctly ordered
        elseif OpB=="bx" ###Check indexes
            return iA < iB ##if indexes are the same the ordering is wrong 
        elseif OpB=="c" ###Check indexes
            return  iA <= iB
        end
    elseif OpA=="by"
        if (OpB=="bx" || OpB=="c")
            return false ###incorrectly ordered
        elseif OpB=="by" ###Check indexes
            return iA <= iB 
        elseif OpB=="bz" ###Check indexes
            return  iA <= iB
        end
    elseif OpA=="bz"
        if (OpB=="bx" || OpB=="c")
            return false ###incorrectly ordered
        elseif OpB=="by" ###Check indexes
            return iA < iB 
        elseif OpB=="bz" ###Check indexes
            return  iA <= iB
        end
    end
    throw(DomainError("Case was never caught"))
end


##Individual terms cannor be reordered
function OpReOrder(a::MajoranaOp) return OpCopy(a) end 


function OpReOrder(MajSp_in::MajoranaSp)
    verbose=false
    ### Loop though the function and apply the bubble sort algorithm to make sure the states are in order
    MajSp = OpCopy(MajSp_in)
    num_factors=length(MajSp.SpList)
    indx = 1
    while indx < num_factors
        if indx<=0 ; indx += 1 ; continue  end ##Sometimes we go back to long
        ElemA=MajSp.SpList[indx]
        ElemB=MajSp.SpList[indx+1]
        verbose && println("ElemA: ",OpToStr(ElemA))
        verbose && println("ElemB: ",OpToStr(ElemB))
        if OpProp(ElemA ,ElemB ) ###If poportional, simply merge the two
            verbose && println("Add the factors")
            MajSp.SpList[indx]=OpAdd(ElemA,ElemB)
            ##Then remove the B elems
            deleteat!(MajSp.SpList,indx+1)
            ##And step down the total count
            num_factors-=1
            if MajSp.SpList[indx].scale==0 ##IF the element is zero
                if num_factors!=1 ###And this is not the last element
                    verbose && println("Remoce sinze zero")
                    ###Remove this element also
                    deleteat!(MajSp.SpList,indx)
                    num_factors-=1
                    indx-=1 ##Take a step back
                else
                    verbose && println("Zero but keep")
                end
            end

        elseif ElemA.OpList < ElemB.OpList
            ###Correctly ordered Go to next pair
            indx += 1
        elseif ElemA.OpList > ElemB.OpList
            ###Reversly ordered ordered, fix and take one step back
            MajSp.SpList[indx]=OpCopy(ElemB)
            MajSp.SpList[indx+1]=OpCopy(ElemA)
            indx-=1
        else
            throw(DomainError("Should not happen"))
        end
    end
    
    return MajSp
end
    

function OpNonComutes(A::MajoranaOp,B::MajoranaOp;strict=true)
    commutes = OpComutes(A::MajoranaOp,B::MajoranaOp;strict=false)
    if strict && commutes
        throw(DomainError("A="*OpToStr(A)*" and B="*OpToStr(B)*" commutes!"))
    else return !commutes end
end

function OpComutes(A::MajoranaOp,B::MajoranaOp;strict=true)
    AB=A*B
    BA=B*A
    commutes= OpEqual(AB,BA,strict=false)
    if strict && !commutes
        throw(DomainError("A="*OpToStr(A)*" and B="*OpToStr(B)*" does not commute!\n"*
                          "AB="*OpToStr(AB)*"\nand\nBA="*OpToStr(BA)))
    else return commutes end        
end
    

function BinToOcc(BinRepIn,NumOrbitals)
    BinRep=BinRepIn
    OccRep=BitArray(fill(false,NumOrbitals))
    for indx in 1:NumOrbitals
        OccRep[indx]=mod(BinRep,2)
        BinRep = BinRep >> 1
    end
    BinRep != 0 && error("BinRep = $BinRepIn encodes more than $NumOrbitals orbitals")
    return OccRep
end


TabLevel=TabLevel[1:end-4]
println(TabLevel*"Close MajoranaReps.jl")


end #Module
