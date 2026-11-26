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

## Second batch (26 Nov 2026): is the eightfold Coble rung in the closure of l Q + det A + det B?

Answer: yes, with an explicit degeneration; write-up in `leads/TENFOLD_COBLE_LEAD.md`, section 16; pre-registration
in `PREREG_pairing.md`, sections 8-15 (each section was written before the runs it names; what each outcome would
mean is stated there). Everything is MOD p (32003 seed 1, 31991 seed 2) unless said; arguments are by an AI and
unreviewed. Not a statement about the Hodge conjecture.

| script | what it runs | result |
|---|---|---|
| `pr8_equisingular.m2` | R8: the second-order form h on (I_Z)_3 for 36-nodal cubics | rank 0 for the Coble-rung section and the three controls; a random functional gives rank 94 |
| `pr9_quadrics.m2` | R9: which quadrics through the nodes survive to first order | 19 quadrics, rank 1, the same 18 survive; controls rank 0 |
| `pr10_arcs.m2` | R10: formal arcs keeping the nodes, obstruction at each order | none to order 6 (one direction per prime; the runs stopped at the time limit before the others) |
| `pr11_cone.m2` | R11, R11b: first-order Hodge locus at a rung member against the node-keeping deformations | 93, 95, 91; two members span; Pluecker rank 3 (cone over P^1 x P^1) |
| `pr12_split.m2` | R12: the algebra of the 18 quadrics at the point itself | control 130 / 32 / 2 (two Segre fourfolds); the case 117 / 45 / 1: no conclusion |
| `pr13_arc_algebra.m2` | R13, R14: the same at the generic point of a formal arc | 27 / 130 / algebra of dimension 2; controls C1, C2 as predicted |
| `pr14_arc_split.m2` | section 14: N^2, N(grad F), the cubic G_N, the pencil | N_0 of rank 1 with image t^2; divisibility t^3, t^2, t; two conjugate determinantal members |
| `pr15_certificate.m2`, `detrep_lib.m2` | matrices from the two members; the identity | det(tau + A) - det(tau + B) = c G, equal trace and s_2, exact over F_(p^2) |
| `check_certificate.m2` | reads a certificate only and checks the identity | true |
| `pr16_tenfold_twodet.m2` | R16: tenfolds l_1 Q_1 + l_2 Q_2 + det A + det B | curve 36 / 37; 72 nodes, 71 conditions; codimension 52 |
| `pr17_synthetic_family.m2` | cubics det M - det sM for products of reflections (exploratory, not pre-registered) | 7 or 8 reflections: curve of degree 18, genus 10 on 9 quadrics; family of affine dimension 75 |

`arcdata/`: the arcs written by `pr13` (cubics g_m and the quadrics through the moving nodes), the pencil files
written by `pr14`, and the certificates. The first arc file was written with unquoted keys and patched by hand
(keys quoted); the scripts now write quoted keys.

What went wrong and was fixed (kept in `logs/first_version/`, reason in each file name): the inverse check of pr8
compared modules instead of entries; pr11 was stopped three times by the time limit (full saturation, then
`super basis(3, I)`; now saturation in one variable and a kernel); pr12 drew its random algebra element entry by
entry; pr14 was stopped once in a slow kernel computation (`gens ker`; now `nullSpace`); pr16 had a shape error in
its Jacobian check; a parse error in the last block of pr14 and two in pr15 (a line starting with `else` or `<<`)
after the results above them were printed. pr13 at order 10 (32003) was stopped after its part (c), before the
lines on the leading term, because pr14 redoes that analysis.

Instances of the identity: p = 32003 seed 1 (the two determinantal cubics are conjugate over F_(p^2)) and p = 31991
seed 2 (they are defined over F_p, but their Lie algebras are not split there; `pr15` was rerun with the fifth
argument `ext`). Both certificates pass `check_certificate.m2`.

Independent check: `../blind_check8/REPORT.txt` (own code; it read only the first certificate). Confirmed: the
identity, the degeneration formula, the synthetic family, the dimension count and the first-order numbers of pr11.
Corrections, accepted: the limit of the degeneration is c G + ..., not G + ...; my argument for "every Coble
section" had a gap (its replacement is in 16.10 of the lead note; still an argument). Not checked by it: pr8-pr10,
pr12-pr14 (the tests at the point and along the arcs), the second certificate, pr16.
