-- BC-SO own library (independent of SO-T6 / W1 code). General even-dim hypersurface X = V(F) in P^(n+1), n = 2k.
-- pi(P)  = int_Y Res(P Omega/F^(k+1)),  P in S_sig,  sig  = (k+1)d - n - 2  (normalised: up to one scalar)
-- psi(P) = int_Y Res(P Omega/F^(k+2)),  P in S_sig2, sig2 = sig + d
-- Hodge condition at pole order k: Q in S_q0, q0 = k d - n - 2.
-- psi: psi(I_Y^2)=0 (ARG, SO-T6 PRE: derivative of pi along F+sW, W in I_Y,d) and Griffiths-Dwork
--      psi(sum A_i dF_i) = 1/(k+1) pi(sum d_i A_i). Implemented in Q = S/I_Y^2 with a Groebner basis of J (ChangeMatrix).

hsData = (F) -> (
    S := ring F; nv := numgens S; n := nv - 2; k := n // 2; d := first degree F;
    new MutableHashTable from {"S"=>S, "kk"=>coefficientRing S, "F"=>F, "n"=>n, "k"=>k, "d"=>d,
        "sig"=>(k+1)*d-n-2, "sig2"=>(k+2)*d-n-2, "q0"=>k*d-n-2, "J"=>ideal jacobian ideal F}
    );

-- index hash of monomial basis in degree e
monIndex = (S, e) -> (b := flatten entries basis(e,S); hashTable apply(#b, i -> (b#i, i)));
-- coefficient matrix (rows = basis(e,S)) of a 1-row matrix
coefM = (S, e, M) -> sub(last coefficients(M, Monomials => basis(e, S)), coefficientRing S);

-- pi as a row vector on basis(sig, S); normalised by the coefficient of the unique standard monomial of (S/(I+J))_sig
piVector = (H, I) -> (
    S := H#"S"; sig := H#"sig";
    G := gb(I + H#"J", DegreeLimit => sig);
    std := basis(sig, S/(I + H#"J"));
    if numcols std != 1 then error("pi not determined: codim of (I+J)_sig = " | toString numcols std);
    mstd := sub(std_(0,0), S);
    r := (basis(sig, S)) % G;
    sub((coefficients(r, Monomials => matrix{{mstd}}))#1, coefficientRing S)
    );
-- value of a row-vector functional on the forms in a 1-row matrix M of degree e
applyFun = (S, e, vec, M) -> vec * coefM(S, e, M);

-- pairing matrix P(u,v) = fun(u v), u in basis(a), v in basis(b), fun a row vector on basis(a+b)
pairMat = (S, a, b, vec) -> (
    ba := flatten entries basis(a,S); bb := flatten entries basis(b,S);
    idx := monIndex(S, a+b);
    v := flatten entries vec;
    matrix(coefficientRing S, apply(ba, u -> apply(bb, w -> v#(idx#(u*w)))))
    );

-- psi machinery for a cycle with ideal I and pi vector piv
psiSetup = (H, I, piv) -> (
    S := H#"S"; Q := S/(I^2); sig := H#"sig"; d := H#"d";
    jQ := sub(transpose jacobian matrix{{H#"F"}}, Q);
    t0 := cpuTime();
    GQ := gb(jQ, ChangeMatrix => true, Syzygies => true, DegreeLimit => H#"sig2");
    tg := cpuTime() - t0;
    -- decomposition of every monomial of degree sig: m = sum B_k dF_k + remainder (mod I^2)
    bs := sub(basis(sig, S), Q);
    rem := bs % GQ;
    stdm := flatten entries basis(sig, Q/ideal(jQ));        -- standard monomials of (Q/J)_sig
    Bm := lift(bs // GQ, S);                                  -- 12 x N
    remC := sub(last coefficients(lift(rem,S), Monomials => matrix{apply(stdm, u -> lift(u,S))}), coefficientRing S); -- r x N
    new MutableHashTable from {"Q"=>Q, "GQ"=>GQ, "jQ"=>jQ, "piv"=>piv, "Bm"=>Bm, "remC"=>remC,
        "std"=>apply(stdm, u -> lift(u,S)), "I"=>I, "gbTime"=>tg}
    );

-- direct psi on a 1-row matrix P of forms of degree sig2 (division in Q)
psiDirect = (H, P, C) -> (
    S := H#"S"; k := H#"k";
    PQ := sub(P, C#"Q");
    if PQ % C#"GQ" != 0 then error "psiDirect: (I^2+J)_sig2 != S_sig2";
    A := lift(PQ // C#"GQ", S);
    dv := sum(numgens S, i -> diff(S_i, A^{i}));
    (promote(1/(k+1), coefficientRing S)) * applyFun(S, H#"sig", C#"piv", dv)
    );

-- psi_G on basis(sig,S) for a list of forms G of degree d: psi(G m) for every monomial m of degree sig
psiG = (H, Gs, C) -> (
    S := H#"S"; k := H#"k"; d := H#"d"; sig := H#"sig"; kk := coefficientRing S;
    nv := numgens S; Bm := C#"Bm"; piv := C#"piv";
    eB := sig - d + 1;          -- degree of B_k
    if not C#?"Wk" then (
        Pdb := pairMat(S, d-1, eB, piv);     -- pi(u v), u in S_(d-1), v in S_eB
        Pdd := pairMat(S, d, sig - d, piv);  -- pi(u v), u in S_d, v in S_(sig-d)
        divB := sum(nv, i -> diff(S_i, Bm^{i}));
        C#"Wdiv" = Pdd * coefM(S, sig - d, divB);
        C#"Wk" = apply(nv, i -> Pdb * coefM(S, eB, Bm^{i}));
        );
    apply(Gs, G -> (
        gv := coefM(S, d, matrix{{G}});
        t2 := (transpose gv) * C#"Wdiv";
        t1 := sum(nv, i -> (transpose coefM(S, d-1, matrix{{diff(S_i, G)}})) * (C#"Wk")#i);
        rv := matrix{apply(C#"std", u -> (psiDirect(H, matrix{{G*u}}, C))_(0,0))};
        (promote(1/(k+1), kk)) * (t1 + t2) + rv * C#"remC"
        ))
    );

-- bilinear matrix of a functional vec on S_sig: (u,v) -> vec(u v), u in S_a, v in S_b
-- (same as pairMat)

-- syzygy consistency test: random element of the degree-sig2 syzygies of jQ in Q; returns pi(div A)
syzTest = (H, C, ntests) -> (
    S := H#"S"; Q := C#"Q"; k := H#"k";
    Z := syz C#"GQ";
    Z = Z_(select(numcols Z, j -> (degrees source Z)#j#0 <= H#"sig2"));
    apply(ntests, t -> (
        A := sum(numcols Z, j -> Z_{j} * random((H#"sig2") - ((degrees source Z)#j#0), Q));
        A = lift(A, S);
        chk := (transpose jacobian matrix{{H#"F"}}) * A;
        inI2 := (sub(chk, Q) == 0);
        dv := sum(numgens S, i -> diff(S_i, A^{i}));
        (inI2, (promote(1/(k+1), coefficientRing S)) * applyFun(S, H#"sig", C#"piv", dv), numcols Z)
        ))
    );

-- kernel helpers (columns = basis of kernel)
kerOf = M -> gens ker M;
end
