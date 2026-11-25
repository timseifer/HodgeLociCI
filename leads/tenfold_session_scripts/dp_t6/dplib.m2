-- DP-T6 library: order-2 surviving cone on a multi-dimensional excess E = T NL / T_f.
-- Input data (over kk): Bs = list of n matrices B_i (rows: basis K of T NL, cols: spanning set of T_f), B_i(K,h) = psi(K e_i h)
--                       Qs = hash (i,j) i<=j -> column vector over K: psi(K e_i e_j)
-- a in E survives iff exists h: q(a) + 2 B(a) h = 0, q(a) = sum_{i,j} a_i a_j Q_ij, B(a) = sum a_i B_i.
coneAnalysis = (kk, Bs, Qs) -> (
    n := #Bs; nK := numrows Bs#0; nh := numcols Bs#0;
    A := kk[a_1..a_n]; av := gens A;
    Bcoef := fold((u,w) -> u | w, Bs);                           -- nK x (n nh)
    -- row change: left kernel of Bcoef (rows where B vanishes identically) and a complement
    Lk := gens ker transpose Bcoef;                               -- nK x l, Lk^T Bcoef = 0
    rB := rank Bcoef;
    -- complement rows: pick independent rows of Bcoef greedily via column profile of transpose
    piv := if rB == 0 then {} else rowRankProfile mutableMatrix Bcoef;
    qsym := (i,j) -> (if i == j then 1_A else 2_A) * av#i * av#j;
    Qfull := sum flatten apply(n, i -> apply(toList(i..n-1), j -> sub(Qs#(i,j), A) * qsym(i,j)));   -- nK x 1 over A
    Bfull := sum(n, i -> av#i * sub(Bs#i, A));                    -- nK x nh over A
    Iq := if numcols Lk == 0 then ideal(0_A) else ideal flatten entries (transpose(sub(Lk, A)) * Qfull);
    Iq = trim Iq;
    -- reduced rows
    Bp := Bfull^piv; qp := Qfull^piv;
    -- compress columns of Bp: independent kk-columns of the coefficient stacking
    Bst := fold((u,w) -> u || w, apply(n, i -> (Bs#i)^piv));     -- (n rB) x nh
    cpiv := if #piv == 0 then {} else columnRankProfile mutableMatrix Bst;
    Bp = Bp_cpiv;
    -- generic column compression to (#rows) columns (rank and column span preserved for a outside a proper closed set; MC/ARG)
    if numcols Bp > numrows Bp then Bp = Bp * sub(random(kk^(numcols Bp), kk^(numrows Bp)), A);
    -- strata by rank of Bp
    rgen := if #piv == 0 then 0 else rank sub(Bp, apply(av, x -> x => random kk));
    pdim := I -> (if dim I <= 0 then -1 else dim I - 1);   -- projective dimension (-1 = empty)
    strata := {};
    Zdims := {};
    if pdim Iq < 0 then rgen = -1;   -- V(Iq) empty: nothing survives
    for s from 0 to rgen do (
        Ms := if s == 0 then ideal(1_A) else (if #piv == 0 then ideal(1_A) else minors(s, Bp));
        Ps := Iq + (if #piv == 0 then ideal(0_A) else minors(s+1, Bp)) + (if #piv == 0 then ideal(0_A) else minors(s+1, Bp | qp));
        Zs := if s == 0 then Ps else saturate(Ps, Ms);
        d0 := pdim Zs;
        strata = append(strata, (s, d0));
        Zdims = append(Zdims, d0));
    new HashTable from {"n"=>n, "nK"=>nK, "nh"=>nh, "rankBcoef"=>rB, "lk"=>numcols Lk, "Iq"=>Iq,
        "numIq"=>numgens Iq, "dimIq"=>pdim Iq, "Bp"=>Bp, "qp"=>qp, "rgen"=>rgen, "strata"=>strata,
        "dimZ"=>(if #Zdims == 0 then -1 else max Zdims), "ring"=>A, "Qfull"=>Qfull, "Bfull"=>Bfull}
    );
-- numeric check at a point a (list over kk): rank[B(a);q(a)] vs rank B(a) on full data
pointTest = (kk, Bs, Qs, a) -> (
    n := #Bs;
    Ba := sum(n, i -> a#i * Bs#i);
    qa := sum flatten apply(n, i -> apply(toList(i..n-1), j -> (if i == j then 1 else 2) * a#i * a#j * Qs#(i,j)));
    (rank Ba, rank(Ba | qa))
    );
verdictOf = (C) -> (
    pe := C#"n" - 1;
    if C#"dimZ" == pe then "ALL SURVIVE" else if C#"dimZ" < 0 then "ALL DIE" else "PARTIAL (proj dim " | toString(C#"dimZ") | " in P^" | toString pe | ")"
    );

-- cross term psi(Gp * Gout * mu), mu in basis(q0): caO = decomp of Gout*mu, MmI3 = psi(W Gp mu) for W in the I3 basis
-- (364 x #I3, from famMatrix of Gp), I3m = basis matrix of (I)_d; requires nu(Gp mu) = 0 and nu(Gout mu) = 0.
qPair = (H, N, Gp, caO, MmI3, I3m) -> (
    S := H#"S"; kk := coefficientRing S; d := H#"d"; sig := H#"sig"; q0 := H#"q0"; nv := numgens S; k := H#"k";
    a := caO#"a"; c := caO#"c";
    if caO#"rem" != 0 then error "qPair: nu(Gout mu) != 0";
    ea := sig - d + 1;
    bi := flatten entries basis(ea, S);
    gd := sum(nv, i -> (
        row := nuApply(H, N, matrix{apply(bi, t -> diff(S_i, Gp * t))});
        row * coefM(S, ea, a^{i})));
    gd = (promote(1/(k+1), kk)) * gd;
    idxq := monIndex(S, q0);
    I3c := coefM(S, d, I3m);
    ip := sum(N#"r", j -> (
        e := (N#"degs")#j; f := (N#"fI")_(0,j);
        bt := flatten entries basis(sig - e, S);
        n1s := unique apply(bt, t -> firstFactor(t, d - e));
        Wc := coefM(S, d, matrix{apply(n1s, u -> u * f)});
        X := Wc // I3c;
        if I3c * X != Wc then error "qPair: W not in span of I3";
        Mw := MmI3 * X;                                   -- 364 x #n1s : psi(W_u Gp mu)
        hu := hashTable apply(#n1s, l -> (n1s#l, l));
        vj := matrix(kk, {apply(bt, t -> (u := firstFactor(t, d - e); Mw_(idxq#(t // u), hu#u)))});
        vj * coefM(S, sig - e, c^{j})));
    gd + ip
    );
-- cached version: qPrep depends only on Gp (and its famMatrix); qPairC(prep, caO) = psi(Gp * Gout * mu)
qPrep = (H, N, Gp, MmI3, I3m) -> (
    S := H#"S"; kk := coefficientRing S; d := H#"d"; sig := H#"sig"; q0 := H#"q0"; nv := numgens S; k := H#"k";
    ea := sig - d + 1;
    bi := flatten entries basis(ea, S);
    gdr := apply(nv, i -> (promote(1/(k+1), kk)) * nuApply(H, N, matrix{apply(bi, t -> diff(S_i, Gp * t))}));
    idxq := monIndex(S, q0);
    if not N#?"I3c" then N#"I3c" = coefM(S, d, I3m);
    I3c := N#"I3c";
    vjs := apply(N#"r", j -> (
        e := (N#"degs")#j; f := (N#"fI")_(0,j);
        bt := flatten entries basis(sig - e, S);
        n1s := unique apply(bt, t -> firstFactor(t, d - e));
        if not N#?("X", j) then (
            Wc := coefM(S, d, matrix{apply(n1s, u -> u * f)});
            X := Wc // I3c;
            if I3c * X != Wc then error "qPrep: W not in span of I3";
            N#("X", j) = X);
        Mw := MmI3 * N#("X", j);
        hu := hashTable apply(#n1s, l -> (n1s#l, l));
        matrix(kk, {apply(bt, t -> (u := firstFactor(t, d - e); Mw_(idxq#(t // u), hu#u)))})));
    new HashTable from {"gdr"=>gdr, "vjs"=>vjs, "ea"=>ea}
    );
qPairC = (H, N, P, caO) -> (
    S := H#"S"; sig := H#"sig"; nv := numgens S;
    if caO#"rem" != 0 then error "qPairC: nu(Gout mu) != 0";
    a := caO#"a"; c := caO#"c";
    gd := sum(nv, i -> (P#"gdr")#i * coefM(S, P#"ea", a^{i}));
    ip := sum(N#"r", j -> (P#"vjs")#j * coefM(S, sig - (N#"degs")#j, c^{j}));
    gd + ip
    );
end
