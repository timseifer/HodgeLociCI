-- VALIDATION TEST 15
-- Sources:   H. Movasati, arXiv:1602.06607, Table 1 (pairs (H,K), as in test 03) and the tuples (4,4,0 | 11,12),
--            (4,4,-1 | 12,12); THE SESSION'S OWN Theorem 2(5) of paper 3 (AI-produced, unreviewed) for the prediction
--            "excess = dim (0 :_A det M)_tau". SOURCES.md entries A1, E1.
-- Statement: at the Fermat point the first-order numbers (H, K) of Movasati's table are obtained by three routes:
--            (i) the Fermat module of the package (period formula for linear cycles, exact over Q(zeta_2d));
--            (ii) the general first-order tool tangentExcess (period polynomial det Jac in the Jacobian ring), with the
--                 Fermat hypersurface written as F = f^T M h + sum p_l s_l modulo a prime p = 1 mod 2d;
--            (iii) the excess calculator excessFromData (Hilbert functions and the rank of .det M : A_tau -> A_d).
-- Computed:  cubic fourfolds and sixfolds (c = 1..k+1), cubic eightfold c = 3, quartic fourfold (c = 1, 2, 3):
--            {H, K} by the three routes, coefficients (1,1), and for (ii), (iii) also lambda = 2.
-- Label:     (i) EXACT; (ii), (iii) MOD p (p = 30241). The routes share no code (see common.m2: fermatPairModP).
-- Expected:  the published pairs (H,K); agreement of the three routes.
load (currentFileDirectory | "common.m2")

published = new HashTable from {
    (3,2,1) => {1,2}, (3,2,2) => {1,2}, (3,2,3) => {1,2},
    (3,3,1) => {4,7}, (3,3,2) => {6,8}, (3,3,3) => {7,8}, (3,3,4) => {8,8},
    (3,4,3) => {19,20},
    (4,2,2) => {11,12}, (4,2,3) => {12,12}};
for dkc in {(3,2,1), (3,2,2), (3,2,3), (3,3,1), (3,3,2), (3,3,3), (3,3,4), (3,4,3), (4,2,2), (4,2,3)} do (
    (d, k, c) := dkc;
    S := fermatRing(d, 2*k);
    (L1, L2) := fermatSpaces(k, c);
    a := fermatTangentData(S, {L1, L2}, {1, 1});
    D := fermatPairModP(d, k, c, 30241);
    b := tangentExcess(D, 1);
    b2 := tangentExcess(D, 2);
    th := excessFromData D;
    l0 := D#"lambda0";
    predicted := th#"codimVZ" - (if l0 == 1 then th#"excessAtLambda0" else th#"excessElsewhere");
    expect(toString dkc | " Fermat: {H, K} published; exact Fermat module; tangentExcess mod p; excessFromData mod p",
        {{a#"hodgeCodimension", a#"jointPersistenceCodimension"}, {b#"codimTNL", b#"codimTVZ"}, {predicted, th#"codimVZ"}},
        toList(3 : published#dkc));
    expect(toString dkc | " Fermat: lambda = 2: tangentExcess against excessFromData (Theorem 2(5) at a special point)",
        b2#"excess", th#"excessElsewhere");
    );
finish()
