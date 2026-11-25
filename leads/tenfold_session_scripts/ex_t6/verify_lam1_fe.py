# EX-T6: check the exact lambda = -1 order-8 arc with T6e's fe.py mod p (own functional): L T_n + c_n = 0 (n = 2..7), K.c_n = 0 (n = 2..8)
import sys, pickle, numpy as np
sys.path.insert(0, '/home/claude/hodge/discovery/t6_unsolved/e')
from fe import Engine
from flint import fmpq
def red(s, p):
    x = fmpq(s); assert int(x.q) % p
    return int(x.p % p) * pow(int(x.q % p), p - 2, p) % p
d = pickle.load(open(__import__('os').environ.get('EXT6_PKL', '/home/claude/hodge/discovery/checks/ex_t6/arc_lam1_exact.pkl'), 'rb'))
for p in [int(a) for a in sys.argv[1:]]:
    for zp in [a for a in range(2, p) if (a * a - a + 1) % p == 0]:
        E = Engine(p, -1, z=zp)
        Ts = [np.array([(red(T[i], p) + red(T[220 + i], p) * zp) % p for i in range(220)], np.int64) for T in d['Ts']]
        cs, Es, MHs = E.series(Ts, 8)
        c8x = np.array([(red(d['c8'][i], p) + red(d['c8'][221 + i], p) * zp) % p for i in range(221)], np.int64)
        print("p", p, "z", zp, "L T_n + c_n = 0 (n=2..7):", [not ((E.L @ Ts[k - 1] + cs[k - 1]) % p).any() for k in range(2, 8)],
              " K.c_n nnz (n=2..8):", [int(np.count_nonzero(E.Kpart(cs[k - 1]))) for k in range(2, 9)], " c8 == exact c8:", np.array_equal(cs[7], c8x),
              " P1 alone K-part nnz at n=2..8:", None, flush=True)
