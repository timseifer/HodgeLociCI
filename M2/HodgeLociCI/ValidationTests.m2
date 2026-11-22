-- HodgeLociCI/ValidationTests.m2  (owner: agent PC)
-- TEST blocks of the validation suite: a fast subset of tests/validation/*.m2 (see tests/SOURCES.md for the sources,
-- tests/README.md for the full table). Every block states: source, statement, what is computed, label, expected value.
-- "Read by machine only": the cited papers were read through a web-fetch tool by an AI agent; no human has checked
-- the transcription of the numbers. "Session": a result of the AI research session, unreviewed.
-- Labels: EXACT (integers, QQ or a cyclotomic field), MOD p (one instance modulo a prime: evidence, not proof).

-- PC-V1 ------------------------------------------------------------------------------------------------------
-- Source:    H. Movasati, arXiv:1602.06607, Section 6, Theorem 12 and Table 1 (entries K_n^3(m)) and the tuples
--            (n,d,m | H,K) of the text; arXiv:1902.00831, Tables 1, 2 (row dim(S)). Read by machine only.
-- Statement: K = codimension of the locus of hypersurfaces containing two linear P^(n/2) meeting in P^m; for cubics
--            the table below (rows n = 4..12, columns n/2-m = 1..); in particular 8 (sixfold, m = 0), 20 (eightfold, m = 1).
-- Computed:  excessFromDegrees(...)#"codimVZ" (Hilbert functions of complete intersections).
-- Label:     EXACT (integer arithmetic on the degrees). Expected values: the published table.
TEST ///
ones = n -> toList(n : 1);
K = (d, k, c) -> (excessFromDegrees(d, ones c, ones c, ones(k+1-c)))#"codimVZ";
published = new HashTable from {2 => {2,2,2}, 3 => {7,8,8,8}, 4 => {16,19,20,20,20}, 5 => {30,36,39,40,40,40}, 6 => {50,60,66,69,70,70,70}};
for k in {2,3,4,5,6} do assert(apply(toList(1..k+1), c -> K(3, k, c)) == published#k);
assert(K(3,3,3) == 8 and K(3,4,3) == 20);
-- tuples (n,d,m | K): (4,4,0|12), (4,4,-1|12), (4,5,0|24), (4,5,-1|24), (4,6,0|38), (4,6,-1|38), (6,4,1|37), (6,4,0|38), (6,4,-1|38), (4,7,0|54)
assert({K(4,2,2), K(4,2,3), K(5,2,2), K(5,2,3), K(6,2,2), K(6,2,3), K(4,3,2), K(4,3,3), K(4,3,4), K(7,2,2)} == {12,12,24,24,38,38,37,38,38,54});
///

-- PC-V2 ------------------------------------------------------------------------------------------------------
-- Source:    R. Kloosterman, arXiv:2312.12363, Proposition 3.10; R. Villaflor Loyola, arXiv:2001.01019, Theorem 1.1 (the
--            number binomial(n/2+d,d) - (n/2+1)^2); H. Movasati, arXiv:1602.06607, Section 4 (table of codimensions of loci
--            of complete intersections in sextic fourfolds) and Section 6 (T_(1,1,2) has codimension 8 for quartic
--            fourfolds). Read by machine only.
-- Statement: codim T NL([Pi_1],[Pi_2]) = 2 binomial(k+d,k) - binomial(k-c+d,k-c) - (k+1)^2 - 2c(k+1) + c^2.
-- Computed:  excessFromDegrees "codimVZ", "codimV1"; ciHilbertFunction. Label: EXACT. Expected: the published formulas.
TEST ///
ones = n -> toList(n : 1);
for d from 3 to 7 do for k from 1 to 6 do for c from 1 to k+1 do (
    t := excessFromDegrees(d, ones c, ones c, ones(k+1-c));
    assert(t#"codimVZ" == 2*binomial(k+d,k) - (if k >= c then binomial(k-c+d,k-c) else 0) - (k+1)^2 - 2*c*(k+1) + c^2);
    assert(t#"codimV1" == binomial(k+d,d) - (k+1)^2);
    );
sextic = {({1,1,1},19), ({1,1,2},32), ({1,1,3},37), ({1,2,2},54), ({1,2,3},62), ({1,3,3},71), ({2,2,2},92), ({2,2,3},106), ({2,3,3},122), ({3,3,3},141)};
assert all(sextic, t -> ciHilbertFunction(t#0 | apply(t#0, a -> 6 - a), 6, 6) == t#1);
assert((excessFromDegrees(4, {1}, {1}, {1,2}))#"codimV1" == 8);
///

-- PC-V3 ------------------------------------------------------------------------------------------------------
-- Source:    H. Movasati, arXiv:1602.06607, Table 1: (H,K) = (6,8), (7,8) for cubic sixfolds, n/2-m = 2, 3;
--            arXiv:1902.00831, Tables 1, 2 (codim(V^1) = 6, 7 for all coefficients 1 <= |r|,|r'| <= 10);
--            arXiv:2211.11405, Proposition 21 (dim T_0 V_[Z] = dim T_0 V_Z + 1 for m = n/2-3). Read by machine only.
-- Statement: at the Fermat cubic sixfold the Zariski tangent space of the Hodge locus of r[P] + r'[P'] has
--            codimension 7 when the two 3-planes meet in a point ("8 -> 7") and 6 when they meet in a line.
-- Computed:  fermatTangentData over Q(zeta_6), planes x_(2i) = z x_(2i+1) and x_(2i) = z^3 x_(2i+1) (i < c).
-- Label:     EXACT. Expected: the published pairs.
TEST ///
S = fermatRing(3, 6);
sp = c -> (apply(4, i -> {2*i, 2*i+1, 1}), apply(4, i -> {2*i, 2*i+1, if i < c then 3 else 1}));
for cH in {(3, 7), (2, 6)} do (
    (c, H) := cH;
    (L1, L2) := sp c;
    for rr in {{1,1}, {1,-1}, {3,-5}} do (
        t := fermatTangentData(S, {L1, L2}, rr);
        assert(t#"jointPersistenceCodimension" == 8 and t#"hodgeCodimension" == H);
        );
    );
///

-- PC-V4 ------------------------------------------------------------------------------------------------------
-- Source:    R. Kloosterman, arXiv:2312.12363, Theorem 1.3 (strict inclusion of tangent spaces for d = 3, c in {2,3},
--            k in {2,3,4} and d = 4, c = 2, k in {1,2}, every X, every nonzero lambda) and Theorem 1.5 (no first-order
--            excess when sum(e_i + d_i) < (c-1)d); H. Movasati, R. Villaflor Loyola, arXiv:1705.00084, Theorem 2 (triples
--            (6,3,-1), (4,4,-1), (2,5,-1)); R. Villaflor Loyola, arXiv:1812.03964, Theorem 3. Read by machine only.
-- Statement: the level dichotomy: tau >= 0 gives excess >= 1; tau < 0 gives excess 0.
-- Computed:  tangentExcess (direct linear algebra in the Jacobian ring) at random instances modulo 32003.
-- Label:     MOD p, one instance per type. Expected: >= 1, resp. 0 (published).
TEST ///
ones = n -> toList(n : 1);
for dkc in {(3,2,2), (3,2,3), (3,3,2), (3,3,3), (4,1,2), (4,2,2)} do (
    (d, k, c) := dkc;
    D := randomCyclePair(d, ones c, ones c, ones(k+1-c), Seed => 41);
    assert all({1, -1, 2, 5/3}, l -> (tangentExcess(D, l))#"excess" >= 1);
    );
for dkc in {(3,3,4), (4,2,3), (5,1,2)} do (
    (d, k, c) := dkc;
    assert((excessFromDegrees(d, ones c, ones c, ones(k+1-c)))#"tau" < 0);
    D := randomCyclePair(d, ones c, ones c, ones(k+1-c), Seed => 42);
    assert all({1, -1, 2}, l -> (tangentExcess(D, l))#"excess" == 0);
    );
D = randomCyclePair(4, {1,1,1}, {1,1,2}, {}, Seed => 43);      -- a non-linear type with tau = -1
assert(D#"tau" == -1 and all({1, -1, 2}, l -> (tangentExcess(D, l))#"excess" == 0));
///

-- PC-V5 ------------------------------------------------------------------------------------------------------
-- Source:    C. Maclean, Asian J. Math. 9 (2005) [journal article NOT opened; read: the author's thesis (Paris 6, 2003),
--            Theorem 24 and Proposition 9, and the secondary description in A. Dan, arXiv:1407.8491, Theorem 1.3].
-- Statement: for a quintic surface with two coplanar lines L_1, L_2 and distinct nonzero integers a, b, the
--            Noether-Lefschetz locus of a[L_1] + b[L_2] is non-reduced: reduction of codimension 2d-6 = 4, Zariski
--            tangent space of codimension < 4.
-- Computed:  k = 1, c = 1 (shared equation = the plane), lambda = b/a: codimVZ; tangentExcess; secondOrderObstruction.
-- Label:     MOD p, one instance (the published statement is for every such quintic).
-- Expected:  4; tangent codimension 3; "ALL DIE" for lambda != 1 and "ALL SURVIVE" at lambda = 1 (a = b).
TEST ///
assert(apply({5,6,7}, d -> (excessFromDegrees(d, {1}, {1}, {1}))#"codimVZ") == {4, 6, 8});
D = randomCyclePair(5, {1}, {1}, {1}, Seed => 51);
for l in {2, -1, 1/2} do (
    te := tangentExcess(D, l);
    assert(te#"codimTVZ" == 4 and te#"codimTNL" == 3);
    assert((secondOrderObstruction(D, l))#"verdict" == "ALL DIE");
    );
assert((secondOrderObstruction(D, 1))#"verdict" == "ALL SURVIVE");
///

-- PC-V6 ------------------------------------------------------------------------------------------------------
-- Source:    SESSION (AI-produced, unreviewed): paper 3, Theorem 9.7 ("thm:lin") and its Table 1; night/CHECKS_R2.md,
--            test T3 (excess at lambda_0).
-- Statement: for (d,k,c) = (3,3,1), (3,3,2), (3,3,3), (4,2,1), (4,2,2) the first-order excess at lambda not in
--            {0, lambda_0} is e = 2, 2, 1, 2, 1 at a general point, and 3, 2, 1, 3, 1 at lambda_0; outside the list it is 0.
-- Computed:  tangentExcess at random instances modulo 32003; linearSubspaceCase for the classification.
-- Label:     MOD p. Status: PROVED in an AI-written, unreviewed paper. Expected: the table of paper 3.
TEST ///
ones = n -> toList(n : 1);
for r in {(3,3,1,2,3), (3,3,2,2,2), (3,3,3,1,1), (4,2,1,2,3), (4,2,2,1,1)} do (
    (d, k, c, e, e0) := r;
    D := randomCyclePair(d, ones c, ones c, ones(k+1-c), Seed => 61);
    l0 := D#"lambda0";
    assert(l0 == (-1)^(c-1) and (linearSubspaceCase(d, k, c))#"genericExcessElsewhere" == e);
    assert(apply({2, -2, -l0, l0}, l -> (tangentExcess(D, l))#"excess") == {e, e, e, e0});
    );
assert((linearSubspaceCase(3, 3, 4))#"case" == "tau < 0" and (linearSubspaceCase(3, 5, 3))#"genericExcessElsewhere" == 0);
///

-- PC-V7 ------------------------------------------------------------------------------------------------------
-- Source:    SESSION (AI-produced, unreviewed): discovery/LEDGER_DISCOVERY.md, entries [CHECK C13] and [CHECK C15](a)
--            (Singular, three primes); here Macaulay2 at new random instances.
-- Statement: cubic sixfolds F = det A + det B: the Hodge locus of the class of the degree-9 threefold
--            {rows 1,2 of A proportional} n {rows 1,2 of B proportional} has tangent codimension 8;
--            cubic sixfolds F = l Q + Pf(M): the Hodge locus of the class of the quintic threefold
--            {l = 0} n {4x4 Pfaffians of a 5x5 principal block} has tangent codimension 7.
-- Computed:  hodgeLocusTangentCodim(F, I)#"codim". Label: MOD p, one instance each. COMPUTED ONLY. Expected: 8, 7.
TEST ///
kk = ZZ/32003; S = kk[x_0..x_7];
setRandomSeed 71;
A = random(S^3, S^{3:-1}); B = random(S^3, S^{3:-1});
F = det A + det B;
IT = minors(2, A^{0,1}) + minors(2, B^{0,1});
t = hodgeLocusTangentCodim(F, IT);
assert(dim IT == 4 and degree IT == 9 and t#"codimIJ" == 1 and t#"codim" == 8);
assert(hilbertFunction(3, minors(2, A) + minors(2, B)) == 8);
setRandomSeed 72;
M = random(S^6, S^{6:-1}); M = M - transpose M;
l = random(1, S); Q = random(2, S);
F = l*Q + (gens pfaffians(6, M))_(0,0);
I5 = ideal(l) + pfaffians(4, submatrix(M, {0,1,2,3,4}, {0,1,2,3,4}));
t = hodgeLocusTangentCodim(F, I5);
assert(dim I5 == 4 and degree I5 == 5 and t#"codimIJ" == 1 and t#"codim" == 7);
///

-- PC-V8 ------------------------------------------------------------------------------------------------------
-- Source:    SESSION (AI-produced, unreviewed): paper 3, Theorem 2 and the table tab:tau of its Section "Computations"
--            (rows 5, 10, 11, 12); Corollary 4.
-- Statement: (d; deg f; deg h; deg p) -> (tau, range, e_tau; excess at lambda_0 / elsewhere):
--            (5;(1);(1);(1)) -> (2, yes, 1; 1/1); (4;(1,1);(1,2);(1)) -> (1, yes, 2; 2/2);
--            (4;(1);(1);(1,1)) -> (2, no, 3; 3/2); (4;(1,1,1);(1,1,2);-) -> (-1, -, 0; 0/0).
-- Computed:  excessFromDegrees (EXACT, integers); verifyExcess at random instances (MOD p): Theorem 2 against the
--            direct first-order computation. Expected: the rows of the table.
TEST ///
rows = {(5, {1}, {1}, {1}, 2, 1, 1, 1), (4, {1,1}, {1,2}, {1}, 1, 2, 2, 2), (4, {1}, {1}, {1,1}, 2, 3, 3, 2), (4, {1,1,1}, {1,1,2}, {}, -1, 0, 0, 0)};
for r in rows do (
    (d, df, dh, dp, tau, et, e0, eE) := r;
    t := excessFromDegrees(d, df, dh, dp);
    assert(t#"tau" == tau and t#"eTau" == et);
    D := randomCyclePair(d, df, dh, dp, Seed => 81);
    l0 := D#"lambda0";
    assert(apply({l0, 2, -l0}, l -> (tangentExcess(D, l))#"excess") == {e0, eE, eE});
    assert((verifyExcess D)#"agrees");
    );
assert((excessFromDegrees(4, {1}, {1}, {1,1}))#"inRange" == false and (excessFromDegrees(4, {1,1}, {1,2}, {1}))#"inRange" == true);
///
