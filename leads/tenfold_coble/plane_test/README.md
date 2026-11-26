# plane_test: the class of the 4-plane cycle by one intersection count

AI-written (Claude Fable 5.2, 26 Nov 2026), not reviewed by a mathematician. Lead note: `../../TENFOLD_COBLE_LEAD.md`,
section 14. Registry: D-TENFOLD-COBLE-PLANE-COUNT. Everything here is MOD p. Nothing here is a statement about the
Hodge conjecture.

| file | what |
|---|---|
| `PREREG_plane.md` | written before the runs: the test, the prediction N = 8, what each outcome would mean |
| `pl1_count.m2` | the computation; `M2 --script pl1_count.m2 p seed mode` (mode B: the explicit 4-plane through the odd eigenspace of iota; mode G: a 4-plane through a second random point of A); about 15 s |
| `run_all.sh` | the 8 runs (p = 32003, 31991; seeds 1, 2; modes B, G) |
| `logs/` | the 8 logs; the last line of each is the RESULT line |
| `logs/first_version/` | logs of the first complete version, which checked transversality only at the rational points of pi |
| `logs/pl1_first_attempt_surface_decomposition_not_finished.log` | the first attempt (decomposing a surface in P^4) did not finish in 10 minutes; replaced by a section by a P^3 before any result was seen |

Result, the same in all 8 runs: the plane pi meets the 4-plane cycle Z_a in 8 reduced points, at each of which Z_a is
smooth and meets pi transversally; the tenfold X is smooth and contains the 5-plane. A multiple of h^5 would give 4.

Independent check: `../blind_check6/REPORT.txt` (4 primes, 6 instances, own code; agrees; its caveats are listed in
section 14.6 of the lead note).

Not done: characteristic 0. One exact attempt (lam = 3, x = (4,3,5)) was dropped: that member is special
(x_0 + x_2 = lam x_1), its singular locus has degree 21.
