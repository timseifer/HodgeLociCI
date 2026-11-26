-- Blind check 12, C4 and C5: symmetry algebras of determinantal cubics in 8 variables.
-- Own code, exact over ZZ/32003 and over QQ.
lieMat = G -> (
    R := ring G; n := numgens R;
    cols := flatten apply(n, i -> apply(n, j -> R_i * diff(R_j, G)));
    sub(last coefficients(matrix{cols}, Monomials => basis(3, R)), coefficientRing R));
lieDim = G -> (numgens ring G)^2 - rank lieMat G;
-- 3x3 matrix of linear forms in 8 variables, entries spanning all 8 forms, single relation tr(C B) = 0
mkB = (R, C) -> (
    k := coefficientRing R;
    c := matrix{flatten entries transpose C};          -- 1 x 9 : the coefficient of B_ij is C_ji
    Kc := gens ker c;                                   -- 9 x 8, columns span the hyperplane c-perp
    N := Kc * random(k^8, k^8);
    while rank N < 8 do N = Kc * random(k^8, k^8);
    forms := flatten entries (N * transpose vars R);    -- 9 linear forms spanning the 8 variables
    B := matrix apply(3, i -> apply(3, j -> forms#(3*i+j)));
    assert(trace(sub(C, R) * B) == 0);
    B);
randRank = (k, r) -> (C := random(k^3, k^r) * random(k^r, k^3); while rank C != r do C = random(k^3, k^r) * random(k^r, k^3); C);
scan({ZZ/32003, QQ}, k -> (
    R := k[y_0..y_7];
    << "---- field " << toString k << endl;
    for r from 1 to 3 do (
        ntrials := if k === QQ then 2 else 6;
        ds := apply(ntrials, t -> lieDim det mkB(R, randRank(k, r)));
        << "rank C = " << r << " : dim of the symmetry algebra of det B, " << ntrials << " random examples: " << ds << endl);
    Cs := {matrix(k, {{1,0,0},{0,1,0},{0,0,1}}), matrix(k, {{1,0,0},{0,1,0},{0,0,0}}), matrix(k, {{1,0,0},{0,0,0},{0,0,0}})};
    << "normal forms C = diag(1,1,1), diag(1,1,0), diag(1,0,0): " << apply(Cs, C -> lieDim det mkB(R, C)) << endl;
    ntr := if k === QQ then 2 else 5;
    << "general cubic: " << apply(ntr, t -> lieDim random(3, R)) << endl;
    << "det A + det B, both rank C = 3: " << apply(ntr, t -> lieDim(det mkB(R, randRank(k, 3)) + det mkB(R, randRank(k, 3)))) << endl;
    << "det A + det B, ranks (3,2),(2,2),(1,1),(3,1): " << apply({(3,2),(2,2),(1,1),(3,1)}, p -> lieDim(det mkB(R, randRank(k, p#0)) + det mkB(R, randRank(k, p#1)))) << endl;
    << "det A + (linear form)^3, rank C = 3: " << apply(2, t -> lieDim(det mkB(R, randRank(k, 3)) + (random(1, R))^3)) << endl;
    ));
-- C5: cubics killed by the symmetry algebra of the determinant on traceless matrices (adjoint representation of sl_3)
k = QQ; R = k[y_0..y_7]; n = 8;
X = matrix{{y_0, y_1, y_2},{y_3, y_4, y_5},{y_6, y_7, -y_0-y_4}};
G0 = det X;
Ker = gens ker lieMat G0;                              -- 64 x 8 : the fields, L_(i,j) at row n*i+j
<< "---- C5 over QQ: G0 = det(general traceless 3x3 matrix); number of fields: " << numcols Ker << endl;
Ls = apply(numcols Ker, a -> matrix apply(n, i -> apply(n, j -> Ker_(n*i+j, a))));
invDim = (Ls, d) -> (
    mons := flatten entries basis(d, R);
    blocks := apply(Ls, L -> (
        imgs := apply(mons, m -> sum(n, i -> sum(n, j -> L_(i,j) * R_i * diff(R_j, m))));
        sub(last coefficients(matrix{imgs}, Monomials => basis(d, R)), k)));
    #mons - rank fold((a, b) -> a || b, blocks));
<< "dim of forms killed by all 8 fields: degree 1: " << invDim(Ls, 1) << ", degree 2: " << invDim(Ls, 2) << ", degree 3: " << invDim(Ls, 3) << endl;
-- Killing form of the 8 fields (rank 8 <=> semisimple) and commutant (dim 1 <=> irreducible on the 8 linear forms)
vecs = apply(Ls, L -> flatten entries L);
Mb = transpose matrix vecs;                            -- 64 x 8
ad = apply(8, a -> matrix apply(8, c -> apply(8, b -> 0_k)));
coords = L -> flatten entries solve(Mb, transpose matrix{flatten entries L});
adm = apply(8, a -> transpose matrix apply(8, b -> coords(Ls#a * Ls#b - Ls#b * Ls#a)));
Kil = matrix apply(8, a -> apply(8, b -> trace(adm#a * adm#b)));
<< "rank of the Killing form: " << rank Kil << endl;
-- same test for a random rank-3 example and for the rank-2 and rank-1 normal forms: are they semisimple?
scan({(3, "random rank 3"), (2, "random rank 2"), (1, "random rank 1")}, p -> (
    G := det mkB(R, randRank(k, p#0));
    Kr := gens ker lieMat G; m := numcols Kr;
    L2 := apply(m, a -> matrix apply(n, i -> apply(n, j -> Kr_(n*i+j, a))));
    Mb2 := transpose matrix apply(L2, L -> flatten entries L);
    co := L -> flatten entries solve(Mb2, transpose matrix{flatten entries L});
    ad2 := apply(m, a -> transpose matrix apply(m, b -> co(L2#a * L2#b - L2#b * L2#a)));
    K2 := matrix apply(m, a -> apply(m, b -> trace(ad2#a * ad2#b)));
    << p#1 << ": number of fields " << m << ", rank of Killing form " << rank K2 << ", cubics killed by all fields: " << invDim(L2, 3) << endl));
