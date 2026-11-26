load "common.m2"
p = 32003;
if #scriptCommandLine > 1 then p = value scriptCommandLine#1;
kk = ZZ/p;
skew = (R, n) -> (M0 := random(R^n, R^{n:-1}); M0 - transpose M0);
pr("===== LOWER RUNGS (Q7 a,b,e; Q8; Q10) MOD " | toString p | " =====");
-- sanity check of the R5 routine on a known case: P^3 in a cubic sixfold, F = sum x_i Q_i, H = {x_0 = 0}
R7 = kk[x_0..x_6];
Qs = apply(4, i -> random(2,R7));
fP = x_1*Qs#1 + x_2*Qs#2 + x_3*Qs#3;   -- f on H=P^6 with coordinates x_0..x_6 renamed: plane x_1=x_2=x_3=0 is a P^3
ZP = satLin ideal jacobian ideal fP;
pr("sanity (P^3 in sixfold): nodes " | toString degree ZP | ", HF " | toString hfList(ZP,4) | "; I_Z + (Q) == (x_1,x_2,x_3,Q_0,..,Q_3) [known annihilator of the class of P^3]: " | toString(ZP + ideal(Qs#0) == ideal(x_1,x_2,x_3,Qs#0,Qs#1,Qs#2,Qs#3)) | "; Gorenstein HF " | toString gorHF(ZP + ideal(Qs#0), 4));
q10test("Q10 sanity (P^3, 8 nodes)", fP, 2);
-- (a) sixfold F = l Q + Pf(M) in P^7
R8 = kk[x_0..x_7];
M = skew(R8, 6);
Qa = random(2,R8);
Fa = x_7*Qa + (gens pfaffians(6,M))_(0,0);
pr("(a) sixfold smooth (Jacobian ideal m-primary): " | toString(codim ideal jacobian ideal Fa == 8));
res7 = map(R7, R8, (gens R7) | {0});
fa = res7 Fa;
Ja = ideal jacobian ideal fa;
Za = satLin Ja;
pr("(a) section l=0: Jacobian scheme dim " | toString(dim Ja - 1) | " length " | toString degree Ja | ", saturated HF(0..4) = " | toString hfList(Za,4) | " => nodes " | toString degree Za | ", conditions on quadrics " | toString hilbertFunction(2,Za) | "; equals 4x4 Pfaffians: " | toString(Za == pfaffians(4, res7 M)));
Ka = Za + ideal(res7 Qa);
pr("   R5 (a): HF of R/(I_Z+Q) = " | toString hfList(Ka,6) | "; Gorenstein quotient: " | toString gorHF(Ka,4));
pr("   non-uniqueness test: dim of (C[x]/(J(f),Q))_4 = number of independent functionals on degree-4 forms killing J(F) and s: " | toString hilbertFunction(4, Ja + ideal(res7 Qa)));
q10test("Q10 Pfaffian-type (a), 14 nodes", fa, 2);
-- (b) eightfold in P^9 with a Pfaffian P^7-section
Rb = kk[x_0..x_7,w_0,w_1];
R8b = kk[x_0..x_7];
Mb = skew(R8b, 6);
ib = map(Rb, R8b, take(gens Rb, 8));
G7 = (gens pfaffians(6,Mb))_(0,0);
IC = pfaffians(4,Mb);
pr("(b) Pfaffian cubic in P^7: singular curve degree " | toString degree IC | ", genus " | toString genus IC | "; Jacobian ideal saturation == 4x4 Pfaffians: " | toString(satLin ideal jacobian ideal G7 == IC));
Ps = apply(2, i -> random(2,R8b));
use Rb;
Fb = ib(G7) + w_0*ib(Ps#0) + w_1*ib(Ps#1) + sum apply({w_0^2,w_0*w_1,w_1^2}, m -> m * ib random(1,R8b)) + random(kk)*w_0^3 + random(kk)*w_0^2*w_1 + random(kk)*w_0*w_1^2 + random(kk)*w_1^3;
pr("   eightfold smooth: " | toString(codim ideal jacobian ideal Fb == 10));
c0 = random kk;
R9 = kk[x_0..x_7,w];
hb = map(R9, Rb, take(gens R9, 8) | {R9_8, c0*R9_8});
fb = hb Fb;
Jb = ideal jacobian ideal fb;
Zb = satLin Jb;
pr("   general hyperplane through the P^7: Jacobian scheme dim " | toString(dim Jb - 1) | " length " | toString degree Jb | ", saturated HF(0..5) = " | toString hfList(Zb,5) | " => nodes " | toString degree Zb | ", conditions on cubics " | toString hilbertFunction(3,Zb));
Kb = IC + ideal(Ps#0 + c0*Ps#1, Ps#1);
pr("   R5 (b): HF of R/(I_C, Psi, Psi') = " | toString hfList(Kb,7) | "; Gorenstein quotient: " | toString gorHF(Kb,5));
q10test("Q10 Pfaffian-type (b), 28 nodes", fb, 3);
-- (e) eightfold F = l Q + det A + det B in P^9
Re = kk[x_0..x_9];
A = random(Re^3, Re^{3:-1}); B = random(Re^3, Re^{3:-1});
Qe = random(2,Re);
Fe = x_9*Qe + det A + det B;
pr("(e) eightfold smooth: " | toString(codim ideal jacobian ideal Fe == 10));
R9e = kk[x_0..x_8];
rese = map(R9e, Re, (gens R9e) | {0});
fe = rese Fe;
Je = ideal jacobian ideal fe;
Ze = satLin Je;
Seg = minors(2, rese A) + minors(2, rese B);
pr("(e) section l=0: Jacobian scheme dim " | toString(dim Je - 1) | " length " | toString degree Je | ", saturated HF(0..5) = " | toString hfList(Ze,5) | " => nodes " | toString degree Ze | ", conditions on cubics " | toString hilbertFunction(3,Ze) | "; equals {rk A<=1} n {rk B<=1} (after saturation): " | toString(Ze == satLin Seg));
Ke = Ze + ideal(rese Qe);
pr("   R5 (e): HF of R/(I_Z+Q) = " | toString hfList(Ke,7) | "; Gorenstein quotient: " | toString gorHF(Ke,5));
q10test("Q10 detA+detB (e), 36 nodes", fe, 3);
