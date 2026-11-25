# Step 1 pre-registration (written 25 Nov 2026, before any of h1-h4 was run)

Aim: replace the ARG "the 4-plane cycle Z_Theta has a non-trivial primitive class" by a short topological argument
whose computable inputs are tested here.

Argument to be tested (ARG until checked):
 (i)   X in the family, H a general hyperplane containing the P^8. X9 = X ∩ H is singular exactly at
       Sigma = A ∩ {Psi_1 = Psi_2 = 0} (72 points), with nodes there (Psi_i = restrictions of dF/dt_i).
 (ii)  For a node p, H_10(X9, X9 - p; Q) = Q. A smooth 5-fold germ through p inside X9 has tangent space a maximal
       isotropic 5-space of the node's quadric; its local class is +1 or -1 according to the ruling.
       Lefschetz: H_10(X9 - Sigma) = Q (linear sections). So a 5-cycle with a non-zero local class at a node is NOT a
       rational multiple of the linear section class in H_10(X9).
 (iii) Z_Theta has two smooth branches at a general point p of A (the 4-planes P^4_x, x in Theta_a ∩ Theta_p), with
       tangent 5-spaces span(P^4_x, T_pA). They are in the same ruling (the planes through p form a connected family
       over Theta_p). So the local class of Z_Theta at each node is +-2.
 (iv)  H_10(X9) -> H_10(X) is injective (complement of a hyperplane section with isolated singularities; LIT to be
       checked: Siersma-Tibar 1995 / Parusinski 1995, bouquet theorem; here no singularities at infinity jump).
 =>    [Z_Theta] is not a multiple of h^5 in H^10(X; Q).

Tests and what each outcome means:

H1 (nodes). Random member, random Psi_1, Psi_2: Sigma = Sing(Y) ∩ {Psi_1 = Psi_2 = 0}.
   - dim 0, degree 72, radical; and for a random completion f on P^10 the Jacobian ideal of f has degree 72:
     the only singularities of X ∩ H are 72 nodes on A. Step (i) holds in the tested instance.
   - Jacobian degree > 72: extra or worse singularities; (ii)-(iv) do not apply as written. Stop and rethink.
