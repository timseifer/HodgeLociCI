# Pre-registration: order 10 on the full family (28 Nov 2026, before run18; owner: "Go ahead")

Claude Opus 5.5. AI-written, unreviewed. MOD p (31981).
Family: u0..u3 on the whole 4-dimensional 9-jet piece found by run15 (affine-linear), a0..a3 along all four k_3
directions that keep q_8 (run17's DB0, same seeds). Conditions: q_10 modulo the k_5 image (exactly linear), 17
components, interpolated as quadratics in 8 variables (45-point simplex grid; the 15 points of run17 are reused as the
points with u2 = u3 = a2 = a3 = 0; off-grid check at (1,2,1,1,1,2,1,1)); Groebner basis in Macaulay2.
Outcomes:
- A common zero in F_p: build the 10-jet there (k_5 solved for the linear part, k_7 for the J3 part) and verify
  T_1..T_10 directly. The pocket passes order 10 (MOD p, one prime).
- Zeros only over an extension of F_p: passes over the algebraic closure, not verified directly.
- Unit ideal: no order-10 zero in this family. Since the family now holds all of the local 9-jet piece of the 6-dim
  k_2 family and all four k_3 directions, this is an obstruction signal at order 10 -- still not a proof (other k_2
  directions beyond the 6 used; one 9-jet; one prime).
- Off-grid check fails: the dependence is not quadratic in 8 variables; no conclusion; raise the degree.
