if !@isdefined(TabLevel)
    TabLevel = ""
end
println(TabLevel*"Open OpAdd.jl")
TabLevel=TabLevel*"    "


import Base.+
import Base.-


+(x::MajoranaOp,y::MajoranaOp) = OpAdd(x,y)
+(x::MajoranaSp,y::MajoranaOp) = OpAdd(x,y)
+(x::MajoranaOp,y::MajoranaSp) = OpAdd(x,y)
+(x::MajoranaSp,y::MajoranaSp) = OpAdd(x,y)

+(x::MajoranaOp,y::Number) = OpAdd(x,y)
+(x::MajoranaSp,y::Number) = OpAdd(x,y)
+(x::Number,y::MajoranaOp) = OpAdd(x,y)
+(x::Number,y::MajoranaSp) = OpAdd(x,y)

-(x::MajoranaOp,y::MajoranaOp) = x+(-1*y)
-(x::MajoranaSp,y::MajoranaOp) = x+(-1*y)
-(x::MajoranaOp,y::MajoranaSp) = x+(-1*y)
-(x::MajoranaSp,y::MajoranaSp) = x+(-1*y)

-(x::MajoranaOp,y::Number) = x+(-1*y)
-(x::MajoranaSp,y::Number) = x+(-1*y)
-(x::Number,y::MajoranaOp) = x+(-1*y)
-(x::Number,y::MajoranaSp) = x+(-1*y)

-(y::MajoranaOp) = OpScale(-1,y)
-(y::MajoranaSp) = OpScale(-1,y)


##### Methods to add majoranas
function OpAdd(a)
    OpAdd(0,a)
end


function OpAdd(b,a::Number)
     OpAdd(a,b)
end
function OpAdd(a::Number,b)
    if a == 0
        return OpCopy(b)
    else
        MajScalar(a) + b
    end
end

function OpAdd(a::Number,b::Number)
    OpScale(a+b)
end

function OpAdd(a_in::MajoranaSp,b::MajoranaSp)
    ##loop over the lists in the 'b' variable
    a=OpCopy(a_in)
    #println("the variables on the left -- a:")
    #OpPrintln(a)
    for bOP in b.SpList
        #println(".-.-.-.-.-.")
        #println("Adding  -- bOP:")
        #OpPrintln(bOP)
        a = OpAdd(a,bOP)
        #println("the new result -- a:")
        #OpPrintln(a)
        #println("a=$a")
    end
    return a
end


function OpAdd(a::MajoranaSp,b::MajoranaOp) OpAdd(b,a) end
function OpAdd(a::MajoranaOp,b_in::MajoranaSp)
    ##loop over the lists in the 'b' variable
    b=OpCopy(b_in)
    if a.scale==0
        return b
    end
    for indx in 1:length(b.SpList)
        localB=b.SpList[indx]
        if OpProp(a ,localB ) ###If poportional, spimply
            NewOp = OpAdd(a,localB)
            if NewOp == 0 ##If the weight is zero remove the term
                deleteat!(b.SpList,indx)
                if length(b.SpList)==1 ###We could have removed a term
                    return b.SpList[1] ##then return the only operator
                else ##Otherwise return all the terms
                    return b
                end
            else ##Update the scale
                b.SpList[indx]=NewOp
                return b
            end
        elseif a.OpList < localB.OpList
            ###If a  is smaller we insert a before b
            insert!(b.SpList,indx,a)
            return b
        end
        ###if it is bigger we loop to the next value to see its size
    end
    ###If we have looped over all the elements then we insert the element at the end
    push!(b.SpList,a)
    return b
end

function OpAdd(a::MajoranaOp,b::MajoranaOp;verbose=false)
    verbose && println("Adding a=$a\nand b=$b")
    if a.KetState != b.KetState
        error("a=$a and b=$b have different ket-states. Nonsensical addition")
    elseif a.scale==0
        verbose && println("Adding zero to b")
        return OpCopy(b) ###Adding zero
    elseif b.scale==0
        verbose && println("Adding zero to a")
        return OpCopy(a) ###Adding zero
    elseif OpProp(a,b) ##Check proåportionality
        verbose && println("States are Proportional")
        NewScale=a.scale+b.scale
        if NewScale == 0
            return  OpScale(0)
        else ###Just add the scales            
            MajOpOut=OpReduce(a)
            MajOpOut.scale = a.scale+b.scale
            return MajOpOut
        end
    else ###
        verbose && println("States are not proprtional")
        verbose && println("a.OpList = $(a.OpList)")
        verbose && println("b.OpList = $(b.OpList)")
        if a.OpList > b.OpList ###If a is larger we insert a after b
            verbose && println("a > b")
            return MajoranaSp([OpReduce(b),OpReduce(a)],true)
        else  ###If a  is smaller we insert a before b
            verbose && println("b < a")
            return MajoranaSp([OpReduce(a),OpReduce(b)],true)
        end
    end
end



###


TabLevel=TabLevel[1:end-4]
println(TabLevel*"Close OpAdd.jl")
