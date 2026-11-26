# An arc at Movasati's own point in a direction that is not a cone over a sixfold (26 Nov 2026, night)

AI-written (Claude Fable 5.2 for Timothy Seifert), unreviewed. Read `PREREG_arc.md` first: theory, predictions
written before each step, outcomes. Summary: `leads/TENFOLD_TWODET_LEAD.md`, section 9. Registry:
D-MOVASATI-POINT-ARC-ORDER8.

| file | what | label |
| --- | --- | --- |
| `ma1_probe.m2` | eightfold Movasati point: ranks; order 4 for a generic net, a net of the 11-dimensional piece, a symmetric one, a cone direction | MOD p |
| `ma2_slice_arc.m2` | the arc in a transversal slice (19 monomials + 7 net directions); corrects the free part of T_(n-3) at order n; can be continued from its state file | MOD p |
| `ma3_cone_to_tenfold.m2` | the eightfold arc read on the Fermat tenfold at Movasati's pair of 5-planes, with the tenfold's 221 equations | MOD p |
| `arcs/arc8_*.txt`, `arcs/arc9_*.txt` | state files of ma2: free directions, the 26 x 7 matrix D, the terms T_1.. (arc9: the run continued to order 9; its T_6, T_7, T_8 differ from arc8, as they must) | MOD p |
| `logs/` | all runs | |
| `blind_check13/` | the independent check: brief, report, the checker's scripts | |

Reproduce (repository root, Macaulay2 1.22; primes must be 1 mod 6):

    M2 --script leads/movasati_arc/ma1_probe.m2 32029 1 -1 4                          (10 seconds)
    M2 --script leads/movasati_arc/ma2_slice_arc.m2 32029 1 -1 8 d 1 /tmp/a.txt       (18 minutes; order 7: 8 minutes; order 9: 50 minutes)
    M2 --script leads/movasati_arc/ma2_slice_arc.m2 32029 1 2 7 d 1 /tmp/b.txt        (5 minutes; stops at order 6)
    M2 --script leads/movasati_arc/ma3_cone_to_tenfold.m2 32029 -1 leads/movasati_arc/arcs/arc8_32029_seed1_lam-1_d.txt 8   (5 minutes)

Arguments of ma2: prime, seed (fixes y_0 and the net), lambda, highest order, case (d: generic in the piece;
s: symmetric; E: cone direction), slice seed, state file (created if absent, continued if present).
