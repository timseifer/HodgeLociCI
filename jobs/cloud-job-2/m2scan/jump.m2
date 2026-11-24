-- cloud-job-2 (PK2): verbatim copy of discovery t6_unsolved/c/jump.m2 (team T6c), only the package path made relative (run with the working directory jobs/cloud-job-2/m2scan).
-- [TOOLING] general points of the divisor J = {det(.det M : A_tau -> A_d) = 0} inside V_Z (target families: sigma' = d, square map)
-- method: fixed random f,h,p,s; a random line M(t) = M0 + t M1; det of the multiplication matrix as a polynomial in t;
-- every root t0 in the prime field gives a point of J on that line (general point of J for a random line).
needsPackage("HodgeLociCI", FileName => "../../../M2/HodgeLociCI.m2");
jumpPoints = method(Options => {Seed => 1, CoefficientRing => ZZ/32003, Height => 3, MaxRoots => 2})
jumpPoints(ZZ, List, List, List) := opts -> (d, F, H, P) -> (
  D0 := randomCyclePair(d, F, H, P, Seed => opts.Seed, CheckSmooth => false, CoefficientRing => opts.CoefficientRing, Height => opts.Height);
  D1 := randomCyclePair(d, F, H, P, Seed => opts.Seed + 1000, CheckSmooth => false, CoefficientRing => opts.CoefficientRing, Height => opts.Height);
  S := D0#"ring"; f := D0#"f"; h := D0#"h"; p := D0#"p"; s := D0#"s"; M0 := D0#"M";
  M1 := sub(D1#"M", S);
  c := #f; tau := D0#"tau"; kk := coefficientRing S;
  I := ideal(f | h | p | s); G := gb I;
  T := kk[symbol t];
  Ba := flatten entries lift(basis(tau, S/I), S);
  Bd := lift(basis(d, S/I), S);
  if #Ba != numColumns Bd then error "not square";
  coords := u -> sub(last coefficients(u % G, Monomials => Bd), kk);
  -- det M(t) = sum_j t^j D_j
  Ss := S[symbol u]; Mt := sub(M0, Ss) + Ss_0 * sub(M1, Ss);
  dt := det Mt; Dj := apply(c+1, j -> sub(coefficient(Ss_0^j, dt), S));
  mats := apply(Dj, Q -> fold((a,b) -> a | b, apply(Ba, b -> coords(b*Q))));
  MatT := sum(c+1, j -> (T_0)^j * sub(mats#j, T));
  dp := det MatT;
  if dp == 0 then return {"IDENTICALLY ZERO", {}};
  fac := select(toList factor dp, u -> first degree u#0 == 1);
  roots := apply(fac, u -> - (coefficient(1_T, u#0)) / (coefficient(T_0, u#0)));
  roots = take(roots, opts.MaxRoots);
  {"deg " | toString first degree dp | " linear factors " | toString(#fac),
   apply(roots, t0 -> (try cyclePair(f, h, p, M0 + t0 * M1, s) else "SINGULAR"))}
);
