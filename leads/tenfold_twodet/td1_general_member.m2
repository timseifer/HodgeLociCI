-- R1 of PREREG_twodet.md: the fivefold T5 on a random tenfold l_1 Q_1 + l_2 Q_2 + det A + det B.   AI-written, unreviewed.
-- usage (from the repository root):  M2 --script leads/tenfold_twodet/td1_general_member.m2 p seed        MOD p.
needsPackage("HodgeLociCI", FileName => "M2/HodgeLociCI.m2");
pp = value(scriptCommandLine#1); sd = value(scriptCommandLine#2); kk = ZZ/pp; setRandomSeed sd;
S = kk[x_0..x_11]; tm = cpuTime();
A = random(S^3, S^{3:-1}); B = random(S^3, S^{3:-1}); Q1 = random(2, S); Q2 = random(2, S);
F = x_10 * Q1 + x_11 * Q2 + det A + det B;
IT = ideal(x_10, x_11) + minors(2, A^{0,1}) + minors(2, B^{0,1});
J = ideal jacobian matrix{{F}};
hf = (I, r) -> apply(r, i -> hilbertFunction(i, I));
<< "T5: dimension " << dim IT - 1 << ", degree " << degree IT << " ; contained in X: " << (F % IT == 0) << endl << flush;
<< "Hilbert function of S / (I(T5) + J), degrees 0..7: " << toString hf(IT + J, 8) << endl << flush;
<< "Hilbert function of S / (l_1, l_2, Q_1, Q_2, I_2(A), I_2(B)): " << toString hf(ideal(x_10, x_11, Q1, Q2) + minors(2, A) + minors(2, B), 8) << " ; cpu " << cpuTime() - tm << endl << flush;
-- the 72 nodes of the section x_11 = 0 (the two rank <= 1 loci and Q_1 in the P^9) and smoothness of T5 there:
-- a random 6 x 6 minor of the Jacobian matrix of the equations of T5, computed in the coordinate ring of the nodes
IZ = ideal(x_10, x_11, Q1) + minors(2, A) + minors(2, B);
Rz = S / IZ;
dl = det sub((random(kk^6, kk^12) * jacobian IT) * random(kk^8, kk^6), Rz);
<< "nodes: degree " << degree IZ << ", dimension " << dim IZ - 1 << " ; they lie on T5: " << isSubset(IT, IZ)
   << " ; T5 is smooth at each of them (a random 6 x 6 minor of the Jacobian matrix vanishes at none): " << (dim ideal dl == 0) << " ; cpu " << cpuTime() - tm << endl << flush;
t = hodgeLocusTangentCodim(F, IT, CheckSmooth => (#scriptCommandLine > 3));
<< "package, hodgeLocusTangentCodim(F, I(T5)): codim " << toString t#"codim" << " ; smooth: " << toString t#"smooth" << " ; " << toString t#"label" << " ; cpu " << cpuTime() - tm << endl;
<< "DONE p " << pp << " seed " << sd << endl;
