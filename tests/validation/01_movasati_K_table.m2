-- VALIDATION TEST 01
-- Source:    H. Movasati, "Why should one compute periods of algebraic cycles?", arXiv:1602.06607, Section 6,
--            Theorem 12 and Table 1 (second entries K_n^3(m)), and the tuples (n,d,m | H,K) in the text of Section 6.
--            Also: H. Movasati, "Hodge cycles for cubic hypersurfaces", arXiv:1902.00831, Tables 1, 2 (row dim(S)) and
--            Table 5 (column L); H. Movasati, "On a Hodge locus", arXiv:2211.11405, Section 4 (values at k = 3, 4).
--            SOURCES.md entries A1, A2, A3. All read by machine only.
--            Also Table 5 of arXiv:1902.00831 (columns dim(T), L, CS, M and the Hodge numbers).
-- Statement: K_n^d(m) = codimension of the locus of degree-d hypersurfaces of dimension n containing two linear
--            P^(n/2) meeting in P^m. Cubics: the K column of Table 1; e.g. K = 8 (sixfold, m = 0), 20 (eightfold, m = 1).
-- Computed:  excessFromDegrees(d, ones c, ones c, ones (k+1-c))#"codimVZ" with k = n/2, c = n/2 - m
--            (Hilbert functions of complete intersections; integer arithmetic on the degrees only).
-- Label:     EXACT (integer arithmetic). That codimVZ IS the codimension of the locus is PROVED only in paper 3
--            (AI-written, unreviewed), Theorem 2(1); the comparison with the published table is the test.
-- Expected:  the published table (entries as read by machine, twice), listed below.
load (currentFileDirectory | "common.m2")

Ktable = new HashTable from {
    4 => {1,2,2,2}, 6 => {4,7,8,8,8}, 8 => {10,16,19,20,20,20},
    10 => {20,30,36,39,40,40,40}, 12 => {35,50,60,66,69,70,70,70}};
