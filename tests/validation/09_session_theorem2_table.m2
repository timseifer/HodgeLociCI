-- VALIDATION TEST 09
-- Source:    THE SESSION'S OWN RESULT (AI-produced, unreviewed): paper 3 (night/paper3/paper3.tex), Theorem 2 and the
--            table "Theorem 2 against runs made before it was formulated" (tab:tau) of its Section "Computations".
--            SOURCES.md entries E1, E4.
-- Statement: with tau = sum(deg f_i + deg h_i) - (c-1)d, e_tau = dim A_tau, range: (k-1)d + tau < 2k+2:
--            excess at lambda_0 = (-1)^(c-1) is e_tau (tau >= 0); in the range the excess is e_tau for every lambda != 0;
--            outside the range it is dim (0 :_A det M)_tau for lambda not in {0, lambda_0}; for tau < 0 it is 0.
--            V_1, V_2 are transversal iff the range holds.
-- Computed:  for the 12 rows of the table: tau, range, e_tau from excessFromDegrees (EXACT, integers); at a random
--            instance modulo 32003 the excess at lambda_0 and at 2, -2, 5/3, -lambda_0 by tangentExcess (direct linear
--            algebra, Theorem 2 not used), and verifyExcess (Theorem 2 against the direct computation).
-- Label:     degrees: EXACT; instances: MOD p. Status of the statement: PROVED in an AI-written, unreviewed paper.
-- Expected:  the rows of the table as printed in paper 3 (columns tau, range, e_tau, excess found).
load (currentFileDirectory | "common.m2")

-- (d, deg f, deg h, deg p, tau, range, e_tau, excess at lambda_0, excess elsewhere)
rows = {
    (6, {1}, {1}, {2},         2, true,  2, 2, 2),
    (6, {1}, {1}, {3},         2, true,  3, 3, 3),
    (5, {1}, {1}, {2},         2, true,  2, 2, 2),
    (5, {1}, {1}, {3},         2, true,  2, 2, 2),
    (5, {1}, {1}, {1},         2, true,  1, 1, 1),
    (3, {1,1}, {1,1}, {1},     1, true,  1, 1, 1),
    (3, {1}, {1}, {1,1},       2, true,  1, 1, 1),
    (4, {1,1,1}, {1,2,3}, {},  1, true,  2, 2, 2),
    (4, {1,1,2}, {1,2,2}, {},  1, true,  3, 3, 3),
    (4, {1,1}, {1,2}, {1},     1, true,  2, 2, 2),
    (4, {1}, {1}, {1,1},       2, false, 3, 3, 2),
    (4, {1,1,1}, {1,1,2}, {}, -1, null,  0, 0, 0)};
scan(#rows, i -> (
    (d, df, dh, dp, tau, rng, et, ex0, exE) := rows#i;
    t := excessFromDegrees(d, df, dh, dp);
    nm := "row " | toString(i+1) | " (d = " | toString d | "; " | toString df | "; " | toString dh | "; " | toString dp | ")";
    expect(nm | ": {tau, e_tau}", {t#"tau", t#"eTau"}, {tau, et});
    if rng =!= null then expect(nm | ": in the range", t#"inRange", rng);
    D := randomCyclePair(d, df, dh, dp, Seed => 600 + i);
    l0 := D#"lambda0";
    te := apply({l0, 2, -2, 5/3, -l0}, l -> tangentExcess(D, l));
    expect(nm | ": excess at lambda_0, 2, -2, 5/3, -lambda_0", apply(te, u -> u#"excess"), {ex0, exE, exE, exE, exE});
    expect(nm | ": V_1, V_2 transversal (codim T V_Z = codim T V_1 + codim T V_2) iff in the range",
        ((te#0)#"codimTVZ" == (te#0)#"codimTV1" + (te#0)#"codimTV2") === t#"inRange", true);
    expect(nm | ": Theorem 2 agrees with the direct computation (verifyExcess)", (verifyExcess D)#"agrees", true);
    ));
-- level dichotomy by degrees: for every linear type with kd-2k-2 >= 1 (the hypothesis of Theorem 9.7),
-- tau < 0 iff (c >= 4, or c = 3 and d >= 4, or c = 2 and d >= 5); then no excess; otherwise excess >= 1 at lambda_0
bad = {};
for d from 3 to 8 do for k from 1 to 6 do for c from 1 to k+1 do if k*d - 2*k - 2 >= 1 then (
    t := excessFromDegrees(d, ones c, ones c, ones(k+1-c));
    neg := c >= 4 or (c == 3 and d >= 4) or (c == 2 and d >= 5);
    if (t#"tau" < 0) =!= neg or (t#"tau" < 0 and t#"excessAtLambda0" != 0) or (t#"tau" >= 0 and t#"excessAtLambda0" < 1) then bad = append(bad, (d,k,c));
    );
expect("linear types 3 <= d <= 8, k <= 6, kd-2k-2 >= 1 violating the dichotomy 'tau < 0 iff no excess at lambda_0' as listed in Theorem 9.7(1)", bad, {});
finish()
