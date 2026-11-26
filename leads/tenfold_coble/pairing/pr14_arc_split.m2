-- Section 14 of PREREG_pairing.md: the algebra along the arc to higher order; N^2, N(grad F), the cubic G_N, and the
-- pencil spanned by the Coble section and the third coefficient of G_N.   AI-written, unreviewed.
-- usage (from this folder):  M2 --script pr14_arc_split.m2 file          (file written by pr13_arc_algebra.m2)   MOD p.
dat = value get scriptCommandLine#1; pp = dat#"p"; kk = ZZ/pp; setRandomSeed 7;
n = dat#"n"; Mord = dat#"Mord"; m1 = dat#"m1"; nq = dat#"nq"; tm = cpuTime();
Ra = kk(monoid[Variables => n]);
mons3 = flatten apply(4, d -> flatten entries basis(d, Ra)); mons2 = flatten apply(3, d -> flatten entries basis(d, Ra));
Lq = apply(dat#"Lq", M -> matrix(kk, M));
cub = apply(dat#"cubic", v -> (matrix{mons3} * sub(transpose matrix(kk, {v}), Ra))_(0,0));
toep = (Ms, J) -> ( r := numRows Ms#0; c := numColumns Ms#0;
    fold((u, v) -> u || v, apply(J, i -> fold((u, v) -> u | v, apply(J, j -> if i >= j then Ms#(i-j) else map(kk^r, kk^c, 0))))) );
rhos = (Ms, Jmax) -> ( rs := {0} | apply(toList(1..Jmax), J -> rank toep(Ms, J)); apply(Jmax, J -> rs#(J+1) - rs#J) );
lastJump = L -> ( d := 0; scan(#L, j -> if (j == 0 and L#0 > 0) or (j > 0 and L#j > L#(j-1)) then d = j); d );
satKer = (Ms, J, m, s) -> ( c := numColumns Ms#0; V := matrix nullSpace mutableMatrix toep(Ms, J);        -- (gens ker was far too slow here)
    Vm := V^(toList(0..c*m-1));
    sel := Vm * random(kk^(numColumns V), kk^s);
    (rank Vm, rank(sel^(toList(0..c-1))), apply(m, j -> sel^(toList(c*j..c*j+c-1)))) );
lin = {1_Ra} | flatten entries vars Ra; nl = #lin;
Mus = apply(m1, j -> ( qj := flatten entries (matrix{mons2} * sub(Lq#j, Ra));
    lift(last coefficients(matrix{flatten apply(qj, q -> apply(lin, l -> q * l))}, Monomials => matrix{mons3}), kk) ));
rM = rhos(Mus, m1); DM = lastJump rM; m2 = m1 - DM; ns = nq * nl - last rM;
ss = satKer(Mus, m1, m2, ns); Sz = ss#2;
<< "order of the arc " << Mord << " ; quadrics modulo e^" << m1 << " ; L S_1: rho_J = " << toString rM << " ; syzygies " << ns << " modulo e^" << m2 << ", free: " << (ss#0 == ns * m2 and ss#1 == ns) << endl << flush;
Pr = random(kk^400, kk^(#mons3 * ns));
Lams = apply(m2, j -> matrix{flatten apply(nq, a -> apply(nq, b -> (
    P := sum(j+1, i -> (Mus#i)_(toList(nl*a..nl*a+nl-1)) * ((Sz#(j-i))^(toList(nl*b..nl*b+nl-1))));
    Pr * (transpose matrix{flatten entries P}) )))});
rL = rhos(Lams, m2); DL = lastJump rL; m3 = m2 - DL; na = nq^2 - last rL;
<< "the algebra: rho_J(Lambda) = " << toString rL << " ; dimension over K at most " << na << " ; known modulo e^" << m3 << " ; cpu " << cpuTime() - tm << endl << flush;
if na != 2 then error "the algebra is not of dimension 2 at this order";
sa = satKer(Lams, m2, m3, na);
if not (sa#0 == na * m3 and sa#1 == na) then error "the algebra is not free of rank 2 modulo this power of e";
cc = random(kk^na, kk^1);
ph = apply(m3, j -> ( va := (sa#2)#j * cc; matrix(kk, apply(nq, a -> apply(nq, b -> va_(nq*a+b, 0)))) ));
Ns = apply(ph, f -> f - (trace f / nq) * id_(kk^nq));
ser = (As, Bs, j) -> sum(j+1, i -> As#i * Bs#(j-i));                     -- coefficient of e^j of a product of two series
N2 = apply(m3, j -> ser(Ns, Ns, j));
dl = apply(N2, S -> trace S / nq);
<< "(i) N modulo e^" << m3 << ": rank of N_0 = " << rank Ns#0 << " ; N^2 is a scalar at each order: " << toString apply(m3, j -> N2#j == dl#j * id_(kk^nq))
   << " ; delta = N^2: coefficients zero? " << toString apply(dl, d -> d == 0) << endl << flush;
-- the gradient of the cubic in the basis of the quadrics
hpart = f -> apply(n, i -> diff(Ra_i, f)) | {3 * f - sum(n, i -> Ra_i * diff(Ra_i, f))};          -- the n+1 homogeneous partial derivatives, in the chart
c2 = L -> lift(last coefficients(matrix{L}, Monomials => matrix{mons2}), kk);
dF = apply(m1, j -> c2 hpart cub#j);
Cs = new MutableList from apply(m1, j -> 0);
scan(m1, j -> ( rhs := dF#j - sum(toList(1..j), i -> Lq#i * Cs#(j-i)); sol := rhs // Lq#0;
    if Lq#0 * sol != rhs then error("the gradient is not in the span of the quadrics at order " | toString j);
    Cs#j = sol ));
Cl = toList Cs;
psi = (Nl, j) -> sum flatten apply(j+1, a -> apply(j+1-a, b -> Lq#a * Nl#b * Cl#(j-a-b)));        -- 45 x 9: N(grad F) at order j
hd = (q, k) -> if k < n then diff(Ra_k, q) else 2 * q - sum(n, l -> Ra_l * diff(Ra_l, q));        -- homogeneous derivative of a quadric
closed = P -> ( qs := flatten entries (matrix{mons2} * sub(P, Ra)); all(n+1, i -> all(n+1, k -> hd(qs#i, k) == hd(qs#k, i))) );
cubOf = P -> ( qs := flatten entries (matrix{mons2} * sub(P, Ra)); (1/3_kk) * (sum(n, i -> Ra_i * qs#i) + qs#n) );
Ps = apply(m3, j -> psi(Ns, j));
<< "(ii) N(grad F) is a gradient at each order: " << toString apply(Ps, closed)
   << " ; teeth (a random endomorphism instead of N_0): " << closed(Lq#0 * random(kk^nq, kk^nq) * Cl#0)
   << " ; sanity (the identity instead of N): " << closed(Lq#0 * Cl#0) << endl << flush;
GN = apply(Ps, cubOf);
-- (iii) the quadric q_* and the linear form
im0 = mingens image Ns#0;
if numColumns im0 == 1 then (
    qst = (matrix{mons2} * sub(Lq#0 * im0, Ra))_(0,0);
    fq = toList factor qst; sq = select(fq, t -> first degree t#0 == 1 and t#1 == 2);
    << "(iii) q_* (the image of N_0): factors (degree, multiplicity) " << toString apply(fq, t -> (first degree t#0, t#1)) << endl << flush;
    if #sq == 1 then ( ell = sq#0#0;
        << "      l_* S_1 lies in the limit net L_0: " << (rank(Lq#0 | c2 apply(lin, l -> ell * l)) == rank Lq#0)
           << " ; l_* vanishes on the nodes (l_* S_2 in the span of L_0 S_1): " << (rank(Mus#0 | lift(last coefficients(matrix{apply(mons2, m -> ell * m)}, Monomials => matrix{mons3}), kk)) == rank Mus#0) << endl;
        dv = (g, k) -> g % ideal(ell^k) == 0;
        << "      G_(N,j) divisible by l_*^3, l_*^2, l_*: " << toString apply(min(m3, 5), j -> (dv(GN#j, 3), dv(GN#j, 2), dv(GN#j, 1))) << endl << flush;
        -- (iv) restrict to the hyperplane l_* = 0 and scan the pencil
        k0 := position(toList(0..n-1), i -> coefficient(Ra_i, ell) != 0);
        Rh = kk[y_0..y_(n-1)];
        others := select(toList(0..n-1), i -> i != k0);
        c0 := coefficient(Ra_k0, ell);
        frk := frac Rh;
        aff := i -> sub(Rh_(position(others, a -> a == i)), frk) / sub(Rh_(n-1), frk);            -- the other affine coordinates on the hyperplane
        sb := map(frk, Ra, apply(n, i -> if i != k0 then aff i else 0_frk));
        xk := - sb(ell - c0 * Ra_k0) / c0;
        sb2 := map(frk, Ra, apply(n, i -> if i != k0 then aff i else xk));
        hom := f -> lift(sb2(f) * (sub(Rh_(n-1), frk))^3, Rh);
        Gr = hom cub#0;
        << "      the cubic restricted to l_* = 0 (the Coble section): singular locus of dimension " << dim saturate ideal jacobian matrix{{Gr}} - 1 << " and degree " << degree saturate ideal jacobian matrix{{Gr}} << endl << flush;
        if m3 >= 4 then ( Ds = hom GN#3;
            B3h := basis(3, Rh);
            sym := D -> lift(last coefficients(matrix{flatten apply(n, i -> apply(n, j -> Rh_i * diff(Rh_j, D)))}, Monomials => B3h), kk);
            SG := sym Gr; SD := sym Ds;
            << "(iv) D_s = G_(N,3) on l_* = 0: zero? " << (Ds == 0) << " ; proportional to the Coble section? " << (rank(lift(last coefficients(matrix{{Gr, Ds}}, Monomials => B3h), kk)) < 2)
               << " ; rank of the vector-field matrix: Coble section " << rank SG << ", D_s " << rank SD << ", random member " << rank(SD + random(kk) * SG) << endl << flush;
            sp := select(toList(0..pp-1), mu -> rank(SD + mu * SG) <= n^2 - 4);
            << "      members D_s + mu G with a Lie algebra of dimension >= 4: mu = " << toString sp << " ; sum of these mu modulo p: " << (if #sp > 0 then toString(sum(sp, mu -> mu_kk)) else "-") << endl << flush;
            scan(sp, mu -> ( D := Ds + mu * Gr; J := saturate ideal jacobian matrix{{D}};
                << "      mu = " << mu << ": Lie algebra of dimension " << n^2 - rank(SD + mu * SG) << " ; singular locus of dimension " << dim J - 1 << ", degree " << degree J
                   << ", Hilbert polynomial " << toString hilbertPolynomial(J, Projective => false) << " ; quadrics in its ideal: " << numColumns super basis(2, J) << endl << flush ));
            if #sp == 0 then << "      (no member found over the prime field: the two may be conjugate over the quadratic extension)" << endl;
            -- for pr15_certificate.m2: the linear form, the eliminated coordinate, the two cubics on the hyperplane, the special mu
            pf := (scriptCommandLine#1) | ".pencil";
            cz := g -> flatten entries lift(last coefficients(matrix{{g}}, Monomials => B3h), ZZ);
            pf << toExternalString(new HashTable from {"p" => pp, "n" => n, "k0" => k0,
                "ell" => apply(lin, m -> lift(coefficient(m, ell), ZZ)), "Gr" => cz Gr, "Ds" => cz Ds, "mu" => sp}) << endl << close;
            << "      pencil written to " << pf << endl ) )
    else << "      q_* is not the square of a linear form" << endl ) else (
    -- N_0 of higher rank (as in the control C2): the leading cubic G_(N,0) in 9 homogeneous variables and its Lie algebra
    R9h = kk[w_0..w_n];
    h9 = f -> homogenize(sub(f, apply(n, i -> Ra_i => R9h_i)), R9h_n);
    G0 = h9 GN#0; B39 = basis(3, R9h);
    S0 = lift(last coefficients(matrix{flatten apply(n+1, i -> apply(n+1, j -> R9h_i * diff(R9h_j, G0)))}, Monomials => B39), kk);
    J0 = saturate ideal jacobian matrix{{G0}};
    << "(iii') rank of N_0 = " << numColumns im0 << " ; the leading cubic G_(N,0): Lie algebra of dimension " << (n+1)^2 - rank S0 << " (16 for a determinant) ; singular locus of dimension " << dim J0 - 1 << " and degree " << degree J0 << endl );
<< "DONE " << scriptCommandLine#1 << " cpu " << cpuTime() - tm << endl;
