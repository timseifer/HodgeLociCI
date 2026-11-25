# Cubic tenfold lead W: a candidate explanation by Coble cubics

Written 25 Nov 2026 by Claude (Fable 5.2) for Timothy Seifert, taking over from `leads/TENFOLD_HANDOFF.md`.
Everything here is AI-generated and unreviewed by any mathematician. Labels: EXACT / MOD p / PROVED (AI, unreviewed) /
ARG (paper argument, not checked line by line) / LIT (literature; said whether read) / OPEN. Finite-order statements
are evidence, not proof. Nothing here is a statement about the Hodge conjecture; if this note is right, the class in
question is algebraic on the whole family.

## 0. Verdict in five lines

1. There is an explicit family of cubic tenfolds of codimension 54 containing F_T in its closure: **X has a
   P^8-section that is a Coble cubic** (the cubic sevenfold singular along a principally polarized abelian surface A
   embedded by |3 Theta|). F_T is the boundary where A degenerates to a scroll of twisted cubics over an elliptic curve.
2. Along F_T this family is tangent to the Hodge locus of [V] in exactly the extra direction G_e, with the exact
   coefficient (MOD p, two primes; EXACT over QQ at the point x = (4,3,3), lam = -59/54; blind-checked MOD p).
3. At a general member, the unique class functional supported on the P^8-section has first-order Hodge locus equal to
   the tangent space of the family, of codimension 54 (MOD p, two primes; EXACT over QQ at x = (4,3,3), lam = 3;
   blind-checked MOD p).
4. Every member contains a 2-dimensional family of 4-planes (spans of the theta curves of A; one found and checked
   MOD p). The 5-fold swept by the 4-planes over a theta curve has degree 12, and its class is (ARG) twice the
   continuation of [V]. If that argument holds, W exists, equals this family, and the class is algebraic on it.
5. NOT established: the class statement in 4 (ARG only, not blind-checked), anything beyond first order at a general
   member, exact arithmetic beyond the two points listed, and review by a mathematician. The lead stays OPEN in the
   registry (entries D-TENFOLD-COBLE-FAMILY, D-TENFOLD-PRODUCT-POINTS, N-TENFOLD-THIRD-DETERMINANT).

## 1. Framework: the Hodge locus is a critical locus (PROVED, AI, unreviewed; short)

A cubic tenfold has h^{7,3} = 1 (Griffiths: H^{10-q,q}_prim = R_{3q-9}). For an integral class delta put
W_delta(F) = int_delta Res(Omega/F^4), a holomorphic function on the cone of cubic forms near a point, homogeneous of
degree -4. Since F^5 is orthogonal to F^6 = <Omega, dOmega>, delta is Hodge at F iff W_delta and all its first
derivatives vanish there; by Euler's relation the Hodge locus is exactly Crit(W_delta), and its Hessian is the usual
pairing (H,K) -> delta(HK) on R_3.

Consequence (splitting lemma with parameters). Near a general point of F_T, where the Hessian has one more kernel
direction t than T F_T, W_delta is equivalent to a nondegenerate quadratic form plus f(t,s), s in F_T, and either
f = t^N h(t,s) with h(0,s) not identically 0, or f = 0. So exactly one of:
- (i) the Hodge locus has a component of codimension 54, smooth along general points of F_T, with tangent space
  T F_T + G_e; or
- (ii) near general points of F_T the Hodge locus is F_T with multiplicity N-1, and G_e is obstructed at order N-1.
The registry's orders 2 and 3 (MOD p) say N >= 5 in case (ii). No finite order decides; an explicit family inside the
Hodge locus does.

## 2. First order lives in the P^8 (reduction EXACT; numbers MOD p)

Write F = F_8(z,p,q) + sum_k w_k Phi_k with P^8 = {w = 0}. Then S/(I_V + J_F) = k[z,p,q]/(I_V8, dF_8/dp, dF_8/dq,
Phi_k|P^8): nine variables instead of twelve. Script `tenfold_coble/c1_general_point.m2` (20 s):
- Hilbert function (1, 9, 33, 57, 42, 12, 1); pairing rank on cubics 54 (registry: 54); kernel = (I_V+J)_3 + 3 more
  = two moduli of T + G_e. This is an independent re-derivation of evidence item 4's first-order input.