H2 (defect; consistency test of the whole argument, uses Dimca's formula, LIT):
   defect = 72 - HF_Sigma(4). Prediction 1 (Cayley-Bacharach on a surface with K = 0: 4H = K + 2H + 2H).
   - HF = 71: b_10(X ∩ H) = 2: exactly one extra class, as (iii) requires (>= 1) and dim A_6 = 1 allows (<= 1).
   - HF = 72: no extra class in H_10(X ∩ H): contradicts (ii)+(iii). Then the argument is wrong somewhere.
   - HF <= 70: two or more extra classes: contradicts the bound from dim A_6 = 1. Then something is wrong.
   Control: for a smooth cubic 7-fold section there is no Sigma; for random 72 points HF(4) = 72.
H3 (rulings). P = the iota-invariant 4-plane of p4b; g = an automorphism of the cubic (index shift). dim (P ∩ gP):
   - exactly a line (and it meets A in a length-2 scheme): same ruling at the common points of A, local classes add.
     (If the rulings differed, span(P,T_pA) ∩ span(gP,T_pA) would be a P^4 and P ∩ gP would contain a plane.)
   - a plane or more: different rulings, local class 0: Z_Theta would NOT carry the class. The class on the family
     would then be a Hodge class supported on the nodal section with no cycle known for it.
   - a point, or gP = P: g unsuitable; no information; try another g.
H3b (direct). At a common point p of P and gP on A: dim of span(P, T_pA) ∩ span(gP, T_pA) = 3 (projective) for the
   same ruling, 4 for different rulings; and both spans lie in the tangent cone of Y at p (rank 6).
H5 (limit at F_T). B = k[z,p,q]/(Jac F_8, Phi) at a point of F_T: dim B_6.
   - 1: every (5,5) class supported on the section is a multiple of [V]_prim there, so the limit of the class on the
     family is a non-zero rational multiple of [V]_prim and the family lies in the Hodge locus of [V].
   - > 1: the limit lives in a bigger space; the identification with [V] then needs the local classes at F_T.
   Also at F_T: number and type of singular points of the hyperplane section (prediction 72 + 4 = 76 nodes) and the
   defect 76 - HF(4) (prediction >= 1).

## Addendum (25 Nov 2026, written before h4 was run): the ladder, a second argument that does not use (iv)

Blow-up formula (ARG, to be re-derived by the checker). X smooth of dimension 2m, X' = X ∩ H with nodes Sigma only,
Z, Z' cycles of dimension m inside X', X'' = X' ∩ H' a general (smooth) hyperplane section:
     Z.Z' (on X) = (Z∩H').(Z'∩H') (on X'') - (-1)^(m-1) * sum_{p in Sigma} n_p(Z) n_p(Z'),
n_p = (sheets in ruling A) - (sheets in ruling B) of the projectivised tangent cone at p.
Applied three times (tenfold / 72 nodes, eightfold / 36 nodes, sixfold / 18 nodes) down to the smooth cubic fourfold
X_4 = Y ∩ P^5 and the ruled surface S = Z ∩ P^5:
     Z.Z (tenfold) = S.S - 18 n^2 + 36 n^2 - 72 n^2 = S.S - 54 n^2      (n = common absolute value of the local classes)
Known case (test of the formula): V at F_T, S = T (C18 scroll, T.T = 18, LIT), n = 1 at the 72/36/18 nodes on the
degree-18 component, local class 0 at the nodes on the plane (they impose independent conditions): 18 - 54 = -36,
which is the registry's [V]^2 = -36.
For Z_Theta: n = 2; S = ruled surface over a genus-2 curve, degree d = 12, sectional genus 2; S.S = 3d + 2 + 2 delta,
delta = number of double points = number of secant lines of A through a fixed point a of A meeting a P^5
      = degree of the projection of A from a = 17 (prediction).  So S.S = 72 and Z.Z = -144, while (4 h^5)^2 = 48.
     => [Z_Theta] != 4 h^5; and -144 = (2[V])^2 with degree 12 = deg(2[V]): consistent with [Z_Theta] = 2 [V].

h4 tests the numerical inputs:
 L1: Y ∩ P^6 has exactly 18 nodes (Jacobian degree 18) and they fail by one to impose independent conditions on
     quadrics (HF(2) = 17).   Other values: the ladder count is wrong at the sixfold level.
 L2: Sing(Y) ∩ P^7 ∩ quadric = 36 reduced points, HF(3) = 35.
 L3: Y ∩ P^5 is a smooth cubic fourfold.
 L4: the projection of A from a point of A has degree 17 (so delta = 17).  16 or less: delta differs, S.S differs,
     and then Z.Z = 3d - 180 + 2(delta - 17); it equals d^2/3 = 48 only for delta = 113, so the conclusion
     [Z_Theta] != 4 h^5 survives any small change, but the identification with 2[V] would not.

## Addendum 2 (before h5): the cycle made explicit
For a rational point a of A, Z_a = union of the 4-planes of Y through a (= Z_Theta for the theta curve of planes
through a). ARG: Z_a lies in Y ∩ Q_a ∩ {G = 0}, Q_a = tangent cone of Y at a, G(y) = l^T adj(B) l (degree 5), where on
T_aA = <v1, v2>:  B_ij = v_i^T Hess F(y) v_j / 2,  l_i = v_i . grad F(y)  (the residual quadric of Y ∩ span(T_aA, y)
is reducible).  h5 decomposes Y ∩ Q_a ∩ {G = 0} ∩ P^5 (a surface of degree 30).
 M1: there is a component S of degree 12 with sectional genus 2 (Hilbert polynomial 6 n^2 + ... with a hyperplane
     section of arithmetic genus consistent with a genus-2 curve plus the nodes).  No such component: the description
     of Z_a is wrong, or deg Z_Theta != 12 (then the Chern-class count c_1 = -6 Theta is wrong).
 M2: Sing(S) is 17 reduced points (delta = 17, so S.S = 38 + 34 = 72 by the double point formula).
     Another number delta': S.S = 38 + 2 delta'.
 M3 (falsification test): with J = Jacobian ideal of the cubic fourfold X_4 = Y ∩ P^5, dim (S_3/(I_S + J)_3) >= 1.
     If it is 0, then [S] = 4 h^2 and the ladder gives [Z_Theta]^2 = 48 - ... contradiction with M2; the claim dies.

## Addendum 3 (before the long h5c run; h5 and h5b, decompositions, did not finish and gave nothing)
h5c samples rational points of C = Z_a ∩ P^4 (a rational, random P^4): for random rational tangent directions tau at
a, the fibre {F = Q_a = l_tau = b_tau = 0} ∩ P^4 is 12 points; those whose fibre has tangent space inside Y lie on the
two 4-planes through the tangent line. Prediction (deg Z_Theta = 12, sections of genus 2): the Hilbert function of
the sampled points stabilises at 12 d - 1 (differences 12) for d >= 4 or so, once there are more points than 12 d.
 - differences 12 and constant term -1: degree 12, arithmetic genus 2: agrees with c_1 = -6 Theta.
 - another slope: deg Z_Theta is that slope; the ladder then reads Z.Z = 3 d + 2 + 34 - 216 (never d^2/3).
A 30-direction trial run (to test the script) was done before this was written: 30 points, 2 per direction when
rational; ranks 14 / 29 / 30 in degrees 2 / 3 / 4 (too few points to see the slope).
