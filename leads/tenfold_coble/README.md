# Scripts behind leads/TENFOLD_COBLE_LEAD.md (25 Nov 2026)

AI-written (Claude Fable 5.2), unreviewed; not part of the package; not covered by CI. Macaulay2 1.22, no other
dependency, no absolute paths. Run from this folder. Each script prints its pre-registration in its header comment.
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

Conventions: variables z_i, p_i, q_i (i mod 3); h_lam(v) = v0^3+v1^3+v2^3+3 lam v0v1v2;
M_x = sum_{i,j} z_{i+j} x_{i-j} p_i q_j; the family is a h_lam(z) + h_lam(p) + h_lam(q) + M_x with
a = -h_lam(x)/(27(1+lam^3)). In the k-scripts the pairing is << S (x) T >> = div(S) pi(T) - pi(S) div(T) (units of
one elliptic period), with the reduction rule gamma(A dh/dp_i) = gamma(dA/dp_i).

`blind_check/`: the blind checker's own scripts (written from the definitions only, without seeing the scripts above),
copied as-is; some contain absolute paths from its working folder (`/home/claude/blind_check`): adjust before running.
Its report is summarised in the registry entries D-TENFOLD-COBLE-FAMILY and D-TENFOLD-PRODUCT-POINTS.
