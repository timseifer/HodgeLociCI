-- Section 14/15 of PREREG_pairing.md: from the pencil found by pr14_arc_split.m2 to explicit matrices.
-- AI-written, unreviewed.  usage (from this folder):  M2 --script pr15_certificate.m2 p seed pencilfile certfile [ext]    exact over F_p or F_(p^2).
-- The Coble cubic, the hyperplane and the change of coordinates are those of "M2 --script pr13_arc_algebra.m2 p seed order case":
-- the same random numbers are drawn here in the same order (checked below: the cubic of the pencil file must be the Coble section).
load "detrep_lib.m2";
pp = value(scriptCommandLine#1); sd = value(scriptCommandLine#2); kk = ZZ/pp; setRandomSeed sd;
hs = (v, l) -> v#0^3+v#1^3+v#2^3 + 3*l*v#0*v#1*v#2;
R9 = kk[z_0..z_2, p_0..p_2, q_0..q_2];
lam = random kk; xx = apply(3, i -> random kk); a0 = - hs(xx, lam) / (27 * (1 + lam^3));
zz = {z_0,z_1,z_2}; ps = {p_0,p_1,p_2}; qs = {q_0,q_1,q_2};
FC = a0 * hs(zz, lam) + hs(ps, lam) + hs(qs, lam) + sum flatten apply(3, i -> apply(3, j -> zz#((i+j)%3) * xx#((i-j)%3) * ps#i * qs#j));
U = kk[u_0..u_7, t]; U0 = kk[u_0..u_7]; inc = map(U, U0, (vars U)_{0..7});
parL = apply(9, i -> random(1, U0)); par = map(U0, R9, parL); G = par FC; Psi = inc random(2, U0);
f0 = inc G + t * Psi + t^2 * random(1, U);
Mg = random(kk^9, kk^9);
dat = value get scriptCommandLine#3; n = 8;
-- the special members of the pencil D_s + mu G: where the 64 x 64 compression of the vector-field matrix drops rank by 8
Rk = kk[y_0..y_7]; B3k = basis(3, Rk);
Grk = (B3k * sub(transpose matrix(kk, {dat#"Gr"}), Rk))_(0,0); Dsk = (B3k * sub(transpose matrix(kk, {dat#"Ds"}), Rk))_(0,0);
symk = D -> lift(last coefficients(matrix{flatten apply(n, i -> apply(n, j -> Rk_i * diff(Rk_j, D)))}, Monomials => B3k), kk);
SG = symk Grk; SD = symk Dsk; Qc = random(kk^(n^2), kk^(numRows SG));
pts = toList(1..n^2+1); vals = apply(pts, m -> det(Qc * (SD + m * SG)));
Pm = kk[mu];
dpol = sum(#pts, i -> ( oth := select(pts, q -> q != pts#i); (vals#i / product(oth, q -> (pts#i - q)_kk)) * product(oth, q -> mu - q) ));
fac = toList factor dpol;
<< "the polynomial det(Q (S_D + mu S_G)) of degree " << first degree dpol << ": factors (degree, multiplicity) " << toString apply(fac, f -> (first degree f#0, f#1)) << endl << flush;
big = select(fac, f -> f#1 >= 6 and first degree f#0 >= 1);
if #big == 2 and all(big, f -> first degree f#0 == 1) then (
    KK = kk; mus = apply(big, f -> lift(- sub(f#0, mu => 0_Pm) / leadCoefficient(f#0), kk)); minp = "";
    << "two members over the prime field: mu = " << toString mus << " ; their sum: " << sum mus << endl ) else if #big == 1 and first degree big#0#0 == 2 then (
    KK = GF(pp^2, Variable => aa); minp = toString (ideal ambient KK)_0;
    Pk := KK[nu]; qq := sub(big#0#0, {mu => nu}); rr := toList factor qq;
    mus = apply(rr, f -> lift(- sub(f#0, nu => 0_Pk) / leadCoefficient(f#0), KK));
    << "the two members are conjugate over F_(p^2): the factor is " << toString big#0#0 << " ; field F_p[aa]/(" << minp << ")" << endl ) else error "no pair of special members";
<< flush;
-- optional fifth argument "ext": work over F_(p^2) although the two members are defined over F_p (needed when their Lie algebras are
-- not split over F_p, so that no matrix over F_p exists; added after the first run at 31991)
if #scriptCommandLine > 5 and minp == "" then ( KK = GF(pp^2, Variable => aa); minp = toString (ideal ambient KK)_0; mus = apply(mus, m -> (lift(m, ZZ))_KK) );
Rh = KK[y_0..y_7]; B3h = basis(3, Rh); U0K = KK[u_0..u_7];
k0 = dat#"k0"; el = apply(dat#"ell", c -> c_KK);                                 -- ell = el#0 + sum el#(i+1) x_i
others = select(toList(0..n-1), i -> i != k0);
Xc = new MutableList from apply(n+1, j -> 0_Rh);
scan(#others, a -> Xc#(others#a) = Rh_a); Xc#n = Rh_(n-1);
Xc#k0 = - (el#0 * Rh_(n-1) + sum(others, i -> el#(i+1) * Xc#i)) * (1 / el#(k0+1));
Xr = matrix{toList Xc};                                                          -- the chart coordinates as linear forms in y
MgK = matrix(KK, apply(entries lift(Mg, ZZ), r -> r));
orig = Xr * sub(MgK, Rh);                                                        -- (u_0, ..., u_7, t) as linear forms in y
GK = sub(G, U0K);
phi = map(Rh, U0K, orig_{0..7});
Gr = (B3h * sub(transpose matrix(KK, {dat#"Gr"}), Rh))_(0,0); Ds = (B3h * sub(transpose matrix(KK, {dat#"Ds"}), Rh))_(0,0);
<< "the hyperplane of the pencil file is t = 0: " << (orig_(0,8) == 0) << " ; its cubic is the Coble section: " << (rank lift(last coefficients(matrix{{Gr, phi GK}}, Monomials => B3h), KK) == 1) << endl << flush;
DA = Ds + mus#0 * Gr; DB = Ds + mus#1 * Gr;
MA = detRep DA; MB = detRep DB;
<< "determinantal representations: " << (if instance(MA, String) then MA else "found") << " / " << (if instance(MB, String) then MB else "found") << endl << flush;
if instance(MA, String) or instance(MB, String) then exit 0;
r = solvePair(MA, MB);
if instance(r, String) then ( << "pair: " << r << endl; exit 0 );
Lphi = lift(last coefficients(orig_{0..7}, Monomials => vars Rh), KK);            -- u = y * Lphi
psi = map(U0K, Rh, (vars U0K) * sub(inverse Lphi, U0K));
Au = psi r#0; Bu = psi r#1;
Tt = KK[u_0..u_7, tau]; toT = map(Tt, U0K, (vars Tt)_{0..7});
lhs = det(tau * id_(Tt^3) + toT Au) - det(tau * id_(Tt^3) + toT Bu);
cst = lhs // toT GK;
<< "RESULT (exact): det(tau + A) - det(tau + B) = c G with G the Coble section, c = " << toString cst << " : " << (lhs == cst * toT GK and cst != 0 and first degree cst == 0)
   << " ; tr A = tr B: " << (trace Au == trace Bu) << " ; s_2(A) = s_2(B): " << (s2of Au == s2of Bu) << endl;
ent = M -> lift(last coefficients(matrix{flatten entries M}, Monomials => vars Tt), KK);
<< "      the nine entries of tau + A are independent linear forms: " << (rank ent(tau * id_(Tt^3) + toT Au) == 9) << " ; of tau + B: " << (rank ent(tau * id_(Tt^3) + toT Bu) == 9) << endl;
-- the first-order freedom: (A_1, B_1) -> tr(B B_1) - tr(A A_1) with tr A_1 = tr B_1, entries linear forms in (u, tau): onto the quadrics?
E = (i, j) -> matrix(Tt, apply(3, a -> apply(3, b -> if (a, b) == (i, j) then 1 else 0)));
ij = flatten apply(3, i -> apply(3, j -> (i, j))); vs = flatten entries vars Tt;
gensA = flatten apply(ij, x -> apply(vs, v -> (v * E x, 0 * E x))) | flatten apply(ij, x -> apply(vs, v -> (0 * E x, v * E x)));
trm = lift(last coefficients(matrix{apply(gensA, g -> trace(g#0) - trace(g#1))}, Monomials => vars Tt), KK);
Kt = gens ker trm;
im2 = lift(last coefficients(matrix{apply(gensA, g -> trace(toT Bu * g#1) - trace(toT Au * g#0))}, Monomials => basis(2, Tt)), KK);
t2 = lift(last coefficients(matrix{{tau^2}}, Monomials => basis(2, Tt)), KK);
<< "      rank of (A_1, B_1) -> tr(B B_1) - tr(A A_1) on {tr A_1 = tr B_1}: " << rank(im2 * Kt) << " of " << numColumns basis(2, Tt) << " quadrics in (u, tau) ; together with tau^2: " << rank((im2 * Kt) | t2) << endl;
cert = new HashTable from {"p" => pp, "minpoly" => minp, "lam" => lift(lam, ZZ), "x" => apply(xx, c -> lift(c, ZZ)), "hyperplane" => apply(parL, toString), "A" => apply(entries Au, r -> apply(r, toString)), "B" => apply(entries Bu, r -> apply(r, toString)), "c" => toString cst};
(scriptCommandLine#4) << toExternalString cert << endl << close;
<< "certificate written to " << scriptCommandLine#4 << endl;
