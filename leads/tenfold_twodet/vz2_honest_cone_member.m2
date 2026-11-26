-- vz2: an honest cone member of the tenfold two-determinant family (PREREG_vz.md, prediction P3).   MOD p.
-- F = x_10 Q1 + x_11 Q2 + det A + det B with A, B random 3 x 3 matrices of linear forms in x_0..x_7 only
-- (so {x_10 = x_11 = 0} n X is the cone over a sixfold det A + det B with vertex the line x_0 = ... = x_7 = 0).
-- usage (from the repository root):  M2 --script leads/tenfold_twodet/vz2_honest_cone_member.m2 p seed
needsPackage("HodgeLociCI", FileName => "M2/HodgeLociCI.m2");
pp = value(scriptCommandLine#1); sd = value(scriptCommandLine#2); kk = ZZ/pp; setRandomSeed sd;
S = kk[x_0..x_11]; tm = cpuTime();
S6 = kk[y_0..y_7]; toS = map(S, S6, apply(8, i -> S_i));
A = toS random(S6^3, S6^{3:-1}); B = toS random(S6^3, S6^{3:-1}); Q1 = random(2, S); Q2 = random(2, S);
F = x_10 * Q1 + x_11 * Q2 + det A + det B;
IT = ideal(x_10, x_11) + minors(2, A^{0,1}) + minors(2, B^{0,1});
I = ideal(x_10, x_11, Q1, Q2) + minors(2, A) + minors(2, B);
J = ideal jacobian matrix{{F}};
hf = (I, r) -> apply(r, i -> hilbertFunction(i, I));
<< "T5 (cone over T): dimension " << dim IT - 1 << ", degree " << degree IT << " ; contained in X: " << (F % IT == 0) << endl << flush;
<< "RESULT Hilbert function of S / (l_1, l_2, Q_1, Q_2, I_2(A), I_2(B)), degrees 0..7: " << toString hf(I, 8) << " ; J inside it: " << isSubset(J, I) << endl << flush;
<< "RESULT Hilbert function of S / (I(T5) + J), degrees 0..7: " << toString hf(IT + J, 8) << endl << flush;
-- the rank <= 1 loci: empty in P^7 (the sixfold is smooth), so in the P^9 only the vertex line, with multiplicity
ID = ideal(x_10, x_11) + minors(2, A) + minors(2, B);
<< "singular scheme of the P^9-section inside the two rank <= 1 loci: dimension " << dim ID - 1 << ", degree " << degree ID
   << " ; its radical is the vertex line: " << (radical ID == ideal(toList(x_0..x_7) | {x_10, x_11})) << " ; cpu " << cpuTime() - tm << endl << flush;
t = hodgeLocusTangentCodim(F, IT, CheckSmooth => true);
<< "RESULT package, hodgeLocusTangentCodim(F, I(T5)): codim " << toString t#"codim" << " ; smooth: " << toString t#"smooth" << " ; " << toString t#"label" << " ; cpu " << cpuTime() - tm << endl;
<< "DONE p " << pp << " seed " << sd << endl;