for n in {4,6,8,10,12} do (
    k := n//2;
    got := apply(k+2, c -> if c == 0 then (excessFromDegrees(3, {1}, {1}, ones k))#"codimV1"
                            else (excessFromDegrees(3, ones c, ones c, ones(k+1-c)))#"codimVZ");
    expect("arXiv:1602.06607 Table 1, K_n^3(m), n = " | toString n | ", n/2-m = 0.." | toString(k+1), got, Ktable#n);
    );
-- tuples (n, d, m, K) from the text of Section 6 of arXiv:1602.06607
for t in {(4,4,0,12), (4,4,-1,12), (4,5,0,24), (4,5,-1,24), (4,6,0,38), (4,6,-1,38), (6,4,1,37), (6,4,0,38), (6,4,-1,38), (4,7,0,54)} do (
    (n, d, m, K) := t;
    k := n//2; c := k - m;
    expect("arXiv:1602.06607 Section 6, K for (n,d,m) = " | toString(n,d,m), (excessFromDegrees(d, ones c, ones c, ones(k+1-c)))#"codimVZ", K);
    );
-- arXiv:1902.00831: rows dim(S) of Table 1 (m = n/2-2) and Table 2 (m = n/2-3), n = 4..12
expect("arXiv:1902.00831 Table 1 row dim(S) (c = 2), n = 4..12",
    apply({2,3,4,5,6}, k -> (excessFromDegrees(3, ones 2, ones 2, ones(k-1)))#"codimVZ"), {2,8,19,36,60});
expect("arXiv:1902.00831 Table 2 row dim(S) (c = 3), n = 4..12",
    apply({2,3,4,5,6}, k -> (excessFromDegrees(3, ones 3, ones 3, ones(k-2)))#"codimVZ"), {2,8,20,39,66});
-- arXiv:1902.00831 Table 5 = arXiv:2211.11405 Table 1, column L (cubics containing a linear P^(n/2)), n = 4..12
expect("arXiv:1902.00831 Table 5 column L, n = 4..12",
    apply({2,3,4,5,6}, k -> (excessFromDegrees(3, {1}, {1}, ones k))#"codimV1"), {1,4,10,20,35});
-- arXiv:2211.11405 Section 4: (1/6)k^3 + (3/2)k^2 - (14/3)k + 4 for d = 3, m = n/2-3 (the numbers 8, 20 are its values at k = 3, 4)
expect("arXiv:2211.11405 Section 4 closed formula against codimVZ, k = 3..8",
    apply(toList(3..8), k -> (excessFromDegrees(3, ones 3, ones 3, ones(k-2)))#"codimVZ"),
    apply(toList(3..8), k -> lift(k^3/6 + 3*k^2/2 - 14*k/3 + 4, ZZ)));
-- arXiv:1902.00831 Table 5 = arXiv:2211.11405 Table 1, columns CS and M (published codimensions). In the package they
-- are codim V_Z - e_tau = "codimNLAtLambda0" for c = 2 (lambda_0 = -1), resp. c = 3 (lambda_0 = +1): that this number is
-- the codimension of a Hodge locus is the session's Theorem 2(4) (AI-written, unreviewed); the numbers are published.
expect("arXiv:1902.00831 Table 5 column CS (cubic scroll), n = 4..12, against codimNLAtLambda0 for c = 2",
    apply({2,3,4,5,6}, k -> (excessFromDegrees(3, ones 2, ones 2, ones(k-1)))#"codimNLAtLambda0"), {1,6,16,32,55});
expect("arXiv:1902.00831 Table 5 column M, n = 4..12, against codimNLAtLambda0 for c = 3",
    apply({2,3,4,5,6}, k -> (excessFromDegrees(3, ones 3, ones 3, ones(k-2)))#"codimNLAtLambda0"), {1,7,19,38,65});
-- the same table: column dim(T) and the Hodge numbers of cubic hypersurfaces (the middle one includes the class of a
-- linear section, so it is the primitive number + 1)
expect("arXiv:1902.00831 Table 5 column dim(T), n = 4..12", apply({4,6,8,10,12}, n -> ciHilbertFunction(toList(n+2 : 2), n+2, 3)), {20,56,120,220,364});
full = n -> (h := primitiveHodgeNumbers(n, 3); apply(#h, q -> if 2*q == n then h#q + 1 else h#q));
expect("arXiv:1902.00831 Table 5, Hodge numbers of cubic hypersurfaces, n = 4, 6, 8, 10", apply({4,6,8,10}, full),
    {{0,1,21,1,0}, {0,0,8,71,8,0,0}, {0,0,0,45,253,45,0,0,0}, {0,0,0,1,220,925,220,1,0,0,0}});
-- n = 12: THE PUBLISHED TABLE AND THE PACKAGE DISAGREE in the middle entry (3432 printed; 3433 here). Not adjusted.
-- The table prints the middle number INCLUDING the class of a linear section for n = 4..10 (21, 71, 253, 925) and
-- 3432 = binomial(14,7), the PRIMITIVE number, for n = 12. Read twice in arXiv:1902.00831 and twice in arXiv:2211.11405.
knownDisagreement("arXiv:1902.00831 Table 5 (= arXiv:2211.11405 Table 1), Hodge numbers of the cubic 12-fold", full 12,
    {0,0,0,0,14,1001,3432,1001,14,0,0,0,0},
    "middle entry: package 3432 primitive + 1 = 3433; the table prints 3432 while its rows n = 4..10 include the +1");
-- my own arithmetic, for the record: the middle Betti number of a smooth cubic of even dimension n is
-- ((-2)^(n+2) - 1)/3 + 2 (from the Euler characteristic); the package's rows sum to it
expect("sum of the package's Hodge numbers = ((-2)^(n+2) - 1)/3 + 2, n = 4..12 (5463 for n = 12; the published row sums to 5462)",
    apply({4,6,8,10,12}, n -> sum full n), apply({4,6,8,10,12}, n -> ((-2)^(n+2) - 1)//3 + 2));
finish()
