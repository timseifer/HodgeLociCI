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
> 26 Nov 2026, owner's question: section 15. Why +1 goes with a K3 surface and -1 with an abelian surface: one
> relation among the nodes exactly when K_S = 0, discriminant = 2 x (number of nodes) = 8 deg(S), and deg(S) =
> 18 - 2 chi(O_S). Arguments by an AI with MOD p support; the blind checker's limits are in 15.8.
> 26 Nov 2026, later (owner: go ahead on the open point of 15.5): section 16. The eightfold Coble rung lies in the
> closure of l Q + det A + det B, by an explicit degeneration; a hyperplane section of a Coble cubic is a difference
> of two determinants with equal trace and second coefficient (an exact identity over a finite field at random
> instances; the general statement and the closure statement are arguments). A new lead on tenfolds in 16.8.

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

## 15. The K3 / abelian pairing (coefficient +1 / coefficient -1): explained, not a coincidence (26 Nov 2026)

Question of the owner (after an observation of another agent, registry D-TENFOLD-PFAFFIAN-K3 (c)): on tenfolds the
coefficient +1 goes with a K3 surface (Pfaffian section) and -1 with an abelian surface (Coble section). Is that a
coincidence, a conjecture worth stating, or provable? Pre-registration, written before the runs and kept as written:
`tenfold_coble/pairing/PREREG_pairing.md`. Scripts and logs: `tenfold_coble/pairing/`. Computations are MOD p (two
primes). Nothing here is a statement about the Hodge conjecture: every class in this section is algebraic.

### 15.0 What came out

1. **Not a coincidence: the discriminant of the class is forced by the Euler characteristic of the surface.**
   Three steps:
   - one relation among the nodes exists exactly when K_S = 0: it is the residue theorem for the holomorphic 2-form
     of S (15.2; ARG, tested on K3, abelian, Enriques);
   - the discriminant of the class of a smooth 5-fold through S is -8 deg(S) (15.1; a Chern class identity, PROVED
     by an AI, unreviewed);
   - in P^8, deg(S) = 18 - 2 chi(O_S) (Riemann-Roch): K3 14, abelian 18; and in the two-plane lattice 14 is the
     discriminant of P1 + P2 only and 18 that of P1 - P2 only (15.3; EXACT arithmetic).
   What this gives, precisely (the blind checker insisted on this, rightly): the DISCRIMINANT is forced. That the
   Pfaffian and Coble families carry classes of the two-plane lattice at all is from earlier entries
   (D-TENFOLD-PFAFFIAN-K3, D-TENFOLD-COBLE-FAMILY), not from this section. For the K3 surface a smooth 5-fold through
   S exists (a hyperplane section of G(2,5)), so the identity applies as proved. For the abelian surface we know no
   smooth one: -144 is the value already in the registry and the identity explains it only through its extension
   to cycles with local classes (ARG). No new conjecture is needed for the pairing.
2. **Torsion canonical class.** By a 2026 paper (15.6) a surface that is the singular scheme of a cubic in P^8 has
   2 K_S = 0. Enriques surfaces do occur: degree 16, the pencil det X + c det Y of two symmetric determinants
   (MOD p; 15.4). They give 64 nodes and NO relation, so this construction gives no class (it says nothing about
   other Hodge classes of those tenfolds); 16 could not be a discriminant anyway. The bielliptic surface we could
   write down (degree 18, K of order 2, both line bundles of its numerical type) is not the singular locus of any
   cubic (MOD p).
3. **Sixfolds and eightfolds.** +1 is "K3-type" on every rung: linear sections of G(2,6) (K3 surface, canonical curve
   of genus 8, 14 points), nodes 56 / 28 / 14. For -1 the nodes are 72 / 36 / 18; on eightfolds the registry's family
   l Q + det A + det B has its 36 nodes at the intersection of two Segre fourfolds, and the sections of the abelian
   surface give 36 nodes as well, with a tangent codimension (25) that is compatible with lying in the closure of
   that family (codimension 26) but does not show it (15.5).
4. A by-product that replaces the ladder of section 10 and the cone dictionary in one line: **discriminant = (+-) 2 x
   (number of nodes on the cycle)** (15.1).

### 15.1 The identity (T1; PROVED by an AI, unreviewed)

X in P^(2k+1) a smooth cubic 2k-fold, H a hyperplane, V = X n H with equation f in H = P^(2k), Sigma in V a smooth
k-fold of degree m. Then df|_Sigma is a section of N^v_(Sigma/H)(3) whose zeros are the singular points of V on Sigma.
If there are finitely many, of total length N:

        3 (Sigma.Sigma)_X - m^2 = (-1)^k 2 N.

Proof. Put n_i = c_i(N_(Sigma/H)). From 0 -> N_(Sigma/H) -> N_(Sigma/P) -> O(1) -> 0 and
0 -> N_(Sigma/X) -> N_(Sigma/P) -> O(3) -> 0 (X is smooth along Sigma): c(N_(Sigma/X)) = c(N_(Sigma/H)) (1+h)/(1+3h),
and (1+h)/(1+3h) = 1 - 2 sum_(j>=1) (-3)^(j-1) h^j. So
(Sigma.Sigma)_X = c_k(N_(Sigma/X)) = n_k - 2 sum_(j>=1) (-3)^(j-1) n_(k-j) h^j.
The number of zeros is N = c_k(N^v(3h)) = sum_i (-1)^i n_i (3h)^(k-i), so (-1)^k N = n_k + sum_(j>=1) (-3)^j n_(k-j) h^j.
Eliminating the sum: 3 (Sigma.Sigma)_X = n_k + 2 (-1)^k N, and n_k = c_k(N_(Sigma/H)) = (Sigma.Sigma) in P^(2k) = m^2. QED

Known lattices it reproduces (by hand): plane in a fourfold, 4 nodes, disc 8; cubic scroll, 6 nodes, 12; P^3 in a
sixfold, 8 nodes, -16; P^5 in a tenfold, 32 nodes, -64; quintic del Pezzo 5-fold in the Pfaffian tenfold, 56
nodes, -112.

Direct counts (`pr4_identity.m2`, MOD 32003 and 31991; the singular points of a random cubic through Sigma, on Sigma;
the self-intersections come from known lattices, not from Chern classes):

| Sigma | k | nodes counted | predicted from the lattice |
|---|---|---|---|
| P^2 x P^2 in P^8 | 4 | 36, reduced | 36 (Sigma.Sigma = 36, D-SEGRE-FOURFOLD) |
| G(2,5) n P^6 | 3 | 14, reduced | 14 (class h^3 + P1 + P2, square -1) |
| P^1 x P^2 in a hyperplane of P^6 | 3 | 12, reduced | 12 (cone over a cubic scroll, disc -24) |
| projected Veronese surface in P^4 | 2 | 10, reduced | 10 (square 12, degree 4; the Segre cubic) |
| P^3 in P^6 | 3 | 8, reduced | 8 |

Consequences.
- Tenfolds, X n P^8 singular along a surface S, Sigma a smooth 5-fold in Y through S: every node of a hyperplane
  section through the P^8 lies on S, N = 4 deg(S), so disc = -8 deg(S).
