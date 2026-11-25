-- BC-SO3 exporter: GB-dependent data for the numpy order-3 engine o3np.py (all other arithmetic is done in numpy).
-- needs o3bc.m2 loaded (engineSetup, gSetup, decomp, nuSetup, pairMat, coefM, qVector)
wmat = (fn, M) -> (fn << toString(numrows M) << " " << toString(numcols M) << "\n" << toString flatten entries lift(M, ZZ) << "\n" << close);
wlist = (fn, L) -> (fn << toString L << "\n" << close);
exportData = (dir, E, G, opts) -> (
    S := E#"S"; kk := E#"kk"; nv := E#"nv"; sig := E#"sig"; dQ := E#"dQ"; k := E#"k"; N := E#"N"; H := E#"H";
    fI := E#"fI"; r := #fI;
    makeDirectory dir;
    t0 := cpuTime();
    if not opts#?"resume" then (
    wlist(dir | "/header.txt", {char kk, nv, k, sig, dQ, r, E#"degs", E#"nW"});
        -- monomial bases in M2 order, degrees 0..sig
        scan(sig + 1, d -> wlist(dir | "/basis" | toString d | ".txt", apply(flatten entries basis(d, S), m -> first exponents m)));
        wmat(dir | "/nu.txt", N#"nuv");
        wmat(dir | "/F.txt", coefM(S, 3, matrix{{(H#"F")}}));
        wmat(dir | "/G.txt", coefM(S, 3, matrix{{G}}));
        scan(r, j -> wmat(dir | "/f" | toString j | ".txt", coefM(S, (E#"degs")#j, matrix{{fI#j}})));
        wlist(dir | "/wgens.txt", apply(E#"Wg", w -> {w#0, first exponents (w#1)}));
        -- decompositions of G*v, v in basis(dQ)
        (stdio << "  [exp] start gSetup" << endl << flush);
        gSetup(E, G);
        scan(nv, i -> wmat(dir | "/ga" | toString i | ".txt", coefM(S, sig - 2, (E#"ga")^{i})));
        scan(r, j -> wmat(dir | "/gc" | toString j | ".txt", coefM(S, sig - (E#"degs")#j, (E#"gc")^{j})));
        (stdio << "  [exp] G decomps done, cpu " << cpuTime() - t0 << endl << flush);
    );
    -- B(W, y) = nu(b_y . grad W) for standard monomials y of (S/I)_sig, then Dfull on all monomials of S_sig
    Rm := apply(flatten entries basis(sig, S/(E#"I")), u -> lift(u, S));
    (stdio << "  [exp] Rm " << #Rm << endl << flush);
    Wp := matrix{apply(E#"Wg", w -> fI#(w#0) * (w#1))};
    Pr := pairMat(S, sig - 2, 2, N#"nuv");
    Ei := apply(nv, i -> Pr * coefM(S, 2, matrix{{diff(S_i, Wp)}}));
    wlist(dir | "/Rm.txt", apply(Rm, m -> first exponents m));
    Rmi := hashTable apply(#Rm, i -> (Rm#i, i));
    if not fileExists(dir | "/NF.txt") then (
        nfm := flatten entries ((basis(sig, S)) % gb(E#"I"));
        trip := flatten apply(#nfm, i -> if nfm#i == 0 then {} else apply(terms nfm#i, tm -> {i, Rmi#(leadMonomial tm), lift(leadCoefficient tm, ZZ)}));
        wlist(dir | "/NF.txt", trip));
    chunks := pack(100, Rm);
    scan(#chunks, c -> if not fileExists(dir | "/DR_" | toString c | ".txt") then (
        caR := decomp(H, N, matrix{chunks#c}); bR := caR#"a";
        wmat(dir | "/DR_" | toString c | ".txt", sum(nv, i -> (transpose coefM(S, sig - 2, bR^{i})) * Ei#i));
        (stdio << "  [exp] DR chunk " << c << " of " << #chunks << ", cpu " << cpuTime() - t0 << endl << flush)));
    wlist(dir | "/nchunks.txt", #chunks);
    -- GD syzygies (A, c): A.dF + c.f = 0, and syzygies of the generators of I, degree <= opts#"syzdeg"
    jac := transpose jacobian matrix{{H#"F"}};
    M := (matrix{fI}) | jac;
    Z := syz(M, DegreeLimit => opts#"syzdeg");
    dz := apply(numcols Z, i -> first((degrees source Z)#i));
    wlist(dir | "/syzdeg.txt", dz);
    scan(numcols Z, i -> (
        dd := dz#i;
        rowsC := apply(r, j -> coefM(S, dd - (E#"degs")#j, matrix{{Z_(j,i)}}));
        rowsA := apply(nv, m -> coefM(S, dd - 2, matrix{{Z_(r+m,i)}}));
        wlist(dir | "/syz" | toString i | ".txt", apply(rowsC | rowsA, x -> flatten entries lift(x, ZZ)))));
    Z0 := syz(matrix{fI}, DegreeLimit => opts#"syzdeg");
    dz0 := apply(numcols Z0, i -> first((degrees source Z0)#i));
    wlist(dir | "/syz0deg.txt", dz0);
    scan(numcols Z0, i -> (dd := dz0#i;
        wlist(dir | "/syz0_" | toString i | ".txt", apply(r, j -> flatten entries lift(coefM(S, dd - (E#"degs")#j, matrix{{Z0_(j,i)}}), ZZ)))));
    -- BC-SO order-2 vector psi(G^2 mu), mu in basis(dQ) (kappa-free family-derivative route), for cross-check
    if opts#"qv" then (
        ca := decomp(H, N, G * basis(dQ, S));
        qv := qVector(H, N, G, ca);
        wmat(dir | "/qv.txt", qv));
    (stdio << "  [exp] all done, cpu " << cpuTime() - t0 << endl << flush);
    );
end
