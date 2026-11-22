-- VALIDATION TEST 12
-- Source:    THE SESSION'S OWN RESULT (AI-produced, unreviewed): paper 3, Corollary 4 (one excess direction; the law
--            (1/2) Hess = ((lambda - lambda_0)/lambda) A(Q)), Theorem "thm:lin" part (3) (non-reduced structure for the
--            list L), and the tables tab:tau (last column) and tab:types of its Section "Computations".
--            SOURCES.md entries E2, E3, E4.
-- Statement: (a) for (d,k,c) in the list L and lambda not in {0, lambda_0}, at a general X the excess directions are all
--            obstructed at second order (the locus is V_Z with a non-reduced structure); at lambda_0 they all survive.
--            (b) types with tau = 0 and K != 0 (tab:types): excess 1, the second-order term vanishes exactly at
--            lambda_0 = (-1)^(c-1) and is proportional to (lambda - lambda_0)/lambda.
--            (c) tab:tau, last column: the quadratic map vanishes at lambda_0 only; if K = 0 (in the range) nothing is
--            obstructed and the locus is smooth of dimension dim V_Z + e_tau for every lambda.
-- Computed:  secondOrderObstruction(D, lambda, Strategy => "Both") at random instances modulo 32003: the verdict, and
--            agreement of the two strategies (the formula of Theorems 9.1/9.4 and the pointwise residue formula).
--            (The type (5; (1,1); (1,2); (1)) of tab:types takes about two minutes and is in tests/slow/.)
-- Label:     MOD p, one instance per type. Status: PROVED in an AI-written, unreviewed paper; the verdict at an instance
--            is a computation.
-- Expected:  "ALL DIE" away from lambda_0 and "ALL SURVIVE" at lambda_0 in (a), (b); in (c) "ALL DIE" or "SOME DIE"
--            (quadrics not all zero) away from lambda_0 when K != 0, and "ALL SURVIVE" for every lambda when K = 0.
load (currentFileDirectory | "common.m2")

verdicts = (D, lams) -> apply(lams, l -> (
    so := secondOrderObstruction(D, l, Strategy => "Both");
    if so#"strategiesAgree" === false then "STRATEGIES DISAGREE" else so#"verdict"));

-- (a) rows of tab:lin that are fast enough here (k <= 3, and (5,2,1))
for dkc in {(3,3,1), (3,3,2), (3,3,3), (4,2,1), (4,2,2), (5,2,1), (5,1,1), (6,1,1)} do (
    (d, k, c) := dkc;
    D := linearPair(d, k, c, 1200 + 100*d + 10*k + c);
    l0 := D#"lambda0";
    expect(toString dkc | ": verdict at lambda = 2, -2, 5/3, -lambda_0 and at lambda_0",
        verdicts(D, {2, -2, 5/3, -l0, l0}), {"ALL DIE", "ALL DIE", "ALL DIE", "ALL DIE", "ALL SURVIVE"});
    tick toString dkc;
    );
-- (b) types with tau = 0 from tab:types: (d, deg f, deg h, deg p)
for t in {(6, {1,2}, {1,2}, {}), (7, {1,2}, {2,2}, {}), (8, {1,1}, {3,3}, {}), (4, {1,1}, {1,1}, {2}), (4, {1,1,1}, {1,2,2}, {}), (4, {1,1,2}, {1,1,2}, {}),
          (3, {1,1,1,1}, {1,1,1,2}, {})} do (
    (d, df, dh, dp) := t;
    D := randomCyclePair(d, df, dh, dp, Seed => 1300 + d + #df);
    l0 := D#"lambda0";
    ex := apply({l0, 2, -l0}, l -> (tangentExcess(D, l))#"excess");
    expect("tau = 0 type " | toString t | ": {tau, lambda_0, excess at lambda_0, 2, -lambda_0}",
        {D#"tau", l0, ex}, {0, (-1)^(#df - 1), {1,1,1}});
    expect("tau = 0 type " | toString t | ": verdict at lambda = 2, -2, 5/3, -lambda_0 and at lambda_0",
        verdicts(D, {2, -2, 5/3, -l0, l0}), {"ALL DIE", "ALL DIE", "ALL DIE", "ALL DIE", "ALL SURVIVE"});
    -- the law: value(lambda) * lambda/(lambda - lambda_0) is independent of lambda (pointwise strategy, which does not
    -- build the factor in)
    kk := D#"field";
    nrm := l -> (
        v := flatten (secondOrderObstruction(D, l, Strategy => "Pointwise"))#"values";
        lam := if instance(l, QQ) then (numerator l)_kk / (denominator l)_kk else l_kk;
        apply(v, a -> a * lam / (lam - l0_kk)));
    expect("tau = 0 type " | toString t | ": pointwise second-order values obey the factor (lambda - lambda_0)/lambda (lambda = 2, -2, 5/3)",
        nrm 2 == nrm(-2) and nrm 2 == nrm(5/3) and any(nrm 2, a -> a != 0), true);
    tick toString t;
    );
-- (c) rows of tab:tau: K != 0 rows (quadratic map vanishes at lambda_0 only) and K = 0 rows
for t in {(6, {1}, {1}, {2}, false), (6, {1}, {1}, {3}, false), (4, {1,1,1}, {1,2,3}, {}, false), (4, {1,1,2}, {1,2,2}, {}, false), (4, {1,1}, {1,2}, {1}, false),
          (5, {1}, {1}, {2}, true), (5, {1}, {1}, {3}, true), (3, {1,1}, {1,1}, {1}, true), (3, {1}, {1}, {1,1}, true)} do (
    (d, df, dh, dp, Kzero) := t;
    D := randomCyclePair(d, df, dh, dp, Seed => 1400 + d + #df + sum dp);
    l0 := D#"lambda0";
    vs := verdicts(D, {2, -2, 5/3, -l0});
    so := secondOrderObstruction(D, 2);
    if Kzero then expect("tab:tau type " | toString take(t, 4) | " (K = 0): dim K and verdicts at lambda = 2, -2, 5/3, -lambda_0",
        {so#"dimK", vs}, {0, toList(4 : "ALL SURVIVE")})
    else expect("tab:tau type " | toString take(t, 4) | " (K != 0): quadrics not all zero at lambda = 2, -2, 5/3, -lambda_0; all survive at lambda_0",
        {all(vs, v -> v == "ALL DIE" or v == "SOME DIE"), (secondOrderObstruction(D, l0))#"verdict"}, {true, "ALL SURVIVE"});
    if not Kzero then report("tab:tau type " | toString take(t, 4) | ": verdicts", vs);
    tick toString take(t, 4);
    );
finish()
