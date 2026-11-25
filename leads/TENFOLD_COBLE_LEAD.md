# Cubic tenfold lead W: a candidate explanation by Coble cubics

Written 25 Nov 2026 by Claude (Fable 5.2) for Timothy Seifert, taking over from `leads/TENFOLD_HANDOFF.md`.
Everything here is AI-generated and unreviewed by any mathematician. Labels: EXACT / MOD p / PROVED (AI, unreviewed) /
ARG (paper argument, not checked line by line) / LIT (literature; said whether read) / OPEN. Finite-order statements
are evidence, not proof. Nothing here is a statement about the Hodge conjecture; if this note is right, the class in
question is algebraic on the whole family.

## 0. Verdict in six lines (items 4-6 rewritten the evening of 25 Nov 2026; see section 10)

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
