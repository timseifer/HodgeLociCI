-- BC-SO famlib: psi on products h*G*mu via first-order families (degree-sig computations only).
-- ARG: for a first-order family direction (h, phi) (F_s = F + s h, I_{V_s} = I + s phi(I), V_s in X_s)
--   pi_s = c(s) nu_s, nu_s = functional on S_sig vanishing on (I_{V_s}+J_s)_sig with nu_s(mstd) = 1;
--   d/ds pi_s(R) = -(k+1) psi(h R); if nu(R) = 0 then psi(h R) = -(1/(k+1)) nu'_h(R), and
--   nu'_h(R) = -nu(sum a_i d_i h) - nu(sum c_j phi(f_j)) for R = sum a_i dF_i + sum c_j f_j (+ 0 * mstd).
-- psi(G R) for R with nu(R) = 0, G arbitrary: R = a.dF + sum c_j f_j, psi(G a.dF) = (1/(k+1)) nu(div(G a)) (GD),
--   psi(G c_j f_j): split c_j f_j = sum (nu1 f_j) nu2, deg(nu1 f_j) = d, nu1 f_j in I_d a family direction (phi = 0),
--   psi(nu1 f_j * G nu2) = (1/(k+1)) nu(a_{G nu2} . grad(nu1 f_j))  (needs nu(G nu2) = 0, i.e. G in T NL).

nuSetup = (H, I) -> (
    S := H#"S"; sig := H#"sig";
    fI := gens I; r := numcols fI;
    jac := transpose jacobian matrix{{H#"F"}};
    M := fI | jac;
    t0 := cpuTime();
    G := gb(M, ChangeMatrix => true, DegreeLimit => sig);
    std := basis(sig, S/(I + H#"J"));
    if numcols std != 1 then error("nu not determined: dim (S/(I+J))_sig = " | toString numcols std);
    mstd := lift(std_(0,0), S);
    rem := (basis(sig, S)) % G;
    nuv := sub((coefficients(rem, Monomials => matrix{{mstd}}))#1, coefficientRing S);
    new MutableHashTable from {"G"=>G, "M"=>M, "r"=>r, "fI"=>fI, "mstd"=>mstd, "nuv"=>nuv,
        "degs"=>apply(r, j -> first degree fI_(0,j)), "time"=>cpuTime()-t0}
    );

-- decompose a 1-row matrix of forms of degree sig: returns (c, a, remcoef) with c: r x N, a: nv x N
decomp = (H, N, R) -> (
    S := H#"S"; G := N#"G"; r := N#"r";
    quo := R // G; rem := R % G;
    if (N#"M") * quo + rem != R then error "decomp: bad quotient";
    remc := sub((coefficients(rem, Monomials => matrix{{N#"mstd"}}))#1, coefficientRing S);
    if rem - (matrix{{N#"mstd"}}) * sub(remc, S) != 0 then error "decomp: remainder not a multiple of mstd";
    new MutableHashTable from {"c"=>quo^(toList(0..r-1)), "a"=>quo^(toList(r..r+numgens S-1)), "rem"=>remc}
    );

nuApply = (H, N, P) -> applyFun(H#"S", H#"sig", N#"nuv", P);   -- P: 1-row matrix of forms of degree sig

-- E(mu, h) = nu(a_mu . grad h) + nu(c_mu . phi_h) for decomposed R_mu = G*mu, mu in basis(q0)
-- dirs: list of (h, phi) with phi a 1 x r matrix (images of the generators of I) or null (phi = 0)
famMatrix = (H, N, ca, dirs) -> (
    S := H#"S"; kk := coefficientRing S; d := H#"d"; sig := H#"sig"; nv := numgens S;
    c := ca#"c"; a := ca#"a";
    ea := sig - d + 1;
    if not N#?"Pa" then N#"Pa" = pairMat(S, ea, d - 1, N#"nuv");
    if not ca#?"Acoef" then ca#"Acoef" = apply(nv, i -> (transpose coefM(S, ea, a^{i})) * N#"Pa");
    Acoef := ca#"Acoef";
    pc := e -> (if not N#?("P", e) then N#("P", e) = pairMat(S, sig - e, e, N#"nuv"); N#("P", e));
    cols := apply(dirs, dr -> (
        (h, phi) := dr;
        v := sum(nv, i -> Acoef#i * coefM(S, d-1, matrix{{diff(S_i, h)}}));
        if phi =!= null then v = v + sum(N#"r", j -> (
            e := (N#"degs")#j;
            if phi_(0,j) == 0 then 0 else (
            (transpose coefM(S, sig - e, c^{j})) * pc(e) * coefM(S, e, matrix{{phi_(0,j)}}))));
        v));
    (promote(1/(H#"k"+1), kk)) * fold((u,w) -> u | w, cols)
    );

-- qvec: psi(G * G * mu) for mu in basis(q0), using decompositions ca of G*mu (requires nu(G mu) = 0)
-- W-matrix over all monomial directions w in S_d (valid only for w in I_d): RW = famMatrix with phi = 0
qVector = (H, N, Gp, ca) -> (
    S := H#"S"; kk := coefficientRing S; d := H#"d"; sig := H#"sig"; q0 := H#"q0"; nv := numgens S; k := H#"k";
    c := ca#"c"; a := ca#"a";
    if ca#"rem" != 0 then error "qVector: nu(G mu) != 0";
    ea := sig - d + 1;
    -- GD part: nu(div(G a_mu)) for each mu
    gd := sum(nv, i -> (
        bi := flatten entries basis(ea, S);
        row := nuApply(H, N, matrix{apply(bi, t -> diff(S_i, Gp * t))});   -- 1 x dim S_ea
        row * coefM(S, ea, a^{i})));
    gd = (promote(1/(k+1), kk)) * gd;
    -- I_d part: for each generator f_j and monomial t of degree sig - e_j: t = nu1 * nu2, deg nu1 = d - e_j
    bq := flatten entries basis(q0, S); idxq := monIndex(S, q0);
    -- psi(W G nu2) = (1/(k+1)) * (A(nu2) . grad W) where A from ca (decomposition of G*nu2)
    ip := sum(N#"r", j -> (
        e := (N#"degs")#j; f := (N#"fI")_(0,j);
        bt := flatten entries basis(sig - e, S);
        n1s := unique apply(bt, t -> firstFactor(t, d - e));
        Ws := apply(n1s, u -> (u, u * f));
        Mw := famMatrix(H, N, ca, apply(Ws, x -> (x#1, null)));   -- dim S_q0 x #n1s : psi(W_u G mu)
        hu := hashTable apply(#n1s, l -> (n1s#l, l));
        vj := matrix(kk, {apply(bt, t -> (u := firstFactor(t, d - e); Mw_(idxq#(t // u), hu#u)))});
        vj * coefM(S, sig - e, c^{j})));
    gd + ip
    );
-- divisor of degree e of monomial t: take variables in order
firstFactor = (t, e) -> (
    ex := first exponents t; S := ring t; out := {}; rest := e;
    for i from 0 to #ex - 1 do (m := min(ex#i, rest); out = append(out, m); rest = rest - m);
    product(#out, i -> (S_i)^(out#i))
    );
end
