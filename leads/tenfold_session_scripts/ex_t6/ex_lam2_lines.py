# EX-T6: exact checks of the shape of the order-5/6 equations at lambda = 2 along random lines (supports the ARG hypotheses):
# (i) K.c4 = 0 and K.c5 = K.c5(0) + DG4 x2 exactly along random lines x2 = s w (w in ker L): no quadratic x2-terms;
# (ii) along x2 = x2* + s k, k in ker DG4: K.c2..5 = 0, K.c6 has no cubic term, quadratic and linear terms in Im DG4,
#      y.c6 constant = 480 (1 + z);  (iii) x3 = s u: K.c6 = K.c6(x2*) + s DG4 u exactly (no quadratic x3-term).
import sys, time, pickle, random, numpy as np
sys.path.insert(0, '/home/claude/hodge/discovery/checks/ex_t6')
from fex import *
from exarc import *
from dirs_exact import *
lam = 2; t00 = time.time(); random.seed(int(sys.argv[1]) if len(sys.argv) > 1 else 1)
def say(*a): print(*a, "(%.0fs)" % (time.time() - t00), flush=True)
X = ExactEngine(lam); X.setup_L(); v = v_exact(X, lam); n = 221
d = pickle.load(open('arc_lam2_exact.pkl', 'rb'))
x2s = np_to_mat(np.array([fmpq(t) for t in d['x2']], dtype=object)); y = [fmpq(t) for t in d['y']]
def rvec(k, scale=3): return np_to_mat(np.array([fmpq(random.randint(-scale, scale)) for _ in range(k)], dtype=object))
def K_at(xs, N):
    a = Arc(X, v)
    for j, x in xs.items(): a.set_x(j, x)
    a.extend(N); return a
base = K_at({}, 5)
D = X.K * lin(X, base.MHs, 2, X.kerL, 5)[5]; rD = rank(D)
for t in range(2):
    w = rvec(364)
    vals = [K_at({2: w * fmpq(s)}, 5) for s in (1, 2)]
    say("(i) line", t, ": K.c4 = 0:", [iszero(a.Kc[4]) for a in vals], " K.c5 = K.c5(0) + s DG4 w:",
        [a.Kc[5] == base.Kc[5] + D * w * fmpq(s) for a, s in zip(vals, (1, 2))])
a0 = K_at({2: x2s}, 6); ob6 = a0.Kc[6]
kD = kernel(D)
for t in range(3):
    k = kD * rvec(kD.ncols(), 2)
    f = [ob6] + [None] * 3; ok_low = True; yc = []
    for s in (1, 2, 3):
        a = K_at({2: x2s + k * fmpq(s)}, 6); f[s] = a.Kc[6]
        ok_low = ok_low and all(iszero(a.Kc[m]) for m in (2, 3, 4, 5))
        yc.append(qz_dot(y, a.cs[6].entries(), n))
    d3 = f[3] - f[2] * 3 + f[1] * 3 - f[0]
    a2 = (f[2] - f[1] * 2 + f[0]) * fmpq(1, 2); a1 = f[1] - f[0] - a2
    say("(ii) line", t, ": K.c2..5 = 0:", ok_low, " cubic term 0:", iszero(d3), " quadratic term in Im DG4:", rank(hcat(D, a2)) == rD,
        " linear term in Im DG4:", rank(hcat(D, a1)) == rD, " y.c6 along the line:", yc)
for t in range(2):
    u = rvec(364)
    vals = [K_at({2: x2s, 3: u * fmpq(s)}, 6) for s in (1, 2)]
    say("(iii) line", t, ": K.c2..5 = 0:", [all(iszero(a.Kc[m]) for m in (2, 3, 4, 5)) for a in vals],
        " K.c6 = K.c6(x2*) + s DG4 u:", [a.Kc[6] == ob6 + D * u * fmpq(s) for a, s in zip(vals, (1, 2))])
