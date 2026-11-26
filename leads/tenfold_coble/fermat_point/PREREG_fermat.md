# Pre-registration: the Coble family at the Fermat cubic tenfold

Written 25 Nov 2026 (late night) by Claude (Fable 5.2) BEFORE any of the computations below were run. Kept as
written; results go in `leads/TENFOLD_COBLE_LEAD.md`, section 13. AI-generated, unreviewed. Nothing here is a
statement about the Hodge conjecture.

## 0. A correction found by theory, before computing

The planned check was: "feed the explicit cubic arc F_0 + t M_xi - t^3 (sum xi^3 / 27) h_0(z) of the Coble family
into the order-12 Fermat engine, for Movasati's class". Working it out by hand first:

(a) (EXACT, by hand) Rescaling the three vertex coordinates turns that cubic arc into the LINE F_0 + tau M_xi. More:
    with the twelve Fermat coordinates grouped as r, y, p, q (three each), every tenfold

        X_x :  h_0(r) + h_0(y) + h_0(p) + h_0(q) + M_x(y, p, q) = 0,    M_x = sum_{i,j} x_{i-j} y_{i+j} p_i q_j,

    has 27 P^8-sections {r_k = -theta_k y_k}, theta_k^3 = 1 + h_0(x)/27, which are Coble cubics (lam = 0,
    a = 1 - theta^3). So a 3-parameter family through the Fermat tenfold (x = 0) lies in the Coble family.
