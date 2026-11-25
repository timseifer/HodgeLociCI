# DA-T6 A1: tangent spaces of candidate families at the Fermat point vs ker L, T Cone_T, Sigma1 (MOD p)
import sys, numpy as np
sys.path.insert(0, '/home/claude/hodge/discovery/checks/da_t6')
from common import Ctx
p = int(sys.argv[1]) if len(sys.argv) > 1 else 32029
lam = int(sys.argv[2]) if len(sys.argv) > 2 else -1
C = Ctx(p, lam); z = C.z; E = C.E
print("p", p, "lam", lam, "z", z, "z^3", pow(z, 3, p) - p)
print("dim kerL", C.kerL.shape[1], "dim TCone", C.TC.shape[1], "TCone in kerL?", not (E.L @ C.TC % p).any(),
      "dim TV", C.rank(C.TV), "dim TCone+B", C.rank(C.TCB), "B in kerL?", not (E.L @ C.B % p).any())
S1 = C.monomials(1); S2 = C.monomials(2)
z5 = pow(z, 5, p)

def report(name, T):
    r = C.rank(T)
    Tk = C.intersect(T, C.kerL)
    inK = Tk.shape[1] == r
    TkC = C.intersect(Tk, C.TC)
    nTk = C.rank(np.concatenate([Tk, C.TC], 1)) - C.TC.shape[1]
    print(name, ": dim T =", r, " dim T n kerL =", Tk.shape[1], " (T in kerL:", inK, ")",
          " dim T n kerL n TCone =", TkC.shape[1], " dim of image in kerL/TCone =", nTk, flush=True)
    if nTk > 0:
        rng = np.random.default_rng(1)
        ranks = []
        for _ in range(3):
            w = Tk @ rng.integers(0, p, Tk.shape[1]) % p
            m = C.M_coords(w)
            # rank of the 3x3 matrix of linear forms in u: evaluate at random u
            u = rng.integers(0, p, 3)
            Mu = np.einsum('iju,u->ij', m, u) % p
            # flattenings rank (a x l type: (i | j,u); l x a type: (j | i,u))
            ranks.append((C.rank(Mu), C.rank(m.reshape(3, 9)), C.rank(m.transpose(1, 0, 2).reshape(3, 9))))
        print("   generic image: (rank M(u), rank flattening i|ju, rank flattening j|iu):", ranks)
    return Tk

# (a) swap involution tau on pairs 3,4,5: (x_a, x_b) -> (z^2 x_b, z^4 x_a)
def tau_mono(e):
    e = list(e); c = 1
    for a, b in [(6, 7), (8, 9), (10, 11)]:
        ea, eb = e[a], e[b]
        c = c * pow(z, 2 * eb + 4 * ea, p) % p
        e[a], e[b] = eb, ea
    return tuple(e), c
Tm = np.zeros((len(C.mons), len(C.mons)), dtype=np.int64)
for i, m in enumerate(C.mons):
    e2, c = tau_mono(m); Tm[C.idx[e2], i] = c
# check tau P1 = P2: tau maps x6 - z x7 to z^2 x7 - z^5 x6 = -z^5 (x6 - z^{-3} x7) = -z^5 (x6 + x7)
inv = E.kernel((Tm - np.eye(len(C.mons), dtype=np.int64)) % p)
anti = E.kernel((Tm + np.eye(len(C.mons), dtype=np.int64)) % p)
report("tau-invariant", inv)
report("tau-anti-invariant", anti)
# (b) TD10 = l1 Q1 + l2 Q2 + det A + det B
def blockmat(xa, xb, xc, xd):
    a = [C.lin({xa: 1, xb: -z}), C.lin({xa: 1, xb: 1}), C.lin({xa: 1, xb: -z5})]
    b = [C.lin({xc: 1, xd: -z}), C.lin({xc: 1, xd: 1}), C.lin({xc: 1, xd: -z5})]
    return [[a[0], b[0], {}], [{}, a[1], b[1]], [b[2], {}, a[2]]]
def fermat_pair(i, j):
    return C.add({tuple(3 if k == i else 0 for k in range(12)): 1}, {tuple(3 if k == j else 0 for k in range(12)): 1})
A = blockmat(4, 5, 6, 7); B = blockmat(8, 9, 10, 11)
assert C.add(C.det3(A), C.scal(-1, C.add(fermat_pair(4, 5), fermat_pair(6, 7)))) == {}
assert C.add(C.det3(B), C.scal(-1, C.add(fermat_pair(8, 9), fermat_pair(10, 11)))) == {}
l1 = C.lin({0: 1, 1: -z}); Q1 = C.add(C.mul(C.var(0), C.var(0)), C.scal(z, C.mul(C.var(0), C.var(1))), C.scal(z * z, C.mul(C.var(1), C.var(1))))
l2 = C.lin({2: 1, 3: -z}); Q2 = C.add(C.mul(C.var(2), C.var(2)), C.scal(z, C.mul(C.var(2), C.var(3))), C.scal(z * z, C.mul(C.var(3), C.var(3))))
assert C.add(C.mul(l1, Q1), C.scal(-1, fermat_pair(0, 1))) == {}
def cofs(M): return [C.minor2(M, r, c) for r in [(0, 1), (0, 2), (1, 2)] for c in [(0, 1), (0, 2), (1, 2)]]
gens = [C.mul(l1, q) for q in S2] + [C.mul(Q1, l) for l in S1] + [C.mul(l2, q) for q in S2] + [C.mul(Q2, l) for l in S1]
gens += [C.mul(c, l) for c in cofs(A) + cofs(B) for l in S1]
report("TD10 l1Q1+l2Q2+detA+detB", C.span(gens))
# (c) det A + det B + det C
A0 = blockmat(0, 1, 2, 3)
gens = [C.mul(c, l) for c in cofs(A0) + cofs(A) + cofs(B) for l in S1]
report("detA+detB+detC", C.span(gens))
# (d) l1Q1 + l2Q2 + l3Q3 + (anything restricted) i.e. cubics containing nothing: control = cubics in (l1,l2,l3) + k[y]
