-- The intersection count of PREREG_plane.md (P1-P4).  MOD p.  AI-written, unreviewed.
-- usage: M2 --script pl1_count.m2 p seed mode      mode = B : P' = the 4-plane through the odd eigenspace of iota
--                                                   mode = G : P' = a 4-plane through a second random point of A
-- Y = Coble cubic (normal form), A = Sing(Y), a = a rational point of A, Z_a = union of the 4-planes of Y through a.
-- The constructions Q_a, l_tau, b_tau, G and the membership test are those of ../h5c_cycle_sampling.m2.
pp = value(scriptCommandLine#1); sd = value(scriptCommandLine#2); md = scriptCommandLine#3;
setRandomSeed sd; kk = ZZ/pp;
R = kk[z_0..z_2, p_0..p_2, q_0..q_2];
zz = {z_0,z_1,z_2}; ps = {p_0,p_1,p_2}; qs = {q_0,q_1,q_2};
hes = (v, l) -> v#0^3+v#1^3+v#2^3 + 3*l*v#0*v#1*v#2;
x = apply(3, i -> random kk); lam = random kk;
a0 = - hes(x, lam) / (27*(1+lam^3));
F = a0 * hes(zz, lam) + hes(ps, lam) + hes(qs, lam) + sum flatten apply(3, i -> apply(3, j -> zz#((i+j)%3) * x#((i-j)%3) * ps#i * qs#j));
grad = jacobian matrix{{F}};                     -- 9 x 1
HessF = jacobian transpose grad;                 -- 9 x 9
Is = saturate ideal grad;
<< "p = " << pp << ", seed " << sd << ", mode " << md << " ; A = Sing(Y): dim " << dim Is - 1 << " degree " << degree Is << endl << flush;
evalAt = (f, pt) -> sub(f, apply(9, i -> R_i => pt#i));
-- a rational point of a zero-dimensional or positive-dimensional scheme in the ring T (cut by random hyperplanes)
ratPoint = (I, T) -> ( n := numgens T; d := dim I - 1; pt := null; cnt := 0;
    while pt === null and cnt < 80 do ( cnt = cnt + 1;
        cps := decompose(I + ideal apply(d, i -> random(1, T)));
        r1 := select(cps, c -> dim c == 1 and degree c == 1);
        if #r1 > 0 then ( lin := select(flatten entries gens gb first r1, f -> first degree f == 1);
            pt = flatten entries gens ker matrix(kk, apply(lin, f -> apply(gens T, v -> coefficient(v, f))))));
    pt);
-- data attached to a point a of A
baseData = apt -> ( ev := apply(9, i -> R_i => apt#i);
    Ha := lift(sub(HessF, ev), kk);
    TA := gens ker transpose lift(sub(jacobian Is, ev), kk);             -- 9 x 3, affine tangent space of A at a
    am := transpose matrix{apt};
    V := TA * (gens ker transpose (TA \\ am));                           -- two vectors, with (a, V) spanning T_aA
    yv := transpose vars R;
    Qa := ((transpose yv) * sub(Ha, R) * yv)_(0,0);
    Bm := (transpose sub(V, R)) * HessF * sub(V, R);
    lv := (transpose sub(V, R)) * grad;
    G := 2 * (Bm_(1,1) * lv_(0,0)^2 - 2 * Bm_(0,1) * lv_(0,0) * lv_(1,0) + Bm_(0,0) * lv_(1,0)^2);
    new HashTable from {"a" => apt, "V" => V, "Qa" => Qa, "B" => Bm, "l" => lv, "G" => G,
        "ok" => (rank Ha == 6 and rank TA == 3 and Ha * TA == 0 and rank(am | V) == 3)});
-- the 4-plane of Y through a and y, if there is one: returns (9 x 5 matrix) or a string saying why not
planeThrough = (D, y) -> ( l1 := evalAt((D#"l")_(0,0), y); l2 := evalAt((D#"l")_(1,0), y);
    if evalAt(F, y) != 0 or evalAt(D#"Qa", y) != 0 or evalAt(D#"G", y) != 0 then return "not on Y n Q_a n G";
    if l1 == 0 and l2 == 0 then return "l_1 = l_2 = 0";
    t1 := l2; t2 := -l1;
    vt := t1 * (D#"V")_{0} + t2 * (D#"V")_{1};
    ltau := ((transpose sub(vt, R)) * grad)_(0,0); btau := ((transpose sub(vt, R)) * HessF * sub(vt, R))_(0,0);
    if evalAt(btau, y) != 0 then return "b_tau != 0";
    Jm := lift(sub(jacobian matrix{{F, D#"Qa", ltau, btau}}, apply(9, i -> R_i => y#i)), kk);     -- 9 x 4
    Tg := gens ker transpose Jm;
    if numColumns Tg != 5 then return "fibre not smooth at y";
    C5 := kk[cc_1..cc_5];
    par := flatten entries (sub(Tg, C5) * transpose vars C5);
    if sub(F, apply(9, i -> R_i => par#i)) != 0 then return "tangent space of the fibre is not in Y";
    if rank(Tg | transpose matrix{D#"a"}) != 5 then return "plane does not contain a";
    Tg);
onZ = (D, y) -> instance(planeThrough(D, y), Matrix);
-- smooth point of the complete intersection Y n Q_a n G ?
ciSmooth = (D, y) -> rank lift(sub(jacobian matrix{{F, D#"Qa", D#"G"}}, apply(9, i -> R_i => y#i)), kk) == 3;

-- the same test over an extension field K of kk (for components without points over kk): y a list of 9 elements of K
memberOver = (D, K, y) -> ( RK := K(monoid[Variables => 9]); mp := map(RK, R, vars RK);
    evK := f -> sub(mp f, apply(9, i -> RK_i => y#i));
    gK := mp grad; HK := mp HessF; VK := sub(D#"V", K);
    if evK F != 0 or evK(D#"Qa") != 0 or evK(D#"G") != 0 then return "not on Y n Q_a n G";
    l1 := evK((D#"l")_(0,0)); l2 := evK((D#"l")_(1,0));
    if l1 == 0 and l2 == 0 then return "l_1 = l_2 = 0";
    vt := l2 * VK_{0} - l1 * VK_{1};
    ltau := ((transpose sub(vt, RK)) * gK)_(0,0); btau := ((transpose sub(vt, RK)) * HK * sub(vt, RK))_(0,0);
    if sub(btau, apply(9, i -> RK_i => y#i)) != 0 then return "b_tau != 0";
    Jm := lift(sub(jacobian matrix{{mp F, mp(D#"Qa"), ltau, btau}}, apply(9, i -> RK_i => y#i)), K);
    if rank Jm != 4 then return "fibre not smooth at y";
    ciRank := rank lift(sub(jacobian matrix{{mp F, mp(D#"Qa"), mp(D#"G")}}, apply(9, i -> RK_i => y#i)), K);
    Tg := gens ker transpose Jm;
    Tg = Tg_(toList(0 .. 4));                                            -- 9 x 5 (rank checked below)
    if rank Tg != 5 then return "kernel basis not found";
    C5K := K(monoid[Variables => 5]);
    par := flatten entries (sub(Tg, C5K) * transpose vars C5K);
    if sub(mp F, apply(9, i -> RK_i => par#i)) != 0 then return ("tangent space of the fibre is not in Y", ciRank == 3);
    ("on a 4-plane through a", ciRank == 3));
-- a point over K = GF(p^2) on a curve c in C4 that is a pair of conjugate lines (degree 2, no point over kk)
conjPoint = (c, K) -> ( hp := random(1, ring c); I0 := saturate(c + ideal hp);                -- a closed point of degree 2
    lin := select(flatten entries gens gb I0, f -> first degree f == 1);
    Lk := gens ker matrix(kk, apply(lin, f -> apply(gens ring c, v -> coefficient(v, f))));   -- 4 x 2: the line through the two points
    if numColumns Lk != 2 then error "conjPoint: unexpected";
    T1 := kk[tq]; ph := map(T1, ring c, flatten entries (sub(Lk_{0}, T1) + tq * sub(Lk_{1}, T1)));
    qd := (trim ph I0)_0;
    al := coefficient(tq^2, qd); be := coefficient(tq, qd); ga := coefficient(1_T1, qd);
    al = lift(al, kk); be = lift(be, kk); ga = lift(ga, kk);
    disc := be^2 - 4 * al * ga;
    mpol := (ideal ambient K)_0; av := (ring mpol)_0;                                  -- a^2 + m1 a + m0 = 0
    m1 := lift(coefficient(av, mpol), kk); m0 := lift(coefficient(1_(ring mpol), mpol), kk);
    d0 := m1^2 - 4 * m0;                                                               -- sqrt(d0) = 2a + m1
    rr := (disc / d0)^((pp + 1) // 4);                                                 -- p = 3 mod 4
    if rr^2 != disc / d0 then error "conjPoint: the discriminant is a square (the component has rational points)";
    sq := sub(rr, K) * (2 * K_0 + sub(m1, K));
    if sq^2 != sub(disc, K) then error "conjPoint: square root failed";
    t0 := (-sub(be, K) + sq) / (2 * sub(al, K));
    flatten entries (sub(Lk_{0}, K) + t0 * sub(Lk_{1}, K)));

apt = ratPoint(Is, R); if apt === null then error "no rational point on A"; D = baseData apt;
<< "point a of A found; checks (rank Hess 6, dim T_aA 3, T_aA in ker Hess, a in T_aA): " << D#"ok" << endl << flush;

-- the 4-plane P'
if md == "B" then (
    evp = {{1,0,0,0,0,0,0,0,0},{0,1,1,0,0,0,0,0,0},{0,0,0,1,0,0,1,0,0},{0,0,0,0,1,0,0,0,1},{0,0,0,0,0,1,0,1,0}};
    od = {{0,1,-1,0,0,0,0,0,0},{0,0,0,1,0,0,-1,0,0},{0,0,0,0,1,0,0,0,-1},{0,0,0,0,0,1,0,-1,0}};
    Pv = kk[v_0..v_4]; Rt = Pv[t_0..t_4];
    ptB = apply(9, k -> sum(4, j -> t_j * od#j#k) + t_4 * sum(5, i -> v_i * evp#i#k));
    FB = a0 * hes(take(ptB, 3), lam) + hes(take(ptB, {3,5}), lam) + hes(take(ptB, {6,8}), lam)
         + sum flatten apply(3, i -> apply(3, j -> (take(ptB, 3))#((i+j)%3) * x#((i-j)%3) * (take(ptB, {3,5}))#i * (take(ptB, {6,8}))#j));
    IB = saturate ideal apply(flatten entries last coefficients FB, f -> lift(f, Pv));
    LB = select(flatten entries gens gb IB, f -> first degree f == 1);
    vv = flatten entries gens ker matrix(kk, apply(LB, f -> apply(5, i -> coefficient(Pv_i, f))));
    Pm = transpose matrix(kk, od | {apply(9, k -> sum(5, i -> vv#i * evp#i#k))});            -- 9 x 5
    use R;
) else (
    apt2 = ratPoint(Is, R); if apt2 === null then error "no second rational point on A"; D2 = baseData apt2; Pm = null; cnt = 0;
    T4 = kk[yy_0..yy_4];
    while Pm === null and cnt < 200 do ( cnt = cnt + 1;
        Lm := random(kk^9, kk^5); ph := map(T4, R, flatten entries (sub(Lm, T4) * transpose vars T4));
        t1 := random kk;
        lt := t1 * (D2#"l")_(0,0) + (D2#"l")_(1,0); bt := t1^2 * (D2#"B")_(0,0) + 2 * t1 * (D2#"B")_(0,1) + (D2#"B")_(1,1);
        Iw := saturate ideal(ph F, ph(D2#"Qa"), ph lt, ph bt);
        if dim Iw != 1 then continue;
        for c in select(decompose Iw, c -> degree c == 1) do (
            lin := select(flatten entries gens gb c, f -> first degree f == 1);
            yp := flatten entries gens ker matrix(kk, apply(lin, f -> apply(gens T4, v -> coefficient(v, f))));
            y9 := flatten entries (Lm * transpose matrix{yp});
            pl := planeThrough(D2, y9);
            if instance(pl, Matrix) then (Pm = pl; break)));
    if Pm === null then error "no 4-plane found";
    use R;
    );
C5 = kk[c_0..c_4];
toP = map(C5, R, flatten entries (sub(Pm, C5) * transpose vars C5));
<< "P' (mode " << md << "): rank " << rank Pm << " ; F vanishes on P': " << (toP F == 0) << " ; a on P': " << (rank(Pm | transpose matrix{apt}) == 5)
   << " ; P' n A: " << (J := saturate toP Is; (dim J - 1, degree J, toString hilbertPolynomial(J, Projective => false))) << endl << flush;

-- P1: the scheme {Q_a = G = 0} in P', cut by a random hyperplane of P' (a curve in P^3; the decomposition of the
--     surface itself in P^4 did not finish in 10 minutes).  The degree of P' n Z_a is the degree of this curve's part in Z_a.
Q5 = toP(D#"Qa"); G5 = toP(D#"G");
ICI = ideal(Q5, G5);
<< "P1: {Q_a = G = 0} in P': Q_a restricted has degree " << first degree Q5 << ", G restricted has degree " << first degree G5
   << " ; dim " << dim ICI - 1 << " degree " << degree ICI << endl << flush;
Hm = random(kk^5, kk^4);                                                              -- a random P^3 in P'
C4 = kk[d_0..d_3];
toH = map(C4, C5, flatten entries (sub(Hm, C4) * transpose vars C4));
ICu = ideal(toH Q5, toH G5);
tm = cpuTime(); comps = decompose ICu;
<< "    in a random P^3 of P': curve of dim " << dim ICu - 1 << " degree " << degree ICu << " ; components (dim, degree): "
   << apply(comps, c -> (dim c - 1, degree c)) << " ; sum of degrees of the curve components "
   << sum apply(select(comps, c -> dim c == 2), degree) << " (equal to " << degree ICu << " means all multiplicities are 1) ; cpu " << cpuTime() - tm << endl << flush;
-- P2: membership of each curve component, at 3 rational points each
N = 0; allgood = true;
K2 = GF(pp^2);
scan(select(comps, c -> dim c == 2), c -> (
    res := apply(3, s -> ( yc := ratPoint(c, C4);
        if yc =!= null then ( y9 := flatten entries (Pm * Hm * transpose matrix{yc});
            pl := planeThrough(D, y9);
            (ciSmooth(D, y9), instance(pl, Matrix), if instance(pl, String) then pl else "on a 4-plane through a"))
        else ( ycK := conjPoint(c, K2);                                               -- no point over kk: a point over GF(p^2)
            y9K := flatten entries (sub(Pm * Hm, K2) * transpose matrix{ycK});
            r := memberOver(D, K2, y9K);
            if instance(r, String) then (false, false, r | " [point over GF(p^2)]")
            else (r#1, r#0 == "on a 4-plane through a", r#0 | " [point over GF(p^2)]"))));
    isZ := all(res, r -> r#1); isR := all(res, r -> not r#1);
    if not (isZ or isR) or not all(res, r -> r#0) then allgood = false;
    if isZ then N = N + degree c;
    << "P2: component of degree " << degree c << ", arithmetic genus " << genus c
       << " ; at 3 rational points (CI smooth there, on Z_a, detail): " << res << endl << flush));
<< "P3: N = sum of degrees of the components in Z_a = " << N << " ; tests consistent: " << allgood << endl << flush;

-- P4: the count for ONE explicit plane pi (taken inside the P^3 above), with every point checked
Um = random(kk^4, kk^3);                                                              -- pi = Pm * Hm * Um * s
piM = Pm * Hm * Um;
C3 = kk[s_0..s_2];
toPi3 = map(C3, C4, flatten entries (sub(Um, C3) * transpose vars C3));
toPi = map(C3, R, flatten entries (sub(piM, C3) * transpose vars C3));
Ipi = ideal(toPi(D#"Qa"), toPi(D#"G"));
<< "P4: pi n {Q_a = G = 0}: dim " << dim Ipi - 1 << " degree " << degree Ipi << " ; prime components (degree): " << apply(decompose Ipi, degree) << endl;
curveComps = select(comps, c -> dim c == 2);
zComps = select(curveComps, c -> ( yc := ratPoint(c, C4); yc =!= null and onZ(D, flatten entries (Pm * Hm * transpose matrix{yc}))));
rComps = select(curveComps, c -> not member(c, zComps));
I8 = saturate sum apply(zComps, c -> toPi3 c);                                        -- pi n (the part of the curve in Z_a)
d8 = decompose I8;
<< "    pi n (components in Z_a): dim " << dim I8 - 1 << " degree " << degree I8 << " ; prime components (degree): " << apply(d8, degree)
   << " ; reduced (sum of degrees = degree): " << (sum apply(d8, degree) == degree I8) << endl << flush;
Jpi = toPi jacobian matrix{{F, D#"Qa", D#"G"}};                                       -- 9 x 3 with entries on pi
smoothAll = (dim(I8 + minors(3, Jpi)) <= 0);                                          -- Y n Q_a n G smooth at each of the points
M3 = (transpose Jpi) * sub(piM, C3);                                                  -- 3 x 3; rank 2 at y  <=>  T_y pi n T_y Z_a = {y}
transAll = (dim(I8 + minors(2, M3)) <= 0);
<< "    at all " << degree I8 << " points: Y n Q_a n G smooth: " << smoothAll << " ; pi meets the tangent space of Z_a only in the point: " << transAll << endl << flush;
-- the points of pi on the residual components must not be on Z_a
resOK = true;
scan(rComps, c -> ( Ic := saturate toPi3 c;
    scan(decompose Ic, q -> (
        if degree q == 1 then ( lin := select(flatten entries gens gb q, f -> first degree f == 1);
            sp := flatten entries gens ker matrix(kk, apply(lin, f -> apply(gens C3, v -> coefficient(v, f))));
            y9 := flatten entries (piM * transpose matrix{sp});
            ok := ciSmooth(D, y9) and not onZ(D, y9);
            if not ok then resOK = false;
            << "    residual point of pi (rational): Y n Q_a n G smooth there and not on Z_a: " << ok << endl)
        else if degree q == 2 then (                                                   -- a conjugate pair: one point over GF(p^2)
            lin2 := select(flatten entries gens gb q, f -> first degree f == 1);
            Lk := gens ker matrix(kk, apply(lin2, f -> apply(gens C3, v -> coefficient(v, f))));      -- 3 x 2
            T1 := kk[tq]; ph := map(T1, C3, flatten entries (sub(Lk_{0}, T1) + tq * sub(Lk_{1}, T1)));
            qd := (trim ph q)_0;
            al := lift(coefficient(tq^2, qd), kk); be := lift(coefficient(tq, qd), kk); ga := lift(coefficient(1_T1, qd), kk);
            disc := be^2 - 4 * al * ga;
            mpol := (ideal ambient K2)_0; av := (ring mpol)_0;
            m1 := lift(coefficient(av, mpol), kk); m0 := lift(coefficient(1_(ring mpol), mpol), kk);
            d0 := m1^2 - 4 * m0; rr := (disc / d0)^((pp + 1) // 4);
            sq := sub(rr, K2) * (2 * K2_0 + sub(m1, K2));
            t0 := (-sub(be, K2) + sq) / (2 * sub(al, K2));
            spK := flatten entries (sub(Lk_{0}, K2) + t0 * sub(Lk_{1}, K2));
            y9K := flatten entries (sub(piM, K2) * transpose matrix{spK});
            r := memberOver(D, K2, y9K);
            ok2 := (sq^2 == sub(disc, K2)) and instance(r, Sequence) and r#1 and r#0 != "on a 4-plane through a";
            if not ok2 then resOK = false;
            << "    residual points of pi (a conjugate pair over GF(p^2)): Y n Q_a n G smooth there and not on Z_a: " << ok2 << endl)
        else ( resOK = false; << "    residual point of degree " << degree q << ": not handled" << endl)))));
NPI = degree I8;
<< "    N for this pi = " << NPI << " ; all checks: " << (smoothAll and transAll and resOK and sum apply(d8, degree) == degree I8) << endl << flush;
-- the tenfold X = F + sum_k w_k Phi_k, Phi_k in (ideal of pi) * (linear forms), containing Lambda = {y in pi, w free}
S12 = kk[z_0..z_2, p_0..p_2, q_0..q_2, w_0..w_2];
inc = map(S12, R, (vars S12)_{0..8});
lamPi = flatten entries ((vars R) * sub(gens ker transpose piM, R));                  -- the 6 linear forms cutting pi in P^8
Phi = apply(3, k -> sum apply(lamPi, lf -> (inc lf) * random(1, S12)));
FX = inc F + sum(3, k -> S12_(9+k) * Phi#k);
LamI = ideal apply(lamPi, lf -> inc lf);
<< "    tenfold X: X n {w = 0} = Y: " << (sub(FX, {S12_9 => 0, S12_10 => 0, S12_11 => 0}) == inc F) << " ; Lambda in X: " << (FX % LamI == 0) << flush;
tm = cpuTime(); JX = ideal jacobian matrix{{FX}}; LTX = ideal leadTerm groebnerBasis(JX, Strategy => "F4");
<< " ; X smooth: " << (dim LTX == 0) << " (cpu " << cpuTime() - tm << ")" << endl;
<< "RESULT p = " << pp << " seed " << sd << " mode " << md << ": N = " << N << " ; for the explicit pi: " << NPI << " points, every point checked: "
   << (smoothAll and transAll and resOK and sum apply(d8, degree) == degree I8) << " ; multiplicities one: "
   << (sum apply(select(comps, c -> dim c == 2), degree) == degree ICu) << " ; membership tests consistent: " << allgood
   << " ; X smooth: " << (dim LTX == 0) << endl;
