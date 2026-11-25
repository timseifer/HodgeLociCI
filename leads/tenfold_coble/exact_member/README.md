# A named member of the Coble family over QQ, with a certificate (25 Nov 2026)

AI-written (Claude Fable 5.2), unreviewed. See `leads/TENFOLD_COBLE_LEAD.md`, section 12, and registry entry
D-TENFOLD-COBLE-EXACT-MEMBER. Nothing here is a statement about the Hodge conjecture.

Variables z_0..z_2, p_0..p_2, q_0..q_2 (together: y) and w_0..w_2.
h(a,b,c) = a^3 + b^3 + c^3 + 9abc;  M = sum_{i,j} x_{(i-j) mod 3} z_{(i+j) mod 3} p_i q_j with x = (4,3,3).

    F8   = -221 h(z) + 378 h(p) + 378 h(q) + 378 M
    Phi0 = 2 z_0 p_0 + z_1 p_1 + 2 z_0 p_2 - p_2^2 - 2 p_0^2 - 2 z_1 z_2
    Phi1 = -p_1 p_2 - 2 q_0 q_2 - 2 q_0^2 + 2 z_1 p_1 - p_1 q_0 - 2 q_1^2
    Phi2 = 2 z_1 q_2 - 2 p_0 q_0 + p_2 q_1 + z_0 p_1 - p_1 q_2 + 2 p_2^2
    F    = F8 + w_0 Phi0 + w_1 Phi1 + w_2 Phi2 + w_0^3 + w_1^3 + w_2^3            X = {F = 0} in P^11

The quadrics were not chosen by hand: `make_member.py 1 1` (rule in `PREREG_exact.md`; candidate 1 with the first
w-part passed the screening, so no candidate was rejected).

| File | What | Command | Time |
| --- | --- | --- | --- |
| member.m2 | the equation (expects `kk`) | loaded by the others | |
| cert_QQ.m2 | directly over QQ: Sigma has 72 distinct points, 71 conditions on quartics, Phi2 nowhere zero on Sigma; the singular surface; first-order rank 54 | `M2 --script cert_QQ.m2` | 7 min |
| cert_modp.m2 | mod p: X smooth; the hyperplane section w_2 = 0 has Jacobian scheme of degree 72; uses the F4 engine | `M2 --script cert_modp.m2 32003` (second argument: seed of a random change of coordinates) | 15 s |

`logs/`: the outputs quoted in the note. With the default Groebner engine the 12-variable smoothness check did not
finish in 40 minutes (and not in 10 with a Hilbert-driven run); the 11-variable node count takes 3 minutes with the
default engine (`logs/s12_1_1_32003_X3.log`) and 1 second with F4, with the same answer.