- The ideal of T is (three bilinear quadrics, two determinant cubics): T is the same thing as a 3x3x3 tensor M, with
  quadrics M(z_k,p,q) and cubics e_1(p) = det M(.,p,.), e_2(q) = det M(.,.,q). Normal form of the section (ARG, orbit
  count 28 = 28): F_8 = M(z,p,q) + e_1(p) + e_2(q).
- Killed hypothesis (pre-registered): "G_e = the third determinant e_0(z) = det M(z,.,.)" is FALSE at first order.
- With a mu_3-graded completion (`c1b_graded_completion.m2`): G_e is invariant, and equals a tensor move plus a
  nonzero multiple of the z-cubic class. This agrees with SS-T6 (G_e leaves the stratum "section singular along a plane").

## 3. Product points (EXACT by hand; checks MOD p)

X_0 = C(w,z) + c_1(p) + c_2(q), C a cubic fourfold containing the plane Pi = {w = 0}, c_1, c_2 isomorphic plane cubics,
class [Pi] x [graph of phi] = [J(Pi, T_phi)]. The Jacobian ring is a tensor product, so everything is explicit:
- rank of the Hessian = 38, kernel 182, normal kernel to the cone locus = the 27 tensor directions z_k p_i q_j (the
  registry's 38 and 27, here for every such point, by hand).
- Periods multiply: W(F_0 + H) = (beta x gamma)(exp(-H)), beta, gamma the period functionals of [Pi] and [graph].
  On the elliptic side the pairing is << S (x) T >> = div(S) pi(T) - pi(S) div(T) with the rule
  gamma(A dh/dp_i) = gamma(dA/dp_i).
- Cubic term on tensors: Delta(M) = f_beta(nu(M(z))), and for c_1 = c_2 the Hesse cubic h_lam:
  **nu(B) = -2 det(B'), B'_{(i+j),(i-j)} = b_ij** (EXACT, by hand; ratio checked MOD p). So the critical cones are the
  two Segre cones {rank-one B'} of dimension 11 = the registry's Sigma_1, and
  **Sigma_1 = tensors in Hesse form alpha X_1 + beta X_2 + gamma X_3 with (alpha:beta:gamma) arbitrary in P^2, while
  F_T is the curve h_lam(alpha,beta,gamma) = 0** (EXACT + `d1_cubic_model.m2`: Hessian corank 11 = 10 + 1, MOD p).
  The registry's 16 = 27 - 11.

## 4. Two period identities on the rank-one locus (MOD p; proof OPEN)

For B' = u (x) x of rank one, x NOT on the curve (`k1_rank_one_vanishing.m2`, `k3_exponential.m2`, `s1_closed_form_c.m2`):
- K1: << exp(-B) >> = 0, checked through degree 18 (p = 32003) and 15 (p = 31991); generic B is nonzero (control);
  symmetry explains only degrees <= 9.
- K3: << p0p1p2 exp(-B) >> = - exp(-c), checked through degree 12 at two primes, with the cubic term in closed form
  (EXACT, symbolic over QQ(lam)):  **c = h_lam(x) h_lam(u) / (27 (1 + lam^3))**.
- On rank-two B' the series does not vanish; its degree-6 term depends only on the adjugate (`k2_rank_two.m2`).
Reading: against the class, h(p) + h(q) + M_x(z,p,q) behaves like h(p) + h(q) + c(z). This is what produced section 5.

## 5. The family

    F#(z,p,q) = a h_lam(z) + b h_lam(p) + c h_lam(q) + M_x(z,p,q),   M_x = sum_{i,j} z_{i+j} x_{i-j} p_i q_j,
    27 (1 + lam^3) a b c + h_lam(x) = 0,          h_lam(v) = v0^3 + v1^3 + v2^3 + 3 lam v0 v1 v2.

- a = 0 forces x on the curve: that is F_T. Moduli: (lam, x, abc) with one relation = 3; F_T has 2. With the choice
  of P^8 and coordinates: dimension 83 in the P^164 of cubic sevenfolds, so codimension 81 - 27 = 54 in tenfolds.
- For a = b = c the relation is the **Burkhardt quartic** y0^4 - y0(y1^3+y2^3+y3^3+y4^3) + 3 y1y2y3y4 = 0 in the P^4 of
  Heisenberg-invariant cubics (EXACT algebra: a = t y0, 3 lam a = -3t y1, x = -3t (y2,y3,y4)), and block scalings
  reduce every member to a = b = c. LIT (read: Beauville, C. R. 337 (2003), Proposition; Ren-Sam-Schrader-Sturmfels,
  arXiv:1303.1132, section 3): the cubic singular along the abelian surface is unique, and Coble cubics are
  parametrized by the Burkhardt quartic. So the members are **Coble cubics**.
- The determinant of a 3x3 matrix (two families of 5-planes meeting pairwise in a P^2, Movasati's configuration) is
  the member lam -> infinity, x a coordinate point, abc = -1 (EXACT, by hand): the Fermat-point lead and the F_T lead
  are two boundary strata of one family (ARG).

Tests (`n1_candidate_family.m2`, pre-registered; MOD 32003 and 31991, 3 members and 3 points of F_T;
`n1_candidate_family_exact.m2`, EXACT over QQ, at the member x = (4,3,3), lam = 3, a = -221/378 and at the point of
F_T x = (4,3,3), lam = -59/54; all of N1-N4 hold there exactly):
- N1 Sing(F# = 0) is a surface of degree 18 with Hilbert polynomial 9 n^2, cut out by 9 quadrics. Controls: a -> 2a
  smooth; a -> 0 with x generic: only a plane.
- N2 A = k[z,p,q]/(dF#, Phi) has Hilbert function (1, 9, 33, 57, 39, 9, 1); the pairing on cubics has rank 54.
- N3 kernel of the pairing = (ideal part) + the four derivatives of F# along the family. Controls with the z-cubic
  coefficient doubled, or without it, fail.
- N4 at points of F_T the same derivatives lie in the kernel of the pairing of [V]; the one transversal to the curve
  is G_e. So G_e = (move x off the curve) - (grad h_lam(x).dx / (27(1+lam^3))) h_lam(z), coefficient exact.
- At a point of F_T, Sing = plane + a degree-18 surface; the 4-planes J(Pi, ruling) of V meet it in the plane and a
  twisted cubic (`p4c_ft_planes.m2`): the abelian surface has become a scroll of twisted cubics over E glued along a
  plane cubic in Pi (ARG for the gluing).

Blind check (25 Nov, separate agent, own Macaulay2 and Python code from the definitions only): N1-N4, the Burkhardt
identity (exact) and K1/K3 all PASS (6 to 12 instances each, two primes). It found more: the degree-18 surface is
smooth (2 instances) and unmixed with h^1(O) = 2, h^2(O) = 1 (5 instances), its saturated ideal is the 9 partials
plus 3 cubics, and **the kernel of the pairing is (ideal of the singular surface)_3 + (ideal part)**, independent of
Phi: the three extra cubics through A are the three moduli of A. Its caveats: modular evidence at a handful of
points; primality of the ideal only indirectly; at a = 0, x generic, the singular scheme is a non-reduced plane.
NOT blind-checked: sections 1, 3 (by hand), the 4-plane runs and all of section 6.

## 6. The cycle (ARG, with one MOD p instance)

- Each theta curve Theta_x of A is a genus-2 sextic spanning a P^4; a cubic singular along A contains the secant
  threefold of Theta_x (degree 8), hence the whole P^4. So a Coble cubic contains a 2-dimensional family of 4-planes
  parametrized by A (ARG; LIT: Gruson-Sam, arXiv:1301.5276, Theorem 3.6 identifies the abelian surface with a Fano
  variety of the Coble cubic; only the introduction was machine-read). `p4b_theta_planes.m2`: one such plane found
  MOD p: it lies in the cubic, meets Sing in a curve with Hilbert polynomial 6n - 1, and h^0 of its normal bundle in
  the cubic is 2.
- For a curve Gamma in A let Z_Gamma = union of P^4_x, x in Gamma: a 5-fold of degree 6 Theta.Gamma (Chern class
  count), so Z_Theta has degree 12. On F_T the 4-planes J(Pi, ruling) are the spans of the degenerate theta curves
  (plane cubic + twisted cubic), and V = Z_sigma with Theta.sigma = 1.
- Class (ARG): Gamma -> [Z_Gamma] is a map of Hodge structures H^2(A) -> H^10(X). Classes of cycles inside the P^8 have
  functionals in the dual of A_6, which is one-dimensional (N2); so the map has rank <= 1 modulo h^5 on H^{1,1}(A), and
  for general A (transcendental part irreducible) it factors through Gamma.Theta. Specializing to F_T:
  [Z_Theta] -> [Z_sigma] + [Z_f] = 2 [V]. Since [V] is not a multiple of h^5, neither is [Z_Theta], and
  **(1/2)[Z_Theta] is the continuation of [V]**: Hodge, indeed algebraic, on the whole family.
- With section 1: the family is in the Hodge locus, has the dimension of its tangent space, so it is the component W
  (case (i)), smooth along general points of F_T.

## 7. What is not established, and how this could be wrong

- The class statement of section 6 is a paper argument. Weak steps: the specialization of the correspondence to F_T
  (flatness of the family of 4-planes; that [Z_f] exists as a limit), and "functional killed by w" for the complex
  classes in the image. A direct check is listed below.
- Sections 4 and N1-N4 are MOD p except where EXACT is stated. The identities K1, K3 have no proof.
- "Abelian surface" rests on: degree 18, Hilbert polynomial 9 n^2, smooth with h^1(O) = 2, h^2(O) = 1 (blind check,
  MOD p, few instances), and the Burkhardt identity; no characteristic-0 proof for the general member.
- Nothing beyond first order was computed at a general member (only the two period components behind K1, K3).
- That the family is the registry's W at the Fermat point (Movasati's class) is ARG (same closure, determinant limit).
- LIT items were recalled or machine-read as stated; none was checked against a full source by a person.

## 8. Plan (none of it needs large compute)

1. DONE 25 Nov: blind check of N1-N4, the Burkhardt identity and K1/K3 (all PASS; see section 5 and the registry).
2. Replace the class ARG by a computation: at a point of F_T build Z_f and count Z_f.T' in the cubic fourfold
   section (18 means [Z_f] = [V]; 12 or 6 would contradict section 6); or compute the cylinder map of the 4-plane
   family by residues.
3. Order 2 and 3 along the explicit arc at a point of F_T with the existing so3_t6 machinery (1-2 CPU-hours): the
   explicit second-order term must solve the registry's order-2 system.
4. Exact arithmetic at a second rational member; irreducibility of the singular surface.
5. Read Gruson-Sam sections 3-4 (Fano variety, degenerations) and match their boundary types with F_T and the
   determinant; then a one-page note for a mathematician (the owner decides whether to send it).

## 9. Credits

Previous agent (Opus 5.5) and its registry entries O-TENFOLD-CONE-LEAD, N-TENFOLD-CODIM54-SEARCH, -2,
N-TENFOLD-DIRECT-METHODS: the lead, the numbers 38 / 27 / 16 / 54 / 55, orders 2-3, and the searches that excluded
the obvious constructions. rStation papers #5 and #11 (u/lelong_ridge, Oct 2026): V_Z is a component; the open
question of a component of slice dimension > 155; Thom-Sebastiani cubic tenfolds. Movasati (arXiv:1902.00831),
Kloosterman (arXiv:2312.12363), Addington-Hassett-Tschinkel-Varilly-Alvarado (C_18). Coble (1917); Beauville (2003);
Gruson-Sam-Weyman (arXiv:1203.2575); Gruson-Sam (arXiv:1301.5276); Ren-Sam-Schrader-Sturmfels (arXiv:1303.1132).
