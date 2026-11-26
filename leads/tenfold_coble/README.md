# Scripts behind leads/TENFOLD_COBLE_LEAD.md (25 Nov 2026)

AI-written (Claude Fable 5.2), unreviewed; not part of the package; not covered by CI. Macaulay2 1.22, no other
dependency (except s2_arc_orders.m2, see the table), no absolute paths. Run from this folder. Each script prints its pre-registration in its header comment.
Times are for one core.

| Script | What it tests | Command | Time |
| --- | --- | --- | --- |
| c1_general_point.m2 | first order at a general point of F_T in 9 variables: rank 54; "third determinant" hypothesis (false) | `M2 --script c1_general_point.m2 32003 1` | 20 s |
| c1b_graded_completion.m2 | shape of the extra direction with a mu_3-graded completion | `M2 --script c1b_graded_completion.m2 32003 1` | 3 s |
| d1_cubic_model.m2 | cubic model at product points: Hessian corank 11 at Hesse tensors | `M2 --script d1_cubic_model.m2 32003 1` | 2 s |
| k1_rank_one_vanishing.m2 | period identity K1 on rank-one forms, to degree 3m | `M2 --script k1_rank_one_vanishing.m2 32003 2 6` | 45 s |
| k2_rank_two.m2 | rank-two values; dependence on the adjugate | `M2 --script k2_rank_two.m2 32003 5 4` | 3 s |
| k3_exponential.m2 | period identity K3 (exponential of a cubic) | `M2 --script k3_exponential.m2 32003 7 4` | 5 s |
| s1_closed_form_c.m2 | closed form of the cubic c over QQ(lam) (EXACT) | `M2 --script s1_closed_form_c.m2` | 1 s |
| n1_candidate_family.m2 | N1-N4 for the family, MOD p; mode `coble` or `ft` | `M2 --script n1_candidate_family.m2 32003 1 coble` | 20 s |
| n1_candidate_family_exact.m2 | the same over QQ (EXACT) | `M2 --script n1_candidate_family_exact.m2 1 coble` | 7 min (coble), longer (ft) |
| p4b_theta_planes.m2 | a 4-plane in a general member, its curve in Sing, h^0 of its normal bundle | `M2 --script p4b_theta_planes.m2 32003 1` | 2 s |
| p4c_ft_planes.m2 | the 4-planes of V at a point of F_T; components of Sing | `M2 --script p4c_ft_planes.m2 32003 3` | 15 s |
| h1_nodal_section.m2 | hyperplane sections through the P^8: 72 nodes, one relation on quartics; mode `coble` or `ft`; 5th argument `full` for the Jacobian on P^10 | `M2 --script h1_nodal_section.m2 32003 1 coble` | 10 s (full: 3 min) |
| h2_same_ruling.m2 | two 4-planes through common points of A: line, same ruling of the tangent cone | `M2 --script h2_same_ruling.m2 32003 2` | 2 s |
| h3_ft_limit.m2 | at F_T every class supported on the section is a multiple of [V]_prim | `M2 --script h3_ft_limit.m2 32003 1` | 2 s |
| h4_ladder_inputs.m2 | 18 and 36 nodes one and two levels down; Y ∩ P^5 smooth; projection of A from a point of A has degree 17 | `M2 --script h4_ladder_inputs.m2 32003 1` | 6 s |
| h5c_cycle_sampling.m2 | sampled points of the explicit cycle Z_a ∩ P^4: degree 12, genus 2 | `M2 --script h5c_cycle_sampling.m2 32003 1 260` | 1.5 min |
| s2_arc_orders.m2 | orders 2 and 3 of the Hodge condition along the explicit arc at a point of F_T (uses `../tenfold_session_scripts/so_t6/solib.m2`, `so3_t6/o3lib.m2`); mode `T` or `N`; 4th argument `3` for order 3 | `M2 --script s2_arc_orders.m2 32003 1 T 3` | 4 min (order 2), 36 min and 2.7 GB (order 3) |
| pf1_section.m2 | control on the coefficient +1: Pfaffian cubic in P^8, its K3 surface, 56 nodes and their relation, the algebra; 3rd argument `full` for the Jacobian on P^10 | `M2 --script pf1_section.m2 32003 1` | 7 min (full: +3 min) |
| pf2_cycles.m2 | the del Pezzo 5-fold and the degree-7 5-fold, their rulings at a point of the K3, intersection numbers 13 / 21 / 7 on the cubic fourfold | `M2 --script pf2_cycles.m2 32003 1` | 5 s |

`PREREG_step1.md`, `PREREG_step2.md`: the pre-registrations of the h- and s-scripts, written before the runs and kept
as written (they include one prediction made mid-way, the ladder, and note which attempts gave nothing).

Conventions: variables z_i, p_i, q_i (i mod 3); h_lam(v) = v0^3+v1^3+v2^3+3 lam v0v1v2;
M_x = sum_{i,j} z_{i+j} x_{i-j} p_i q_j; the family is a h_lam(z) + h_lam(p) + h_lam(q) + M_x with
a = -h_lam(x)/(27(1+lam^3)). In the k-scripts the pairing is << S (x) T >> = div(S) pi(T) - pi(S) div(T) (units of
one elliptic period), with the reduction rule gamma(A dh/dp_i) = gamma(dA/dp_i).

`blind_check/`: the blind checker's own scripts (written from the definitions only, without seeing the scripts above),
copied as-is; some contain absolute paths from its working folder (`/home/claude/blind_check`): adjust before running.
Its report is summarised in the registry entries D-TENFOLD-COBLE-FAMILY and D-TENFOLD-PRODUCT-POINTS.

`blind_check2/`: the second blind checker's scripts, logs and unedited report (REPORT.txt) for section 10 of the lead
note (nodes, defect, rulings, sections, the mathematics of the two arguments, order 2 with its own implementation of
psi). Copied as-is; absolute paths `/home/claude/blind_check2`. `logs_step12/`: the outputs of the h- and s-scripts
quoted in section 10.
`PREREG_k3.md`, `logs_k3/`, `blind_check3/`: pre-registration, outputs and the third blind checker's scripts and
unedited report for section 11 (the Pfaffian / K3 control).
`exact_member/`: a named member over QQ with its certificate (section 12 of the lead note); it has its own README.
`blind_check4/`: the fourth blind checker's scripts, logs and unedited report for that certificate (one 2.6 MB data
file of its run was left out).
`fermat_point/`: the Coble family at the Fermat cubic tenfold (section 13 of the lead note): a correction (which class
the family carries there), a proof on a symmetric 3-parameter family, and explicit arcs with no symmetry in the
repository's Fermat engine; it has its own README and a three-part pre-registration.
`blind_check5/`: the fifth blind checker's scripts, logs and unedited report for section 13.
`plane_test/`: the intersection count of section 14 (a 5-plane against the 4-plane cycle: 8 points, not 4): pre-registration,
script, logs of 8 runs.
`blind_check6/`: the sixth blind checker's scripts, logs and unedited report for section 14.
`pairing/`: why the coefficient +1 goes with a K3 surface and -1 with an abelian surface (section 15): pre-registration,
seven scripts (rungs, Enriques, bielliptic, the node identity, the class as a functional, the sign test, the K3 cover), logs.
`blind_check7/`: the seventh blind checker's scripts, logs and unedited report for section 15.
The node mechanism of sections 10-12 is packaged as a tool with regression tests in `tooling/node_section/`.
