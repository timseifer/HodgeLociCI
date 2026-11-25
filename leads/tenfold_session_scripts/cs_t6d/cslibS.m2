-- CS-T6D: streamed-kernel version of cs_t6/cslib.m2 csCodimPk (same math; never forms the full syzygy matrix M).
-- Hom'_0 = ker M, computed as K <- K * nullSpace(Qbatch * K) over batches of syzygy rows (dense flint mutable matrices).
csCodimPkS = (F, I, kd, batchRows) -> (
    nl := 11 - kd; outs := toList(kd+1..11);
    t0 := cpuTime();
    Sp := kk[z_0..z_kd]; toP := map(Sp, S, (gens Sp) | toList(nl:0_Sp)); back := map(S, Sp, take(gens S, kd+1));
    Ip := trim toP I; g := mingens Ip; r := numColumns g; G := gb Ip; A := Sp/Ip;
    dg := apply(r, i -> first degree g_(0,i));
    sy := syz g; s := numColumns sy; sdeg := apply(s, k -> (degrees source sy)#k#0);
    Bs := apply(r, i -> lift(basis(dg#i, A), Sp));
    offs := {0} | accumulate(plus, 0, apply(Bs, numColumns)); N := last offs;
    pr("  r = " | toString r | ", dg " | toString dg | ", N = " | toString N | ", #syz = " | toString s | ", syz degrees " | toString tally sdeg);
    K := null; totRows := 0; batch := {}; nb := 0;
    doBatch := () -> (
        if #batch == 0 then return;
        Qb := fold((a,b) -> a || b, batch); batch = {}; nb = nb + 1;
        Am := mutableMatrix Qb; Qb = null;
        if K === null then K = nullSpace Am
        else if numColumns K > 0 then (C := Am * K; X := nullSpace C; K = K * X);
        Am = null; collectGarbage();
        pr("   batch " | toString nb | ": rows so far " | toString totRows | ", dim K = " | toString numColumns K | "  t " | toString(cpuTime()-t0)));
    brows := 0;
    for e in unique sdeg do (
       ks := select(s, k -> sdeg#k == e); Ek := lift(basis(e, A), Sp); ne := numColumns Ek;
       if ne == 0 then continue;
       for k in ks do (
          P := matrix{flatten apply(r, i -> flatten entries (sy_(i,k) * Bs#i))};
          Q := lift(last coefficients(P % G, Monomials => Ek), kk);   -- ne x N
          batch = append(batch, Q); brows = brows + ne; totRows = totRows + ne;
          if brows >= batchRows then (doBatch(); brows = 0)));
    doBatch();
    pr("  M (streamed) " | toString totRows | " x " | toString N | " in " | toString nb | " batches, time " | toString(cpuTime()-t0));
    K = matrix K;
    -- (v2) check: K satisfies every syzygy relation (K inside Hom'(I, S/I)_0)
    Ks := sub(K, Sp);
    -- (v2') from 01:31Z: check a random linear combination of the kernel columns (all columns before; too slow across reboots)
    Kr := Ks * sub(random(kk^(numColumns K), kk^1), Sp);
    Phi := matrix apply(r, i -> {(Bs#i) * Kr^{offs#i .. offs#i + numColumns(Bs#i) - 1}});
    chk := (matrix{flatten entries ((transpose sy) * Phi)}) % G;
    pr("  (v2') random combination of kernel satisfies all syzygies: " | toString(chk == 0));
    L1 := lift(basis(1, A), Sp); n1 := numColumns L1;
    pr("  [Pk] Hom'_0 = " | toString numColumns K | " + " | toString nl | " x " | toString n1 | " = " | toString(numColumns K + nl*n1) | "  time " | toString(cpuTime()-t0));
    Fp := toP F; c := Fp // g;
    I3list := flatten apply(select(flatten entries g, gg -> first degree gg <= 3), gg -> apply(flatten entries basis(3 - first degree gg, Sp), mm -> back(gg * mm))) | flatten apply(outs, a -> apply(flatten entries basis(2, S), mm -> S_a * mm));
    polys := I3list;
    Qrow := map(Sp^1, Sp^(numColumns K), 0);
    for i from 0 to r-1 do (if dg#i <= 3 and c_(i,0) != 0 and numColumns(Bs#i) > 0 then Qrow = Qrow + c_(i,0) * ((Bs#i) * Ks^{offs#i .. offs#i + numColumns(Bs#i) - 1}));
    Qrow = Qrow % G; polys = polys | select(flatten entries back(Qrow), q -> q != 0);
    for a in outs do (Ra := toP diff(S_a, F); for b from 0 to n1-1 do polys = append(polys, back(Ra * L1_(0,b))));
    m3 := basis(3, S); cf := M -> lift(last coefficients(M, Monomials => m3), kk);
    JS1 := flatten entries ((jacobian matrix{{F}}) * vars S);
    r0 := rank mutableMatrix cf(matrix{I3list | JS1}); r1 := rank mutableMatrix cf(matrix{polys | JS1});
    pr("  codim without V-moduli = " | toString(364 - r0) | "; WITH Hom_0 = " | toString(364 - r1) | "  total time " | toString(cpuTime()-t0));
    (364 - r0, 364 - r1, numColumns K + nl*n1));
