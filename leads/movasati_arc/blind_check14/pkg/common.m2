needsPackage("HodgeLociCI", FileName => "M2/HodgeLociCI.m2")
readArc = (S, fn) -> (
  ls := select(lines get ("leads/movasati_arc/arcs/" | fn), l -> #l > 0);
  apply(drop(ls, 3), l -> value l))
setupS = p -> (
  S := if p == 0 then fermatRing(3, 8) else fermatRing(3, 8, p);
  S)
runCheck = (p, fn, lam, N) -> (
  S := setupS p; z := fermatRoot S; use S;
  L1 := apply(5, i -> {2*i, 2*i+1, 1});
  L2 := apply(5, i -> {2*i, 2*i+1, if i < 3 then 3 else 1});
  P1 := fermatPeriodPolynomial(S, L1); P2 := fermatPeriodPolynomial(S, L2);
  -- make z visible to value
  global z <- z;
  Ts := readArc(S, fn);
  << "file " << fn << " p=" << p << " terms=" << #Ts << " ring " << toString coefficientRing S << endl;
  t0 := cpuTime();
  C := fermatExpansion(P1 + lam*P2, Ts, N);
  << "  lambda=" << lam << " order " << N << ": nonzero entries per column " << apply(N, j -> #select(flatten entries C_{j}, v -> v != 0)) << " of " << numRows C << "  cpu " << (cpuTime()-t0) << endl;
  Cp := fermatExpansion(P1 + (-lam)*P2, Ts, 1);
  << "  lambda=" << (-lam) << " order 1: nonzero entries " << #select(flatten entries Cp, v -> v != 0) << endl;
  C)