- With the cone dictionary (disc = (-2)^(k-2) d): on a cubic 2k-fold the nodal hyperplane section carrying a class of
  "fourfold discriminant" d has 2^(k-3) d nodes on the cycle: d/2 on fourfolds (C_8: 4, C_12: 6), d on sixfolds,
  2d on eightfolds, 4d on tenfolds.
- (ARG) For a cycle that is singular at the nodes the same holds with N replaced by the sum of the squares of its
  local classes (the ladder step of section 10 plus the cone degeneration V(y, t s) -> cone over V n {s = 0}); the
  cycle Z_a of section 14 has local class 2 and disc -576 = -2 * 4 * 72.
- The ladder of section 10 is this identity applied on each rung; its alternating signs are the (-1)^k.

### 15.2 One relation exactly when K_S = 0 (T2, T3; ARG)

Y in P^8 a cubic sevenfold whose singular scheme is a smooth surface S; X a smooth tenfold with X n P^8 = Y.

T2 (Cayley-Bacharach). The nodes are Z = S n {two quadrics}. From the Koszul complex on S,
0 -> O_S -> O_S(2h)^2 -> I_Z(4h) -> 0, and Kodaira vanishing for 2h (K_S numerically trivial):
h^1(I_(Z/S)(4h)) = h^2(O_S) = p_g(S). If S is 4-normal this is the number of relations among the nodes on quartics.

T3. LIT (15.6): the normal bundle N of S carries a nowhere degenerate quadratic form with values in O(3); so
(det N)^2 = O(18) and, since det N = O(9) + K_S, 2 K_S = 0. ARG: the two families of isotropic 3-spaces of the form
are exchanged along loops by the double cover of S attached to the 2-torsion bundle det N (-9h) = K_S. A 5-fold Z in
Y through S, smooth at the general point of S, has T Z / T S isotropic, so it selects one family everywhere; it can
exist only if K_S = 0. Both statements say the same thing from two sides: K3 and abelian (p_g = 1, K = 0) give one
relation and a cycle; Enriques and bielliptic (p_g = 0, K of order 2) give none.

Tested: K3 56 nodes / 55 conditions; abelian 72 / 71; Enriques 64 / 64 (15.4).

The relation itself (ARG from a classical theorem; LIT: the global residue theorem, Griffiths-Harris, chapter 5).
Let Psi_1, Psi_2 be the two quadrics cutting the nodes on S and omega a holomorphic 2-form on S. For a quartic P the
meromorphic form P omega / (Psi_1 Psi_2) has poles on the two curves {Psi_i = 0} only, so the sum of its residues
vanishes:

        sum over the nodes p of  P(p) omega(p) / Jac(Psi_1, Psi_2)(p)  =  0     for every quartic P.

If K_S = 0, omega has no zeros and this is the one relation. If K_S is of order 2 there is no omega; the residue
theorem then gives a relation only against sections of K_S + 4h, which are not cut by quartics of P^8. That is the
whole difference between K3 / abelian and Enriques / bielliptic.

A second form of the same theorem, due to the blind checker (ARG, classical): if the nodes of V lie on a smooth
k-fold Sigma in V as in 15.1, then K_Sigma + det(N^v(3)) = O(k - 1), and the residue theorem for the section df of
N^v(3) gives sum of R(p) / Jac(df)(p) = 0 for every form R of degree k - 1. So every smooth cycle through the nodes
produces a relation among them, with no surface S needed (this covers l Q + Pf, det A + det B and linear spaces).

"Sign pattern" (R6, `pr6_signs.m2`; pre-registered in section 6 of the pre-registration; MOD p, two primes).
At a node the determinant D of the affine Hessian of the hyperplane section is
(discriminant of the normal quadratic form) x Jac(Psi)^2, and the two square roots of the first factor are the two
families of isotropic 3-spaces. Prediction: the relation is sum of +- P(p) / sqrt(D(p)), that is, writing the
relation as Tr(g .) on the coordinate ring of the node scheme, g^2 D is constant. Computed in all seven cases with
one relation (sixfolds: Pfaffian 14 nodes, Coble rung 18; eightfolds: Pfaffian rung 28, Coble rung 36,
det A + det B 36; tenfolds: Pfaffian 56, Coble 72): g^2 D is a nonzero constant, at both primes. Control: with a
principal minor in place of D it is not constant (degree N - 1 in the generator). So the relation selects one
square root of the Hessian at every node, i.e. one family of isotropic spaces along S; for a surface with
K_S of order 2 no such selection exists globally (T3). This is a consistency check of the mechanism, not the proof
that the Enriques surface has no relation: that is T2 or 15.4.

### 15.3 The sign (T4, T5)

T4 (Riemann-Roch). S linearly normal, spanning P^8, K_S numerically trivial: 9 = chi(O_S) + deg(S)/2, so
deg(S) = 18 - 2 chi(O_S): K3 14, Enriques 16, abelian 18, bielliptic 18.

T5 (EXACT). In <h^5, P1, P2> (P.P = -21, P1.P2 = 3): disc <h^5, a h^5 + r P1 + s P2> = -8 (8 r^2 - 2 r s + 8 s^2).
8 r^2 - 2 r s + 8 s^2 = 14 only for (r, s) = +-(1, 1); = 18 only for +-(1, -1). And 3 Sigma.Sigma - m^2 is 0 or 2
mod 3, while -8 * 16 is 1 mod 3: no class has "discriminant 16".

Together with 15.1: chi(O_S) = 2 gives -112, the discriminant of P1 + P2; chi(O_S) = 0 gives -144, that of
P1 - P2.

What this does and does not say.
- It identifies the discriminant of <h^5, class>, for the class of a 5-fold through S to which 15.1 applies
  (regularly embedded, smooth at the nodes). K3: the five 4 x 4 Pfaffians of a 5 x 5 principal block cut a hyperplane
  section of G(2,5), smooth for general data, containing S and lying in Y; so -112 follows from 15.1. Abelian: no
  such smooth 5-fold is known to us (Z_a is double along a cone); -144 is the registry's value
  (D-TENFOLD-COBLE-CYCLE-CLASS) and 15.1 accounts for it only through the ARG extension with local classes.
- It does not show that the families meet the two-plane locus, nor which class of that discriminant occurs; inside
  <h^5, P1, P2> the discriminant fixes the class only up to sign and multiples of h^5 (for that: sections 5, 11, 13).
  "The Euler characteristic chooses the sign" is a statement about deg(S) = 18 - 2 chi(O_S), no more.
- For the Enriques surface the congruence and T3 say the same thing twice; the reason there is no relation is T2
  (p_g = 0), or the classical argument of 15.4.

### 15.4 Enriques and bielliptic surfaces (MOD p)

