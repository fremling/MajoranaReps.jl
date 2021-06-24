

using Test

MLGreedyEval=false
include("MathLinkHeader.jl")
@test W"a"+W"b" == W"Plus"(W"a",W"b")
@test W"a"+W"a" == W"Plus"(W"a",W"a")
@test W"a"-W"a" == W"Plus"(W"a",W"Minus"(W"a"))
MLGreedyEval=true
@test W"a"+W"b" == W"Plus"(W"a",W"b")
@test W"a"+W"a" == W"Times"(2,W"a")
@test W"a"-W"a" == 0
MLGreedyEval=false
@test W"b"+W"b" == W"Plus"(W"b",W"b")
MLGreedyEval=true

#### Test Rationals parts
@test (4//5)*W"a" == weval(W`4 a/5`)
@test W"a"*(4//5) == weval(W`4 a/5`)
@test (4//5)/W"a" == weval(W`4/(a 5)`)
@test W"a"/(4//5) == weval(W`5 a/4`)




#### Test imaginary parts
@test im*W"a" == weval(W`I * a`)
@test (2*im)*W"a" == weval(W`2 I a`)
@test im/W"a" == weval(W`I / a`)
@test W"a"/(2* im) == weval(W`- I a/2`)
@test im*(im*W"c") == weval(W`-c`)



@test W2Mstr(W`x`) == "x"
@test W2Mstr(W`Sin[x]`) == "Sin[x]"
@test W2Mstr(weval(W`a + c + v`)) == "(a + c + v)"
@test W2Mstr(weval(W`a + c*b + v`)) == "(a + (b*c) + v)"
@test W2Mstr(weval(W`(a + c)*(b + v)`)) == "((a + c)*(b + v))"
@test W2Mstr(weval(W`a^(b+c)`)) == "a^(b + c)"
@test W2Mstr(weval(W`a^2`)) == "a^2"
@test W2Mstr(weval(W`e+a^(b+c)`)) == "(a^(b + c) + e)"
@test W2Mstr(weval(W`a + c + v + Sin[2 + x + Cos[q]]`)) == "(a + c + v + Sin[(2 + x + Cos[q])])"

@test W2Mstr(weval(W`2*I`)) == "(2*I)"
@test W2Mstr(weval(W`2/I`)) == "(-2*I)"
@test W2Mstr(W`2 + 0*I`) == "(2 + (0*I))"
@test W2Mstr(W"Complex"(W"c",0)) == "c"
@test W2Mstr(weval(W"Complex"(W"c",0))) == "c"
@test W2Mstr(weval(W"Complex"(W"c",W"b"))) == "(c+b*I)"



@test (3*im)*(2*im)*W"a" == weval(W`-6 a`)
@test (3*im) + (2*im)*W"a" == weval(W`3 I + 2 I a`)
@test (3*im) - (2*im)*W"a" == weval(W`3 I - 2 I a`)

@test W2Mstr([W`x`,W`a`]) == "{x,a}"
@test W2Mstr([W`x`]) == "{x}"
@test W2Mstr([W`x` W`y`; W`z` W`x`]) == "{{x,y},{z,x}}"


P12 = [ 0 1 ; 1 0 ]
@test P12 * [W"a" W"b" ; W`a+b` 2] == [ W`a+b` 2 ; W"a" W"b"]
@test [W"a" W"b" ; W`a+b` 2] * P12  == [ W"b" W"a" ; 2 W`a+b`]

#### test larger matrix
@test P12 * [W"a" W"b" ; W`a+b` W`v+2`] == [ W`a+b` W`2+v` ; W"a" W"b"]
@test [W"a" W"b" ; W`a+b` W`v+2`] * P12  == [ W"b" W"a" ; W`2+v` W`a+b`]


#### test larger matrix
P13 = fill(0,(3,3))
P13[1,3]=1
P13[3,1]=1
P13[2,2]=1
Mat = fill(W`a+d`,3,3)
Mat[:,:] = [W`a+d` W`a+d` W`f*g`; W`a+b` W`v+2` W`f*g` ;  W`d+b`  W`a+b`  W`a+b`]
P13 * Mat * P13
#HM2 = P13*Mat*P13



###A real live eample
P14 = fill(0,(4,4))
P14[1,4]=1
P14[4,1]=1
P14[2,2]=1
P14[3,3]=1
Mat = MathLink.WExpr[W"Plus"(W"J1245", W"J1346", W"J2356") W"Plus"(W"Times"(W"Complex"(0, 1), W"J1356"), W"Times"(W"Complex"(0, -1), W"J2346")) W"Plus"(W"Times"(W"Complex"(0, -1), W"J1256"), W"Times"(W"Complex"(0, 1), W"J2345")) W"Plus"(W"J1246", W"Times"(-1, W"J1345")); W"Plus"(W"Times"(W"Complex"(0, -1), W"J1356"), W"Times"(W"Complex"(0, 1), W"J2346")) W"Plus"(W"J1245", W"Times"(-1, W"J1346"), W"Times"(-1, W"J2356")) W"Plus"(W"J1246", W"J1345") W"Plus"(W"Times"(W"Complex"(0, -1), W"J1256"), W"Times"(W"Complex"(0, -1), W"J2345")); W"Plus"(W"Times"(W"Complex"(0, 1), W"J1256"), W"Times"(W"Complex"(0, -1), W"J2345")) W"Plus"(W"J1246", W"J1345") W"Plus"(W"Times"(-1, W"J1245"), W"J1346", W"Times"(-1, W"J2356")) W"Plus"(W"Times"(W"Complex"(0, -1), W"J1356"), W"Times"(W"Complex"(0, -1), W"J2346")); W"Plus"(W"J1246", W"Times"(-1, W"J1345")) W"Plus"(W"Times"(W"Complex"(0, 1), W"J1256"), W"Times"(W"Complex"(0, 1), W"J2345")) W"Plus"(W"Times"(W"Complex"(0, 1), W"J1356"), W"Times"(W"Complex"(0, 1), W"J2346")) W"Plus"(W"Times"(-1, W"J1245"), W"Times"(-1, W"J1346"), W"J2356")]
####WE just want to see that the numbers can be computed
Mat * P14
P14 * Mat
P14 * Mat* P14
