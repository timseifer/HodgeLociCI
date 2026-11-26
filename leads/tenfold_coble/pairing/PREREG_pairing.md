# Pre-registration: the K3 / abelian pairing (coefficient +1 / coefficient -1)

AI-written (Claude Fable 5.2), 26 Nov 2026, not reviewed by a mathematician. Written BEFORE the runs of this folder.
Labels: EXACT / MOD p / PROVED (AI, unreviewed) / ARG / LIT / OPEN. Nothing here is a statement about the Hodge
conjecture: every class below is the class of an explicit algebraic cycle.

## 0. The observation and the question

Registry, D-TENFOLD-PFAFFIAN-K3 (c): on cubic tenfolds with two 5-planes meeting in a plane,
coefficient +1 (class P1 + P2): X n P^8 is a Pfaffian cubic, singular along a K3 surface of degree 14, 56 nodes;
coefficient -1 (class P1 - P2): X n P^8 is a Coble cubic, singular along an abelian surface of degree 18, 72 nodes.
Owner's question (four items): (1) the same on eightfolds and sixfolds; (2) surfaces with torsion canonical class
(Enriques, bielliptic); (3) a computable reason why the sign selects K3 or abelian; (4) literature.
Goal: decide between a coincidence, a conjecture worth stating, and something provable.

## 1. Theory written down before any run

Setting. X in P^(2k+1) a smooth cubic 2k-fold, Lambda = P^(2k-s) a linear space, Y = X n Lambda singular along a
smooth S of dimension s, with Hessian of rank equal to the codimension of S in Lambda at every point of S.
The hyperplanes through Lambda form a P^s and the Gauss map S -> P^s is given by s quadrics, so a general
hyperplane section V = X n H through Lambda has 2^s deg(S) nodes, all on S.

T1 (PROVED, AI, unreviewed; a Chern class computation). Let H be a hyperplane, V = X n H, and Sigma in V a smooth
k-fold of degree m. The cubic f = F|_H gives a section df of N^v_(Sigma/H)(3) whose zeros are the singular points
of V on Sigma. If they are finitely many, of total length N, then
        3 (Sigma.Sigma)_X - m^2 = (-1)^k 2 N,
that is: the discriminant of the lattice <h^k, [Sigma]> is (-1)^k * 2 * (number of nodes of V on Sigma).
Proof. With n_i = c_i(N_(Sigma/H)):  c(N_(Sigma/X)) = c(N_(Sigma/H)) (1+h)/(1+3h), because
0 -> N_(Sigma/H) -> N_(Sigma/P) -> O(1) -> 0 and 0 -> N_(Sigma/X) -> N_(Sigma/P) -> O(3) -> 0 (X is smooth).
(1+h)/(1+3h) = 1 - 2 sum_(j>=1) (-3)^(j-1) h^j, so (Sigma.Sigma)_X = n_k - 2 sum_(j>=1) (-3)^(j-1) n_(k-j) h^j.
N = c_k(N^v(3h)) = sum_i (-1)^i n_i (3h)^(k-i), so (-1)^k N = n_k + sum_(j>=1) (-3)^j n_(k-j) h^j.
Eliminating the sum: 3 (Sigma.Sigma)_X = n_k + 2 (-1)^k N, and n_k = (Sigma.Sigma) in P^(2k) = m^2.  QED
Hand checks (known lattices): plane in a fourfold: 4 nodes, disc 8. Cubic scroll: 6 nodes, 12. P^3 in a sixfold: 8
nodes, 3(-5) - 1 = -16. P^5 in a tenfold: 32 nodes, 3(-21) - 1 = -64. Quintic del Pezzo 5-fold (Pfaffian tenfold):
56 nodes, -112 = 3(-29) - 25. Coble tenfold, [V]^2 = -36, degree 6: 72 nodes, -144.
Consequence: for the tenfold setting above (k = 5, s = 2): disc = -8 deg(S). With the cone dictionary
(disc = (-2)^(k-2) d, d the discriminant of the cubic fourfold class): nodes = 2^(k-3) d on a 2k-fold.

T2 (ARG, Cayley-Bacharach). For a surface S (k = 5, s = 2) with K_S numerically trivial: the number of relations
among the 4 deg(S) nodes on quartics is p_g(S), provided S is 4-normal in P^8 (between p_g and p_g + h^1(I_S(4))
in general). Koszul for the two quadrics on S, Kodaira vanishing for 2h.

T3 (LIT + ARG). Piroddi, Rios Ortiz, Rojas, Song, arXiv:2606.10884 (machine-read 26 Nov 2026), Prop. 2.2 and
Cor. 2.3: if S is the scheme-theoretic singular locus of a hypersurface of degree d in P^N, the normal bundle
carries a nowhere degenerate quadratic form with values in O(d) and 2 K_S = (d (N - n) - 2 (N + 1)) H. For cubics
in P^8 and surfaces: 2 K_S = 0. So S is K3, abelian, Enriques, or bielliptic with K_S of order 2.
ARG: the two families of isotropic 3-spaces of the form on N (rank 6) are exchanged by the double cover of S
given by the 2-torsion bundle det N (-9h) = K_S. A 5-fold Z in Y containing S and smooth along S has
T Z / T S isotropic, so it chooses one family at every point; hence it can exist only if K_S is trivial.

