# tests/data/fermat: provenance of the data files (agent PB, 22 Nov 2026)

All files here are byte-identical copies of files written earlier in this session by AI agents (team T3 of the discovery
phase). Nothing was edited. `SHA256SUMS` lists the checksums of the copies. Identical copies of the ten data files (not of
the READMEs) are in `M2/HodgeLociCI/data/`, because Macaulay2 installs that directory with the package and the TEST blocks
and documentation examples read the files from there (`HodgeLociCI#"auxiliary files" | "data/"`).

| file here | copied from (in the session workspace, not in this repository) | what it is |
|---|---|---|
| `README_export_c3.txt` | `discovery/t3_window/export_c3/README.txt` | the specification: normalisation of the periods, rules (1)-(5), how to read the certificate files |
| `cert_n6_lam-1.txt`, `cert_n6_lam2.txt`, `cert_n6_lam5o3.txt` | `discovery/t3_window/export_c3/` | obstruction certificates of order 5, Fermat cubic sixfold, Movasati's two 3-planes, lambda = -1, 2, 5/3 |
| `cert_n8_lam-1.txt`, `cert_n8_lam2.txt`, `cert_n8_lam5o3.txt` | `discovery/t3_window/export_c3/` | obstruction certificates of order 4, Fermat cubic eightfold, two 4-planes meeting in a line |
| `README_export_x1.txt`, `README_export_x1_round4.txt` | `discovery/t3_window/export_x1/README.txt`, `README_round4.txt` | description of the files below (pair X1 on the cubic eightfold) |
| `x1_lam-1_arc.txt` | `discovery/t3_window/export_x1/` | an exact arc with 7 terms, lambda = -1: all 45 period functions vanish to order 7 |
| `x1_lam2_obstruction.txt` | `discovery/t3_window/export_x1/` | an arc to order 4 and an obstruction at order 5, lambda = 2 |
| `six_lam-1_arc.txt`, `six_lam2_arc.txt` | `discovery/t3_window/export_x1/` | sparse exact arcs with 9 terms (order 9), eightfold reading |

How the files were produced and checked before this phase: `discovery/t3_window/cert.py`, `cert_x1.py` (exact, python-flint)
produced them; blind checkers re-derived them with their own code (`discovery/checks/c3/` for export_c3, `discovery/checks/c11/`
and `discovery/checks/c18/` for export_x1). No human has reviewed the files, the producing code or the checking code.

What the package does with them (`M2/HodgeLociCI/FermatTests.m2`): `fermatVerifyCertificate` re-computes, in Macaulay2 and in
exact arithmetic over QQ(zeta_6), every numerical claim of the files (vanishing of the coefficients of eps^1..eps^M for all
forms, the listed coefficients of eps^N, the listed functionals K with K.L = 0 and the listed nonzero K.c_N, the ranks, the
period polynomial). All ten files pass (measured 0.1 s to 6 s each). The package does NOT check the arguments by which the
READMEs draw geometric conclusions from these numbers ("why one arc suffices"; claim 4 of `x1_lam2_obstruction.txt`; the
Smith-form claims of `README_export_x1_round4.txt`), and it does not implement the sixfold reading or the invariant-factor
computations of round 4. Note that `README_export_x1.txt` itself records a WITHDRAWN argument (the restriction to the family
FF); the copy is kept unedited.

Hard-coded reference values in the tests that do not come from these files:
- four values of the period functional on monomials, from `discovery/checks/c3/lib.py` (`Periods.I`, literal pole-order
  reduction; blind checker's own code), run on 22 Nov 2026;
- three series `pi_eps(N)` from `discovery/checks/c18/eng18.py` (`Eng.series`, shift = 1), run on 22 Nov 2026;
- four values mod 30089 on the quartic sixfold from `discovery/t1_fake_linear/flc.py` (`Ctx(30089).phi_mono`), run on 22 Nov 2026.
