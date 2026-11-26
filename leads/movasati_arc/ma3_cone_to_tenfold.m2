-- ma3: the eightfold arc of ma2, read on the Fermat TENFOLD (x_10, x_11 untouched), at Movasati's pair of 5-planes,
-- tested with the tenfold's own 221 period functions.   MOD p.
-- usage (repository root):  M2 --script leads/movasati_arc/ma3_cone_to_tenfold.m2 p lambda statefile [nterms]
-- statefile: written by ma2_slice_arc.m2 (two header lines after the comment, then T_1.. one per line).
needsPackage("HodgeLociCI", FileName => "M2/HodgeLociCI.m2");
pp = value(scriptCommandLine#1); lam = value(scriptCommandLine#2); sf = scriptCommandLine#3;
S8 = fermatRing(3, 8, pp); z8 = lift(fermatRoot S8, ZZ);
S = fermatRing(3, 10, pp); z = fermatRoot S; kk = coefficientRing S;
<< "the same root of unity in both rings: " << (lift(z, ZZ) == z8) << endl;
ll = select(lines get sf, l -> #l > 0 and l#0 != "#");
use S;
Ts = apply(drop(ll, 2), l -> value l);
if #scriptCommandLine > 4 then Ts = take(Ts, value(scriptCommandLine#4));
L1 = apply(6, i -> {2*i, 2*i+1, 1});
L2 = apply(6, i -> {2*i, 2*i+1, if i < 3 then 3 else 1});
P = fermatPeriodPolynomial(S, L1) + lam * fermatPeriodPolynomial(S, L2);
mons = fermatDeformationMonomials S;
vecOf = T -> matrix(kk, apply(mons, a -> {lift(coefficient(a, T), kk)}));
Lm = fermatFirstOrderMatrix P; La = fermatFirstOrderMatrix fermatPeriodPolynomial(S, L1); Lb = fermatFirstOrderMatrix fermatPeriodPolynomial(S, L2);
<< "tenfold, Movasati's pair, p = " << pp << ", lambda = " << lam << " : equations " << numrows Lm << " ; rank L = " << rank Lm << " ; rank [L_P1; L_P2] = " << rank(La || Lb) << endl;
T1 = Ts#0;
<< "T_1 in ker L: " << (Lm * vecOf T1 == 0) << " ; not in ker L_P1: " << (La * vecOf T1 != 0) << " ; variables x_10, x_11 absent from the arc: " << all(Ts, T -> degree(S_10, T) == 0 and degree(S_11, T) == 0) << endl;
-- the net of the part of T_1 tangent to V_Z: coefficients of f_i h_j x_(7+2k); it must have C = 0 (no x_11)
tm = cpuTime();
v = fermatVerifyArc(P, Ts);
<< "RESULT tenfold: fermatVerifyArc on " << #Ts << " terms: pass " << v#"pass" << " ; first failing order " << toString v#"firstFailingOrder" << " ; forms " << numrows Lm << " ; cpu " << cpuTime() - tm << endl;
-- control: the same arc with the class [P1] + [P2] (the topological coefficient) must fail
Pc = fermatPeriodPolynomial(S, L1) + fermatPeriodPolynomial(S, L2);
vc = fermatVerifyArc(Pc, take(Ts, min(#Ts, 5)));
<< "RESULT control, class [P1] + [P2], first " << min(#Ts, 5) << " terms: pass " << vc#"pass" << " ; first failing order " << toString vc#"firstFailingOrder" << endl;
<< "DONE" << endl;
