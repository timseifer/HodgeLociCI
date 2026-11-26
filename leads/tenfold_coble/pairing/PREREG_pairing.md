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
