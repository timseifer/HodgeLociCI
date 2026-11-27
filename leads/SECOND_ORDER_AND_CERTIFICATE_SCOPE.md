# What the second-order checker takes from paper 3, and what each Fermat certificate covers (plan item B9)

27 Nov 2026, Claude Opus 5.5. AI-written, unreviewed. Paper 3 is itself AI-written and unreviewed
(papers/paper3.tex, papers/paper3_general_rule.pdf, frozen; papers/README.md).

## 1. Statements of paper 3 used by `secondOrderObstruction` (from M2/HodgeLociCI/SecondOrderDoc.m2)

| statement of paper 3 | what the code uses it for |
| --- | --- |
| Lemma 2.1(3): the pointwise second-order period functional of a complete intersection | both strategies ("Jacobian", "Residue") compute this functional; neither is an independent check of the lemma |
| Theorem 2 (first order; lambda_0 = (-1)^(c-1), level tau, excess e_tau) | which coefficients need a second-order computation at all |
| Theorem 8.1 | the second-order obstruction is a non-zero quadratic form at the point (cited at the example) |
| Theorem 9.1(3) | the quantity rho(N N' tr(Mdot adj M)) - D_vdot(N N' det M) returned by the helper equals the second-order term |
| Corollary 9.2(2) | the second-order term vanishes at lambda_0 (found exactly by the code) |
| Corollary 9.3 | "ALL DIE" = the quadrics have no common zero: every excess direction is obstructed at second order |
| Remark 10.3(iii) | hand values for a line, used as a test |

So every verdict of `secondOrderObstruction` is as strong as these statements: MOD p arithmetic at one instance plus
an AI-written, unreviewed proof. The helper nodes say this; the summary above is for readers of the rStation draft.

## 2. Scope of each Fermat certificate in M2/HodgeLociCI/data/

| file | what it certifies | one arc or every arc with its first terms |
| --- | --- | --- |
| cert_n6_lam-1, cert_n6_lam2, cert_n6_lam5o3 | periods vanish to order 4 along the given T_1..T_4; the order-5 vector is not in the image of L (left-kernel vector K with K.c_5 != 0) | ONE arc (the T_2..T_4 written in the file). The conclusion "no component of dimension dim V + 1" (D-FERMAT-CERTIFICATES-*) uses an extra argument: such a component would be the smooth germ with tangent space ker L, and every jet in ker L would extend; this needs condition (ii) (V smooth with the expected tangent space), not verified by any checker |
| cert_n8_lam-1, cert_n8_lam2, cert_n8_lam5o3 | the same at order 4 on the eightfold | ONE arc, same remark |
| x1_lam2_obstruction | order 5 at X1, lambda = 2 | EVERY arc with this T_1 (claim 4: K.c_5 does not change when T_2..T_4 are replaced by any other terms that keep orders 1..4) |
| x1_lam-1_arc, six_lam-1_arc, six_lam2_arc | arcs (no obstruction) to order 9 | n/a; note that six_lam-1_arc's T_8, T_9 are not on the continuing arc (D-RANK-CONTRAST-EXACT-ARCS conditions, D-SIXFOLD-ARC-ORDER19) |

Wording checked: README.md (line ~398), docs/04_fermat_certificate.md and FermatDoc.m2 (line ~846) already say that an
obstruction found by `fermatExtendArc` is for the arc built, not for every arc. No wording found that claims more for
the n6 / n8 certificates; their registry entry states the extra argument and its condition explicitly.
Related, from this week: obstruction verdicts of the slice solver at order >= 7 can be false
(N-SLICE-FALSE-OBSTRUCTION-ORDER7); order-6 verdicts used on the headline card were confirmed in the full space.
