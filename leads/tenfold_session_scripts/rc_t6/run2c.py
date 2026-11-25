# T6e: arcs with fixed tangent v to order N with the FULL linearised freedom (all x_j, j = 2..n-3, in ker L),
# followed by an EXACT recomputation (a solution that survives the exact recomputation is a genuine arc mod p).
# python3 run2.py p lam seed kind N
import sys, time, numpy as np
sys.path.insert(0, '/home/claude/hodge/discovery/t6_unsolved/e')
from ana import *

def build(E, v, xs, N):
    """T_1 = v, T_j = SL c_j + kerL x_j. returns Ts, list of K.c_n (n = 1..N), MH list (0..N-1)"""
    p = E.p; SL = E.solveL_matrix(); kerL = E.kerL
    Ts = [v % p]; Tp = [E.vec_to_poly(Ts[0])]
    Es = [E.poly_one(), Tp[0]]; MHs = [E.L, E.MH(Tp[0])]
    Kc = [np.zeros(E.Kl.shape[0], dtype=np.int64)] * 2
    for n in range(2, N + 1):
        inv = pow(n, p - 2, p)
        c = np.zeros(E.L.shape[0], dtype=np.int64)
        for j in range(1, n):
            c = (c + j * (MHs[n - j] @ Ts[j - 1] % p)) % p
        c = c * inv % p
        Kc.append(E.Kpart(c))
        if n == N: break
        T = SL @ c % p
        if n in xs: T = (T + kerL @ xs[n]) % p
        Ts.append(T); Tp.append(E.vec_to_poly(T))
        terms = [(j * inv, E.mul(Tp[j - 1], Es[n - j])) for j in range(1, n + 1)]
        En = E.add(*terms)
        Es.append(En); MHs.append(E.MH(En))
    return Ts, Kc, MHs

def jac(E, MHs, n, jmin=2):
    """J[m][j] = K-part of dc_m for dx_j (columns: ker L coords), m = 5..n, j = jmin..n-3; also checks K.dc for
    m < j+3 vanish."""
    p = E.p; SL = E.solveL_matrix(); kerL = E.kerL
    blocks = {}
    ok = True
    for j in range(jmin, n - 2):
        dT = {j: kerL % p}
        for m in range(j + 1, n + 1):
            dc = np.zeros((E.L.shape[0], kerL.shape[1]), dtype=np.int64)
            for i in range(j, m):
                dc = (dc + MHs[m - i] @ dT[i]) % p
            Kd = E.Kl @ dc % p
            if m < j + 3 and Kd.any(): ok = False
            if m >= 5: blocks[(m, j)] = Kd
            dT[m] = SL @ dc % p
    rows = []
    for m in range(5, n + 1):
        row = [blocks.get((m, j), np.zeros((E.Kl.shape[0], kerL.shape[1]), dtype=np.int64)) for j in range(jmin, n - 2)]
        rows.append(np.concatenate(row, 1))
    return np.concatenate(rows, 0), ok

def run(p, lam, seed, kind, N, v=None, quiet=False):
    E, X = setup(p, lam)
    rng = np.random.default_rng(seed)
    if v is None: v, info = directions(E, X, rng, kind)
    tag = "p=%d lam=%d seed=%d kind=%s" % (p, lam, seed, kind)
    xs = {}
    t0 = time.time()
    hist = []
    for n in range(4, N + 1):
        Ts, Kc, MHs = build(E, v, xs, n)
        low = [m for m in range(2, n) if Kc[m].any()]
        if low: report(tag, "ERROR lower orders nonzero", low); return tag, ('error', n)
        if not Kc[n].any():
            report(tag, "order", n, "K.c zero"); hist.append((n, 'zero')); continue
        if n == 4:
            report(tag, "RESULT obstructed at order 4 (choice independent)"); return tag, ('obstructed', 4)
        J, ok = jac(E, MHs, n)
        rhs = np.zeros(J.shape[0], dtype=np.int64); rhs[-E.Kl.shape[0]:] = (-Kc[n]) % p
        DG = J[:E.Kl.shape[0], :E.kerL.shape[1]]
        top = E.solve(DG, (-Kc[n]) % p)
        if top is not None:
            sol = np.zeros(J.shape[1], dtype=np.int64); sol[-E.kerL.shape[1]:] = top
        else:
            sol = E.solve(J, rhs)
        rJ = E.rank(J)
        report(tag, "order", n, "K.c nnz", np.count_nonzero(Kc[n]), "rank J", rJ, "(", J.shape, ") lin. solvable?", sol is not None,
               "K.dc low ok", ok, "in Im DG4 alone?", E.in_span(DG, Kc[n]))
        if sol is None:
            report(tag, "RESULT order", n, "NOT removable by the linearised freedom of x_2..x_%d" % (n - 3), "time %.1f" % (time.time() - t0))
            return tag, ('linobstructed', n, Ts)
        nk = E.kerL.shape[1]
        for idx, j in enumerate(range(2, n - 2)):
            dx = sol[idx * nk:(idx + 1) * nk]
            xs[j] = (xs.get(j, np.zeros(nk, dtype=np.int64)) + dx) % p
        Ts, Kc, MHs = build(E, v, xs, n)
        bad = [m for m in range(2, n + 1) if Kc[m].any()]
        report(tag, "   exact recomputation: nonzero K orders", bad)
        if bad:
            report(tag, "RESULT order", n, "linear correction does not survive the exact recomputation"); return tag, ('nonlinear', n, Ts)
        hist.append((n, 'corrected'))
    report(tag, "RESULT arc exists to order", N, "(mod p, exact recomputation)", hist, "time %.1f" % (time.time() - t0))
    np.save('/home/claude/hodge/discovery/checks/rc_t6/arc2_%d_%d_%d_%s_%d.npy' % (p, lam, seed, kind, N), np.array(Ts))
    return tag, ('survives', N, Ts)

if __name__ == '__main__':
    p = int(sys.argv[1]); lam = int(sys.argv[2]); seed = int(sys.argv[3]); kind = sys.argv[4]; N = int(sys.argv[5])
    run(p, lam, seed, kind, N)
