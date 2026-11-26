-- shared routines (blind check 7).  Everything is MOD p.
singCubics = (I) -> (
    -- dimension (and basis) of the space of cubics all of whose partial derivatives lie in I
    R := ring I;
    B := basis(3,R);
    B2 := basis(2,R);
    mats := apply(numgens R, i -> (
        D := diff(R_i, B) % I;
        lift((coefficients(D, Monomials => B2))#1, coefficientRing R)));
    big := fold((a,b) -> a || b, mats);
    Kr := gens kernel big;
    (numcols Kr, B * sub(Kr, R))
    )
gorHF = (K, sd) -> (
    -- K ideal with (R/K)_sd one-dimensional; Hilbert function of R/Ann(functional R_sd -> R_sd/K_sd)
    R := ring K;
    B := basis(sd, R);
    sm := basis(sd, R/K);
    if numcols sm != 1 then (<< "  gorHF: dim (R/K)_" << sd << " = " << numcols sm << " (not 1)" << endl; return null);
    m0 := lift(sm_(0,0), R);
    NF := B % K;
    cf := lift((coefficients(NF, Monomials => matrix{{m0}}))#1, coefficientRing R);
    g := (B * transpose sub(cf,R))_(0,0);
    toList apply(0..sd, d -> (
        C := contract(transpose basis(d,R), matrix{{g}});
        rank lift((coefficients(transpose C, Monomials => basis(sd-d,R)))#1, coefficientRing R)))
    )
hfList = (I, n) -> toList apply(0..n, d -> hilbertFunction(d, I))
pr = s -> (stdio << s << endl << flush);
satLin = I -> saturate(I, ideal(random(1, ring I)));
-- Q10 test: nodal cubic f in P^n; e = n/2-1; relation rho = Tr(g .) on the coordinate ring of the nodes in a random affine chart
q10test = (nm, f, e) -> (
    Rh := ring f; n := numgens Rh - 1; kk := coefficientRing Rh;
    t := symbol t;
    Ra := kk[t_1..t_n];
    lin := apply(n+1, i -> random(kk) + sum apply(n, j -> random(kk) * Ra_j));   -- random affine chart (random projective change of coordinates, then x_0 = 1)
    fa := (map(Ra, Rh, lin)) f;
    Ia := ideal fa + ideal jacobian ideal fa;
    A := Ra/Ia;
    B := basis A; N := numcols B;
    Bl := lift(B, Ra);
    mult := b -> lift((coefficients((b * Bl) % Ia, Monomials => Bl))#1, kk);
    Ms := apply(N, j -> mult(Bl_(0,j)));
    tr := matrix{apply(Ms, trace)};
    T := matrix apply(N, i -> flatten entries (tr * Ms#i));
    mons := matrix{flatten apply(e+1, d -> flatten entries basis(d, Ra))};
    C := lift((coefficients(mons % Ia, Monomials => Bl))#1, kk);
    rk := rank C;
    pr(nm | ": n=" | toString n | ", nodes N=" | toString N | " (trace form nondegenerate, i.e. node scheme reduced: " | toString(det T != 0) | "), rank of evaluation of forms of degree " | toString e | " = " | toString rk);
    if rk != N-1 then (pr("   no single relation; skipping"); return null);
    r := gens kernel transpose C;
    gc := solve(T, r);
    g := (Bl * sub(gc, Ra))_(0,0);
    Hess := matrix table(n, n, (i,j) -> diff(Ra_i, diff(Ra_j, fa)));
    HA := sub(Hess, A);
    D := det(HA, Strategy => Cofactor);
    gA := sub(g, A);
    val := lift(gA^2 * D, Ra);
    pr("   g a unit on Z (all coefficients of the relation nonzero): " | toString(ideal(gA) == ideal(1_A)) | ";  g^2 * D = " | (if #support val == 0 then toString val | "  CONSTANT" else "non-constant (" | toString(#terms val) | " terms in normal form)"));
    -- negative controls
    D1 := det(submatrix(HA, toList(0..n-2), toList(0..n-2)), Strategy => Cofactor);
    v1 := lift(gA^2 * D1, Ra);
    pr("   control 1 (principal (n-1)x(n-1) minor instead of D): " | (if #support v1 == 0 then "constant " | toString v1 else "non-constant (" | toString(#terms v1) | " terms)"));
    v1b := lift(gA * D, Ra); v1c := lift(gA^3 * D, Ra); v1d := lift(gA^2 * D^2, Ra);
    pr("   control 2 (wrong exponents g*D, g^3*D, g^2*D^2): " | toString apply({v1b,v1c,v1d}, v -> if #support v == 0 then "constant" else "non-constant"));
    if e >= 1 then (
        mons2 := matrix{flatten apply(e, d -> flatten entries basis(d, Ra))};
        C2 := lift((coefficients(mons2 % Ia, Monomials => Bl))#1, kk);
        r2 := (gens kernel transpose C2) * random(kk^(N - rank C2), kk^1);
        g2 := sub((Bl * sub(solve(T, r2), Ra))_(0,0), A);
        v2 := lift(g2^2 * D, Ra);
        pr("   control 3 (a random relation on forms of degree " | toString(e-1) | " instead of the relation on degree " | toString e | "): " | (if #support v2 == 0 then "constant" else "non-constant")));
    )
