# The second matrix along T2's sixfold arc: where it stalls (note for an expert)

27 Nov 2026. AI-written (Claude Fable 5.2, Claude Opus 5.5), unreviewed. Everything below is floating point at
fixed eps on one arc, except item 1. Registry: D-SIXFOLD-ARC-ORDER19, D-ARC-SPLITTING-NUMERICAL,
N-MATRIX-RECOVERY-FIRST-ATTEMPTS, N-SECOND-MATRIX-THIRD-ROUTE; O-RECOVER-MATRICES-AND-LIMIT-OF-T (open).

The question. Team T2's statement (S): near the sixfold divisor D the second component W_(-1) of the Hodge locus of
[P1] - [P2] (Fermat sixfold, two 3-planes meeting in a point) is the closure of the cubics det A + det B. Along one
arc F_eps into D one wants A(eps), B(eps) with det A + det B = F_eps, and then the flat limit of the degree-9
threefold T. This would replace a paper chain by a computation, and by the cone map the same for eightfolds and
tenfolds (the headline card on two determinants rests on it).

What is known (labels in the registry).
1. The arc exactly to order 19 over QQ(zeta_6), unique in its nine-monomial slice (EXACT). F_eps = y5^3 + Phi_eps.
2. The class functional [P1] - [P2] transported along the arc, as an exact series to order 19.
3. The catalecticant Cat(2,2) has 12 + 6 + 18 singular values (units, 77 to 13.9 eps^2, truncation level). The
   cubics with all partials in its kernel form a 3-dimensional space (y5^3, F_eps, one more). Exactly two members
   besides y5^3 and the cone are killed by linear vector fields: G_A, G_B with G_A + G_B = F_eps, both
   = -+(2187/64) l^3 eps^-6 (1 + O(eps)), l the tangent hyperplane at P1 n P2 (NUMERICAL, four eps).
4. G_A: 8 vector fields forming sl_3 acting by the adjoint representation; an explicit matrix A with
   det A = G_A to 1.4e-40 relative after a coordinate correction (eps = 1/800, 170 digits); its 2 x 2 minors lie in
   the kernel of Cat(2,2).
5. G_B: 8 vector fields at eps = 1/800 (the 9th singular value is 0.99 eps^13, a factor 459 above the noise); at
   1/40 .. 1/100 the 9th is below the noise. Its fields are known to about 0.3 per cent, not enough to show they
   form sl_3, and the eigenvector matrix of a general element has condition number 1e11 .. 1e18.

Where it stalls.
- Lie-algebra route for G_B: precision. The 9th near-field is at eps^13 while the noise falls like eps^16, so the
  ratio improves only like eps^3; eps = 1e-6 (about 400 digits) would give 1e-10 for the fields.
- Correction route (B = -(A - Delta)): geometry. The tangent space of the determinantal cubics at G_A has rank 56
  but singular values spread over 31 orders of magnitude, and F_eps is 65 per cent outside it. So -G_B is not
  reachable from G_A by a small move: -G_B = G_A o g with g in GL_8 far from the identity, presumably a large
  element of the near-stabiliser of the cube l^3 times a small correction. Newton diverges; damped Newton stalls.
- Commuting-algebra route (T2's): the generator is nearly nilpotent (eigenvalues +-c eps^6); with order-19 series
  the eigen-split is resolved (it gives item 3), but it gives the nets only, not the matrices.

What an expert might try.
(a) An ansatz adapted to the cube: A = s(eps) (l I + eps N_1 + eps^2 N_2 + ...), possibly with fractional powers
    (T2 suggested weights l: 0, w: 1, y': 3/2 and a tridiagonal leading matrix), solved order by order in exact
    arithmetic, with B = -P A P^(-1) + ... and P to be found: the conjugation is invisible to det to leading order
    and is exactly the large group element above.
(b) A global solve for g in GL_8 with G_A o g = -G_B, using invariants of the near-cube normal form to fix the large
    part of g first (the leading terms of both summands in the basis l, then the next order).
(c) More precision for the Lie-algebra route (series to order ~30, or eps ~ 1e-6 with 400 digits).
Data to start from: leads/tenfold_twodet/matrices/results/mx4_eps800_fulldigits.json (G_A, G_B, F_eps, A to 165
digits), periods_deg4_order19.txt, arc_true_order19.txt.
