# DA-T6 B1: T6e's arc test (run2 logic, re-used read-only) with GENERIC directions of Sigma1:
#   v = c + b, c = random element of the full T Cone_T (not only pure-y), b = bOf(rank-1 M) with random coefficients mod p.
# python3 b1.py p lam seed kind N     kind: al | la | cone (c only) | al_small (T6e's pure-y v0 + rank-1 with full random coeffs)
import sys, time, numpy as np
sys.path.insert(0, '/home/claude/hodge/discovery/t6_unsolved/e')
from ana import setup, bOf, report
from run2 import build, jac
p = int(sys.argv[1]); lam = int(sys.argv[2]); seed = int(sys.argv[3]); kind = sys.argv[4]; N = int(sys.argv[5])
E, X = setup(p, lam)
rng = np.random.default_rng(seed)
Mc = X['Mc'] % p; TC = E.kernel(Mc); TV = X['TV'] % p
us = [1, 3, 5]
def rnd(n): return rng.integers(0, p, n)
if kind in ('al', 'la', 'cone', 'al_y'):
    if kind == 'al_y':
        yIdx = [i for i, m in enumerate(E.mons) if all(m[j] == 0 for j in range(6))]
        cy = E.kernel(Mc[:, yIdx]); c = np.zeros(len(E.mons), dtype=np.int64); c[yIdx] = cy @ rnd(cy.shape[1]) % p
    else:
        c = TC @ rnd(TC.shape[1]) % p
    a = [int(x) for x in rnd(3)]; l = [{u: int(x) for u, x in zip(us, rnd(3))} for _ in range(3)]
    if kind in ('al', 'al_y'):
        M = [[{u: a[i] * cc % p for u, cc in l[j].items()} for j in range(3)] for i in range(3)]
    elif kind == 'la':
        M = [[{u: a[j] * cc % p for u, cc in l[i].items()} for j in range(3)] for i in range(3)]
    else:
        M = [[{} for j in range(3)] for i in range(3)]
    b = bOf(E, M)
    v = (c + b) % p
print("in TV?", E.in_span(TV, v), "in TCone?", E.in_span(TC, v), "in kerL?", not (E.L @ v % p).any(), flush=True)
tag = "p=%d lam=%d seed=%d kind=%s(generic)" % (p, lam, seed, kind)
xs = {}; t0 = time.time(); hist = []
for n in range(4, N + 1):
    Ts, Kc, MHs = build(E, v, xs, n)
    low = [m for m in range(2, n) if Kc[m].any()]
    if low: report(tag, "ERROR lower orders nonzero", low); break
    if not Kc[n].any():
        report(tag, "order", n, "K.c zero"); hist.append((n, 'zero')); continue
    if n == 4:
        report(tag, "RESULT obstructed at order 4"); break
    J, ok = jac(E, MHs, n)
    DG = J[:E.Kl.shape[0], :E.kerL.shape[1]]
    rhs = np.zeros(J.shape[0], dtype=np.int64); rhs[-E.Kl.shape[0]:] = (-Kc[n]) % p
    top = E.solve(DG, (-Kc[n]) % p)
    if top is not None:
        sol = np.zeros(J.shape[1], dtype=np.int64); sol[-E.kerL.shape[1]:] = top
    else:
        sol = E.solve(J, rhs)
    report(tag, "order", n, "K.c nnz", np.count_nonzero(Kc[n]), "rank DG4", E.rank(DG), "rank J", E.rank(J), "solvable", sol is not None,
           "in Im DG4 alone", top is not None)
    if sol is None:
        report(tag, "RESULT order", n, "NOT removable by the linearised freedom", "time %.1f" % (time.time() - t0)); break
    nk = E.kerL.shape[1]
    for idx, j in enumerate(range(2, n - 2)):
        xs[j] = (xs.get(j, np.zeros(nk, dtype=np.int64)) + sol[idx * nk:(idx + 1) * nk]) % p
    Ts, Kc, MHs = build(E, v, xs, n)
    bad = [m for m in range(2, n + 1) if Kc[m].any()]
    report(tag, "   exact recomputation: nonzero K orders", bad)
    if bad: report(tag, "RESULT nonlinear failure at", n); break
    hist.append((n, 'corrected'))
else:
    report(tag, "RESULT arc exists to order", N, hist, "time %.1f" % (time.time() - t0))
    np.save('/home/claude/hodge/discovery/checks/da_t6/arc_%d_%d_%d_%s_%d.npy' % (p, lam, seed, kind, N), np.array(Ts))
