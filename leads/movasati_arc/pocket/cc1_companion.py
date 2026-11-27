# cc1: companion classes along the lambda = 2 pocket jet (PREREG_companion_classes.md). MOD p.
# usage: python3 cc1_companion.py p z jetfile N
import sys, itertools, time
sys.path.insert(0, "/home/claude/hodgelocici/leads/movasati_arc/blind_check14/own")
from own import Ctx, L1, L2, M
import numpy as np
from flint import nmod_mat
p = int(sys.argv[1]); z = int(sys.argv[2]) % p; jet = sys.argv[3]; N = int(sys.argv[4])
S = Ctx(p, z); t0 = time.time()
Ts = [S.parse(l) for l in open(jet) if l.strip()][:N]
E = S.expseries(Ts, N)
codes5 = [c for c in range(2**M) if bin(c).count("1") == 5]; idx = {c: i for i, c in enumerate(codes5)}   # 252
pw2 = 1 << np.arange(M, dtype=np.int64)
def Arow(f):
    """45 x 252 matrix: Psi_P(Q f) = sum_code A[Q, code] P[code]"""
    n = len(f); A = np.zeros((45, 252), dtype=np.int64)
    if n == 0: return A
    ex = np.fromiter(itertools.chain.from_iterable(f.monoms()), dtype=np.int64, count=n*M).reshape(n, M)
    co = np.fromiter((int(c) for c in f.coeffs()), dtype=np.int64, count=n)
    for i, q in enumerate(S.Q):
        h = ex + np.array(q, dtype=np.int64)[None, :]; r = h % 3; ok = (r != 2).all(axis=1)
        if not ok.any(): continue
        hh = h[ok]; w = co[ok].copy()
        for j in range(M): w = w * S.W[hh[:, j]] % p
        code = ((1 - r[ok]) * pw2).sum(axis=1)
        sel = np.array([bin(int(c)).count("1") == 5 for c in range(2**M)])[code]
        if not sel.any(): continue
        cols = np.array([idx[int(c)] for c in code[sel]]); ww = w[sel]
        A[i] = np.bincount(cols, weights=None, minlength=252) * 0
        acc = np.zeros(252, dtype=np.int64)
        np.add.at(acc, cols, ww); A[i] = acc % p
    return A
def pvec(L):
    v = np.zeros(252, dtype=np.int64)
    for choice in itertools.product((0, 1), repeat=5):
        c = 1; code = 0
        for (a, b, e), ch in zip(L, choice):
            cj = pow(z, e, p); c = c * 3 * cj % p
            if ch: c = c * cj % p; code |= 1 << b
            else: code |= 1 << a
        v[idx[code]] = (v[idx[code]] + c) % p
    return v
def rank(A):
    if A.size == 0: return 0
    return nmod_mat(A.shape[0], A.shape[1], [int(x) for x in A.flatten()], p).rank()
def nullspace(A):
    m = nmod_mat(A.shape[0], A.shape[1], [int(x) for x in A.flatten()], p)
    X, nul = m.nullspace()
    return np.array([[int(X[i, j]) for j in range(nul)] for i in range(A.shape[1])], dtype=np.int64)
# H: span of linear-cycle period polynomials (random sample until the rank is stable)
rng = np.random.default_rng(1)
def matchings(idxs):
    if not idxs: yield []; return
    a = idxs[0]
    for i in range(1, len(idxs)):
        for rest in matchings(idxs[1:i] + idxs[i+1:]): yield [(a, idxs[i])] + rest
allM = list(matchings(list(range(10))))
vecs = []; rk = 0; stable = 0
while stable < 400:
    Mt = allM[rng.integers(len(allM))]; es = rng.choice([1, 3, 5], size=5)
    vecs.append(pvec([(a, b, int(e)) for (a, b), e in zip(Mt, es)]))
    if len(vecs) % 50 == 0:
        r = rank(np.array(vecs)); stable = stable + 50 if r == rk else 0; rk = r
Hm = np.array(vecs).T % p
r = rank(Hm.T); print("dim H (span of linear-cycle period polynomials, sampled):", r, "from", len(vecs), "cycles ; %.0fs" % (time.time()-t0), flush=True)
# basis of H
from flint import nmod_mat as NM
mH = NM(Hm.shape[1], 252, [int(x) for x in Hm.T.flatten()], p); R = mH.rref()[0]
B = np.array([[int(R[i, j]) for j in range(252)] for i in range(r)], dtype=np.int64).T   # 252 x r
c = (pvec(L1) + 2 * pvec(L2)) % p
print("c in H:", rank(np.hstack([B, c.reshape(-1, 1)])) == r, flush=True)
Acc = np.zeros((0, 252), dtype=np.int64)
for n in range(1, N + 1):
    An = Arow(E[n]); Acc = np.vstack([Acc, An]) % p
    print("order %d: c_n(c) zero: %s ; dim Lambda_%d = %d ; %.0fs" % (n, not (An @ c % p).any(), n, r - rank(Acc @ B % p), time.time()-t0), flush=True)
K = nullspace(Acc @ B % p); Lam = B @ K % p
print("RESULT dim Lambda_%d = %d ; c in Lambda: %s" % (N, Lam.shape[1], rank(np.hstack([Lam, c.reshape(-1, 1)])) == Lam.shape[1]), flush=True)
np.save("Lambda_%d_%d.npy" % (p, N), Lam)
