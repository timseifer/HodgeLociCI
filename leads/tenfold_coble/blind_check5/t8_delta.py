"""T8 probe: delta = [P_z1]-[P_z2] along the symmetric family F_0 + tau*M_xi when xi_1 + xi_2 = 0
(the first-order equations of delta are multiples of xi_1 + xi_2, see T1).  MOD p."""
import random, sys
import pcore, t7
from pcore import Y, Pv, Qv, mono
for p in (2147483629, 2147483587):
    rng = random.Random(99)
    z = pcore.cube_roots_of_minus_one(p)
    pl = [pcore.plane(zz, p) for zz in z]
    kap = pcore.kappa_poly(p)
    deltas = [pcore.comb([(pl[0], 1), (pl[1], -1)], p), pcore.comb([(pl[1], 1), (pl[2], -1)], p), pcore.comb([(pl[0], 1), (pl[2], -1)], p)]
    Ql = pcore.standard_forms()
    for trial in range(2):
        a = rng.randrange(1, p); b = rng.randrange(1, p)
        for label, xi in (("xi=(a,b,-b)", [a, b, p - b]), ("xi=(0,b,-b)", [0, b, p - b]), ("xi=(a,0,0)", [a, 0, 0]), ("xi generic", [a, b, rng.randrange(1, p)])):
            d = {}
            for i in range(3):
                for j in range(3):
                    k = mono(Y(i + j), Pv(i), Qv(j))
                    d[k] = (d.get(k, 0) + xi[(i - j) % 3]) % p
            G = {1: pcore.from_dict(d, p)}
            N = 12
            res, first = pcore.expansion(G, N, p, [kap] + deltas, Ql, last_filtered=False)
            print(f"p={p} {label}: symmetric family to order {N}: first nonzero order kappa: {first[0]}, deltas: {first[1:]}", flush=True)
