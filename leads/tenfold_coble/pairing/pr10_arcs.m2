-- R10 of PREREG_pairing.md (section 10): formal arcs of cubic sevenfolds keeping all the nodes, order by order.
-- AI-written, unreviewed.  usage (from this folder):  M2 --script pr10_arcs.m2 p seed order          MOD p.
-- f + e g_1 + e^2 g_2 + ... ; the node p moves to p + x(e) (critical point), b(e) = critical value.  At order m the
-- coefficient of e^m of b is  g_m(p) + beta_m(g_1, ..., g_(m-1)).  A cubic g_m with g_m = -beta_m on the nodes exists
-- iff the relation rho kills beta_m:  rho(beta_m) is the obstruction at order m.  Finite order: evidence, not proof.
-- Same set-up as pr8_equisingular.m2 (coordinate ring of the node scheme = k[T]/(chi) after a random change of coordinates).
pp = value(scriptCommandLine#1); sd = value(scriptCommandLine#2); Mord = value(scriptCommandLine#3); kk = ZZ/pp; setRandomSeed sd;
UT = kk[T];
P2 = kk[TT, ee];
arcTest = (nm, f0, IZ0, W0, ndir) -> ( R := ring f0; n := numgens R - 1; tm := cpuTime();
    gch := map(R, R, (vars R) * random(kk^(n+1), kk^(n+1)));
    f := gch f0; IZ := saturate gch IZ0;
    Ra := kk(monoid[Variables => n]);
    deh := map(Ra, R, (vars Ra) | matrix{{1_Ra}});
    Ia := deh IZ; N := degree IZ;
    if dim Ia != 0 or degree Ia != N then error "a node on the hyperplane at infinity of the chart";
    Aq := Ra / Ia; Bq := basis Aq;
    cds := q -> lift(last coefficients(matrix{{q}}, Monomials => Bq), kk);
    ell := (sub((vars Ra) * random(kk^n, kk^1), Aq))_(0,0);
    pw := {1_Aq}; scan(N, i -> pw = append(pw, (last pw) * ell));
    Pm := fold((u, v) -> u | v, apply(N, i -> cds(pw#i)));
    if det Pm == 0 then error "the linear form does not generate the coordinate ring";
    Pinv := inverse Pm;
    toT := v -> sum(N, i -> v_(i,0) * T^i);
    chi := T^N - toT(Pinv * cds(pw#N));
    Xs := apply(n, j -> toT(Pinv * cds(sub(Ra_j, Aq))));
    ev := map(UT, Ra, Xs);
    red := q -> q % chi;
    cT := q -> transpose matrix{apply(N, i -> coefficient(T^i, q))};
    mons3 := flatten apply(4, d -> flatten entries basis(d, Ra));
    W3 := fold((u, v) -> u | v, apply(mons3, m -> cT red ev m));
    rr := gens ker transpose W3;
    if numColumns rr != 1 then error("number of relations on cubics: " | toString numColumns rr);
    K3 := gens ker W3;
    tp := {1_UT}; scan(2*N-2, i -> tp = append(tp, red(T * last tp)));
    Bm := matrix(kk, apply(N, i -> apply(N, j -> coefficient(T^(N-1), tp#(i+j)))));
    hh := toT((inverse Bm) * rr);
    rhoOf := b -> coefficient(T^(N-1), red(hh * b));
    fa := deh f;
    Hs := matrix apply(n, i -> apply(n, j -> red ev diff(Ra_i, diff(Ra_j, fa))));
    Dd := red det Hs; gc := gcdCoefficients(Dd, chi);
    if first degree gc#0 != 0 then error "the Hessian is degenerate at a node";
    Dinv := red(gc#1 * (1 / leadCoefficient gc#0));
    rws := toList(0..n-1);
    Hinv := matrix apply(n, i -> apply(n, j -> red(Dinv * (-1)^(i+j) * det submatrix(Hs, select(rws, a -> a != j), select(rws, b -> b != i)))));
    -- the ring of truncated series over the coordinate ring of the nodes
    toP := map(P2, UT, {TT});
    Re := P2 / ideal(toP chi, ee^(Mord+1));
    eR := sub(ee, Re);
    XR := apply(Xs, q -> sub(toP q, Re));
    HinvR := sub(toP Hinv, Re);
    toUT := map(UT, P2, {T, 0});
    coefE := (b, m) -> toUT ((last coefficients(lift(b, P2), Variables => {ee}, Monomials => matrix{{ee^m}}))_(0,0));
    gradf := apply(n, j -> diff(Ra_j, fa));
    oneArc := c1 -> ( gs := new MutableList from apply(Mord+1, m -> 0_Ra);
        gs#1 = (matrix{mons3} * sub(c1, Ra))_(0,0);
        gradPhi := x -> ( phi := map(Re, Ra, apply(n, j -> XR#j + x_(j,0)));
            transpose matrix{apply(n, j -> phi(gradf#j) + sum(1..Mord, m -> eR^m * phi(diff(Ra_j, gs#m))))} );
        valPhi := x -> ( phi := map(Re, Ra, apply(n, j -> XR#j + x_(j,0))); phi(fa) + sum(1..Mord, m -> eR^m * phi(gs#m)) );
        x := map(Re^n, Re^1, 0);
        obs := {}; ok2 := null; lowOK := true; stopped := false;
        for m from 2 to Mord do ( if stopped then break;
            x = x - HinvR * gradPhi(x); x = x - HinvR * gradPhi(x);
            b := valPhi(x);
            if not all(1..m-1, j -> coefE(b, j) == 0) then lowOK = false;
            beta := coefE(b, m);
            if m == 2 then ( gv := apply(n, j -> red ev diff(Ra_j, gs#1));
                ok2 = (red(beta + (1/2_kk) * sum(n, j -> sum(n, k -> gv#j * Hinv_(j,k) * gv#k))) == 0) );
            o := rhoOf beta; obs = append(obs, o);
            if o != 0 then stopped = true else (
                rhs := - (cT beta); sol := rhs // W3;
                if W3 * sol != rhs then error "no cubic with the prescribed values, although the relation vanishes";
                gs#m = (matrix{mons3} * sub(sol, Ra))_(0,0) ));
        fin := if stopped then "-" else ( x = x - HinvR * gradPhi(x); x = x - HinvR * gradPhi(x);
            toString((valPhi(x) == 0) and (gradPhi(x) == 0)) );
        (obs, ok2, lowOK, fin));
    scan(ndir, d -> ( r := oneArc(K3 * random(kk^(numColumns K3), kk^1));
        << "RESULT " << nm << ", general direction " << d+1 << ": obstructions at orders 2.." << Mord << ": " << toString r#0
           << " ; order-2 term equals -1/2 grad g^T H^(-1) grad g: " << r#1 << " ; lower orders vanish: " << r#2
           << " ; at the end all nodes persist to order " << Mord << " (value and gradient zero): " << r#3 << " ; cpu " << cpuTime() - tm << endl << flush ));
    if W0 =!= null then ( W0M := lift(last coefficients(matrix{apply(W0, w -> deh gch w)}, Monomials => matrix{mons3}), kk);
        r := oneArc(W0M * random(kk^(numColumns W0M), kk^1));
        << "RESULT " << nm << ", a direction tangent to the family of sections of rung members: obstructions " << toString r#0 << " ; nodes persist: " << r#3 << endl << flush ));
skew6 = R -> ( Lf := new MutableHashTable; scan(6, i -> scan(6, j -> if i < j then Lf#(i,j) = random(1, R)));
    matrix table(6, 6, (i,j) -> if i < j then Lf#(i,j) else if i > j then -Lf#(j,i) else 0_R));
hs = (v, l) -> v#0^3+v#1^3+v#2^3 + 3*l*v#0*v#1*v#2;
R9 = kk[z_0..z_2, p_0..p_2, q_0..q_2];
lam = random kk; xx = apply(3, i -> random kk); a0 = - hs(xx, lam) / (27 * (1 + lam^3));
zz = {z_0,z_1,z_2}; ps = {p_0,p_1,p_2}; qs = {q_0,q_1,q_2};
FC = a0 * hs(zz, lam) + hs(ps, lam) + hs(qs, lam) + sum flatten apply(3, i -> apply(3, j -> zz#((i+j)%3) * xx#((i-j)%3) * ps#i * qs#j));
<< "Coble cubic of this seed: singular locus of degree " << degree saturate ideal jacobian matrix{{FC}} << " ; order " << Mord << endl << flush;
U = kk[x_0..x_8];
Qs = apply(4, j -> random(2, U));
arcTest("control: sevenfold through a P^4", sum(4, j -> U_(5+j) * Qs#j), ideal(x_5, x_6, x_7, x_8) + ideal Qs, null, 1);
A3 = matrix table(3, 3, (i,j) -> random(1, U)); B3 = matrix table(3, 3, (i,j) -> random(1, U));
arcTest("control: det A + det B", det A3 + det B3, minors(2, A3) + minors(2, B3), null, 1);
U = kk[u_0..u_7, t]; U0 = kk[u_0..u_7]; inc = map(U, U0, (vars U)_{0..7});
Mk = skew6 U0; Psi = inc random(2, U0);
arcTest("control: section of the Pfaffian rung", inc((gens pfaffians(6, Mk))_(0,0)) + t * Psi + t^2 * random(1, U), inc pfaffians(4, Mk) + ideal(Psi, t), null, 1);
par = map(U0, R9, apply(9, i -> random(1, U0))); G = par FC; Psi = inc random(2, U0);
IC = saturate ideal jacobian matrix{{G}};
W0 = (apply(flatten entries super basis(3, IC), w -> inc w)) | (apply(8, j -> Psi * U_j)) | (apply(flatten entries basis(2, U), m -> t * m));
arcTest("THE CASE: section of the Coble rung", inc G + t * Psi + t^2 * random(1, U), inc ideal jacobian matrix{{G}} + ideal(Psi, t), W0, 3);
<< "DONE p " << pp << " seed " << sd << endl;
