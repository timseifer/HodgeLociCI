# The Coble family at the Fermat cubic tenfold (lead note, section 13)

AI-written (Claude Fable 5.2, 25-26 Nov 2026), unreviewed. Read `PREREG_fermat.md` first: it was written in three
parts, each before the runs it describes, and is kept as written. Results: `../../TENFOLD_COBLE_LEAD.md`, section 13.
Nothing here is a statement about the Hodge conjecture.

Coordinates: r_k = x_(2k), y_k = x_(2k+1), p_i = x_(6+2i), q_i = x_(7+2i). The three-plane class is
h^5 - P1 - P2 - P3 for the three 5-planes {r_k + y_k = 0, p_i = zeta q_i}, zeta^3 = -1.

| file | what it does | label |
|---|---|---|
| `fp_lib.py` | closed-form Fermat periods on Q * M^n for a 9-term trilinear M (own code) | - |
| `fp_main.py exact N` | period equations of the three-plane class along F_0 + tau M_x, identically in x | EXACT |
| `fp_main.py classes N p`, `classes55 N p` | all 924 eigenclasses: first order, controls, the classes that stay in F^5, resp. of type (5,5) | MOD p |
| `fp_main.py perturb N p` | control: one coefficient of M_x changed | MOD p |
| `fp_diag.py N` | control K4: which vanishing sums are forced by a symmetry | EXACT |
| `b_membership.m2` | X_x cut by r = -theta y is the Coble normal form; singular surface of degree 18 | EXACT + MOD p |
| `t_invariants.py` | invariant part of the cohomology under the group of order 162: Hodge numbers (0,1,10,1,0) | EXACT |
| `t_ks_grid.py` | (P - Q) dM/dx_d lies in the Jacobian ideal for generic x, without Groebner bases | EXACT |
| `t_ks_points.m2` | the same identity at three rational points x, by Groebner bases over QQ | EXACT |
| `t_ks.m2` | the same over QQ(x) by a Groebner basis; did NOT finish in 25 minutes; kept for the record | - |
| `fp_engine.py gate / ref` | validity gate for the repository's engine on arcs outside its squarefree slice | MOD p |
| `fp_engine.py arcs / arcsl`, `run_arcs.sh`, `run_arcsl.sh` | the arcs H and H' with no symmetry, and their controls | MOD p |
| `fp_engine.py kernel` | all 924 eigenclasses along the arc H': which combinations survive to order n (only the three-plane class, from order 5) | MOD p |

`fp_engine.py` uses `tooling/fermat_series` (the previous agent's compiled kernel) unchanged, replacing only its
table of plane coefficients; it builds `libfsc.so` in `/tmp/fsc_build` (override with `FSC_SO_DIR`).

Notes on the logs. `logs/gate_first_sparse_version_*.log`: the first version of the gate used coordinate changes
with 3 + 2 entries; at one seed the sign-flipped control did not fail up to order 5 (the arc was too degenerate), so
the gate arcs were made denser (5 + 3 entries) before anything else was run. `logs/*first_look*`: first runs of
each kind, kept. `logs/kernel_first_run_with_a_normalisation_bug_*`: my first replication of the checker's
"which classes survive" run dropped a factor 3^(-m) that is not common along these arcs; kept, superseded by
`logs/kernel_p*`. `logs/classes_N10_*`: the version of the all-classes scan without the conjugate conditions (the
space it reports, of dimension 298, is "stays in F^5", not "stays of type (5,5)"; see `classes55`).
