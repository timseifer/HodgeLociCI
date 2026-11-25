# [BC-TS] own engine at gseed 0 (Fermat tenfold) vs the tooling reference fe_ref.py (Fermat closed form): L, MH(E) on random E.
import sys, json, numpy as np
sys.path.insert(0, '/home/claude/hodgelocici/tooling/fermat_series')
from fe_ref import Engine
from bcpsi import PsiB, build
from bceng import BCEngine
p = int(sys.argv[1]); lam = int(sys.argv[2]) % p
z = json.load(open('/home/claude/hodge/discovery/checks/ts_t6/primes.json'))['roots_of_z2_minus_z_plus_1'][str(p)][0]
D = 15
G, P1, P2 = build(p, z, 0); Y = PsiB(p, G, D, log=lambda *a: None)
t1 = Y.table(*P1, (-729) % p); t2 = Y.table(*P2, (-729) % p)
W = BCEngine(p, lam, z, t1, t2, D)
R = Engine(p, lam, z=z)
print("L equal:", np.array_equal(W.L, R.L), "rank L", W.Lrank)
rng = np.random.default_rng(5)
T1 = rng.integers(0, p, 220) * (rng.random(220) < 0.3); T2 = rng.integers(0, p, 220) * (rng.random(220) < 0.3)
E1 = W.vec_to_poly(T1); E2 = W.Eprime(2, [W.vec_to_poly(T1), W.vec_to_poly(T2)], [W.one(), E1])
rE1 = R.vec_to_poly(T1)
rE2 = R.add((1, R.mul(R.vec_to_poly(T1), rE1)), (1, R.vec_to_poly(T2)))
rE2 = (rE2[0], rE2[1] * pow(2, p - 2, p) % p)
# R.add with coefficient: E'_2 = (1/2)(T1 E'_1 + 2 T2)
rE2 = R.add((pow(2, p - 2, p), R.mul(R.vec_to_poly(T1), rE1)), (1, R.vec_to_poly(T2)))
print("nterms E'_2 own / ref:", len(E2[0]), len(rE2[0]))
print("MH(E'_1) equal:", np.array_equal(W.MH(E1), R.MH(rE1)))
print("MH(E'_2) equal:", np.array_equal(W.MH(E2), R.MH(rE2)))
E3 = W.Eprime(3, [W.vec_to_poly(T1), W.vec_to_poly(T2)], [W.one(), E1, E2])
rE3 = R.add((pow(3, p - 2, p), R.mul(R.vec_to_poly(T1), rE2)), (2 * pow(3, p - 2, p), R.mul(R.vec_to_poly(T2), rE1)))
print("MH(E'_3) equal:", np.array_equal(W.MH(E3), R.MH(rE3)))
