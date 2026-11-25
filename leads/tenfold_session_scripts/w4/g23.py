# W4: exact (Q(z)) Schwartz-Zippel test that G2 = G3 = 0 identically on ker L (dense random points), lambda from argv.
import sys, random, time
sys.path.insert(0, '/home/claude/hodge/discovery/checks/ex_t6')
from fex import *
from exarc import *
lam = int(sys.argv[1]); seed = int(sys.argv[2]); N = int(sys.argv[3]) if len(sys.argv) > 3 else 3
t0 = time.time()
X = ExactEngine(lam); X.setup_L()
random.seed(seed)
k = X.kerL.ncols()
x1 = fmpq_mat(k, 1, [random.randint(-10**6, 10**6) for _ in range(k)])
v = X.kerL * x1
arc = Arc(X, v)
x2 = fmpq_mat(k, 1, [random.randint(-10**6, 10**6) for _ in range(k)])
arc.set_x(2, x2)
arc.extend(N, verbose=True)
print("lam", lam, "seed", seed, "L v = 0:", iszero(X.L * v), " K.c_n zero for n = 2..%d:" % N, [iszero(arc.Kc[n]) for n in range(2, N + 1)],
      " nnz:", [nnz(arc.Kc[n]) for n in range(2, N + 1)], "(%.0fs)" % (time.time() - t0), flush=True)
