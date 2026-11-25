-- K1: the relative period series V(B) = sum_m nu_{3m}(B) of the class [Gamma_phi] on E x E for the potential
--     g_B(p,q) = h(p) + h(q) + B(p,q),  h = Hesse cubic,  B a bilinear form (3x3 matrix b_ij), evaluated MOD p.
-- gamma_12 = g' (div (x) pi - pi (x) div), with reduction rule  gamma(A d_i h) = gamma(d_i A)  (integration by parts).
-- Pre-registration (written before running):
--   (a) nu_3(B) is a constant multiple of det(B'), B'_{(i+j),(i-j)} = b_ij  [derived by hand; pipeline check].
--   (b) for B' = u (x) x of rank one with x ON the curve h_lam(x) = 0: nu_{3m} = 0 for all m (F_T lies in the Hodge locus; check).
--   (c) for B' = u (x) x of rank one with x generic: if nu_6 != 0 the relative period does not vanish identically on the
--       Segre cone (then any vanishing has to come from the cubic-fourfold factor); if nu_{3m} = 0 for all m tested, that is
--       evidence for the identity V = 0 on the Segre cone (would make the tenfold potential vanish on a whole family).
pp = value(scriptCommandLine#1); sd = value(scriptCommandLine#2); mmax = value(scriptCommandLine#3);
setRandomSeed sd; kk = ZZ/pp;
lam = random kk;
R = kk[p_0..p_2, q_0..q_2];
ps = {p_0,p_1,p_2}; qs = {q_0,q_1,q_2};
hp = p_0^3+p_1^3+p_2^3 + 3*lam*p_0*p_1*p_2; hq = sub(hp, {p_0=>q_0,p_1=>q_1,p_2=>q_2});
Jp = matrix{apply(ps, v -> diff(v, hp))}; Jq = matrix{apply(qs, v -> diff(v, hq))};
Gp = gb ideal Jp; Gq = gb ideal Jq;
-- one reduction rstep in the variables vs with Jacobian row J: S -> sum d_i A_i where S = sum A_i d_i h (+ remainder)
rstep = (S, J, vs) -> (
    (Q, r) := quotientRemainder(matrix{{S}}, J);
    (sum(3, i -> diff(vs#i, Q_(i,0))), r_(0,0)));
-- full reduction in p of a form of p-degree 3m: returns (Pi, D): S ~ Pi * Hstd(p) + D, with Pi, D free of p
degIn = (S, vs) -> if S == 0 then -1 else max apply(exponents S, e -> sum(apply(vs, v -> e#(index v))));
redv = (S, J, vs) -> (
    d := degIn(S, vs);
    while d > 3 do ( (S1, r) := rstep(S, J, vs); if r != 0 then error "nonzero remainder above degree 3"; S = S1; d = d - 3; );
    if d < 3 then return (0_R, S);
    (S2, r2) := rstep(S, J, vs);
    (r2, S2));
-- standard cubic monomials (remainders are multiples of these)
(dump1, Hp) = rstep(p_0*p_1*p_2, Jp, ps); (dump2, Hq) = rstep(q_0*q_1*q_2, Jq, qs);
<< "standard cubics: " << Hp << " , " << Hq << endl;
coefOf = (r, H) -> (if r == 0 then 0_R else (c := r // H; if c*H != r then error "remainder not a multiple of the standard cubic"; c));
nu = (B, m) -> (
    S := B^(3*m);
    (rp, D) := redv(S, Jp, ps);  Pi := coefOf(rp, Hp);          -- S ~ Pi(q) Hp + D(q)
    -- gamma_12 = g'(div_p pi_q - pi_p div_q):  D -> pi_q(D),  Pi -> div_q(Pi)
    (rD, dD) := redv(D, Jq, qs);  piD := coefOf(rD, Hq);
    (rP, dP) := redv(Pi, Jq, qs);
    sgn := if m % 2 == 0 then 1 else -1;
    fact := 1_kk; scan(1..3*m, i -> fact = fact * i);
    sgn * lift(piD - dP, kk) / fact);
mkB = Bm -> sum flatten apply(3, i -> apply(3, j -> Bm_(i,j) * ps#i * qs#j));
prime = Bm -> matrix(kk, apply(3, a -> apply(3, b -> ( -- B'_{a,b} = b_ij with i+j = a, i-j = b  => i = 2(a+b), j = 2(a-b) mod 3
        i := (2*(a+b)) % 3; j := (2*(a-b)) % 3; Bm_(i,j)))));
unprime = Bp -> matrix(kk, apply(3, i -> apply(3, j -> Bp_((i+j)%3, (i-j)%3))));
-- (a) generic B: ratio nu_3 / det B'
scan(3, t -> (Bm := random(kk^3, kk^3); << "(a) generic B: nu_3 / det(B') = " << nu(mkB Bm, 1) / det prime Bm << endl));
-- (c) rank one, x generic
rk1 = (u, x) -> unprime(transpose matrix{u} * matrix{x});
scan(2, t -> (u := apply(3, i -> random kk); x := apply(3, i -> random kk); B := mkB rk1(u, x);
    << "(c) rank-one, x generic: " << apply(toList(1..mmax), m -> (tt := cpuTime(); v := nu(B, m); (3*m, v, cpuTime() - tt))) << endl << flush));
-- (b) rank one, x on the curve: choose x_0, x_1 random and lam' so that the curve through x is the lam-curve: instead pick x then reset?  use x with h_lam(x)=0 by solving for lam: not possible with lam fixed;
--     so build x on the curve from a line through a known point: brute-force search for a root of the cubic in x_2
findOnCurve = () -> (x := null; while x === null do (a := random kk; b := random kk;
        S1 := kk[t]; f := a^3 + b^3 + t^3 + 3*lam*a*b*t; rts := roots1 f; if #rts > 0 then x = {a, b, rts#0}); x);
roots1 = f -> (S1 := ring f; fs := factor f; select(apply(toList fs, fe -> (g := fe#0; if first degree g == 1 then - (coefficient(1_S1, g)) / (coefficient(S1_0, g)) else null)), r -> r =!= null));
scan(2, t -> (u := apply(3, i -> random kk); x := findOnCurve(); B := mkB rk1(u, x);
    << "(b) rank-one, x on the curve (h_lam(x) = " << x#0^3+x#1^3+x#2^3+3*lam*x#0*x#1*x#2 << "): " << apply(toList(1..min(mmax,4)), m -> (3*m, nu(B, m))) << endl << flush));
-- generic B at higher order for comparison (nonvanishing control)
Bm = random(kk^3, kk^3); << "control generic B: " << apply(toList(1..min(mmax,3)), m -> (3*m, nu(mkB Bm, m))) << endl;
