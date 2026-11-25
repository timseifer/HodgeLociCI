# W2: Fermat cubic fourfold planes (405), intersection numbers; search for triples of pairwise disjoint planes
# Pa+Pb+Pc = h^2 + P1 - P2 (then R_abc = 3h^2 - Pa - Pb - Pc = kappa_- = 2h^2 - P1 + P2) or = h^2 - P1 + P2 (kappa_+).
import itertools, numpy as np
z = np.exp(1j * np.pi / 3)
eps = [z, -1 + 0j, z**5]          # cube roots of -1
def pairings(s):
    if not s: yield []; return
    a = s[0]
    for b in s[1:]:
        rest = [x for x in s if x not in (a, b)]
        for p in pairings(rest): yield [(a, b)] + p
planes = []
for pr in pairings(list(range(6))):
    for e in itertools.product(range(3), repeat=3):
        M = np.zeros((3, 6), complex)
        for k, ((a, b), ei) in enumerate(zip(pr, e)):
            M[k, a] = 1; M[k, b] = -eps[ei]
        planes.append((tuple(pr), e, M))
n = len(planes); print('planes', n)
G = np.zeros((n, n), int)
for i in range(n):
    for j in range(i, n):
        r = np.linalg.matrix_rank(np.vstack([planes[i][2], planes[j][2]]), tol=1e-9)
        v = {3: 3, 4: -1, 5: 1, 6: 0}[r]; G[i, j] = G[j, i] = v
idx = {(p[0], p[1]): k for k, p in enumerate(planes)}
std = ((0, 1), (2, 3), (4, 5))
P1 = idx[(std, (0, 0, 0))]; P2 = idx[(std, (1, 1, 1))]
h2 = G[idx[(std, (0, 0, 0))]] * 0
for e3 in range(3): h2 = h2 + G[idx[(std, (0, 0, e3))]]           # h^2 . Pi_k  (h^2 = sum of 3 planes in a P^3)
print('check h2.plane all 1:', set(h2.tolist()), ' rank of plane lattice:', np.linalg.matrix_rank(G.astype(float)))
targets = {'kappa_- (Pa+Pb+Pc = h2+P1-P2)': h2 + G[P1] - G[P2], 'kappa_+ (Pa+Pb+Pc = h2-P1+P2)': h2 - G[P1] + G[P2]}
for name, t in targets.items():
    found = []
    # candidates: planes with target-compatible intersections; brute force over disjoint triples
    for a in range(n):
        for b in range(a + 1, n):
            if G[a, b] != 0: continue
            rem = t - G[a] - G[b]
            # need c with G[c] == rem
            for c in range(b + 1, n):
                if G[a, c] == 0 and G[b, c] == 0 and np.array_equal(G[c], rem): found.append((a, b, c))
    print(name, ': disjoint triples found =', len(found), [ (planes[a][:2], planes[b][:2], planes[c][:2]) for a, b, c in found[:3]])
# also: any 3 planes (not nec. disjoint) summing to the targets, and pairs
for name, t in targets.items():
    cnt = 0
    for a in range(n):
        for b in range(a, n):
            rem = t - G[a] - G[b]
            m = np.where((G == rem).all(axis=1))[0]
            cnt += len(m[m >= b])
    print(name, ': any multiset {a<=b<=c} with sum =', cnt)
# sanity: R (standard) class = 3h2 - P1 - P2 - P3 is an elliptic scroll class: norm 18, .h2 = 6
P3 = idx[(std, (2, 2, 2))]
Rv = 3 * h2 - G[P1] - G[P2] - G[P3]
print('R.P1, R.P2, R.P3 =', Rv[P1], Rv[P2], Rv[P3], '; kappa_-.P1, .P2 =', (2 * h2 - G[P1] + G[P2])[P1], (2 * h2 - G[P1] + G[P2])[P2])
print('--- multisets for kappa_- with pairwise intersection numbers:')
t = h2 + G[P1] - G[P2]
for a in range(n):
    for b in range(a, n):
        rem = t - G[a] - G[b]
        for c in np.where((G == rem).all(axis=1))[0]:
            if c >= b:
                print([planes[k][:2] for k in (a, b, c)], ' G_ab, G_ac, G_bc =', G[a, b], G[a, c], G[b, c], ' P1 among:', P1 in (a, b, c), ' .P2:', G[a, P2], G[b, P2], G[c, P2])
