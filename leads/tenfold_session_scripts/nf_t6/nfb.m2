-- NF-T6 task B1 (MOD p): first and second order of NL([P1] + lam [P2]) at a point of Z_0 (cubic tenfold, two 5-planes
-- P1 = V(f,p), P2 = V(h,p) meeting in Pi = P^2 = V(f,h,p), F = f^T M h + p.s with M|Pi = 0).
-- Uses the package's residue machinery (debug HodgeLociCI: hlResidueDual, hlSquaredPairData, hlFirstOrder); no package edit.
-- Second order (Lemma 2.1(3), pointwise; same normalisation as hlPointwiseValues): for v in ker L_lam, the order-2
-- condition of an arc t v + t^2 T2 + ... is q(v)(Q) = psi2_lam(v^2 Q) = 0 for all Q in K = ker L_lam (L symmetric),
-- psi2_lam = sum_nu Res[./Phi^1_(nu)] + lam sum_nu Res[./Phi^2_(nu)] on S_9.
-- With ker L = T V_Z + T Cone_T and T Cone_T / T Z_0 one-dimensional (spanned by c), v = t c + b + z gives
-- q(v) = 2 t beta(b) with beta(b)(Q) = psi2(c b Q), b in T V_Z / T Z_0 (27-dim, = M|Pi).
needsPackage("HodgeLociCI", FileName => "/home/claude/hodge/package/HodgeLociCI/M2/HodgeLociCI.m2");
debug HodgeLociCI;

