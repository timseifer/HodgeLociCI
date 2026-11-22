-- VALIDATION TEST 07
-- Sources:   R. Villaflor Loyola, arXiv:1812.03964, Corollary 3 (Section 8): T V_[delta] = (J^F : P_delta)_d with
--            P_delta = det Jac(f_1,g_1,...); arXiv:2001.01019, Example 2.1 (after Dan): for a complete intersection
--            Z = V(f) in X = {sum f_i g_i = 0}, T V_[Z] = <f_1,g_1,...>_d, and Theorem 1.1: the number
--            binomial(n/2+d,d) - (n/2+1)^2 for a linear cycle. H. Movasati, arXiv:1602.06607: Section 4, table
--            "Codimension of the loci of complete intersection algebraic cycles" (types (d_1,d_2,d_3); the pair
--            (n,d) = (4,6) is MY inference from the entry 19 for type (1,1,1) and from the surrounding text on sextic
--            fourfolds), and Section 6: T_(1,1,2) has codimension 8 for (n,d) = (4,4).
--            SOURCES.md entries C1, C2, A1. Read by machine only.
-- Statement: the tangent codimension of the Hodge locus of one complete-intersection cycle is dim (S/(f,g))_d.
-- Computed:  (a) ciHilbertFunction / excessFromDegrees "codimV1" for the published numbers (EXACT, integers);
--            (b) at random instances modulo 32003: the rank computed from the period polynomial in the Jacobian ring
--            (tangentExcess "codimTV1", i.e. codim (J : P)_d) and, independently, hodgeLocusTangentCodim(F, I(Y_1)),
--            against (a).
-- Label:     (a) EXACT; (b) MOD p.
-- Expected:  published numbers for (a); equality of the three computations for (b).
load (currentFileDirectory | "common.m2")

-- (a) published numbers
expect("arXiv:2001.01019 Thm 1.1 number binomial(k+d,d)-(k+1)^2: line on a quintic surface, plane on a quartic fourfold, 3-plane on a cubic sixfold, 4-plane on a cubic eightfold",
    {(excessFromDegrees(5, {1}, {1}, {1}))#"codimV1", (excessFromDegrees(4, {1}, {1}, {1,1}))#"codimV1",
     (excessFromDegrees(3, {1}, {1}, {1,1,1}))#"codimV1", (excessFromDegrees(3, {1}, {1}, {1,1,1,1}))#"codimV1"},
    {2, 6, 4, 10});
expect("arXiv:1602.06607 Section 6: codimension of T_(1,1,2) for (n,d) = (4,4)", (excessFromDegrees(4, {1}, {1}, {1,2}))#"codimV1", 8);
sextic = {({1,1,1},19), ({1,1,2},32), ({1,1,3},37), ({1,2,2},54), ({1,2,3},62), ({1,3,3},71), ({2,2,2},92), ({2,2,3},106), ({2,3,3},122), ({3,3,3},141)};
expect("arXiv:1602.06607 Section 4 table, sextic fourfolds, types (1,1,1), (1,1,2), ..., (3,3,3)",
    apply(sextic, t -> ciHilbertFunction(t#0 | apply(t#0, a -> 6 - a), 6, 6)), apply(sextic, t -> t#1));
-- (b) three computations of the same tangent codimension at random instances
for t in {(5, {1}, {1}, {1}), (5, {2}, {1}, {1}), (4, {1}, {1}, {1,1}), (4, {1}, {1}, {1,2}), (4, {2}, {1}, {1,2}), (3, {1}, {1}, {1,1,1}), (6, {2}, {2}, {3})} do (
    (d, df, dh, dp) := t;
    pred := (excessFromDegrees(d, df, dh, dp))#"codimV1";
    D := randomCyclePair(d, df, dh, dp, Seed => 400 + d + sum df);
    viaPeriod := (tangentExcess(D, 2))#"codimTV1";
    viaIdeal := hodgeLocusTangentCodim(D#"F", ideal(D#"f" | D#"p"));
    expect("type " | toString(df | dp) | " in degree " | toString d | ": {Hilbert function, rank from the period polynomial, hodgeLocusTangentCodim}",
        {pred, viaPeriod, viaIdeal#"codim"}, {pred, pred, pred});
    );
finish()
