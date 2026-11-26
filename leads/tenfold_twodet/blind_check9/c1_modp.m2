-- C1 and the Fermat-point version of C6 over ZZ/p, p = 1 mod 3 (the earlier run over toField(QQ[w]/..) is not trusted)
runP = p -> (
    assert(isPrime p and p % 3 == 1);
    kk := ZZ/p;
    w := ((select(toList(2..p-1), t -> (t^3) % p == 1))#0)_kk;
    S := kk[x_0..x_11];
    lf := (i,j,e) -> x_i + w^e*x_j;
    a := lf(0,1,0); c := lf(0,1,1); f := lf(0,1,2);
    b := lf(2,3,0); d := lf(2,3,1); e := lf(2,3,2);
    a' := lf(4,5,0); c' := lf(4,5,1); f' := lf(4,5,2);
    b' := lf(6,7,0); d' := lf(6,7,1); e' := lf(6,7,2);
    A0 := matrix{{a,b,0},{0,c,d},{e,0,f}};
    B0 := matrix{{a',b',0},{0,c',d'},{e',0,f'}};
    l1 := x_8+x_9; Q1 := x_8^2-x_8*x_9+x_9^2;
    l2 := x_10+x_11; Q2 := x_10^2-x_10*x_11+x_11^2;
    Fer := sum(12, i -> x_i^3);
    << "p=" << p << " w=" << w << ": Fermat == detA0+detB0+l1Q1+l2Q2: " << (Fer == det A0 + det B0 + l1*Q1 + l2*Q2) << endl;
    IT := ideal(l1,l2) + minors(2, A0^{0,1}) + minors(2, B0^{0,1});
    pl := (k1,k2,k3,k4) -> ideal(lf(0,1,k1), lf(2,3,k2), lf(4,5,k3), lf(6,7,k4), l1, l2);
    Lsh := {(0,0),(0,1),(1,1)};
    planes := flatten apply(Lsh, u -> apply(Lsh, v -> pl(u#0,u#1,v#0,v#1)));
    U := intersect planes;
    cnt := 0;
    for k in (0,0,0,0)..(2,2,2,2) do if isSubset(IT, pl(k#0,k#1,k#2,k#3)) then cnt = cnt+1;
    << "  T5: affine dim " << dim IT << ", degree " << degree IT << ", I(T5) == intersection of the 9 L-shape planes: " << (IT == U)
       << ", I(T5) radical: " << (radical IT == IT) << ", #planes p(k) in T5 (of 81): " << cnt << ", Fermat in I(T5): " << (Fer % IT == 0) << endl;
    IF := ideal(l1,l2,Q1,Q2) + minors(2,A0) + minors(2,B0);
    J := ideal jacobian ideal Fer;
    aP := (ks) -> (
        prs := {(0,1),(2,3),(4,5),(6,7),(8,9),(10,11)};
        fs := apply(6, t -> lf(prs#t#0, prs#t#1, ks#t));
        gs := apply(6, t -> lf(prs#t#0, prs#t#1, ks#t+1)*lf(prs#t#0, prs#t#1, ks#t+2));
        assert(sum(6, t -> fs#t*gs#t) == Fer);
        det jacobian matrix{fs|gs});
    ad := aP{1,1,1,1,0,0} - aP{1,1,0,2,0,0} - aP{0,2,1,1,0,0} + aP{0,2,0,2,0,0};
    aT := sum flatten apply(Lsh, u -> apply(Lsh, v -> aP{u#0,u#1,v#0,v#1,0,0}));
    Ann := J : ideal(ad);
    << "  Fermat: HF(S/I) = " << toString apply(8, i -> hilbertFunction(i, S/IF)) << ", J in I: " << isSubset(J,IF)
       << ", a_T5 - a_delta2 in J: " << ((aT-ad) % J == 0) << ", a_delta2 * I in J: " << ((ad * gens IF) % J == 0)
       << ", (J:a_delta2) == I: " << (Ann == IF) << endl << flush;
    );
runP 30013; runP 20011; runP 7;
