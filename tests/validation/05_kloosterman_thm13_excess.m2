-- VALIDATION TEST 05
-- Source:    R. Kloosterman, arXiv:2312.12363, Theorem 1.3 and Example 3.17; R. Villaflor Loyola, arXiv:1812.03964,
--            Section 9, Proposition 7 / Remark 7 (at Fermat). SOURCES.md entries B, C1. Read by machine only.
-- Statement: for d = 3, c in {2,3}, k in {2,3,4}, or d = 4, c = 2, k in {1,2}: at EVERY smooth X containing two k-planes
--            meeting in codimension c and for every nonzero rational lambda, the tangent space of
--            NL([Pi_1] + lambda [Pi_2]) is strictly larger than that of NL([Pi_1],[Pi_2]).
-- Computed:  tangentExcess(D, lambda)#"excess" >= 1 for lambda in {1, -1, 2, 5/3} at a random instance modulo 32003 and at
--            the Fermat hypersurface modulo 30241 (planes of Movasati type), for all eight triples (d,k,c).
-- Label:     MOD p, two instances per triple (the published statement is for every X).
-- Expected:  every excess >= 1 (published). The exact values are printed as INFO; their predicted values are the
--            session's (paper 3, Theorem 2), tested in tests 09, 10.
load (currentFileDirectory | "common.m2")

lams = {1, -1, 2, 5/3};
for dkc in {(3,2,2), (3,2,3), (3,3,2), (3,3,3), (3,4,2), (3,4,3), (4,1,2), (4,2,2)} do (
    (d, k, c) := dkc;
    D := linearPair(d, k, c, 200 + 10*k + c);
    ex := apply(lams, l -> (tangentExcess(D, l))#"excess");
    expect(toString dkc | " random point: excess >= 1 at lambda = 1, -1, 2, 5/3", all(ex, e -> e >= 1), true);
    report(toString dkc | " random point: the excesses", ex);
    Df := fermatPairModP(d, k, c, 30241);
    exf := apply(lams, l -> (tangentExcess(Df, l))#"excess");
    expect(toString dkc | " Fermat point: excess >= 1 at lambda = 1, -1, 2, 5/3", all(exf, e -> e >= 1), true);
    report(toString dkc | " Fermat point: the excesses", exf);
    );
finish()
