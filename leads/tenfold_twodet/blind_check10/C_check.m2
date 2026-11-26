-- Claim C: random instance over ZZ/32003, own code (no package).
pr = s -> (stdio << s << endl << flush;);
sd = if #scriptCommandLine > 1 then value scriptCommandLine#1 else 1;
setRandomSeed sd;
kk = ZZ/32003;
S = kk[x_0..x_11];
lin8 = () -> sum(8, i -> random(kk) * x_i);
A = matrix table(3, 3, (i,j) -> lin8());
B = matrix table(3, 3, (i,j) -> lin8());
Q1 = random(2, S); Q2 = random(2, S);
F = x_10*Q1 + x_11*Q2 + det A + det B;
pr("seed " | toString sd | "; F has " | toString(#terms F) | " terms; variables in A,B: " | toString sort unique apply(support(ideal A + ideal B), index));
tm = () -> toString cpuTime();
I = ideal(x_10, x_11, Q1, Q2) + minors(2, A) + minors(2, B);
J = ideal jacobian matrix{{F}};
pr("J contained in I: " | toString isSubset(J, I));
hf = apply(9, d -> hilbertFunction(d, S/I));
pr("Hilbert function of S/I, degrees 0..8: " | toString hf | "; equals 1,10,35,52,35,10,1,0,0: " | toString(hf == {1,10,35,52,35,10,1,0,0}));
-- socle
m = ideal vars S;
soc = (I : m);
socdims = apply(8, d -> hilbertFunction(d, I) - hilbertFunction(d, soc));   -- hilbertFunction(d, ideal) is that of the quotient
pr("dimension of socle ((I:m)/I) in degrees 0..7: " | toString socdims | "   [t=" | tm() | "]");
-- the scheme (x10, x11) + minors
K1 = ideal(x_10, x_11) + minors(2, A) + minors(2, B);
pr("scheme V(x10,x11,I_2(A),I_2(B)): projective dim " | toString(dim K1 - 1) | ", degree " | toString degree K1);
lineIdeal = ideal(x_0,x_1,x_2,x_3,x_4,x_5,x_6,x_7,x_10,x_11);
pr("    V(K1) lies in the line x0=..=x7=x10=x11=0 because x10, x11 and all x_i^5 (i<8) are in K1: " | toString all(8, i -> (x_i)^5 % K1 == 0));
S8 = kk[x_0..x_7];
K8 = sub(minors(2,A) + minors(2,B), S8);
pr("    k[x0..x7]/(I_2(A)+I_2(B)): Hilbert function " | toString apply(6, d -> hilbertFunction(d, S8/K8)) | ", length " | toString degree K8);
pr("    Q1,Q2 restricted to the line (x8,x9): resultant-type check, dim of (lineIdeal + (Q1,Q2)) = " | toString dim(lineIdeal + ideal(Q1,Q2)) | " (0 means no common zero on the line)");
-- pieces of the structure used in claim D
IA = minors(2, A); IB = minors(2, B);
pr("codim I_2(A), I_2(B) in k[x0..x7]: " | toString{codim sub(IA,S8), codim sub(IB,S8)});
-- the fivefold T5 and the ideal J + I(T5)
T5 = ideal(x_10, x_11) + minors(2, A^{0,1}) + minors(2, B^{0,1});
pr("T5: projective dim " | toString(dim T5 - 1) | ", degree " | toString degree T5 | ", F in I(T5): " | toString(F % T5 == 0));
IJ = T5 + J;
pr("Hilbert function of S/(I(T5)+J), degrees 0..8: " | toString apply(9, d -> hilbertFunction(d, S/IJ)) | "   [t=" | tm() | "]");
-- sum over the variants (rows i,j / columns i,j) of I(T) + J equals I ?
rowsOf = M -> apply({{0,1},{0,2},{1,2}}, p -> minors(2, M^p));
colsOf = M -> apply({{0,1},{0,2},{1,2}}, p -> minors(2, M_p));
pr("I_2(A) is the sum of the row-pair ideals: " | toString(sum rowsOf A == IA) | "; (x10,x11,I_2(A),I_2(B)) + J == I: " | toString(ideal(x_10,x_11) + IA + IB + J == I));
-- smoothness of F: Sing(X) = V(J).
--   (a) standard engine: no singular point with x10 = x11 = 0;
--   (b) whole Jacobian ideal: Groebner basis by M2's F4 engine, dim of the initial ideal, Hilbert function.
t0 = cpuTime();
sa = J + ideal(x_10, x_11);
pr("smoothness (a): dim of V(J + (x10,x11)) (affine cone) = " | toString dim sa | " (0 means empty in P^11)   [" | toString(cpuTime() - t0) | " s]");
t0 = cpuTime();
G4 = groebnerBasis(J, Strategy => "F4");
pr("smoothness (b): F4 basis of J: " | toString numcols G4 | " elements   [" | toString(cpuTime() - t0) | " s]");
L4 = ideal leadTerm G4;
pr("               dim of the initial ideal (affine) = " | toString dim L4 | " => F smooth: " | toString(dim L4 == 0));
hJ = apply(14, d -> hilbertFunction(d, L4));
pr("               Hilbert function of S/J: " | toString hJ | "; equals binomial(12,d): " | toString(hJ == apply(14, d -> binomial(12,d))));
pr("               generators of J reduce to 0 modulo the F4 basis: " | toString((gens J) % (forceGB G4) == 0));
pr("               (independent engine: Singular, Hilbert-driven std, see C_singular_<seed>.out; M2's MGB and M2's standard gb did not finish in 4 and 9 minutes)");
-- Gorenstein duality check: the multiplication pairing (S/I)_3 x (S/I)_3 -> (S/I)_6 is perfect
Rq = S/I;
b3 = basis(3, Rq); b6 = basis(6, Rq);
prod33 = (transpose b3) * b3;
G = matrix apply(numcols b3, i -> apply(numcols b3, j -> (
    c := (coefficients(matrix{{prod33_(i,j)}}, Monomials => b6))#1;
    lift(c_(0,0), kk))));
pr("rank of the pairing (S/I)_3 x (S/I)_3 -> (S/I)_6 = k: " | toString rank G | " of " | toString numcols b3);
pr("total time " | tm());
