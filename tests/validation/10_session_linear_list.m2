-- VALIDATION TEST 10
-- Source:    THE SESSION'S OWN RESULT (AI-produced, unreviewed): paper 3, Theorem "thm:lin" (Theorem 9.7) and its
--            Table (tab:lin); night/CHECKS_R2.md, test T3 (the excesses at lambda_0). SOURCES.md entries E3, E6.
-- Statement: for two k-planes meeting in dimension k-c on a general smooth hypersurface of degree d and
--            lambda not in {0, lambda_0}, the first-order excess of NL([Pi_1] + lambda [Pi_2]) over V_Z is e for
--            (d,k,c) in the list L (table below) and 0 otherwise; at lambda_0 it is e_tau.
-- Computed:  rows with k <= 3 and the surface rows: tangentExcess at lambda in {2, 3, -2, -lambda_0} and at lambda_0, at a
--            random instance modulo 32003; linearSubspaceCase(d,k,c) for the classification itself.
--            (The rows with cubic eightfolds and quintic fourfolds are in test 11.)
-- Label:     MOD p, one instance per row. Status of the statement: PROVED in an AI-written, unreviewed paper
--            (first-order part); COMPUTED in CHECKS_R2 (Singular) with other code.
-- Expected:  e from tab:lin; the excess at lambda_0 from CHECKS_R2 T3 (3, 2, 1, 6, 3, 1, 3, 1, 3, 1 in table order).
load (currentFileDirectory | "common.m2")

-- (d,k,c, tau, lambda_0, e, excess at lambda_0)
rows = {(3,3,1, 2, 1, 2, 3), (3,3,2, 1, -1, 2, 2), (3,3,3, 0, 1, 1, 1), (4,2,1, 2, 1, 2, 3), (4,2,2, 0, -1, 1, 1),
        (5,1,1, 2, 1, 1, 1), (6,1,1, 2, 1, 1, 1), (7,1,1, 2, 1, 1, 1)};
for r in rows do (
    (d, k, c, tau, l0, e, e0) := r;
    nm := toString(d,k,c);
    lc := linearSubspaceCase(d, k, c);
    expect(nm | ": linearSubspaceCase {tau, lambda0, case, genericExcessElsewhere}",
        {lc#"tau", lc#"lambda0", lc#"case", lc#"genericExcessElsewhere"}, {tau, l0, "sporadic", e});
    D := linearPair(d, k, c, 700 + 100*d + 10*k + c);
    expect(nm | ": excess at lambda = 2, 3, -2, -lambda_0, and at lambda_0",
        apply({2, 3, -2, -l0, l0}, l -> (tangentExcess(D, l))#"excess"), {e, e, e, e, e0});
    );
-- outside the list: excess 0 for lambda != lambda_0
for dkc in {(3,3,4), (4,2,3), (5,1,2), (6,1,2)} do (
    (d, k, c) := dkc;
    D := linearPair(d, k, c, 800 + 100*d + 10*k + c);
    l0 := D#"lambda0";
    expect(toString dkc | " (not in the list): case and excess at lambda = 2, 3, -2, -lambda_0",
        {(linearSubspaceCase(d,k,c))#"genericExcessElsewhere", apply({2, 3, -2, -l0}, l -> (tangentExcess(D, l))#"excess")}, {0, {0,0,0,0}});
    );
-- excluded cases (quartic surface, cubic fourfold): divisors, excess 1 for every lambda
for dkc in {(4,1,2), (3,2,1), (3,2,2)} do (
    (d, k, c) := dkc;
    D := linearPair(d, k, c, 900 + 100*d + 10*k + c);
    expect(toString dkc | " (excluded: kd-2k-2 = 0): case and excess at lambda = 1, -1, 2, 3",
        {(linearSubspaceCase(d,k,c))#"case", apply({1, -1, 2, 3}, l -> (tangentExcess(D, l))#"excess")}, {"excluded", {1,1,1,1}});
    );
finish()
