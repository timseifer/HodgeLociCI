-- ex2_count.m2: the intersection count of D-TENFOLD-COBLE-PLANE-COUNT, EXACT over QQ at the named member of
-- ex1_setup.m2.   usage:  M2 --script ex2_count.m2 [mode]      mode: pi (default) | p3 | all
-- Every positive or negative membership statement is verified by identities in the residue field of the point
-- (determinants and substitutions only; no ideal quotient over an extension field is used).
load "ex1_setup.m2"
mode = if #scriptCommandLine > 1 then scriptCommandLine#1 else "pi";
tm0 = cpuTime();
-- a closed point of a zero-dimensional projective scheme: prime ideal q in the polynomial ring T over QQ.
-- Returns (K, list of the coordinates in K, minimal polynomial as a string); K = QQ or toField(QQ[w]/(f)).
closedPoint = (q, T) -> (
    n := numgens T; d := degree q;
    j0 := position(toList(0..n-1), j -> dim(q + ideal(T_j)) <= 0);
    others := select(toList(0..n-1), j -> j != j0);
    if d == 1 then (
        lin := select(flatten entries gens gb q, f -> first degree f == 1);
        sp := flatten entries gens ker matrix(QQ, apply(lin, f -> apply(gens T, v -> coefficient(v, f))));
        return (QQ, sp, "rational"));
    A := QQ[uu_1..uu_(n-1), ww, MonomialOrder => Lex];
    for trial from 0 to 12 do (
        cf := if trial < n - 1 then apply(n - 1, i -> if i == trial then 1 else 0) else apply(n - 1, i -> random(-3, 3));
        sb := apply(n, j -> if j == j0 then 1_A else A_(position(others, o -> o == j)));
        qa := (map(A, T, sb)) q + ideal(A_(n-1) - sum(n - 1, i -> cf#i * A_i));
        gbq := flatten entries gens gb qa;
        fw := select(gbq, g -> all(n - 1, i -> degree(A_i, g) == 0));
        if #fw != 1 or (degree(A_(n-1), fw#0)) != d then continue;
        W := QQ[ww]; toW := map(W, A, toList((n-1) : 0_W) | {W_0});
        f := toW(fw#0); f = f / leadCoefficient f;
        K := toField(W / ideal f);
        co := apply(n - 1, i -> ( gi := select(gbq, g -> leadMonomial g == A_i); if #gi != 1 then error "closedPoint: not in shape position";
            g := gi#0; c := leadCoefficient g; sub(toW(A_i - g / c), K)));
        pt := apply(n, j -> if j == j0 then 1_K else co#(position(others, o -> o == j)));
        return (K, pt, toString f));
    error "closedPoint: no primitive element found");
-- kernel of a 4 x 9 matrix Mt of rank 4 over the field K by Cramer's rule (determinants and one division only);
-- returns (9 x 5 matrix with an identity block on the rows fr, fr) or null if all 4 x 4 minors vanish
kerK = (K, Mt) -> (
    piv := null;
    for Sx in subsets(toList(0..8), 4) do ( if det Mt_Sx != 0 then (piv = Sx; break));
    if piv === null then return null;
    fr := select(toList(0..8), c -> not member(c, piv));
    Mp := Mt_piv; dM := det Mp;
    vecs := apply(fr, j -> ( rhs := - Mt_{j};
        c := apply(4, i -> det(Mp_(toList(0..i-1)) | rhs | Mp_(toList(i+1..3))) / dM);
        apply(9, r -> if r == j then 1_K else if member(r, piv) then c#(position(piv, t -> t == r)) else 0_K)));
    (transpose matrix(K, vecs), fr));
-- membership test of a point y (list of 9 elements of the field K) : is y on a 4-plane of Y through a meeting P(ker Hess_a) in a line?
memberK = (K, y) -> (
    RK := K(monoid[Variables => 9]); mp := map(RK, R, vars RK);
    yv := matrix(K, {y});
    evK := f -> sub(mp f, yv);
    if evK F != 0 or evK Qa != 0 or evK G != 0 then return "not on Y n Q_a n G";
    l1 := lift(evK(lv_(0,0)), K); l2 := lift(evK(lv_(1,0)), K);
    if l1 == 0 and l2 == 0 then return "l_1 = l_2 = 0 (direction not determined)";
    VK := sub(V, K);
    vt := l2 * VK_{0} - l1 * VK_{1};
    gK := mp grad; HK := mp HessF;
    ltau := ((transpose sub(vt, RK)) * gK)_(0,0); btau := ((transpose sub(vt, RK)) * HK * sub(vt, RK))_(0,0);
    ci := lift(sub(jacobian matrix{{mp F, mp Qa, mp G}}, yv), K);
    ciSm := (minors(3, ci) != 0);
    if sub(btau, yv) != 0 then return ("NOT on Z_a: b_tau(y) != 0", ciSm);
    Jm := lift(sub(jacobian matrix{{mp F, mp Qa, ltau, btau}}, yv), K);                 -- 9 x 4
    kr := kerK(K, transpose Jm);
    if kr === null then return ("undecided: the fibre is not smooth at y", ciSm);
    (Tg, fr) := kr;                                                                    -- 9 x 5, identity block on the rows fr
    if (transpose Jm) * Tg != 0 then return ("undecided: kernel not verified", ciSm);
    C5K := K(monoid[Variables => 5]);
    par := (sub(Tg, C5K) * transpose vars C5K);
    onY := ((map(C5K, RK, flatten entries par)) (mp F) == 0);
    if not onY then return ("NOT on Z_a: the only candidate 4-plane (tangent space of the smooth fibre) is not in Y", ciSm);
    inSpan := u -> (u == Tg * u^fr);
    aK := transpose matrix(K, {apt});
    if inSpan aK and inSpan(transpose yv) and inSpan vt then return ("ON Z_a: a 4-plane inside Y through a and y, containing the tangent line of direction tau at a", ciSm);
    ("undecided: plane in Y but incidence failed", ciSm));
-- classify all closed points of a reduced zero-dimensional scheme I in the ring T, points given by the 9 x n matrix M
classify = (I, T, M, label) -> (
    comps := decompose I;
    << label << ": dim " << dim I - 1 << ", degree " << degree I << " ; closed points of degrees " << toString apply(comps, degree)
       << " ; reduced (degrees add up): " << (sum apply(comps, degree) == degree I) << " ; cpu " << cpuTime() - tm0 << endl << flush;
    apply(comps, q -> (
        (K, pt, fs) := closedPoint(q, T);
        y := flatten entries (sub(M, K) * transpose matrix(K, {pt}));
        r := memberK(K, y);
        << "   closed point of degree " << degree q << " [" << (if #fs > 60 then substring(0, 60, fs) | "..." else fs) << "]: " << toString r << " ; cpu " << cpuTime() - tm0 << endl << flush;
        (q, degree q, r))));
setRandomSeed 20261126;
rndZ = (m, n) -> sub(matrix apply(m, i -> apply(n, j -> random(-3, 3))), kk);
if mode == "pi" or mode == "all" then (
    Hm = rndZ(5, 4); Um = rndZ(4, 3);
    piM = Pm * Hm * Um;                                                                -- 9 x 3: the plane pi inside P'
    C3 = kk[s_0..s_2];
    toPi = map(C3, R, flatten entries (sub(piM, C3) * transpose vars C3));
    << "pi: rank " << rank piM << " ; inside P': " << (rank(Pm | piM) == 5) << " ; a on pi: " << (rank(piM | am) == 3) << " ; pi = column span of " << toString entries piM << endl;
    Ipi = ideal(toPi Qa, toPi G);
    << "no point of pi n Q_a with l_1 = l_2 = 0: " << (dim ideal(toPi Qa, toPi lv_(0,0), toPi lv_(1,0)) <= 0) << endl;
    resPi = classify(Ipi, C3, piM, "pi n {Q_a = G = 0}");
    Jpi = toPi jacobian matrix{{F, Qa, G}};
    M3 = (transpose Jpi) * sub(piM, C3);
    scan(resPi, r -> << "   degree " << r#1 << ": Y n Q_a n G smooth at these points: " << (dim(r#0 + minors(3, Jpi)) <= 0)
        << " ; pi meets the tangent space only in the point: " << (dim(r#0 + minors(2, M3)) <= 0) << endl << flush);
    Non = sum apply(select(resPi, r -> instance(r#2, Sequence) and match("^ON Z_a", r#2#0)), r -> r#1);
    Noff = sum apply(select(resPi, r -> instance(r#2, Sequence) and match("^NOT on Z_a", r#2#0)), r -> r#1);
    << "RESULT pi: points on Z_a: " << Non << " ; points not on Z_a: " << Noff << " ; total " << degree Ipi << endl << flush;
    -- the tenfold X and the 5-plane Lambda
    S12 = kk[z_0..z_2, p_0..p_2, q_0..q_2, w_0..w_2];
    inc = map(S12, R, (vars S12)_{0..8});
    lamPi = flatten entries ((vars R) * sub(gens ker transpose piM, R));
    Phi = apply(3, k -> sum apply(lamPi, lf -> (inc lf) * sum(12, i -> random(-2, 2) * S12_i)));
    FX = inc F + sum(3, k -> S12_(9+k) * Phi#k);
    LamI = ideal apply(lamPi, lf -> inc lf);
    << "X = F + sum w_k Phi_k: X n {w = 0} = Y: " << (sub(FX, {S12_9 => 0, S12_10 => 0, S12_11 => 0}) == inc F) << " ; Lambda in X: " << (FX % LamI == 0) << endl;
    den = lcm apply(flatten entries last coefficients FX, c -> denominator lift(c, QQ));
    << "common denominator of the coefficients of X: " << den << endl;
    "X_exact.txt" << toString FX << endl << close;
    scan({32003, 31991}, pr -> ( kp := ZZ/pr; Sp := kp[z_0..z_2, p_0..p_2, q_0..q_2, w_0..w_2];
        FXp := sub(den * FX, Sp); tmx := cpuTime();
        LTX := ideal leadTerm groebnerBasis(ideal jacobian matrix{{FXp}}, Strategy => "F4");
        << "RESULT X modulo " << pr << " (does not divide the denominator: " << (den % pr != 0) << "): smooth: " << (dim LTX == 0) << " ; cpu " << cpuTime() - tmx << endl << flush)));
if mode == "p3" or mode == "all" then (
    L3 = rndZ(9, 4);
    C4 = kk[d_0..d_3];
    toL = map(C4, R, flatten entries (sub(L3, C4) * transpose vars C4));
    << "P^3: rank " << rank L3 << " ; a on it: " << (rank(L3 | am) == 4) << " ; column span of " << toString entries L3 << endl;
    I30 = ideal(toL F, toL Qa, toL G);
    << "no point of the P^3 on Y n Q_a with l_1 = l_2 = 0: " << (dim ideal(toL F, toL Qa, toL lv_(0,0), toL lv_(1,0)) <= 0) << endl << flush;
    res3 = classify(I30, C4, L3, "P^3 n Y n {Q_a = G = 0}");
    Non3 = sum apply(select(res3, r -> instance(r#2, Sequence) and match("^ON Z_a", r#2#0)), r -> r#1);
    Noff3 = sum apply(select(res3, r -> instance(r#2, Sequence) and match("^NOT on Z_a", r#2#0)), r -> r#1);
    << "RESULT P^3: points on Z_a: " << Non3 << " ; points not on Z_a: " << Noff3 << " ; total " << degree I30 << endl << flush);
<< "DONE cpu " << cpuTime() - tm0 << endl;
