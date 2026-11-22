-- VALIDATION TEST 08
-- Sources:   C. Maclean, "A second-order invariant of the Noether-Lefschetz locus and two applications", Asian J. Math.
--            9 (2005): NOT opened. Read instead: the author's thesis (Paris 6, 2003), Theorem 24 and Proposition 9;
--            A. Dan, arXiv:1407.8491, Introduction and Theorem 1.3 (secondary). SOURCES.md entries D1, D1a, D1b.
-- Statement: on a quintic surface X containing two coplanar lines L_1, L_2 and for distinct nonzero integers a, b, the
--            Noether-Lefschetz locus of a[L_1] + b[L_2] (- a multiple of H) is NON-REDUCED: its reduction is
--            NL(L_1) n NL(L_2), of codimension 2d - 6 = 4, and its Zariski tangent space has codimension < 4.
--            (Dan: the same for d >= 5 and the class 2 l_1 + l_2, codimension 2d - 6.)
-- Computed:  k = 1, c = 1 (own equations f_0, h_0 linear; the shared equation p is the plane), lambda = b/a, lambda_0 = 1:
--            codimVZ from degrees for d = 5, 6, 7; at a random quintic modulo 32003 and at a random quintic over QQ:
--            first-order excess (tangentExcess) and the second-order verdict (secondOrderObstruction, both strategies).
-- Label:     MOD p (one instance) and EXACT over QQ (one instance); the published statement is for every such quintic.
-- Expected:  codim V_Z = 2d - 6; excess 1 for every lambda != 0 (tangent codimension 3 < 4); verdict "ALL DIE" for
--            lambda != 1 (non-reduced structure on V_Z; a != b) and "ALL SURVIVE" at lambda = 1 (a = b: the class of the
--            conic L_1 + L_2 plus a multiple of H, where the locus is smooth and larger).
load (currentFileDirectory | "common.m2")

expect("codim V_Z for two coplanar lines, d = 5, 6, 7 (published: 2d - 6)",
    apply({5,6,7}, d -> (excessFromDegrees(d, {1}, {1}, {1}))#"codimVZ"), {4, 6, 8});
for kk in {ZZ/32003, QQ} do (
    D := randomCyclePair(5, {1}, {1}, {1}, Seed => 500, CoefficientRing => kk);
    nm := if kk === QQ then "quintic over QQ" else "quintic mod 32003";
    te := apply({2, -1, 1/2, 3, 1}, l -> tangentExcess(D, l));
    expect(nm | ": codim T V_Z and codim T NL at lambda = 2, -1, 1/2, 3, 1",
        {(te#0)#"codimTVZ", apply(te, t -> t#"codimTNL")}, {4, {3,3,3,3,3}});
    so := apply({2, -1, 1/2, 3}, l -> secondOrderObstruction(D, l, Strategy => "Both"));
    expect(nm | ": second-order verdict at lambda = 2, -1, 1/2, 3", apply(so, t -> t#"verdict"), toList(4 : "ALL DIE"));
    expect(nm | ": formula and pointwise strategies agree", apply(so, t -> t#"strategiesAgree"), toList(4 : true));
    expect(nm | ": second-order verdict at lambda = 1", (secondOrderObstruction(D, 1))#"verdict", "ALL SURVIVE");
    expect(nm | ": label", match(if kk === QQ then "EXACT" else "MOD p", (so#0)#"arithmetic"), true);
    );
finish()
