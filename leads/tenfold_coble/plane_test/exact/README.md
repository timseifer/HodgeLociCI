# The plane count, exactly over QQ (26 Nov 2026)

Exact version of `../pl1_count.m2` (registry D-TENFOLD-COBLE-PLANE-COUNT) at one named rational member.
Write-up: `leads/TENFOLD_COBLE_LEAD.md`, section 17. Registry: D-TENFOLD-COBLE-PLANE-COUNT-EXACT.
AI-written, unreviewed. No statement about the Hodge conjecture.

    M2 --script ex2_count.m2 pi      (about 1 minute)   Lambda . Z_a = 8, X smooth, Lambda in X
    M2 --script ex2_count.m2 p3      (about 10 minutes to the degree-12 point)   deg Z_a = 12

`ex1_setup.m2` (loaded by ex2): the member lam = -2, x = (8, 18, 1), a0 = 29; the point
a = (0,1,-1,1,2,3,-1,-3,-2) of Sing(Y); the forms Q_a, G; the rational 4-planes P_B (through a) and P' = g(P_B).
`X_exact.txt`: the tenfold used. `PREREG_exact_plane.md`: what was predicted and why no number field is needed for
the member. `logs/`: the two runs. Independent check: `../../blind_check11/`.
