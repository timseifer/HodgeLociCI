# EX-T6: exact evaluations at RANDOM points with large coefficients (Schwartz-Zippel test of the polynomial identities behind
# the lambda = 2 obstruction, package coordinates x_j in ker L):
# (A) K.c2..4 = 0 and K.c5 = K.c5(0) + DG4 x2 for all x2, x3, x4 in ker L     (polynomials of degree <= 2 in (x2, x3, x4))
# (B) for x2 = x2* + k (k in ker DG4), any x3, x4: K.c2..5 = 0 and y.c6 = 480 (1 + z)   (degree <= 3 in (k, x3, x4))
# Random coordinates uniform in [-R, R], R = 10^6: a false identity survives one point with probability <= 3/(2R+1).
import sys, time, pickle, random, numpy as np
sys.path.insert(0, '/home/claude/hodge/discovery/checks/ex_t6')
from fex import *
from exarc import *
from dirs_exact import *
lam = 2; t00 = time.time(); random.seed(int(sys.argv[1]) if len(sys.argv) > 1 else 7); R = 10 ** 6
def say(*a): print(*a, "(%.0fs)" % (time.time() - t00), flush=True)
X = ExactEngine(lam); X.setup_L(); v = v_exact(X, lam); n = 221
d = pickle.load(open('arc_lam2_exact.pkl', 'rb'))
x2s = np_to_mat(np.array([fmpq(t) for t in d['x2']], dtype=object)); y = [fmpq(t) for t in d['y']]
def rvec(k): return np_to_mat(np.array([fmpq(random.randint(-R, R)) for _ in range(k)], dtype=object))
def at(xs, N):
    a = Arc(X, v)
    for j, x in xs.items(): a.set_x(j, x)
    return a.extend(N)
base = at({}, 5); D = X.K * lin(X, base.MHs, 2, X.kerL, 5)[5]; kD = kernel(D)
for t in range(2):
    w = rvec(364); a = at({2: w, 3: rvec(364), 4: rvec(364)}, 5)
    say("(A) point (random x2, x3, x4)", t, ": K.c2, K.c3, K.c4 = 0:", [iszero(a.Kc[m]) for m in (2, 3, 4)], " K.c5 = K.c5(0) + DG4 x2:", a.Kc[5] == base.Kc[5] + D * w)
for t in range(3):
    k = kD * rvec(kD.ncols()); a = at({2: x2s + k, 3: rvec(364), 4: rvec(364)}, 6)
    say("(B) point", t, ": K.c2..5 = 0:", [iszero(a.Kc[m]) for m in (2, 3, 4, 5)], " y.c6 =", qz_dot(y, a.cs[6].entries(), n), " K.c6 nnz", nnz(a.Kc[6]))
