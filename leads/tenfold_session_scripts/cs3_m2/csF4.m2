-- CS3-M2: variant of cs2_t6/cslibS2.m2 csCodimPkS2 for Z spanning P^11 (kd = 11) with a Groebner basis computed by F4
-- (Algorithm => LinearAlgebra) and standard monomials from its lead terms (no quotient ring, no Buchberger GB of I_Z).
-- Inputs: F, g (1 x r matrix of MINIMAL generators of I_Z), Gm (matrix: a GB of I_Z), batchRows, sdl (syzygy DegreeLimit; 0 = none).
-- Same mathematics as csCodimPkS2 (Hom'(I_Z, S/I_Z)_0 = ker of the syzygy conditions, image in S_3, rank with I_Z(3) and J S_1).
-- sdl > 0 truncates syzygies: fewer conditions, so the computed Hom_0 CONTAINS the true one and the codim is a LOWER bound.
csCodimF4 = (F, g, Gm, batchRows, sdl) -> (
    t0 := cpuTime(); r := numColumns g;
    G := forceGB Gm; LT := ideal leadTerm Gm; SL := S/LT;
    stdb := e -> lift(basis(e, SL), S);
    dg := apply(r, i -> first degree g_(0,i));
    sy := if sdl > 0 then syz(g, DegreeLimit => sdl) else syz g; s := numColumns sy; sdeg := apply(s, k -> (degrees source sy)#k#0);
    Bs := apply(r, i -> stdb(dg#i));
    offs := {0} | accumulate(plus, 0, apply(Bs, numColumns)); N := last offs;
    pr("  [F4] r = " | toString r | ", dg " | toString dg | ", N = " | toString N | ", #syz = " | toString s | ", syz degrees " | toString tally sdeg | "  t " | toString(cpuTime()-t0));
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
       ks := select(s, k -> sdeg#k == e); Ek := stdb(e); ne := numColumns Ek;
       if ne == 0 then continue;
       for k in ks do (
          P := matrix{flatten apply(r, i -> flatten entries (sy_(i,k) * Bs#i))};
          Q := lift(last coefficients(P % G, Monomials => Ek), kk);
          batch = append(batch, Q); brows = brows + ne; totRows = totRows + ne;
          if brows >= batchRows then (doBatch(); brows = 0)));
    doBatch();
    pr("  M (streamed) " | toString totRows | " x " | toString N | " in " | toString nb | " batches, time " | toString(cpuTime()-t0));
    K = matrix K;
    Kr := K * random(kk^(numColumns K), kk^1);
    Phi := matrix apply(r, i -> {(Bs#i) * sub(Kr^{offs#i .. offs#i + numColumns(Bs#i) - 1}, S)});
    chk := (matrix{flatten entries ((transpose sy) * Phi)}) % G;
    pr("  (v2') random combination of kernel satisfies all (used) syzygies: " | toString(chk == 0));
    pr("  [F4] Hom'_0 = " | toString numColumns K | "  time " | toString(cpuTime()-t0));
    -- F as a combination of the generators of degree <= 3, by linear algebra in S_3 (no Buchberger division)
    low := select(r, i -> dg#i <= 3); m3b := basis(3, S);
    colsL := flatten apply(low, i -> apply(flatten entries basis(3 - dg#i, S), mm -> (i, mm)));
    Mc := lift(last coefficients(matrix{apply(colsL, im -> im#1 * g_(0, im#0))}, Monomials => m3b), kk);
    xs := solve(Mc, lift(last coefficients(matrix{{F}}, Monomials => m3b), kk));
    c := map(S^r, S^1, (i, j) -> sum(#colsL, l -> if (colsL#l)#0 == i then xs_(l,0) * (colsL#l)#1 else 0_S));
    pr("  F = sum c_i g_i check: " | toString((matrix{{F}} - g * c) == 0));
    Ks := sub(K, S);
    I3list := flatten apply(select(flatten entries g, gg -> first degree gg <= 3), gg -> apply(flatten entries basis(3 - first degree gg, S), mm -> gg * mm));
    Qrow := map(S^1, S^(numColumns K), 0);
    for i from 0 to r-1 do (if dg#i <= 3 and c_(i,0) != 0 and numColumns(Bs#i) > 0 then Qrow = Qrow + c_(i,0) * ((Bs#i) * Ks^{offs#i .. offs#i + numColumns(Bs#i) - 1}));
    Qrow = Qrow % G;
    polys := I3list | select(flatten entries Qrow, q -> q != 0);
    B3A := stdb(3); HF3 := numColumns B3A;
    imgs := flatten entries Qrow;
    rk := if #imgs == 0 then 0 else rank mutableMatrix lift(last coefficients(matrix{imgs}, Monomials => B3A), kk);
    nZX = numColumns K - rk; hf3Z = HF3;
    pr("  [CS2] HF_Z(3) = " | toString HF3 | ", rank(Hom_0 -> (S/I_Z)_3) = " | toString rk | ", h0(N_{Z/X}) first order = " | toString nZX);
    m3 := basis(3, S); cf := M -> lift(last coefficients(M, Monomials => m3), kk);
    JS1 := flatten entries ((jacobian matrix{{F}}) * vars S);
    r0 := rank mutableMatrix cf(matrix{I3list | JS1}); r1 := rank mutableMatrix cf(matrix{polys | JS1});
    pr("  codim without moduli = " | toString(364 - r0) | "; WITH Hom_0 = " | toString(364 - r1) | "  total time " | toString(cpuTime()-t0));
    (364 - r0, 364 - r1, numColumns K));
