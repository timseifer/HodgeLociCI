-- VALIDATION TEST 06
-- Sources:   (i) H. Movasati, R. Villaflor Loyola, "Periods of linear algebraic cycles", arXiv:1705.00084, Theorem 2
--            (list of triples (n,d,m) where the locus of hypersurfaces containing two linear cycles is a reduced
--            component of the Hodge locus of their sum); the same list is Theorem 1 of arXiv:1602.06607.
--            (ii) R. Villaflor Loyola, arXiv:1812.03964, Theorem 3: at Fermat, if m < n/2 - d/(d-2) then
--            V_[a P + b P'] = V_[P] n V_[P'] for all nonzero a, b.
--            (iii) R. Kloosterman, arXiv:2312.12363, Theorem 1.5: complete intersections with
--            sum_(i<c)(e_i + d_i) < (c-1)d: equal tangent codimensions for all but finitely many lambda.
--            SOURCES.md entries A4, C1, B. Read by machine only.
-- Statement: in all these cases the level tau = sum(deg f_i + deg h_i) - (c-1)d is negative and there is no first-order
--            excess.
-- Computed:  excessFromDegrees(...)#"tau" < 0 and tangentExcess(D, lambda)#"excess" = 0 for lambda in {1, -1, 2},
--            at a random instance modulo 32003 and (linear cases, small ones) at the Fermat point modulo 30241.
--            Small cases: both strategies of tangentExcess ("Jacobian": codim (J : P_delta)_d as in Villaflor Loyola's
--            Corollary 3; "Residue": residue functionals of the regular sequences (f,p,g,s), (h,p,q,s)); larger
--            cases: "Residue" only. Sextic fourfolds and cubic tenfolds of the list: tests/slow/.
-- Label:     MOD p, one or two instances per case; tau is EXACT (integer arithmetic).
-- Expected:  tau < 0 and excess 0 (published; (iii) allows finitely many exceptional lambda, paper 3 Theorem 2(3)
--            [AI, unreviewed] says there are none).
load (currentFileDirectory | "common.m2")

lams = {1, -1, 2};
exs = (D, strat) -> apply(lams, l -> (tangentExcess(D, l, Strategy => strat))#"excess");
-- (n, d, m) from Theorem 2 of arXiv:1705.00084 (k = n/2, c = k - m); true: small enough for both strategies
cases = {(2,5,-1,true), (2,6,-1,false), (2,7,-1,false), (4,4,-1,true), (4,5,-1,false), (4,5,0,false),
         (6,3,-1,true), (6,4,-1,false), (6,4,0,false), (8,3,-1,true), (8,3,0,true)};
for t in cases do (
    (n, d, m, both) := t; k := n//2; c := k - m;
    ndm := (n, d, m);
    tau := (excessFromDegrees(d, ones c, ones c, ones(k+1-c)))#"tau";
    D := linearPair(d, k, c, 300 + 10*n + d + c);
    if both then expect("(n,d,m) = " | toString ndm | ": tau < 0; excess at lambda = 1, -1, 2 at a random point, strategies Jacobian and Residue",
        {tau < 0, exs(D, "Jacobian"), exs(D, "Residue")}, {true, {0,0,0}, {0,0,0}})
    else expect("(n,d,m) = " | toString ndm | ": tau < 0; excess at lambda = 1, -1, 2 at a random point, strategy Residue",
        {tau < 0, exs(D, "Residue")}, {true, {0,0,0}});
    if n <= 6 and d <= 5 and not (n == 6 and d == 4) then (
        Df := fermatPairModP(d, k, c, 30241);
        expect("(n,d,m) = " | toString ndm | ": excess at lambda = 1, -1, 2 at the Fermat point (Villaflor, Theorem 3), strategy Residue",
            exs(Df, "Residue"), {0,0,0});
        );
    );
-- non-linear complete intersections with tau < 0 (Kloosterman, Theorem 1.5): (d; deg f; deg h; deg p)
for t in {(4, {1,1,1}, {1,1,2}, {}), (6, {1,2}, {1,1}, {}), (7, {2,2}, {1,1}, {}), (5, {1,1,1}, {1,2,2}, {}), (5, {1,1}, {1,1}, {2})} do (
    (d, df, dh, dp) := t;
    tau := (excessFromDegrees(d, df, dh, dp))#"tau";
    D := randomCyclePair(d, df, dh, dp, Seed => 350 + d);
    expect("degrees " | toString t | ": tau < 0 and excess at lambda = 1, -1, 2 (strategy Residue)", {tau < 0, exs(D, "Residue")}, {true, {0,0,0}});
    );
finish()
