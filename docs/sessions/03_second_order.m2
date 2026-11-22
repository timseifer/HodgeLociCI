needsPackage("HodgeLociCI", FileName => "../../M2/HodgeLociCI.m2");
-- a cubic sixfold through two 3-planes meeting in a line: tau = 1, lambda0 = -1, two excess directions for every lambda
D = randomCyclePair(3, {1,1}, {1,1}, {1,1}, Seed => 7)
apply({-1, 2, 5/3}, l -> (tangentExcess(D, l))#"excess")
-- second order at lambda = 2: do the two excess directions survive?
so = secondOrderObstruction(D, 2);
so#"verdict", so#"excess", so#"dimK", so#"rankOfQuadrics", so#"commonZeroLocusDim"
so#"quadrics"
so#"statement"
so#"label"
-- the same question answered by the pointwise residue formula as well
(secondOrderObstruction(D, 5/3, Strategy => "Both"))#"strategiesAgree"
-- at lambda0 = -1 nothing is obstructed
s0 = secondOrderObstruction(D, -1); s0#"verdict"
s0#"statement"
-- Maclean's example, exactly over QQ: two coplanar lines on a quintic surface (k = 1, c = 1; the plane is shared)
Dq = randomCyclePair(5, {1}, {1}, {1}, CoefficientRing => QQ, Seed => 7)
(tangentExcess(Dq, 2))#"codimTVZ", (tangentExcess(Dq, 2))#"codimTNL"
sq = secondOrderObstruction(Dq, 2); sq#"verdict", sq#"values", sq#"arithmetic"
(secondOrderObstruction(Dq, 1))#"verdict"
