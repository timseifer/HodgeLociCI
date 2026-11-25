# RC-T6 convention check: fe.py (step e) functional vs BC hl.py functional, MOD p.
import sys, numpy as np, itertools
sys.path.insert(0, '/home/claude/hodge/discovery/t6_unsolved/e')
sys.path.insert(0, '/home/claude/hodge/discovery/checks/bc_t6')
import fe
import hl
p = 32029
rng = np.random.default_rng(7)
for lam in (-1, 2):
    E = fe.Engine(p, lam)
    z = E.z
    F = hl.Field(p); F.z = z; F.zb = pow(z, 5, p)
    T1 = hl.pair_tables(F, [z] * 6)
    T2m = hl.pair_tables(F, [z, z, z, p - 1, p - 1, p - 1])
    T2b = hl.pair_tables(F, [z, z, z, F.zb, F.zb, F.zb])
    z2 = z * z % p
    def sigma(g):
        # on pairs 3..5: swap a<->b, then x_a -> z^2 x_a  (monomial map with scalar)
        g = list(g); c = 1
        for e in (3, 4, 5):
            a, b = 2 * e, 2 * e + 1
            ga, gb = g[a], g[b]
            g[a], g[b] = gb, ga
            c = c * pow(z2, g[a], p) % p
        return tuple(g), c
    ratios = {}; ratios_s = {}; nnz = 0
    for trial in range(4000):
        deg = 3 * int(rng.integers(2, 7))
        # random monomial with residues in admissible patterns half of the time
        g = [0] * 12
        for k in range(deg): g[int(rng.integers(0, 12))] += 1
        key = hl.enc(g)
        Ep = (np.array([key], np.int64), np.array([1], np.int64))
        vfe = int(E.H(Ep)[0])
        P = hl.Poly(p, [key], [1])
        f = hl.functional(P, [T1, T2m], [[0] * 12], p)[0]
        vbc = (int(f[0]) + lam * int(f[1])) % p
        gs, cs = sigma(g)
        Ps = hl.Poly(p, [hl.enc(gs)], [cs])
        fs = hl.functional(Ps, [T1, T2b], [[0] * 12], p)[0]
        vbs = (int(fs[0]) + lam * int(fs[1])) % p
        if vfe == 0 and vbc == 0 and vbs == 0: continue
        nnz += 1
        r = vfe * pow(vbc, p - 2, p) % p if vbc else None
        rs = vbs * pow(vbc, p - 2, p) % p if vbc else None
        ratios.setdefault(deg, set()).add(r); ratios_s.setdefault(deg, set()).add(rs)
        # also individual planes under sigma
    print("lam", lam, "z", z, "nonzero samples", nnz)
    for d in sorted(ratios):
        exp = pow(3, 6, p) * pow(pow(3, (d - 6) // 3, p), p - 2, p) % p
        print("  deg", d, "fe/BC(z'=-1) ratios", ratios[d], "predicted 3^6/3^m", exp, "| BC(z'=z^5, sigma)/BC(z'=-1) ratios", ratios_s[d])
