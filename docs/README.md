# Worked examples (docs/)

Written by an AI agent (PC); not reviewed by a human. Nothing here is, or bears on, a proof or disproof of the Hodge
conjecture. Each example is a real captured Macaulay2 1.22 session: the input is `sessions/NN_*.m2`, the captured
output `sessions/NN_*.out` is pasted unchanged into `NN_*.md` by `build_docs.py` (prose in `prose/`).

| file | topic | arithmetic |
|---|---|---|
| `01_excess_calculator.md` | the excess calculator on Movasati's cubic sixfold and eightfold cases (8 -> 7, 20 -> 19), and cases with shared equations of higher degree | degrees: EXACT; data: MOD p; Fermat point: EXACT over Q(zeta_6) |
| `02_level_dichotomy.md` | the level dichotomy tau < 0 / tau >= 0 on both sides; the range; a cubic tenfold outside the range | EXACT, MOD p |
| `03_second_order.md` | the second-order checker where excess directions die: cubic sixfold with 3-planes meeting in a line; Maclean's coplanar lines on a quintic | MOD p; EXACT over QQ |
| `04_fermat_certificate.md` | verifying a Fermat certificate exported by the research session; a corrupted file is rejected | EXACT over Q(zeta_6) |
| `05_tangent_codimension_two_determinants.md` | first-order tangent codimension of the Hodge locus of an explicit threefold on a cubic det A + det B | MOD p |

Regenerate everything (about 20 s), from the repository root: `python3 docs/build_docs.py --run`.
The sessions load the package from the repository (`../../M2/HodgeLociCI.m2`); nothing needs to be installed.
Vocabulary: Hodge locus, Noether-Lefschetz locus (the surface case), linear and complete-intersection cycles,
Hilbert function, Zariski tangent space, obstruction; "excess" and "level" are defined in example 1 and example 2.
