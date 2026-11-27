import sys, time, itertools, numpy as np
sys.path.insert(0, "/home/claude/hodgelocici/leads/movasati_arc/blind_check14/own")
from own import Ctx, L1, L2, M
p, z = 31981, 12637
C = Ctx(p, z)
J = [l.strip() for l in open("/home/claude/work/o10c/jet9_31981.txt") if l.strip()]
K = [l.strip() for l in open("/home/claude/hodgelocici/leads/movasati_arc/arcs/jet8_31981_s_lam2.txt") if l.strip()]
T = [C.parse(l) for l in J]; assert len(T) == 9
print("T1 == jet8 line1:", T[0] == C.parse(K[0]), flush=True)
print("degrees", [t.total_degree() for t in T], "terms", [len(t) for t in T], flush=True)
t1, t2 = C.ptable(C.Pspace(L1)), C.ptable(C.Pspace(L2))
tabs = {2: (t1 + 2*t2) % p, -1: (t1 - t2) % p}
def per(f, tab, chunk=1000000):
    # chunked version of Ctx.periods
    out = np.zeros(45, dtype=np.int64); mons = f.monoms(); cos = f.coeffs()
    for s in range(0, len(mons), chunk):
        g = C.ctx.from_dict(dict(zip(mons[s:s+chunk], cos[s:s+chunk])))
        out = (out + C.periods(g, tab)) % p
    return out
def run(Ts, N, label):
    E = [C.ctx.from_dict({(0,)*M: 1})]
    res = {}
    for n in range(1, N+1):
        acc = C.ctx.from_dict({})
        for j in range(1, min(n, len(Ts)) + 1):
            acc = acc + Ts[j-1] * E[n-j] * j
        E.append(acc * pow(n, p-2, p))
        for lam, tab in tabs.items():
            c = per(E[n], tab); res[(lam, n)] = int(np.count_nonzero(c))
        print(label, "n=%d terms=%d nonzero c_n[Q] (of 45): lam=2 -> %d, lam=-1 -> %d" % (n, len(E[n]), res[(2,n)], res[(-1,n)]), flush=True)
    return res
run(T, 9, "jet")
# control (a): perturb one coefficient of T_5
m0, c0 = T[4].monoms()[0], T[4].coeffs()[0]
T5 = T[4] + C.ctx.from_dict({m0: 1})
print("perturb T_5 coeff of", m0, "from", int(c0), "to", (int(c0)+1) % p, flush=True)
run(T[:4] + [T5] + T[5:], 6, "pert")
