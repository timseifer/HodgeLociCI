# [TS-T6] split point data: G = f^T M0 h (Q1 = V(f), Q2 = V(h)) in the pair coordinates of x6..x11; Psi_B tables.
import numpy as np, time
from psib import *

def pair_forms(p, z):
    zb = (1 - z) % p; f = []; h = []; l = []
    for k in range(3):
        a, b = 2 * k, 2 * k + 1
        f.append(lin([1 if j == a else ((-z) % p if j == b else 0) for j in range(6)]))
        h.append(lin([1 if j in (a, b) else 0 for j in range(6)]))
        l.append(lin([1 if j == a else ((-zb) % p if j == b else 0) for j in range(6)]))
    return f, h, l

def M0_of(seed):
    """seed 0: Fermat (M0 = diag(l_k)); seed >= 1: integer random 3x3 matrix of linear forms in w = (f1,f2,f3,h1,h2,h3),
    entries in [-9, 9]"""
    if seed == 0: return None
    rng = np.random.default_rng(1000 + seed)
    return rng.integers(-9, 10, (3, 3, 6))

def build_G(p, z, seed):
    f, h, l = pair_forms(p, z); w = f + h
    M0 = M0_of(seed)
    if M0 is None:
        M = [[l[i] if i == j else {} for j in range(3)] for i in range(3)]
    else:
        M = [[{} for j in range(3)] for i in range(3)]
        for i in range(3):
            for j in range(3):
                for k in range(6):
                    if M0[i, j, k]: M[i][j] = padd(M[i][j], {e: c * int(M0[i, j, k]) % p for e, c in w[k].items()}, p)
    g1 = [{} for _ in range(3)]; g2 = [{} for _ in range(3)]
    for i in range(3):
        for j in range(3):
            g1[i] = padd(g1[i], pmul(M[i][j], h[j], p), p)
            g2[j] = padd(g2[j], pmul(f[i], M[i][j], p), p)
    G = {}
    for i in range(3): G = padd(G, pmul(f[i], g1[i], p), p)
    return G, (f, g1), (h, g2), M

def kappa(p, z, T):
    G, P1, P2, _ = build_G(p, z, 0)
    Y = Fourfold(p, G, [P1, P2], T); Y.socle()
    cg = Y.psi3_cg(*P1); cl = fermat_closed(p, z, z, T, 3)
    i = np.nonzero(cl)[0][0]
    return int(cl[i] * pow(int(cg[i]), p - 2, p) % p)

def psi_tables(p, z, seed, Dmax, log=print, checks=True):
    T = Tables(Dmax)
    kap = kappa(p, z, T)
    G, P1, P2, M = build_G(p, z, seed)
    Y = Fourfold(p, G, [P1, P2], T)
    info = Y.check_smooth_and_slice(); log("G seed %d: %s" % (seed, info))
    assert info['smooth (R_7 = 0)'] and info['squarefree complement deg2'] and info['squarefree complement deg3']
    Y.socle(); Y.cofactors7()
    tabs = []
    psi3s = []
    for name, (f, g) in (("Q1", P1), ("Q2", P2)):
        psi = {0: np.zeros(1, np.int64), 3: Y.psi3_cg(f, g) * kap % p}
        psi3s.append(psi[3])
        x, rep = Y.psi6(psi[3], f); log("%s degree 6: %s" % (name, rep)); assert rep['consistent']
        psi[6] = x
        for d in range(9, Dmax + 1, 3): psi[d] = Y.extend(psi, d)
        if checks:
            log("%s checks: I^3 at deg 9 (bad of 20): %d; I^4 at deg 12: %s; (I + J)_3 annihilated: %s" % (name, Y.check_Ipower(psi[9], 9, f, 3),
                Y.check_Ipower(psi[12], 12, f, 4) if Dmax >= 12 else '-', Y.check_Ipower(psi[3], 3, f, 1) == 0))
        if seed == 0:
            c = z if name == "Q1" else (p - 1)
            log("%s equals Fermat closed form on degrees 0..%d: %s" % (name, Dmax, all(np.array_equal(psi[d], fermat_closed(p, z, c, T, d)) for d in range(3, Dmax + 1, 3))))
        full = np.zeros(T.OFF[-1], np.int64)
        for d in range(0, Dmax + 1, 3): full[T.OFF[d]:T.OFF[d + 1]] = psi[d]
        tabs.append(full)
    # intersection check on H^{2,2}: <Q1p,Q2p> / <Q1p,Q1p> = -1/8, <Q2p,Q2p> = <Q1p,Q1p>
    sq3 = [i for i, e in enumerate(T.M[3]) if max(e) <= 1]
    Bm = np.zeros((20, 20), np.int64)
    for a, ia in enumerate(sq3):
        for b, ib in enumerate(sq3):
            e = tuple(x + y for x, y in zip(T.M[3][ia], T.M[3][ib]))
            Bm[a, b] = Y.phi[T.idx[6][e]]
    R, piv = rref(np.concatenate([Bm, np.eye(20, dtype=np.int64)], 1), p); Binv = R[:, 20:]
    u = [ps[sq3] for ps in psi3s]
    q11 = int(u[0] @ Binv % p @ u[0] % p); q12 = int(u[0] @ Binv % p @ u[1] % p); q22 = int(u[1] @ Binv % p @ u[1] % p)
    log("intersection check: 8 <Q1,Q2> + <Q1,Q1> = 0: %s; <Q2,Q2> = <Q1,Q1>: %s; <Q1,Q1> != 0: %s" % ((8 * q12 + q11) % p == 0, q11 == q22, q11 != 0))
    return T, tabs, Y, (G, P1, P2, M)
