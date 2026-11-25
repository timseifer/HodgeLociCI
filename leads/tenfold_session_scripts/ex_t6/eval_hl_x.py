# RC-T6: evaluate a step-(e) arc (fe.py slice vectors T_1..T_m, exp(sum t^j T_j) convention) with BC's hl.py functional.
# Conversion: BC uses exp(-G/3) => G_j = -T_j (fe Psi = 3^(6-m) Phi, so exp(T) with Psi == exp(-G/3) with Phi iff G = -T). Planes: P1 = z on all pairs, P2 = z on pairs 0-2 and w2 on pairs 3-5
# (w2 = -1 = fe's convention, or 'zb' with the sigma map applied to the arc). All 364 cubic forms P.
# usage: python3 eval_hl.py arc.npy p lam z [w2mode=m1|zb]
import sys, numpy as np, itertools, time
sys.path.insert(0, '/home/claude/hodge/discovery/checks/bc_t6')
import hl
from hl import Poly, enc, dec_arr
fn, p, lam, z = sys.argv[1], int(sys.argv[2]), int(sys.argv[3]), int(sys.argv[4]) % int(sys.argv[2])
mode = sys.argv[5] if len(sys.argv) > 5 else 'm1'
Ts = np.load(fn) % p
sys.path.insert(0, '/home/claude/hodge/discovery/t6_unsolved/e')
from fe import bounded_exps
mons = bounded_exps(12, 3, 1)
F = hl.Field(p); F.z = z; F.zb = pow(z, 5, p)
w2 = (p - 1) if mode == 'm1' else F.zb
T1 = hl.pair_tables(F, [z] * 6, amax=40); T2 = hl.pair_tables(F, [z, z, z, w2, w2, w2], amax=40)
z2 = z * z % p
def sig(beta):
    g = list(beta); c = 1
    if mode == 'zb':
        for e in (3, 4, 5):
            a, b = 2 * e, 2 * e + 1
            g[a], g[b] = g[b], g[a]
            c = c * pow(z2, g[a], p) % p
    return g, c
Gs = []
for T in Ts:
    ks, cs = [], []
    for i in np.flatnonzero(T):
        g, c = sig(mons[i]); ks.append(enc(g)); cs.append(int(T[i]) * (p - 1) % p * c % p)
    Gs.append(Poly(p, ks, cs).norm())
Ps = hl.cubic_monos()
PA = np.array(Ps, np.int64)
def phi_both(E, chunk=400000):
    out = np.zeros((len(Ps), 2), np.int64)
    for s in range(0, len(E.k), chunk):
        ex = dec_arr(E.k[s:s + chunk]); c = E.c[s:s + chunk]
        for it, T in enumerate((T1, T2)):
            # per pair, factor for each P-pair exponent combo
            cache = {}
            for ip, P in enumerate(Ps):
                v = c.copy()
                for e in range(6):
                    key = (e, P[2 * e], P[2 * e + 1])
                    if key not in cache:
                        cache[key] = T[e][ex[:, 2 * e] + P[2 * e], ex[:, 2 * e + 1] + P[2 * e + 1]]
                    v = v * cache[key] % p
                out[ip, it] = (out[ip, it] + int(v.sum() % p)) % p
    return out
t0 = time.time()
import arc as bcarc
E = bcarc.expE(Gs, p, len(Gs) + 1)
print("E sizes", [len(e) for e in E], flush=True)
# L_BC on squarefree slice (for the Im L test at the last order)
LB = []
for m in mons:
    g, c = sig(m)
    f = phi_both(Poly(p, [enc(g)], [c]))
    LB.append((f[:, 0] + lam * f[:, 1]) % p)
LB = np.array(LB, np.int64).T % p
print("rank L_BC (364 x 220) =", hl.rank(LB, p), flush=True)
for n in range(1, len(Gs) + 2):
    f = phi_both(E[n]); r = (f[:, 0] + lam * f[:, 1]) % p
    nz = int((r != 0).sum())
    extra = ""
    if nz:
        extra = " residual in Im L_BC (removable by G_%d)? %s" % (n, hl.solve(LB, r, p) is not None)
    print(f"order {n}: |E_n|={len(E[n])} nonzero delta-equations {nz}/364;{extra} single planes nonzero: P1 {int((f[:,0]!=0).sum())}, P2 {int((f[:,1]!=0).sum())}  ({time.time()-t0:.0f}s)", flush=True)
# ---- EX-T6 addition: certificate check (y = e*(x6x8x11) + z e*(x6x9x11)) in hl.py coordinates
if len(sys.argv) > 6:
    import json
    cert = json.load(open(sys.argv[6])); yZ = cert['y_Zz']
    from fe import bounded_exps as _be
    forms = [tuple([0] * 12)] + _be(12, 3, 1)
    idx = {tuple(P): i for i, P in enumerate(Ps)}
    nzs = [(forms[i], a, b) for i, (a, b) in enumerate(yZ) if a or b]
    assert all(sum(f) == 3 for f, a, b in nzs)
    yv = np.zeros(len(Ps), np.int64)
    for f, a, b in nzs: yv[idx[f]] = (a + b * z) % p
    print("y.L_BC = 0:", not (yv @ LB % p).any(), flush=True)
    f = phi_both(E[len(Gs) + 1]); r = (f[:, 0] + lam * f[:, 1]) % p
    yr = int(yv @ r % p)
    c6 = cert.get('y_dot_c6_modp', {}).get(str(p) + '_' + str(z))
    print("y . (hl order-%d residual) =" % (len(Gs) + 1), yr, " ; y.c6(fe/exact) =", c6,
          " ratio y.c6 / y.r_hl =", (c6 * pow(yr, p - 2, p) % p) if (c6 is not None and yr) else None, " 5*3^7 mod p =", 5 * 3 ** 7 % p, flush=True)
