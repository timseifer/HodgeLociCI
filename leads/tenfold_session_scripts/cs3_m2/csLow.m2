-- CS3-M2: LOWER BOUND for the family codim WITH Hom_0 when the full Hom(I_Z, S/I_Z)_0 is too large (N ~ 38000 for the generic double structure).
-- ARG: the tangent space of {X containing a deformation of Z} at X is I_Z(3) + {psi(F) : psi in Hom(I_Z,S/I_Z)_0}, and psi(F) = sum c_i psi(g_i)
-- involves only the generators g_i of degree <= 3 (F in I_Z(3)). Every genuine psi satisfies the syzygies AMONG these low generators; imposing
-- only those (up to degree smax) gives a SUPERSET of the possible tuples (psi(g_i))_{deg <= 3}, hence a superset of the tangent space and a
-- LOWER bound on the codim. If this lower bound is 55 (= codim F_T), the family codim is not 54.
-- Inputs: F, gl (1 x r, the minimal generators of degree <= 3), G (forced GB of the full I_Z), LT (its lead-term ideal), smax, batchRows.
csLowBound = (F, gl, G, LT, smax, batchRows, ntr) -> (
    t0 := cpuTime(); r := numColumns gl; SL := S/LT; stdb := e -> lift(basis(e, SL), S);
    dg := apply(r, i -> first degree gl_(0,i)); d0 := min dg;
    Bs := apply(r, i -> stdb(dg#i)); offs := {0} | accumulate(plus, 0, apply(Bs, numColumns)); N := last offs;
    pr("  [low] r = " | toString r | ", dg " | toString tally dg | ", N = " | toString N);
    K := null; totRows := 0; nb := 0; prevSyz := null; prevIdx := null; nsyzTot := 0; newc := {};
    for s from d0 + 1 to smax do (
        -- column index (i, monomial) of degree s
        idx := flatten apply(r, i -> if dg#i > s then {} else apply(flatten entries basis(s - dg#i, S), mm -> (i, mm)));
        pos := new MutableHashTable; scan(#idx, l -> pos#(idx#l) = l);
        Ms := lift(last coefficients(matrix{apply(idx, im -> im#1 * gl_(0, im#0))}, Monomials => basis(s, S)), kk);
        Ks := gens ker Ms;   -- all syzygies of degree s (columns over idx)
        -- syzygies used: if few, the minimal ones (x_j * lower ones removed); if many (#Ks > 400), ntr RANDOM combinations of all of them.
        -- Using fewer conditions is always SOUND for the lower bound (superset of tuples); random combinations of all syzygies of degree s,
        -- together with the conditions already imposed in lower degrees, give all degree-s conditions once ntr >= #(minimal syzygies of degree s).
        if numColumns Ks > 400 then (
            Ks = Ks * random(kk^(numColumns Ks), kk^ntr); newc = toList(0 .. ntr - 1);
            pr("  [low] degree " | toString s | ": " | toString ntr | " random combinations of all syzygies  t " | toString(cpuTime()-t0)))
        else (
        Os := if prevSyz === null or numColumns prevSyz == 0 then map(kk^(#idx), kk^0, 0) else (
            cols := flatten apply(numColumns prevSyz, c -> apply(numgens S, j -> (
                v := mutableMatrix(kk, #idx, 1);
                for l from 0 to #prevIdx - 1 do (a := prevSyz_(l, c); if a != 0 then (im := prevIdx#l; v_(pos#(im#0, S_j * im#1), 0) = a));
                matrix v)));
            fold((a, b) -> a | b, cols));
        ro := if numColumns Os == 0 then 0 else rank Os;
        prof := columnRankProfile mutableMatrix(Os | Ks);
        newc = select(prof, c -> c >= numColumns Os) / (c -> c - numColumns Os);
        pr("  [low] degree " | toString s | ": all syzygies " | toString numColumns Ks | ", from lower degree " | toString ro | ", new (minimal) " | toString(#newc) | "  t " | toString(cpuTime()-t0)));
        prevSyz = Ks; prevIdx = idx; nsyzTot = nsyzTot + #newc;
        Ek := stdb(s); ne := numColumns Ek;
        batch := {}; brows := 0;
        doBatch := () -> (
            if #batch == 0 then return;
            Am := mutableMatrix fold((a,b) -> a || b, batch); batch = {}; nb = nb + 1;
            if K === null then K = nullSpace Am else if numColumns K > 0 then (C := Am * K; X := nullSpace C; K = K * X);
            Am = null; collectGarbage();
            pr("   batch " | toString nb | ": rows so far " | toString totRows | ", dim K = " | toString numColumns K | "  t " | toString(cpuTime()-t0)));
        for c in newc do (
            a := new MutableList from apply(r, i -> 0_S);
            for l from 0 to #idx - 1 do (v := Ks_(l, c); if v != 0 then (im := idx#l; a#(im#0) = a#(im#0) + v * im#1));
            P := matrix{flatten apply(r, i -> flatten entries (a#i * Bs#i))};
            Q := lift(last coefficients(P % G, Monomials => Ek), kk);
            batch = append(batch, Q); brows = brows + ne; totRows = totRows + ne;
            if brows >= batchRows then (doBatch(); brows = 0));
        doBatch());
    if K === null then K = id_(kk^N) else K = matrix K;
    pr("  [low] superset of low-degree Hom tuples: dim " | toString numColumns K | " (" | toString nsyzTot | " minimal syzygies up to degree " | toString smax | ")  t " | toString(cpuTime()-t0));
    -- F = sum c_i g_i (linear algebra in S_3)
    m3b := basis(3, S);
    colsL := flatten apply(r, i -> apply(flatten entries basis(3 - dg#i, S), mm -> (i, mm)));
    Mc := lift(last coefficients(matrix{apply(colsL, im -> im#1 * gl_(0, im#0))}, Monomials => m3b), kk);
    xs := solve(Mc, lift(last coefficients(matrix{{F}}, Monomials => m3b), kk));
    Ksub := sub(K, S); Qrow := map(S^1, S^(numColumns K), 0);
    for l from 0 to #colsL - 1 do (if xs_(l,0) != 0 then (i := (colsL#l)#0; Qrow = Qrow + xs_(l,0) * (colsL#l)#1 * ((Bs#i) * Ksub^{offs#i .. offs#i + numColumns(Bs#i) - 1})));
    Qrow = Qrow % G;
    I3list := flatten apply(r, i -> apply(flatten entries basis(3 - dg#i, S), mm -> mm * gl_(0,i)));
    polys := I3list | select(flatten entries Qrow, q -> q != 0);
    cf := M -> lift(last coefficients(M, Monomials => m3b), kk);
    JS1 := flatten entries ((jacobian matrix{{F}}) * vars S);
    r0 := rank mutableMatrix cf(matrix{I3list | JS1}); r1 := rank mutableMatrix cf(matrix{polys | JS1});
    pr("  [low] codim without moduli = " | toString(364 - r0) | "; LOWER BOUND for codim WITH Hom_0 = " | toString(364 - r1) | "  total " | toString(cpuTime()-t0));
    (364 - r0, 364 - r1, numColumns K));
