-- SO3-T6 engine: periods of higher pole order of an algebraic cycle V in a cubic X = V(F) of dimension n = 2k.
--   psi_m(P) = int_[V] Res(P Omega / F^(k+m)),  P in S_(3(k+m) - N),  m = 1 (pi), 2 (psi), 3 (psi3).
-- Characterisation used (ARG, ledger [SO3-T6] PRE): psi_m = 0 on (I_V^m) (m = 1: pi = 0 on I_V, V in X);
--   Griffiths-Dwork: psi_m(sum_j A_j dF/dx_j) = 1/(k+m-1) psi_(m-1)(sum_j dA_j/dx_j);  psi_0 = 0 (V Hodge);
--   pi = pi0 * (coefficient of m0 in the normal form mod I+J)  ((I+J)_t has codimension 1, t = 3(k+1) - N).
-- Evaluation by recursive lifting along mingens(I) | J with products of generators g_gamma carried symbolically:
--   psi_m(g_gamma W), |gamma| < m.  Remaining data: symbols ("K", m, gamma) = psi_m(g_gamma m0), deg g_gamma = 3m - 3.
-- Vectors are HashTables  key -> 1 x nz matrix  (key "1" = known part, other keys = unknown constants).
-- Expects S, kk, pr defined by the caller.
o3Setup = (F, gensI, k, pi0) -> (
    N := numgens S;
    H := new MutableHashTable;
    H#"F" = F; H#"k" = k; H#"g" = gensI; H#"r" = #gensI;
    H#"dg" = apply(gensI, u -> first degree u);
    Jr := apply(N, i -> diff(S_i, F)); H#"Jr" = Jr;
    H#"dgen" = apply(gensI, u -> apply(N, j -> diff(S_j, u)));
    t1 := cpuTime();
    IJ := ideal gens gb(ideal gensI + ideal Jr); H#"IJ" = IJ;
    t := 3*(k+1) - N; H#"t" = t;
    bt := lift(basis(t, S/IJ), S);
    if numColumns bt != 1 then error("(I+J)_t has codimension " | toString numColumns bt);
    m0 := bt_(0,0); H#"m0" = m0;
    Bt := basis(t, S);
    pv := flatten entries lift(last coefficients(Bt % IJ, Monomials => matrix{{m0}}), kk);
    H#"PiT" = pi0 * (Bt * transpose matrix{pv})_(0,0);
    H#"GIJ" = matrix{gensI | Jr};
    H#"setupTime" = cpuTime() - t1;
    H);
