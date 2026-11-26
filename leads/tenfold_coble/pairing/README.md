# pairing: why coefficient +1 goes with a K3 surface and -1 with an abelian surface

AI-written (Claude Fable 5.2, 26 Nov 2026), not reviewed by a mathematician. Lead note: `../../TENFOLD_COBLE_LEAD.md`,
section 15. Computations are MOD p (p = 32003 and 31991). Nothing here is a statement about the Hodge conjecture.

| file | what | time |
|---|---|---|
| `PREREG_pairing.md` | written before the runs: the theory (T1-T5), the predictions for R1-R4, and (sections 5, 6 and 7, each added before its first run) for R5, R6 and R7 | |
| `pr1_rungs.m2` | R1: node counts on sixfolds and eightfolds for +1 and -1, with `tooling/node_section` | 1 min |
| `pr2_enriques.m2` | R2: an Enriques surface of degree 16 in P^8, the pencil of cubics singular along it, 64 nodes, no relation | 20 s |
| `pr3_bielliptic.m2` | R3: a bielliptic surface of degree 18 in P^8 is not the singular locus of a cubic; controls: K3, abelian | 1 min |
| `pr4_identity.m2` | R4: the identity "discriminant = +-2 x nodes" by direct node counts on five classical examples | 10 s |
| `pr5_tangent.m2` | R5: the class as a functional built from the relation among the nodes; Hilbert function of its Gorenstein algebra; five controls and two new cases | 2 min |
| `pr6_signs.m2` | R6: the relation among the nodes has coefficients +- 1/sqrt(Hessian determinant): g^2 D constant in seven cases, with a negative control | 2 min |
| `pr7_enriques_twisted.m2` | R7: on the K3 cover of the Enriques surface the 128 points over the nodes have one relation on octics, and it is anti-invariant (ranks 64 / 63) | 10 s |
| `run_pr1.sh`, `run_rest.sh`, `run_pr6.sh` | the runs at both primes | |
| `logs/` | all logs; `logs/first_version/` holds the logs of three false starts (below) | |

Usage: `M2 --script <file> p seed` from this folder (Macaulay2 1.22).

Results in one table (the same at both primes):

| run | prediction | result |
|---|---|---|
| R1 (a)-(e) | 14 / 28 / 18 / 36 / 36 nodes, one relation each | as predicted |
| R2 Enriques | cubics exist (pencil), 64 nodes, no relation | as predicted |
| R3 bielliptic | none (two-sided) | no cubic singular along it |
| R4 | 36, 14, 12, 10, 8 nodes | as predicted |
| R5 controls | 7, 19, 26, 38, 54 | as predicted |
| R5 new | sixfold Coble rung at most 7; eightfold Coble rung at most 25 | 7; 25 |
| R6 | g^2 D constant on the nodes in all seven one-relation cases | as predicted; the control fails as it should |
| R7 | ranks 64 (invariant octics), 63 (anti-invariant), 127 (all) on the 128 points of the K3 cover | as predicted |

False starts, kept: (1) in the first version of `pr1_rungs.m2` a sum was split over two lines and Macaulay2 dropped
the second line; the eightfold of case (b) was then singular along a line and its section showed a 29th singular
point. Found by a smoothness check, fixed, and a smoothness check added for every case. (2) `pr2_enriques.m2` first
tried a direct smoothness check of S (minors of a Jacobian) that did not finish in 12 minutes; replaced by the
double-cover argument (the direct check is still available with a third argument `full`). (3) a variable-name clash
in `pr3_bielliptic.m2`.

Independent check: `../blind_check7/REPORT.txt` (own code, same two primes and a third for some items). Every number
was reproduced. Its objections to the arguments were accepted and are worked into section 15 of the lead note:
what is forced is the discriminant of the class, not the class; the justification first given for the functional of
R5 was insufficient (the corrected one is in the header of `pr5_tangent.m2`); the Coble rungs are not components of
their Hodge loci, and "25 < 26" does not separate them from the family l Q + det A + det B; "no class" for the
Enriques surface means none from this construction. It did not check R6 for the two tenfold cases and for the
eightfold Coble rung.