(b) (ARG) The class the family carries at x = 0 is NOT Movasati's two-plane class P1 - P2. Along the cone h_0(x) = 0
    the tenfold contains V = J(Pi, T_x), and for x a flex the scroll T_x is the residual of three disjoint planes in a
    Segre threefold section: [T] = 3 h^2 - Pa - Pb - Pc. So the class is kappa = h^5 - P1 - P2 - P3, where
    P1, P2, P3 are the three 5-planes of ONE pairing through the same P^2 (Movasati's two planes and the third one).
    kappa and P1 - P2 are different markings of the same cone: on the Fermat tenfold kappa is supported on 16 torus
    characters and P1 - P2 on 48, and automorphisms permute characters.

Consequence: the planned run would have tested the wrong class. What can be tested at the Fermat tenfold is the
three-plane class kappa. Movasati's own class is NOT tested by anything below.

## 1. What is run, and what each outcome would mean

Notation: Psi_v = the Fermat period functional of a class v (closed form, Pochhammer weights, as in
`tooling/fermat_series`); the Hodge condition for v along the line F_0 + tau M_x is
S(Q, n) := Psi_v(Q M_x^n) = 0 for all n >= 0 and Q in {1} u {220 squarefree cubics}.

A. First order (EXACT). Is M_x in ker L for kappa, and for P1 - P2 (and the other two differences)?
   - kappa yes, differences no (predicted): the correction (b) stands.
   - differences yes: (b) is wrong; then the main test C is run for P1 - P2 as originally planned.
   - kappa no: the identification of the class is wrong; go to D before anything else.

B. Membership (EXACT over QQ at one rational x, and MOD p at random x). The section of X_x by r = -theta y equals
   the normal form of the lead note, and its singular locus is a surface of degree 18 with Hilbert polynomial 9 n^2.
   - yes (predicted): (a) holds at that member.  - no: an algebra slip in (a); stop and fix.

C. Main test. S(Q, n) for kappa as a polynomial in x (EXACT over QQ) for n <= N1, and MOD p at random x for
   n <= N2 > N1 (as far as it is cheap; at least 12, the order reached by the registry's arcs).
   - identically zero for all n, Q (predicted): the three-plane class stays Hodge to that order along the family,
     with no correction terms. This agrees with section 10 of the lead note at a different point, with different
     period formulas. Finite order: evidence, not proof.
   - nonzero, but divisible by h_0(x): the class is Hodge only over the cone a = 0 (the C_18 family F_T), not on the
     Coble family. That would contradict the conclusion of section 10 at this point. Report it as such.
   - nonzero and not divisible by h_0(x): the class identification (b) is wrong even on F_T; use D.

D. Which classes survive. For v = any complex combination of the 924 torus eigenclasses of type (5,5): the space
   V(N) of v with Psi_v(Q M_x^n) = 0 for all Q, all n <= N, identically in x.
   - contains the 8-dimensional span of the 27 classes kappa_theta (predicted); its dimension is recorded. Anything
     beyond the classes I can name is reported as OPEN, not interpreted.
   - does not contain it: see C.

Controls (the test must be able to fail):
   K1. P1 - P2, P1 - P3, P2 - P3, and P1 alone: must fail (order 1 or 2).
   K2. The wrong combination of the same two eigenclasses (sign flipped): must fail at low order.
   K3. One coefficient of M_x changed (so the tenfold is no longer in the family): kappa must fail at low order.
   K4. The counts of nonzero individual terms in the vanishing sums are recorded (a sum of no terms proves nothing).
   If K1-K3 pass instead of failing, the test has no teeth and nothing is concluded.

E. Cross-check with the repository's engine (`tooling/fermat_series`, written by the previous agent), patched only in
   its table of plane coefficients: the same vanishing, two primes. Disagreement with my own code = a bug; resolve
   before reporting.

F. Independent check: a separate agent gets the statements only (not my code or numbers).

## 2. What this cannot show

- Nothing about Movasati's class P1 - P2: that the registry's W for that class is the Coble family stays ARG
  (irreducibility of the marked family of C_18 fourfolds), and no explicit arc for it is known.
- Finite order in tau. Not a proof that the class is Hodge on the family, and nothing about algebraicity beyond
  section 10.

## 3. Addendum, written after steps A-D and the controls K3, K4 had run, and BEFORE any run of section 3

What the first runs showed (details go in the lead note): A as predicted (the differences fail at order 1); B as
predicted; C zero through order 15, identically in x; D: the classes staying of type (5,5) form a 220-dimensional
space, stable from order 4 to 12. But control K4, taken seriously, says the main test C had no teeth: every
vanishing sum is forced by a symmetry of the family (three reflections), except one period function, and that one
vanishes because (P - Q) m_d lies in the Jacobian ideal (found MOD p; the exact version is being run). So on the
symmetric family X_x the class is Hodge for a reason that has nothing to do with section 10. That is a result (and
probably a proof), but it is not a test of section 10.

A test with teeth: leave the symmetric family inside the Coble family. Every cubic

    F = F_x + sum_k (r_k + theta(x) y_k) * phi_k,      theta(x)^3 = 1 + h_0(x)/27,    phi_k any quadrics,

has the same P^8-section {r_k = -theta y_k} as X_x, so it is in the Coble family, and for general phi_k it has no
symmetry. Take x = tau * xi and phi_k -> tau * phi_k with fixed sparse random phi_k:

    F_tau = F_0 + tau ( M_xi + sum_k (r_k + theta(tau) y_k) phi_k ),   theta(tau) = (1 + tau^3 h_0(xi)/27)^(1/3).

In the engine's convention F = F_0 - sum_j tau^j T_j this is T_1 = -(M_xi + sum_k (r_k + y_k) phi_k) and
T_(3j+1) = -theta_j sum_k y_k phi_k (theta = sum_j theta_j tau^(3j)); no free terms. The engine
(`tooling/fermat_series`) is used with its table of plane coefficients replaced by the three-plane class.

G (validity gate, must pass before anything is read): the engine was written for arcs in the squarefree slice. Run
it on arcs F_0(g_tau x) for explicit polynomial coordinate changes g_tau (not in the slice, with a sign that
matters): all period equations must vanish at every order for P1 - P2 and for the three-plane class; with the
signs of the T_j flipped they must not. Also compare the engine with my own dictionary implementation on the
arcs of H, orders <= 5. If G fails, nothing below is read.

H (the test). For 3 seeds (xi and phi_k random, phi_k with 2 monomials each) and 2 primes, orders 1..N (N as far as
memory allows, at least 7): all period equations c_n[Q] = 0?
   - all zero, and the controls below fail: finite-order evidence (MOD p) that a part of the Coble family with no
     symmetry lies in the Hodge locus of the three-plane class at the Fermat tenfold, with no correction terms.
     Same kind of evidence as the registry's arcs for Movasati's class; not a proof.
   - nonzero at order n: section 10 fails at this point, or the class or the family is misidentified. The terms
     linear in the phi_k (they test only "the class functional is supported on the P^8") will be separated from the
     rest before anything is concluded. Reported as a failure of the lead's main claim at this point.
Controls (must fail; if they pass, H has no teeth):
   H1. the same arc with theta = 1 (drop T_4, T_7, ...): expected to fail at order 4 if L(T_4) != 0 (checked first).
   H2. the same arc with the sign of h_0(xi) flipped in theta.
   H3. the same arc for P1 - P2 and for the three-plane class with one eigen-sign flipped.
   H4. phi_k multiplied into (r_k + 2 y_k) instead of (r_k + y_k) (not the right P^8).

## 4. Second addendum, written after the first runs of H (seed 1, orders <= 12, passed; controls failed as required)
##    and BEFORE any run of H'

H covers only the Coble cubics with lam = 0. H' adds the third modulus lam, so that the arc moves in all moduli of
the Coble cubic (lam and x) and in the quadrics phi_k. With lam = lam_1 tau, x = tau xi, and the relation of the
normal form 27 (1 + lam^3) a + h_lam(x) = 0, theta^3 = 1 - a:

    F_tau = F_0 + 3 lam (P + Q) + 3 a lam Y + M_x + sum_k (r_k + theta y_k) tau phi_k,
    P = p_0 p_1 p_2, Q = q_0 q_1 q_2, Y = y_0 y_1 y_2,   a = -h_lam(x) / (27 (1 + lam^3)),
    h_lam(x) = tau^3 (h_0(xi) + 3 lam_1 tau xi_0 xi_1 xi_2).

Its P^8-section {r_k = -theta y_k} is the normal form a h_lam(y) + h_lam(p) + h_lam(q) + M_x (EXACT, by hand; checked
in the script by substitution at a numeric tau). All T_j are determined; no free terms.
   - all period equations zero to order N, controls failing: as for H, now with all three moduli of the Coble cubic.
   - nonzero: as for H.
Controls (must fail): H'1 drop the term 3 a lam Y (expected at order 4); H'2 use h_0(x) in place of h_lam(x) in a
(expected at order 5); H'3 drop the factor (1 + lam^3) in a (expected at order 7); H'4 Movasati's class P1 - P2.
If H'1-H'3 fail at those orders and the true arc passes, the test is sensitive to each part of the relation that
defines the Coble cubics (the Burkhardt quartic), not only to its leading term.
