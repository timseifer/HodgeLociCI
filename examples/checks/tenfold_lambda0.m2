-- examples/checks/tenfold_lambda0.m2: first-order excess for two 5-planes meeting in a P^2 on a cubic tenfold
-- (d,k,c) = (3,5,3): at the Fermat point (Movasati's pair) and at random points of V_Z (MOD 32029).
-- Run from the repository root: M2 --script examples/checks/tenfold_lambda0.m2  (each random point ~30 min CPU).
-- AI-written, unreviewed. Random points are NOT checked for smoothness (CheckSmooth => false).
needsPackage("HodgeLociCI", FileName => "M2/HodgeLociCI.m2");
load "tests/validation/common.m2";
out = (name, val) -> (print("RESULT " | name | " " | toString val); stdio << flush);
t0 = cpuTime();
Fm = fermatPairModP(3, 5, 3, 32029);
out("fermat.lambda0", Fm#"lambda0");
for l in {1, -1, 2, 1/2} do out("fermat.excess(" | toString l | ")", (tangentExcess(Fm, l))#"excess" | " cpu " | toString(cpuTime()-t0));
for s in {1031, 1032} do (
  D = randomCyclePair(3, {1,1,1}, {1,1,1}, {1,1,1}, Seed => s, CheckSmooth => false);
  out("general.seed" | toString s | ".lambda0", D#"lambda0");
  for l in {1, -1, 2, 1/2} do out("general.seed" | toString s | ".excess(" | toString l | ")", toString((tangentExcess(D, l))#"excess") | " cpu " | toString(cpuTime()-t0));
  );
