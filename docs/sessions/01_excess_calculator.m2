needsPackage("HodgeLociCI", FileName => "../../M2/HodgeLociCI.m2");
view = (t, ks) -> netList(apply(ks, k -> {k, t#k}), Alignment => Left);
ks = {"tau", "lambda0", "inRange", "eTau", "codimV1", "codimV2", "codimVZ", "excessAtLambda0", "codimNLAtLambda0", "excessElsewhere"};
-- (1) Movasati's cubic sixfold case: two 3-planes meeting in a point. Three own linear equations each, one shared.
t6 = excessFromDegrees(3, {1,1,1}, {1,1,1}, {1});
view(t6, ks)
t6#"levelDichotomy"
t6#"label"
-- (2) the cubic eightfold case: two 4-planes meeting in a line (two shared linear equations)
t8 = excessFromDegrees(3, {1,1,1}, {1,1,1}, {1,1});
view(t8, ks)
-- (3) the same numbers from data: a random smooth cubic sixfold through two such planes, modulo 32003
D6 = randomCyclePair(3, {1,1,1}, {1,1,1}, {1}, Seed => 2026)
e6 = excessFromData D6;
view(e6, {"eTau", "rankDetM", "dimAnnDetM", "codimVZ", "excessAtLambda0", "codimNLAtLambda0", "excessElsewhere"})
e6#"label"
-- Theorem 2 of paper 3 against a direct first-order computation in the Jacobian ring
v6 = verifyExcess D6;
netList(prepend(v6#"tableColumns", v6#"table"), Alignment => Left)
v6#"agrees"
-- (4) at the Fermat point, exactly over Q(zeta_6): Movasati's pairs (H,K) = (7,8) and (19,20)
planes = (k, c) -> (apply(k+1, i -> {2*i, 2*i+1, 1}), apply(k+1, i -> {2*i, 2*i+1, if i < c then 3 else 1}));
S6 = fermatRing(3, 6); (P1, P2) = planes(3, 3);
f6 = fermatTangentData(S6, {P1, P2}, {1, 1});
view(f6, {"jointPersistenceCodimension", "hodgeCodimension", "excess", "label"})
S8 = fermatRing(3, 8); (P1, P2) = planes(4, 3);
f8 = fermatTangentData(S8, {P1, P2}, {1, -1});
view(f8, {"jointPersistenceCodimension", "hodgeCodimension", "excess", "label"})
-- (5) shared equations of higher degree: two plane conics on a common quadric p = 0, on a sextic surface
ts = excessFromDegrees(6, {1}, {1}, {2});
view(ts, ks)
Ds = randomCyclePair(6, {1}, {1}, {2}, Seed => 2026)
vs = verifyExcess Ds;
netList(prepend(vs#"tableColumns", vs#"table"), Alignment => Left)
-- (6) a quartic fourfold, a plane and a quadric surface with one shared linear equation (c = 2)
tq = excessFromDegrees(4, {1,1}, {1,2}, {1});
view(tq, ks)
