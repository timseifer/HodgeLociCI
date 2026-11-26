-- Q1(b): count N = length( Sigma n Sing(V) ) for a random cubic V in H containing Sigma.  MOD p
doit = (nm, p, n, mk, expectedN) -> (
    R := ZZ/p[x_0..x_n];
    I := mk(R);
    g := flatten entries mingens I;
    f := sum apply(g, gi -> gi * random(3 - first degree gi, R));
    J := ideal jacobian ideal f;
    Zs := I + J;
    cd := codim Zs;
    dg := if cd == n then degree Zs else -1;
    -- total singular scheme of V (to see whether V has other singularities)
    cdJ := codim J; dJ := degree J;
    -- reducedness of the zero scheme: compare with radical degree
    rd := if cd == n then degree radical Zs else -1;
    << nm << " MOD " << p << ": dim Sigma=" << dim I - 1 << " deg Sigma=" << degree I << "; codim(Sigma n SingV)=" << cd << " (n=" << n << "), N=length=" << dg << ", reduced length=" << rd << ", expected " << expectedN << "; Sing V: codim " << cdJ << " degree " << dJ << endl;
    )
scan({32003, 31991}, p -> (
  doit("plane in P4 (k=2)", p, 4, R -> ideal(R_0,R_1), 4);
  doit("cubic scroll in P4 (k=2)", p, 4, R -> minors(2, matrix{{R_0,R_1,R_3},{R_1,R_2,R_4}}), 6);
  doit("P3 in P6 (k=3)", p, 6, R -> ideal(R_0,R_1,R_2), 8);
  doit("P1xP2 in P5 in P6 (k=3)", p, 6, R -> minors(2, matrix{{R_0,R_1,R_2},{R_3,R_4,R_5}}) + ideal(R_6), 12);
  doit("V5=G(2,5)nP6 (k=3)", p, 6, R -> pfaffians(4, (M := random(R^5, R^{5:-1}); M - transpose M)), 14);
  doit("P2xP2 in P8 (k=4)", p, 8, R -> minors(2, genericMatrix(R,3,3)), 36);
  doit("P4 in P8 (k=4)", p, 8, R -> ideal(R_0,R_1,R_2,R_3), 16);
  ))
