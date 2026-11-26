# Cubic tenfold lead W: a candidate explanation by Coble cubics

Written 25 Nov 2026 by Claude (Fable 5.2) for Timothy Seifert, taking over from `leads/TENFOLD_HANDOFF.md`.
Everything here is AI-generated and unreviewed by any mathematician. Labels: EXACT / MOD p / PROVED (AI, unreviewed) /
ARG (paper argument, not checked line by line) / LIT (literature; said whether read) / OPEN. Finite-order statements
are evidence, not proof. Nothing here is a statement about the Hodge conjecture; if this note is right, the class in
question is algebraic on the whole family.

## 0. Verdict in six lines (items 4-6 rewritten the evening of 25 Nov 2026; see section 10)

> 26 Nov 2026: read section 13 with item 6. At the Fermat tenfold the explicit arcs of this family carry a
> different class from Movasati's (the three-plane class); the family passes a finite-order test there for that
> class. For Movasati's class the identification with the registry's W is unchanged: a paper argument.
> 26 Nov 2026, later: section 14. The class of the 4-plane cycle is not a multiple of h^5 by an intersection count
> with a 5-plane (8 points, where a multiple of h^5 would give 4; MOD p, predicted in advance, blind-checked). This
> does not use the node argument or the ladder of section 10.

1. There is an explicit family of cubic tenfolds of codimension 54 containing F_T in its closure: **X has a
   P^8-section that is a Coble cubic** (the cubic sevenfold singular along a principally polarized abelian surface A
   embedded by |3 Theta|). F_T is the boundary where A degenerates to a scroll of twisted cubics over an elliptic curve.
2. Along F_T this family is tangent to the Hodge locus of [V] in exactly the extra direction G_e, with the exact
   coefficient (MOD p, two primes; EXACT over QQ at the point x = (4,3,3), lam = -59/54; blind-checked MOD p).
3. At a general member, the unique class functional supported on the P^8-section has first-order Hodge locus equal to
   the tangent space of the family, of codimension 54 (MOD p, two primes; EXACT over QQ at x = (4,3,3), lam = 3;
   blind-checked MOD p).
4. Every member contains a 2-dimensional family of 4-planes (LIT: Benedetti-Manivel-Tanturri, abstract read; one
   found and checked MOD p). The 5-fold Z_Theta swept by the 4-planes over a theta curve has degree 12 (Chern class
   count; sampled MOD p) and **Z_Theta.Z_Theta = -144** on the tenfold, where a multiple of h^5 would have 48
   (ARG, section 10: two arguments with MOD p inputs, added the evening of 25 Nov). So [Z_Theta] = 4 h^5 ± 2 ([V] - 2 h^5).
   If those arguments hold, W exists, equals this family, and the class is algebraic on it (outcome (a) of the
   handoff; not "a Hodge class not known to be algebraic").
5. Along the explicit arc of the family through a point of F_T the Hodge condition for [V] holds exactly at orders 2
   and 3, with prescribed second- and third-order terms (MOD p, section 10.6). Finite order: evidence, not proof.