T4 (ARG, Riemann-Roch). S linearly normal and spanning P^8, K_S numerically trivial: 9 = chi(O_S) + deg(S)/2, so
deg(S) = 18 - 2 chi(O_S): K3 14, Enriques 16, abelian 18, bielliptic 18.

T5 (EXACT, lattice). In <h^5, P1, P2> (P.P = -21, P1.P2 = 3): disc <h^5, a h^5 + r P1 + s P2> = -8 (8 r^2 - 2 r s
+ 8 s^2). The value 14 is taken only at (r, s) = +-(1, 1), the value 18 only at +-(1, -1). 16 is never a value
of (3 Sigma^2 - m^2)/(-8)... more simply: 3 Sigma^2 - m^2 is 0 or 2 mod 3, and -8 * 16 = 1 mod 3.

Predicted answer to item 3 (to be tested by 2 and 3 below): the sign is forced.
    one relation  <=>  K_S = 0  (T2, T3);   discriminant = -8 deg(S) = -8 (18 - 2 chi(O_S))  (T1, T4);
    chi = 2 (K3): 14, coefficient +1;   chi = 0 (abelian): 18, coefficient -1   (T5).
    Enriques (chi = 1, degree 16) and bielliptic (chi = 0, degree 18): no relation, so no coefficient at all.

## 2. Runs, predictions, and what each outcome would mean

R1 (item 1; tool: tooling/node_section). Random instances, two primes.
  (a) sixfold, +1: F = l*Q + Pf(M), section l = 0.              Predicted: 14 nodes, 13 conditions on quadrics, defect 1.
  (b) eightfold, +1: X n P^7 a Pfaffian cubic sixfold (singular along a canonical curve of genus 8, degree 14);
      a hyperplane section through the P^7.                     Predicted: 28 nodes, 27 on cubics, defect 1.
  (c) sixfold, -1: a hyperplane section equal to (Coble cubic) n P^6.   Predicted: 18 nodes, 17 on quadrics, defect 1.
  (d) eightfold, -1: X n P^7 = (Coble cubic) n P^7 (singular along a curve of degree 18, genus 10); a hyperplane
      section through the P^7.                                  Predicted: 36 nodes, 35 on cubics, defect 1.
  (e) eightfold, -1, the registry's family F = l*Q + det A + det B (D-EIGHTFOLD-FAMILY-TD), section l = 0.
                                                                Predicted: 36 nodes (the 6 * 6 points where the two
      Segre fourfolds meet), 35 on cubics, defect 1.
  Meaning. All as predicted: T1 with d = 14, 18 holds on every rung (nodes = 2^(k-3) d), and the section geometry
  on the rungs is: +1 = linear sections of G(2,6) (K3, canonical curve, 14 points), -1 = linear sections of the
  abelian surface (surface, curve of genus 10, 18 points), with the generic eightfold -1 member being
  "two Segre fourfolds meeting in 36 points". A different node count in (e) (not 36) would contradict T1 or the
  registry's class for that family. A defect other than 1 anywhere: T2 or the family is misunderstood; stop and look.
  Not tested by R1: that the Coble rungs (c), (d) lie in the closure of the registry's -1 families.