-- vector arithmetic
o3Add = (A, B) -> (C := new MutableHashTable from A; scan(keys B, kx -> C#kx = if C#?kx then C#kx + B#kx else B#kx); new HashTable from C);
o3Scale = (c, A) -> applyValues(A, v -> c * v);
-- multiplier rows: D^dm applied to the z-basis
o3Dz = (Bz, dm) -> (M := Bz; scan(dm, j -> M = diff(S_j, M)); M);
-- level-1 values for a factored job: v_z = pi((D^dm z) W)
o3Pi1 = (H, Bz, W, dm) -> (
    Dz := o3Dz(Bz, dm);
    matrix{apply(flatten entries Dz, f -> if f == 0 then 0_kk else lift(contract(f * W, H#"PiT"), kk))});
o3Pi1fast = (H, Bz, W, dm) -> (
    -- u_mu = pi(mu W) for monomials mu via one contraction, then the multiplier map
    Dz := o3Dz(Bz, dm);
    e := first degree (H#"PiT") - first degree W;
    C := contract(W, H#"PiT");
    Be := basis(e, S);
    u := lift(last coefficients(C, Monomials => Be), kk);             -- |Be| x 1  (coefficient of mu in C = pi(mu W))
    L := lift(last coefficients(Dz, Monomials => Be), kk);             -- |Be| x nz
    (transpose u) * L);
-- main evaluator.  mTop: level; Wf: factored start (polynomial, multiplier z in Bz) or null; Pex: explicit start (1 x nz) or null
o3Eval = (H, mTop, Bz, Wf, Pex) -> (
    nz := if Pex =!= null then numColumns Pex else numColumns Bz; r := H#"r"; N := numgens S; k := H#"k";
    g := H#"g"; dgen := H#"dgen"; GIJ := H#"GIJ"; IJ := H#"IJ"; m0 := H#"m0"; t := H#"t";
    fac := new MutableHashTable; ex := new MutableHashTable;
    addF := (m, ga, dm, W) -> (if W == 0 or #ga >= m then return; kx := (m, sort ga, sort dm); fac#kx = if fac#?kx then fac#kx + W else W);
    addE := (m, ga, P0) -> (if #ga >= m then return; P := map(S^1, , {flatten entries P0}); kx := (m, sort ga); ex#kx = if ex#?kx then ex#kx + P else P);
    if Wf =!= null then addF(mTop, {}, {}, Wf);
    if Pex =!= null then addE(mTop, {}, Pex);
    out := new MutableHashTable; out#"1" = map(kk^1, kk^nz, 0);
    addOut := (kx, v) -> out#kx = if out#?kx then out#kx + v else v;
    stats := new MutableHashTable; stats#"lifts" = 0; stats#"exLifts" = 0;
    dropPos := (ga, p) -> drop(ga, {p, p});
    for m from 1 to mTop do (); -- (placeholder)
    for mm from 0 to mTop - 1 do (
        m := mTop - mm;
        for s from 0 to m - 1 do (
            if m == 1 then (
                -- level 1: only gamma = {} survives
                for kx in keys fac do if kx#0 == 1 then (addOut("1", o3Pi1fast(H, Bz, fac#kx, kx#2)); remove(fac, kx));
                for kx in keys ex do if kx#0 == 1 then (
                    P := ex#kx; remove(ex, kx);
                    addOut("1", matrix{apply(flatten entries P, f -> if f == 0 then 0_kk else lift(contract(f, H#"PiT"), kk))}));
                break);
            cf := 1_kk / (k + m - 1);
            -- factored jobs at (m, |gamma| = s)
            fk := select(keys fac, kx -> kx#0 == m and #(kx#1) == s);
            for kx in fk do (
                W := fac#kx; remove(fac, kx); ga := kx#1; dm := kx#2;
                rem := W % IJ;
                Q := (matrix{{W - rem}}) // GIJ;
                stats#"lifts" = stats#"lifts" + 1;
                for c from 0 to r - 1 do addF(m, append(ga, c), dm, Q_(c, 0));
                if m >= 2 then for j from 0 to N - 1 do (
                    E := Q_(r + j, 0);
                    if E != 0 then (
                        for p from 0 to #ga - 1 do addF(m - 1, dropPos(ga, p), dm, cf * dgen#(ga#p)#j * E);
                        addF(m - 1, ga, dm, cf * diff(S_j, E));
                        addF(m - 1, ga, append(dm, j), cf * E)));
                if rem != 0 then addE(m, ga, o3Dz(Bz, dm) * rem));
            -- explicit jobs at (m, |gamma| = s)
            ek := select(keys ex, kx -> kx#0 == m and #(kx#1) == s);
            for kx in ek do (
                P := ex#kx; remove(ex, kx); ga := kx#1;
                rem := P % IJ;
                if target P =!= target GIJ then (pr("DBG target P " | toString degrees target P | " " | toString ring P | " src " | toString degrees source P); error "dbg");
                Q := (P - rem) // GIJ;
                stats#"exLifts" = stats#"exLifts" + 1;
                for c from 0 to r - 1 do addE(m, append(ga, c), Q^{c});
                for j from 0 to N - 1 do (
                    E := Q^{r + j};
                    if E != 0 then (
                        for p from 0 to #ga - 1 do addE(m - 1, dropPos(ga, p), cf * dgen#(ga#p)#j * E);
                        addE(m - 1, ga, cf * diff(S_j, E))));
                if rem != 0 then (
                    rl := flatten entries rem;
                    if any(rl, f -> f != 0 and first degree f != t) then error "o3Eval: remainder outside degree t";
                    cvec := matrix{apply(rl, f -> if f == 0 then 0_kk else lift(f // m0, kk))};
                    if rem != m0 * sub(cvec, S) then error "o3Eval: remainder is not a multiple of m0";
                    addOut(("K", m, ga), cvec)));
            );
        );
    if #keys fac > 0 or #keys ex > 0 then error "o3Eval: unprocessed jobs";
    (new HashTable from out, new HashTable from stats));
-- substitute known constants (HashTable key -> scalar); returns (row, list of unresolved keys)
o3Subst = (v, Kv) -> (
    row := v#"1"; unres := {};
    for kx in keys v do if kx =!= "1" then (
        if Kv#?kx then row = row + Kv#kx * v#kx
        else if v#kx != 0 then unres = append(unres, kx));
    (row, unres));