6. NOT established: the two arguments of section 10 have not been read by a mathematician; their inputs are MOD p;
   the sign in 4; that the family is the registry's W at the Fermat point (ARG). The lead stays OPEN in the registry
   until a person has read the arguments (entries D-TENFOLD-COBLE-FAMILY, D-TENFOLD-COBLE-CYCLE-CLASS,
   D-TENFOLD-COBLE-ARC-ORDERS, D-TENFOLD-PRODUCT-POINTS, N-TENFOLD-THIRD-DETERMINANT).

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
  [WITHDRAWN 26 Nov 2026, section 13.1: on a tenfold with a determinantal section the two 5-planes are homologous,
  so this is not evidence about Movasati's class.]

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

## 6. The cycle (ARG, with one MOD p instance; the class statement is superseded by section 10)

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
  [26 Nov 2026: the "determinant limit" part is withdrawn; what remains is the irreducibility argument of 13.5.]
- LIT items were recalled or machine-read as stated; none was checked against a full source by a person.

## 8. Plan (none of it needs large compute)

1. DONE 25 Nov: blind check of N1-N4, the Burkhardt identity and K1/K3 (all PASS; see section 5 and the registry).
2. DONE 25 Nov (evening), differently: section 10.2-10.5 (nodes, local classes, ladder; Z.Z = -144). Earlier text:
   Replace the class ARG by a computation: at a point of F_T build Z_f and count Z_f.T' in the cubic fourfold
   section (18 means [Z_f] = [V]; 12 or 6 would contradict section 6); or compute the cylinder map of the 4-plane
   family by residues.
3. DONE 25 Nov (evening): section 10.6, both orders hold exactly. Earlier text:
   Order 2 and 3 along the explicit arc at a point of F_T with the existing so3_t6 machinery (1-2 CPU-hours): the
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
For section 10: Benedetti-Manivel-Tanturri (arXiv:1904.10848); Dimca (Duke Math. J. 60, 1990) and Kloosterman
(arXiv:1612.06726) for the defect formula; Siersma-Tibar (Duke Math. J. 80, 1995) and Parusinski (1995) for the
bouquet theorem; the previous agent's period engine (so_t6, so3_t6) for orders 2 and 3; the other agent's
N-TENFOLD-SINGULAR-SECTIONS, whose stated next step (sections singular along a non-planar surface) is what this is.

## 10. Update, 25 Nov 2026 (evening): the class of the cycle; orders 2 and 3

This section carries out items 2 and 3 of the plan in section 8 and replaces the class argument of section 6.
Pre-registrations, written before the runs and kept as written: `tenfold_coble/PREREG_step1.md`,
`tenfold_coble/PREREG_step2.md`. Scripts: `tenfold_coble/h1`-`h5c`, `s2_arc_orders.m2`. All computations MOD p
(32003 and 31991); nothing in this section is EXACT over QQ.

### 10.1 What came out

- (ARG, inputs MOD p) The cycle Z_Theta of section 6 has Z_Theta.Z_Theta = -144 on the tenfold. A multiple of h^5 of
  the same degree 12 has 48. So [Z_Theta] is not a multiple of h^5; in the lattice of section 6 it is
  4 h^5 + c v_0 with v_0 = [V] - 2 h^5 and c^2 = 4, that is [Z_Theta] = 2 [V] (c = 2) or 8 h^5 - 2 [V] (c = -2; the
  sign was not checked; +2 by the degeneration to F_T, where one of the two branches at a node becomes the branch
  of V and both stay in one ruling: ARG). Two arguments, A (10.3) and B (10.4), with
  different inputs; neither is the argument of section 6.
- (MOD p) Along the explicit arc of the family through a point of F_T the Hodge condition for [V] holds exactly at
  orders 2 and 3, as identities with no freedom (10.6).
- (ARG) Together with sections 1 and 5: the family W# lies in the Hodge locus of [V], has the dimension of its
  tangent space at a general member, and contains F_T in its closure. So it is the component W of the handoff
  (case (i) of section 1), and on it [V] = (1/2)[Z_Theta] or 4 h^5 - (1/2)[Z_Theta]: algebraic with rational
  coefficients. This is outcome (a) of the handoff. It is NOT "a Hodge class not known to be algebraic".

### 10.2 The mechanism: hyperplane sections with 72 nodes (MOD p; reason ARG)

Let X be a member (X ∩ P^8 = Y a Coble cubic, singular along A) and H a general hyperplane containing the P^8.
Then X ∩ H is a cubic 9-fold whose singular points are the 72 points A ∩ {Psi_1 = Psi_2 = 0}, Psi_i the two
derivatives of F transversal to the P^8 inside H; equivalently H is tangent to X at 72 points of A (the Gauss map of
X sends A to the plane of hyperplanes through the P^8, with degree 72 = 18 * 4). They are ordinary double points
(ARG: the Hessian of F restricted to P^8 has rank 6 along A with kernel the tangent plane, and the two gradients
border it to rank 10 when the Psi_i meet transversally on A).

| Test (pre-registered) | Result | Instances |
| --- | --- | --- |
| H1: A ∩ {Psi_1 = Psi_2 = 0} | 72 reduced points | 32003 seed 1; 31991 seed 2 |
| H1: Jacobian scheme of a random completion f on P^10 | dimension 0, degree 72, nothing off the P^8 | 32003 seed 1; 31991 seed 2 (3 min each) |
| H2: Hilbert function of the 72 points | (9, 34, 63, 71, 72): they fail by one on quartics | both |
| H2 control: 36 points (linear ∩ quadric section of A) on quartics | independent | both |
| H1/H2 at a point of F_T | 76 = 4 (on the plane) + 72 (on the degree-18 surface) reduced points; quartics: 75; the 4 are independent, the 72 fail by one | 32003 seed 1 |
| H1 at a point of F_T: Jacobian scheme on P^10 | dimension 0, degree 76, nothing off the P^8 | 32003 seed 1 (6 min) |
| L1: Y ∩ P^6 | 18 nodes; fail by one on quadrics | 32003 seed 1; 31991 seed 2 |
| L2: Sing(Y ∩ P^7) ∩ quadric | 36 points; fail by one on cubics | both |
| L3: Y ∩ P^5 | smooth cubic fourfold | both |

The failure by exactly one is Cayley-Bacharach on a surface with trivial canonical class (4H = K_A + 2H + 2H;
3H = K_C + 2H on the curve A ∩ H'; 2H = K_A + H + H). By Dimca's formula (LIT: Dimca, Duke Math. J. 60 (1990); the
degree nd/2 - n - 1 was taken from the statement quoted in Kloosterman, arXiv:1612.06726, Theorem 2.5; neither
paper was read in full) a nodal cubic 9-fold whose 72 nodes fail by one on quartics has one extra class in H_10.
That number was a pre-registered consistency test of the argument below (0 or 2 would have contradicted it); the
argument itself does not use the formula. It also matches dim A_6 = 1 of section 5.

So the picture is: the class lives on X because a hyperplane section acquires 72 nodes with one relation, and the
relation exists because K_A = 0. This also fits the other agent's N-TENFOLD-SINGULAR-SECTIONS (plane-singular
sections explain nothing; "sections singular along a non-planar surface" was its next step).

### 10.3 Argument A: local classes at the nodes (ARG; one LIT theorem)

1. For a node p of the 9-fold X' = X ∩ H, H_10(X', X' - p; Q) = Q. A smooth 5-fold germ through p inside X' has
   tangent space a maximal isotropic 5-space of the node's quadric, and local class +1 or -1 according to its family
   (ruling). H_10(X' - Sigma; Q) = Q by Lefschetz and duality, generated by a linear section. So a 5-cycle with a
   non-zero local class at some node is not a rational multiple of the linear section class in H_10(X'; Q).
2. At a general point p of A exactly two 4-planes of Z_Theta_a pass (x in Theta_a ∩ Theta_p), and near p the cycle
   is two smooth branches with tangent 5-spaces span(P^4_x, T_pA). The 4-planes through p form a connected family
   (a theta curve), so all branches through p are in the same ruling: local class ±2 at every node.
   Checked MOD p (H3, H3b; 32003 seeds 1-5, 31991 seed 2): for the 4-plane P of `p4b` and its images under the
   index shift sigma and sigma^2, P ∩ gP is exactly a line, it meets A in two points, and at those points the two
   spans are 5-planes inside the tangent cone (rank 6) meeting in a P^3 (a P^4 would mean different rulings).
   From the tested pair to a general pair (ARG, written out at the blind checker's request): "same ruling" is the
   parity of the dimension of the intersection of two maximal isotropic spaces, locally constant on the set of
   triples (p, x, y), p in Theta_x ∩ Theta_y, x != y, where both spans are 5-planes; that set is irreducible
   (it is an open part of A x Theta x Theta), and the tested pair lies in it.
3. H_10(X'; Q) -> H_10(X; Q) is injective: X - X' is a typical fibre of a cubic polynomial on C^11 whose fibres are
   smooth along the hyperplane at infinity and whose part at infinity X' has isolated singularities; such a fibre is
   a bouquet of 10-spheres (LIT: Siersma-Tibar, Duke Math. J. 80 (1995), Theorem 3.1, as quoted in arXiv:2201.11026,
   Theorem 2.4; Parusinski 1995; snippets read, not the papers), so H^9(X - X') = H_11(X, X') = 0. The Euler
   characteristic agrees: 2^11 - 72 spheres.
   The blind checker gave a justification that does not need the quoted theorem: the closure of a fibre is singular
   at a point at infinity iff grad f_3 = 0 and f_2 = 0 there, independently of t; X smooth at the nodes means
   f_2 != 0 there, so all fibre closures are smooth along infinity and t is a submersion on a product
   stratification; by Thom's isotopy lemma the only atypical values are affine critical values, C^11 is the fibre
   plus 11-cells, the fibre is 9-connected, H^9 = 0. Euler characteristics: 1377 for X, -600 for X', 1977 = 1 + 1976.
4. Hence [Z_Theta] is not a rational multiple of h^5 in H^10(X; Q).

### 10.4 Argument B: a ladder of self-intersections (ARG; classical intersection theory; no use of A.3)

Formula (derived by blowing up the nodes; to be checked by a person). X smooth of dimension 2m, X' = X ∩ H with
nodes only, Z, Z' of dimension m inside X', X'' = X' ∩ H' a general hyperplane section:

    Z.Z' (on X) = (Z ∩ H').(Z' ∩ H') (on X'') - (-1)^(m-1) sum_p n_p(Z) n_p(Z'),

n_p = (sheets in one ruling) - (sheets in the other) of the tangent cone at p. Applied at the tenfold (72 nodes),
the eightfold (36) and the sixfold (18), down to the smooth cubic fourfold X_4 = Y ∩ P^5 and the surface
S = Z ∩ P^5:

    Z.Z = S.S - 18 n^2 + 36 n^2 - 72 n^2 = S.S - 54 n^2        (n = absolute value of the local classes).

- Test on a known case: V at a point of F_T. S = T, T.T = 18 (LIT: Addington-Hassett-Tschinkel-Varilly-Alvarado,
  the C_18 scroll; recalled), n = 1 at the nodes on the degree-18 surface, local class 0 at the nodes on the plane
  (assumed when this was written; then checked by the blind checker, MOD p: at a point of the plane the scroll T has
  class 3 sA + 3 sB in the transversal quadric, so the two rulings cancel). The ladder gives 18 - 54 = -36, the
  registry's [V]^2. The checker also tested the formula on a P^m in a smooth cubic 2m-fold (2^m nodes): it returns
  the top Chern class of the normal bundle for m = 2..5.
- Z_Theta: n = 2 (10.3, step 2). S is the image of a ruled surface over a genus-2 curve with H^2 = 12, hyperplane
  section of genus 2, and delta double points, delta = number of secant lines of A through a meeting the P^5 =
  degree of the projection of A from a point of A. Double point formula: S.S = 6 H^2 + 3 H.K + K^2 - e + 2 delta
  = 72 - 30 - 8 + 4 + 2 delta = 38 + 2 delta.
  Checked MOD p: L4, the projection of A from a rational point of A has degree 17 (from a general point: 18), both
  primes. So S.S = 72 and Z.Z = 72 - 216 = -144.
  Inputs of this step that nobody has checked beyond the following ARG: S has exactly delta transversal double
  points and nothing else. Two 4-planes of the family meet in exactly the line through their two common points of
  A (H3 for the tested pairs), so the scroll maps birationally onto Z and the double points of S are the 17 points
  where a secant line through a meets the P^5; three of the planes meet only at a, so no triple points; the focal
  line of the family in P^4_x is the line through a and its conjugate point on Theta_x, these lines sweep a
  surface, which a general P^5 misses, so no pinch points.
- Robustness: with degree d and delta double points, Z.Z = 3d + 2 + 2 delta - 216, and d^2/3 would need
  delta = 113 at d = 12. With delta = 17 no degree d gives a multiple of h^5.
- Lattice: -144 with degree 12 is (4 h^5 + c v_0)^2 = 48 - 48 c^2 with c^2 = 4, an integer square. That the three
  node counts, the double point count and the registry's lattice fit with c = ±2 is a consistency check in itself.
- By-product (ARG): on the cubic fourfold Y ∩ P^5 the class S - 4 h^2 is primitive in cohomology with square 24; if it
  is divisible by 2 (as S -> 2T at F_T suggests) its half has square 6, the C_18 lattice. So a general P^5-section
  of a Coble cubic would be a special cubic fourfold of discriminant 18 containing a 2-dimensional family of lines
  parametrized by the abelian surface. Not checked against the literature.

### 10.5 The cycle made explicit (MOD p)

For a rational point a of A, Z_a = union of the 4-planes through a lies in Y ∩ Q_a ∩ {G = 0} (Q_a the tangent cone,
G of degree 5: the condition that Y ∩ span(T_aA, y) contains a plane through y and a tangent line at a).
Decomposing that complete intersection did not finish (`h5`, `h5b`: 10 and 15 minutes; nothing obtained).
Sampling instead (`h5c_cycle_sampling.m2`, pre-registered after a 30-direction trial): for random rational tangent
directions the fibre meets a random P^4 in 12 points, of which 2 lie on 4-planes inside Y (tested by "the tangent
space of the fibre lies in Y"). The Hilbert function of the sampled points of Z_a ∩ P^4 is

    14, 29, 47, 59, 71, 83, 95   in degrees 2..8   (254 points at 32003; 236 points at 31991),

that is 12 d - 1 from degree 4 on: a curve of degree 12 and arithmetic genus 2. So deg Z_Theta = 12 and its curve
sections have genus 2, as the Chern class count c_1 = -6 Theta of section 6 says (GRR, redone by hand this session).

### 10.6 Orders 2 and 3 along the explicit arc (MOD p; previous agent's engine, unchanged)

At a point of F_T take x(t) = x + t dx, lam fixed, a(t) = -h_lam(x + t dx)/(27(1+lam^3)) = t a1 + t^2 a2 + t^3 a3,
and the same w-part. Then F_t = F + tA + t^2 g2 + t^3 g3 exactly, with A = M_dx + a1 h_lam(z), g2 = a2 h_lam(z),
g3 = a3 h_lam(z). With pi, psi, psi3 the periods of [V] of pole order 6, 7, 8 (so_t6/solib.m2, so3_t6/o3lib.m2),
the Hodge condition for the flat class reads, for all 364 cubic monomials Q:

    E2:  pi(Q g2) = 3 psi(Q A^2)            E3:  pi(Q g3) = 6 psi(Q A g2) - 7 psi3(Q A^3).

The previous agent tested solvability of these for some g2, g3. Here g2 and g3 are prescribed.

| Run | Result | Controls |
| --- | --- | --- |
| E2, dx transversal to F_T, 32003 seed 1 | holds for all 364 Q (165 non-zero on each side) | a2 -> 2 a2 fails; a2 -> 0 fails |
| E2, dx tangent to F_T (a1 = 0), 31991 seed 2 | holds for all 364 Q | both fail |
| E3, dx transversal, 32003 seed 1 (36 min) | holds for all 364 Q (165 non-zero on each side) | a3 -> 2 a3 fails; a3 -> 0 fails |
| E2, dx transversal, 31991 seed 2 | holds for all 364 Q | both fail |
| E3, dx transversal, 31991 seed 2 (36 min) | holds for all 364 Q (165 non-zero on each side) | a3 -> 2 a3 fails; a3 -> 0 fails |

So the relation 27(1+lam^3) a + h_lam(x) = 0 is right to third order in x at the tested points, not only its
gradient. Finite order: evidence, not proof.

### 10.7 Independent check

Blind check BC-COBLE-2 (a separate agent; it was given the definitions and the statements, not the scripts, logs or
this note; its own Macaulay2 and Python code and its unedited report are in `tenfold_coble/blind_check2/`). All MOD
32003 and 31991.

| Item | Verdict | Runs |
| --- | --- | --- |
| 72 nodes: reduced points; Jacobian degree 72 on P^10, all on the P^8 | PASS | 4 full, 1 partial |
| quartics through the 72 points: 71; control 36 | PASS | 5 |
| F_T: 76 = 4 + 72 points, quartics 75 = 4 + 71 | PASS | 4 |
| two 4-planes: a line; length 2 on A; rank 6; isotropic 5-planes meeting in a P^3 (sigma and sigma^2) | PASS | 7 |
| F_T: Hilbert function (1,9,33,57,42,12,1,0) | PASS | 4 M2 + 1 Python |
| 18 nodes / quadrics 17; 36 points / cubics 35; Y ∩ P^5 smooth; projection degree 17 against 18 | PASS | 4 |
| blow-up formula, signs for m = 3, 4, 5 | re-derived, correct; extra test on linear spaces | by hand |
| ladder for V; "local class 0 at the plane nodes" | arithmetic correct; the assumption checked by computation | 2 x 3 trials |
| c_1 = -6 theta (GRR), double point arithmetic, -144 | correct (GRR two ways) | by hand |
| argument A | sound; shorter justification of step 3 supplied | by hand |
| E2 at order 2, all 364 Q, own implementation of psi | PASS; the ratio 3 psi(Q A^2)/pi(Q h_lam(z)) equals a2 for all 165 Q without w; 2 a2 and 0 fail | 5 instances |

Its objections, all accepted:
1. One statement I gave it was false: the Hilbert function of k[z,p,q]/(dF, Phi) at a general member is
   (1,9,33,57,39,9,1,0), not (1,9,33,57,42,12,1,0). That was my slip in the brief (I copied the F_T numbers);
   section 5 and the registry have 39, 9, and nothing in this section uses those two values, only that degree 6
   is 1 and degree 7 is 0, which the checker confirms in both cases.
2. Degree 12 and square -144 are shared by 2[V] and 8 h^5 - 2[V]: a consistency statement, not an identification
   (10.1 says ±).
3. The 17 double points with no other singularity of S, the birationality of the scroll onto Z, and the passage
   from the tested pair of planes to a general pair were inputs, not results. The ARG for them was added to 10.3
   and 10.4 after its report; it has not been checked by anyone.
Not covered by the blind check: the sampled degree 12 of 10.5 (run after the brief was written), E3 at order 3
(repeated by me at a second prime with the same engine, not re-implemented), and the lattice value [V]^2 = -36.

### 10.8 Not established, and how this could still be wrong

- Arguments A and B are paper arguments by an AI, not read by a mathematician. The steps most in need of a human
  eye: the sign and the local terms of the blow-up formula; that the hyperplane sections at the three levels have
  no singularities other than the nodes counted (computed at the top level only: Jacobian degree 72; at the lower
  levels the points were counted, 36 and 18, and for the sixfold level the Jacobian degree 18); that S has exactly
  delta ordinary double points and no other singularity; the hypotheses of the bouquet theorem in A.3.
- The inputs are MOD p at two primes, a few seeds. The abelian-surface structure rests on section 5 and LIT
  (Beauville; Benedetti-Manivel-Tanturri, arXiv:1904.10848, abstract read: A is the Fano variety of the P^4's and
  each P^4 cuts A in a theta divisor).
- The sign of c (2[V] or 8h^5 - 2[V]) was not determined.
- E2, E3: MOD p, finite order; the engine's characterisation of psi, psi3 is the previous agent's (ARG there).
- That W# equals the registry's W at the Fermat point (Movasati's pair of 5-planes) is still ARG, as in section 7.
- K1, K3 of section 4 are still unproved. They are no longer needed for the conclusion.

## 11. A control on a known case: the coefficient +1 and a K3 surface (25 Nov 2026, late evening)

Question asked by the owner: what next. Proposal: the same mechanism with a K3 surface in place of the abelian
surface. Before running I read the registry and found that the family I had in mind is already there:
"X ∩ P^8 is a Pfaffian cubic sevenfold" is, on tenfolds, the locus of the coefficient lambda_0 = +1
(D-TENFOLD-LAMBDA0-CHECK: codim 38 = 39 - 1; D-LAMBDA1-PFAFFIAN-AND-SCROLL and D-PFAFFIAN-LAMBDA1 on sixfolds and
eightfolds; Kloosterman, arXiv:2312.12363, Prop. 6.4, Cor. 6.5: quintic del Pezzo k-folds of class
h^k + [P1] + [P2]). So nothing here is a new family, and its codimension was not re-tested. The run became a
positive control: does the node picture of section 10, and its ladder, reproduce a lattice that is known
independently? Pre-registration: `tenfold_coble/PREREG_k3.md`; scripts `pf1_section.m2`, `pf2_cycles.m2`. All MOD p
(32003 seed 1; 31991 seed 2).

Setting: M a 6x6 skew matrix of linear forms in 9 variables, Y = {Pf(M) = 0} in P^8.

| Test | Result |
| --- | --- |
| Q1 singular locus | S = {4x4 Pfaffians = 0}: degree 14, Hilbert polynomial 7n^2 + 2 (a K3 surface of genus 8, LIT); sat(Jacobian ideal) = I_S; Hessian of rank 6 on all of S |
| Q2 nodes | 56 reduced points, Hilbert function 9, 28, 47, 55, 56 (one relation on quartics); Jacobian scheme on P^10 of degree 56, all on the P^8 (31991 seed 2); 28 points with 27 on cubics; Y ∩ P^6 has 14 nodes with 13 on quadrics; Y ∩ P^5 smooth |
| Q3 algebra | k[y]/(Jac, Phi) has Hilbert function (1, 9, 33, 57, 27, 9, 1, 0): degree 6 is one-dimensional, as for the Coble cubic; k[y]/(I_S, Phi) has (1, 9, 27, 38, 27, 9, 1); pairing rank 38, kernel (I_S + Phi)_3; dim (I_S)_3 = 100 |
| Q4 cycles | Z' (five 4x4 Pfaffians of a 5x5 block; the quintic del Pezzo 5-fold): degree 5. Z (kernel of M meets a fixed 3-space): degree 7, ideal 3 quadrics + 1 cubic. Both contain S. Z ∪ Z' = Y ∩ {Pf_0123 = Pf_0124 = 0}, a complete intersection of degree 12 |
| Q5 rulings at a point of S | all four 5-folds (two of each kind) are smooth there, tangent spaces contain T_pS and are isotropic; Z, Z_2 in one ruling (intersection P^3), Z', Z'_2 in the same ruling as each other (P^3), Z against Z' in different rulings (P^4 or P^2) |
| Q6 on the cubic fourfold Y ∩ P^5 | D.D_2 = 13 (the known value for quintic del Pezzo surfaces on a Pfaffian cubic fourfold), sigma.sigma_2 = 21, sigma.D = 7 (lengths of proper intersections) |

All as pre-registered. One thing I had wrong and corrected during the run: the 3x3 minors of the 6x3 block define Z
only as a set (that scheme does not contain F; F^2 is in it); the reduced ideal is the residual of Z' in the
complete intersection.

What follows.
- (EXACT argument, degrees MOD p) Degrees 5 and 7 are not divisible by 3 and h^5 is not divisible in H^10(X, Z)
  (h^5.h^5 = 3), so neither class is a rational multiple of h^5. No ladder needed for that.
- (ARG, arithmetic) The ladder of 10.4 with node counts 14, 28, 56 and local classes +1 for Z, -1 for Z':
      Z'.Z' = 13 - 14 + 28 - 56 = -29,   Z.Z = 21 - 42 = -21,   Z.Z' = 7 + 14 - 28 + 56 = 49.
  The registry's formula for linear cycles (D-INTERSECTION-NUMBERS: P.P = -21, P1.P2 = 3 for 5-planes meeting in a
  plane) gives, for [Z'] = h^5 + P1 + P2 and [Z] = 3h^5 - P1 - P2: -29, -21 and 49. They agree. This is the
  second known lattice the ladder reproduces (the first was [V]^2 = -36), now with both rulings and a mixed product.
- So on cubic tenfolds the two coefficients that have an extra component show the same picture:

  | coefficient | P^8-section | singular surface | nodes of a hyperplane section | codimension | cycle |
  | --- | --- | --- | --- | --- | --- |
  | +1 (the general rule) | Pfaffian cubic | K3, degree 14 | 56, one relation | 38 | quintic del Pezzo 5-fold (Kloosterman) |
  | -1 (the lead W) | Coble cubic | abelian, degree 18 | 72, one relation | 54 | 4-planes over a theta curve (section 10) |

  14 and 18 are also the discriminants attached to (1,1) and (1,-1) in D-CONE-DICTIONARY, and the P^5-sections are
  cubic fourfolds of discriminant 14 (LIT) and, by 10.4, 18 (ARG). That the surface is exactly "K = 0" in both
  cases is what makes the one relation among the nodes.
- Not shown: that these are the only two. A natural question for a mathematician: which surfaces with K = 0 in P^8
  are the singular locus of a cubic sevenfold with rank-6 Hessian along them.

Independent check: blind check BC-PFAFF (a separate agent, definitions and statements only; its code and unedited
report are in `tenfold_coble/blind_check3/`). MOD p, 2 to 4 runs per item: all of Q1-Q6 PASS, and by hand the
indivisibility of h^5, the lattice numbers from Chern classes, and the ladder formula (re-derived a second time),
with -29, -21, 49 on both sides. Its caveats, all accepted:
1. Z and Z_2 are singular along a curve of degree 6 that meets S in 9 points, so they are smooth at points of S
   only away from those 9. For random Psi the 56 nodes avoid them (it computed this).
2. Local classes were computed at rational points of S and extended to the nodes by continuity; self-intersections
   were computed as Z.Z_2 and Z'.Z'_2, which uses that members of one family are homologous. Neither was computed.
3. Equal numbers show equal Gram matrices; they do not by themselves identify the classes.
4. A smooth tenfold with the 56-nodal section was not constructed (Bertini argument only). Everything is MOD p.

## 12. One member written down over QQ, with a certificate (25 Nov 2026, night)

Aim: a named smooth cubic tenfold, off F_T and off the cone loci, on which the node picture of section 10 is
established over QQ rather than MOD p. Pre-registration with the specialization arguments:
`tenfold_coble/exact_member/PREREG_exact.md`; equation and scripts in the same folder.

The member (x = (4,3,3), lam = 3, the member section 5 already treats over QQ; quadrics by a fixed rule, first
candidate accepted). With h(a,b,c) = a^3 + b^3 + c^3 + 9abc and M = sum x_{i-j} z_{i+j} p_i q_j:

    F8   = -221 h(z) + 378 h(p) + 378 h(q) + 378 M
    Phi0 = 2 z_0 p_0 + z_1 p_1 + 2 z_0 p_2 - p_2^2 - 2 p_0^2 - 2 z_1 z_2
    Phi1 = -p_1 p_2 - 2 q_0 q_2 - 2 q_0^2 + 2 z_1 p_1 - p_1 q_0 - 2 q_1^2
    Phi2 = 2 z_1 q_2 - 2 p_0 q_0 + p_2 q_1 + z_0 p_1 - p_1 q_2 + 2 p_2^2
    F    = F8 + w_0 Phi0 + w_1 Phi1 + w_2 Phi2 + w_0^3 + w_1^3 + w_2^3

X = {F = 0}, X' = X ∩ {w_2 = 0}, Sigma = {dF8 = 0, Phi0 = Phi1 = 0} in the P^8.

| Item | Result | How it holds over QQ |
| --- | --- | --- |
| X1: X is smooth | no singular point mod 32003, 31991, 30011 (the Jacobian quotient has Hilbert function binomial(12,d)); same after a random change of coordinates | MOD p + specialization: a projective scheme over Z_(p) with empty special fibre has empty generic fibre |
| X2: Sigma is 72 distinct points | dimension 0, degree 72; its projection to a fixed line is a squarefree form of degree 72 | EXACT (computed over QQ) |
| X3: Sing(X') = Sigma, all ordinary double points | mod p the Jacobian scheme of F restricted to w_2 = 0 has dimension 0 and length 72, all on the P^8 (three primes; two engines at 32003) | MOD p + specialization: over QQ the length is at most 72; it contains Sigma, of length 72; so it is Sigma, reduced, Tjurina number 1 at each point |
| X4: the 72 points impose exactly 71 conditions on quartics | saturated ideal of Sigma has Hilbert function 1, 9, 34, 63, 71, 72, 72 | EXACT (computed over QQ; also via the colon ideal) |
| X5: Phi2 has no zero on Sigma | empty | EXACT (computed over QQ) |
| the singular surface of X ∩ P^8 | degree 18, Hilbert polynomial 9n^2, ideal 9 quadrics + 3 cubics | EXACT |
| first order at this X | k[y]/(dF8, Phi) has Hilbert function (1, 9, 33, 57, 39, 9, 1, 0); pairing rank 54 | EXACT |

What this gives (ARG + LIT, not computed): X' is a cubic 9-fold with exactly 72 nodes and defect 1, so its tenth
Betti number is 2 (Dimca's formula, LIT); the extra class is of type (5,5) and maps injectively to H^10(X)
(10.3, step 3). So this X, a smooth cubic tenfold with rational coefficients, has a rational Hodge class that is
not a multiple of h^5, with first-order Hodge locus of codimension 54. By section 10 that class is the class of an
algebraic cycle (ARG); nothing here is "a Hodge class not known to be algebraic".

Practical note: the 12-variable smoothness check did not finish with Macaulay2's default Groebner engine (40
minutes, and 10 with a Hilbert-driven run). With the F4 engine (`groebnerBasis(..., Strategy => "F4")`) it takes
7 seconds; on the 11-variable problem both engines agree (3 minutes against 1 second).

Independent check: blind check BC-EXACT (a separate agent, the equation and the statements only; its code and
unedited report are in `tenfold_coble/blind_check4/`). All computed items PASS with the same numbers: the QQ items
by its own routes (the 72 distinct points through the characteristic polynomial of a 72x72 rational matrix; the
rank 54 through exact multiplication matrices), the two mod p items at the same three primes with F4, a second
F4-type engine, mathicgb's classic engine for the node count, and random changes of coordinates. The default
engine did not finish for it either. It accepted both specialization arguments. Its remarks, all taken in:
1. The 72 nodes form a single Galois orbit (the degree-72 form is irreducible over QQ): none is a rational point.
2. X5 is the same statement as "X is smooth at the nodes of X'", not an independent input.
3. The injectivity step (10.3, step 3) skipped two things, both true here: near infinity the pair (total space,
   divisor at infinity) is a product because f_2 != 0 at the nodes, and the affine critical points are isolated
   (it counted 2048 - 72 = 1976 at one prime, none on f = 0). It recommends citing instead Dimca-Paunescu,
   "On the connectivity of complex affine hypersurfaces II" (arXiv:math/9906064), which by its account gives that
   X - X' is 9-connected directly. LIT: I confirmed the paper and its abstract by search; I did not read the theorem.
4. The exact statement number of Dimca's formula in the 1990 paper is still to be supplied (its copy was garbled).

## 13. The Fermat tenfold (26 Nov 2026): a correction, a small theorem, and explicit arcs with no free terms

Pre-registration, written before the runs and kept as written (three parts, each before its runs):
`tenfold_coble/fermat_point/PREREG_fermat.md`. Scripts and logs: `tenfold_coble/fermat_point/`. Labels as in the
rest of this note. Nothing here is a statement about the Hodge conjecture.

Coordinates of the Fermat cubic tenfold X_0 = {F_0 = 0}: r_k = x_(2k), y_k = x_(2k+1), p_i = x_(6+2i),
q_i = x_(7+2i) (k, i mod 3). The three 5-planes P_zeta = {r_k + y_k = 0, p_i = zeta q_i} (zeta^3 = -1) pairwise meet
in the same P^2. Movasati's class is delta = [P_zeta] - [P_zeta']. The **three-plane class** is
kappa = h^5 - [P_z1] - [P_z2] - [P_z3]. M_x = sum_{i,j} x_(i-j) y_(i+j) p_i q_j.

### 13.0 What came out

1. CORRECTION. The explicit arc of the Coble family through the Fermat tenfold carries the three-plane class kappa,
   not Movasati's class delta. Its direction is not tangent to the Hodge locus of delta (EXACT). Everything below
   is about kappa. For Movasati's class nothing new is shown: that the registry's W for delta is the Coble family
   stays ARG, and no explicit arc for delta is known (13.5).
2. (EXACT, by hand; checked EXACT at one rational point) The tenfolds X_x: F_0 + M_x(y,p,q) = 0, x in C^3, lie in
   the Coble family: each has 27 P^8-sections that are Coble cubics.
3. (PROVED, AI, unreviewed; two EXACT computations) On every smooth X_x the class kappa stays a Hodge class. The
   reason is special to this symmetric family and does not use section 10. It is NOT a test of section 10.
4. (MOD p, two primes, finite order) A test of section 10 that can fail: explicit arcs of the Coble family through
   X_0 with no symmetry and no free terms, moving all three moduli of the Coble cubic and generic quadrics off the
   P^8. All 221 period equations of kappa vanish to order 12 (one arc), 11 (three arcs) and 10 (two arcs) at two primes, and to orders 8 and 6 on
   two denser arcs.
   Changing any one ingredient of the relation that defines the Coble cubics makes the arc fail, at the order
   predicted in advance (4, 5 and 7). Finite order: evidence, not proof.
5. NOT established: anything about delta; that kappa is Hodge on the whole Coble family (finite order only, outside
   the symmetric family); algebraicity beyond section 10.

### 13.1 The correction (EXACT, by hand and by computation)

The planned check was "the cubic arc F_0 + t M_xi - t^3 (sum xi^3 / 27) h_0(z) of the family, in the order-12 Fermat
engine, for Movasati's class".
- Rescaling the vertex coordinates turns that arc into the line F_0 + tau M_xi; the sections of X_x by
  {r_k = -theta_k y_k}, theta_k^3 = 1 + h_0(x)/27, are the normal form of section 5 with lam = 0 and
  a = 1 - theta^3 = -h_0(x)/27. `b_membership.m2`: EXACT over QQ at x = (3,15,18), theta = 7 (a = -342), and
  MOD 32003 at three random x: the section equals the normal form, and its singular locus is a surface of degree 18
  with Hilbert polynomial 9 n^2, cut out by 9 quadrics.
- Which class. On the cone h_0(x) = 0 the tenfold contains V = J(Pi, T_x), and for x a flex the scroll T_x is the
  residual of the three disjoint planes {q = c p} in a Segre threefold section of the Fermat fourfold, so
  [T] = 3 h^2 - Pa - Pb - Pc and [V] - 2 h^5 = kappa (EXACT, by hand; ARG for the continuation to all x).
- kappa and delta are different markings of the same cone: on X_0 kappa is supported on 16 torus eigenclasses and
  delta on 48 (`fp_main.py classes`; automorphisms of X_0 permute eigenclasses), so no automorphism carries one to
  the other. First order: M_x is tangent to the Hodge locus of kappa (no term at all at order 1) and not to that of
  P1 - P2, P1 - P3, P2 - P3, P1, P1 + P2 (non-zero modulo p, hence non-zero). (Blind check 5, EXACT with x symbolic: M_x is
  tangent to the Hodge locus of delta exactly on the plane x_1 + x_2 = 0.)
- Correction to section 5 (the line on the determinant): on a tenfold with a determinantal P^8-section the two
  5-planes of Movasati's configuration belong to one connected family, so their difference is zero in homology
  there. That line is not evidence that the family is the registry's W at Movasati's point, and is withdrawn.

### 13.2 The symmetric family: the first test had no teeth

Step C of the pre-registration: S(Q, n) = Psi_kappa(Q M_x^n), the order-n period equations along F_0 + tau M_x.
`fp_main.py exact 15`: zero for all n <= 15 and all 221 forms Q, identically in x (EXACT, integers; at n = 15:
44118 terms in 115 cells). Controls: one coefficient of M_x changed: fails at order 2; one eigen-sign of kappa
flipped: fails at order 2.
Control K4 (`fp_diag.py`): the family has three reflection symmetries that change the sign of the class
functional; every cell is forced to vanish by one of them, except those with Q = p_0 p_1 p_2 or q_0 q_1 q_2
(n = 6: 2 cells, n = 9: 6, n = 12: 12; there positive part = negative part > 0, e.g. 1013088384000 at n = 12).
And those vanish for the reason in 13.3. So this test could not have failed for a reason related to section 10.
Recorded as it happened: it is the reason for 13.5.

### 13.3 A theorem on the symmetric family (PROVED, AI, unreviewed)

**Statement.** For every x such that X_x is smooth, and every path from 0, the flat transport of kappa to X_x is a
Hodge class, not a multiple of h^5.

Inputs (EXACT):
- (I1) `t_invariants.py`. Gamma' = the group generated by sh (shift of indices), c, b (diagonal, cube roots of
  unity), iota ((index -> -index) and p <-> q); it has order 162, preserves F_x for every x and permutes the
  three planes. Its invariants on the Jacobian ring of F_0 twisted by the determinant (the action on Q Omega) have
  dimensions 0, 1, 10, 1, 0 in degrees 0, 3, 6, 9, 12: the invariant part of H^10 has Hodge numbers
  (0, 1, 10, 1, 0), and its (6,4) part is spanned by (P - Q) Omega / F^5, P = p_0 p_1 p_2, Q = q_0 q_1 q_2.
- (I2) `t_ks_grid.py`. (P - Q) m_d lies in the Jacobian ideal of G_x = h_0(y) + h_0(p) + h_0(q) + M_x for generic x,
  d = 0, 1, 2 (m_d = dM_x/dx_d). Proof without Groebner bases: 30 explicit elements of the Jacobian ideal, linear in
  x; at all 5456 integer points x >= 0, |x| <= 30 the integer matrix [30 columns | target] has rank <= 30, and the
  30 columns have rank 30 at (1,1,1); a minor is a polynomial of degree <= 30 in x, so it vanishes identically.
  Controls: (P + Q) m_d is not in the ideal; P - Q is not. (A Groebner basis over QQ(x) did not finish in 25
  minutes; `t_ks.m2` is kept for the record.)

Proof. U = {x : X_x smooth} is connected. By Griffiths, F^6 H^10(X_x) = (S_0 + S_3/J_3) Omega as a representation of
Gamma'; the dimension of its invariant part is constant on U and equals 1 at x = 0 (I1). Where P - Q is not in the
Jacobian ideal (an open dense connected set containing 0) the invariant part is the line L_x spanned by
omega_x = Res((P - Q) Omega / F_x^5). The derivative of omega_x in the direction x_d is
Res(-5 (P - Q) m_d Omega / F_x^6); by (I2) (which extends from generic x to all of U, since membership in a
subbundle of constant rank is a closed condition) it lies in F^6, and it is Gamma'-invariant, so it lies in L_x.
So L is a flat line bundle, and f(x) = <kappa(x), omega_x> satisfies df = a f. f(0) = 0 because kappa is a Hodge
class on X_0. Hence f = 0, first on the dense set and then on U. Since kappa(x) is Gamma'-invariant and the pairing
is invariant, kappa(x) is orthogonal to all of F^6. A rational class orthogonal to F^6 lies in F^5 and in its
conjugate, so it is of type (5,5). qed.

Remarks. (a) The invariant part is a Hodge structure of K3 type, (1, 10, 1) up to a shift, with constant period on
this family. (b) All classes: `fp_main.py classes55`: the combinations of the 924 eigenclasses of type (5,5) on X_0
that stay of type (5,5) along F_0 + tau M_x, identically in x, form a space of dimension 220, stable from order 4 to
order 12 (MOD p, two primes; finite order); it contains the 8-dimensional span of the 27 classes kappa_theta.
What the other classes are is OPEN and was not looked at. (c) The theorem says nothing about tenfolds outside the
3-parameter family, and it does not use the Coble cubic.
(d) From the blind review of this proof (all eight of its points are fillable; the ones that change the text):
P - Q is not in the Jacobian ideal for ANY x (the nine variables have distinct weights under the diagonal
symmetries), so omega_x is nowhere zero and the restriction to a dense set is not needed; (I2) must be a
function-field identity, which it is; the action is the determinant-twisted one and F^6 is filtered, so "as a
representation" uses complete reducibility; and the argument uses nothing about kappa except invariance, so it
gives the same conclusion for every Gamma'-invariant rational Hodge class of X_0 (a 10-dimensional space).
The checker also found a closed form: (P - Q) m_d = -(x_d/3) sum_{i-j=d} y_(i+j)^2 (p_(i+1) p_(i+2) q_j^2 -
p_i^2 q_(j+1) q_(j+2)) modulo the Jacobian ideal (confirmed by it at 19 points; not used here).

### 13.4 Arcs of the Coble family with no symmetry (MOD p, finite order)

Every cubic F = (a tenfold whose section by the P^8 {r_k = -theta y_k} is a Coble cubic in normal form)
+ sum_k (r_k + theta y_k) phi_k, phi_k any quadrics, is in the Coble family. With lam = lam_1 tau, x = tau xi,
a = -h_lam(x) / (27 (1 + lam^3)), theta^3 = 1 - a, theta(0) = 1:

    F_tau = F_0 + 3 lam (P + Q) + 3 a lam Y + M_x + sum_k (r_k + theta y_k) tau phi_k,       Y = y_0 y_1 y_2.

Its section by {r_k = -theta y_k} is a h_lam(y) + h_lam(p) + h_lam(q) + M_x (EXACT, by hand; checked numerically in
the script). Random xi, lam_1 and sparse random quadrics phi_k; the arc has no symmetry and no free term. H is the
case lam_1 = 0, H' the general case. Engine: `tooling/fermat_series` (previous agent), changed only in its table of
plane coefficients (`fp_engine.py`).

Gate (must pass before anything is read; it did). The engine was written for arcs in the squarefree slice.
(i) On arcs F_0(g_tau x), g_tau explicit polynomial coordinate changes (not in the slice), all period equations
vanish to order 5 for delta and for kappa (3 seeds); with the signs flipped they fail at order 3. (ii) On the arc
of H the engine agrees with a separate dictionary implementation on all 221 equations, orders 1..5, non-zero values
included.

| arc | terms of T_1 | seeds | primes | orders with all 221 equations zero |
|---|---|---|---|---|
| H (lam = 0) | 21 | 1 | 67108837, 67108819 | 1..12 |
| H (lam = 0) | 21 | 2, 3 | both | 1..11 |
| H, denser quadrics | 33 | 4 | both | 1..8 |
| H' (lam moving) | 23 | 1 | both | 1..11 |
| H' (lam moving) | 22-23 | 2, 3 | both | 1..10 |
| H', denser quadrics | 47 | 5 | 67108837 | 1..6 |

(The largest run: 110,762,513 terms at order 12.) Controls, same at every seed and prime:

| change to the arc | predicted | first failing order |
|---|---|---|
| theta = 1 (H) | 4 | 4 |
| sign of h_0(xi) flipped in theta (H) | 4 | 4 |
| quadrics multiplied into r_k + 2 y_k (wrong P^8) | 1 | 1 |
| term 3 a lam Y left out (H') | 4 | 4 |
| h_0(x) in place of h_lam(x) in a (H') | 5 | 5 |
| factor (1 + lam^3) left out of a (H') | 7 | 7 |
| class P1 - P2 or P1 - P3 in place of kappa | - | 1 |
| one eigen-sign of kappa flipped | - | 2 |

So the vanishing depends on each part of the relation 27 (1 + lam^3) a + h_lam(x) = 0 (the Burkhardt quartic of
section 5), on the right P^8 and on the right class.

Which classes survive (`fp_engine.py kernel`; found by the blind checker, then replicated here). Take all 924
eigenclasses of type (5,5) of X_0 at once. The combinations whose period equations vanish along the arc H' to
order n form a space of dimension 704, 484, 264, 44, 1 for n = 1..5 (MOD p; seeds 1 and 2; two primes at seed 1),
and the 1-dimensional space is the line of kappa. So the arc determines its class: up to a factor, kappa is the
only class of the Fermat tenfold that survives to order 5. (My first run of this replication dropped a factor
3^(-m) that is common on the symmetric family but not on these arcs; it gave 0 at order 5 and was corrected; the
log is kept.)

Caveats. (i) The gate with coordinate changes passes for ANY class (blind checker's remark), so it validates the
series, the reduction and the signs outside the squarefree slice, not the table of the class. The table is fixed
by the first-order test (only one of the three roots on the pairs (r_k, y_k) passes for the P^8 {r_k = -y_k}) and,
independently, by the checker, who pinned the period polynomial of each plane exactly. (ii) On the plane
x_1 + x_2 = 0 each single plane class persists along the symmetric family (checker, to order 12), so a test with
such xi would say little; the random xi used here are not on it (the controls with delta fail at order 1).

What this is: finite-order evidence, MOD p, that near X_0 the Coble family lies in the Hodge locus of kappa, on arcs
that explore the moduli of the Coble cubic and the quadrics phi_k. It is the same kind of evidence as the
registry's arcs for Movasati's class (order 12, O-TENFOLD-CONE-LEAD), with two differences: these arcs are explicit
members of a named family, and nothing is solved for (no correction terms).
What it is not: a proof; a test of the whole family (the arcs end at the cone point lam = 0, x = 0 and the
sections have a fixed form up to the quadrics phi_k, which were sparse); a statement about delta.

### 13.5 Where this leaves Movasati's class and the lead

- Both delta and kappa mark the cone over the Fermat fourfold as a point of the C_18 cone locus (the lattices
  <h^2, P1' - P2'> and <h^2, h^2 - Pa - Pb - Pc> have discriminant 18). ARG: the marked family of C_18 fourfolds is
  irreducible (LIT: Hassett; not re-read), so both are limits of the same family and the closure of the Coble
  family has a branch at each. For kappa the branch is explicit (this section). For delta it is not: the limit
  there is degenerate (the tangent directions found by the previous agent, the two Segre cones, are nets of
  reducible quadrics), and I did not find the arc.
- So the registry's lead (O-TENFOLD-CONE-LEAD, the component W for delta at lambda = -1) is in the same state as
  after section 12: explained if section 10 holds and if the branch at delta is the Coble family (ARG). New here:
  the twin class kappa at the same tenfold, where the same family is explicit and passes a test that can fail.
- What would close it for delta: an explicit arc of the Coble family ending at the Fermat cone with the marking
  delta, run through the same engine. OPEN.

### 13.6 Independent check

Blind check 5 (26 Nov 2026; a separate agent given the statements only, not the code or the numbers; its own two
period engines, numpy MOD p and python-flint EXACT over QQ, and its unedited report:
leads/tenfold_coble/blind_check5/). Its answers agree with every item:
first order: kappa yes, identically in x; delta no for general x (EXACT, x symbolic; it adds: tangent for delta
exactly when x_1 + x_2 = 0). Membership at x = (3,15,18): yes, a = -342, surface of degree 18, 9 n^2 (EXACT).
The group: order 162, invariants 0, 1, 10, 1, 0, degree 3 spanned by P - Q (EXACT, two methods). The identity
(P - Q) dM/dx_d in the Jacobian ideal: EXACT over QQ(x) by its own determinant-grid proof (36 x 36 block, 37^3
points), at 7 rational points and over QQ(s) on a line; (P + Q) dM/dx_d not; P - Q not in the ideal for any x.
The proof on the symmetric family: judged sound, with eight points that each need a sentence (all taken into
section 13.3); it notes the argument gives the same for every invariant rational Hodge class (a 10-dimensional
space). Symmetric family: zero identically in x to order 18 (EXACT). The arc with no symmetry, with its own random
data: all period equations of kappa vanish to order 10 (2 data sets), 9 (2), 8 (4), each at two primes
(2147483629, 2147483587), and EXACTLY over QQ to order 7 (1 data set) and 6 (1). Variants, without being told the
orders: no term 3 a lam Y: fails at 4; h_0 in place of h_lam: 5; no factor 1 + lam^3: 7; theta = 1: 4; delta in
place of kappa: 1. Found by it and then replicated here: among all 924 eigenclasses the combinations that survive
along the arc to order n have dimension 704, 484, 264, 44, 1 for n = 1..5, and the last is the line of kappa.
Its caveats: a coordinate-change arc passes for ANY class, so that gate validates the reduction and the signs, not
the period polynomial of a plane (it pinned that separately, exactly); on the plane x_1 + x_2 = 0 each single plane
class persists, so tests there are uninformative; orders n = 1 mod 3 of the symmetric test are empty sums. Not
checked by it: the closed period formula and Griffiths' description (taken from the literature); orders above 10;
algebraicity of the transported class. Disclosure by it: it saw file names under leads/ in a directory listing and
opened none.

### 13.7 Tool

The node count of sections 10-12 (singular points of a hyperplane section, ordinary double points, relations on
forms of the right degree) is packaged in `tooling/node_section/` with seven regression cases, among them the
member of section 12 (72 / 71 / 1) and a Pfaffian section as in section 11 (56 / 55 / 1). It returns a labelled
count, not a statement about Hodge classes (registry M-NODE-SECTION-TOOL).

## 14. The class of the cycle by one intersection count (26 Nov 2026)

Pre-registration, written before the runs and kept as written: `tenfold_coble/plane_test/PREREG_plane.md`.
Script and logs: `tenfold_coble/plane_test/`. MOD p. Nothing here is a statement about the Hodge conjecture.

### 14.0 What came out

1. (MOD p; two primes, two seeds, two kinds of 4-plane: 8 runs) In a smooth cubic tenfold X of the Coble family
   that contains a 5-plane Lambda, the 4-plane cycle Z_a and Lambda meet transversally in exactly **8** points.
   If [Z_a] were a multiple of h^5 the number would be 4 (deg Z_a = 12). So [Z_a] is not a multiple of h^5.
2. This does not use section 10 (no local classes at nodes, no ladder). What it uses: the count, the degree 12 of
   Z_a, and the textbook fact that a transversal intersection computes the intersection number. The number 8 was
   predicted in writing before the run (14.2).
3. NOT done: characteristic 0 (a lifting argument, ARG, in 14.4; no exact run); a human reading.

### 14.1 Setup

Y = Coble cubic in P^8 (normal form, random lam and x), A = Sing(Y), a = a point of A, Z_a = the union of the
4-planes of Y through a (dimension 5, degree 12: 10.5). P' = another 4-plane of Y, not through a; pi = a plane in
P'. X = F_Y + sum_k w_k Phi_k with Phi_k in (ideal of pi)(linear forms): X n {w = 0} = Y, and X contains the 5-plane
Lambda = {y in pi, w free}. Lambda n Z_a = pi n Z_a, because Z_a lies in the P^8.

If [Z_a] = c h^5 then 12 = Z_a . h^5 = 3c, so c = 4 and Lambda . Z_a = 4 (Lambda . h^5 = 1).

### 14.2 The prediction (ARG, written before computing)

Two 4-planes P', P'' of Y meet in the secant line of the theta curve A n P' through its two points on A n P''.
So P' n Z_a is the ruled surface of these secants for P'' through a. The pairs of points form a curve B in the
symmetric square of the genus-2 sextic A n P'; B meets "pairs containing a given point" in 2 and the diagonal in 8
(Riemann-Hurwitz on the incidence curve, of genus 7), and the secants meeting a codimension-2 plane form the class
6 x - delta/2. Degree of the surface: 6 * 2 - 8/2 = 8.

### 14.3 The computation (`pl1_count.m2`)

Z_a is a component of Y n {Q_a = G = 0} (Q_a the tangent cone of Y at a, G a quintic; as in `h5c_cycle_sampling.m2`).
A point y of that complete intersection lies on Z_a if and only if the fibre through y of the pencil of the
construction is, near y, a 4-plane contained in Y through a (the test of `h5c`); at a smooth point of the complete
intersection this decides which component passes through y.

| what | result, the same in all 8 runs |
|---|---|
| {Q_a = G = 0} in P' | a surface of degree 10 |
| its section by a random P^3 of P' | a curve of degree 8 and arithmetic genus 8, and two lines (over ZZ/p in 6 runs, conjugate over GF(p^2) in 2); all multiplicities 1 |
| the curve of degree 8, at 3 rational points | smooth points of Y n Q_a n G, on a 4-plane of Y through a: in Z_a |
| the two lines, at 3 points each (over GF(p^2) where needed) | smooth points of Y n Q_a n G, NOT on Z_a |
| an explicit plane pi in that P^3: pi n Z_a | 8 points, reduced |
| at all 8 points (ideal computation, so non-rational points included) | Y n Q_a n G is smooth; the tangent space of Z_a meets pi only in the point |
| the 2 points of pi on the lines | not on Z_a |
| X | contains Lambda, X n {w = 0} = Y, smooth (F4, 12 variables) |

Runs: p = 32003 and 31991, seeds 1 and 2, with P' = the explicit 4-plane through the odd eigenspace of iota
(mode B) and with P' = a 4-plane through a second random point of A (mode G). N = 8 in all.
(A first version of the script tried to decompose the surface in P^4 and did not finish in 10 minutes; it was
replaced by the section by a P^3 before any result was seen. The first complete version checked transversality
only at the rational points of pi; the final one checks all 8 points. Logs of both are kept.)

### 14.4 What follows, and what is still an argument

- (MOD p) On X: Lambda and Z_a have complementary dimension, meet in 8 points, and at each point Z_a is smooth with
  T Z_a n T Lambda = 0 (T Lambda n T P^8 = T pi and T Z_a lies in T P^8). So Lambda . Z_a = 8, not 4, and [Z_a] is
  not a multiple of h^5 on X.
- Z_a is the same subvariety in every tenfold X' with X' n {w = 0} = Y. The smooth ones form a connected family
  (the complement of a hypersurface in an affine space), and the class of a fixed subvariety is locally constant.
  So [Z_a] is not a multiple of h^5 on any of them, in particular on those that contain no 5-plane.
- Consistent with section 10: there [Z_a] = 4 h^5 + c v_0 with c = +-2, so Lambda . Z_a - 4 = c (Lambda . v_0) must
  be even; it is 4.
- Characteristic 0 (ARG): take integer lam, x; a and P' are smooth points of A and of the Fano surface of 4-planes
  mod p, so they lift to the p-adic integers (Hensel), and so do pi and X; Z_a and Lambda are flat over the p-adic
  integers and intersection numbers are constant in flat families. Not written out in detail, and not replaced by
  a computation over a number field.
- The degree 12 of Z_a is from 10.5 (Chern class count; sampled at two primes); it was not recomputed here. The
  conclusion needs only deg Z_a different from 24.
- With section 5 (first order: the class functional supported on the P^8 is unique, and its Hodge locus has the
  tangent space of the family, codimension 54) this gives outcome (a) of the handoff at the level MOD p + the
  lifting argument: an explicit algebraic 5-cycle with class not a multiple of h^5 on the codimension-54 family
  that contains F_T as a divisor.

### 14.5 Why the node tool is not a route to the main target (ARG)

Asked to "continue on the most logical path", I first looked at using `tooling/node_section` to search for new
classes. Count by Cayley-Bacharach: if a P^(10-s)-section of a cubic tenfold is singular along a smooth S of
dimension s, a general hyperplane through it has nodes at S n (s quadrics), and they fail to impose independent
conditions on quartics by h^0(K_S + (2s - 4) h). For a surface (s = 2) the defect is the geometric genus p_g(S):
1 for the K3 surface of section 11 and 1 for the abelian surface, as computed. But in that case the secant variety
of S has dimension 5 and lies in the cubic, hence in the tenfold: a candidate algebraic cycle comes for free. For
s = 3 the threefold must have a deficient secant variety, which forces the determinantal families already in the
registry. So a search with the tool would list loci that come with a visible cycle; it would not produce "a Hodge
class not known to be algebraic". Not tested: whether the secant variety carries the class in the two known cases.

### 14.6 Independent check (BC-PLANE, blind check 6)

A separate agent, given the statement and the definitions only (no code, no repository). Its own Macaulay2 and Python
code and its unedited report are in `tenfold_coble/blind_check6/`. MOD p at 4 primes (32003, 30011, 20011, 10007),
6 instances, 5 different cubics.

It AGREES on every item:

- deg Z_a = 12, three ways: 110 sampled 4-planes through a per instance cut by a P^5 give a curve of degree 12 and
  arithmetic genus 2; a direct count of the 4-planes through a that meet a random P^3; its own class computation
  on A x A.
- N = 8 for all 24 planes pi it tried, decided two ways: the incidence scheme {(y, P)} has dimension 0, degree 8 and
  is reduced; and for every root, including the conjugate ones over F_(p^k), it constructs the 4-plane through a and
  the point by linear algebra and verifies that it lies in Y.
- Transversality at all 192 points.
- P' n P'' is a line through the two common points of the two sextics, in every pair tested (14.2).
- The identities for X; X smooth for 16 random X and for one explicit X over QQ (EXACT, lam = 2, x = (1,2,5)).

It adds: the 4-planes through a form a geometrically irreducible double cover of the line of tangent directions with
6 branch points (genus 2), so Z_a is irreducible; Z_a is double along the cone over A with vertex a (pi misses it);
a class in the span of h^5 and Lambda with pairings 12 and 8 would have self-intersection 189/4, so [Z_a] is not in
that span either.

Its caveats, all accepted:

1. Everything is MOD p, while classes and connectedness are used over C.
2. Charts are random, not a covering: a point outside a chart would be missed with probability about 1/p.
3. Only sampled a and pi. A proof needs one fully certified triple (a, pi, X) in characteristic 0.
4. The degree needs a proof; the argument is insensitive to it (it would "conclude" from any degree other than 24).
5. On X itself the statement is weak, because Lambda is already not a multiple of h^5. The content is for the members
   of the family that contain no 5-plane, reached by the deformation step of 14.4.
6. Special parameters must be avoided (below).

Its pitfall: in a fully generic Grassmannian chart the count of 4-planes through a returns 14; two of the points have
dependent spanning vectors. Saturating by the 5 x 5 minors gives 12.

Its finding on special parameters (EXACT over QQ, a scan of 1220 parameter points): Sing(Y) has degree 18 + 3k when
[x] lies on k flex tangents of the Hesse cubic h_lam = 0; the rational ones are x_i + x_j = lam x_k. This explains
an exact attempt of mine at lam = 3, x = (4,3,5) (4 + 5 = 3 * 3): the singular locus had degree 21, with Hilbert
polynomial that of the abelian surface plus three planes. That member must not be used; the attempt was dropped.

Its suggestion for characteristic 0: Hensel lifting of a, then specialisation: the characteristic-0 cycle
specialises to m [Z_a mod p], so the degree and the intersection number become 12 m and 8 m and the ratio 2/3
survives for any m; or a computation over a number field that contains a point of A.