R2 (item 2, Enriques). S = quotient of the K3 surface {q_i(x) + q'_i(y) = 0, i = 1,2,3} in P^5 by (x, y) -> (x, -y),
  embedded in P^8 by the 9 invariant quadrics: S = {rank X <= 1, rank Y <= 1} n P^8, X, Y symmetric 3 x 3, the P^8
  cut out of P^11 by three linear forms. Degree 16.
  Predictions: (i) S smooth, Hilbert polynomial 8 n^2 + 1; (ii) the cubics singular along S are exactly the pencil
  det X + c det Y (the Riemann-Roch count 165 - 73 - 90 = 2 agrees); (iii) for general c the singular scheme of
  Y_c is S and the Hessian has rank 6 on S; (iv) a tenfold through Y_c: 64 nodes on the hyperplane sections
  through the P^8, 64 conditions on quartics, defect 0.
  Meaning. As predicted: Enriques surfaces do occur as singular loci of cubic sevenfolds in P^8, and give no
  relation (no class, no coefficient): the pairing is K3 / abelian only, as T2-T3 say. If the defect were 1:
  T2 or T3 is wrong, or S is not 4-normal; a class with "d = 16" cannot exist (T5), so its cycle would have to be
  singular along S; that would be a new phenomenon and would be reported as such. If (ii) fails with no cubic:
  the construction is wrong (the two determinants are singular along S by inspection), stop.

R3 (item 2, bielliptic). S = (E x F)/<(tau, -1)>, tau a translation of order 2 on E, embedded by the invariant
  sections of O_E(6 points) x O_F(3 points): degree 18 in P^8, K_S of order 2 (LIT: type (3,3) is very ample,
  Mella-Palleschi; as quoted in arXiv:2607.18918, Prop. 1.9).
  Prediction: none for existence. The Riemann-Roch count is 165 - 81 - 81 = 3, the same as for the abelian
  surface, where the true number is 1; so the count does not decide. Two-sided:
  no cubic singular along S -> bielliptic surfaces of this type do not occur (for this embedding);
  at least one -> predicted 72 nodes and defect 0 (T2), tested with the tool as in R2.

R4 (T1 by direct count, independent of the lattice numbers). For a smooth Sigma in P^(2k) and a random cubic through
  it, count the singular points on Sigma: P^2 x P^2 in P^8 (predicted 36, from Sigma.Sigma = 36 in the registry),
  G(2,5) n P^6 (predicted 14, from 13), P^1 x P^2 in P^5 inside P^6 (predicted 12, from the cubic scroll).

## 3. Independent check

One blind checker gets the statements T1-T5 and the constructions of R1-R3 as definitions only, no code, and
reports before anything is recorded.

## 4. Not attempted here

Abelian surfaces of type (1,9) in P^8; non-linearly-normal surfaces; a proof that the Coble rungs lie in the
registry's -1 families on sixfolds and eightfolds; anything in characteristic 0.

## 5. Added 26 Nov (about 03:08 UTC; the time first written here, 03:15, was a guess), after R1-R4 had run and before the first run of pr5_tangent.m2

R5. Question left by R1: are the "Coble rungs" (c), (d) inside the registry's -1 families on sixfolds and eightfolds?
A count that can exclude it: the tangent codimension of the Hodge locus of the class at a rung member.
ARG (new, to be tested by the controls): the class attached to the relation rho among the nodes Z of V = X n H,
F = f + s Q, is the functional delta(P) = rho(P / Q) on forms of degree (k+1)(d-2) = e + 2 (e = k - 1): it kills s
and the Jacobian ideal. The tangent codimension of the Hodge locus is dim (S/I)_3, I the Gorenstein ideal of delta.
Controls (known values, registry): sixfold l*Q + Pf: 7 (Hilbert function 1,7,12,7,1); eightfold Pfaffian rung: 19;
eightfold l*Q + det A + det B: 26; tenfold Pfaffian: 38 (1,9,27,38,27,9,1); tenfold Coble: 54.
If a control fails, the formula for delta is wrong and nothing is concluded from R5.
Unknown, with what each value would mean:
  eightfold Coble rung (d): by symmetry of the Hilbert function the value is at most 36 - 9 - 2 = 25.
    <= 26: compatible with the rung lying in the closure of {l*Q + det A + det B} (codim 26) as a special point where
           the tangent space is larger; a value below 26 also says the Hodge locus is not smooth of codim 26 there.
    (a value above 26 is impossible by the bound; if it occurred, the bound or the formula is wrong.)
  sixfold Coble rung (c): at most 7 (one linear form in the ideal). 7: tangent codimension 7, the same as for every
    lambda in D-CUBIC-SIXFOLD-DETC (M_lambda of codimension 7); the rung family itself has codimension 11 by a
    parameter count, so the Hodge locus is strictly larger than the rung family.

## 6. Added 26 Nov, about 03:20 UTC, after R1-R5 had run and before the first run of pr6_signs.m2

R6 (item 3, "relation sign patterns"). ARG, classical in spirit: a relation among the nodes p_i of a nodal
hypersurface {f = 0} in P^n (n even) on forms of degree n/2 - 1 comes from an integral relation sum eps_i delta_i = 0
among the vanishing cycles, and has the shape
        sum_i eps_i P(p_i) / sqrt(D_i) = 0,      D_i = determinant of the affine Hessian of f at p_i
(one chart for all nodes; the degrees match: P(p)^2 and D scale by the same power n - 2). The two square roots of
D_i are the two families of isotropic spaces of the node. In the tenfold setting D_i = (discriminant of the normal
quadratic form at p_i) * (Jacobian of the Gauss map S -> P^2 at p_i)^2, so choosing the square roots consistently
is choosing a family of isotropic 3-spaces along S: possible exactly when K_S = 0 (T3).
Prediction: in each of the seven cases with one relation ((a)-(e) of R1 and the two tenfold cases) the relation
functional is rho = Tr(g .) with g^2 * D constant on the node scheme (all eps_i = +-1 and all nodes involved).
Meaning. Constant in all cases: the coefficients of the relation are, up to one common factor, inverse square
roots of the node Hessians; the relation selects one square root at every node, and "the sign pattern" is that
selection. This supports the link between T2 and T3. Not constant in some case: the shape above is wrong (or some
node has |eps| different from 1); T2's counts stand, but the explanation of the missing Enriques relation by the
two families would lose its support and would be withdrawn.

## 7. Added 26 Nov, about 03:36 UTC, before the first run of pr7_enriques_twisted.m2

R7 (the Enriques case by a classical theorem). On the K3 cover in P^5 the preimage of the 64 nodes is a complete
intersection of type (2,2,2,4,4): 128 points. Cayley-Bacharach for a complete intersection: exactly one relation on
forms of degree 2+2+2+4+4-6 = 8, namely sum of P(p) / J(p) = 0 with J the Jacobian determinant. Under
(x, y) -> (x, -y) the equations are invariant and the determinant of the involution is -1, so J is anti-invariant:
the relation vanishes identically on invariant octics and is a genuine relation on anti-invariant octics. The
invariant octics contain the pull-backs of the quartics of P^8; the anti-invariant octics are the sections of
K_S + 4h.
Prediction: Hilbert function of the 128 points in degree 8 is 127; the invariant octics have rank 64 on them (no
relation among the 64 nodes), the anti-invariant octics rank 63 (one relation, in the twisted system).
Meaning. As predicted: for this Enriques surface "no relation against quartics, one relation against K_S + 4h" is
the classical Cayley-Bacharach theorem plus a parity count, i.e. T2/T3 hold here by a standard argument and the
missing class is explained. Ranks 63 / 64 the other way round, or 64 / 64: the parity argument is wrong; look.

## 8. Added 26 Nov (owner: "go ahead" on the open point of 15.5), before the first run of pr8_equisingular.m2

Question. Do the eightfolds of the Coble rung (R1 (d)) lie in the closure of the family l Q + det A + det B (R1 (e))?

Why not the Hodge-theoretic second-order obstruction: for a class given only as a functional on the Jacobian ring,
the second-order term is a period of a form of higher pole order, <delta, Res(P G^2 Omega / F^6)>, and for P G^2 not
in the Jacobian ideal this is not determined algebraically by delta. So I use the classical obstruction to keeping
the nodes instead, which is algebraic.

Setting (eightfolds only: here the relation among the nodes is on cubics, the degree of the deformations).
V = {f = 0} a cubic sevenfold in P^8 with N reduced nodes p_i and exactly one relation sum c_i g(p_i) = 0 on cubics.
ES = the germ at f of the cubics with N nodes near the p_i (the intersection of the N smooth branches B_i of the
discriminant). T ES = (I_Z)_3, of dimension 165 - (N - 1); dim ES >= 165 - N.
In one affine chart, the branch B_i is {critical value near p_i = 0}:
     b_i(f + eps g) = eps g(p_i) - (eps^2 / 2) grad g(p_i)^T H_i^(-1) grad g(p_i) + O(eps^3),   H_i = Hessian of f at p_i.
Since sum c_i g(p_i) = 0 for every cubic g, the function sum c_i b_i has no linear term, and its quadratic term is
     h(g) = sum_i c_i grad g(p_i)^T H_i^(-1) grad g(p_i)                                   (T8; ARG, classical)
on (I_Z)_3; ES lies in {sum c_i b_i = 0}. So:
   h not identically zero on (I_Z)_3  =>  dim ES = 165 - N exactly (one less than its tangent space);
   h identically zero on (I_Z)_3     =>  no obstruction at second order (dim ES could be 165 - N + 1).
Built-in check: for g = (linear vector field) . grad f, an infinitesimal coordinate change, grad g = H . xi at the
nodes and h(g, g') = rho(xi . grad g') = 0 for all g' in (I_Z)_3. The computation must reproduce this.

Controls (known dimensions): the sections of l Q + det A + det B form a family of dimension 130 = dim (I_Z)_3, and
those of the Pfaffian rung one of dimension 138 = 165 - 27 = dim (I_Z)_3; in both ES is smooth with that tangent
space, so h must vanish identically on (I_Z)_3. Teeth: with a random functional in place of the relation the form
must not vanish.

The case in question, V_0 a section through the P^7 of a Coble-rung eightfold (36 nodes, 35 conditions): the
sections of rung members form a family of dimension 128 inside ES, on whose tangent space h must vanish; (I_Z)_3
has dimension 130. So h has rank at most 4. No prediction for whether it is zero. (A reason to expect it nonzero:
the two extra tangent directions come from H^1(O_A), i.e. from re-embedding the curve A n P^7 by a different
projection of its canonical model, and a count gives no cubic sixfold singular along a general such curve.)
What each outcome means:
   h != 0: dim ES(V_0) = 129 < 130. The 36-nodal sections of rung members are then not limits of the 36-nodal
           sections of l Q + det A + det B (those form a family of dimension 130 inside the 36-nodal cubics).
           Consequence for the eightfolds, under two assumptions that will be stated as such (the functional of R5
           is the class, so that a limiting hyperplane must contain the P^7; a general rung member has no further
           Hodge classes): the Coble rung is NOT in the closure of that family.
   h == 0: nothing is obstructed at second order; compatible with the rung lying in the closure; not a proof.
           Next would be third order or an explicit degeneration.
If a control fails, T8 or the code is wrong and nothing is concluded.

## 9. Added 26 Nov, after the first run of pr8_equisingular.m2 (h == 0 in the case in question) and before the first run of pr9_quadrics.m2

Outcome of section 8 at the first prime: h vanishes identically on (I_Z)_3 for the section of the Coble rung, as
for the three controls (teeth: a random functional gives a form of rank 94). So there is no second-order
obstruction, and by section 8 nothing is concluded yet. A first-order test that can still decide "no":

R9. Let sigma = the closure of {det A + det B} in the cubics of P^8 (dimension 130). If V_0 lies in sigma, then
the germ ES of 36-nodal cubics at V_0 contains a germ of dimension 130 = dim of its tangent space (I_Z)_3, hence ES
is smooth and equal to sigma there, and EVERY g in (I_Z)_3 is tangent to a curve in sigma. On sigma the 36 nodes
lie on at least 18 quadrics (the 2 x 2 minors of A and of B; upper semicontinuity). The nodes move with velocity
x = -H^(-1) grad g, and a quadric q through the nodes survives to first order iff the function grad q . x on the
nodes is the restriction of a quadric. So:
     mu_g : (I_Z)_2 -> (functions on the nodes)/(quadrics),   q -> [grad q . x]
must have kernel of dimension >= 18 for every g in (I_Z)_3 (NECESSARY for V_0 in sigma; ARG, elementary).
For the section of the Coble rung dim (I_Z)_2 = 19 (nine multiples of the hyperplane, nine quadrics through the
curve, and Psi), so the condition is: rank mu_g <= 1 for every g in (I_Z)_3.
Controls: for det A + det B, for the Pfaffian rung and for a sevenfold through a P^4 the type of the node scheme is
constant on ES, so mu_g = 0 for all g in (I_Z)_3. In the case in question mu_g must vanish for g tangent to the
family of sections of rung members (the 128-dimensional subspace).
Outcomes for a general g in (I_Z)_3 in the case in question:
   rank mu_g >= 2: V_0 is not in sigma. With the two assumptions of section 8 for the passage to eightfolds, the
                   Coble rung is not in the closure of l Q + det A + det B. A "no".
   rank mu_g = 1:  exactly what membership requires (19 quadrics at V_0, 18 on sigma); compatible, not a proof.
   rank mu_g = 0:  all 19 quadrics survive in every direction; then the nearby 36-nodal cubics have their nodes on
                   19 quadrics and are not general members of sigma; V_0 could then lie only in a proper closed
                   part of sigma, which contradicts "every g is tangent to a curve in sigma" unless sigma itself
                   has 19 quadrics there. A "no" as well (same argument).

## 10. Added 26 Nov, after the first run of pr9_quadrics.m2 and before the first runs of pr10_arcs.m2 and pr11_cone.m2

Outcome of section 9 at the first prime: rank mu_g = 1 for general g, 0 on the rung directions, and the same 18
quadrics survive in every direction. With section 8 (h == 0) both necessary conditions for membership hold; nothing
is decided. (An exploratory attempt to find a closed condition separating det A + det B from general cubics by
Koszul flattenings gave nothing: the ranks for det A + det B are the generic ones. Not recorded as a result.)

R10 (formal arcs; finite order, so evidence and not proof). For a general g_1 in (I_Z)_3 extend
f + e g_1 + e^2 g_2 + ... order by order so that all 36 nodes persist. At order m the nodes impose the values of g_m
on Z, and such a cubic g_m exists iff the relation rho kills those values: one number per order, the obstruction.
If all lower obstruction forms vanish identically this number does not depend on the earlier choices.
   Controls: det A + det B, the Pfaffian rung, a sevenfold through a P^4: every direction of (I_Z)_3 integrates
   (ES is smooth with that tangent space), so the obstruction must be 0 at every order. Cross-check of the code:
   the order-2 value must equal -1/2 grad g_1^T H^(-1) grad g_1 computed with the matrices of pr8.
   The case in question, general g_1 (three directions), to order 6:
     a nonzero obstruction at some order m: dim ES = 129, and by section 8 the answer is "no" (with its assumptions);
     zero to order 6: the 36-nodal cubics near V_0 form, as far as order 6 can tell, a family of dimension 130 with
     a relation; compatible with "yes". It would still not show that this family is the family det A + det B.
R11 (first order, eightfolds). For each hyperplane H_c of the pencil through the P^7, the first-order deformations
of the eightfold keeping the 36 nodes of X n H_c (H_c allowed to move) form a space T_c of codimension 27.
Prediction: the sum of the T_c over the pencil is exactly the tangent space of the Hodge locus found in R5
(codimension 25). Meaning: the whole first-order Hodge locus at a rung member is accounted for by keeping the nodes
of some member of the pencil; then the picture "the Hodge locus there is the family of eightfolds with a 36-nodal
section, of codimension 26, singular along the rung with tangent cone the union of the T_c" is consistent. If the
sum is smaller than codimension 25, there are first-order Hodge directions that no nodal section explains.

## 11. Added 26 Nov, while pr10 and pr11 were running, before the first run of pr12_split.m2

R12 (can the 18 surviving quadrics be the limit of "minors of A plus minors of B"?). For det A + det B the 18
quadrics through the nodes are L = L_A + L_B, the quadrics of the two Segre fourfolds; L S_1 = (I_Z)_3 has
dimension 130, so L has exactly 32 linear syzygies, 16 for each summand. Hence the algebra
     Alg(L) = { phi in End(L) : (phi x 1) maps the linear syzygies of L to linear syzygies }
contains the two projections: dim Alg(L) >= 2. A two-dimensional subspace of End has a limit, and the condition is
closed. So if V_0 lies in sigma (then, by section 9, the common kernel L_0 of the maps mu_g is the limit of the
spaces L along every general arc, and if L_0 S_1 still has dimension 130 its syzygies are the limits of the
syzygies), then dim Alg(L_0) >= 2 (NECESSARY; ARG).
Control: det A + det B itself: dim Alg = 2 expected (the two projections; ranks 9 and 9; each summand cuts a
fourfold of degree 6).
The case in question, L_0 = the 18 surviving quadrics of section 9:
   dim L_0 S_1 different from 130: the argument does not apply as stated; report the number, conclude nothing.
   dim Alg(L_0) = 1 (scalars only): V_0 is not in sigma: a "no" (with the assumptions of section 8 for eightfolds).
   dim Alg(L_0) >= 2: compatible. Then the structure of a non-scalar element says how the two Segre fourfolds
       would degenerate: two idempotents of rank 9 (two limit fourfolds, to be looked at), or a nilpotent element
       (the two fourfolds come together in the limit).

## 12. Added 26 Nov, about 05:50 UTC, after the rerun of pr12_split.m2 at the first prime and before the first run of pr13_arc_algebra.m2

State. R8 (h == 0), R9 (rank mu_g = 1), R10 (no obstruction to order 6, one general direction at each prime; the
runs were stopped by the time limit before the other two directions), R12 (dim L_0 S_1 = 117, not 130: the argument
of section 11 does not apply, nothing concluded; control: dim Alg = 2, two Segre fourfolds). Every test that could
have said "no" is compatible with "yes"; none shows "yes". The tests so far look only at V_0. The next one looks
at a nearby point.

R13, R14 (the 18 quadrics at the generic point of a formal arc). Notation: sigma = closure of {det A + det B}
(dimension 130), ES = the scheme of 36-nodal cubics near V_0, K = k((e)), R = k[[e]].
Argument (ARG). Suppose V_0 lies in sigma. Then ES contains a germ of dimension 130 = dim of its tangent space, so
ES is smooth at V_0 and equals sigma there. In a smooth germ every jet lifts to an arc, and the arcs with a given
jet are not all contained in a proper closed subset. So the jet computed by the method of R10 (order M) is the
jet of an arc gamma in sigma whose generic point is a general point of sigma. At that point, over K:
   (a) the nodes lie on exactly 18 quadrics L (rank of the evaluation map on quadrics = 27);
   (b) L S_1 has dimension 130 (32 linear syzygies);
   (c) Alg(L) has dimension exactly 2 (R12 control; the two projections).
All objects are determined modulo e^(M+1) by the jet, and a LOWER bound for a rank over K read off from a
truncation is rigorous: for a matrix over R, (rank over k of its block truncation modulo e^J) - (the same modulo
e^(J-1)) = the number of elementary divisors e^d with d < J =: rho_J, and rank over K >= rho_J. Saturated kernels
are computed modulo e^(J - D), D = the largest exponent seen; this is exact once the rank over K is known to be
reached (it is bounded above: by 27 for (a) under the hypothesis, by 130 for (b) because the nodes impose at least
35 conditions on cubics over K).
The algebra: phi in End(L) with Mult . (phi x 1) . Syz = 0, a linear system Lambda over R with 324 unknowns;
dim Alg over K <= 324 - rho_J(Lambda).  (Rows of Lambda are replaced by 400 random combinations over k.)

Controls.
   C1  det A + det B at a general point, general direction: (a), (b) at order 0 and rho_1(Lambda) = 322.
   C2  a point of sigma outside {det A + det B}: G = sum_ij cofactor_ij(A) B_ij = the first-order term of
       det(A + e B), A the generic matrix. It contains the Segre fourfold of A; expected: 36 nodes on it (the zeros
       of a normal vector field; 6 x 6 = 36), one relation, and by the argument above ES = sigma there. So the
       method MUST find (b) and 324 - rho(Lambda) >= 2 at every order, and = 2 if the order suffices. If it finds
       <= 1, the argument or the code is wrong and nothing is concluded from THE CASE. (No prediction for the
       numbers at e = 0 there.)
THE CASE (section of the Coble rung, general direction, order 6, both primes). No prediction. Outcomes:
   324 - rho_J(Lambda) <= 1 for some J, with (b) reached:  V_0 is not in sigma (MOD p; a finite-order
        certificate together with the ARG above). With the two assumptions of section 8 for the passage to
        eightfolds: the Coble rung is not in the closure of l Q + det A + det B. Then the 36-nodal cubics near
        V_0, if they form a 130-dimensional family as R10 suggests, are a different family, to be described.
   (b) reached and 324 - rho_J(Lambda) >= 2 up to the order available:  compatible with "yes"; then the leading
        term of a non-scalar element says how the two Segre fourfolds would come together (two idempotents, or a
        nilpotent element as in C2). Evidence at finite order, not a proof.
   (a) fails (rho(E) reaches 28) or (b) is not reached within the order:  no conclusion; raise the order once.
Not tested by this: that the arc of R10 extends (finite order); whether the functional of R5 is the class.

## 13. Added 26 Nov, about 06:12 UTC, after pr11_cone.m2 finished at the first prime and before the run of its added last block

Outcome of R11 at the first prime: dim J_c = 93 (codimension 27) for five members; each lies in the kernel of the
class (codimension 25); already two members span it; (I_C)_3 + Psi_1 S_1 + Psi_2 S_1 has dimension 91 (codimension
29, the tangent space of the rung), so each member adds 2 dimensions and the pencil adds 4.

R11b (shape of the tangent cone; ARG first, then a check). From 0 -> I_C(3) -> I_Z(3) -> O_C(3H - Z) = O_C(H) -> 0
and Z_c = C n {Psi_1 + c Psi_2 = 0}: (I_(Z_c))_3 / (I_C)_3 = (Psi_1 + c Psi_2) H^0(O_C(1)), and H^0(O_C(1)) = H^0(K_C)
has dimension 10, two more than the linear forms of P^7 (C is not linearly normal; the quotient is H^1(I_C(1)),
which comes from H^1(O_A)). So with N = H^0(K_C) / S_1 (dimension 2):
     kernel / tangent space of the rung  =  (pencil) x N  (dimension 4),      J_c / (...) = (1, c) x N.
Prediction: the union over c of the J_c is the cone of decomposable tensors, a quadric cone of rank 4. Check: in
the 4-dimensional quotient the five 2-planes are lines of one ruling of a quadric surface in P^3, so their Pluecker
vectors lie on a conic: they span a space of dimension 3 (five general lines: 5).
Meaning if it holds: to first order, the eightfolds with a 36-nodal hyperplane section near a rung member X_0 form
(rung) x (cone over P^1 x P^1), the image of the pairs (X, H) under forgetting H, which contracts the pencil over
each rung member. That is what one expects if the pairs (X, H) form a smooth family of codimension 26; it says
nothing about which family that is. If it fails, the description of J_c above is wrong.

## 14. Added 26 Nov, about 06:32 UTC, after the first run of pr13_arc_algebra.m2 on THE CASE (order 6, first prime) and before the first run of pr14_arc_split.m2

Outcome of section 12 so far (first prime). C1: 27 / 130 / algebra of dimension 2, two idempotents of rank 9.
C2 (order 3): 27; L S_1 = 129 at e = 0 and 130 over K; algebra of dimension 2 over K; the leading term of a non-scalar
element is nilpotent of rank 9 with square 0 (the two Segre fourfolds come together), as predicted.
THE CASE (order 6): quadrics rho = 26, 27; L S_1: rho = 117, 129, 130; algebra: bound 19, 19, 2, 2. So the
necessary condition holds: outcome "compatible with yes". The leading term of a non-scalar element (trace removed)
is N_0 of RANK 1 with square 0. This was not predicted. What it suggests (ARG, written before any further run):

T14. Let N = phi - (tr phi / 18) in the algebra over K; if the cubic at the generic point is G_+ + G_- with the two
nets L_+, L_- (as for det A + det B), then N^2 = delta is a scalar, N = sqrt(delta) (pi_+ - pi_-), and N(grad F) is
the gradient of the cubic G_N = sqrt(delta) (G_+ - G_-).  At e = 0: N_0(grad F_0) = grad G_(N,0) with all partial
derivatives proportional to one quadric q_* (N_0 has rank 1). A cubic whose partial derivatives are all proportional
to one quadric is the cube of a linear form, and then q_* is its square. So:
   P1  q_* = l_*^2 for a linear form l_*, and G_(N,0) is a multiple of l_*^3.   Expected l_* = t, the hyperplane of
       the nodes.
A matrix of linear forms whose determinant is t^3 and whose net of minors is nondegenerate enough is t.1 after a
change of bases, so the natural normal form of the degeneration is
       F_e = [ det(t + e A(e)) - det(t + e B(e)) ] / e^3,
and since det(t + e A) = t^3 + e t^2 tr A + e^2 t s_2(A) + e^3 det A (s_2 = sum of the principal 2 x 2 minors), the
limit is finite iff tr A_0 = tr B_0 and s_2(A_0) = s_2(B_0) modulo the obvious terms; then
       F_0 = det A_0 - det B_0 + t Psi + t^2 l + c t^3,       with Psi, l, c free (from A_1, B_1, A_2, B_2).
   P2  (if this is the mechanism) the Coble section G = F_0 restricted to t = 0 is a difference of two determinants
       of 3 x 3 matrices of linear forms on P^7 whose characteristic polynomials differ only in the constant term.
       Then det(t + A_0) - det(t + B_0) = G identically, so the cone over G is itself a sum of two determinants on
       P^8, and the passage to V_0 is the explicit family above.
   P3  with this normal form G_N = c (det(t + eA) + det(t + eB)) / e^3 . sqrt(delta): so G_(N,0) in (t^3),
       G_(N,1) in (t^2), G_(N,2) in (t), and G_(N,3) restricted to t = 0 is a multiple of det A_0 + det B_0. Hence in
       the pencil spanned by G and D_s := G_(N,3) restricted to t = 0 there are two members D_s + mu G, D_s - mu G
       (opposite values of mu) that are determinantal cubic sixfolds: singular along a threefold of degree 6 with
       Hilbert polynomial (n+1)^3 (a hyperplane section of P^2 x P^2), with an 8-dimensional Lie algebra of linear
       vector fields (a general member of the pencil: none).
What is computed (pr14_arc_split.m2, from the arc written by pr13 at order 10):
   (i)   N^2 is a scalar to the order available (NECESSARY for "yes": two idempotents of rank 9 at the generic
         point; if it fails: "no");
   (ii)  N(grad F) is a gradient to the order available (NECESSARY for "yes"; if it fails: "no"). Teeth: a random
         endomorphism in place of N_0 must fail;
   (iii) P1 and the divisibility statements of P3;
   (iv)  the scan of the pencil for members with a Lie algebra of dimension 8, and their singular loci.
Outcomes of (iii), (iv): if P1 or the divisibility fails, the normal form above is not the mechanism (no conclusion
about "yes"/"no" from that alone; describe what is found instead). If the scan finds two opposite values of mu with
determinantal members: G = (D_1 - D_2)/(2 mu) with D_1, D_2 determinantal: explicit cubics modulo p, checkable
without the arc. That would still not be "yes": it needs the matrices with equal trace and s_2 (next step, exact).
If the scan finds nothing at this prime, the two members may be conjugate over the quadratic extension (then mu^2 is
not a square); try the other prime before concluding anything.
Order: G_(N,3) needs N modulo e^4, hence the arc to order 8 at least; the run uses order 10.

## 15. Added 26 Nov, about 07:33 UTC, after pr14 / pr15 at the first prime and before the first run of pr16_tenfold_twodet.m2

Outcome of section 14 at the first prime (order 10): (i) N^2 is a scalar and vanishes modulo e^6; (ii) N(grad F) is
a gradient at each order (teeth fail); (iii) P1 holds: q_* = l_*^2, l_* S_1 in L_0, l_* vanishes on the nodes; the
divisibility pattern of P3 holds exactly (l^3, l^2, l, none); (iv) no special member over F_p, but the polynomial
det(Q (S_D + mu S_G)) has the factor (mu^2 + 8615)^8: two opposite, conjugate values over F_(p^2). pr15 (added after
that; it uses a routine that recovers a matrix from a determinantal cubic through its Lie algebra, tested on
synthetic pairs built from isometries of the trace form) then found matrices A, B over F_(p^2) with
     det(tau + A) - det(tau + B) = c G,   tr A = tr B,   s_2(A) = s_2(B),         G = the Coble section,
an exact identity that check_certificate.m2 verifies from the matrices alone. P2 holds at this instance.
Found only after these runs, in the registry: the same mechanism on sixfolds (D-DEGENERATION-ALONG-ARC) and the
family with equal trace and second coefficient as a negative result for their divisor D
(N-TWO-TRACE-DESCRIPTION-OF-D). Credit in the write-up.

R16 (the tenfold analogue of the two-determinant family; a side question raised by the count, ARG first).
T2S_10 = cubic tenfolds F = l_1 Q_1 + l_2 Q_2 + det A + det B in P^11 (the P^9-section is a sum of two
determinants). Predictions:
   (a) in the P^9 the two rank <= 1 loci (cones over P^2 x P^2, fivefolds with K = -4H) meet in a curve D of degree
       36 with K_D = (-4 - 4 + 10) H = 2H, genus 37;
   (b) a hyperplane section through the P^9 has exactly 72 nodes, D n {Q = 0}, with exactly one relation on quartics
       (h^0(K_D - 2H) = 1): 71 conditions;
   (c) parameter count (220 - 148) - 20 = 52: the tangent space l_1 S_2 + l_2 S_2 + Q_1 S_1 + Q_2 S_1 + I_2(A)_3 +
       I_2(B)_3 has codimension 52 in the 364 cubics, and S / (l_1, l_2, Q_1, Q_2, I_2(A), I_2(B)) has a symmetric
       Hilbert function 1, 10, ., 52, ., 10, 1 (as 1, 9, 26, 26, 9, 1 on eightfolds).
Meaning. If (b) and (c) hold: a family of cubic tenfolds of codimension 52 with a class on 72 nodes, discriminant
144 by D-NODES-DISCRIMINANT-IDENTITY's count (2 x 72), the same as the Coble family (codimension 54). Because the
first-order Hodge locus at the exact Coble member has codimension 54 (EXACT), a Coble member cannot be a limit of
T2S_10 members with the class continuing: on tenfolds the two families would be different, unlike on eightfolds
(where the Coble rung has tangent codimension 25 < 26). A new lead, to be recorded as open; nothing about which of
them is the registry's W near the Fermat point follows from this alone. If (c) gives 54 or more, or (b) fails, the
count is wrong and nothing follows.
Not computed in this run: whether the class is in the orbit of P1 - P2; the Hodge-theoretic tangent space.

## 16. Closing record (26 Nov, about 08:25 UTC; not a pre-registration)

Section 14 at the second prime (31991, order 10): the same (i)-(iii); in (iv) the two special members are defined
over F_p (mu = +-13379, sum 0 as predicted), each with a Lie algebra of dimension 8 and a singular threefold of
degree 6 with Hilbert polynomial (n+1)^3; no matrix over F_p (not split), matrices over F_(p^2). R16: all three
predictions held at both primes. pr14 on the control C2: the leading cubic is the determinant (Lie algebra 16).
Blind check 8: see README.md. Deviations from what was registered: R10 in fewer directions (time limit); pr13 at
order 10 stopped after the arc was written (32003: after part (c); 31991: after the arc); pr17 was exploratory.
