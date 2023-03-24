#include("../src/MajoranaReps.jl")
using MajoranaReps
using Test

@testset "Weird sites" begin
    @test "$(c(""))" == "c"
    @test "$(bx(""))" == "bx"
    @test "$(bx(1))" == "bx_1"
    @test "$(bx("1"))" == "bx_1"
    @test "$(bx("a"))" == "bx_a"
    @test "$(c("")*Ket())" == "c|0>"
    @test "$(bx("")*c("")*Ket())" == "bx c|0>"
end

##@testset "Majorana Operator Reduction" begin
@testset "Sqrt uncertatiny" begin
    @test OpSqrt(4) < 3
    @test OpSqrt(10) > 3
    @test 2*OpSqrt(2) > 2
    @test OpSqrt(4) > OpSqrt(3)
    @test OpSqrt(12) > OpSqrt(3)
    @test OpSqrt(34) > -OpSqrt(7)
    @test OpSqrt(3) > -8
    @test -OpSqrt(2) > -8
    @test -OpSqrt(5) < -1
    @test OpSqrt(7) > OpSqrt(5)
    @test OpSqrt(7) > 2.0
    @test OpSqrt(7) < 5.0
end

@testset "Ket multiplication" begin
    @test c(1)*OpSqrt(4//5) == c(1)*2*OpSqrt(1//5)
    @test c(1)//OpSqrt(6//5) == c(1)*OpSqrt(5//6)
    @test c(1)//OpSqrt(6//5) == OpSqrt(5//6)*c(1)
    @test Ket()//OpSqrt(6//5) == Ket()*OpSqrt(5//6)
    @test Ket()//OpSqrt(6//5) == OpSqrt(5//6)*Ket()

end

@testset "Addition" begin
    @test OpSqrt(1,5)+OpSqrt(1,5) == 2*OpSqrt(5)
    @test OpSqrt(1,9)+OpSqrt(1,9) == 6
    @test OpSqrt(3)-2*OpSqrt(3) == -OpSqrt(3)
    @test 4+OpSqrt(1,9) == 7
    @test 4+OpSqrt(0,3) == 4
    @test OpSqrt(2)+OpSqrt(0,3) == OpSqrt(2)
    @test OpSqrt(5)+OpSqrt(6,0) == OpSqrt(5)
    @test (3+7)*OpSqrt(2) == 3*OpSqrt(2)+7*OpSqrt(2)
    @test (5-2)*OpSqrt(2) == 5*OpSqrt(2)-2*OpSqrt(2)
    @test (5+6*im)*OpSqrt(2) == 5*OpSqrt(2)+6*im*OpSqrt(2)
    @test (11*im+6*im)*OpSqrt(2) == 11*im*OpSqrt(2)+6*im*OpSqrt(2)
end

@testset "Complex values" begin
    @test conj((2+3*im)*OpSqrt(2)) == (2-3*im)*OpSqrt(2)
    @test conj((5*im)*OpSqrt(2)) == (-5*im)*OpSqrt(2)
    @test conj((-im//8)*OpSqrt(2)) == (im//8)*OpSqrt(2)
    @test real((2+3*im)*OpSqrt(2)) == 2*OpSqrt(2)
    @test imag((5+6*im)*OpSqrt(2)) == 6*OpSqrt(2)
    @test OpSqrt(0,2) == 0
    @test OpSqrt(3,0) == 0
    @test isreal((im*im * OpSqrt(2) // 8)) == true
    @test isreal((im * OpSqrt(2) // 8)) == false
    @test imag(OpSqrt(2)) == 0
    @test real(im*OpSqrt(3)) == 0
end    

@testset "Square root" begin
    @test (-1//32*im)*OpSqrt(4,2) == OpSqrt(-1//8*im,2)
    @test OpSqrt(4) == 2
    @test 2*OpSqrt(2) == OpSqrt(8)
    @test OpSqrt(3)*OpSqrt(2) == OpSqrt(6)
    @test OpSqrt(2)*OpSqrt(2)*OpSqrt(2) == OpSqrt(8)
    @test OpSqrt(1.5) == sqrt(1.5)
    @test 2.3*OpSqrt(3) == sqrt((2.3)^2*3)
    @test OpSqrt(1) == 1
    @test OpSqrt(0) == 0
    @test OpSqrt(17325) == 3*5*OpSqrt(77)
    @test OpSqrt(17325)^2 == 17325
    @test OpSqrt(1//2)*OpSqrt(2) == 1
    @test OpSqrt(3//4) == OpSqrt(3)*(1//2)
    @test OpSqrt(3//4)^-1 == OpSqrt(4//3)
    @test OpSqrt(3//4)^2 == 3//4
    @test OpSqrt(3//4)^3 == (3//4)*OpSqrt(3//4)
    @test OpSqrt(3//4)^-3 == OpSqrt(4//3)^3

    @test OpSqrt(3//4) == OpSqrt(3)//2
    @test OpSqrt(5//23)^0 == 1
    @test OpSqrt(5//23)^-2 == 23//5
        @test OpSqrt(3)^-1 == OpSqrt(1//3)
        @test OpSqrt(3//4)^-1 == OpSqrt(4//3)
        @test OpSqrt(2//3)*OpSqrt(3//4) == OpSqrt(1//2)
    @test OpSqrt(2//3)*OpSqrt(6//5) == 2*OpSqrt(1//5)
    @test OpSqrt(2, 2) == OpSqrt(1, 8)

    @test 4 == OpSqrt(2, 4)
    @test 4 == OpSqrt(4, 1)
    @test 4 != OpSqrt(1, 8)
    @test 2 != OpSqrt(2, 8)
    @test 2 != OpSqrt(2, 2)
    @test 2 != OpSqrt(2, 4)
    @test 0 == OpSqrt(0, 4)
    @test 0 == OpSqrt(34, 0)
    @test 0 != OpSqrt(23, 3)
    @test 2 == OpSqrt(1, 4)
    @test -2 != OpSqrt(1, 4)
    @test -2 != OpSqrt(2, 1)
    @test 2 != OpSqrt(-2, 1)
    @test OpSqrt(2//3, 3) == OpSqrt(1//3, 3*4)
    @test OpSqrt(3)//OpSqrt(2) == OpSqrt(3//2)
    @test 3//OpSqrt(2) == OpSqrt(9//2)
    @test (5//2)//OpSqrt(2) == 5*OpSqrt(1//8)
    @test (5//2)//OpSqrt(2) == OpSqrt(25//8)
    @test OpSqrt(2)//(3//4) == 4*OpSqrt(2)//3
    @test_throws DomainError OpSqrt(-1)
    @test_throws DomainError OpSqrt(-2//17)
    @test_throws DomainError OpSqrt(1  + im)
    @test OpSqrt(5  + 0*im) == OpSqrt(5)
    @test_throws DomainError OpSqrt(-im)
    @test "$(OpSqrt(3))" == "√(3)"
    @test "$(OpSqrt(im,3))" == "im√(3)"
    @test im*OpSqrt(3) == OpSqrt(im,3)
    @test "$((im)*OpSqrt(3))" == "im√(3)"
    @test "$((1+im)*OpSqrt(3))" == "(1 + 1im)√(3)"
    @test_broken "$((1+im)*OpSqrt(3//4))" == "(1 + 1im)√(3)//2"
    @test "$((1//2+im//3)*OpSqrt(3))" == "(3 + 2im)√(3)//6"
    @test "$(OpSqrt(4*3))" == "2√(3)"
    @test "$(OpSqrt(3//4))" == "√(3)//2"
    @test "$(OpSqrt(3//2))" == "√(6)//2"
    @test "$(2*OpSqrt(3)//5)" == "2√(3)//5"
    @test "$(2*OpSqrt(3)//5)" == "2√(3)//5"
    @test isreal(OpSqrt(3*4))
    @test real(OpSqrt(3*4)) == OpSqrt(3*4)
    @test OpSqrt(im,2) == im*OpSqrt(2)
        @test (1+im)*OpSqrt(2) == OpSqrt(1+im,2)
        @test (1+im)*OpSqrt(im,2) == OpSqrt(-1+im,2)
    @test im*OpSqrt(im,2) == -OpSqrt(2)
    @test 2*im*OpSqrt(1//2,2) == OpSqrt(im,2)
    @test 3*im*OpSqrt(im//2,2) == (-3//2)*OpSqrt(2)
end


    @testset "Majorana Print" begin
        @test OpToStr(Ket()) == "|0>"
        @test OpToStr(Down()) == "|0>"
        @test OpToStr(-Down()) == "-|0>"
        @test OpToStr(-2*Down()) == "-2 |0>"
        @test OpToStr(3*Down()) == "3 |0>"
        @test OpToStr(im*Down()) == "i |0>"
        @test OpToStr(-im*Down()) == "-i |0>"
        @test OpToStr(2*im*Down()) == "2i |0>"
        @test OpToStr(-3*im*Down()) == "-3i |0>"
        @test "$((im*OpSqrt(2)//8)*bx(1))" == "√(2)//8i bx_1"
    end

@testset "ScaleType" begin
    @test OpScaleType(MajScalar(1)) == typeof(1)
    @test OpScaleType(MajScalar(.4)) == typeof(0.4)
    @test OpScaleType(MajScalar(1//3)) == typeof(2//3)
    @test OpScaleType(3*c(1)) == typeof(2)
    @test OpScaleType(2.3*c(1)) == typeof(2.3)
    @test OpScaleType(1//3*c(1)) == typeof(3//4)
    @test OpScaleType(c(1)+c(2)) == typeof(1)
    @test OpScaleType(c(1)+1.5*c(2)) == typeof(1.5)
    @test OpScaleType(2*c(1)+1//3*c(2)) == typeof(1//3)
    @test OpScaleType(1.67*c(1)+1//3*c(2)) == typeof(12.3)
    @test OpScaleType([1*c(1),1//3*c(2)]) == typeof(1//3)
    @test OpScaleType([1.4*c(1),1//3*c(2)]) == typeof(1.34)
    @test OpScaleType([c(2)+1.4*c(1),c(3)+1//3*c(2)]) == typeof(1.34)
    @test OpScaleType([c(2)+im*c(1),c(3)+1//3*c(2)]) == typeof(im*3//4)
end

    

    @testset "Majorana State" begin
        @test Down() == Ket()
        @test ! OpProp(MajScalar(1),Ket())
        @test MajScalar(1) != Ket()
        @test MajoranaOp(1,[MajElem("c",1)],false) != MajoranaOp(1,[MajElem("c",1)],true)
        @test c(1)*Down() == MajoranaOp(1,[MajElem("c",1)],true)
        @test Down() == c(1)*c(1)*Down()
        @test c(1)*c(2)*Down() == -c(2)*c(1)*Down()
        @test OpScale(2,Down()) == 2*Down()
        @test OpScale(2,Down()) == Down()*2
        @test OpAdd(1,Sz(1)) == 1+Sz(1)
        @test OpScale(-1,Sz(1)) == -Sz(1)
        @test OpAdd(1,-1*Sz(1)) == 1-Sz(1)


    end
    @testset "Space Reduction" begin
        @test bz(1)*Ket() == -im*c(1)*Ket()
        @test bx(1)*Ket() == im*by(1)*Ket()
        @test bx(1)*c(1)*Ket() == im*by(1)*c(1)*Ket()
    end


    
    @testset "Spin operators" begin
        @test  Down() ==  OpReduce(Down())
        @test  1 ==  Sx(1)*Sx(1)
        @test  1 == Sy(1)*Sy(1)
        @test  1 == Sz(1)*Sz(1)
        @test  1 == Sx(1)*Sx(1)*Sx(2)*Sx(2)
        @test  1 == Sx(1)*Sx(2)*Sx(1)*Sx(2)

        
        @test  bx(1)*by(1) == Sx(1)*Sy(1)
        @test  bx(1)*bz(1) == Sx(1)*Sz(1)
        @test  -bx(1)*by(1) == Sy(1)*Sx(1)
        @test  by(1)*bz(1) == Sy(1)*Sz(1)
        @test  -bx(1)*bz(1) == Sz(1)*Sx(1)
        @test  -by(1)*bz(1) == Sz(1)*Sy(1)
        
    end

@testset "Broadcasting and collection" begin
    @test (1//2)*(1 + ParityOp(1)) * c(1)*Ket() == 0
    @test (1//2)*(1 + ParityOp(2)) * c(1)*Ket() == c(1)*Ket()
    
    ###We befin by creating the 2^4 = 16 naive spin states
    Plist = [(1//2)*(1 + ParityOp(x)) for x in 1:1]
    FullProj = prod(Plist)
    @test FullProj*FullProj == FullProj
    @test FullProj^2 == FullProj
    BasisList = [Ket(),c(1)*c(2)*Ket()]
    Res = [FullProj*BaseElem for BaseElem in BasisList]
    end

#ProjBasisList = [ FullProj*BaseElem for BaseElem in BasisList]


@testset "Powers" begin
    Amaj = MajElem("c",1)
    @test Amaj^0 == 1
    @test Amaj == Amaj
    @test Amaj*Amaj == 1
    @test Amaj*Amaj*Amaj == Amaj
    @test  1 ==  Sx(1)^0
    @test_throws MethodError Amaj^(-1)
    @test_throws MethodError Sy(5)^(-3)
    @test Amaj^2 == 1
    @test Amaj^3 == Amaj
    @test (2*c(1))^2== 4
    @test (im*c(1))^2== -1
    @test (c(2)+2*c(1))^2==(c(2)+2*c(1))*(c(2)+2*c(1))
    @test (1+3*c(3)*c(1))^3==(1+3*c(3)*c(1))*(1+3*c(3)*c(1))*(1+3*c(3)*c(1)) 
    @test  1 ==  Sx(1)^2
    @test  -1 ==  (im*Sx(1))^2
    @test  -im*Sx(1) ==  (im*Sx(1))^3
    end

    
    @testset "Spin commutators" begin
       
        @test OpComutes(bx(1),bx(1))
        @test OpNonComutes(bx(1),bx(2))
        @test OpNonComutes(bx(1),by(1))
        @test OpNonComutes(bx(1),bz(1))
        @test OpNonComutes(bx(1),c(1))
        @test OpNonComutes(by(1),bz(1))
        @test OpNonComutes(by(1),c(1))
        @test OpNonComutes(bz(1),c(1))
        
        @test Down() == Ket()
        ##Check the eigenvalues Z
        @test -Down() == Sz(1)*Down() 
        @test Up(1)  == Sz(1)*Up(1)
        ##Check that S^x implements spin flip
        @test Up(1)  == Sx(1)*Down() 
        @test Down()  == Sx(1)*Up(1) 
        ##Check that S^y implements spin flip
        @test -im*Up(1)  == Sy(1)*Down()
        @test im*Down()  == Sy(1)*Up(1) 

        @test OpComutes(Sx(1),Sx(1))
        @test OpComutes(Sx(1),Sx(2))
        @test !OpComutes(Sx(1),Sy(1),strict=false)
        @test !OpComutes(Sx(1),Sz(1),strict=false)
        @test_throws DomainError OpComutes(Sx(1),Sy(1))
        @test_throws DomainError OpComutes(Sx(1),Sz(1))

        @test OpNonComutes(Sx(1),Sy(1))
        @test OpNonComutes(Sx(1),Sz(1))
        @test !OpNonComutes(Sx(1),Sx(1),strict=false)
        @test_throws DomainError OpNonComutes(Sx(1),Sx(1))
        
        ###Check parity commutes with the spin operators
        @test OpComutes(ParityOp(1),Sx(1))
        @test OpComutes(ParityOp(1),Sy(1))
        @test OpComutes(ParityOp(1),Sz(1))

        
    end
    

    @testset "ParityProjectors" begin
        @test Down() == ParityOp(1)*Down()
        @test Up(1) == ParityOp(1)*Up(1)
        @test Up(2) == ParityOp(1)*Up(2)
        @test Up(1,2) == ParityOp(1)*Up(1,2)
        
        @test  -bx(1)*Down() == ParityOp(1)*bx(1)*Down()
        @test  -bz(1)*Down() == ParityOp(1)*bz(1)*Down()
        @test  -bz(1)*by(2)*Down() == ParityOp(1)*bz(1)*by(2)*Down()
        @test  bx(2)*Down() == ParityOp(1)*bx(2)*Down()
        @test OpComutes( bx(2)*by(2) , ParityOp(2) )
        @test OpNonComutes( by(2) , ParityOp(2) )
        

    end

    @testset "Multispin" begin
        @test  Up(1,2) == Up(2,1) 
        @test  Up(1,2) == Sx(1)*Sx(2)*Down() 
        @test  Up(2) == Sx(1)*Up(1,2) 
        @test  Up(1,3) == Sx(3)*Sx(2)*Up(1,2) 
    end
    @testset "Inner Products" begin
        @test_throws BoundsError OpInnerProd(Down(),Sx(1))
        @test_throws BoundsError OpInnerProd(Sy(1),Down())
        @test 0 == OpInnerProd(0,Down())
        @test 0 == OpInnerProd(Down(),0)
        @test 0 == OpInnerProd(MajScalar(0),Down())
        @test 0 == OpInnerProd(Down(),MajScalar(0))
        @test 1 == OpInnerProd(Down(),Down())
        @test 1 == OpInnerProd(Up(1),Up(1))
        @test 0 == OpInnerProd(Up(1),Down())
        @test 1 == OpInnerProd(Up(1,2),Up(1,2))
        @test 0 == OpInnerProd(Up(1,2),Up(1,3))
        @test 0 == OpInnerProd(Up(1),Up(1,2))
        ### Test insertions of more operators
        @test 1 == OpInnerProd(Up(1),Sx(1),Down())
        @test 0 == OpInnerProd(Down(),Sx(1),Down())
        @test -im == OpInnerProd(Up(1),Sy(1),Down())
        @test 0 == OpInnerProd(Down(),Sy(1),Down())
        @test_throws BoundsError OpInnerProd(Down(),Sx(1),Sx(1))
        @test_throws ErrorException OpInnerProd(Down(),Down(),Sx(1))
        @test_throws ErrorException OpInnerProd(Up(1),Down(),Down())
        @test_throws ErrorException OpInnerProd(Down(),Down(),Up(1))
    end

    @testset "Scalars" begin
        @test 0*Down()  == 0
        @test MajScalar(0) == 0
        @test MajScalar(1) == 1
        @test MajScalar(im) == im
        @test MajoranaOp(1,fill(MajElem("c",1),0),true) != 1
        @test MajoranaOp(0,fill(MajElem("c",1),0),true) == 0
        @test MajoranaOp(0,[MajElem("c",1)],true) == 0
        @test MajoranaOp(0,[MajElem("bx",2)],false) == 0
    end


    @testset "Super-positions" begin
        ###Define a superposition
        ###Test abelian addition of term
        @test Up(2) - Up(2) == 0
        @test Down() + Up(1)  == Up(1) + Down()
        @test Up(1,2) + Up(1) ==  Up(1) + Up(1,2)  
        ###Test that a+a =2*a
        @test Up(1) + Up(1) ==  2*Up(1)
        ###Test that r(a+b) =r*a+r*b
        @test 3*(Up(1)+Up(2)) == 3*Up(1) + 3*Up(2)
        ###Test that (a+b+c) =(a+b)+c
        @test (Up(1)+Up(2))+Up(3) == Up(1)+(Up(3)+Up(2))
        ###Test that (a+b)-b =a
        @test Up(2) == -Up(1) + (Up(1)+Up(2))
        @test Up(2) == (Up(1)+Up(2)+Up(3)) - Up(3) - Up(1)

    end

@testset "Majorana Operator Reduction" begin
    #### Test the basics of addition
    M1 = Majorana("b",1)
    M2=M1
    @test M2 == M1
    M2.OpList[1]=MajElem("bx",1) ###Change both to "a"
    @test M2 == M1
    M2 = Majorana("by",1) ###Change M2 to "b"
    @test M2 == M2
    @test M1 != M2

    aMaj=MajElem("bx",1)
    bMaj=MajElem("bz",1)
    @test 1*MajoranaOp([aMaj,bMaj]) == -MajoranaOp([bMaj,aMaj])
    @test 1*MajoranaOp([aMaj,aMaj]) == MajScalar(1)
    @test 1*MajoranaOp([bMaj,bMaj]) == MajScalar(1)

    @test M2 + M1 == M1 + M2
    @test M1 + M2 == MajoranaSp([M1,M2])
    @test M2 + M1 == MajoranaSp([M1,M2])
    @test 2*M1 == M1 + M1
    @test 2*M1 != M1 + M2
    @test 2*M1 == 1*MajoranaSp([M1,M1])
end


    @testset "multi-term multiplication" begin
        Projector=1+Sx(1)*Sx(2)
        @test "1  +bx_1 bx_2 c_1 c_2"=="$Projector"
        @test Down() == 1*Down()
        @test Down() == Down()*1
        @test Projector == Projector*1
        @test 1*Projector == Projector*1
        @test Up(1)+Up(2) == Projector*Up(1)
        @test Down()+Up(1,2) == Projector*Down()
        ###Test that printing works
        @test "i bx_1 c_1|0>  +i bx_2 c_2|0>" =="$((1+Sx(1)*Sx(2))*Up(1))"
        @test "i bx_1 c_1|0>  +i bx_2 c_2|0>" == "$(Projector*Up(1))"
        @test (Sx(1)+Sy(1))*Down() == (1-im)*Up(1)
        @test Sx(1)*Down()+Sy(1)*Down() == (1-im)*Up(1)
    end


    @testset "multi-term multiplication II" begin
        @test ((Sx(1)+Sx(2))*(Up(3)+Up(4)) == Up(1,3)+Up(1,4)+Up(2,3)+Up(2,4))
        @test (Sx(1)+Sx(2))*(Up(1)+Up(2)) == Sx(1)*Up(1)+Sx(1)*Up(1)+2*Up(1,2)
        @test (Sx(1)+Sx(2))*(Up(1)-Up(2)) == 0
        @test  (1+Sx(1))*(Up(2)-Down()) == -Down()+Up(2)-Up(1)+Up(1,2)
    end
    @testset "Inner Products -multiterm" begin
        @test 2 == OpInnerProd(OpAdd(Up(1),Down()),Sx(1),OpAdd(Up(1),Down()))
        @test 0 == OpInnerProd(OpAdd(Up(1),Down()),Sy(1),OpAdd(Up(1),Down()))
        @test 1 == OpInnerProd(OpAdd(Up(1),Down()),Sx(1),Down())
        @test im == OpInnerProd(OpAdd(Up(1),Down()),OpScale(im,Down()))
        @test -im == OpInnerProd(OpScale(im,Down()),OpAdd(Up(1),Down()))
        @test im == OpInnerProd(Up(),Sy(1),OpAdd(Up(1),Down()))
        @test 0 == OpInnerProd(OpAdd(Up(1),Down()),OpAdd(OpScale(-1,Up(1)),Down()))
        @test (1+im) == OpInnerProd(Up(1)+Down(),im*Up(1)+Down())
    end
    @testset "Sanity Addition" begin
        @test OpScale(1) == OpAdd(1)
        @test OpScale(2) == OpAdd(1,1)
        @test OpScale(2) == OpAdd(0,2)
        @test Down() == OpAdd(0,Down())
        @test Down() == OpAdd(Down())
    end
    @testset "Is approx" begin
        @test isapprox(c(1),1.0001*c(1),atol=0.01)
        @test !isapprox(c(1),1.0001*c(1),atol=0.000001)
        ####test SMS
        @test isapprox(c(1)+c(2),c(2)+1.0001*c(1),atol=0.01)
        @test !isapprox(c(1)+c(2),c(2)+1.0001*c(1),atol=0.000001)
        @test !isapprox(c(1)+c(2),c(2)+1.0001*c(1),atol=0)
        @test isapprox(c(1)+c(2),c(2)+c(1),atol=0)
        @test isapprox(c(1)+c(2),c(2)+c(1),atol=0.01)
        ##### test hybrid
        @test !isapprox(c(1)+c(2),1.0000001*c(1),atol=0.1)
        @test !isapprox(c(1)+c(2),1.0000001*c(1),atol=0)
        #### An extra term that is reallt small
        @test !isapprox(c(1)+0.000000000000000001*c(2),1.0000001*c(1),atol=0)
        #### Such that it is approximately zero
        @test isapprox(c(1)+0.00000001*c(2),1.0000001*c(1),atol=0.001)
        #### Here all the extra term are either too big or the big term is too small
        @test !isapprox(c(1)+0.01*c(2),1.0000001*c(1),atol=0.001)
        @test !isapprox(c(1)+0.01*c(2)+0.01*c(3),1.0000001*c(1),atol=0.001)
        @test !isapprox(c(1)+0.01*c(2)+0.01*c(2),1.0000001*c(1),atol=0.001)
        @test !isapprox(1.1*c(1)+0.01*c(2)+0.01*c(3),1.0000001*c(1),atol=0.001)
        @test !isapprox(0.01*c(2)+0.01*c(3),1.0000001*c(1),atol=0.001)
    end
    @testset "Matrix Multiplication" begin
        Count=3
        RM=rand(3,3) ###random matrix
        vectorOp=[c(1),c(2),c(3)]
        vectorSM=[c(1)+c(2),c(2)+c(3),c(3)+c(1)]
        RMOP=RM*vectorOp
        RMSM=RM*vectorSM
        RMOPII=fill(c(1)+c(2),Count)
        RMSMII=fill(c(1)+c(2),Count)
        for i in 1:Count
            tmpOP=0
            tmpSM=0
            for j in 1:Count
                tmpOP += RM[i,j]*vectorOp[j]
                tmpSM += RM[i,j]*vectorSM[j]
            end
            RMOPII[i]=tmpOP
            RMSMII[i]=tmpSM
        end
        for i in 1:Count
            @test isapprox(RMOP[i],RMOPII[i])
            @test isapprox(RMSM[i],RMSMII[i])
        end
    end
    @testset "Broadcasting" begin
        Count=3
        RM=rand(3) ###random matrix
        vectorOp=[c(1),c(2),c(3)]
        vectorSM=[c(1)+c(2),c(2)+c(3),c(3)+c(1)]
        RMOP=RM .* vectorOp[1]
        RMSM=RM .* vectorSM[1]
        RMOPI=RM .* vectorOp
        RMSMI=RM .* vectorSM

        RMOPII=fill(c(1)+c(2),Count)
        RMSMII=fill(c(1)+c(2),Count)
        RMOPIII=fill(c(1)+c(2),Count)
        RMSMIII=fill(c(1)+c(2),Count)

        for i in 1:Count
            RMOPII[i]=RM[i] * vectorOp[1]
            RMSMII[i]=RM[i] * vectorSM[1]
            RMOPIII[i]=RM[i] * vectorOp[i]
            RMSMIII[i]=RM[i] * vectorSM[i]
        end
        for i in 1:Count
            @test isapprox(RMOP[i],RMOPII[i])
            @test isapprox(RMSM[i],RMSMII[i])

            @test isapprox(RMOPI[i],RMOPIII[i])
            @test isapprox(RMSMI[i],RMSMIII[i])
        end
    end
##end
