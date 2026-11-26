-- R13, R14 of PREREG_pairing.md (section 12): the quadrics through the nodes at the generic point of a formal arc
-- of 36-nodal cubics, their linear syzygies, and the algebra of endomorphisms preserving the syzygies.
-- AI-written, unreviewed.  usage (from this folder):  M2 --script pr13_arc_algebra.m2 p seed order which [file]     MOD p.
--    which = c1 (det A + det B), c2 (a cubic containing a Segre fourfold, on the boundary), case (the Coble rung), all.
-- The arc is built as in pr10_arcs.m2.  For a matrix over k[[e]] known modulo e^J, rho_J = (rank over k of its block
-- truncation modulo e^J) - (the same modulo e^(J-1)) = number of elementary divisors e^d with d < J; the rank over
-- k((e)) is at least rho_J.  Finite order: evidence, not proof.
pp = value(scriptCommandLine#1); sd = value(scriptCommandLine#2); Mord = value(scriptCommandLine#3); which = scriptCommandLine#4;
kk = ZZ/pp; setRandomSeed sd;
UT = kk[T];
P2 = kk[TT, ee];
toep = (Ms, J) -> ( r := numRows Ms#0; c := numColumns Ms#0;
    fold((u, v) -> u || v, apply(J, i -> fold((u, v) -> u | v, apply(J, j -> if i >= j then Ms#(i-j) else map(kk^r, kk^c, 0))))) );
rhos = (Ms, Jmax) -> ( rs := {0} | apply(toList(1..Jmax), J -> rank toep(Ms, J)); apply(Jmax, J -> rs#(J+1) - rs#J) );
lastJump = L -> ( d := 0; scan(#L, j -> if (j == 0 and L#0 > 0) or (j > 0 and L#j > L#(j-1)) then d = j); d );
-- the saturated kernel modulo e^m of a matrix known modulo e^J: project the kernel of the truncation, pick a basis
satKer = (Ms, J, m, s) -> ( c := numColumns Ms#0; V := gens ker toep(Ms, J);
    Vm := V^(toList(0..c*m-1));
    sel := Vm * random(kk^(numColumns V), kk^s);
    (rank Vm, rank(sel^(toList(0..c-1))), apply(m, j -> sel^(toList(c*j..c*j+c-1)))) );
arcAlg = (nm, f0, IZ0) -> ( R := ring f0; n := numgens R - 1; tm := cpuTime();
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
    mons2 := flatten apply(3, d -> flatten entries basis(d, Ra));
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
    toP := map(P2, UT, {TT});
    Re := P2 / ideal(toP chi, ee^(Mord+1));
    eR := sub(ee, Re);
    XR := apply(Xs, q -> sub(toP q, Re));
    HinvR := sub(toP Hinv, Re);
    toUT := map(UT, P2, {T, 0});
    coefE := (b, m) -> toUT ((last coefficients(lift(b, P2), Variables => {ee}, Monomials => matrix{{ee^m}}))_(0,0));
    gradf := apply(n, j -> diff(Ra_j, fa));
    -- the arc (as in pr10_arcs.m2)
    gs := new MutableList from apply(Mord+1, m -> 0_Ra);
    gs#1 = (matrix{mons3} * sub(K3 * random(kk^(numColumns K3), kk^1), Ra))_(0,0);
    gradPhi := x -> ( phi := map(Re, Ra, apply(n, j -> XR#j + x_(j,0)));
        transpose matrix{apply(n, j -> phi(gradf#j) + sum(1..Mord, m -> eR^m * phi(diff(Ra_j, gs#m))))} );
    valPhi := x -> ( phi := map(Re, Ra, apply(n, j -> XR#j + x_(j,0))); phi(fa) + sum(1..Mord, m -> eR^m * phi(gs#m)) );
    x := map(Re^n, Re^1, 0);
    obs := {};
    for m from 2 to Mord do (
        x = x - HinvR * gradPhi(x); x = x - HinvR * gradPhi(x);
        beta := coefE(valPhi(x), m);
        o := rhoOf beta; obs = append(obs, o);
        if o != 0 then error("obstruction at order " | toString m);
        rhs := - (cT beta); sol := rhs // W3;
        if W3 * sol != rhs then error "no cubic with the prescribed values";
        gs#m = (matrix{mons3} * sub(sol, Ra))_(0,0) );
    x = x - HinvR * gradPhi(x); x = x - HinvR * gradPhi(x);
    if not ((valPhi(x) == 0) and (gradPhi(x) == 0)) then error "the nodes do not persist";
    << "RESULT " << nm << ": " << N << " nodes ; arc to order " << Mord << ", obstructions " << toString obs << ", nodes persist ; cpu " << cpuTime() - tm << endl << flush;
    -- (a) quadrics through the moving nodes
    Ne := Mord + 1;
    phi := map(Re, Ra, apply(n, j -> XR#j + x_(j,0)));
    ev2 := apply(mons2, mm -> phi mm);
    Es := apply(Ne, j -> fold((u, v) -> u | v, apply(ev2, b -> cT coefE(b, j))));
    rE := rhos(Es, Ne); DE := lastJump rE; m1 := Ne - DE; nq := #mons2 - last rE;
    sk := satKer(Es, Ne, m1, nq);
    << "      (a) evaluation on quadrics: rho_J = " << toString rE << " ; quadrics over K: at most " << nq << " ; saturated kernel modulo e^" << m1
       << ": k-dimension " << sk#0 << " (free of rank " << nq << " would be " << nq * m1 << ") ; leading parts independent: " << (sk#1 == nq) << endl << flush;
    Lq := sk#2;
    -- optional fifth argument: write the arc (the cubics g_m and the quadrics through the moving nodes) to a file for
    -- pr14_arc_split.m2; added after the first runs; it uses no random numbers, so the results above and below are unchanged
    if #scriptCommandLine > 5 then ( fn := scriptCommandLine#5;
        cub := apply(Mord+1, m -> flatten entries lift(last coefficients(matrix{{if m == 0 then fa else gs#m}}, Monomials => matrix{mons3}), ZZ));
        fn << toExternalString(new HashTable from {"p" => pp, "n" => n, "N" => N, "Mord" => Mord, "m1" => m1, "nq" => nq,
            "cubic" => cub, "Lq" => apply(Lq, M -> entries lift(M, ZZ))}) << endl << close;
        << "      arc written to " << fn << endl << flush );
    lin := {1_Ra} | flatten entries vars Ra; nl := #lin;
    Mus := apply(m1, j -> ( qj := flatten entries (matrix{mons2} * sub(Lq#j, Ra));
        lift(last coefficients(matrix{flatten apply(qj, q -> apply(lin, l -> q * l))}, Monomials => matrix{mons3}), kk) ));
    rM := rhos(Mus, m1); DM := lastJump rM; m2 := m1 - DM; ns := nq * nl - last rM;
    ss := satKer(Mus, m1, m2, ns);
    << "      (b) L S_1: rho_J = " << toString rM << " ; linear syzygies over K: at most " << ns << " ; saturated syzygies modulo e^" << m2
       << ": k-dimension " << ss#0 << " (free would be " << ns * m2 << ") ; leading parts independent: " << (ss#1 == ns) << endl << flush;
    Sz := ss#2;
    nr := #mons3 * ns; Pr := random(kk^400, kk^nr);
    mL := min(m2, 5);                                                      -- levels of Lambda used (enough; saves time)
    Lams := apply(mL, j -> matrix{flatten apply(nq, a -> apply(nq, b -> (
        P := sum(j+1, i -> (Mus#i)_(toList(nl*a..nl*a+nl-1)) * ((Sz#(j-i))^(toList(nl*b..nl*b+nl-1))));
        Pr * (transpose matrix{flatten entries P}) )))});
    rL := rhos(Lams, mL);
    << "      (c) the algebra: rho_J(Lambda) = " << toString rL << " ; DIMENSION OF THE ALGEBRA OVER K AT MOST: " << toString apply(rL, r -> nq^2 - r) << " ; cpu " << cpuTime() - tm << endl << flush;
    -- the leading term of the algebra, if the bound stays >= 2
    DL := lastJump rL; m3 := mL - DL; na := nq^2 - last rL;
    if na >= 2 and na <= 4 and m3 >= 1 then ( sa := satKer(Lams, mL, m3, na);
        A0 := (sa#2)#0;                                                    -- nq^2 x na: leading terms, entry (a,b) at index nq*a + b
        idv := transpose matrix{flatten entries id_(kk^nq)};
        << "      algebra modulo e^" << m3 << ": k-dimension " << sa#0 << " (free would be " << na * m3 << ") ; leading terms independent: " << (sa#1 == na)
           << " ; the identity is among the leading terms: " << (rank(A0 | idv) == rank A0) << endl;
        va := A0 * random(kk^na, kk^1);
        ph := matrix(kk, apply(nq, a -> apply(nq, b -> va_(nq*a+b, 0))));
        Pc := kk[lambda]; cp := det(lambda * id_(Pc^nq) - sub(ph, Pc)); fac := factor cp;
        << "      leading term of a random element: characteristic polynomial factors with (degree, multiplicity): " << toString apply(toList fac, t -> (first degree t#0, t#1));
        lf := select(toList fac, t -> first degree t#0 == 1);
        scan(lf, t -> ( ev0 := - sub(t#0, lambda => 0) / leadCoefficient(t#0); Nn := ph - ev0 * id_(kk^nq);
            << " ; eigenvalue of multiplicity " << t#1 << ": rank of (phi - ev) = " << rank Nn << ", of its square = " << rank(Nn * Nn) ));
        << endl << flush );
    );
U = kk[x_0..x_8];
if which == "c1" or which == "all" then (
    A3 = matrix table(3, 3, (i,j) -> random(1, U)); B3 = matrix table(3, 3, (i,j) -> random(1, U));
    arcAlg("control C1: det A + det B", det A3 + det B3, minors(2, A3) + minors(2, B3)) );
if which == "c2" or which == "all" then (
    A3 = genericMatrix(U, 3, 3); B3 = matrix table(3, 3, (i,j) -> random(1, U));
    cof = (i, j) -> (-1)^(i+j) * det submatrix'(A3, {i}, {j});
    Gb = sum flatten apply(3, i -> apply(3, j -> cof(i,j) * B3_(i,j)));
    Jb = saturate ideal jacobian matrix{{Gb}};
    << "C2: the cubic sum cof_ij(A) B_ij: singular scheme of dimension " << dim Jb - 1 << " and degree " << degree Jb << " ; contained in the Segre fourfold of A: " << isSubset(minors(2, A3), Jb) << endl << flush;
    arcAlg("control C2: a cubic through a Segre fourfold, first-order limit of det A - det(A + e B)", Gb, Jb) );
if which == "case" or which == "all" then (
    hs = (v, l) -> v#0^3+v#1^3+v#2^3 + 3*l*v#0*v#1*v#2;
    R9 = kk[z_0..z_2, p_0..p_2, q_0..q_2];
    lam = random kk; xx = apply(3, i -> random kk); a0 = - hs(xx, lam) / (27 * (1 + lam^3));
    zz = {z_0,z_1,z_2}; ps = {p_0,p_1,p_2}; qs = {q_0,q_1,q_2};
    FC = a0 * hs(zz, lam) + hs(ps, lam) + hs(qs, lam) + sum flatten apply(3, i -> apply(3, j -> zz#((i+j)%3) * xx#((i-j)%3) * ps#i * qs#j));
    << "Coble cubic of this seed: singular locus of degree " << degree saturate ideal jacobian matrix{{FC}} << endl << flush;
    U = kk[u_0..u_7, t]; U0 = kk[u_0..u_7]; inc = map(U, U0, (vars U)_{0..7});
    par = map(U0, R9, apply(9, i -> random(1, U0))); G = par FC; Psi = inc random(2, U0);
    arcAlg("THE CASE: section of the Coble rung", inc G + t * Psi + t^2 * random(1, U), inc ideal jacobian matrix{{G}} + ideal(Psi, t)) );
<< "DONE p " << pp << " seed " << sd << " order " << Mord << " " << which << endl;
