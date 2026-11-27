import sys; sys.path.insert(0, "/home/claude/blind_check15")
from fs7 import *
p = int(sys.argv[1]); case = sys.argv[2]; lam = int(sys.argv[3]); NS = int(sys.argv[4]) if len(sys.argv) > 4 else 30
z = {32029: 31556, 31981: 12637}[p]
S = Ctx(p, z); x = S.x
P = S.Pspace(L1) + S.Pspace(L2) * (lam % p)
def net(A):
    f = [x[2*i] - x[2*i+1] * z for i in range(3)]; h = [x[2*j] + x[2*j+1] for j in range(3)]
    e = S.ctx.from_dict({})
    for i in range(3):
        for j in range(3):
            if A[i][j] % p: e = e + f[i] * h[j] * (A[i][j] % p)
    return S.ctx.from_dict({m: c for m, c in zip(e.monoms(), e.coeffs()) if max(m) <= 1})
def y0part(f):
    return S.ctx.from_dict({m: c for m, c in zip(f.monoms(), f.coeffs()) if sum(m[6:]) == 0})
mm = lambda A, B: [[sum(A[i][k]*B[k][j] for k in range(3)) for j in range(3)] for i in range(3)]
G = [[1,1,0],[0,1,1],[1,0,2]]; H = [[2,0,1],[1,1,0],[0,1,1]]
F1 = [[1,2,0],[0,1,0],[0,0,0]]; F2 = [[1,0,0],[1,1,0],[0,0,0]]
E01p = [[0,1,0],[1,0,0],[0,0,0]]; E01m = [[0,1,0],[-1,0,0],[0,0,0]]
yfile = {2: "exact_g_lam2_order5.txt", -1: "exact_g_lam-1_order7.txt"}[lam]
y0 = y0part(S.parse(read_lines(yfile)[0]))
nets = {"g": (mm(mm(G, F1), H), mm(mm(G, F2), H)), "s": (E01p, E01m), "F": (F1, F2)}
A, B = nets[case]
T1 = y0 + x[7] * net(A) + x[9] * net(B)
if case == "g":
    assert T1 == S.parse(read_lines(yfile)[0]), "T_1 rebuild differs from file"
    print("T_1 rebuilt from y_0 + nets equals the file's T_1 (mod p)")
t0 = time.time()
fs = FS7(S, P, T1, seed=7)
dimK = fs.K.shape[1]
print("p", p, "case", case, "lambda", lam, "#T1", len(T1), "rank L", fs.rkL, "dimK", dimK,
      "L T1 nonzero:", int(np.count_nonzero(S.periods(T1, fs.tab))), "setup %.0fs" % (time.time()-t0), flush=True)
Z = lambda: {n: np.zeros(dimK, dtype=np.int64) for n in range(2, 7)}
ev = lambda k, top=7: fs.evaluate(k, top)[0]
# 1. identity check against direct expansion, n = 2..7
kk = fs.rk(); ob, T = fs.evaluate(kk)
Ts = [T1] + [fs.poly3(T[n]) for n in range(2, 7)]
E = S.expseries(Ts, 7)
print("identity Kl c_n(direct) == ob_n at random dense point, n=2..7:",
      [bool(not ((fs.Kl @ S.periods(E[n], fs.tab) - ob[n]) % p).any()) for n in range(2, 8)], "%.0fs" % (time.time()-t0), flush=True)
t1 = time.time(); ev(fs.rk()); print("one evaluation through order 7: %.2fs" % (time.time()-t1), flush=True)
# 2. ob_2..4 zero; ob_5 linear part
o0 = ev(Z(), 6)
print("ob_2..4 nonzero at 3 random points:", [[int(np.count_nonzero(ev(fs.rk(), 5)[n])) for n in (2, 3, 4)] for _ in range(3)])
def jac(base, n, blk, top):
    ob_b = ev(base, top)[n]; cols = []
    for i in range(dimK):
        e = {m: base[m].copy() for m in base}; e[blk][i] = (e[blk][i] + 1) % p
        cols.append((ev(e, top)[n] - ob_b) % p)
    return np.array(cols).T % p, ob_b
Lb = {}
for blk in range(2, 7):
    Lb[blk], _ = jac(Z(), 5, blk, 5)
print("ob_5 linear-part ranks by block k2..k6:", [rank(Lb[b], p) for b in range(2, 7)])
# affinity of ob_5 in k2 (second difference)
a, b = fs.rk(), fs.rk()
s_ = {n: (a[n] + b[n]) % p for n in a}
print("ob_5 affine (second difference):", not ((ev(s_, 5)[5] - ev(a, 5)[5] - ev(b, 5)[5] + o0[5]) % p).any())
L5 = Lb[2]; Ab = np.hstack([L5, o0[5].reshape(-1, 1)])
assert rank(Ab, p) == rank(L5, p), "ob_5 inconsistent"
N5 = nullspace(Ab, p); j = int(np.flatnonzero(N5[-1])[0]); part2 = N5[:-1, j] * pow(int(N5[-1, j]), p-2, p) % p
N2 = nullspace(L5, p)
print("dim A2 (k2 with ob_5 = 0):", N2.shape[1], flush=True)
def rand_pt():
    k = fs.rk(); k[2] = (part2 + N2 @ fs.rng.integers(0, p, size=N2.shape[1])) % p; return k
