# RC-T6: evaluate a BC-T6 hensel arc (BC coords: planes z, z' = z^5; exp(-G/3)) with step (e)'s functional (fe_big = fe.py
# with exact accumulation). Conversion: G' = sigma^* G (pairs 3-5: x_a -> z^2 x_b, x_b -> x_a), T = -G'.
# usage: python3 eval_fe_bc.py hensel_file
import sys, json, numpy as np, time
sys.path.insert(0, '/home/claude/hodge/discovery/checks/rc_t6')
import fe_big as fe
lines = open(sys.argv[1]).read().strip().split("\n"); meta = json.loads(lines[0])
p, lam, z = meta["p"], meta["lam"], meta["z"]
z2 = z * z % p
Gs = [json.loads(l.split(": ", 1)[1]) for l in lines[1:]]
E1 = fe.Engine(p, lam, z=z); E0 = fe.Engine(p, 0, z=z)
def conv(G):
    ks, cs = [], []
    for b, c in G:
        g = list(b); cc = c % p
        for e in (3, 4, 5):
            a_, b_ = 2 * e, 2 * e + 1
            i, j = b[a_], b[b_]
            g[a_], g[b_] = j, i
            cc = cc * pow(z2, i, p) % p
        ks.append(fe.pack(g)); cs.append((-cc) % p)
    return E1.normalize(np.array(ks, np.int64), np.array(cs, np.int64))
Ts = [conv(G) for G in Gs]
t0 = time.time(); Es = [E1.poly_one()]
print("p", p, "lam", lam, "arc length", len(Ts), meta.get("log"), flush=True)
for n in range(1, len(Ts) + 1):
    inv = pow(n, p - 2, p)
    En = E1.add(*[(j * inv % p, E1.mul(Ts[j - 1], Es[n - j])) for j in range(1, n + 1)])
    Es.append(En)
    c = E1.cvec(En); c0 = E0.cvec(En)
    print(f"order {n}: |E_n|={len(En[0])} fe delta-coefficients nonzero {np.count_nonzero(c)}/221; P1 alone nonzero {np.count_nonzero(c0)}; P2 alone nonzero {np.count_nonzero((c - c0) % p)} ({time.time()-t0:.0f}s)", flush=True)
