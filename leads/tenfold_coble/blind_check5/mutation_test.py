"""mutation tests: the validation arc F0(g x) must FAIL when the period code is deliberately broken"""
import random, sys
import numpy as np
import pcore, arcs, validate
from arcs import X, TAU, F0

p = 2147483629
rng = random.Random(1)
lin, A, B = validate.random_g(rng)
G = sum(l**3 for l in lin) - F0
Ql = pcore.standard_forms()
kap = pcore.kappa_poly(p)
z = pcore.cube_roots_of_minus_one(p)
dl = pcore.comb([(pcore.plane(z[0], p), 1), (pcore.plane(z[1], p), -1)], p)
N = 5
Gp = arcs.split_tau(G, p, N)
res, first = pcore.expansion(Gp, N, p, [kap, dl], Ql)
print("unmutated: first nonzero orders (kappa, delta):", first)

# mutation 1: swap the Pochhammer bases 1/3 <-> 2/3
orig_init = pcore.Functional.__init__
def init_swapped(self, p, maxm=40):
    orig_init(self, p, maxm)
    self.T = self.T[::-1].copy()
pcore.Functional.__init__ = init_swapped
res, first = pcore.expansion(Gp, N, p, [kap, dl], Ql)
print("mutation 1 (Pochhammer bases swapped): first nonzero orders:", first)

# mutation 2: Pochhammer (a)_m replaced by a^m
def init_pow(self, p, maxm=40):
    orig_init(self, p, maxm)
    inv3 = pow(3, p - 2, p)
    for r in (0, 1):
        a = (1 + r) * inv3 % p
        for m in range(maxm + 1):
            self.T[r, m] = pow(a, m, p)
pcore.Functional.__init__ = init_pow
res, first = pcore.expansion(Gp, N, p, [kap, dl], Ql)
print("mutation 2 ((a)_m -> a^m): first nonzero orders:", first)
pcore.Functional.__init__ = orig_init

# mutation 3: exp(-G) replaced by 1/(1+G) (no factorials): rescale G_j-products: use recursion E_n = -sum G_j E_(n-j)
orig_exp = pcore.expansion
def expansion_geom(G, N, p, Pdicts, Qlist):
    fun = pcore.Functional(p)
    E = {0: pcore.Poly(np.array([0], dtype=np.int64), np.array([1], dtype=np.int64))}
    first = [None] * len(Pdicts)
    for n in range(1, N + 1):
        parts = [pcore.mul_small(E[n - j], G[j], p, c=p - 1) for j in range(1, n + 1) if j in G]
        E[n] = pcore.add_list(parts, p)
        for ci, Pd in enumerate(Pdicts):
            vec = fun.evaluate(E[n].k, E[n].v, Pd, Qlist)
            if first[ci] is None and any(vec):
                first[ci] = n
    return first
print("mutation 3 (geometric series instead of exponential): first nonzero orders:", expansion_geom(Gp, N, p, [kap, dl], Ql))