-- column vectors (over basis B of S_3) <-> forms
toForm = (B, v) -> (B * sub(v, ring B))_(0,0);
coefVec = (B, G, kk) -> lift((coefficients(G, Monomials => B))#1, kk);
-- cubic dual of Q -> R(G Q): contract(G, R) and read coefficients on B
dualVec = (R, G, B, kk) -> (
    c := contract(G, R);
    if c == 0 then map(kk^(numColumns B), kk^1, 0) else lift((coefficients(c, Monomials => B))#1, kk));
spanRank = (A) -> if numColumns A == 0 then 0 else rank A;
intersectSpaces = (A, Bm) -> (
    -- column spaces A, Bm in kk^n: basis of the intersection
    N := gens ker (A | Bm);
    A * N^(toList(0..numColumns A - 1)));
complementIn = (Sub, Big) -> (
    -- columns of Big completing a basis of Sub to a basis of span(Sub|Big)
    cur := Sub; chosen := {}; r := spanRank cur;
    for j from 0 to numColumns Big - 1 do (
        t := cur | Big_{j};
        if rank t > r then (cur = t; r = r + 1; chosen = append(chosen, j)));
    Big_chosen);

-- main analysis. f, h, p: lists of 3 linear forms; M: 3x3 matrix of linear forms with M|Pi = 0; s: 3 quadrics.
-- ells: 3 linear forms independent on Pi (used for the b-basis f_a h_b ell_k).
nfAnalyze = (f, h, p, M, s, ells, lams, seed) -> (
    S := ring first f; kk := coefficientRing S;
    t0 := cpuTime();
    D := cyclePair(f, h, p, M, s, CheckSmooth => true);
    F := D#"F";
    print("smooth:", D#"smooth", "excessFromData:", (excessFromData D)#"excessAtLambda0", (excessFromData D)#"excessElsewhere", "codimVZ", (excessFromData D)#"codimVZ");
    B := basis(3, S); nB := numColumns B;
    (C1, C2) := hlFirstOrder(D, "Residue");
    TVZ := gens ker (C1 || C2);
    print("dim S_3", nB, "codim T V_Z", nB - numColumns TVZ, "rank C1", rank C1, "rank C2", rank C2, "C1 symmetric", C1 == transpose C1, "(", cpuTime() - t0, "s)");
    -- T Cone: G with G|P^8 in k[f,h]_3|P^8 + (J_F S_1)|P^8
    pm := lift((coefficients(matrix{p}, Monomials => vars S))#1, kk);  -- 12 x 3
    Kp := gens ker transpose pm;                                       -- 12 x 9: parametrisation of V(p)
    tt := symbol tt; S8 := kk[tt_0..tt_8];
    res := map(S8, S, flatten entries (vars S8 * transpose Kp));
    B8 := basis(3, S8);
    R8 := lift((coefficients(res B, Monomials => B8))#1, kk);         -- 165 x 364 restriction
    wl := apply(f | h, u -> res u);
    ww := symbol ww; Sw := kk[ww_0..ww_5];
    wc := flatten entries basis(3, Sw);
    wsub := map(S8, ring first wc, wl);
    Ugens := apply(wc, m -> wsub m) | flatten apply(12, i -> apply(9, k -> tt_k * res(diff(S_i, F))));
    U := lift((coefficients(matrix{Ugens}, Monomials => B8))#1, kk);
    Nn := gens ker transpose U;                                         -- 165 x (165 - rank U)
    TCone := gens ker (transpose Nn * R8);
    print("codim T Cone (cone locus, P^8 and vertex moving)", nB - numColumns TCone, "(", cpuTime() - t0, "s)");
    -- second-order dual polynomials (degree 9) for both cycles
    (rds1, rds2) := (hlSquaredPairData(D#"f" | D#"p", D#"g" | D#"s"), hlSquaredPairData(D#"h" | D#"p", D#"q" | D#"s"));
    Rd1 := sum(rds1, rd -> (Bs := basis(rd#"sigma", S); (Bs * transpose sub(matrix{hlResRow(rd, Bs)}, S))_(0,0)));
    Rd2 := sum(rds2, rd -> (Bs := basis(rd#"sigma", S); (Bs * transpose sub(matrix{hlResRow(rd, Bs)}, S))_(0,0)));
    print("second-order dual polynomials: terms", #terms Rd1, #terms Rd2, "(", cpuTime() - t0, "s)");
    -- b-basis f_a h_b ell_k
    bforms := flatten flatten apply(3, a -> apply(3, b -> apply(3, k -> f#a * h#b * ells#k)));
    Bb := coefVec(B, matrix{bforms}, kk);
    print("b-basis in T V_Z:", (C1 || C2) * Bb == 0);
    results := {};
    for lam in lams do (
        l := lam_kk;
        L := C1 + l * C2;
        kerL := gens ker L;
        TCT := intersectSpaces(TCone, kerL);
        TZ0 := intersectSpaces(TCT, TVZ);
        rTC := rank(L * TCone);
        print("--- lambda", lam, ": rank L", rank L, "| rank of L on T Cone", rTC, "| codim T Cone_T", nB - numColumns TCT,
            "| codim T Z_0", nB - numColumns TZ0, "| T V_Z + T Cone_T = ker L:", rank(TVZ | TCT) == numColumns kerL,
            "| dim ker L", numColumns kerL, "| excess (codim VZ - rank L)", (nB - numColumns TVZ) - rank L);
        bcomp := complementIn(TZ0, Bb);
        print("    b-basis independent mod T Z_0 (27 expected):", numColumns bcomp, " and spans T V_Z / T Z_0:", numColumns TZ0 + numColumns bcomp == numColumns TVZ);
        rV := rank TVZ;
        jc := position(toList(0..numColumns TCT - 1), j -> rank(TVZ | TCT_{j}) > rV);
        ccol := TCT_{jc};
        print("    dim T Cone_T / T Z_0:", numColumns TCT - numColumns TZ0);
        c := toForm(B, ccol_{0});
        psi2 := G -> (dualVec(Rd1, G, B, kk) + l * dualVec(Rd2, G, B, kk));   -- column: Q-monomial -> psi2(G Q)
        -- controls: q(v) on K for random v in T V_Z, T Cone_T, T Z_0 (must vanish); random v in ker L (generic)
        rv := A -> toForm(B, A * random(kk^(numColumns A), kk^1));
        ctl := apply({("T V_Z", TVZ), ("T Cone_T", TCT), ("T Z_0", TZ0), ("ker L generic", kerL)}, (nm, A) -> (
            v := rv A; w := transpose(psi2(v^2)) * kerL;
            (nm, w == 0, rank w)));
        print("    controls q(v)|K = 0:", ctl);
        -- beta: 27 x dim K
        betaM := matrix apply(27, i -> {transpose(psi2(c * bforms#i)) * kerL});
        betaM = transpose betaM;   -- rows K, cols b
        rb := rank betaM;
        kb := gens ker betaM;      -- coordinates m_(a,b,k) of b in ker beta
        print("    rank beta:", rb, " dim ker beta (b-directions in T V_Z/T Z_0 surviving order 2 with c):", numColumns kb);
        -- rank-1 matrices in ker beta: M(m) = (sum_k m_abk u_k)_(a,b); rank <= 1 locus
        rk1 := "n/a";
        if numColumns kb > 0 then (
            nk := numColumns kb;
            ee := symbol ee; uu := symbol uu;
            T := kk[ee_0..ee_(nk-1), uu_0..uu_2];
            mvec := sub(kb, T) * transpose matrix{toList(ee_0..ee_(nk-1))};
            MM := matrix table(3, 3, (a, b) -> sum(3, k -> mvec_(9*a + 3*b + k, 0) * uu_k));
            -- rank <= 1 over k[u]: 2x2 minors vanish identically in u
            I2 := minors(2, MM);
            cf := flatten apply(flatten entries gens I2, g -> flatten entries (coefficients(g, Variables => {uu_0, uu_1, uu_2}))#1);
            J := ideal cf;
            Tm := kk[ee_0..ee_(nk-1)];
            Jm := (map(Tm, T, toList(ee_0..ee_(nk-1)) | {0,0,0})) J;
            rk1 = (dim Jm, "affine dim of {M in ker beta : rank M <= 1} (rank-1 cone in the 27-dim space has dim 11)");
            -- also: does ker beta contain T Z_0-transverse c-free information? report a sample element's rank
            );
        print("    rank<=1 locus inside ker beta:", rk1, "(", cpuTime() - t0, "s)");
        results = append(results, (lam, rank L, nB - numColumns TCT, rb, numColumns kb, rk1));
        );
    results
    );
