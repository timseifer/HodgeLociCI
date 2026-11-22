EXPORT FOR ONE BLIND CHECK (team T3, round 2).  Start with cert_n6_lam-1.txt (one arc, 4 + 6 monomials).

THE CLAIM, IN TWO SENTENCES
On the Fermat cubic F0 = x0^3 + ... + x_{NV-1}^3 (NV = 8: sixfold; NV = 10: eightfold) with Movasati's two planes P1, P2 and
delta = [P1] + lambda [P2], the explicit arc F_eps = F0 - (eps T_1 + eps^2 T_2 + ...) of the file is tangent to the Hodge locus of
delta but not to the locus V of cubics containing both planes, every period function Phi_Q(F_eps) vanishes to order N - 1
(N = 5 for NV = 8, N = 4 for NV = 10), and the vector of coefficients of eps^N is NOT in the image of the first-order map L.
Since ker L has dimension dim V + 1, this shows (given the period expansion below) that the Hodge locus of delta has no
component of dimension dim V + 1 through the Fermat point, for the lambda of the file.

WHY ONE ARC SUFFICES (the logic the certificate relies on)
Let M be the zero set of rank(L) period functions with independent differentials; it is a smooth germ with tangent space
ker L, of dimension dim V + 1 (rank L = 7 against rank [L_P1; L_P2] = 8 for NV = 8; 19 against 20 for NV = 10).  The Hodge locus
lies in M.  If it had a component of dimension dim V + 1 it would equal M, so f = K.Phi would vanish on M for every left-kernel
vector K (K.L = 0).  The arc satisfies all period equations modulo eps^N, so it is within O(eps^N) of M, and df = K.L = 0 at
F0; hence f(F_eps) = O(eps^(N+1)) would follow, i.e. K.c_N = 0.  The file exhibits K with K.c_N != 0.
Assumed, not checked here: Griffiths' description of the Hodge locus by the period functions, the Griffiths-Dwork reduction,
and the period formula for a linear subspace (P_i below); and that V is smooth with tangent space ker L_P1 n ker L_P2.
Not claimed: anything about algebraic cycles or the Hodge conjecture.

NORMALISATION OF THE PERIODS (everything is defined up to ONE nonzero constant common to all Q; exact arithmetic in Q(z))
z = zeta_6, z^2 = z - 1, z^3 = -1.  k = NV/2 - 1.  Omega = the standard (NV-1)-form on P^(NV-1).
Planes: {x_a = zeta_ab x_b} on the pairs (a,b) = (0,1),(2,3),...; the roots zeta_ab = z^e are listed in the file (z^3 = -1).
(1) Period polynomial of a plane:  P_i = prod over the pairs (a,b) of  3*zeta_ab*(x_a + zeta_ab*x_b)   (sign +1 for this
    pairing; a squarefree form of degree NV/2).   P_delta = P_1 + lambda*P_2.  It is listed at the end of each file.
(2) For a squarefree monomial x^R of degree NV/2:   I(x^R, k+1) := int_delta Res( x^R Omega / F0^(k+1) ) = coefficient of the
    complementary monomial x^(R^c) in P_delta.   For a monomial with all exponents <= 1 and pole order m != k+1:  I = 0.
(3) Griffiths-Dwork at Fermat: if beta_j >= 2 then   I(x^beta, m+1) = ((beta_j - 2)/(3m)) * I(x^(beta - 3 e_j), m)
    (so I = 0 as soon as an exponent equal to 2 is met; the result does not depend on the order of the reductions).
(4) Period functions:  Phi_Q(F) = int_delta Res( Q Omega / F^k ),  Q a squarefree monomial of degree NV/2 - 3 (x_i for NV = 8,
    x_i x_j for NV = 10), and for T a cubic form   Phi_Q(F0 - T) = sum_{m >= 0} binomial(k-1+m, m) * I(Q*T^m, k+m).
    Substitute T = eps T_1 + eps^2 T_2 + ... and collect powers of eps: c_n[Q] = coefficient of eps^n.
    Equivalent closed form (used to produce the files):  Phi_Q(F0 - T) = k * Psi(Q*exp(T)),  Psi(x^g) = prod_j ((1+r_j)/3)_{m_j}
    * [coefficient of x^(R^c) in P_delta]  if g_j = 3 m_j + r_j with all r_j in {0,1} and exactly NV/2 of them equal to 1
    (R = their support; (a)_m = a(a+1)...(a+m-1)), and Psi(x^g) = 0 otherwise.
(5) First-order map:  L[Q][x^alpha] = c_1 for T = x^alpha = k * [coefficient of x^((Q x^alpha)^c) in P_delta] if Q and x^alpha are
    coprime, else 0; alpha runs over the squarefree cubics (the monomials x_i^2 x_j are in the kernel of L and are not used).
    L_P1, L_P2: the same with P_1, P_2 in place of P_delta.

WHAT TO RECOMPUTE
 a. c_n[Q] = 0 for all Q and 1 <= n <= N-1;   b. the listed c_N[Q];   c. K.L = 0 and K.c_N as listed (nonzero);
 d. L.T_1 = 0 and L_P1.T_1 != 0.
A wrong certificate would show a nonzero c_n with n < N, or c_N in the image of L.

FILES (coefficients are written a+b*z, a, b rational; [c]*x_i*x_j*x_k is a term of a cubic)
 cert_n6_lam-1.txt, cert_n6_lam2.txt, cert_n6_lam5o3.txt     NV = 8,  N = 5
 cert_n8_lam-1.txt, cert_n8_lam2.txt, cert_n8_lam5o3.txt     NV = 10, N = 4
Control (not exported): at lambda = 1 the same construction gives c_N IN the image of L for both NV, as it must (the locus is
smooth of dimension dim V + 1 there).  Further values run with the same outcome as the files: lambda = 3, -2, 1/2.
Produced by ../cert.py (exact, python-flint rationals); the checker should NOT need it.
