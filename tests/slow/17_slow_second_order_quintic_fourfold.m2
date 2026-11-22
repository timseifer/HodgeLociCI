-- VALIDATION TEST 17 (SLOW; not part of the default suite: run with tests/run_all.sh --slow)
-- Source:    THE SESSION'S OWN RESULT (AI-produced, unreviewed): paper 3, Corollary 4 and table tab:types, row
--            (k,d) = (2,5), type (1,1)+(1,2) with a shared linear equation (c = 2, tau = 0). SOURCES.md entries E2, E4.
-- Statement: excess 1 for every lambda != 0; lambda_0 = -1; the second-order term vanishes exactly at lambda_0 and is
--            proportional to (lambda - lambda_0)/lambda (A != 0).
-- Computed:  tangentExcess and secondOrderObstruction (Strategy => "Both") at one random instance modulo 32003.
-- Label:     MOD p, one instance. Status: PROVED in an AI-written, unreviewed paper; the instance is a computation.
-- Expected:  {tau, lambda_0} = {0, -1}; excess 1; "ALL DIE" at lambda = 2, -2, 5/3, 1; "ALL SURVIVE" at lambda = -1.
-- Measured:  see tests/README.md.
load (pcHere = currentFileDirectory; pcHere | "../validation/common.m2")

D = randomCyclePair(5, {1,1}, {1,2}, {1}, Seed => 1307);
l0 = D#"lambda0";
expect("{tau, lambda_0, excess at lambda_0, 2, -lambda_0}",
    {D#"tau", l0, apply({l0, 2, -l0}, l -> (tangentExcess(D, l, Strategy => "Residue"))#"excess")}, {0, -1, {1,1,1}});
so = apply({2, -2, 5/3, -l0, l0}, l -> secondOrderObstruction(D, l, Strategy => "Both"));
expect("verdict at lambda = 2, -2, 5/3, -lambda_0 and at lambda_0", apply(so, t -> t#"verdict"),
    {"ALL DIE", "ALL DIE", "ALL DIE", "ALL DIE", "ALL SURVIVE"});
expect("formula and pointwise strategies agree away from lambda_0", apply(take(so, 4), t -> t#"strategiesAgree"), toList(4 : true));
finish()
