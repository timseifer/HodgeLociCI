-- HodgeLociCI/SecondOrder.m2  (owner: agent PA)
-- Item 2: the second-order checker ("cliff detector").  Source: paper 3 (AI-written, unreviewed),
--   Lemma 2.1(3)                      pointwise second-order residue formula
--   Theorem 8.1, Theorem 9.1(2),(3)   the law and the formula in the range
--   Theorem 9.4, Proposition 9.4'     the same on the excess directions E' outside the range, for every r
-- Uses the private helpers hl* of Excess.m2 (same package dictionary).

export { "secondOrderQuadrics", "secondOrderObstruction", "secondOrderFunctional" }

-- (k+1) phi_[Y](P) / kappa = sum_nu Res[P / (phi_0,..,phi_nu^2,..,phi_k; psi_0,..,psi_nu^2,..,psi_k)]
hlSquaredPairData = (phi, psi) -> (
    n2 := #phi;
    seq := phi | psi;
    apply(n2, nu -> hlResidueData apply(#seq, j -> if j == nu or j == nu + n2 then (seq#j)^2 else seq#j))
    );

secondOrderFunctional = method()
secondOrderFunctional(List, List) := (phi, psi) -> (
    if #phi == 0 or #phi != #psi then error "secondOrderFunctional: expected two lists of forms of the same positive length";
    if not all(phi | psi, u -> instance(u, RingElement)) then error "secondOrderFunctional: expected lists of polynomials";
    S := ring first phi;
    hlCheckRing S;
    if not all(phi | psi, u -> ring u === S and u != 0 and isHomogeneous u and hlDeg u >= 1) then
        error "secondOrderFunctional: expected nonzero homogeneous forms of positive degree in one ring";
    if numgens S != 2 * #phi then error("secondOrderFunctional: expected k+1 = " | toString(numgens S // 2)
        | " pairs (the ring has " | toString numgens S | " variables)");
    dd := unique apply(#phi, i -> hlDeg(phi#i) + hlDeg(psi#i));
    if #dd != 1 then error "secondOrderFunctional: F = sum phi_i psi_i is not homogeneous";
    kk := coefficientRing S;
    rds := hlSquaredPairData(phi, psi);
    sg := (first rds)#"sigma";
    P -> (
        if instance(P, ZZ) or instance(P, QQ) then P = P_S;
        if not instance(P, RingElement) or ring P =!= S then error "secondOrderFunctional: the argument must lie in the ring of the forms";
        Ps := part(sg, P);
        if Ps == 0 then return 0_kk;
        sum(rds, rd -> first hlResRow(rd, matrix{{Ps}}))
        )
    );

hlCofactor = (M, i, j) -> (
    c := numRows M;
    if c == 1 then return 1_(ring M);
    rr := select(c, a -> a != i); cc := select(c, a -> a != j);
    (-1)^(i+j) * det(submatrix(M, rr, cc), Strategy => Cofactor)
    );

-- quadric of a vector of values on the pairs (a,b), a <= b, as a polynomial in the ring T
hlQuadricPoly = (T, prs, v) -> sum(#prs, t -> (
    (a,b) := prs#t;
    (if a == b then v#t else 2 * v#t) * T_a * T_b));

hlSymMatrix = (kk, e, prs, v) -> (
    H := new MutableHashTable;
    scan(#prs, t -> ( H#(prs#t) = v#t; H#(reverse prs#t) = v#t; ));
    matrix(kk, table(e, e, (a,b) -> H#(a,b)))
    );

-- span and common zeros of a list of quadrics given by their value vectors
hlQuadricSummary = (kk, e, prs, vals) -> (
    nn := getSymbol "n";
    T := kk(monoid[nn_0..nn_(e-1)]);
    V := if #vals == 0 then map(kk^0, kk^(#prs), 0) else matrix(kk, vals);
    rk := rank V;
    spanRows := if rk == 0 then {} else entries transpose mingens image transpose V;
    polys := apply(spanRows, v -> hlQuadricPoly(T, prs, v));
    cz := if rk == 0 then e - 1 else (dim ideal polys) - 1;      -- projective dimension of the common zero locus in P(E')
    new HashTable from {
        "ring" => T, "rank" => rk, "quadrics" => polys,
        "matrices" => apply(spanRows, v -> hlSymMatrix(kk, e, prs, v)),
        "commonZeroLocusDim" => cz
        }
    );

-- the generators Q(vdot) of K by single-component virtual deformations, with the values of
--   q(N_a,N_b)(Q(vdot)) = rho(N_a N_b tr(Mdot adj M)) - D_vdot(N_a N_b det M)  = (k+1)/kappa * Q_0(N_a,N_b)(Q(vdot))
hlQuadricData = D -> (
    if D.cache#?"quadricData" then return D.cache#"quadricData";
    S := D#"ring"; kk := D#"field"; d := D#"degree"; k := D#"k"; c := D#"c"; tau := D#"tau";
    if char kk == 2 then error "second-order computations are not available in characteristic 2";
    sp := k*d - 2*k - 2; r := d - sp; n2 := k + 1;
    ed := hlExcessData D;
    Ep := ed#"Eprime"; e := #Ep;
    f := D#"f"; h := D#"h"; p := D#"p"; s := D#"s"; M := D#"M"; g := D#"g"; q := D#"q"; dM := D#"detM";
    df := D#"degreesF"; dh := D#"degreesH";
    dimK := if sp < 0 then 0 else binomial(sp + 2*k + 1, 2*k + 1) - hlHF(sp, ed#"IZ");
    prs := flatten apply(e, a -> apply(toList(a..e-1), b -> (a,b)));
    gensK := {}; vals := {};
    if tau >= 0 and e > 0 and sp >= 0 then (
        NN := apply(prs, ab -> Ep#(ab#0) * Ep#(ab#1));
        Phi0 := D#"Phi0";
        rd0 := hlResidueData Phi0;
        A := S/(D.cache#"IA");
        -- matrix part: Mdot = x^alpha E_ij, Q = x^alpha f_i h_j, value rho(N N' x^alpha adj(M)_ji)
        for i from 0 to c-1 do for j from 0 to c-1 do (
            dg := sp - df#i - dh#j;
            if dg >= 0 then (
                Bm := lift(basis(dg, A), S);
                cof := hlCofactor(M, i, j);
                rows := apply(NN, w -> if cof == 0 then toList(numColumns Bm : 0_kk) else hlResRow(rd0, (w * cof) * Bm));
                for mm from 0 to numColumns Bm - 1 do (
                    gensK = append(gensK, {"M", (i,j), Bm_(0,mm), Bm_(0,mm) * f#i * h#j});
                    vals = append(vals, apply(#prs, t -> (rows#t)#mm));
                    );
                );
            );
        -- parts f, p, h, s: phidot = x^alpha, Q = x^alpha * partner, value -Res[N N' det M x^alpha/(..,phi^2,..)]
        for pos from 0 to 2*k+1 do (
            phi := Phi0#pos;
            dg := hlDeg phi - r;
            if dg >= 0 then (
                rdp := hlResidueData apply(#Phi0, a -> if a == pos then phi^2 else Phi0#a);
                Bm := lift(basis(dg, S/(rdp#"ideal")), S);
                (kind, idx, partner) := if pos < c then ("f", pos, g#pos)
                    else if pos < n2 then ("p", pos - c, s#(pos - c))
                    else if pos < n2 + c then ("h", pos - n2, q#(pos - n2))
                    else ("s", pos - n2 - c, p#(pos - n2 - c));
                rows := apply(NN, w -> hlResRow(rdp, (w * dM) * Bm));
                for mm from 0 to numColumns Bm - 1 do (
                    gensK = append(gensK, {kind, idx, Bm_(0,mm), Bm_(0,mm) * partner});
                    vals = append(vals, apply(#prs, t -> -(rows#t)#mm));
                    );
                );
            );
        );
    res := new HashTable from {"Eprime" => Ep, "pairs" => prs, "generators" => gensK, "values" => vals,
        "dimK" => dimK, "sigmaPrime" => sp, "r" => r};
    D.cache#"quadricData" = res;
    res
    );

secondOrderQuadrics = method()
secondOrderQuadrics CyclePair := D -> (
    kk := D#"field"; d := D#"degree"; k := D#"k"; tau := D#"tau";
    qd := hlQuadricData D;
    th := excessFromData D;
    e := #(qd#"Eprime");
    sm := if e > 0 then hlQuadricSummary(kk, e, qd#"pairs", qd#"values") else null;
    new HashTable from {
        "tau" => tau, "lambda0" => D#"lambda0", "inRange" => th#"inRange",
        "sigmaPrime" => qd#"sigmaPrime", "r" => qd#"r",
        "eTau" => th#"eTau",
        "excessDirections" => qd#"Eprime",
        "dimEprime" => e,
        "conditionS" => th#"conditionS",
        "dimK" => qd#"dimK",
        "generators" => qd#"generators",
        "values" => qd#"values",
        "pairs" => qd#"pairs",
        "quadrics" => (if sm === null then {} else sm#"quadrics"),
        "quadricMatrices" => (if sm === null then {} else sm#"matrices"),
        "rankOfQuadrics" => (if sm === null then 0 else sm#"rank"),
        "commonZeroLocusDim" => (if sm === null then -1 else sm#"commonZeroLocusDim"),
        "normalisation" => "values are rho(N N' tr(Mdot adj M)) - D_vdot(N N' det M) = ((k+1)/kappa) Q_0(N,N')(Q(vdot)); kappa != 0 is the constant of Lemma 2.1(4); (1/2) Hess = (k kappa/2) ((lambda-lambda0)/lambda) * value",
        "label" => "residues " | D#"label" | "; formula: " | hlProved | ", Theorem 9.1(3), Theorem 9.4(2), Proposition 9.4'"
        }
    );

-- G_lambda(N) for N in E': N det M = H_1 + H_2 with H_1 in (f,p,s) (inside T V_1), H_2 in (h) (inside T V_2);
-- G_lambda(N) = H_2 + (lambda0/lambda) H_1   (proof of Theorem 9.4(1))
hlExcessVectors = (D, lam) -> (
    kk := D#"field";
    c := D#"c"; lam0 := (D#"lambda0")_kk;
    f := D#"f"; h := D#"h"; p := D#"p"; s := D#"s";
    GM := matrix{f | p | s | h};
    Ep := (hlExcessData D)#"Eprime";
    apply(Ep, N -> (
        w := matrix{{N * D#"detM"}};
        if w % GM != 0 then error "internal error: N det M does not lie in (f,h,p,s)";
        cf := flatten entries (w // GM);
        nfps := #f + #p + #s;
        H1 := sum(nfps, a -> cf#a * (f | p | s)#a);
        H2 := sum(#h, a -> cf#(nfps + a) * h#a);
        H2 + (lam0/lam) * H1
        ))
    );

-- the second-order term computed from the pointwise formula (Lemma 2.1(3)): for each generator Q of K and pair (a,b),
--   sum_nu Res[Q G_a G_b/Phi^1_(nu)] + lambda sum_nu Res[Q G_a G_b/Phi^2_(nu)] = ((k+1)/kappa) phi_delta_lambda(Q G_a G_b)
hlPointwiseValues = (D, lam) -> (
    qd := hlQuadricData D;
    kk := D#"field";
    prs := qd#"pairs"; gensK := qd#"generators";
    if #gensK == 0 or #prs == 0 then return {};
    if not D.cache#?"squaredPairs" then D.cache#"squaredPairs" = (
        hlSquaredPairData(D#"f" | D#"p", D#"g" | D#"s"), hlSquaredPairData(D#"h" | D#"p", D#"q" | D#"s"));
    (rds1, rds2) := D.cache#"squaredPairs";
    Gs := hlExcessVectors(D, lam);
    Qrow := matrix{apply(gensK, u -> u#3)};
    perPair := apply(prs, ab -> (
        W := (Gs#(ab#0) * Gs#(ab#1)) * Qrow;
        r1 := apply(rds1, rd -> hlResRow(rd, W));
        r2 := apply(rds2, rd -> hlResRow(rd, W));
        apply(#gensK, gi -> sum(r1, row -> row#gi) + lam * sum(r2, row -> row#gi))
        ));
    apply(#gensK, gi -> apply(#prs, t -> (perPair#t)#gi))
    );

secondOrderObstruction = method(Options => {Strategy => "Formula"})
secondOrderObstruction(CyclePair, Thing) := opts -> (D, lambda) -> (
    kk := D#"field"; d := D#"degree"; k := D#"k"; tau := D#"tau";
    lam := hlToField(lambda, kk);
    if lam == 0 then error "secondOrderObstruction: lambda must be nonzero";
    strat := opts.Strategy;
    if not member(strat, {"Formula", "Pointwise", "Both"}) then
        error "secondOrderObstruction: Strategy must be \"Formula\", \"Pointwise\" or \"Both\"";
    lam0 := (D#"lambda0")_kk;
    th := excessFromData D;
    qd := hlQuadricData D;
    Ep := qd#"Eprime"; e := #Ep; prs := qd#"pairs";
    sp := qd#"sigmaPrime";
    src := if strat == "Formula" then hlProved | ", Theorem 9.1(3), Theorem 9.4(2), Proposition 9.4'"
        else if strat == "Pointwise" then hlProved | ", Lemma 2.1(3) and the proof of Theorem 9.4(1)"
        else hlProved | ", Lemma 2.1(3) and Theorem 9.1(3)/9.4(2)/Proposition 9.4', computed by both routes";
    base := {
        "lambda" => lambda, "lambda0" => D#"lambda0", "tau" => tau, "inRange" => th#"inRange",
        "eTau" => th#"eTau", "conditionS" => th#"conditionS", "dimK" => qd#"dimK",
        "sigmaPrime" => sp, "r" => qd#"r", "strategy" => strat,
        "arithmetic" => D#"label"
        };
    -- The default label describes a second-order computation. The two NO EXCESS returns make none and pass their own
    -- label (under the key "label" in `more`), which says so and names the arithmetic of the first-order data.
    lbl := "second-order term: residues " | D#"label" | "; formulas: " | src;
    noSecond := "no second-order computation was needed (verdict NO EXCESS); first-order data: ";
    out := (ex, dirs, vd, st, more) -> new HashTable from (base | {
        "excess" => ex, "excessDirections" => dirs, "verdict" => vd, "statement" => st}
        | (if any(more, o -> o#0 === "label") then {} else {"label" => lbl}) | more);
    none := {"quadrics" => {}, "quadricMatrices" => {}, "rankOfQuadrics" => 0, "commonZeroLocusDim" => -1,
        "generators" => {}, "values" => {}, "strategiesAgree" => NotDetermined};
    if tau < 0 then return out(0, {}, "NO EXCESS",
        "tau < 0: NL(delta_lambda) = V_Z for every lambda != 0 (" | hlProved | ", Theorem 2(3)); there is nothing to test at second order",
        none | {"label" => noSecond | "tau < 0, EXACT (integer arithmetic on the degrees of the data); that tau < 0 means no excess: "
            | hlProved | ", Theorem 2(3)"});
    if lam == lam0 then return out(th#"eTau", "all of A_tau (multiples N det M)", "ALL SURVIVE",
        "lambda = lambda0: the e_tau excess directions N det M are tangent to arcs F - t N det M inside NL(delta_lambda0), which is smooth of codimension codim V_Z - e_tau ("
            | hlProved | ", Theorem 1 and Theorem 2(4)); the second-order term vanishes identically by the factor (lambda - lambda0)/lambda",
        none | {"label" => "no second-order computation was needed (lambda = lambda0); first-order data (e_tau, by Hilbert functions): "
            | D#"label" | "; that these directions survive: " | hlProved | ", Theorem 1 and Theorem 2(4)"});
    if e == 0 then return out(0, {}, "NO EXCESS",
        "the annihilator of det M in A_tau is zero, so T NL(delta_lambda) = T V_Z and NL(delta_lambda) = V_Z, smooth (" | hlProved | ", Theorem 2(5))",
        none | {"label" => noSecond | "the annihilator of det M in A_tau is zero, by Hilbert functions and the rank of multiplication by det M, "
            | D#"label" | "; that this means no excess: " | hlProved | ", Theorem 2(5)"});
    if sp < 0 then return out(e, Ep, "ALL SURVIVE",
        "kd-2k-2 < 0: there are no period conditions; the Hodge locus is the whole space",
        none | {"label" => "no second-order computation was needed (kd-2k-2 < 0: no period conditions); first-order data: " | D#"label"});
    factor := (lam - lam0)/lam;
    valsF := apply(qd#"values", v -> apply(v, a -> factor * a));
    agree := NotDetermined;
    vals := valsF;
    if strat != "Formula" then (
        valsP := hlPointwiseValues(D, lam);
        if strat == "Both" then agree = (valsP == valsF);
        vals = valsP;
        );
    sm := hlQuadricSummary(kk, e, prs, vals);
    cz := sm#"commonZeroLocusDim"; rk := sm#"rank";
    inRange := th#"inRange"; cS := th#"conditionS";
    (vd, st) := if rk == 0 and not (inRange or cS) then ("NOT DETERMINED",
            "the quadrics from K vanish on the excess directions, but outside the range with condition (S) false the forms of K_lambda outside K "
            | "give further order-2 conditions (also on pairs (u, N) with u tangent to V_Z) that this test does not compute; "
            | "at Fermat surfaces of degree 7 and 8 such conditions were found to be nonzero (the locus not smooth at order 2). Do not read this as 'no obstruction'")
        else if rk == 0 then ("ALL SURVIVE",
            if qd#"dimK" == 0 and inRange then "K = 0 and the range holds: NL(delta_lambda) is smooth of dimension dim V_Z + e_tau (" | hlProved | ", Theorem 9.1(1))"
            else if qd#"dimK" == 0 then "K = 0: there is no second-order condition coming from K; outside the range nothing more is decided here"
            else "the second-order term vanishes on all excess directions: no obstruction at second order; nothing is decided about higher order (this happens at special points, e.g. when all entries of M lie in (f,h,p,s))"
                | (if not cS then "; condition (S) fails, so forms Q in K_lambda outside K are not controlled (Remark (v) of section 9.1)" else ""))
        else if cz == -1 then ("ALL DIE",
            "the quadrics N -> Q_0(N,N)(Q), Q in K, have no common zero in P(E'): every excess direction is obstructed at second order; "
            | (if cS then "the reduction of NL(delta_lambda) is V_Z and NL(delta_lambda) is non-reduced along V_Z near X (" | hlProved
                    | (if inRange then ", Theorem 9.1(4))" else ", Theorem 9.4(4); condition (S) holds)")
               else "NL(delta_lambda) is not smooth at X (" | hlProved | ", Theorem 9.4(3)); condition (S) fails, so Theorem 9.4(4) does not apply and the reduced structure is not determined here"))
        else ("SOME DIE",
            "the quadrics are not all zero but have common zeros in P(E') (a locus of projective dimension " | toString cz
            | "): NL(delta_lambda) is not smooth at X (" | hlProved | ", Theorem 9.4(3)); the directions in the common zero locus survive at second order, and the structure of the locus is not determined by this test");
    out(e, Ep, vd, st, {
        "quadrics" => sm#"quadrics", "quadricMatrices" => sm#"matrices", "rankOfQuadrics" => rk,
        "commonZeroLocusDim" => cz,
        "generators" => qd#"generators", "values" => vals,
        "strategiesAgree" => agree,
        "normalisation" => "values are ((k+1)/kappa) phi_delta_lambda(Q G_lambda(N) G_lambda(N')), kappa != 0 the constant of Lemma 2.1(4); (1/2) Hess = (k kappa/2) * value"
        })
    );
