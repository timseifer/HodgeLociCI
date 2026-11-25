-- CS-T6: memory-lean copy of w1lib.m2 w1codimP8 (Hom images as one matrix product)
csCodimP8 = (F, I) -> (
    t0 := cpuTime();
    Sp := kk[z_0..z_8]; toP := map(Sp, S, (gens Sp) | {0_Sp,0_Sp,0_Sp}); back := map(S, Sp, take(gens S, 9));
    Ip := trim toP I; g := mingens Ip; r := numColumns g; G := gb Ip; A := Sp/Ip;
    dg := apply(r, i -> first degree g_(0,i));
    sy := syz g; s := numColumns sy; sdeg := apply(s, k -> (degrees source sy)#k#0);
    Bs := apply(r, i -> lift(basis(dg#i, A), Sp));
    offs := {0} | accumulate(plus, 0, apply(Bs, numColumns)); N := last offs;
    rowsList := {};
    for e in unique sdeg do (
       ks := select(s, k -> sdeg#k == e); Ek := lift(basis(e, A), Sp); ne := numColumns Ek;
       if ne == 0 then continue;
       -- one big row of polynomials: for each k in ks, each column block i
       P := matrix{flatten apply(ks, k -> flatten apply(r, i -> flatten entries (sy_(i,k) * Bs#i)))};
       Q := lift(last coefficients(P % G, Monomials => Ek), kk);   -- ne x (#ks * N)
       rowsList = rowsList | apply(#ks, a -> Q_{a*N .. (a+1)*N - 1}));
    pr("  rows built " | toString(cpuTime()-t0));
    M := fold((a,b) -> a || b, rowsList);
    pr("  M " | toString numRows M | " x " | toString numColumns M | " " | toString(cpuTime()-t0));
    K := matrix nullSpace mutableMatrix M;
    L1 := lift(basis(1, A), Sp); n1 := numColumns L1;
    pr("  [P8] Hom'_0 = " | toString numColumns K | " + 3 x " | toString n1 | " = " | toString(numColumns K + 3*n1) | "  time " | toString(cpuTime()-t0));
    Fp := toP F; c := Fp // g; pr("  lift done " | toString(cpuTime()-t0));
    pr("  deg-3 part start " | toString(cpuTime()-t0));
    I3list := flatten apply(select(flatten entries g, gg -> first degree gg <= 3), gg -> apply(flatten entries basis(3 - first degree gg, Sp), mm -> back(gg * mm))) | flatten apply({9,10,11}, a -> apply(flatten entries basis(2, S), mm -> S_a * mm));
    polys := I3list; pr("  deg-3 part " | toString(#polys) | " " | toString(cpuTime()-t0));
    Ks := sub(K, Sp); Qrow := map(Sp^1, Sp^(numColumns K), 0);
    pr("  r = " | toString r | ", dg " | toString dg | ", block sizes " | toString apply(Bs, numColumns));
    for i from 0 to r-1 do (if dg#i <= 3 and c_(i,0) != 0 and numColumns(Bs#i) > 0 then Qrow = Qrow + c_(i,0) * ((Bs#i) * Ks^{offs#i .. offs#i + numColumns(Bs#i) - 1}); pr("   block " | toString i | " " | toString(cpuTime()-t0)));
    pr("  Qrow summed " | toString(cpuTime()-t0)); Qrow = Qrow % G; polys = polys | select(flatten entries back(Qrow), q -> q != 0);
    pr("  Hom images built " | toString(cpuTime()-t0));
    for a from 9 to 11 do (Ra := toP diff(S_a, F); for b from 0 to n1-1 do polys = append(polys, back(Ra * L1_(0,b))));
    m3 := basis(3, S); cf := M -> lift(last coefficients(M, Monomials => m3), kk);
    JS1 := flatten entries ((jacobian matrix{{F}}) * vars S); w1TFpolys = polys | JS1;
    r0 := rank mutableMatrix cf(matrix{I3list | JS1}); r1 := rank mutableMatrix cf(matrix{polys | JS1});
    pr("  codim without V-moduli = " | toString(364 - r0) | "; WITH Hom_0 = " | toString(364 - r1) | "  total time " | toString(cpuTime()-t0));
    (364 - r0, 364 - r1, numColumns K + 3*n1));

-- general version: I contains x_(kd+1)..x_11 (cycle inside P^kd)
csCodimPk = (F, I, kd) -> (
    nl := 11 - kd; outs := toList(kd+1..11);
    t0 := cpuTime();
    Sp := kk[z_0..z_kd]; toP := map(Sp, S, (gens Sp) | toList(nl:0_Sp)); back := map(S, Sp, take(gens S, kd+1));
    Ip := trim toP I; g := mingens Ip; r := numColumns g; G := gb Ip; A := Sp/Ip;
    dg := apply(r, i -> first degree g_(0,i));
    sy := syz g; s := numColumns sy; sdeg := apply(s, k -> (degrees source sy)#k#0);
    Bs := apply(r, i -> lift(basis(dg#i, A), Sp));
    offs := {0} | accumulate(plus, 0, apply(Bs, numColumns)); N := last offs;
    rowsList := {};
    for e in unique sdeg do (
       ks := select(s, k -> sdeg#k == e); Ek := lift(basis(e, A), Sp); ne := numColumns Ek;
       if ne == 0 then continue;
       -- one big row of polynomials: for each k in ks, each column block i
       P := matrix{flatten apply(ks, k -> flatten apply(r, i -> flatten entries (sy_(i,k) * Bs#i)))};
       Q := lift(last coefficients(P % G, Monomials => Ek), kk);   -- ne x (#ks * N)
       rowsList = rowsList | apply(#ks, a -> Q_{a*N .. (a+1)*N - 1}));
    pr("  rows built " | toString(cpuTime()-t0));
    M := fold((a,b) -> a || b, rowsList);
    pr("  M " | toString numRows M | " x " | toString numColumns M | " " | toString(cpuTime()-t0));
    K := matrix nullSpace mutableMatrix M;
    L1 := lift(basis(1, A), Sp); n1 := numColumns L1;
    pr("  [Pk] Hom'_0 = " | toString numColumns K | " + " | toString nl | " x " | toString n1 | " = " | toString(numColumns K + nl*n1) | "  time " | toString(cpuTime()-t0));
    Fp := toP F; c := Fp // g; pr("  lift done " | toString(cpuTime()-t0));
    pr("  deg-3 part start " | toString(cpuTime()-t0));
    I3list := flatten apply(select(flatten entries g, gg -> first degree gg <= 3), gg -> apply(flatten entries basis(3 - first degree gg, Sp), mm -> back(gg * mm))) | flatten apply(outs, a -> apply(flatten entries basis(2, S), mm -> S_a * mm));
    polys := I3list; pr("  deg-3 part " | toString(#polys) | " " | toString(cpuTime()-t0));
    Ks := sub(K, Sp); Qrow := map(Sp^1, Sp^(numColumns K), 0);
    pr("  r = " | toString r | ", dg " | toString dg | ", block sizes " | toString apply(Bs, numColumns));
    for i from 0 to r-1 do (if dg#i <= 3 and c_(i,0) != 0 and numColumns(Bs#i) > 0 then Qrow = Qrow + c_(i,0) * ((Bs#i) * Ks^{offs#i .. offs#i + numColumns(Bs#i) - 1}); pr("   block " | toString i | " " | toString(cpuTime()-t0)));
    pr("  Qrow summed " | toString(cpuTime()-t0)); Qrow = Qrow % G; polys = polys | select(flatten entries back(Qrow), q -> q != 0);
    pr("  Hom images built " | toString(cpuTime()-t0));
    for a in outs do (Ra := toP diff(S_a, F); for b from 0 to n1-1 do polys = append(polys, back(Ra * L1_(0,b))));
    m3 := basis(3, S); cf := M -> lift(last coefficients(M, Monomials => m3), kk);
    JS1 := flatten entries ((jacobian matrix{{F}}) * vars S); w1TFpolys = polys | JS1;
    r0 := rank mutableMatrix cf(matrix{I3list | JS1}); r1 := rank mutableMatrix cf(matrix{polys | JS1});
    pr("  codim without V-moduli = " | toString(364 - r0) | "; WITH Hom_0 = " | toString(364 - r1) | "  total time " | toString(cpuTime()-t0));
    (364 - r0, 364 - r1, numColumns K + nl*n1));
