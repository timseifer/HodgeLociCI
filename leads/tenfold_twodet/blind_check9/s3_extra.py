import numpy as np, random
from fermat import *
P = all_pairings()
# (b) sum over one exponent with the others fixed has intersection number 1 with every plane (= h^5)
E0 = [[k,1,2,0,0,0] for k in range(3)] + [[2,k,1,0,0,0] for k in range(3)] + [[0,2,1,k,0,0] for k in range(3)]
I = inter_with_all(PI0, E0, P).astype(np.int64)
for t in range(3):
    s = I[:, :, 3*t:3*t+3].sum(axis=2)
    print("sum_k p(..k..).P == 1 for all 7577955 planes:", bool(np.all(s == 1)))
# find example pairs (P1,P2) with m=2 of each cycle type, to hand to M2
random.seed(5)
found = {}
for tries in range(300000):
    pi2 = random.choice(P); e2 = [random.randrange(3) for _ in range(6)]
    if dim_by_cycles(PI0, [0]*6, pi2, e2) == 2:
        typ = tuple(sorted(sum(abs(x) for x in s) for s, t in cycles(PI0, pi2)))
        if typ not in found: found[typ] = (pi2, e2)
found[(1,1,1,1,1,1)] = (PI0, [1,1,1,0,0,0])
with open("pairs_m2.txt", "w") as fh:
    for typ, (pi2, e2) in sorted(found.items()):
        print(typ, pi2, e2)
        fh.write("{" + ",".join("{%d,%d,%d}" % (i, j, e) for (i, j), e in zip(pi2, e2)) + "}\n")
