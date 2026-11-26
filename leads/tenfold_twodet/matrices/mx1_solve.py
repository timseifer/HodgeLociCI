"""mx1: numerical solutions (A, B) of det A + det B = F_eps along T2's arc; controls.  NUMERICAL.
usage (repository root): python3 leads/tenfold_twodet/matrices/mx1_solve.py [starts] [seed] [output directory]"""
import sys, numpy as np
sys.path.insert(0, "leads/tenfold_twodet/matrices")
from mx_common import *
starts = int(sys.argv[1]) if len(sys.argv) > 1 else 6
rng = np.random.default_rng(int(sys.argv[2]) if len(sys.argv) > 2 else 1)
arc = parse_arc()
print("arc terms per order:", [len(T) for T in arc])
# M0: synthetic control
X0 = rng.standard_normal((2, 3, 3, 8)) + 1j * rng.standard_normal((2, 3, 3, 8))
res = [solve(lambda Y: cubic_from_matrices(X0, Y), rng)[1:] for _ in range(4)]
print("M0 synthetic target det A0 + det B0, 4 random starts: (rms residual, iterations):", [(f"{a:.1e}", b) for a, b in res])
size10 = max(abs(c) for c in arc[8].values())
for eps in [0.2, 0.15, 0.1, 0.07]:
    F = cubic_terms(eps, arc)
    out = []
    best = None
    for s in range(starts):
        X, f, it = solve(lambda Y: eval_cubic(F, Y), rng)
        out.append(f)
        if best is None or f < best[1]: best = (X, f)
    # control: Fermat + a random cubic on the same monomials and of the same size as eps T_1 (not on the arc)
    Fc = {(i, i, i): 1.0 + 0j for i in range(8)}
    for idx, c in arc[0].items():
        Fc[idx] = -eps * abs(c) * np.exp(2j * np.pi * rng.random())
    outc = [solve(lambda Y: eval_cubic(Fc, Y), rng)[1] for s in range(max(2, starts // 2))]
    nrm = [np.linalg.norm(best[0][s]) for s in range(2)]
    print(f"eps = {eps}: truncation scale eps^10 * |T_9| = {eps**10 * size10:.1e} ; rms residuals over {starts} starts: "
          + ", ".join(f"{v:.1e}" for v in sorted(out)) + " ; control (not on the arc): " + ", ".join(f"{v:.1e}" for v in sorted(outc))
          + f" ; norms of the best (A, B): {nrm[0]:.1f}, {nrm[1]:.1f}")
    if len(sys.argv) > 3: np.save(f"{sys.argv[3]}/sol_eps{eps}.npy", best[0])      # optional output directory
