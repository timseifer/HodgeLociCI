needsPackage("HodgeLociCI", FileName => "../../M2/HodgeLociCI.m2");
ones = n -> toList(n : 1);
-- the Hodge level of a cubic sixfold (a separate helper; it is not the level tau below)
primitiveHodgeNumbers(6, 3), hodgeLevel(6, 3)
-- two 3-planes on a cubic sixfold meeting in dimension 3 - c, for c = 1, 2, 3, 4: the level tau = 2c - (c-1)d
rows = for c from 1 to 4 list (
    t := excessFromDegrees(3, ones c, ones c, ones(4-c));
    {c, t#"tau", t#"lambda0", t#"eTau", t#"codimVZ", t#"codimNLAtLambda0", t#"excessElsewhere"});
netList(prepend({"c", "tau", "lambda0", "e_tau", "codim V_Z", "codim NL at lambda0", "excess elsewhere"}, rows), Alignment => Left)
-- the two sides of the dichotomy, as the package states them
(excessFromDegrees(3, ones 4, ones 4, {}))#"levelDichotomy"
(excessFromDegrees(3, ones 3, ones 3, ones 1))#"levelDichotomy"
-- side tau < 0, checked directly: two disjoint 3-planes on a random cubic sixfold (mod 32003)
Dneg = randomCyclePair(3, ones 4, ones 4, {}, Seed => 5)
apply({1, -1, 2, 5/3}, l -> (tangentExcess(Dneg, l))#"excess")
-- side tau >= 0, checked directly: two 3-planes meeting in a point
Dpos = randomCyclePair(3, ones 3, ones 3, ones 1, Seed => 5)
apply({1, -1, 2, 5/3}, l -> (tangentExcess(Dpos, l))#"excess")
(tangentExcess(Dpos, 2))#"label"
-- outside "the range" the degrees do not determine the excess away from lambda0: cubic tenfolds, two 5-planes
-- meeting in a plane (the case of Kloosterman's Theorem 1.2)
t10 = excessFromDegrees(3, ones 3, ones 3, ones 3);
t10#"tau", t10#"inRange", t10#"excessAtLambda0", t10#"excessElsewhere", t10#"excessElsewhereBounds"
-- at a random point the excess away from lambda0 = 1 is 0 ...
D10 = randomCyclePair(3, ones 3, ones 3, ones 3, Seed => 5)
e10 = excessFromData D10; e10#"eTau", e10#"rankDetM", e10#"excessAtLambda0", e10#"excessElsewhere"
-- ... and at the Fermat point it is 1 for every coefficient (Movasati's pair (38,39)), exactly:
S10 = fermatRing(3, 10);
P1 = apply(6, i -> {2*i, 2*i+1, 1}); P2 = apply(6, i -> {2*i, 2*i+1, if i < 3 then 3 else 1});
f10 = fermatTangentData(S10, {P1, P2}, {1, 2}); f10#"jointPersistenceCodimension", f10#"hodgeCodimension", f10#"label"
-- the classification for two linear subspaces at a general point (paper 3, Theorem 9.7)
(linearSubspaceCase(3, 3, 4))#"statement"
(linearSubspaceCase(3, 3, 3))#"statement"
(linearSubspaceCase(3, 5, 3))#"statement"
