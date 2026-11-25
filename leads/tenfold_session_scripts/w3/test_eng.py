import sys, time, numpy as np, pickle
sys.path.insert(0, '/home/claude/hodge/discovery/checks/w3')
from w3eng import W3Engine
from fe_big_copy import Engine
from flint import fmpq
p = 67108837
def red(s, p):
    x = fmpq(s); return int(x.p % p) * pow(int(x.q % p), p - 2, p) % p
d = pickle.load(open('/home/claude/hodge/discovery/checks/ex_t6/arc_lam1_exact.pkl', 'rb'))
zs = [a for a in range(2, 200000000) if (a * a - a + 1) % p == 0][:1] if False else None
# roots of z^2 - z + 1 mod p
from sympy import sqrt_mod
r = sqrt_mod(-3, p, all_roots=True); inv2 = pow(2, p - 2, p)
zs = sorted(set((1 + x) * inv2 % p for x in r)); print("z roots", zs)
zp = zs[0]
t = time.time(); W = W3Engine(p, -1, z=zp); print("W init %.1f" % (time.time() - t)); t = time.time()
B = Engine(p, -1, z=zp); print("B init %.1f" % (time.time() - t))
print("L equal", np.array_equal(W.L, B.L), "rank", W.Lrank)
Ts = [np.array([(red(T[i], p) + red(T[220 + i], p) * zp) % p for i in range(220)], np.int64) for T in d['Ts']]
Tp = [W.vec_to_poly(T) for T in Ts]
Es = [W.poly_one()]
for n in range(1, 6):
    t = time.time(); En, acc, nt = W.Eprime(n, Tp, Es); t1 = time.time() - t
    t = time.time()
    inv = pow(n, p - 2, p)
    Eb = B.add(*[(j * inv, B.mul(Tp[j - 1], Es[n - j])) for j in range(1, n + 1)]); t2 = time.time() - t
    same = np.array_equal(En[0], Eb[0]) and np.array_equal(En[1], Eb[1])
    t = time.time(); M1 = W.MH_from_acc(acc); t3 = time.time() - t
    t = time.time(); M2 = B.MH(Eb); t4 = time.time() - t
    print(n, "|E'|", len(En[0]), "poly same", same, "MH same", np.array_equal(M1, M2), "times bucketprod+H %.1f / mul %.1f, MH(fe_big) %.1f" % (t1, t2, t4), flush=True)
    Es.append(En)
