-- NF-T6 positive control for the order-2 map: a J-point of V_Z (det M|Pi in (s|Pi)_3, T6c's divisor J; E' = 1,
-- excess direction G = G_lam(1)). Package secondOrderObstruction ("Both") must say ALL DIE (T6c) and my contract-based
-- psi2 must give q(G) != 0 on K = ker L_lam and agree with hlPointwiseValues on the package's generators of K.
load "/home/claude/hodge/discovery/checks/nf_t6/nfb.m2";
setRandomSeed 7; pr = 32003; kk = ZZ/pr; S = kk[x_0..x_11];
f = {x_0, x_1, x_2}; h = {x_3, x_4, x_5}; p = {x_6, x_7, x_8};
M0 = matrix table(3, 3, (i, j) -> random(1, S)); s = apply(3, i -> random(2, S));
ell = random(1, S);
Pi = kk[y_0..y_2]; rPi = map(Pi, S, {0,0,0,0,0,0,0,0,0, y_0, y_1, y_2});
sP = ideal apply(s, u -> rPi u);
B3 = basis(3, Pi); sp3 = matrix{flatten apply(flatten entries gens sP, u -> apply(3, k -> u * Pi_k))};
Ns = gens ker transpose lift((coefficients(sp3, Monomials => B3))#1, kk);   -- functional on Pi_3 killing (s)_3
val = G -> (transpose Ns * lift((coefficients(G, Monomials => B3))#1, kk))_(0,0);
a0 = val(rPi det M0); a1 = val(rPi(ell * det submatrix(M0, {1,2}, {1,2})));
t = -a0 / a1;
M = M0 + t * matrix{{ell, 0, 0}, {0, 0, 0}, {0, 0, 0}};
print("det M|Pi in (s|Pi)_3:", val(rPi det M) == 0);
D = cyclePair(f, h, p, M, s, CheckSmooth => true);
ex = excessFromData D; print("smooth", D#"smooth", "excessElsewhere", ex#"excessElsewhere", "conditionS", ex#"conditionS");
for lam in {2, -1} do (
    so := secondOrderObstruction(D, lam, Strategy => "Both");
    print("lambda", lam, "package verdict", so#"verdict", "strategiesAgree", so#"strategiesAgree", "rank", so#"rankOfQuadrics");
    B := basis(3, S);
    (C1, C2) := hlFirstOrder(D, "Residue");
    L := C1 + lam_kk * C2; kerL := gens ker L;
    (rds1, rds2) := (hlSquaredPairData(D#"f" | D#"p", D#"g" | D#"s"), hlSquaredPairData(D#"h" | D#"p", D#"q" | D#"s"));
    Rd1 := sum(rds1, rd -> (Bs := basis(rd#"sigma", S); (Bs * transpose sub(matrix{hlResRow(rd, Bs)}, S))_(0,0)));
    Rd2 := sum(rds2, rd -> (Bs := basis(rd#"sigma", S); (Bs * transpose sub(matrix{hlResRow(rd, Bs)}, S))_(0,0)));
    G := first hlExcessVectors(D, lam_kk);
    Gv := coefVec(B, matrix{{G}}, kk);
    print("   G in ker L:", L * Gv == 0, " G in T V_Z:", (C1 || C2) * Gv == 0);
    w := dualVec(Rd1, G^2, B, kk) + lam_kk * dualVec(Rd2, G^2, B, kk);
    print("   my q(G) on K = ker L: rank", rank(transpose w * kerL));
    gK := apply((hlQuadricData D)#"generators", u -> u#3);
    mine := apply(gK, Q -> (transpose w * coefVec(B, matrix{{Q}}, kk))_(0,0));
    pv := flatten hlPointwiseValues(D, lam_kk);
    print("   my values on package K-generators == package pointwise values:", mine == pv, " (nonzero:", #select(pv, a -> a != 0), "of", #pv, ")");
    );
