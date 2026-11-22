-- examples/quickstart.m2: a smoke test with machine-readable output.
-- Run from the repository root:   M2 --script examples/quickstart.m2
-- Every line of interest starts with "RESULT "; compare with examples/quickstart.expected.
needsPackage("HodgeLociCI", FileName => "M2/HodgeLociCI.m2");
out = (name, val) -> print("RESULT " | name | " " | toString val);

-- 1. Excess calculator by degrees: two 3-planes meeting in a point on a cubic sixfold (c = 3).
r = excessFromDegrees(3, {1,1,1}, {1,1,1}, {1});
scan({"tau", "lambda0", "eTau", "codimVZ", "codimNLAtLambda0", "excessAtLambda0", "excessElsewhere", "inRange"},
     key -> out("sixfold." | key, r#key));

-- 2. The level dichotomy on the other side: two 4-planes meeting in a point on a cubic eightfold (tau < 0).
t = excessFromDegrees(3, {1,1,1,1}, {1,1,1,1}, {1});
out("eightfold_point.tau", t#"tau");
out("eightfold_point.excessAtLambda0", t#"excessAtLambda0");

-- 3. The same sixfold case at a random point (MOD p), compared with an independent first-order computation.
Y = randomCyclePair(3, {1,1,1}, {1,1,1}, {1}, Seed => 7);
out("sixfold.verifyExcess.agrees", (verifyExcess Y)#"agrees");

-- 4. Second-order check: the excess direction dies at lambda = 2 and survives at lambda_0 = 1.
out("sixfold.secondOrder.lambda2", (secondOrderObstruction(Y, 2))#"verdict");
out("sixfold.secondOrder.lambda1", (secondOrderObstruction(Y, 1))#"verdict");

-- 5. First-order utility: tangent codimension of the Hodge locus of a degree-9 threefold in a sum of two determinants.
setRandomSeed 11;
S = ZZ/32003[x_0..x_7];
A = random(S^3, S^{3:-1}); B = random(S^3, S^{3:-1});
h = hodgeLocusTangentCodim(det A + det B, minors(2, A^{0,1}) + minors(2, B^{0,1}));
out("twoDeterminants.codim", h#"codim");

-- 6. Hodge numbers and Hodge level of a cubic sixfold.
out("cubicSixfold.primitiveHodgeNumbers", primitiveHodgeNumbers(6, 3));
out("cubicSixfold.hodgeLevel", hodgeLevel(6, 3));

-- 7. Fermat point: re-verify one certificate shipped with the package (an obstruction at order 5, EXACT).
cert = "M2/HodgeLociCI/data/cert_n6_lam2.txt";
v = fermatVerifyCertificate cert;
out("fermat.cert_n6_lam2.pass", v#"pass");
out("fermat.cert_n6_lam2.vanishingOrder", v#"vanishingOrder");
out("fermat.cert_n6_lam2.obstructionOrder", v#"obstructionOrder");
