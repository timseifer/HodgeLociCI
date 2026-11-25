# Dossier draft: lead on cubic tenfolds (NOT a candidate)

Registry entry: [O-TENFOLD-CONE-LEAD](../discoveries/07_open_problems.md#o-tenfold-cone-lead) (the registry is the
source of truth; this dossier is a readable summary, updated 24 Nov 2026).

AI-produced, unreviewed. Not a candidate under the project's candidate standard: there is no specific smooth member off the cone
locus, and the existence of the component is inferred from finite-order arcs at one point. Wording rule: if it ever
becomes a candidate, it is "a Hodge class not known to be algebraic", never a counterexample.

## Setting
- X0: Fermat cubic tenfold in P^11. P1, P2: two Fermat 5-planes meeting in a P^2 (Movasati's pair, arXiv:1902.00831).
- Class [P1] - [P2] (lambda = -1). Hodge conjecture: open for cubic tenfolds (no theorem found covering all members;
  Steenbrink covers cubic sixfolds; Hodge level 4).
- Loci: V_Z (both planes survive; codim 39), Cone_d (X n P^8 a cone over a cubic fourfold in Hassett's C_18;
  explained; codim 65).

## What is established, with labels
- EXACT: rank L = 38, codim V_Z = 39, excess 1; T Cone_T codim 65 inside ker L; T V_Z + T Cone_T = ker L;
  ker L / T Cone_T = 27-dim (3x3 matrices of linear forms on the P^2). [BC-T6, EX-T6]
- EXACT: for explicit generic rank-1 normal directions, an arc with all period equations of [P1] - [P2] vanishing
  through order 8, with neither plane staying Hodge (not a V_Z arc). [EX-T6, 2 directions]
- EXACT (+ARG): for [P1] + 2[P2], the same kind of direction is obstructed at order 6 for every integral arc with that
  tangent. [EX-T6, 3 directions; ARG of step (e), not checked by a second reader]
- EXACT at random points (+ MOD p 16/16): rank DG4 = 16 and G4 = 0 on both Segre cones; G2 = G3 = 0 on ker L. So IF the
  tangent cone of a component W contains a whole Segre cone, W has codim exactly 54 and its tangent cone contains
  T Cone_T; whether W contains Cone_T does not follow. [EXP-T6, W4]
- Second reading (W4): the setup, the order-6 criterion and the tangent-cone argument are sound; the order-8 arcs at
  lambda = -1 are evidence, not proof, of a component (all orders and a Zariski-dense set of tangents would be needed).
- Reconciled: an apparent disagreement with the blind check came from a degenerate sub-family (explained by a join with
  the cubic-sixfold component, where the Hodge conjecture is known). [RC-T6, EXP-T6]

- Follow-up (24 Nov, MOD p): arcs at lambda = -1 extend to order 12 (one direction, two primes) and 11 (other type);
  12/12 fully generic directions extend to order 8 at lambda = -1 and are obstructed at order 6 at lambda = 2; G4 = 0 on
  Sigma1 exact at 40 random points. [W3]
- At random NON-Fermat members of the C_18 family F_T, the Hodge-tangent codim of the cone cycle is 54 vs 55 for F_T
  (first order; a branch or a non-reduced locus, undecided; second-order test running). [W1, SO-T6]

- Cloud runs (24 Nov, MOD p at two primes 67108837 / 67108819; each batch pre-registered, checker re-run by the
  coordinator: PASS, one checker artifact verified by hand): lambda = -1 fully generic rank-1 directions: 1 to order 12
  at both primes (identical histories), 8 to order 10, 1 to order 9, and a batch of 48 new directions 48/48 to order 9;
  none obstructed. Sparse lambda = -1 arcs 4/4 to order 15. lambda = 2 controls 120/120 obstructed at order 6. 26 other
  coefficients obstructed at order 6; only -1 and lambda_0 = 1 extend. [cloud R001-R026, branch cloud-job-1]
- Symmetry versus geometry (24 Nov, pre-registered): GEOMETRIC at order 6-8 (MOD p, two primes). At two split points
  Fermat4 + G (G a cubic fourfold with two disjoint planes; no automorphism swaps the planes, EXACT computer-assisted),
  lambda = -1 generic directions extend to order 6 (16/16) and 8 (8/8), lambda = 2 is obstructed at order 6, lambda_0 = 1
  extends. Blind check BC-TS: AGREE (own tables and order-6 driver; cone-geometry code shared). [TS-T6, BC-TS]
- Orders 2 and 3 at C_18 points: the extra Hodge-tangent direction of F_T is unobstructed at order 2 (2 seeds x 2
  primes, MOD p; blind check BC-SO agrees) and at order 3 (4/4, MOD p; exact cancellation of two nonzero parts;
  controls pass; partly blind check BC-SO3 agrees), consistent with a codim-54 component containing F_T as a
  divisor. [SO-T6, BC-SO, SO3-T6, BC-SO3]
- Semiregularity (Buchweitz-Flenner, V not lci): NOT semiregular, so the theorem gives no conclusion; V is rigid in X,
  so a branch needs a different cycle of class a h^5 + b[V], b != 0. [SR-T6]
- At sextic del Pezzo cone points (special points of F_T: they also contain a V-type cone) the excess over F_T jumps
  from 1 to 5; a rank-4 quadric cone of those directions survives order 2 (MOD p, 4/4; not blind-checked). [DP-T6,
  CS2-T6]
- lambda_0 = +1 for this configuration (checked): lambda = -1 is not the special coefficient of the general rule; its
  first-order excess is a property of special points (Fermat, Z_0, Cone_18). [D-TENFOLD-LAMBDA0-CHECK]

## Constructions tested, and why each fails to explain W
- Second pre-registered search (25 Nov, N-TENFOLD-CODIM54-SEARCH-2; MOD p): ruled out among Thom-Sebastiani /
  Katsura-Shioda cycles, further degenerations of T, P^3-bundles, scrolls of degree 9 and 12, unions with V, and
  del Pezzo-guided families. A sharper check (normal-bundle sections vs explicit family) confirms the first search's
  residual and degeneration verdicts beyond first order. OPEN side item: cones over projected Segre P^2 x P^2 give a
  codim-55 family with Hodge-tangent codim 50.
- Pre-registered codim-54 search (24 Nov, N-TENFOLD-CODIM54-SEARCH; first order, MOD p): ruled out among six named
  types (lattice/two-class reading; joins with the del Pezzo C_18 class; linkage residuals R22, R23, R33,
  R222; degenerations of T; cones with point or line vertex; small-degree 5-folds incl. a 3 x 4 determinantal
  one). The first-order Hodge lattice along F_T is <h^5, [V]>, so W would need a new 5-cycle. Not a proof that none
  exists.
- Cones (Kloosterman Thm 5.3): equal to Cone_d. [LIT]
- Determinantal tower (TD10, det^3, l^4Q^4 + det): codims 52, 88, 32. [DA-T6]
- Swap-invariant families; sums of lambda_0 classes of other Fermat 5-planes; residual/linked cycles. [DA-T6]
- Segre P^2xP^3, P^1xP^4, P^1xQ^4, G(2,5) sections: excluded by integrality (degree divisible by 3). [EXP-T6]
- 13 cone/join/scroll families: codims 32-60, none 54. [EXP-T6]
- F_T does NOT explain W: its tangent cone at Fermat is 165-dim, a codim-1 sub-cone. [W2, ARG]
- PARTIAL: C_18 family F_T (X containing J(P^2, T), T elliptic ruled sextic): codim 55, specific to lambda = -1;
  expected to explain a codim-1 sub-cone of the directions. [EXP-T6, ARG]

## What is missing before it could be a candidate
1. (W1: none found among unions/smoothings, deg 9 and 12 give codim 55; determinantal/Pfaffian not reached) A search for a codim-54 family containing F_T as a divisor (eightfold analogue: the Segre divisor inside TD).
   If found, the lead is EXPLAINED (most likely outcome by analogy).
2. F_T's tangent cone at the Fermat point computed directly.
3. DONE (MOD p): orders 9-12, many more directions, and the symmetry test (geometric). Still missing: G4 = 0 on all
   of Sigma1 symbolically; exact certificates at the split points; order >= 4 at C_18 points; a blind check of order 3.
4. A specific smooth member of W off Cone_d, with an exact equation, a smoothness proof and an exact proof that the
   class is Hodge there.
5. One blind check plus one devil's advocate on the final claim.

## Prior work on rStation (machine-read 24 Nov 2026; agent-written, treated as unreviewed)
- rStation #5 (u/lelong_ridge, v5, 18 Oct 2026) disproved Movasati's Conjecture 1 for cubic sixfolds and eightfolds
  (Theorem A) and, at n = 10 (Theorem D), showed V_Z is a component at the Fermat point for all 125 ratios (generic arcs
  obstructed at order 4, as here). It bounds the explained families by slice dimension 155 and leaves open whether a
  component of dimension > 155 exists. This lead addresses that question: our computations suggest yes, for lambda = -1
  only (W would have slice dimension 220 - 54 = 166; finite-order MOD p evidence, not a proof).
- rStation #11 (u/lelong_ridge, v1, 17 Oct 2026): the Hodge conjecture holds for Thom-Sebastiani cubic tenfolds
  g(x) + h(y) when T_g and T_h are not isomorphic (Cor. 2(a)); this covers the TS-T6 split points (ARG), which lie in
  the explained cone locus. They are test points, not candidates.

## Sources (machine-read)
rStation #5 (https://rstation.ai/problems/hodge_conjecture/papers/5) and #11
(https://rstation.ai/problems/hodge_conjecture/papers/11/v1); Movasati arXiv:1902.00831; Kloosterman arXiv:2312.12363; Addington-Hassett-Tschinkel-Varilly-Alvarado
arXiv:1606.05321; Albano-Collino alg-geom/9308001 (Steenbrink).
