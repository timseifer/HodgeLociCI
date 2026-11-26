-- R16 of PREREG_pairing.md (section 15): cubic tenfolds l_1 Q_1 + l_2 Q_2 + det A + det B.   AI-written, unreviewed.
-- usage (from this folder):  M2 --script pr16_tenfold_twodet.m2 p seed        MOD p.   Uses tooling/node_section/NodeSection.m2.
load "../../../tooling/node_section/NodeSection.m2";
pp = value(scriptCommandLine#1); sd = value(scriptCommandLine#2); kk = ZZ/pp; setRandomSeed sd;
R = kk[x_0..x_11];
A = matrix table(3, 3, (i,j) -> random(1, R)); B = matrix table(3, 3, (i,j) -> random(1, R));
Q1 = random(2, R); Q2 = random(2, R);
F = x_10 * Q1 + x_11 * Q2 + det A + det B;
ID = ideal(x_10, x_11) + minors(2, A) + minors(2, B);
<< "(a) the two rank <= 1 loci in the P^9: dimension " << dim ID - 1 << ", degree " << degree ID << ", genus " << genus ID << endl << flush;
I = ideal(x_10, x_11, Q1, Q2) + minors(2, A) + minors(2, B);
<< "(c) Hilbert function of S / (l_1, l_2, Q_1, Q_2, I_2(A), I_2(B)), degrees 0..7: " << toString apply(8, d -> hilbertFunction(d, R/I)) << endl << flush;
B3 = basis(3, R);
tg = (flatten entries (x_10 * basis(2, R))) | (flatten entries (x_11 * basis(2, R))) | (flatten entries (Q1 * vars R)) | (flatten entries (Q2 * vars R)) | (flatten entries super basis(3, minors(2, A))) | (flatten entries super basis(3, minors(2, B)));
rk = rank lift(last coefficients(matrix{tg}, Monomials => B3), kk);
jac = rank lift(last coefficients(matrix{tg | flatten apply(12, i -> apply(12, j -> R_i * diff(R_j, F)))}, Monomials => B3), kk);
<< "    tangent space of the family: dimension " << rk << " of " << numColumns B3 << ", codimension " << numColumns B3 - rk << " ; it contains the Jacobian ideal in degree 3: " << (jac == rk) << endl << flush;
r = nodalSectionReport(F, x_11);
<< "(b) hyperplane section x_11 = 0: " << toString r << endl;
<< "DONE p " << pp << " seed " << sd << endl;
