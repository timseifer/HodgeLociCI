# W3 task 3: EXACT (over Q(z)) randomised certificate of K.c_2 = K.c_3 = K.c_4 = 0 on Sigma1 = T Cone_T + bOf(Segre),
# for random (c, a, l, x2, x3) with integer coordinates uniform in [-R, R]; plus a control at random v in ker L.
# python3 g4exact.py lam kind npts seed   (kind: al | la | kerL)
import sys, time, random, numpy as np
sys.path.insert(0, '/home/claude/hodge/discovery/checks/ex_t6')
from fex import *
from exarc import Arc
from mc_exact import mc_exact
lam = int(sys.argv[1]); kind = sys.argv[2]; npts = int(sys.argv[3]); seed = int(sys.argv[4])
R = 10 ** 6
rnd = random.Random(seed)
t00 = time.time()
def say(*a): print(*a, "(%.0fs)" % (time.time() - t00), flush=True)
X = ExactEngine(lam); X.setup_L()
Mc, _ = mc_exact(X, lam); TC = kernel(Mc)
say("lam", lam, "kind", kind, "rank L", X.Lrank // 2, "dim_Q(z) T Cone_T", TC.ncols() // 2, "T Cone_T in ker L:", iszero(X.L * TC))

def mono(idx):
    e = [0] * 12
    for i in idx: e[i] += 1
    return tuple(e)

def bOf_qz(M):
    """M[i][j] = dict u -> (A, B) in Q(z); b = sum f_i h_j M_ij (squarefree part), realified"""
    d = {}
    for i in range(3):
        for j in range(3):
            fi = {mono([6 + 2 * i]): (1, 0), mono([7 + 2 * i]): (0, -1)}
            hj = {mono([6 + 2 * j]): (1, 0), mono([7 + 2 * j]): (1, 0)}
            for uk, cu in M[i][j].items():
                for e1, c1 in fi.items():
                    for e2, c2 in hj.items():
                        e = tuple(a + b for a, b in zip(e1, e2))
                        e = tuple(a + (1 if k == uk else 0) for k, a in enumerate(e))
                        c = zmul(zmul(c1, c2), cu)
                        a0, b0 = d.get(e, (0, 0)); d[e] = (a0 + c[0], b0 + c[1])
    A_ = [Q0] * X.nm; B_ = [Q0] * X.nm
    for e, (a, b) in d.items():
        if max(e) <= 1:
            k = X.mons.index(e); A_[k] += fmpq(a); B_[k] += fmpq(b)
    return np_to_mat(np.array(A_ + B_, dtype=object))

def ri(): return rnd.randint(-R, R)
def rqz(): return (fmpq(ri()), fmpq(ri()))
def rvec(n): return np_to_mat(np.array([fmpq(ri()) for _ in range(n)], dtype=object))

for pt in range(npts):
    t0 = time.time()
    if kind == 'kerL':
        v = X.kerL * rvec(X.kerL.ncols())
    else:
        a = [rqz() for _ in range(3)]
        l = [{u: rqz() for u in (1, 3, 5)} for _ in range(3)]
        if kind == 'al': M = [[{u: zmul(a[i], c) for u, c in l[j].items()} for j in range(3)] for i in range(3)]
        else: M = [[{u: zmul(a[j], c) for u, c in l[i].items()} for j in range(3)] for i in range(3)]
        v = TC * rvec(TC.ncols()) + bOf_qz(M)
    arc = Arc(X, v)
    arc.xs[2] = rvec(X.kerL.ncols()); arc.xs[3] = rvec(X.kerL.ncols())
    arc.extend(4)
    ok = [iszero(arc.Kc[n]) for n in (2, 3, 4)]
    hb = max(max(abs(int(fmpq(t).p)).bit_length(), int(fmpq(t).q).bit_length()) for t in v.entries())
    say("point", pt, ": L v = 0:", iszero(X.L * v), " nnz(v) =", sum(1 for i in range(X.nm) if v.entries()[i] != 0 or v.entries()[X.nm + i] != 0),
        " K.c2 = 0, K.c3 = 0, K.c4 = 0:", ok, " nnz K.c4 =", nnz(arc.Kc[4]), " |E'_3| =", len(arc.Es[3][0]), " max bits of v:", hb, " (%.0fs)" % (time.time() - t0))
