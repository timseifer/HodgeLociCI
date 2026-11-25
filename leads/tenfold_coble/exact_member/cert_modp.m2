-- Certificate, the MOD p part: (X1) smoothness, (X3) the Jacobian scheme of the hyperplane section, and the mod p versions of (X2), (X4), (X5).
-- Pre-registration and the specialization arguments: PREREG_exact.md.   usage: M2 --script cert_modp.m2 p [twist]
-- (X1) and (X3) use the F4 engine (groebnerBasis, Strategy => "F4"); with a second argument the coordinates are first changed by a random
-- element of GL_12 (a different computation with the same answer).
pp = value(scriptCommandLine#1); twist = (#scriptCommandLine > 2);
kk = ZZ/pp; load "member.m2";
setRandomSeed(if twist then value(scriptCommandLine#2) else 0);
Fx = if twist then (map(S, S, (vars S) * random(kk^12, kk^12))) F else F;
tm = cpuTime();
J = ideal jacobian matrix{{Fx}};
G = groebnerBasis(J, Strategy => "F4"); LT = ideal leadTerm G;
<< "p = " << pp << (if twist then " (random linear change of coordinates)" else "") << endl;
<< "(X1) Jacobian ideal of F, 12 variables: projective dim of the zero set = " << dim LT - 1 << " (-1 = smooth) ; Hilbert function of S/in(J), d = 0..13: "
   << apply(toList(0..13), d -> hilbertFunction(d, S/LT)) << " ; cpu " << cpuTime() - tm << endl << flush;
if not twist then (
    S11 = kk[z_0..z_2, p_0..p_2, q_0..q_2, w_0, w_1];
    r = map(S11, S, {z_0,z_1,z_2,p_0,p_1,p_2,q_0,q_1,q_2,w_0,w_1,0});
    Jp = ideal jacobian matrix{{r F}};
    Gp = groebnerBasis(Jp, Strategy => "F4"); LTp = ideal leadTerm Gp;
    Gq = groebnerBasis(Jp + ideal(w_0, w_1), Strategy => "F4"); LTq = ideal leadTerm Gq;
    << "(X3) Jacobian scheme of F|_{w_2=0} in P^10: projective dim " << dim LTp - 1 << " ; degree " << degree LTp << " ; with w_0 = w_1 = 0: degree " << degree LTq << " ; cpu " << cpuTime() - tm << endl << flush;
    R = kk[z_0..z_2, p_0..p_2, q_0..q_2];
    toR = map(R, S, {z_0,z_1,z_2,p_0,p_1,p_2,q_0,q_1,q_2,0,0,0});
    J8 = ideal jacobian matrix{{toR F8}}; Ph = {toR Phi0, toR Phi1, toR Phi2};
    Sg = J8 + ideal(Ph#0, Ph#1);
    T = kk[u, v];
    l1 = z_0 + 2*z_1 - z_2 + 3*p_0 - 2*p_1 + p_2 + 2*q_0 - q_1 + 3*q_2;
    l2 = 2*z_0 - z_1 + 3*z_2 + p_0 + p_1 - 2*p_2 - q_0 + 2*q_1 + q_2;
    g = (ker map(R/Sg, T, {sub(l1, R/Sg), sub(l2, R/Sg)}))_0;
    << "(X2) Sigma: projective dim " << dim Sg - 1 << " ; degree " << degree Sg << " ; projection to the fixed line: degree " << first degree g << " ; squarefree: " << (first degree gcd(g, diff(T_0, g)) == 0) << endl << flush;
    << "(X5) Sigma ∩ {Phi2 = 0}: projective dim " << dim(Sg + ideal(Ph#2)) - 1 << " (-1 = empty)" << endl;
    Ss = saturate Sg;
    << "(X4) Hilbert function of Sigma (saturated), d = 0..6: " << apply(toList(0..6), d -> hilbertFunction(d, R/Ss)) << " ; cpu " << cpuTime() - tm << endl << flush;);
