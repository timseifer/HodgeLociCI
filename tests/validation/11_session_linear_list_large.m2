-- VALIDATION TEST 11
-- Source:    THE SESSION'S OWN RESULT (AI-produced, unreviewed): paper 3, Theorem "thm:lin" and Table tab:lin, rows with
--            cubic eightfolds (3,4,c), c = 1, 2, 3, and quintic fourfolds (5,2,1); night/CHECKS_R2.md, test T3.
--            SOURCES.md entries E3, E6. For (3,4,3) compare also Movasati's pair (19,20) (test 03) and Kloosterman's
--            Theorem 1.3 (test 05).
-- Statement: as in test 10. Rows: (3,4,1): e = 2, excess 6 at lambda_0 = 1; (3,4,2): e = 2, excess 3 at lambda_0 = -1;
--            (3,4,3): e = 1, excess 1 at lambda_0 = 1; (5,2,1): e = 1, excess 3 at lambda_0 = 1. Not in the list:
--            (3,4,4), (3,4,5), (5,2,2), (5,2,3): excess 0.
-- Computed:  tangentExcess at a random instance modulo 32003 at lambda in {2, -2, -lambda_0} and at lambda_0
--            (strategy "Jacobian" for the cubic eightfolds, "Residue" for the quintic fourfolds, which are about
--            ten times slower with "Jacobian"; the two strategies are compared in tests 06 and 15).
-- Label:     MOD p, one instance per row. Status: PROVED in an AI-written, unreviewed paper; COMPUTED in CHECKS_R2.
-- Expected:  tab:lin and CHECKS_R2 T3.
load (currentFileDirectory | "common.m2")

rows = {(3,4,1, 2, 6, 16), (3,4,2, 2, 3, 19), (3,4,3, 1, 1, 20), (5,2,1, 1, 3, 22)};
for r in rows do (
    (d, k, c, e, e0, cod) := r;
    D := linearPair(d, k, c, 1000 + 100*d + 10*k + c);
    l0 := D#"lambda0";
    te := apply({2, -2, -l0, l0}, l -> tangentExcess(D, l, Strategy => (if d == 5 then "Residue" else "Jacobian")));
    expect(toString(d,k,c) | ": codim T V_Z; excess at lambda = 2, -2, -lambda_0, and at lambda_0",
        {(te#0)#"codimTVZ", apply(te, u -> u#"excess")}, {cod, {e, e, e, e0}});
    );
for dkc in {(3,4,4), (3,4,5), (5,2,2), (5,2,3)} do (
    (d, k, c) := dkc;
    D := linearPair(d, k, c, 1100 + 100*d + 10*k + c);
    l0 := D#"lambda0";
    expect(toString dkc | " (not in the list): excess at lambda = 2, -2, -lambda_0",
        apply({2, -2, -l0}, l -> (tangentExcess(D, l, Strategy => (if d == 5 then "Residue" else "Jacobian")))#"excess"), {0,0,0});
    );
finish()
