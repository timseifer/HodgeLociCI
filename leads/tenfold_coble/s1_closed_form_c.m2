-- S1: (1) the cubic c_{x,lam}(u) := pi_3(u (x) x) in closed form (symbolic x, u, lam over QQ);
--     (2) the cubic sevenfold  X8#(x,lam) = { h(p) + h(q) + M_x(z,p,q) - c_{x,lam}(z) = 0 } in P^8: its singular locus, MOD p.
-- Pre-registration (written before running):
--   If X8# carries a 5-dimensional cycle that is not a multiple of h^2 (needed for a tenfold Hodge class supported in the P^8),
--   its singular locus must have dimension >= 2 (Lefschetz for singular hypersurfaces; LIT, machine-recalled).
--   Outcome A: dim Sing X8# >= 2 for generic x, and < 2 for the controls (c replaced by 0 or by 2c): strong support for an explicit
--              3-moduli family through F_T. Outcome B: dim Sing X8# < 2: the exponential identity does NOT come from a cycle inside
--              the P^8 section; the candidate family is not explained this way.
-- part 1: symbolic
A = QQ[lam, u_0..u_2, x_0..x_2];
R = A[p_0..p_2, q_0..q_2];
ps = {p_0,p_1,p_2}; qs = {q_0,q_1,q_2};
hp = p_0^3+p_1^3+p_2^3 + 3*lam*p_0*p_1*p_2; hq = sub(hp, {p_0=>q_0,p_1=>q_1,p_2=>q_2});
B = sum flatten apply(3, i -> apply(3, j -> u_((i+j)%3) * x_((i-j)%3) * ps#i * qs#j));
-- reduction rules for the Hesse cubic, done by hand on monomials (exact):  gamma(A d_i h) = gamma(d_i A).
-- We only need: for a p-sextic S, (pi, div);  and for q-cubics T, (pi, div).   pi = coefficient of P modulo J, div as defined.
-- cubics: basis of J_3: x_i d_i h = 3 x_i^3 + 3 lam P  (div 1),  x_k d_i h (k != i): div 0.  So x_i^3 = (1/3) x_i d_i h - lam P:
--   pi(x_i^3) = -lam, div(x_i^3) = 1/3 ; pi(P) = 1, div(P) = 0 ; x_i^2 x_k (k != i): x_k d_i h = 3 x_i^2 x_k + 3 lam x_k x_{i+1} x_{i+2};
--   one of x_{i+1}, x_{i+2} equals x_k, so that monomial is x_k^2 x_m: the six monomials x_a^2 x_b (a != b) satisfy
--   x_i^2 x_k + lam x_k^2 x_m = (1/3) x_k d_i h  (m = third index): a 6x6 linear system with solutions pi = div = 0 for all (if 1 + lam^3 != 0).
picub = T -> ( -- T cubic in 3 variables v (list): returns (pi, div)
    (T, 0));
redCubic = (T, vs) -> (
    P := vs#0*vs#1*vs#2;
    cP := coefficient(P, T);
    cc := apply(3, i -> coefficient(vs#i^3, T));
    (cP - lam * sum cc, (1/3) * sum cc));
-- sextics: reduce via Macaulay2 division in the fraction field would be heavy; use the explicit one-step rule on monomials instead:
--   for a monomial m of degree >= 4 pick i with exponent e_i >= 2:  m = (m/x_i^2) * x_i^2 = (m/x_i^2) * ( (1/3) d_i h - lam x_{i+1} x_{i+2} ),
--   gamma(m) = (1/3) gamma( d_i (m/x_i^2) ) - lam gamma( (m/x_i^2) x_{i+1} x_{i+2} ).   The second term has a smaller power of x_i; iterate.
--   Termination: for degree >= 4 some exponent is >= 2 unless the monomial is squarefree (degree <= 3).  The lam-term can cycle, so
--   instead solve by linear algebra on H_3-invariant monomials of degree 6: use M2 over the fraction field of QQ[lam].
K = frac(QQ[l]);
RK = K[a_0..a_2];
h3 = a_0^3+a_1^3+a_2^3 + 3*l*a_0*a_1*a_2;
JK = matrix{apply(gens RK, v -> diff(v, h3))};
red6 = S -> ( -- S sextic in RK: returns the cubic sum d_i A_i with S = sum A_i d_i h
    (Q, r) := quotientRemainder(matrix{{S}}, JK); if r != 0 then error "sextic not in J";
    sum(3, i -> diff(RK_i, Q_(i,0))));
redCubK = T -> ( P := a_0*a_1*a_2; cP := coefficient(P, T); cc := apply(3, i -> coefficient(RK_i^3, T)); (cP - l * sum cc, (1/3) * sum cc));
-- table: for each p-monomial m of degree 3: (pi, div) of P*m (a sextic) and of m itself
m3 = flatten entries basis(3, RK);
tab6 = hashTable apply(m3, m -> (exponents m)#0 => redCubK red6(a_0*a_1*a_2*m));
tab3 = hashTable apply(m3, m -> (exponents m)#0 => redCubK m);
-- pi_3(B) = (-1/6) << P(p) B^3 >> ,  << S (x) T >> = div(S) pi(T) - pi(S) div(T)
B3 = B^3;
(mons, cfs) = coefficients B3;     -- monomials in p,q ; coefficients in A
toA = f -> (map(A, K, {lam})) f;   -- K -> frac? coefficients are rational functions in l; clear denominators later
AK = frac A; lamK = sub(A_0, AK);
val = 0_AK;
scan(numColumns mons, c -> (
    e := (exponents mons_(0,c))#0; ep := take(e, 3); eq := drop(e, 3);
    (piS, divS) := tab6#ep; (piT, divT) := tab3#eq;
    f := divS * piT - piS * divT;                   -- in K
    Pl := ring numerator f; phi := map(AK, Pl, {lamK}); fnum := phi numerator f; fden := phi denominator f;
    val = val + (sub(cfs_(c,0), AK)) * (fnum / fden)));
c3 = (-1/6) * val;
<< "c_{x,lam}(u) = pi_3(u (x) x) = " << toString c3 << endl;
<< "numerator factored: " << toString factor numerator c3 << endl << "denominator: " << toString factor denominator c3 << endl;
"c3.txt" << toString numerator c3 << endl << toString denominator c3 << endl << close;
