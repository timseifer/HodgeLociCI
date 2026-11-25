# DA-T6 A2: which Fermat linear-cycle classes (64-dim pattern space Lambda) stay Hodge along directions / arcs (MOD p)
import sys, itertools, numpy as np
sys.path.insert(0, '/home/claude/hodge/discovery/checks/da_t6')
sys.path.insert(0, '/home/claude/hodge/discovery/t6_unsolved/e')
from ana import setup, directions
from fe import PAIRS
p = int(sys.argv[1]); lam = int(sys.argv[2])
E, X = setup(p, lam); z = E.z % p
CH = list(itertools.product([0, 1], repeat=6))
def r_of(ch):
    r = [0] * 12
    for k, (a, b) in enumerate(PAIRS):
        if ch[k] == 0: r[a] = 0; r[b] = 1
        else: r[a] = 1; r[b] = 0
    return tuple(r)
def set_onehot(k):
    E.patterns = [(r_of(ch), 1 if i == k else 0) for i, ch in enumerate(CH)]
def cvec_all(Epoly):
    cols = []
    for k in range(64):
        set_onehot(k); cols.append(E.cvec(Epoly))
    return np.stack(cols, 1) % p   # 221 x 64
def cls(exps):
    # pattern vector of the 5-plane x_a = z^e x_b (e per pair)
    w = np.zeros(64, dtype=np.int64)
    for i, ch in enumerate(CH):
        v = 1
        for k in range(6):
            c = pow(z, exps[k], p)
            v = v * (3 * c if ch[k] == 0 else 3 * c * c) % p
        w[i] = v
    return w
P1 = cls((1,) * 6); P2 = cls((1, 1, 1, 3, 3, 3))
target = (P1 + lam * P2) % p
def lin_E(T):  # E_1 = T_1 as poly
    return E.vec_to_poly(T)
def Es_of(Ts, N):
    Tp = [E.vec_to_poly(T) for T in Ts]
    Es = [E.poly_one()]
    for n in range(1, N + 1):
        inv = pow(n, p - 2, p)
        terms = [(j * inv, E.mul(Tp[j - 1], Es[n - j])) for j in range(1, n + 1) if j - 1 < len(Tp)]
        Es.append(E.add(*terms))
    return Es
def classes_along(Ts, N):
    Es = Es_of(Ts, N)
    rows = []
    out = []
    for n in range(1, N + 1):
        rows.append(cvec_all(Es[n]))
        K = E.kernel(np.concatenate(rows, 0))
        inT = E.in_span(K, target) if K.shape[1] else False
        out.append((n, K.shape[1], inT))
    return out, K
def describe(K):
    # test some named classes
    names = {}
    for e3 in itertools.product([1, 3, 5], repeat=3):
        names['P(z,z,z|%d%d%d)' % e3] = cls((1, 1, 1) + e3)
    hits = [nm for nm, w in names.items() if K.shape[1] and E.in_span(K, w)]
    # differences P1 - P(e) etc
    diffs = []
    for nm, w in names.items():
        for nm2, w2 in names.items():
            if nm < nm2 and K.shape[1] and E.in_span(K, (w - w2) % p): diffs.append(nm + '-' + nm2)
    return hits, diffs
mode = sys.argv[3]
if mode == 'dirs':
    for kind, seed in [('al', 1), ('la', 2), ('both', 1), ('mono', 1), ('cone', 3), ('tv', 3), ('r2', 2)]:
        rng = np.random.default_rng(seed)
        v, info = directions(E, X, rng, kind)
        res, K = classes_along([v], 1)
        hits, diffs = describe(K)
        print(kind, seed, "first-order Hodge classes in Lambda along v: dim", res[-1][1], "target in:", res[-1][2],
              "| planes:", hits[:6], len(hits), "| plane differences:", len(diffs), diffs[:8], flush=True)
else:
    fn = mode
    Ts = list(np.load(fn))
    N = len(Ts)
    res, K = classes_along(Ts, N)
    print(fn, "orders 1..%d:" % N, res, flush=True)
    hits, diffs = describe(K)
    print("   planes:", hits, "| plane differences:", len(diffs), diffs[:12], flush=True)
