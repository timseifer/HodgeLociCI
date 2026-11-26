import numpy as np
from math import gcd
from fermat import *
P = all_pairings()
tests = {
 "(1,1,1,1,2)": (((0,1),(2,3),(4,10),(5,11),(6,7),(8,9)), [1,0,2,2,2,0]),
 "(2,2,2)":     (((0,10),(1,11),(2,5),(3,4),(6,8),(7,9)), [1,1,0,0,1,1]),
}
A = inter_with_all(PI0, [[0]*6], P)[:, :, 0].astype(np.int64)
for name, (pi2, e2) in tests.items():
    m = dim_by_cycles(PI0, [0]*6, pi2, e2)
    B = inter_with_all(pi2, [e2], P)[:, :, 0].astype(np.int64)
    V = A - B; vals = np.unique(V).tolist()
    g = 0; gd = 0
    for v in vals: g = gcd(g, abs(v)); gd = gcd(gd, abs(v - vals[0]))
    print(name, "m =", m, "values", vals, "gcd(values) =", g, "gcd(differences) =", gd)
# rows vs columns: the 'column' version of T5 on the Fermat cubic. cols 1,2 of A0 proportional -> planes (a,e),(c,e),(c,b)
# i.e. (k1,k2) in {(0,2),(1,2),(1,0)}.  Compare classes with all Fermat planes.
Lr = [(0,0),(0,1),(1,1)]; Lc = [(0,2),(1,2),(1,0)]
def tot(LA, LB):
    E0 = [list(u + v + (0,0)) for u in LA for v in LB]
    return inter_with_all(PI0, E0, P).astype(np.int64).sum(axis=2)
rr = tot(Lr, Lr); rc = tot(Lr, Lc); cc = tot(Lc, Lc)
print("rows/rows vs cols/cols:  [T5cc]-3h^5 == +([T5rr]-3h^5) on all planes:", bool(np.all(cc - 3 == rr - 3)))
print("rows/rows vs rows/cols:  [T5rc]-3h^5 == -([T5rr]-3h^5) on all planes:", bool(np.all(rc - 3 == -(rr - 3))))
