load "common.m2"
p = 32003;
if #scriptCommandLine > 1 then p = value scriptCommandLine#1;
kk = ZZ/p;
R = kk[y_0..y_8];
pr = s -> (stdio << s << endl << flush);
tenfold = (nm, IS, G) -> (
    -- hyperplane section (in P^10) of a general cubic tenfold X in P^11 with X n P^8 = {G=0}
    R11 := kk[y_0..y_8,w_0,w_1];
    inc := map(R11, R, toList(y_0..y_8) / (v -> sub(v,R11)));
    W0 := R11_9; W1 := R11_10;
    Ps := apply(3, i -> inc random(2,R));
    wq := {W0^2, W0*W1, W1^2};
    f := inc(G) + W0*Ps#0 + W1*Ps#1 + sum apply(wq, m -> m * inc random(1,R)) + random(kk)*W0^3 + random(kk)*W0^2*W1 + random(kk)*W0*W1^2 + random(kk)*W1^3;
    J11 := ideal jacobian ideal f;
    K := inc(IS) + ideal(Ps#0, Ps#1, W0, W1);
    gbJ := groebnerBasis(J11, Strategy => "F4");
    LT := ideal leadTerm gbJ;
    pr(nm | " tenfold, hyperplane section in P^10 MOD " | toString p | ": Jacobian scheme dim " | toString(dim LT - 1) | ", length " | toString degree LT | "; contained in S n {Psi_0=Psi_1=0} n P^8: " | toString isSubset(J11, K) | " (which has length " | toString degree K | ", HF(0..6) = " | toString hfList(K,6) | ")");
    pr("   => Jacobian scheme = S n two quadrics (same length, the latter saturated); nodes " | toString degree K | ", conditions on quartics " | toString hilbertFunction(4,K) | ", defect " | toString(degree K - hilbertFunction(4,K)));
    pr("   Q (= Psi_2 on P^8) non-vanishing at the nodes, i.e. X smooth along them: " | toString(codim(K + ideal(Ps#2)) == 11));
    -- R5 on the span P^8 of the nodes
    K8 := IS + ideal apply(3, i -> random(2,R));
    pr("   R/(I_S, three quadrics): HF = " | toString hfList(K8,8));
    hf := gorHF(K8, 6);
    pr("   R5 Hilbert function of S/I (Gorenstein quotient, socle degree 6): " | toString hf);
    );
-- (i) Pfaffian
pr("===== PFAFFIAN K3 (Q2(i)) MOD " | toString p | " =====");
M0 = random(R^6, R^{6:-1}); M = M0 - transpose M0;
IS = pfaffians(4, M);
G = (gens pfaffians(6, M))_(0,0);
pr("dim S = " | toString(dim IS - 1) | ", degree " | toString degree IS | ", HP " | toString hilbertPolynomial(IS, Projective => false) | ", HF(0..5) = " | toString hfList(IS,5) | ", pdim " | toString pdim comodule IS);
JG = ideal jacobian ideal G;
pr("Jacobian ideal of Pf (9 quadrics): contained in I_S " | toString isSubset(JG, IS) | ", equal to I_S " | toString(JG == IS) | "; its Hilbert polynomial " | toString hilbertPolynomial(JG, Projective => false) | " (same as I_S => saturation of Jacobian ideal = I_S)");
(nc, cubs) = singCubics IS;
pr("cubics singular along S: " | toString nc);
q1 = random(2,R); q2 = random(2,R);
Z = IS + ideal(q1,q2);
pr("S n two random quadrics: codim " | toString codim Z | " degree " | toString degree Z | "; HF(0..7) = " | toString hfList(Z,7) | " (ideal saturated since S is ACM)");
pr("  => nodes " | toString degree Z | ", conditions on quartics " | toString hilbertFunction(4,Z) | ", defect " | toString(degree Z - hilbertFunction(4,Z)));
tenfold("Pfaffian", IS, G);
-- (iii) Enriques
pr("===== ENRIQUES tenfold MOD " | toString p | " =====");
use R;
L = apply(3, i -> random(1,R));
sym3 = v -> matrix{{v#0,v#1,v#2},{v#1,v#3,v#4},{v#2,v#4,v#5}};
Xs = sym3 {y_0,y_1,y_2,y_3,y_4,y_5}; Ys = sym3 {y_6,y_7,y_8,L#0,L#1,L#2};
IE = minors(2,Xs) + minors(2,Ys);
GE = det Xs + random(kk) * det Ys;
tenfold("Enriques", IE, GE);
