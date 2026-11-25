-- Certificate, the part computed directly over QQ: (X2), (X4), (X5), the singular surface, and the first-order Hodge locus at this member.
-- Pre-registration: PREREG_exact.md.   usage: M2 --script cert_QQ.m2
kk = QQ; load "member.m2";
R = kk[z_0..z_2, p_0..p_2, q_0..q_2];
toR = map(R, S, {z_0,z_1,z_2,p_0,p_1,p_2,q_0,q_1,q_2,0,0,0});
G8 = toR F8; Ph = {toR Phi0, toR Phi1, toR Phi2};
J = ideal jacobian matrix{{G8}};
tm = cpuTime();
Sg = J + ideal(Ph#0, Ph#1);
<< "QQ (X2) Sigma = {dF8 = 0, Phi0 = Phi1 = 0}: projective dim " << dim Sg - 1 << " ; degree " << degree Sg << " ; cpu " << cpuTime() - tm << endl << flush;
<< "QQ (X5) Sigma ∩ {Phi2 = 0}: projective dim " << dim(Sg + ideal(Ph#2)) - 1 << " (-1 = empty) ; cpu " << cpuTime() - tm << endl << flush;
Q1 = Sg : ideal vars R;
<< "QQ (X4) Hilbert function of R/((dF8, Phi0, Phi1) : m), d = 0..6: " << apply(toList(0..6), d -> hilbertFunction(d, R/Q1)) << " ; cpu " << cpuTime() - tm << endl << flush;
Ss = saturate Sg;
<< "QQ (X4) saturated ideal of Sigma: degree " << degree Ss << " ; Hilbert function d = 0..6: " << apply(toList(0..6), d -> hilbertFunction(d, R/Ss)) << " ; cpu " << cpuTime() - tm << endl << flush;
T = kk[u, v];
l1 = z_0 + 2*z_1 - z_2 + 3*p_0 - 2*p_1 + p_2 + 2*q_0 - q_1 + 3*q_2;
l2 = 2*z_0 - z_1 + 3*z_2 + p_0 + p_1 - 2*p_2 - q_0 + 2*q_1 + q_2;
g = (ker map(R/Sg, T, {sub(l1, R/Sg), sub(l2, R/Sg)}))_0;
<< "QQ (X2) projection of Sigma to the fixed line: degree " << first degree g << " ; squarefree: " << (first degree gcd(g, diff(T_0, g)) == 0) << " ; cpu " << cpuTime() - tm << endl << flush;
Js = saturate J;
<< "QQ Sing(Y): projective dim " << dim Js - 1 << " ; degree " << degree Js << " ; Hilbert polynomial " << toString hilbertPolynomial(Js, Projective => false)
   << " ; generators by degree " << toString tally apply(flatten entries mingens Js, f -> first degree f) << " ; cpu " << cpuTime() - tm << endl << flush;
-- first order at this member: A = R/(dF8, Phi0, Phi1, Phi2), the functional on A_6, the pairing on cubics
I = J + ideal Ph;
Gb = gb(I, DegreeLimit => 7); A = R/I;
<< "QQ first order: Hilbert function of R/(dF8, Phi0, Phi1, Phi2), d = 0..7: " << apply(toList(0..7), d -> hilbertFunction(d, A)) << " ; cpu " << cpuTime() - tm << endl << flush;
b6 = basis(6, A);
use R;
B6 = basis(6, R); NF = B6 % Gb; mons6 = flatten entries B6; s6 = lift(b6_(0,0), R);
dl = flatten entries lift(last coefficients(NF, Monomials => matrix{{s6}}), kk);
idx = new MutableHashTable; scan(#mons6, i -> idx#(mons6#i) = i);
m3 = flatten entries basis(3, R);
PM = matrix(kk, apply(m3, a -> apply(m3, b -> dl#(idx#(a*b)))));
<< "QQ first order: rank of the pairing on the 165 cubics = " << rank PM << " (the codimension of the first-order Hodge locus of the class at this tenfold) ; cpu " << cpuTime() - tm << endl << flush;
