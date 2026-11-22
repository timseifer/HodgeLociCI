-- VALIDATION TEST 04
-- Source:    R. Kloosterman, arXiv:2312.12363, Theorem 1.2. SOURCES.md entry B. Read by machine only.
-- Statement: for d = 3, c in {2,3}, k >= 5, or d = 4, c = 2, k >= 3, THERE EXISTS a smooth X of degree d containing two
--            k-planes meeting in codimension c and a finite set S such that for rational lambda outside S the tangent
--            spaces of NL([Pi_1] + lambda [Pi_2]) and NL([Pi_1],[Pi_2]) have the same codimension. S = {0,1} if c = d = 3;
--            S = {0,-1} if d = 4, c = 2. (This is the statement that refutes Movasati's dimension claim for n >= 10.)
-- Computed:  at ONE random instance modulo 32003 (fixed seed) with (d,k,c) = (3,5,3) and (4,3,2), the two cases where
--            the theorem names S: tangentExcess(D, lambda, Strategy => "Residue")#"excess" for several lambda outside S,
--            and at the exceptional coefficient. The "Residue" strategy pairs S_d with S_(kd-2k-2) through the
--            residue functionals Res[ . /(f,p,g,s)] and Res[ . /(h,p,q,s)] (the period formula for complete
--            intersections in the form of paper 3, Lemma 2.1(1); Theorem 2 of paper 3 is NOT used). The "Jacobian"
--            strategy (Villaflor Loyola's (J : P)_d literally) did not finish in 15 minutes for (3,5,3); the two
--            strategies are compared on smaller cases in test 06. The case (3,5,2) is in tests/slow/.
-- Label:     MOD p, one instance (evidence for an existence statement; not a proof).
-- Expected:  excess 0 outside S (published). At the exceptional coefficient the published statement only excludes it
--            from the equality; the value 1 of the excess there is the session's own (paper 3, Theorem 2(4): e_tau),
--            AI-produced and unreviewed.
load (currentFileDirectory | "common.m2")
ex = (D, l) -> (tangentExcess(D, l, Strategy => "Residue"))#"excess";

D = linearPair(3, 5, 3, 101);
expect("(d,k,c) = (3,5,3), random point mod 32003: X smooth", D#"smooth", true);
expect("(3,5,3): excess at lambda = 2, 3, -2, 1/2, 5/3, -1 (outside S = {0,1})",
    apply({2, 3, -2, 1/2, 5/3, -1}, l -> ex(D, l)), {0,0,0,0,0,0});
expect("(3,5,3): excess at lambda = 1 [session value e_tau = 1]", ex(D, 1), 1);
expect("(3,5,3): codimension of T V_Z (39 in Movasati's table, A1)", (tangentExcess(D, 2, Strategy => "Residue"))#"codimTVZ", 39);

D = linearPair(4, 3, 2, 103);
expect("(d,k,c) = (4,3,2), random point mod 32003: X smooth", D#"smooth", true);
expect("(4,3,2): excess at lambda = 1, 2, 3, -2, 1/2, 5/3 (outside S = {0,-1})",
    apply({1, 2, 3, -2, 1/2, 5/3}, l -> ex(D, l)), {0,0,0,0,0,0});
expect("(4,3,2): excess at lambda = -1 [session value e_tau = 1]", ex(D, -1), 1);
expect("(4,3,2): codimension of T V_Z (37 in arXiv:1602.06607, tuple (6,4,1 | 36,37))", (tangentExcess(D, 2, Strategy => "Residue"))#"codimTVZ", 37);
expect("label says MOD p", match("MOD p", (tangentExcess(D, 2, Strategy => "Residue"))#"label"), true);
finish()
