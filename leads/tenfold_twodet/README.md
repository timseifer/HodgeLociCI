# The class on the tenfold two-determinant family (26 Nov 2026)

Owner's question: the class of the family l_1 Q_1 + l_2 Q_2 + det A + det B on cubic tenfolds, and whether it is in the
orbit of [P1] - [P2]. Write-up: `leads/TENFOLD_TWODET_LEAD.md`. Pre-registration (written before any run, with
what each outcome would mean): `PREREG_twodet.md`. AI-written, unreviewed; no statement about the Hodge conjecture.

| script | what it does | result |
|---|---|---|
| `fermat_planes.py validate` | intersection of Fermat planes from cycles of two pairings, against ranks (fourfold) | 0 mismatches of 4000 |
| `fermat_planes.py scan 12` | EXACT on the Fermat tenfold: T5.T5, the four-plane form of the class, its pairings with all 7 577 955 planes, search for a two-plane form | -21; second difference of four planes; norm -48; values 0, +-1, ..., +-12; no two-plane form |
| `fermat_planes.py scan 10`, `scan 8` | the same on the eightfold and the sixfold (controls) | T4.T4 = 51 as in the registry; no two-plane form at the Fermat point there either |
| `fermat_planes.py kappa` | the same count for the Coble class kappa at the Fermat point (R4) | norm -48, values 0, +-1, ..., +-16: primitive, divisibility 1 |
| `td1_general_member.m2` (run from the repository root) | MOD p at a random member: T5, the nodes on it, Hilbert functions, the package's first-order Hodge locus | 5, 9; 72 nodes on T5, smooth there; 1, 10, 37, 52, 35, 10, 1, 0; codimension 52 (two primes; smooth at one) |

Reproduce:

    python3 leads/tenfold_twodet/fermat_planes.py validate
    python3 leads/tenfold_twodet/fermat_planes.py scan 12            (about 10 s)
    M2 --script leads/tenfold_twodet/td1_general_member.m2 32003 1   (about 2 minutes; add a third argument to test smoothness)

Predictions that failed (kept in `PREREG_twodet.md`, section 4): the controls (I expected a two-plane form on the
sixfold and eightfold at the Fermat point; my reading of the registry was wrong) and "all pairings are 0 mod 3".
`logs/first_version/`: a run of the general-member script that hung in a symbolic determinant.

Independent check: `blind_check9/REPORT.txt` (nothing refuted; three caveats and a stronger form of two statements,
worked into section 6 of the lead note). `tooling_tofield_colon.m2`: the checker's example of a wrong ideal
quotient of Macaulay2 1.22 over toField(QQ[w]/(w^2+w+1)), reproduced (registry N-M2-TOFIELD-IDEAL-QUOTIENT).

## Second batch (26 Nov, evening): does the family meet V_Z with the class [P1] - [P2]?

Write-up: section 7 of `leads/TENFOLD_TWODET_LEAD.md`. Pre-registration, written before the runs (theory T1-T6,
predictions P1-P6 with what each outcome would mean): `PREREG_vz.md`. Logs: `logs/vz/`.
All scripts are run from the repository root (they load the package from `M2/HodgeLociCI.m2`).

| script | what it does | result |
|---|---|---|
| `vz1_fermat_cone_arc.m2 first` | EXACT: T3's cone arc read as a tenfold arc at the pair [6T 2T 2F 2T]; first-order ranks | all 221 period functions of P1 - P2 vanish to order 9; rank L = 38, joint 39 |
| `vz2_honest_cone_member.m2 p seed` | MOD p: a member with A, B in x_0..x_7 only | Hilbert function 1,10,35,52,35,10,1; tangent codimension 52; smooth; vertex line of multiplicity 36 |
| `vz3_order4_model_cone.m2 p seed` | MOD p, polynomials only: the 27 model quadrics on nets z_0 A + z_1 B + z_2 C | Jacobian rank 14 / 16 / 18 on the pieces of dimension 13 / 11 / 9 |
| `vz4_order4_movasati.m2 p seed lambda order [cases]` | MOD p: order 4 at Movasati's point along eight kinds of direction | generic rank 3 and rank 2: obstructed at 4; Segre, the 13-dimensional piece, z_0 C': pass |
| `vz5_order5_removability.m2 p seed lambda [case]` | MOD p: is the order-5 obstruction removable by a change of T_2? | yes for lambda = -1 and 2 on the 13-dimensional piece; image of rank 14 |
| `vz6_order6.m2 p seed lambda [nrandom]`, `vz6b_verify_order6.m2 p seed lambda` | MOD p: order 6 on the same direction, T_2 corrected | lambda = -1: removable by T_3, corrected arc verified to order 6; lambda = 2: obstructed modulo the corrections tested |

Reproduce:

    M2 --script leads/tenfold_twodet/vz1_fermat_cone_arc.m2 first                 (about 25 s)
    M2 --script leads/tenfold_twodet/vz2_honest_cone_member.m2 32003 1            (about 75 s)
    M2 --script leads/tenfold_twodet/vz3_order4_model_cone.m2 32003 1             (2 s)
    M2 --script leads/tenfold_twodet/vz4_order4_movasati.m2 32029 1 -1 4          (about 2.5 min; primes must be 1 mod 6)
    M2 --script leads/tenfold_twodet/vz5_order5_removability.m2 32029 1 -1 d      (about 25 min)

The answer is conditional on the sixfold statement D-W-MINUS1-IS-TWO-DET-CLOSURE (a paper chain); see section 7.0.
Independent check: `blind_check10/REPORT.txt`.
