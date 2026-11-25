-- BC-SO3 order-3 engine (own code; builds on BC-SO's solib/famlib helpers: hsData, coefM, nuSetup, decomp, qVector).
-- Single algebraic cycle Y with ideal I (generated in degrees <= 3), F in I_3, n = 2k, cubic.
-- Phi_m(P) = int_Y Res(P Omega/F^m). pi = Phi_(k+1) on S_sig, psi = Phi_(k+2) on S_(sig+3), psi3 = Phi_(k+3) on S_(sig+6).
-- Rules used (ARG): GD  Phi_(m+1)(A.dF) = Phi_m(div A)/m ; pi = 0 on (I+J)_sig (pi(mstd) = 1); psi = 0 on I^2; psi3 = 0 on I^3.
-- Level 2 on I: psi(W*Y) = nu(b_Y . grad W)/(k+1) + lambda(Y) kappa(W) for W in I_3, Y = b.dF + e.f + lambda mstd.
-- kappa(W) = psi(W mstd) is an unknown linear functional on I_3, fixed by consistency relations (syzygies, GD, I^2).
-- Values are rows [const | kappa-coefficients] (length 1 + #Wgens).
dir0 = "/home/claude/hodge/discovery/checks/bc_so/";
load(dir0 | "solib.m2"); load(dir0 | "famlib.m2"); load(dir0 | "order2.m2");

engineSetup = (F, I) -> (
    H := hsData F; S := H#"S"; kk := coefficientRing S;
    I = ideal mingens I;
    N := nuSetup(H, I);
    fI := flatten entries gens I;
    degs := apply(fI, f -> first degree f);
    if max degs > 3 then error "generators of degree > 3";
    Wg := flatten apply(#fI, j -> apply(flatten entries basis(3 - degs#j, S), u -> (j, u)));
    widx := hashTable apply(#Wg, w -> (Wg#w, w));
    E := new MutableHashTable from {"H"=>H, "N"=>N, "S"=>S, "kk"=>kk, "I"=>I, "fI"=>fI, "degs"=>degs, "Wg"=>Wg, "widx"=>widx,
        "nW"=>#Wg, "k"=>H#"k", "sig"=>H#"sig", "dQ"=>H#"q0", "nv"=>numgens S, "mcache"=>new MutableHashTable};
    E
    );
zeroRow = E -> map((E#"kk")^1, (E#"kk")^(1 + E#"nW"), 0);
constRow = (E, c) -> (r := mutableMatrix zeroRow E; r_(0,0) = c; matrix r);
nuOf = (E, P) -> (if P == 0 then 0_(E#"kk") else (nuApply(E#"H", E#"N", matrix{{P}}))_(0,0));
-- first factor of degree e of monomial t (same rule as famlib firstFactor)
splitPoly = (E, P, e) -> (
    -- returns hash u -> sum of c * t/u over terms c*t of P with firstFactor(t,e) = u
    h := new MutableHashTable;
    if P == 0 then return h;
    scan(terms P, tm -> (
        t := leadMonomial tm; c := leadCoefficient tm;
        u := firstFactor(t, e);
        y := (c * t) // u;
        if h#?u then h#u = h#u + y else h#u = y));
    h
    );
-- psi on an element of I_(sig+3) given by a representation R = list over generators j of polys (P = sum f_j R_j)
psiIrep = (E, R) -> (
    S := E#"S"; kk := E#"kk"; k := E#"k"; nW := E#"nW";
    Ws := {}; Ys := {}; ws := {};
    scan(#R, j -> if R#j != 0 then (
        h := splitPoly(E, R#j, 3 - (E#"degs")#j);
        scan(keys h, u -> (ws = append(ws, (E#"widx")#(j, u)); Ws = append(Ws, (E#"fI")#j * u); Ys = append(Ys, h#u)))));
    out := mutableMatrix zeroRow E;
    if #Ys == 0 then return matrix out;
    ca := decomp(E#"H", E#"N", matrix{Ys});
    a := ca#"a"; rem := ca#"rem";
    cst := 0_kk;
    scan(#Ys, i -> (
        g := sum(E#"nv", m -> a_(m,i) * diff(S_m, Ws#i));
        cst = cst + nuOf(E, g);
        out_(0, 1 + ws#i) = out_(0, 1 + ws#i) + rem_(0,i)));
    out_(0,0) = cst / (k+1);
    matrix out
    );
-- representation of P in I (division by gens I)
repOf = (E, P) -> (
    S := E#"S"; g := gens E#"I";
    q := (matrix{{P}}) // g;
    if g * q != matrix{{P}} then error "repOf: not in I";
    flatten entries q
    );
psiI = (E, P) -> psiIrep(E, repOf(E, P));
-- G-data: decompositions of G*v, v in basis(dQ)
gSetup = (E, G) -> (
    S := E#"S"; bq := basis(E#"dQ", S);
    ca := decomp(E#"H", E#"N", G * bq);
    if ca#"rem" != 0 then error "gSetup: G not in T NL";
    E#"G" = G; E#"bq" = flatten entries bq; E#"bqidx" = hashTable apply(numcols bq, i -> (bq_(0,i), i));
    E#"ga" = ca#"a"; E#"gc" = ca#"c";
    );
-- psi(G*Y), Y in S_sig, via Y = sum_u u y_u (u in S_dQ): psi(G u y) = pi(div(y a_u))/(k+1) + psi(y c_u . f)
GammaG = (E, Y) -> (
    S := E#"S"; k := E#"k"; r := #(E#"fI");
    h := splitPoly(E, Y, E#"dQ");
    us := keys h;
    if #us == 0 then return zeroRow E;
    yrow := matrix{apply(us, u -> h#u)};
    cols := apply(us, u -> (E#"bqidx")#u);
    A := (E#"ga")_cols; C := (E#"gc")_cols;
    Ab := A * transpose yrow;   -- nv x 1
    Cc := C * transpose yrow;   -- r x 1
    dv := sum(E#"nv", m -> diff(S_m, Ab_(m,0)));
    constRow(E, nuOf(E, dv) / (k+1)) + psiIrep(E, flatten entries Cc)
    );
-- split an I-part e (r x 1 matrix of polys, P = sum e_j f_j) as sum_v Wsum_v * v, v in S_dQ:
-- returns (list of v-indices, list of representations of Wsum_v (lists over j))
splitE = (E, e) -> (
    r := #(E#"fI"); hv := new MutableHashTable;
    scan(r, j -> if e_(j,0) != 0 then (
        dj := (E#"degs")#j;
        scan(terms e_(j,0), tm -> (
            t := leadMonomial tm; c := leadCoefficient tm;
            u := firstFactor(t, 3 - dj); v := t // u;
            vi := (E#"bqidx")#v;
            if not hv#?vi then hv#vi = new MutableList from toList(r:0_(E#"S"));
            (hv#vi)#j = (hv#vi)#j + c*u))));
    vs := keys hv;
    (vs, apply(vs, vi -> toList(hv#vi)))
    );
repPoly = (E, rep) -> sum(#rep, j -> (E#"fI")#j * rep#j);
-- psi3(G*G*X) for X in S_sig with nu(X) = 0
psi3GGX = (E, X) -> (
    S := E#"S"; k := E#"k"; G := E#"G"; nv := E#"nv"; r := #(E#"fI");
    ca := decomp(E#"H", E#"N", matrix{{X}});
    if ca#"rem" != 0 then error "psi3GGX: nu(X) != 0";
    b := ca#"a"; e := ca#"c";
    divb := sum(nv, m -> diff(S_m, b_(m,0)));
    bgG := sum(nv, m -> b_(m,0) * diff(S_m, G));
    T1 := GammaG(E, G*divb + 2*bgG);
    (vs, reps) := splitE(E, e);
    ga := E#"ga"; gc := E#"gc";
    -- T2a: psi(sum_v Wsum_v (G div a_v + a_v.grad G)) + psi(G * sum_v a_v.grad Wsum_v)
    Racc := new MutableList from toList(r:0_S);
    Y2 := 0_S;
    U := new MutableHashTable;   -- v' -> polynomial U_v' in I^2
    scan(#vs, i -> (
        v := vs#i; rep := reps#i; Wv := repPoly(E, rep);
        av := ga_{v};
        Yv := G * sum(nv, m -> diff(S_m, av_(m,0))) + sum(nv, m -> av_(m,0) * diff(S_m, G));
        scan(r, j -> Racc#j = Racc#j + rep#j * Yv);
        Y2 = Y2 + sum(nv, m -> av_(m,0) * diff(S_m, Wv));
        -- split c_v . f into sum_v' W'_{v,v'} v'
        (vs2, reps2) := splitE(E, gc_{v});
        scan(#vs2, i2 -> (
            v2 := vs2#i2; W2 := repPoly(E, reps2#i2);
            if U#?v2 then U#v2 = U#v2 + Wv * W2 else U#v2 = Wv * W2))));
    T2a := psiIrep(E, toList Racc) + GammaG(E, Y2);
    PB := 0_S;
    scan(keys U, v2 -> (av := ga_{v2}; PB = PB + sum(nv, m -> av_(m,0) * diff(S_m, U#v2))));
    T2b := psiI(E, PB);
    (1/(k+2)) * (T1 + T2a + T2b)
    );
-- relations for kappa: rows [const | coeffs] that must vanish: value(rep) - known
-- (i) GD syzygies (A, c): A.dF + c.f = 0  =>  psi(mu * (-c).f) = pi(div(mu A))/(k+1)
-- (ii) I^2: psi(f_i f_j mu) = 0 ; (iii) syzygies of gens I: rep of 0
kappaRelations = (E, nrel, sd, nm) -> (
    setRandomSeed sd;
    rmon := (dg) -> (bb := flatten entries basis(dg, E#"S"); sum(nm, t -> random(E#"kk") * bb#(random(#bb))));
    S := E#"S"; kk := E#"kk"; k := E#"k"; nv := E#"nv"; fI := E#"fI"; r := #fI; sig := E#"sig";
    jac := transpose jacobian matrix{{(E#"H")#"F"}};
    M := (matrix{fI}) | jac;
    Z := syz(M, DegreeLimit => sig);
    dz := apply(numcols Z, i -> first degree Z_(0,i) + first degree M_(0,0) - first degree M_(0,0));
    -- degrees of syzygy columns (as degree of the relation element)
    dz = apply(numcols Z, i -> (first((degrees source Z)#i)));
    Z0 := syz(matrix{fI}, DegreeLimit => sig);
    dz0 := apply(numcols Z0, i -> first((degrees source Z0)#i));
    rows := {};
    cnt := 0;
    while cnt < nrel do (
        typ := cnt % 3;
        if typ == 0 then (
            -- GD syzygy times random monomial
            i := random(numcols Z); d0 := dz#i;
            if d0 <= sig + 3 then (
                mu := rmon(sig + 3 - d0);
                c := apply(r, j -> - mu * Z_(j,i)); A := apply(nv, m -> mu * Z_(r+m, i));
                known := nuOf(E, sum(nv, m -> diff(S_m, A#m))) / (k+1);
                rows = append(rows, psiIrep(E, c) - constRow(E, known)); cnt = cnt + 1))
        else if typ == 1 then (
            i1 := random r; i2 := random r; dd := (E#"degs")#i1 + (E#"degs")#i2;
            mu2 := rmon(sig + 3 - dd);
            rep := apply(r, j -> if j == i1 then fI#i2 * mu2 else 0_S);
            rows = append(rows, psiIrep(E, rep)); cnt = cnt + 1)
        else (
            -- syzygy of the generators of I times a monomial: a representation of 0
            i3 := random(numcols Z0); d3 := dz0#i3;
            if d3 <= sig + 3 then (
                mu3 := rmon(sig + 3 - d3);
                rows = append(rows, psiIrep(E, apply(r, j -> mu3 * Z0_(j,i3)))));
            cnt = cnt + 1);
        );
    fold((x,y) -> x || y, rows)
    );
-- solve kappa from relation rows Rel (rows [c | v], v.kappa + c = 0); returns (kappa column, rank, consistent)
solveKappa = (E, Rel) -> (
    nW := E#"nW";
    Aq := Rel_(toList(1..nW)); bq := - Rel_{0};
    rk := rank Aq;
    sol := bq // Aq;
    (sol, rk, Aq * sol == bq)
    );
evalRow = (row, kap) -> (row_{0} + row_(toList(1..(numcols row - 1))) * kap)_(0,0);
-- is the kappa-dependence of a value row determined by the relations?
determined = (E, Rel, row) -> (nW := E#"nW"; A := Rel_(toList(1..nW)); rank(A || row_(toList(1..nW))) == rank A);
end