Enriques (`pr2_enriques.m2`, p = 32003 and 31991). X, Y symmetric 3 x 3 matrices of coordinates on P^11, a general
P^8, S = {rank X <= 1, rank Y <= 1} n P^8: the quotient of the K3 surface {q_i(x) + q'_i(y) = 0, i = 1, 2, 3} in
P^5 by (x, y) -> (x, -y), embedded by the nine invariant quadrics.
- S has degree 16, Hilbert function 8 n^2 + 1 from n = 0 on (projectively normal); the K3 cover is smooth and the
  involution has no fixed point, so S is smooth (ARG: the map to the join of the two Veronese surfaces is etale).
- The cubics containing S: 92. The cubics singular along S: exactly 2, det X and det Y. (The count
  165 - chi(O_S(3)) - chi(N^v(3)) = 165 - 73 - 90 = 2 predicted this.)
- For random c the saturation of the Jacobian ideal of det X + c det Y is the ideal of S: the singular scheme is S.
- A smooth tenfold through it: 64 ordinary double points on a hyperplane section through the P^8, Hilbert function
  1, 9, 31, 55, 64: they impose 64 conditions on quartics. Defect 0.
So cubic sevenfolds singular along an Enriques surface exist, with 2 K_S = 0 as the literature requires, and carry
no relation. All four predictions of the pre-registration held.

Why there is no relation here, by a classical theorem (R7, `pr7_enriques_twisted.m2`; section 7 of the
pre-registration). On the K3 cover in P^5 the preimage of the 64 nodes is a complete intersection of type
(2,2,2,4,4), 128 points. Cayley-Bacharach: exactly one relation on forms of degree 2+2+2+4+4-6 = 8,
sum of P(p) / J(p) = 0 with J the Jacobian determinant. The equations are invariant under (x, y) -> (x, -y) and that
involution has determinant -1, so J is anti-invariant: the relation is identically zero on invariant octics (which
contain the pull-backs of the quartics of P^8) and is a genuine relation on the anti-invariant ones (the sections of
K_S + 4h). Computed, both primes: the 128 points have Hilbert function 127 in degree 8; invariant octics have rank 64
on them, anti-invariant octics rank 63, pull-backs of quartics rank 64. As predicted. So for this surface the missing
relation is not an accident of a count: it lives in the twisted system, exactly as 15.2 says.

Bielliptic (`pr3_bielliptic.m2`, same primes). E: v^2 = u^4 + al u^2 + be with tau(u,v) = (-u,-v); F: w^2 = g(s) with
sigma(s,w) = (s,-w); S = (E x F)/<(tau, sigma)>, K_S of order 2; embedding by the nine invariant sections of
O_E(6 points) x O_F(3 points) (type (3,3); very ample by Mella-Palleschi, as quoted in arXiv:2607.18918, Prop. 1.9).
- Degree 18, Hilbert function 9 n^2 for n >= 1, 9 quadrics, 84 cubics (interpolated through 420 points and checked
  to vanish identically on E x F).
- Cubics singular along S: 0. Controls of the same routine: K3 surface 1 (the Pfaffian), abelian surface 1 (the
  Coble cubic).
So this bielliptic surface is not the singular locus of a cubic. Not examined: the other components of the Picard
scheme with the same numerical type, the bielliptic type with group Z/2 x Z/2, abelian surfaces of type (1,9).

### 15.5 Sixfolds and eightfolds (MOD p)

Node counts with `tooling/node_section` (`pr1_rungs.m2`, p = 32003 and 31991; every X checked smooth):

| rung | coefficient | description | nodes | conditions | defect |
|---|---|---|---|---|---|
| sixfold | +1 | l Q + Pf(M), section l = 0 | 14 | 13 on quadrics | 1 |
| eightfold | +1 | X n P^7 Pfaffian, singular along a canonical curve of genus 8; hyperplane through the P^7 | 28 | 27 on cubics | 1 |
| sixfold | -1 | hyperplane section = Coble n P^6 | 18 | 17 on quadrics | 1 |
| eightfold | -1 | X n P^7 = Coble n P^7, singular along a curve of degree 18, genus 10 | 36 | 35 on cubics | 1 |
| eightfold | -1 | l Q + det A + det B (D-EIGHTFOLD-FAMILY-TD), section l = 0 | 36 | 35 on cubics | 1 |

All as predicted (nodes = 2^(k-3) d). In the last row the 36 nodes are exactly the scheme where the two Segre
fourfolds {rank A <= 1}, {rank B <= 1} meet (6 x 6 points).

The class as a functional (`pr5_tangent.m2`; added after the first runs, pre-registered in section 5 of the
pre-registration). ARG: for F = f + s Q, nodes Z of {f = 0}, one relation rho on forms of degree e = k - 1, the
class is the functional delta(P) = rho(P / Q) on forms of degree e + 2. Corrected after the blind check: "delta
kills s and the Jacobian ideal", which is what I first wrote as the justification, is true but far from enough
(in the first row below such functionals form a space of dimension 14). What characterises delta is that it kills
the saturated ideal I_Z of the nodes and Q: its kernel is (I_Z + (Q)) in degree k + 1, of codimension 1. That the
Hodge class kills I_Z (deformations keeping the nodes keep the class) is an argument, not a proof, in the cases
where the nodes fail to impose independent conditions on cubics. The checker's code reproduces the known
annihilator of a P^3 in a sixfold this way. The Hilbert function of the Gorenstein algebra S/I of delta, and
dim (S/I)_3 = tangent codimension of the Hodge locus:

| case | Hilbert function | degree 3 | known value |
|---|---|---|---|
| sixfold +1, l Q + Pf | 1, 7, 12, 7, 1 | 7 | 7 (registry) |
| eightfold +1, Pfaffian rung | 1, 8, 19, 19, 8, 1 | 19 | 19 (codim NL(1)) |
| eightfold -1, l Q + det A + det B | 1, 9, 26, 26, 9, 1 | 26 | 26 (registry) |
| tenfold +1, Pfaffian | 1, 9, 27, 38, 27, 9, 1 | 38 | 38 (registry) |
| tenfold -1, Coble | 1, 9, 33, 54, 33, 9, 1 | 54 | 54 (registry) |
| sixfold -1, Coble rung | 1, 7, 16, 7, 1 | 7 | new |
| eightfold -1, Coble rung | 1, 8, 25, 25, 8, 1 | 25 | new |

The five controls reproduce the known values, at both primes. Reading of the two new rows:
- Eightfolds: at a member of the Coble rung the Hodge locus of the class has tangent codimension 25, less than 26,
  the codimension of {l Q + det A + det B}. The rung family itself has codimension 29 by a parameter count, so it
  is not a component: the locus through it is larger (or non-reduced). 25 < 26 does NOT put the rung outside the
  closure of {l Q + det A + det B}: tangent spaces can only grow under specialisation, and the whole Hilbert
  function of the rung is termwise at most that of the family (1,8,25,25,8,1 against 1,9,26,26,9,1), with the same
  36 nodes and discriminant 72, which is what a specialisation requires. Either the rung lies in that closure and
  the Hodge locus is singular or non-reduced along it, or there is a component of codimension 25 through it.
  Deciding needs the dimension of the locus, not a tangent space. Open.
- Sixfolds: tangent codimension 7 at the Coble rung, as for every coefficient in D-CUBIC-SIXFOLD-DETC; the rung
  family has codimension 11 by a parameter count (more than h^(4,2) = 8, the largest codimension a Hodge locus of
  sixfolds can have), so the Hodge locus there is larger than the rung family.
- These two rows are also the only ones without a dimension cross-check of the functional.
- Observation (computed, no explanation offered): the length of the Gorenstein algebra is the absolute value of the
  discriminant, 2 x (number of nodes), for the Pfaffian rungs and for l Q + det A + det B (28, 56, 112; 72), and 4
  less for the Coble rungs (32, 68, 140 against 36, 72, 144).

Answer to "is -1 a degenerate-Coble (Segre) picture and +1 K3-type": +1 is K3-type on all three rungs, and there
the family is the whole Hodge locus to first order. For -1 the generic eightfold member is a two-Segre picture (36 =
6 x 6); the sections of the abelian surface give the same count and may be a special case of it. On sixfolds the
generic member of {det A + det B} has no nodal hyperplane section to look at; only the Coble rung does.

### 15.6 Literature (machine-read 26 Nov 2026; finite search)

- Piroddi, Rios Ortiz, Rojas, Song, "Coble type hypersurfaces and hyperkaehler fourfolds", arXiv:2606.10884.
  Definition 2.1 (a hypersurface whose singular scheme is X); Prop. 2.2 (nondegenerate quadratic form on the normal
  bundle); Cor. 2.3 (2 K_X = (d(N-n) - 2(N+1)) H; K-trivial X can only have Coble cubics in P^(3n+2)); Table 1 lists,
  for surfaces and cubics in P^8, exactly G(2,6) n P^8 (K3) and the abelian surfaces of Coble; Example 2.9: for
  A = E1 x E2 the Coble cubic degenerates to the determinantal cubic along the Segre P^2 x P^2. So the pairing
  "K3 of genus 8 and abelian (3,3) are the K-trivial surfaces with a Coble type cubic in P^8" is in the literature.
  Not found there (first 100 000 characters and the last part read by machine): Enriques or bielliptic surfaces, the
  double cover of the two families of isotropic spaces, nodes of linear sections, Hodge classes, discriminants of
  cubic fourfolds.
- Benedetti, Bolognesi, Faenzi, Manivel: "The Coble quadric" (Forum Math. Sigma 12 (2024) e63, arXiv:2307.05993) and
  "Goepel varieties" (arXiv:2506.22030): Coble type hypersurfaces in homogeneous spaces from graded Lie algebras
  (Jordan-Vinberg theory); the cubic case is the three-forms in nine variables. Abstracts and contents read; nothing
  found there on K3 surfaces, Pfaffian cubics, cubic fourfolds, linear sections or Hodge classes.
- Benedetti, Manivel, Tanturri, arXiv:1904.10848; Gruson, Sam, arXiv:1301.5276 (Remark 3.16: the Jacobian ideal of
  the Coble cubic is not radical in their normal form; degenerations of (3,3) abelian surfaces).
- Addington, Hassett, Tschinkel, Varilly-Alvarado, arXiv:1606.05321: the general cubic fourfold of discriminant 18
  contains an elliptic ruled surface.
- Not found: the identity of 15.1 in this generality (for cubic fourfolds, "six nodes on a hyperplane section means
  C_12 or C_8" is in the literature, e.g. as recalled in Marquand-Viktorova, arXiv:2601.20778); the Enriques pencil
  det X + c det Y as a family of cubic sevenfolds. Neither is claimed as new.

### 15.7 What is not shown

- A human reading of 15.1-15.3. T2 and T3 are arguments; T1 is a short proof by an AI.
- A smooth (or regularly embedded) 5-fold through the abelian surface inside the Coble cubic, so that 15.1 applies
  there without the extension.
- That this construction is the only source of Hodge classes on the tenfolds with an Enriques section.
- Characteristic 0 for any computation of this section.
- The classification: that the Pfaffian, Coble and det X + c det Y cubics are the only cubic sevenfolds in P^8 whose
  singular scheme is a smooth surface. Open cases named in 15.4.
- That the Coble rungs lie in the closure of the registry's -1 families on sixfolds and eightfolds.
- That the functional of 15.5 is the Hodge class (it passes five controls).

### 15.8 Independent check (BC-PAIRING, blind check 7)

A separate agent, given the statements and constructions only (no code, no repository). Its own Macaulay2 and Python
code and its unedited report are in `tenfold_coble/blind_check7/`. MOD 32003 and 31991, some items also 30011.

Every number it recomputed came out as stated:

- T1: derivation redone, sign right; node counts for a plane (4), a cubic scroll (6), P^3 (8), P^1 x P^2 (12),
  G(2,5) n P^6 (14), P^2 x P^2 (36), P^4 in P^8 (16), all reduced. It notes that for three of them the
  self-intersection comes from the same normal-bundle calculus, so only the plane, the scroll and the linear
  spaces test the identity independently.
- T2: K3 56 / 55, Coble 72 / 71, Enriques 64 / 64, each also on an actual tenfold section.
- T3: the theory is right (det N = O(9) + K_S; the cover of the two families; isotropy). Its own test, one prime:
  a square root of the discriminant of the normal form exists as a cubic on the Pfaffian K3; for the Enriques
  surface it exists only on the K3 cover and is anti-invariant. (It discloses a first version with special
  coordinate minors that gave a different answer, which it attributes to the special choice without verifying.)
- Enriques: all of 15.4, at two primes; the surface is arithmetically Cohen-Macaulay.
- Bielliptic: no cubic singular along it, at three primes, also for the embedding by L + K_S; by its argument
  these two are all the cases for this type. The type with group Z/2 x Z/2: not checked.
- Rungs: 14/13, 28/27, 18/17, 36/35, 36/35.
- Functional: all seven Hilbert functions of 15.5.
- R6: g^2 D constant for P^3 in a sixfold and for four of our cases, with three kinds of failing controls; the
  two tenfold cases and the eightfold Coble rung were NOT checked by it (its determinant step did not finish).
- R7: ranks 127 / 64 / 63 / 64; the parity argument is correct (it uses that the K3 is projectively normal).

Its objections, all accepted and worked into the text above:

1. The justification first given for the functional of 15.5 was insufficient (see the corrected paragraph there).
2. The Coble rungs are not components of their Hodge loci (parameter counts 11 and 29 against 7 and 25).
3. "25 < 26" does not put the rung outside the closure of l Q + det A + det B (15.5).
4. 15.3 identifies a discriminant, not a class, and only for a suitable cycle; "the coefficient is forced" was
   too strong as first written (15.0, 15.3 now say what is forced).
5. "Enriques and bielliptic give no class" must read "this construction gives no class".

Not verified by it: smoothness of the Coble surface and reducedness of its 72 nodes (our tool reports 72 ordinary
double points); the bielliptic Hilbert polynomial beyond five values (our Groebner computation gives 9 n^2).
Not covered by anyone: abelian surfaces of type (1,9), surfaces that are not linearly normal.

## 16. Is the eightfold Coble rung in the closure of l Q + det A + det B? Yes; and what a Coble section is (26 Nov 2026)

Asked in 15.5 and left open there; the owner said "go ahead", and later "continue on this line". Pre-registered in
`leads/tenfold_coble/pairing/PREREG_pairing.md`, sections 8-15; scripts `pr8` ... `pr16` in the same folder.
Nothing in this section is a statement about the Hodge conjecture: it identifies one family of cubics with part of
the boundary of another. All classes that occur are classes of algebraic cycles.

Notation. V_0 = G(u) + t Psi(u, t) is a cubic sevenfold in P^8 whose hyperplane section t = 0 is a Coble section
G = (Coble cubic) n P^7, singular along the curve C = A n P^7 (degree 18, genus 10). V_0 has 36 nodes, C n {Psi = 0},
with one relation on cubics. These are the hyperplane sections, through the P^7, of the eightfolds of the Coble rung
(15.5 (d)). sigma = closure of {det A + det B} in the cubics of P^8 (dimension 130 as a cone).

### 16.0 The answer

1. (MOD p; an exact identity over F_(p^2) at two random instances, p = 32003 and p = 31991; verified from the
   matrices alone)
   A hyperplane section G of a Coble cubic is a difference of two determinants whose characteristic polynomials
   differ only in the constant term:
        det(tau + A) - det(tau + B) = c G,       tr A = tr B,    s_2(A) = s_2(B),
   A, B 3 x 3 matrices of linear forms on P^7 (s_2 = sum of the principal 2 x 2 minors). Equivalently
   G(M) = det(M) - det(sM) on P(sl_3) = P^7 for an isometry s of the form tr(XY), and the curve C is the set of M
   for which M and sM have the same double eigenvalue, each with a two-dimensional eigenspace.
2. (ARG, elementary, on top of 1) So the cone over G is itself a sum of two determinants, det(t + A) - det(t + B),
   and every V_0 = G + t Psi is the limit as e -> 0 of the sums of two determinants
        [ det(t + e A(e)) - det(t + e B(e)) ] / e^3.
   Hence V_0 lies in sigma, and the eightfolds of the Coble rung lie in the closure of l Q + det A + det B. The
   answer to the question is yes.
3. (MOD p, two primes) Before the identity was found, every necessary condition tested held: no second-order
   obstruction to keeping the 36 nodes, formal arcs unobstructed to order 6 (to order 10 in one direction), and at
   the generic point of such an arc the 18 quadrics through the nodes carry a 2-dimensional algebra, as for
   det A + det B.
4. (MOD p, two primes; ARG for the shape) The first-order Hodge locus at a rung member (codimension 25) is spanned
   by the deformations keeping the nodes of two members of the pencil; the tangent cone of "eightfolds with a
   36-nodal section" there is (rung) x (cone over P^1 x P^1).
5. A by-product on tenfolds (MOD p, two primes): the tenfolds l_1 Q_1 + l_2 Q_2 + det A + det B form a family of
   codimension 52 with 72 nodes and one relation on a hyperplane section (16.8). It is not the Coble family
   (codimension 54). Recorded as a new lead, not followed here.

Passing from "two random instances modulo p" to "every Coble section" in 1 is an argument, and as I first wrote it
(two irreducible families of the same dimension with a common random point) it had a gap; the blind checker
supplied a better one, given in 16.10: near the certificate point both families are open in one smooth locus. No
statement in characteristic 0 is proved.

### 16.1 What was in the registry already

- D-EIGHTFOLD-FAMILY-TD: the family l Q + det A + det B, codimension 26, its fourfold T4.
- D-DEGENERATION-ALONG-ARC (team T2, cubic sixfolds): along an arc into their divisor D the 18 quadrics split into
  two determinantal nets, found through the algebra of endomorphisms respecting the 32 linear syzygies; both cubics
  have a pole and tend to a triple hyperplane. The test of 16.4 and the mechanism of 16.5 are the same method and
  the same phenomenon one dimension up; I found that entry only after running them (PREREG, section 15).
- N-TWO-TRACE-DESCRIPTION-OF-D (T2): the family x_H Q + det M_A - det M_B "with equal trace and equal second
  coefficient" on sixfolds, ruled out as a description of D (codimension 11, an 18-nodal hyperplane section).
  What is new here: that family is the Coble rung. Its hyperplane sections are sections of Coble cubics (16.6,
  16.7), which links the two-determinant families of the sixfold and eightfold work with the Coble family of the
  tenfold lead.

### 16.2 Tests at V_0 itself (R8-R12; MOD 32003 and 31991)

T8 (ARG, classical). ES = the germ of 36-nodal cubics at V_0; its tangent space is (I_Z)_3, of dimension 130, and
dim ES >= 129. The branch of the discriminant through the node p_i is b_i(f + e g) = e g(p_i) -
(e^2 / 2) grad g(p_i)^T H_i^(-1) grad g(p_i) + ..., so with the relation sum c_i g(p_i) = 0 the function sum c_i b_i
starts with the quadratic form h(g) = sum c_i grad g(p_i)^T H_i^(-1) grad g(p_i) on (I_Z)_3: if h is not identically
zero there, dim ES = 129.

| test | det A + det B (control) | Pfaffian rung, P^4 sevenfold (controls) | V_0 |
|---|---|---|---|
| R8: rank of h on (I_Z)_3 | 0 of 130 | 0 of 138; 0 of 150 | 0 of 130 (random functional instead of the relation: 94) |
| R9: quadrics through the nodes; rank of mu_g | 18; 0 | 25; 0 and 34; 0 | 19; 1 for general g, 0 on rung directions; the same 18 survive |
| R10: obstruction along a formal arc | 0 to order 6 | 0 to order 6 | 0 to order 6 (pr10: one direction per prime; pr13: one more per prime); to order 10 in the runs of 16.5 |
| R12: surviving quadrics L, dim L S_1, syzygies, algebra | 18, 130, 32, 2 (two Segre fourfolds) | - | 18, 117, 45, 1 |

mu_g : (I_Z)_2 -> (functions on the nodes)/(quadrics), q -> [grad q . x], x = -H^(-1) grad g the velocity of the
nodes: a quadric survives to first order iff it is in the kernel. In sigma the nodes lie on 18 quadrics, so rank
mu_g <= 1 is necessary; it holds with equality. R12 at V_0 decides nothing (pre-registered: dim L S_1 = 117 is not
130, so the argument does not apply): the splitting is not visible at the point itself.
Not done as registered: R10 was to use three general directions at order 6; the runs were stopped by the time
limit after the first. An exploratory attempt to separate sigma by Koszul flattenings gave nothing.

### 16.3 The tangent cone at a rung member (R11, R11b; MOD p, two primes)

Eightfold F = G(u) + t_1 Psi_1 + t_2 Psi_2 + ..., hyperplanes H_c: t_2 = c t_1, nodes Z_c = C n {Psi_1 + c Psi_2 = 0}.
Inside the 120 cubics in u: J_c = (I_(Z_c))_3 + Psi_2 S_1 has dimension 93 (codimension 27) for five members;
each lies in the kernel of the pairing of the class (95, codimension 25; the classes built from two members have
the same kernel); J_c + J_c' = the kernel; (I_C)_3 + Psi_1 S_1 + Psi_2 S_1 = tangent space of the rung, 91
(codimension 29). Shape (ARG, then checked): (I_(Z_c))_3 / (I_C)_3 = (Psi_1 + c Psi_2) H^0(O_C(1)), and
H^0(O_C(1)) = H^0(K_C) is two dimensions larger than the linear forms (C is not linearly normal; this is where
H^1(O_A) enters). So kernel / rung = (pencil) x N with N = H^0(K_C) / S_1, and J_c / rung = (1, c) x N: the union
over c is the cone of decomposable tensors. Check: the Pluecker vectors of the five 2-planes span a space of
dimension 3. So to first order the eightfolds with a 36-nodal section are (rung) x (cone over P^1 x P^1) near a
rung member: the image of the pairs (X, H), contracting the pencil over each rung member.

### 16.4 A nearby point (R13, R14; MOD p; method as in D-DEGENERATION-ALONG-ARC)

Argument (ARG): if V_0 is in sigma, then ES is smooth and equals sigma near V_0, every jet lifts to an arc with
general generic point, and over K = k((e)) the nodes lie on exactly 18 quadrics L with dim L S_1 = 130 and a
2-dimensional algebra Alg(L) = {phi in End(L) preserving the linear syzygies}. Lower bounds for ranks over K read
off from truncations are rigorous (rho_J = number of elementary divisors of exponent < J), so "dimension of the
algebra <= 1" would have been a certificate for "no".

| | quadrics: rho_J | L S_1: rho_J | algebra over K | leading term of a non-scalar element |
|---|---|---|---|---|
| C1: det A + det B, general point | 27 | 130 | 2 | two idempotents of rank 9 |
| C2: sum cof_ij(A) B_ij (contains one Segre fourfold; a boundary point of sigma) | 27 | 129, 130 | 2 | nilpotent of rank 9, square 0 |
| V_0, order 6 (both primes) and order 10 (32003) | 26, 27 | 117, 129, 130 | bound 19, 19, 2, then 2 up to order 8 | nilpotent of rank 1, square 0 |

C2 was predicted in advance and is a true positive control: there the two Segre fourfolds come together.

### 16.5 The mechanism (T14 of the pre-registration; pr14; MOD 32003 and 31991, order 10)

With N the trace-free non-scalar element: N^2 is a scalar and vanishes modulo e^6; N(grad F) is the gradient of a
cubic G_N at every order (a random endomorphism fails). Predicted from "N_0 has rank 1" before the run and found:
the image of N_0 is the square of a linear form l_*, which is the hyperplane t of the nodes; l_* S_1 lies in the
limit net; G_(N,0) is a multiple of t^3, G_(N,1) of t^2, G_(N,2) of t, G_(N,3) of nothing. So both determinantal
cubics tend to the triple hyperplane, and the normal form is det(t + eA) - det(t + eB), which has a finite limit
after division by e^3 iff tr and s_2 agree. In the pencil spanned by G and D_s = G_(N,3) on t = 0 the members with
an 8-dimensional Lie algebra of linear vector fields are D_s + mu G with mu^2 + 8615 = 0: the polynomial
det(Q (S_D + mu S_G)) has this factor to the power 8 (32003; the two members are conjugate over F_(p^2)). At 31991
the two members are defined over F_p, mu = +-13379: each has an 8-dimensional Lie algebra and is singular along a
threefold of degree 6 with Hilbert polynomial (n+1)^3, a hyperplane section of P^2 x P^2; their Lie algebras are
not split over F_p, so the matrices exist only over F_(p^2). The same analysis on the control C2 returns the
determinant itself as leading cubic (Lie algebra of dimension 16, singular along a fourfold of degree 6).

### 16.6 The identity (pr15, check_certificate.m2; exact over F_(p^2); p = 32003 seed 1 and p = 31991 seed 2)

From the two members: a matrix for each (through the Lie algebra sl_3 of a determinantal cubic sixfold: the
eigenforms of a split regular element are the off-diagonal entries; `detrep_lib.m2`, tested on synthetic pairs),
then constant matrices m_A, m_B with tr(M_A m_A) = tr(M_B m_B) and s_2 equal (a unique line of solutions). Result:
     det(tau + A) - det(tau + B) = c G,  c != 0,  tr A = tr B,  s_2(A) = s_2(B),
for the Coble cubic with the parameters and the hyperplane of the seed; the nine entries of tau + A are
independent, and so are those of tau + B. The files `arcdata/certificate_32003_seed1.txt` and
`arcdata/certificate_31991_seed2.txt` hold the parameters, the hyperplane and the two matrices; `check_certificate.m2` rebuilds the Coble cubic from the normal form and checks
the identity, without any of the arc computations.

### 16.7 The family det M - det sM (MOD p; synthetic, independent of the arcs)

If tr A = tr B and s_2(A) = s_2(B) and the trace-free part of A is an isomorphism onto sl_3, then B_0 = s(A_0) with
s an isometry of tr(X^2), and det(tau + A) - det(tau + B) = det(A_0) - det(s A_0): the trace drops out. For s a
product of 7 or 8 random reflections: G_s = det M - det sM is singular along a curve of degree 18 and genus 10 on
9 quadrics, the invariants of a Coble section. (One reflection: G_s is reducible, singular along a quadric of dimension 5; two: singular
along a threefold of degree 4.) The differential of (g, s) -> G_s o g has rank 75 = 64 + 11 at a random point, not 64 + 12, and its image is
(I_C)_3 (dimension 75, as for a Coble section): the family has dimension at least 75, and exactly 75 by 16.10. So
each cubic should have a one-parameter family of such representations (ARG: one for each g^2_9 on C; not checked;
the checker counts the kernel as 16 + 1 with the 1 unexplained). On P^8 the same construction gives only cones, so the Coble cubic itself is not
of this form.

### 16.8 Consequences and a by-product

Degeneration (ARG; inputs exact over F_(p^2)). For A(e) = A + e A_1 + e^2 A_2, B(e) likewise, with tr A_1 = tr B_1:
     [det(t + eA(e)) - det(t + eB(e))] / e^3  ->  c G + t (tr(B B_1) - tr(A A_1)) + t^2 (tr A_2 - tr B_2)
(c G = det A - det B, not G: corrected by the blind checker; rescale Psi). The map (A_1, B_1) -> tr(B B_1) -
tr(A A_1) has rank 44 = all quadrics in (u, t) without t^2 (computed; it uses only that the entries of A span the
linear forms in u), and the last term supplies t^2 (linear form). So every G + t Psi is a limit of sums of two
determinants, over the algebraic closure of F_p for these two G.

Tenfolds (R16; MOD p, two primes; predicted). F = l_1 Q_1 + l_2 Q_2 + det A + det B in P^11: in the P^9 the two
rank <= 1 loci meet in a curve of degree 36 and genus 37 (K = 2H); a hyperplane section through the P^9 has 72
ordinary double points imposing 71 conditions on quartics; the tangent space of the family has codimension 52 and
S / (l_1, l_2, Q_1, Q_2, I_2(A), I_2(B)) has Hilbert function 1, 10, 35, 52, 35, 10, 1. So there is a family of
codimension 52 with a class on 72 nodes (discriminant 144 by 15.1 if a smooth 5-fold through the nodes exists,
e.g. {rows 1, 2 of A proportional} n {rows 1, 2 of B proportional} in the P^9; not checked). A member of the Coble
family cannot be a limit of these with the class continuing, because its first-order Hodge locus has codimension
54 (EXACT, D-TENFOLD-COBLE-EXACT-MEMBER). So on tenfolds the two families differ, unlike on eightfolds. Not computed: the class
itself, whether it lies in the orbit of P1 - P2, and how this family meets V_Z, F_T or the Fermat point.

### 16.9 What is not established

- Characteristic 0, and more than the two instances run. The identity is exact over a finite field there; "every
  Coble section" rests on the dimension argument of 16.0.
- That a general cubic det M - det sM is a Coble section (the converse inclusion) is the same argument read
  backwards; no direct check (for instance an abelian surface through the curve).
- The step from V_0 in sigma to "the eightfold is in the closure of l Q + det A + det B" uses only that the
  eightfold is V_0 + t_2 Q.
- Whether the class on l Q + det A + det B specialises to the class of the rung (the functional of 15.5) was not
  checked directly; the kernels have the right dimensions (26 at the general member, 25 at the rung).
- R6 for the eightfold Coble rung, left unchecked in 15.8, is still unchecked.

### 16.10 Blind check 8 (26 Nov; a separate agent, own Macaulay2 code; it read only the first certificate)

Report: `leads/tenfold_coble/blind_check8/REPORT.txt`. It was given the definitions and the claims, not the scripts.

Confirmed (exact over F_(p^2), p = 32003, or MOD p):
- the identity of 16.6 for the first certificate, with tr A = tr B (not zero), s_2 equal, entries of rank 9; G
  irreducible, not a cone; det A not proportional to det B; the map between the trace-free parts is an isometry
  with s != +-1 and s^2 != 1 (so nothing is trivial); the Coble surface has Hilbert polynomial 9 n^2 and C is
  smooth and connected with h^0(O_C(1)) = 10;
- the degeneration formula, symbolically with indeterminate entries, with the correction c G for G; rank 44;
- 16.7 at two primes: degree 18, genus 10, exactly 9 quadrics, 75 cubics; ranks 64 / 20 / 75, and the span is
  (I_C)_3; one reflection gives (linear) x (quadric);
- the count 3 + 8 + 63 (the differential in the 72 coefficients of the substitution has rank 72, with the Coble
  parameters 75); irreducibility of the family det M - det sM;
- 16.3: 85 / 93 / 91 / 95 and Pluecker rank 3 at five members, also for a synthetic G_s.

Its objections and additions (accepted; worked into the text above):
1. The limit in 16.8 is c G + ..., not G + ...
2. The rank 44 carries no information beyond "the entries of A span the linear forms".
3. "Every Coble section": my argument had a gap (equal dimension and one common point do not give equality, and
   one random instance modulo p does not certify a general point). Its replacement (ARG, by the checker,
   unreviewed; computations at the certificate point):
   (a) Lemma, in any characteristic other than 2 and 3: if tr A = tr B and s_2(A) = s_2(B), the rank <= 1 loci of
       tau + A and tau + B in P^8 both lie on the quadric s_2(tau + A) = 0, so they meet in a curve (degree 18), and
       the cone over det A - det B is singular along it. Checked on a synthetic pair and on the certificate
       (Hilbert polynomial 18 n - 9, projecting onto Sing G). So every such cubic has a singular curve.
   (b) At the certificate point the saturated Jacobian ideal is I_C, so the locus E of cubics singular along a
       curve with that Hilbert polynomial has tangent space inside (I_C)_3 (dimension 75); the Coble sections and
       the cubics det M - det sM both lie in E, and both parametrisations have differential of rank 75 there. So E
       is smooth of dimension 75 at G and the closures of both families are the component of E through G.
   (c) Characteristic 0: the same over the Witt vectors would do, but the details are not written.
   With (a), (b): in characteristic p a general Coble section is of the form det M - det sM and conversely, for
   the component through this G. Still an argument; still nothing in characteristic 0.
4. R11b (the Pluecker rank) is forced by h^0(O_C(1)) = 10 = 8 + 2: it tests O_C(1) = K_C and nothing more.
5. At the certificate det s = -1, in the synthetic runs +1: harmless (replace B by its transpose).

Not checked by it: the second certificate (31991; only `check_certificate.m2` has seen it); R8, R9, R10, R12-R14
(the tests at the point and along the arcs) and 16.5; the tenfold family of 16.8. Those rest on my runs alone.

## 17. The intersection count of section 14, exactly over QQ at a named member (26 Nov 2026, evening)

Owner's request: make the headline exact where it is still MOD p. This section does it for the count on which
the class statement rests. Scripts, logs and the pre-registration: `leads/tenfold_coble/plane_test/exact/`.
Registry: D-TENFOLD-COBLE-PLANE-COUNT-EXACT. Labels as before; nothing here is a statement about the Hodge
conjecture (the cycle is algebraic).

### 17.0 Result

At the Coble cubic Y with lam = -2, x = (8, 18, 1) (so a0 = 29: integer coefficients) and the point
a = (0, 1, -1, 1, 2, 3, -1, -3, -2) of Sing(Y), for the cycle Z_a (the union of the 4-planes of Y through a that
contain a tangent line of Sing(Y) at a), an explicit rational plane pi in a rational 4-plane P' of Y, the 5-plane
Lambda over pi and an explicit rational tenfold X = F + sum w_k Phi_k:

- **Lambda . Z_a = 8** (EXACT over QQ; Z_a read as its 5-dimensional part, see 17.4): pi n {Q_a = G = 0} is 10 reduced points, one closed point of degree 8 and
  one of degree 2; the 8 lie on Z_a (a 4-plane of Y through a and the point is exhibited over the degree-8
  field), the 2 do not (the only candidate plane is not in Y); at the 8 the intersection is transversal.
- **deg Z_a = 12** (EXACT over QQ): a rational P^3 meets Y n {Q_a = G = 0} in 30 reduced points, closed points of
  degrees 12 and 18; the 12 lie on Z_a and the 18 do not (the checker's run; mine was stopped).
- X is smooth (its reductions modulo 32003 and 31991 are; a singular point over QQ would specialise) and contains
  Lambda.
- Hence on X the class [Z_a] is not a rational multiple of h^5: such a multiple c h^5 would have
  Lambda . (c h^5) = c and degree 3c, and 8 is not 12 / 3. (ARG on exact numbers: three lines.)

What stays an argument: that the same holds on every smooth tenfold with this P^8-section and on the other
members of the family (the cycle does not change; connectedness), as in section 14.

### 17.1 Why no number field was needed for the member

The earlier entry said an exact run "needs a point of A over a number field". The involution
iota: z_1 <-> z_2, p_0 <-> q_0, p_1 <-> q_2, p_2 <-> q_1 preserves the normal form, and for a point b of its odd
eigenspace the conditions grad F(b) = 0 are linear in (lam, x): they cut out a line of parameters. So every
rational odd point lies on Sing(Y) for a line of rational Coble cubics. With b = (1; 1, 2, 3): lam = -2 and
x = (15 + u, 33 + 3u, 2u)/2; u = 1 gives the member above. Two more rational objects come with it: the 4-plane P_B
through the odd eigenspace (it lies in Y, passes through a and contains a tangent line of Sing(Y) there, so Z_a
has a rational plane), and its image P' = g(P_B) under the rational symmetry
g: z_k -> z_(k+2), p_i -> p_(i+1), q_j -> q_(j+1), which does not pass through a. P_B n P' is a line.

### 17.2 How membership is certified

A 4-plane Pi of Y through a and a + v_tau (v_tau a tangent direction of Sing(Y) at a) lies in
{F = Q_a = l_tau = b_tau = 0}: expand F on the plane spanned by a, a + v_tau and y. So for y on such a plane
Q_a(y) = G(y) = 0, and tau = (l_2(y), -l_1(y)) is determined when (l_1, l_2)(y) != 0 (checked: no point of pi or
of the P^3 on Q_a has l_1 = l_2 = 0). When the fibre {F = Q_a = l_tau = b_tau = 0} is smooth at y, its tangent
space is the only candidate plane. "On Z_a": the candidate lies in Y and contains a, y and a + v_tau.
"Not on Z_a": the candidate does not lie in Y. Both are identities in the residue field of the closed point
(degree 2, 8, 12 over QQ), computed with determinants and substitutions only: the kernel is written by Cramer's
rule and checked by multiplication, because `kernel` over a field made by toField is not reliable in Macaulay2
1.22 (the first version of the script returned "kernel not verified"; see also N-M2-TOFIELD-IDEAL-QUOTIENT).

### 17.3 The numbers

| | what | result | label |
|---|---|---|---|
| member | grad F(a) = 0; rank Hess_a = 6; P_B and P' in Y; a on P_B, not on P'; no special-parameter relation | all true | EXACT |
| E1 | pi n {Q_a = G = 0}: degree 10, reduced; closed points 8 + 2 | as predicted | EXACT |
| E1 | degree-8 point on Z_a; degree-2 point not; CI smooth and transversal at both | as predicted | EXACT |
| E2 | P^3 n Y n {Q_a = G = 0}: degree 30, reduced; closed points 12 + 18; the 12 on Z_a | as predicted | EXACT |
| X | Lambda in X; X smooth modulo 32003 and 31991 (denominator 1380) | true | EXACT / by reduction |

### 17.4 Blind check 11, and the gap it closed

A separate agent, given the definitions and the claims only (no code, no repository), redid everything with its
own exact arithmetic (Python on python-flint for the number fields, Singular and Macaulay2 only over QQ, ZZ/p and
QQ(t)): `leads/tenfold_coble/blind_check11/REPORT.txt`.

- CONFIRMED exactly: the member and the planes; 10 = 8 + 2 on pi with the memberships and transversality; the
  same count on two planes of its own; 30 = 12 + 18 on the P^3 with the 12 on Z_a; a smooth X of its own with
  Lambda inside; Sing(Y) of dimension 2, degree 18, Hilbert polynomial 9 n^2 over QQ, and smooth (by reduction).
  It decided the degree-18 point directly: NOT on Z_a (my run of that test had been stopped as too slow).
- **A gap in my chain, found and closed by the checker.** My argument for "deg Z_a = 12" and for transversality
  assumed that Z_a is 5-dimensional at the points found; nothing in my runs showed that the family of planes is
  infinite (a finite set of 4-planes would have no class in dimension 5). The checker proved it by an exact
  computation over QQ(t): for the direction tau = (1 : t) with t an indeterminate there is a plane of the family
  defined over a quadratic extension of QQ(t), so the planes are parametrised by a double cover of the tau-line
  (discriminant with a factor of degree 1 and one of degree 5: genus 2, as the theta-curve picture says), and the
  planes through the degree-12 point and through the eight points of pi are specialisations of it. Hence the
  5-dimensional part Z5 of Z_a is irreducible, equal to the degree-12 component of Y n {Q_a = G = 0}, and the
  statements of 17.0 hold for Z5: deg Z5 = 12, Lambda . Z5 = 8, [Z5] is not a rational multiple of h^5.
- Its other remarks, all accepted: the membership test is only sufficient where the Jacobian rank is 4 (the
  rational plane P_B sits over a branch point, t = 11/5, where the fibre contains it doubly, so the test does not
  see P_B itself); points with l_1 = l_2 = 0 exist on Z_a (a is one) but no plane of the family lies in
  {l_1 = l_2 = 0}; pure 5-dimensionality of Z_a is not established and not needed; the Phi_k must involve the w
  (mine do); a robust form of the conclusion needs only "Z5 is not empty".
- A structural by-product: {B_11 = B_12 = B_22 = 0} is a P^5 through the tangent plane of Sing(Y) at a, and it meets
  Y in P_B and a rank-3 quadric cone that lies in every fibre.

## 18. Is the Coble family in the closure of the two-determinant family on tenfolds? (plan item A5; 27 Nov; ARG)

Reconciliation with the first-order count. Both families carry a primitive class of norm -48: v_0 = [V] - 2 h^5 on the
Coble family (D-TENFOLD-COBLE-CYCLE-CLASS) and delta_2 = [T5] - 3 h^5 on the two-determinant family
(D-TENFOLD-TWO-DET-CLASS), and the lattice rule cannot tell them apart. But: suppose the Coble family W# (codim 54)
lies in the closure Sigma of the two-determinant family (codim 52) and the class delta_2, transported to a general
point X of W#, is +-v_0 (or any class whose Hodge locus at X is the one computed in D-TENFOLD-COBLE-FAMILY (N3)).
Sigma lies in the Hodge locus of that class near X, so the Zariski tangent space of that Hodge locus at X contains
the tangent cone of Sigma at X, which has the dimension of Sigma: its codimension would be at most 52. (N3) computed
it as 54 (MOD p, two primes, three members; EXACT at one member). Hence (ARG): at a general Coble point either W# is
not in the closure of the two-determinant family, or it is and the two-determinant class specialises there to a
class different from +-v_0 (then a general Coble tenfold carries two independent primitive Hodge classes of norm
-48). On eightfolds the analogous numbers are 25 (rung) against 26 (two determinants), which is compatible, and there
the containment holds (D-EIGHTFOLD-COBLE-RUNG-IN-TWO-DET-CLOSURE). The eightfold mechanism (a Coble SECTION is
det(tau + A) - det(tau + B) with equal trace and second coefficient) does not lift directly: the full Coble cubic in
P^8 is not a cone, while det(tau + A) - det(tau + B) with equal trace and s_2 is a cone in tau. Which alternative
holds is open; the second would be testable by computing the rank of the space of Hodge classes at a Coble member
(two classes would show up as a second independent functional with the same tangent space data).
Blind check 16: the argument is sound with conditions: it holds per local branch of the closure through X (if
there are several branches, each must specialise to a class other than +-v_0), needs the closure pure-dimensional at
X and both codimensions measured in the same ambient space; sign and monodromy are harmless. In the second
alternative the two classes span a negative-definite lattice (Hodge-Riemann), a usable consistency test.
