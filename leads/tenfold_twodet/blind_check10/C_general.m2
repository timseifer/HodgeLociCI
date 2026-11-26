-- Bonus for claims C/D: a random member of the BIG family (A, B in all 12 variables), over ZZ/32003. Own code.
pr = s -> (stdio << s << endl << flush;);
sd = if #scriptCommandLine > 1 then value scriptCommandLine#1 else 1;
setRandomSeed sd;
kk = ZZ/32003;
S = kk[x_0..x_11];
A = random(S^3, S^{3:-1}); B = random(S^3, S^{3:-1});
Q1 = random(2, S); Q2 = random(2, S);
F = x_10*Q1 + x_11*Q2 + det A + det B;
pr("seed " | toString sd | "; variables in A,B: " | toString sort unique apply(support(ideal A + ideal B), index));
I = ideal(x_10, x_11, Q1, Q2) + minors(2, A) + minors(2, B);
J = ideal jacobian matrix{{F}};
pr("J in I: " | toString isSubset(J, I) | "; Hilbert function of S/I: " | toString apply(9, d -> hilbertFunction(d, S/I)));
m = ideal vars S;
pr("socle dimensions of S/I in degrees 0..7: " | toString apply(8, d -> hilbertFunction(d, I) - hilbertFunction(d, I : m)));
K1 = ideal(x_10, x_11) + minors(2, A) + minors(2, B);
pr("curve V(x10,x11,I_2(A),I_2(B)): projective dim " | toString(dim K1 - 1) | ", degree " | toString degree K1 | ", genus " | toString genus K1);
T5 = ideal(x_10, x_11) + minors(2, A^{0,1}) + minors(2, B^{0,1});
pr("T5: projective dim " | toString(dim T5 - 1) | ", degree " | toString degree T5 | ", F in I(T5): " | toString(F % T5 == 0));
IJ = T5 + J;
pr("Hilbert function of S/(I(T5)+J): " | toString apply(9, d -> hilbertFunction(d, S/IJ)) | "  (value 1 in degree 6 means: the functional of [T5]_prim, if nonzero, is the socle functional of S/I)");
pr("(x10,x11,I_2(A),I_2(B)) + J == I: " | toString(ideal(x_10,x_11) + minors(2,A) + minors(2,B) + J == I));
t0 = cpuTime();
G4 = groebnerBasis(J, Strategy => "F4");
L4 = ideal leadTerm G4;
pr("smoothness (F4): dim of initial ideal of J = " | toString dim L4 | "; Hilbert function " | toString apply(14, d -> hilbertFunction(d, L4)) | "   [" | toString(cpuTime() - t0) | " s]");
-- singular locus of T5 (expected: two curves, where rows 1,2 of A resp. of B vanish)
vA = ideal(x_10, x_11) + ideal(A^{0,1}) + minors(2, B^{0,1});
pr("locus {l=0, rows 1,2 of A zero, rows 1,2 of B dependent} inside T5: projective dim " | toString(dim vA - 1) | ", degree " | toString degree vA);