# 3. ob_6 in k3: Jacobian at two random points of A2 x rest, affinity in k3, dependence on k4..k6
u = rand_pt(); J3a, o6a = jac(u, 6, 3, 6)
v = rand_pt(); J3b, _ = jac(v, 6, 3, 6)
print("J3 = d ob_6/d k3: rank", rank(J3a, p), "equal at two random points:", not ((J3a - J3b) % p).any())
d = fs.rng.integers(0, p, size=dimK); d2 = fs.rng.integers(0, p, size=dimK)
uu = lambda c: {n: (u[n] + (c[0]*d + c[1]*d2 if n == 3 else 0)) % p for n in u}
sd = (ev(uu((1, 1)), 6)[6] - ev(uu((1, 0)), 6)[6] - ev(uu((0, 1)), 6)[6] + o6a) % p
print("ob_6 affine in k3 (second difference):", not sd.any())
w = {n: (u[n] + (fs.rng.integers(0, p, size=dimK) if n >= 4 else 0)) % p for n in u}
print("ob_6 independent of k4,k5,k6 (one test):", not ((ev(w, 6)[6] - o6a) % p).any())
J4a, o7a = jac(u, 7, 4, 7)
print("J4 = d ob_7/d k4: rank", rank(J4a, p), "image equal to im J3:", rank(np.hstack([J3a, J4a]), p) == rank(J3a, p), flush=True)
# 4. samples on V6 = {ob_2..ob_6 = 0}: random point, k3 corrected by J3
def solve(J, rhs):
    Jh = np.hstack([J, rhs.reshape(-1, 1) % p])
    if rank(Jh, p) != rank(J, p): return None
    Nn = nullspace(Jh, p); jj = int(np.flatnonzero(Nn[-1])[0]); return Nn[:-1, jj] * pow(int(Nn[-1, jj]), p-2, p) % p
def on_V6():
    k = rand_pt(); o6 = ev(k, 6)[6]
    a = solve(J3a, o6)
    if a is None: return None
    k[3] = (k[3] + a) % p
    return k
V = []; bad = 0; t1 = time.time()
while len(V) < NS:
    k = on_V6()
    if k is None: bad += 1; continue
    o = ev(k, 7)
    V.append((k, o))
print("samples on V6:", len(V), "(unsolvable k3-steps:", bad, ") max nonzero ob_2..ob_6 at samples:",
      max(max(int(np.count_nonzero(o[n])) for n in range(2, 7)) for _, o in V), "%.0fs" % (time.time()-t1), flush=True)
e7 = V[0][1][7]
Wc = np.hstack([((o[7] - e7) % p).reshape(-1, 1) for _, o in V[1:]])
print("dim W7 = span(ob_7(u)-ob_7(u0)):", rank(Wc, p), "; contains im J4:", rank(np.hstack([Wc, J4a]), p) == rank(Wc, p),
      "; ob_7(u0) nonzero:", int(np.count_nonzero(e7)), flush=True)
if not in_span(Wc, e7, p):
    ell = nullspace(Wc.T, p); ells = ell.T @ e7 % p
    print("OBSTRUCTED at order 7: ob_7(u0) not in W7; codim of W7:", ell.shape[1],
          "; nonzero values l.ob_7(u0) over a basis of W7-annihilators:", int(np.count_nonzero(ells)))
    l1 = ell[:, int(np.flatnonzero(ells)[0])]
    fresh = []
    for _ in range(8):
        k = on_V6()
        if k is not None: fresh.append(int(l1 @ ev(k, 7)[7] % p))
    print("  l.ob_7(u0) =", int(l1 @ e7 % p), "; l.ob_7 at fresh points of V6:", fresh, flush=True)
else:
    k = V[0][0]
    for rnd in range(3):
        o7 = ev(k, 7)[7]; J4 = J4a
        if not o7.any(): break
        a = solve(J4, o7)
        if a is None: print("  k4-solve round", rnd, ": not solvable; OPEN"); break
        k[4] = (k[4] + a) % p
        o = ev(k, 7); print("  k4-solve round", rnd, "rank J4", rank(J4, p), ": ob_2..ob_7 nonzero", [int(np.count_nonzero(o[n])) for n in range(2, 8)], flush=True)
    o, T = fs.evaluate(k, 7)
    c7 = fs.cprime(7, T, {n: fs.poly3(T[n]) for n in range(2, 7)})
    T7 = (-fs.X @ c7) % p
    print("DIRECT verification of constructed jet T_1..T_7: nonzero c_n among 45, n=1..7:", fs.direct(T, T7), flush=True)
print("total %.0fs" % (time.time()-t0))
