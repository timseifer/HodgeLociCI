needsPackage("HodgeLociCI", FileName => "/home/claude/hodgelocici/M2/HodgeLociCI.m2");
for typ in {({1,1,1},{1,1,1},{1}), ({1,1},{1,1},{1,1})} do (
  D = randomCyclePair(3, typ#0, typ#1, typ#2, Seed => 11);
  for lam in {2, 1} do (
    r = secondOrderObstruction(D, lam);
    print(toString typ, lam, r#"verdict", r#"excess", r#"rankOfQuadrics", r#"commonZeroLocusDim", r#"arithmetic");
  ));
