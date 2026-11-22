-- VALIDATION TEST 13
-- Source:    THE SESSION'S OWN RESULTS (AI-produced, unreviewed): discovery/LEDGER_DISCOVERY.md, entries [CHECK C12],
--            [CHECK C13], [CHECK C15]; discovery/END_OF_ROUND_REPORT.md. SOURCES.md entry E7.
--            Those checks were made with Singular at primes 32003, 30011, 1000003; here: Macaulay2, new random instances.
-- Statement: first-order tangent codimension of the Hodge locus of the class of an explicit subvariety:
--            (C13) cubic sixfolds F = det A + det B (A, B 3x3 matrices of linear forms), T = {rows 1,2 of A proportional}
--                  n {rows 1,2 of B proportional} (degree 9 threefold):                                   codimension 8;
--            (C15a) cubic sixfolds F = l Q + Pf(M) (M 6x6 skew), T5 = {l = 0} n {4x4 Pfaffians of a 5x5 block}
--                  (degree 5 threefold):                                                                   codimension 7;
--            (C12) cubic eightfolds through a Segre fourfold {x_9 = 0, rank N <= 1}: 27 conditions to contain it,
--                  tangent codimension 26 for the Hodge locus of its class; Hilbert function of S/(I+J): 1,9,26,27,9,1,0;
--            (C15c) cubic eightfolds F = l Q + det A + det B, T' = {l = 0} n {rows 1,2 of A prop.} n {rows 1,2 of B prop.}
--                  (degree 9 fourfold): codimension 26; Hilbert function of S/(I+J): 1,9,29,26,9,1,0.
-- Computed:  hodgeLocusTangentCodim(F, I)#"codim" (rank of the pairing of (S/(I+J))_3 with (S/(I+J))_e into the
--            one-dimensional top degree), plus supporting Hilbert functions with plain Macaulay2.
-- Label:     MOD p (32003), one random instance per family. COMPUTED ONLY (no proof claimed for these numbers).
-- Expected:  8, 7, 27 and 26, 26 as recorded in the ledger entries.
load (currentFileDirectory | "common.m2")
kk = ZZ/32003;
hf = (I, r) -> apply(r, i -> hilbertFunction(i, I));

-- C13: sums of two determinants
setRandomSeed 1313;
S = kk[x_0..x_7];
A = random(S^3, S^{3:-1}); B = random(S^3, S^{3:-1});
F = det A + det B;
IT = minors(2, A^{0,1}) + minors(2, B^{0,1});
t = hodgeLocusTangentCodim(F, IT);
J = ideal jacobian matrix{{F}};
expect("C13: T has dimension 3 and degree 9", {dim IT - 1, degree IT}, {3, 9});
expect("C13: codim (I_T + J)_3 and (I_T + J)_4", {hilbertFunction(3, IT + J), t#"codimIJ"}, {13, 1});
expect("C13: tangent codimension of the Hodge locus of [T]", t#"codim", 8);
expect("C13: codimension of the cubics in the ideal of all 2x2 minors of A and B (tangent space of the family)",
    hilbertFunction(3, minors(2, A) + minors(2, B)), 8);

-- C15(a): l Q + Pfaffian
setRandomSeed 1515;
Mk = random(S^6, S^{6:-1}); Mk = Mk - transpose Mk;
l = random(1, S); Q = random(2, S);
F = l*Q + (gens pfaffians(6, Mk))_(0,0);
I5 = ideal(l) + pfaffians(4, submatrix(Mk, {0,1,2,3,4}, {0,1,2,3,4}));
t = hodgeLocusTangentCodim(F, I5);
expect("C15a: T5 has dimension 3 and degree 5", {dim I5 - 1, degree I5}, {3, 5});
expect("C15a: tangent codimension of the Hodge locus of [T5]; codim (I+J)_4", {t#"codim", t#"codimIJ"}, {7, 1});
expect("C15a: codimension of the family tangent space l S_2 + Q S_1 + (4x4 Pfaffians)_3",
    hilbertFunction(3, ideal(l, Q) + pfaffians(4, Mk)), 7);

-- C12: Segre fourfold in a cubic eightfold
setRandomSeed 1212;
S = kk[x_0..x_9];
N = genericMatrix(S, 3, 3);
I = ideal(S_9) + minors(2, N);
F = S_9 * random(2, S) + sum(flatten entries gens minors(2, N), m -> random(1, S) * m);
t = hodgeLocusTangentCodim(F, I);
J = ideal jacobian matrix{{F}};
expect("C12: Hilbert function of S/(I+J) in degrees 0..6", hf(I + J, 7), {1, 9, 26, 27, 9, 1, 0});
expect("C12: tangent codimension of the Hodge locus of the Segre class (27 conditions to contain the Segre fourfold)",
    {t#"codim", hilbertFunction(3, I + J)}, {26, 27});

-- C15(c): l Q + det A + det B
setRandomSeed 1516;
A = random(S^3, S^{3:-1}); B = random(S^3, S^{3:-1});
l = random(1, S); Q = random(2, S);
F = l*Q + det A + det B;
IT = ideal(l) + minors(2, A^{0,1}) + minors(2, B^{0,1});
t = hodgeLocusTangentCodim(F, IT);
J = ideal jacobian matrix{{F}};
expect("C15c: T' has dimension 4 and degree 9", {dim IT - 1, degree IT}, {4, 9});
expect("C15c: Hilbert function of S/(I(T')+J) in degrees 0..6", hf(IT + J, 7), {1, 9, 29, 26, 9, 1, 0});
expect("C15c: tangent codimension of the Hodge locus of [T']", t#"codim", 26);
expect("C15c: codimension of the family tangent space", hilbertFunction(3, ideal(l, Q) + minors(2, A) + minors(2, B)), 26);
expect("label says MOD p", match("MOD p", t#"label"), true);
finish()
