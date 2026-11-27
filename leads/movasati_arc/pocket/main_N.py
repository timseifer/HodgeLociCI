# Generalisation (main session) of blind check 20's complete linear test to an N-jet: checks c_1..c_N = 0, computes
# c_{N+1} with T_{N+1} = 0, and tests whether a first-order correction (dT_2..dT_N, T_{N+1}) fixes order N+1.
# usage: python3 main_N.py p z lam jetfile N
import sys, time, subprocess, os, itertools
sys.path.insert(0, "/home/claude/hodgelocici/leads/movasati_arc/blind_check14/own")
from own import Ctx, L1, L2, M
import numpy as np
from flint import nmod_mat
p = int(sys.argv[1]); S = Ctx(p, int(sys.argv[2]) % p); lam = int(sys.argv[3]); jf = sys.argv[4]; N = int(sys.argv[5])
P = S.Pspace(L1) + S.Pspace(L2) * lam
tab = S.ptable(P)
W = np.zeros(128, dtype=np.int64); W[:80] = S.W
W.tofile("W.bin"); tab.astype(np.int64).tofile("tab.bin")
Ts = [S.parse(l) for l in open(jf) if l.strip()][:N]
assert len(Ts) == N
T0 = time.time()
def log(*a): print("[%6.0fs]" % (time.time()-T0), *a, flush=True)
def monlist(D):
    B = D + 1; out = []
    for k in range(B**M):
        t = k; s = []
        for j in range(M): s.append(t % B); t //= B
        if sum(s) == D: out.append(tuple(s))
    return out
mon2 = monlist(2); i2 = {m: i for i, m in enumerate(mon2)}
ms = [tuple(int(v) for v in np.bincount(c, minlength=M)) for c in itertools.combinations_with_replacement(range(M), 5)]
ms.sort(key=lambda s: sum(s[j]*6**j for j in range(M))); i5 = {m: i for i, m in enumerate(ms)}
cub = [tuple(int(v) for v in np.bincount(c, minlength=M)) for c in itertools.combinations_with_replacement(range(M), 3)]
def dump(f, fn):
    n = len(f); rec = np.zeros(n, dtype=[('e', 'u1', (10,)), ('c', '<u4')])
    rec['e'] = np.fromiter(itertools.chain.from_iterable(f.monoms()), dtype=np.uint8, count=n*M).reshape(n, M)
    rec['c'] = np.fromiter((int(c) for c in f.coeffs()), dtype=np.uint32, count=n); rec.tofile(fn)
def phi(f, D, tag):
    fn = "t_%s.bin" % tag; dump(f, fn)
    subprocess.run(["./phi", str(D), "W.bin", "tab.bin", fn, "o_%s.bin" % tag], check=True)
    r = np.fromfile("o_%s.bin" % tag, dtype=np.int64); os.remove(fn); os.remove("o_%s.bin" % tag); return r
def per(f, tag):
    r = phi(f, 2, tag); return np.array([r[i2[q]] for q in S.Q], dtype=np.int64)
def rk(X): return nmod_mat(X.shape[0], X.shape[1], [int(v) for v in (X % p).flatten()], p).rank()
E = S.expseries(Ts + [S.ctx.from_dict({})], N + 1)
log("sizes", [len(e) for e in E])
c = {n: per(E[n], "c%d" % n) for n in range(1, N + 2)}
log("nonzero c_n, n = 1..%d:" % N, [int(np.count_nonzero(c[n])) for n in range(1, N + 1)], "; c_%d (T_%d = 0) nonzero:" % (N+1, N+1), int(np.count_nonzero(c[N+1])))
A = {}
for k in range(0, N):
    r = phi(E[k], 5, "A%d" % k)
    A[k] = np.array([[r[i5[tuple(a+b for a, b in zip(q, m))]] for m in cub] for q in S.Q], dtype=np.int64)
nb = N  # orders 2..N+1, unknowns dT_2..dT_N, T_{N+1}
J = np.zeros((45*nb, 220*nb), dtype=np.int64)
for n in range(2, N + 2):
    for j in range(2, n + 1):
        J[45*(n-2):45*(n-1), 220*(j-2):220*(j-1)] = A[n-j]
prev = 0
for n in range(2, N + 2):
    r = rk(J[:45*(n-1), :220*(n-1)]); log("order", n, ": extra conditions beyond the 19 fixed by T_n:", r - prev - 19); prev = r
rhs = np.zeros(45*nb, dtype=np.int64); rhs[45*(nb-1):] = (-c[N+1]) % p
r1 = rk(J); r2 = rk(np.hstack([J, rhs[:, None]]))
log("RESULT rank J (orders 2..%d) = %d ; with the order-%d right-hand side: %d -> %s" % (N+1, r1, N+1, r2, "SOLVABLE to first order" if r1 == r2 else "NOT solvable to first order"))
