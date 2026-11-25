# EX-T6 PRE 3a: check the exact lambda = 2 arc and certificate y with T6e's fe.py (own functional, own SL, own ker L) mod p.
import sys, pickle, json, numpy as np
sys.path.insert(0, '/home/claude/hodge/discovery/checks/ex_t6'); sys.path.insert(0, '/home/claude/hodge/discovery/t6_unsolved/e')
from fe import Engine
from flint import fmpq
def red(s, p):
    x = fmpq(s); assert int(x.q) % p
    return int(x.p % p) * pow(int(x.q % p), p - 2, p) % p
def zroots(p):
    r = [a for a in range(2, p) if (a * a - a + 1) % p == 0]
    return r
d = pickle.load(open(__import__('os').environ.get('EXT6_PKL', '/home/claude/hodge/discovery/checks/ex_t6/arc_lam2_exact.pkl'), 'rb'))
y = d['y']; n = 221
for p in [int(a) for a in sys.argv[1:]]:
    for zp in zroots(p):
        E = Engine(p, 2, z=zp)
        Ts = [np.array([(red(T[i], p) + red(T[220 + i], p) * zp) % p for i in range(220)], np.int64) for T in d['Ts']]
        c6x = np.array([(red(d['c6'][i], p) + red(d['c6'][n + i], p) * zp) % p for i in range(n)], np.int64)
        yp = np.array([(y[i] + y[n + i] * zp) % p for i in range(n)], np.int64)
        cs, Es, MHs = E.series(Ts, 6)
        solved = [not ((E.L @ Ts[k - 1] + cs[k - 1]) % p).any() for k in range(2, 6)]
        Kc = [int(np.count_nonzero(E.Kpart(cs[k - 1]))) for k in range(2, 7)]
        SL = E.solveL_matrix(); kerL = E.kerL
        dT = {2: kerL}; dc = {}
        for m in range(3, 7):
            acc = np.zeros((221, kerL.shape[1]), np.int64)
            for i in range(2, m): acc = (acc + MHs[m - i] @ dT[i]) % p
            dc[m] = acc; dT[m] = SL @ acc % p
        D = E.Kl @ dc[5] % p
        kD = E.kernel(D)
        Lam = dc[6] @ kD % p
        print("p", p, "z", zp, "L T_n + c_n = 0 (n=2..5):", solved, " K.c_n nnz n=2..6:", Kc, " c6 == exact c6:", np.array_equal(cs[5], c6x),
              " rank DG4:", E.rank(D), " y.L = 0:", not (yp @ E.L % p).any(), " y.dc5 = 0:", not (yp @ dc[5] % p).any(),
              " y.Lambda(kerDG4) = 0:", not (yp @ Lam % p).any(), " y.c6 =", int(yp @ cs[5] % p), "(!= 0)", flush=True)
