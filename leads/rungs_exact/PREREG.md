# Exact node counts for the K3 / abelian rungs (plan item B7). Pre-registered 27 Nov 2026, 08:27 UTC.
Over QQ with tooling/node_section (nodalDefect), one rational instance each:
- sixfold rung: Pfaffian cubic (6 x 6 skew matrix of linear forms with small integer coefficients) restricted to a
  rational P^6: expected 14 ordinary double points, defect 1 on quadrics. Coble member lam = -2, x = (8, 18, 1),
  a0 = 29 (D-TENFOLD-COBLE-PLANE-COUNT-EXACT) restricted to a rational P^6: expected 18, defect 1 on quadrics.
- eightfold rung: G|P^7 + t Psi(u, t), Psi a rational quadric in 9 variables: expected 28 (K3) / 36 (abelian)
  ordinary double points, defect 1 on cubics.
Any other number at these instances: report (a special instance can give more; rerun with another before reading
anything into it). MOD p versions of all four are in the registry (D-COBLE-RUNGS-SIXFOLD-EIGHTFOLD, the Pfaffian entry).

## Outcome (27 Nov, 09:36 UTC; re1.log): all four AS PREDICTED, EXACT over QQ at one rational instance each
sixfold rung: K3 14 ODP, 13 conditions on quadrics (defect 1); abelian 18 ODP, 17 conditions (defect 1).
eightfold rung: K3 28 ODP, 27 conditions on cubics (defect 1); abelian 36 ODP, 35 conditions (defect 1).
Not done: the tenfold rung (56 / 72) over QQ (11 variables; expected too slow for the Groebner engine over QQ).
