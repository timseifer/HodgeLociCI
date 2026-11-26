import numpy as np, random, itertools, time
from collections import Counter
from fermat import *
random.seed(20261126)
P = all_pairings()
print("pairings:", len(P), " planes:", len(P)*729)

# 1. validate the cycle formula against honest ranks (complex SVD and mod 7), and against the Jacobian ring
bad = 0; cnt = Counter(); badK = 0
for trial in range(4000):
    pi1 = random.choice(P); pi2 = random.choice(P) if trial % 3 else pi1
    if trial % 7 == 0: pi2 = random.choice(P[:200])
    e1 = [random.randrange(3) for _ in range(6)]; e2 = [random.randrange(3) for _ in range(6)]
    if trial % 5 == 0:   # bias toward large intersections
        pi2 = pi1; e2 = e1[:]; 
        for _ in range(random.randrange(4)): e2[random.randrange(6)] = random.randrange(3)
    m1 = dim_by_rank(pi1, e1, pi2, e2); m2 = dim_by_rank_modp(pi1, e1, pi2, e2); m3 = dim_by_cycles(pi1, e1, pi2, e2)
    cnt[m3] += 1
    if not (m1 == m2 == m3): bad += 1
    K = K_pair(a_plane(pi1, e1), a_plane(pi2, e2))
    if K != ((-2)**(m3+1), 0): badK += 1
print("rank(complex) = rank(mod 7) = cycle formula on 4000 random pairs: mismatches", bad, " dims seen", dict(sorted(cnt.items())))
print("Jacobian-ring pairing [x_0..x_11] a_P a_P' == (-2)^(m+1) (i.e. P.P' = f(m)): mismatches", badK)
# targeted: pairs with many shared structure to hit m = 3,4
c2 = Counter(); badK2 = 0
for trial in range(3000):
    pi1 = random.choice(P); e1 = [random.randrange(3) for _ in range(6)]
    # random pairing obtained by re-matching two or three pairs
    ks = random.sample(range(6), random.choice([2, 2, 3]))
    verts = [v for k in ks for v in pi1[k]]; random.shuffle(verts)
    newp = [tuple(sorted(verts[2*a:2*a+2])) for a in range(len(ks))]
    pi2 = tuple(sorted([pi1[k] for k in range(6) if k not in ks] + newp))
    e2 = [random.randrange(3) for _ in range(6)]
    m1 = dim_by_rank(pi1, e1, pi2, e2); m3 = dim_by_cycles(pi1, e1, pi2, e2); c2[m3] += 1
    K = K_pair(a_plane(pi1, e1), a_plane(pi2, e2))
    if m1 != m3 or K != ((-2)**(m3+1), 0): badK2 += 1
print("targeted 3000 pairs: mismatches", badK2, dict(sorted(c2.items())))

# 2. C2: T5 = 9 planes, delta_2
Lsh = [(0,0),(0,1),(1,1)]
T5 = [(a[0], a[1], b[0], b[1], 0, 0) for a in Lsh for b in Lsh]
ap, am = (1,1), (0,2)
D2 = [((ap+ap+(0,0)), 1), ((ap+am+(0,0)), -1), ((am+ap+(0,0)), -1), ((am+am+(0,0)), 1)]
T5sq = sum(inter(PI0, x, PI0, y) for x in T5 for y in T5)
print("\n[T5].[T5] =", T5sq, "  [T5].h^5 =", len(T5), "  ([T5]-3h^5)^2 =", T5sq - 2*3*9 + 9*3)
d2sq = sum(s*t*inter(PI0, x, PI0, y) for x, s in D2 for y, t in D2)
print("delta_2^2 =", d2sq, "  delta_2.h^5 =", sum(s for _, s in D2))
print("delta_2.T5 =", sum(s*inter(PI0, x, PI0, y) for x, s in D2 for y in T5), " (expected delta_2.(3h^5+delta_2) = -48)")

t0 = time.time()
E0 = [list(x) for x in T5] + [list(x) for x, _ in D2]
I = inter_with_all(PI0, E0, P)          # (10395, 729, 13)
print("enumeration time %.1fs" % (time.time() - t0), I.shape)
T5P = I[:, :, :9].astype(np.int64).sum(axis=2)
sg = np.array([s for _, s in D2])
D2P = (I[:, :, 9:].astype(np.int64) * sg).sum(axis=2)
print("([T5]-3h^5).P == delta_2.P for all planes:", bool(np.all(T5P - 3 == D2P)), " #planes", D2P.size)
vals, counts = np.unique(D2P, return_counts=True)
hist = dict(zip(vals.tolist(), counts.tolist()))
print("C3 histogram of delta_2.P:", hist)
claimed = {12:72, 8:540, 6:4176, 4:32400, 3:59904, 2:511920, 1:898560, 0:4562811}
full_claim = {}
for v, c in claimed.items():
    full_claim[v] = c
    if v: full_claim[-v] = c
print("matches claimed table:", hist == full_claim, " total", sum(hist.values()))
print("-24 present:", -24 in hist, " 24 present:", 24 in hist)
# divisibility / primitivity
g = 0
for v in vals.tolist(): g = gcd(g, abs(v))
print("gcd of values (primitivity in H if 1):", g, "; values 0 and 1 both occur ->", (0 in hist and 1 in hist))
# explicit witnesses
idx1 = np.argwhere(D2P == 1)[0]; idx0 = np.argwhere(D2P == 0)[0]
print("witness P  (delta.P=1):", P[idx1[0]], EXPS[idx1[1]].tolist())
print("witness P' (delta.P=0):", P[idx0[0]], EXPS[idx0[1]].tolist())
np.save("D2P.npy", D2P.astype(np.int16))

# 3. C5: P1 - P2 for Fermat planes meeting in a P^2
print("\nC5: differences of two Fermat planes meeting in a P^2")
def analyse(pi1, e1, pi2, e2, label):
    m = dim_by_cycles(pi1, e1, pi2, e2)
    A = inter_with_all(pi1, [e1], P)[:, :, 0].astype(np.int64)
    B = inter_with_all(pi2, [e2], P)[:, :, 0].astype(np.int64)
    V = A - B
    vals, counts = np.unique(V, return_counts=True)
    h = dict(zip(vals.tolist(), counts.tolist()))
    g = 0
    for v in vals.tolist(): g = gcd(g, abs(v))
    gd = 0
    for v in vals.tolist(): gd = gcd(gd, abs(v - vals[0]))
    norm = F_TAB[5]*2 - 2*F_TAB[m]
    print(label, "m =", m, " norm =", norm, " gcd(values) =", g, " gcd(differences) =", gd)
    print("   histogram:", h)
    return h
h_same = analyse(PI0, [0]*6, PI0, [1,1,1,0,0,0], "same pairing, 3 exponents differ:")
# other combinatorial types with m = 2
found = {}
tries = 0
while len(found) < 4 and tries < 200000:
    tries += 1
    pi2 = random.choice(P); e2 = [random.randrange(3) for _ in range(6)]
    if dim_by_cycles(PI0, [0]*6, pi2, e2) == 2:
        typ = tuple(sorted(sum(abs(x) for x in s) for s, t in cycles(PI0, pi2)))
        if typ not in found: found[typ] = (pi2, e2)
for typ, (pi2, e2) in found.items():
    h = analyse(PI0, [0]*6, pi2, e2, "cycle type %s:" % (typ,))
print("delta_2 histogram == histogram of same-pairing P1-P2 ?", hist == h_same)
