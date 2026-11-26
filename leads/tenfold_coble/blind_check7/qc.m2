load "common.m2"
p = 32003;
if #scriptCommandLine > 1 then p = value scriptCommandLine#1;
kk = ZZ/p;
R = kk[z_0..z_2,pp_0..pp_2,qq_0..qq_2];
pr("===== COBLE (Q2(ii), Q7(c),(d)) MOD " | toString p | " =====");
ok = false;
while not ok do (
    lam = random kk; xx = apply(3, i -> random kk);
    ok = (1 + lam^3 != 0) and all({(0,1,2),(1,2,0),(0,2,1)}, t -> xx#(t#0) + xx#(t#1) != lam * xx#(t#2)) and all(xx, v -> v != 0);
    );
hcub = v -> v#0^3 + v#1^3 + v#2^3 + 3*lam*v#0*v#1*v#2;
aa = - hcub(xx) / (27 * (1 + lam^3));
zv = {z_0,z_1,z_2}; pv = {pp_0,pp_1,pp_2}; qv = {qq_0,qq_1,qq_2};
G = aa * hcub(zv) + hcub(pv) + hcub(qv) + sum flatten apply(3, i -> apply(3, j -> xx#((i-j) % 3) * zv#((i+j) % 3) * pv#i * qv#j));
pr("lam = " | toString lam | ", x = " | toString xx | ", a = " | toString aa);
J = ideal jacobian ideal G;
pr("Jacobian ideal: dim " | toString(dim J - 1) | ", degree " | toString degree J | ", HP " | toString hilbertPolynomial(J, Projective => false) | ", HF(0..5) = " | toString hfList(J,5));
IS = satLin J;
pr("saturation I_S: HP " | toString hilbertPolynomial(IS, Projective => false) | ", HF(0..6) = " | toString hfList(IS,6) | " (9n^2: " | toString apply(7, n -> 9*n^2) | "), generators in degrees " | toString tally apply(flatten entries mingens IS, g -> first degree g) | ", pdim " | toString pdim comodule IS);
-- control: without the special value of a the cubic should not be singular along a surface
Gbad = G + hcub(zv);
Jb = ideal jacobian ideal Gbad;
pr("control (a replaced by a+1): singular locus dim " | toString(dim Jb - 1));
(nc, cubs) = singCubics IS;
pr("cubics singular along S: " | toString nc);
q1 = random(2,R); q2 = random(2,R); q3 = random(2,R);
Z0 = IS + ideal(q1,q2);
Z = satLin Z0;
pr("S n two random quadrics: codim " | toString codim Z | ", length " | toString degree Z | "; HF(0..7) of I_S+(q1,q2): " | toString hfList(Z0,7) | "; of its saturation: " | toString hfList(Z,7));
pr("  => nodes " | toString degree Z | ", conditions on quartics " | toString hilbertFunction(4,Z) | ", defect " | toString(degree Z - hilbertFunction(4,Z)));
-- R5 for the tenfold (on the span P^8 of the nodes)
K8 = Z + ideal(q3);
pr("R5 tenfold Coble: HF of R/(I_Z + Q) = " | toString hfList(K8,8) | " ; HF of R/(I_S + 3 quadrics) = " | toString hfList(IS + ideal(q1,q2,q3),8));
pr("   Gorenstein quotient S/I: " | toString gorHF(K8, 6));
-- tenfold hyperplane section in P^10
R11 = kk[y_0..y_8,w_0,w_1];
inc = map(R11, R, toList(y_0..y_8));
f11 = inc(G) + w_0*inc(q1) + w_1*inc(q2) + sum apply({w_0^2, w_0*w_1, w_1^2}, m -> m * inc random(1,R)) + random(kk)*w_0^3 + random(kk)*w_0^2*w_1 + random(kk)*w_0*w_1^2 + random(kk)*w_1^3;
J11 = ideal jacobian ideal f11;
LT = ideal leadTerm groebnerBasis(J11, Strategy => "F4");
K11 = inc(Z) + ideal(w_0,w_1);
pr("Coble tenfold, hyperplane section in P^10: Jacobian scheme dim " | toString(dim LT - 1) | ", length " | toString degree LT | "; contained in (S n q1 n q2)^sat n P^8: " | toString isSubset(J11, K11) | " (length " | toString degree K11 | ") => equal after saturation; conditions on quartics " | toString hilbertFunction(4, K11));
use R;
-- (c) sixfold: section of the Coble cubic by a general P^6
R6 = kk[s_0..s_6];
m6 = map(R6, R, apply(9, i -> random(1,R6)));
f6 = m6 G;
J6 = ideal jacobian ideal f6;
Z6 = satLin J6;
pr("(c) Coble n P^6: Jacobian scheme dim " | toString(dim J6 - 1) | " length " | toString degree J6 | "; saturated HF(0..4) = " | toString hfList(Z6,4) | " => nodes " | toString degree Z6 | ", conditions on quadrics " | toString hilbertFunction(2,Z6) | "; equals (I_S restricted)^sat: " | toString(Z6 == satLin m6 IS));
Q6 = random(2,R6);
pr("   R5 (c): HF of R/(I_Z+Q) = " | toString hfList(Z6 + ideal Q6, 6) | "; Gorenstein quotient: " | toString gorHF(Z6 + ideal Q6, 4));
q10test("Q10 Coble-type (c), 18 nodes", f6, 2);
-- (d) eightfold: P^7-section of the Coble cubic
use R;
R7 = kk[s_0..s_7];
m7 = map(R7, R, apply(9, i -> random(1,R7)));
g7 = m7 G;
IC = satLin ideal jacobian ideal g7;
pr("(d) Coble n P^7: singular locus dim " | toString(dim IC - 1) | ", degree " | toString degree IC | ", genus " | toString genus IC | ", HP " | toString hilbertPolynomial(IC, Projective => false));
R8 = kk[s_0..s_7,w];
i8 = map(R8, R7, toList(s_0..s_7));
Ps0 = random(2,R7); Ps1 = random(2,R7);
f8 = i8(g7) + w*i8(Ps0) + w^2*i8(random(1,R7)) + random(kk)*w^3;
J8 = ideal jacobian ideal f8;
Z8 = satLin J8;
Zc = satLin(IC + ideal Ps0);
pr("   general hyperplane section (in P^8) of the eightfold: Jacobian scheme dim " | toString(dim J8 - 1) | ", length " | toString degree J8 | "; saturated HF(0..5) = " | toString hfList(Z8,5) | " => nodes " | toString degree Z8 | ", conditions on cubics " | toString hilbertFunction(3,Z8) | "; equals (C n Psi_0, w=0): " | toString(Z8 == i8(Zc) + ideal(w)));
pr("   Q=Psi_1 nonvanishing at nodes: " | toString(codim(Zc + ideal Ps1) == 8));
pr("   R5 (d): HF of R/(I_Z+Q) on P^7 = " | toString hfList(Zc + ideal Ps1, 7) | "; Gorenstein quotient: " | toString gorHF(Zc + ideal Ps1, 5));
