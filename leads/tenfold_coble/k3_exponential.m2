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

-- K3: the v-derivative series on the rank-one locus.
--   Pcal(B) := << P(p) exp(-B) >>,  P = p0 p1 p2,  with << S (x) T >> = div(S) pi(T) - pi(S) div(T)  (units of g').
-- Pre-registration (written before running):
--   Write Pcal = pi_0 + pi_3 + pi_6 + ...  (pi_{3m} homogeneous of degree 3m in B).
--   EXP hypothesis: on rank-one B' = u (x) x,  Pcal = pi_0 * exp(pi_3/pi_0), i.e. pi_6 = pi_3^2/(2 pi_0), pi_9 = pi_3^3/(6 pi_0^2), ...
--   If EXP holds: the one equation cutting W in the shape family reads "C~ + c_{x,j}(z) contains a plane" (explicit family).
--   If EXP fails: no such simple description; record the values.
--   Also checked: << (P(p) + P(q)) exp(-B) >> = 0 on rank one (the j-derivative of the rank-one identity; must hold if K1 is an identity).
nuIns = (B, m, Sp, Tq) -> (   -- << Sp(p) Tq(q) B^(3m) >> * (-1)^m/(3m)!   (insertion Sp*Tq of degree = 0 mod 3 in p and in q)
    S := Sp * Tq * B^(3*m);
    (rp, D) := redv(S, Jp, ps);  Pi := coefOf(rp, Hp);
    (rD, dD) := redv(D, Jq, qs);  piD := coefOf(rD, Hq);
    (rP, dP) := redv(Pi, Jq, qs);
    sgn := if m % 2 == 0 then 1 else -1;
    fact := 1_kk; scan(1..3*m, i -> fact = fact * i);
    sgn * lift(piD - dP, kk) / fact);
mkB = Bm -> sum flatten apply(3, i -> apply(3, j -> Bm_(i,j) * ps#i * qs#j));
unprime = Bp -> matrix(kk, apply(3, i -> apply(3, j -> Bp_((i+j)%3, (i-j)%3))));
rk1 = (u, x) -> unprime(transpose matrix{u} * matrix{x});
Pp = p_0*p_1*p_2; Pq = q_0*q_1*q_2;
scan(2, t -> (
    u := apply(3, i -> random kk); x := apply(3, i -> random kk); B := mkB rk1(u, x);
    piP := apply(toList(0..mmax), m -> nuIns(B, m, Pp, 1_R));
    piQ := apply(toList(0..mmax), m -> nuIns(B, m, 1_R, Pq));
    << "pi_{3m} (P(p) inserted), m=0.. : " << piP << endl;
    << "    (P(q) inserted)           : " << piQ << "   sum zero: " << all(#piP, i -> piP#i + piQ#i == 0) << endl;
    p0 := piP#0; p3 := piP#1;
    pred := apply(toList(0..mmax), m -> (f := 1_kk; scan(1..m, i -> f = f*i); p0 * (p3/p0)^m / f));
    << "    EXP prediction             : " << pred << endl;
    << "    EXP holds at each order    : " << apply(#pred, i -> pred#i == piP#i) << endl << flush;
    ));
-- control: generic B (EXP should fail there if it is special to rank one)
Bm = random(kk^3, kk^3); B = mkB Bm;
piP = apply(toList(0..min(mmax,3)), m -> nuIns(B, m, Pp, 1_R));
<< "control generic B: pi = " << piP << " ; pi_6 - pi_3^2/(2 pi_0) = " << piP#2 - piP#1^2/(2*piP#0) << endl;
