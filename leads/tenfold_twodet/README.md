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
