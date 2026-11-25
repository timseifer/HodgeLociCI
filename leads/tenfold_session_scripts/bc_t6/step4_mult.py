# multiplicity of the (Lyapunov-Schmidt) obstruction along straight lines t*kappa, kappa random in ker L_W
import sys
sys.path.insert(0, '/home/claude/hodge/discovery/checks/bc_t6')
from arc import *
p = int(sys.argv[1]); lam = int(sys.argv[2]); sl = sys.argv[3]; N = int(sys.argv[4]); trials = int(sys.argv[5])
S = {"8": [0, 1, 6, 7, 8, 9, 10, 11], "10": [0, 1, 2, 3, 6, 7, 8, 9, 10, 11], "12": list(range(12))}[sl]
St = Setup(p, lam, S)
LW = St.Mmat(Poly.mono(p, [0] * NV)); K = nullspace(LW, p)
rng = np.random.default_rng(7)
print("slice", sl, "lam", lam, "dim W", len(St.Wmon), "rank L_W", rank(LW, p), "dim ker", len(K))
for tr in range(trials):
    kap = mm(rng.integers(0, p, size=len(K))[None, :], K, p)[0]
    Fs = [St.Wpoly(kap)]
    first = None
    for n in range(2, N + 1):
        E = expE(Fs + [Poly(p)], p, n); r = St.phi(E[n])
        sol = solve(LW, (3 * r) % p, p)
        if sol is None:
            first = n; break
        Fs.append(St.Wpoly(sol))
    print("random kernel direction", tr, ": first order with residual outside Im L =", first, flush=True)
