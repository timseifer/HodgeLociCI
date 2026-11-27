# Frozen prediction for quartics, (d, c) = (4, 2) (plan item C10). Committed before any quartic computation of this
# item and before reading Kloosterman, Section 6 / Cor. 6.2 in detail. NEVER EDIT THIS FILE; corrections go elsewhere.

Written 27 Nov 2026, 08:12 UTC, Claude Opus 5.5. AI-written, unreviewed. What I knew before writing: the
registry's machine-read summary that Kloosterman singles out -1 for (d, c) = (4, 2) and +1 for (3, 3), and the cubic
mechanism of headline card 2 (D-NODES-DISCRIMINANT-IDENTITY, D-TENFOLD-K3-ABELIAN-PAIRING).

## 1. The mechanism generalised to degree d (ARG; derivation in section 4)

X smooth of degree d in P^(2k+1), H a hyperplane, V = X n H, Sigma in V a smooth k-fold of degree m with finitely many
singular points of V on it, N of them counted with multiplicity. Then
    (N-identity)   d (Sigma.Sigma)_X - m^2 = (-1)^k (d - 1) N,
i.e. disc <h^k, [Sigma]> = (-1)^k (d - 1) N. For d = 3 this is the registry identity (factor 2).
    (relation degree)   K_Sigma + det(N^v_(Sigma/H)(d)) = O(k (d - 2) - 1),
so the residue theorem gives one relation among the N nodes on forms of degree k(d - 2) - 1 (for d = 3: k - 1).
Linear spaces: two k-planes meeting in P^m have P1.P2 = f_d(m) = [(1 + x)^(m+1) / (1 + d x)]_(x^m)
= (1 - (1 - d)^(m+1)) / d; P.P = f_d(k).

## 2. Numbers for (d, c) = (4, 2), m = k - 2 (EXACT arithmetic)

disc <h^k, r P1 + s P2> = 4 (r^2 + s^2) f_4(k) + 8 r s f_4(k - 2) - (r + s)^2:
- k = 2 (quartic fourfold, two planes meeting in a point): 27 r^2 + 6 r s + 27 s^2; lambda = -1: 48 -> N = 16;
  lambda = +1: 60 -> N = 20. Relation degree 3.
- k = 3 (quartic sixfold, two 3-planes meeting in a line): -(81 r^2 + 18 r s + 81 s^2); lambda = -1: -144 -> N = 48;
  lambda = +1: -180 -> N = 60. Relation degree 5.

## 3. Predictions (what counts as failure)

P1. The N-identity holds for d = 4 at instances: a plane P (m = 1) in a hyperplane section of a quartic fourfold has
    N = 9 nodes on it (so P.P = 7); a smooth quadric surface (m = 2) has N = 12 (so Sigma.Sigma = 10). A different
    count at a general instance: FAILURE of the generalised identity.
P2. The special coefficient for (4, 2) is -1 (consistent with the registry's reading of Kloosterman), and the
    geometry behind it, if it is the analogue of the cubic one, consists of hyperplane sections with N = 16 nodes
    (k = 2) / 48 nodes (k = 3) carrying exactly one relation on forms of degree 3 / 5 -- for k = 2 a 16-node quartic
    surface configuration (Kummer type) is the natural candidate. FAILURE: if the special coefficient's mechanism, as
    found in Kloosterman Section 6 or by computation, involves a node count other than 16 / 48, or a relation in
    another degree.
P3. lambda = +1 for (4, 2) would need 20 / 60 nodes; prediction: no such configuration appears at general points.
    FAILURE: excess at +1 at a general point.

## 4. Derivation of the N-identity (ARG)
c(N_(Sigma/X)) = c(N_(Sigma/H)) (1 + h) / (1 + d h); N = c_k(N^v_(Sigma/H)(d h)) = sum_j (-1)^(k-j) d^j e_(k-j) h^j
(e_i the elementary symmetric functions of the Chern roots of N_(Sigma/H)); m^2 = c_k(N_(Sigma/H)) = e_k;
Sigma.Sigma = e_k + sum_(j>=1) (1 - d)(-d)^(j-1) e_(k-j) h^j. Then d Sigma.Sigma - m^2 = (d - 1) sum_j (-d)^j e_(k-j) h^j
= (-1)^k (d - 1) N. Relation degree: K_Sigma = (-(2k+1) h + det N_(Sigma/H))|_Sigma and det(N^v(d)) = -det N + k d h.
