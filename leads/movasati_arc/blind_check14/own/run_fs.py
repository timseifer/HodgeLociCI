import sys; sys.path.insert(0, "/home/claude/blind_check14/own")
from fs import *
p = int(sys.argv[1]); case = sys.argv[2]; lam = int(sys.argv[3])
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
fs = FS(S, P, T1)
print("p", p, "case", case, "lambda", lam, "#T1", len(T1), "rank L", fs.rkL, "dim ker L", fs.K.shape[1],
      "L T1 nonzero:", int(np.count_nonzero(S.periods(T1, fs.tab))), "setup %.0fs" % (time.time()-t0), flush=True)
dimK = fs.K.shape[1]
def ev(kk): return fs.evaluate(kk)[0]
zero = {n: np.zeros(dimK, dtype=np.int64) for n in range(2, 6)}
# --- end-to-end identity check at one random point
kk = fs.rk(); ob, T = fs.evaluate(kk)
Ts = [T1] + [fs.poly3(T[n]) for n in range(2, 6)]
E = S.expseries(Ts, 6)
okid = []
for n in range(2, 7):
    cd = S.periods(E[n], fs.tab)
    okid.append(bool(not ((fs.Kl @ cd - ob[n]) % p).any()))
print("identity Kl c_n(direct) == ob_n at a random dense point, n=2..6:", okid, flush=True)
# --- ob_2..ob_4 identically zero?
pts = [fs.rk() for _ in range(4)]
obs = [ev(q) for q in pts]
print("ob_2,ob_3,ob_4 nonzero counts at 4 random points:", [[int(np.count_nonzero(o[n])) for n in (2, 3, 4)] for o in obs], flush=True)
# --- ob_5 affine?
add = lambda a, b, ca=1, cb=1: {n: (ca*a[n] + cb*b[n]) % p for n in a}
o0 = ev(zero); oa, ob_ = obs[0], obs[1]; oab = ev(add(pts[0], pts[1])); o2a = ev(add(pts[0], pts[0]))
aff5 = not ((oab[5] - oa[5] - ob_[5] + o0[5]) % p).any() and not ((o2a[5] - 2*oa[5] + o0[5]) % p).any()
print("ob_5 affine (2 second-difference tests):", aff5, flush=True)
# linear part by finite differences, variables ordered (k2,k3,k4,k5)
t1 = time.time()
cols = []
for n in range(2, 6):
    for i in range(dimK):
        e = {m: np.zeros(dimK, dtype=np.int64) for m in range(2, 6)}; e[n][i] = 1
        cols.append((ev(e)[5] - o0[5]) % p)
Lin5 = np.array(cols).T % p
rk_by = [rank(Lin5[:, dimK*j:dimK*(j+1)], p) for j in range(4)]
print("Lin5 rank total", rank(Lin5, p), "by block k2,k3,k4,k5:", rk_by, "ob5(0) nonzero:", int(np.count_nonzero(o0[5])),
      "%.0fs" % (time.time()-t1), flush=True)
# A = { o0 + Lin5 k = 0 }
Ab = np.hstack([Lin5, (o0[5] % p).reshape(-1, 1)])
if rank(Ab, p) != rank(Lin5, p):
    print("ob_5 = 0 has NO solution (affine system inconsistent)"); sys.exit()
N5 = nullspace(Ab, p)   # homogenised
# particular solution: column of N5 with last coord nonzero
j = int(np.flatnonzero(N5[-1])[0]); part = N5[:, j] * pow(int(N5[-1, j]), p-2, p) % p
Nh = nullspace(Lin5, p)
print("dim A =", Nh.shape[1], flush=True)
def unpack(v): return {n: v[dimK*(n-2):dimK*(n-1)] % p for n in range(2, 6)}
def rA(): return unpack(part[:-1] + Nh @ fs.rng.integers(0, p, size=Nh.shape[1]))
u0 = unpack(part[:-1]); o_u0 = ev(u0)
print("at u0: ob_2..ob_5 nonzero:", [int(np.count_nonzero(o_u0[n])) for n in range(2, 6)], "ob_6 nonzero:", int(np.count_nonzero(o_u0[6])), flush=True)
e6 = o_u0[6]
Wc = np.zeros((26, 0), dtype=np.int64); still = 0; ns = 0; chk = []
while still < 6 and ns < 40:
    u = rA(); o = ev(u); ns += 1
    chk.append(max(int(np.count_nonzero(o[n])) for n in range(2, 6)))
    d = ((o[6] - e6) % p).reshape(-1, 1)
    if rank(np.hstack([Wc, d]), p) > rank(Wc, p): Wc = np.hstack([Wc, d]); still = 0
    else: still += 1
print("samples on A:", ns, "max nonzero of ob_2..5 at samples:", max(chk), "dim W = span(ob_6(u)-ob_6(u0)):", rank(Wc, p), flush=True)
if not in_span(Wc, e6, p):
    ell = nullspace(Wc.T, p) if Wc.shape[1] else np.eye(26, dtype=np.int64)
    ell = ell[:, [int(np.flatnonzero((ell.T @ e6) % p)[0])]].ravel()
    vals = [int(ell @ ev(rA())[6] % p) for _ in range(10)]
    print("OBSTRUCTED: ob_6(u0) not in W; functional l with l(W)=0: l.ob_6(u0) =", int(ell @ e6 % p),
          "; l.ob_6 at 10 fresh points of A:", vals, flush=True)
else:
    # affine on A?
    ua, ub = rA(), rA()
    a_, b_, ab_ = ev(ua), ev(ub), ev({n: (ua[n] + ub[n] - u0[n]) % p for n in ua})
    aff6 = not ((ab_[6] - a_[6] - b_[6] + e6) % p).any()
    print("ob_6(u0) lies in W; ob_6 affine on A (one test):", aff6, flush=True)
    # linear part on A via finite differences along Nh columns
    D = np.array([(ev(unpack(part[:-1] + Nh[:, i]))[6] - e6) % p for i in range(Nh.shape[1])]).T
    sol = None
    Dh = np.hstack([D, (e6 % p).reshape(-1, 1)])
    if rank(Dh, p) == rank(D, p):
        Nn = nullspace(Dh, p); jj = int(np.flatnonzero(Nn[-1])[0]); a = Nn[:-1, jj] * pow(int(Nn[-1, jj]), p-2, p) % p
        u = unpack(part[:-1] + Nh @ a); o, T = fs.evaluate(u)
        print("candidate from affine model: ob_2..ob_6 nonzero:", [int(np.count_nonzero(o[n])) for n in range(2, 7)], flush=True)
        # T6 = -X c'_6, direct verification
        c6 = fs.cprime(6, T, {n: fs.poly3(T[n]) for n in range(2, 6)})
        T6 = (-fs.X @ c6) % p
        print("DIRECT verification of the constructed jet T_1..T_6: nonzero c_n among 45, n=1..6:", fs.direct(T, T6), flush=True)
    else:
        print("linearisation of ob_6 on A not solvable; OPEN")
print("total %.0fs" % (time.time()-t0))
