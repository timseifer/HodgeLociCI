# Step 2 pre-registration (written 25 Nov 2026, before running s2_arc_orders.m2)

Arc inside the candidate family through a point X_0 of F_T (x on the curve h_lam(x) = 0, a = 0), lam fixed, w-part fixed:
   x(t) = x + t dx,  a(t) = -h_lam(x + t dx)/(27(1+lam^3)) = t a1 + t^2 a2 + t^3 a3   (exact, a cubic polynomial in t)
   F_t = F + t A + t^2 g2 + t^3 g3,   A = M_dx + a1 h_lam(z),  g2 = a2 h_lam(z),  g3 = a3 h_lam(z).
Hodge condition for the flat continuation of [V] along the arc, expanded in t (pi, psi, psi3 = periods of [V] with pole
orders 6, 7, 8; previous agent's engine so_t6/solib.m2 + so3_t6/o3lib.m2, used unchanged):
   E1: pi(Q A) = 0                                   for all Q in S_3
   E2: pi(Q g2) = 3 psi(Q A^2)                       for all Q in S_3   (364 equations)
   E3: pi(Q g3) = 6 psi(Q A g2) - 7 psi3(Q A^3)      for all Q in S_3   (364 equations)
(derivation: 1/F_t^5 = F^-5 - 5 F^-6 (tA + t^2 g2 + t^3 g3) + 15 F^-7 (tA + t^2 g2)^2 - 35 F^-8 t^3 A^3 + ...)
The previous agent tested only solvability of E2, E3 for SOME g2, g3. Here g2, g3 are prescribed, so E2 and E3 are
exact identities to be tested, with no freedom.

Outcomes:
 - E2 holds for transversal dx (leaving F_T) and for tangent dx: the explicit family stays in the Hodge locus of [V]
   to second order, as the cycle argument predicts. Evidence, not proof.
 - E2 fails: the family as written is NOT in the Hodge locus beyond first order (wrong relation between a and x at
   second order, or the class on the family is not the continuation of [V]). That would contradict Step 1.
 - Controls, expected to FAIL E2: a2 -> 2 a2; a2 -> 0 (if they pass, the test has no power: h_lam(z) would be in T NL).
 - E3 likewise at third order; control a3 -> 0 or 2 a3 expected to fail.
