needsPackage("HodgeLociCI", FileName => "/home/claude/hodgelocici/M2/HodgeLociCI.m2");
S = fermatRing(3, 6); x = gens S;
P1 = fermatPeriodPolynomial(S, {{0,1,1},{2,3,1},{4,5,1},{6,7,1}});
P2 = fermatPeriodPolynomial(S, {{0,1,3},{2,3,3},{4,5,3},{6,7,1}});
for lam in {-1, 2, 1} do for T in {x_1*x_3*x_5, x_0*x_2*x_4, x_1*x_3*x_7, x_0*x_2*x_6} do (
  r := try fermatExtendArc(P1 + lam*P2, {T}, 7) else null;
  if r === null then print("RESULT lam " | toString lam | " T " | toString T | " : not in ker L / error")
  else print("RESULT lam " | toString lam | " T " | toString T | " order " | toString(r#"order") | " obstructedAt " | toString(r#"obstructedAtOrder"));
  stdio << flush);
