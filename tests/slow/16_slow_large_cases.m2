-- VALIDATION TEST 16 (SLOW; not part of the default suite: run with tests/run_all.sh --slow)
-- Sources:   H. Movasati, R. Villaflor Loyola, arXiv:1705.00084, Theorem 2 (triples (4,6,-1), (4,6,0), (10,3,-1),
--            (10,3,0), (10,3,1)); R. Kloosterman, arXiv:2312.12363, Theorem 1.2 for (d,c,k) = (3,2,5) (the set S is not
--            named there for c = 2). SOURCES.md entries A4, B. Read by machine only.
-- Statement: tau < 0 and no first-order excess for the five triples; for (3,5,2): no excess for all but finitely many
--            lambda at some X.
-- Computed:  tangentExcess(D, lambda, Strategy => "Residue") at one random instance modulo 32003.
-- Label:     MOD p, one instance per case.
-- Expected:  excess 0 (published). For (3,5,2) at lambda = -1 the value 4 = e_tau = k-1 is the session's own (paper 3,
--            Theorem 2(4)); 36 - 4 = 32 is the entry of column CS of arXiv:1902.00831, Table 5 for n = 10.
-- Measured:  see tests/README.md (wall-clock time of the last run on the development machine).
load (pcHere = currentFileDirectory; pcHere | "../validation/common.m2")

lams = {1, -1, 2};
exs = (D, ls) -> apply(ls, l -> (tangentExcess(D, l, Strategy => "Residue"))#"excess");
for ndm in {(4,6,-1), (4,6,0), (10,3,-1), (10,3,0), (10,3,1)} do (
    (n, d, m) := ndm; k := n//2; c := k - m;
    tau := (excessFromDegrees(d, ones c, ones c, ones(k+1-c)))#"tau";
    D := linearPair(d, k, c, 1600 + 10*n + d + c);
    expect("(n,d,m) = " | toString ndm | ": tau < 0; excess at lambda = 1, -1, 2 at a random point", {tau < 0, exs(D, lams)}, {true, {0,0,0}});
    );
D = linearPair(3, 5, 2, 102);
expect("(d,k,c) = (3,5,2): excess at lambda = 2, 3, -2, 1/2, 5/3, 1", exs(D, {2, 3, -2, 1/2, 5/3, 1}), {0,0,0,0,0,0});
expect("(3,5,2): excess at lambda = -1 [session value e_tau = k-1 = 4]; codim T V_Z",
    {first exs(D, {-1}), (tangentExcess(D, 2, Strategy => "Residue"))#"codimTVZ"}, {4, 36});
finish()
