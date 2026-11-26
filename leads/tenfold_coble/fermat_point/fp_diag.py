# Control K4 of PREREG_fermat.md: are the vanishing sums of step C sums of real terms, and are they forced by the
# obvious symmetry?  iota = (index k -> -k on r, y, p, q) o (p <-> q) preserves M_x and changes the sign of the
# class functional; a cell with iota(Q) = Q vanishes for that reason alone.  (AI-written, unreviewed.)
import sys, numpy as np
from collections import defaultdict
from fp_lib import *
FORMS = forms()
perm = np.zeros(NV, dtype=np.int64)
for k in range(3):
    perm[R_IDX[k]] = R_IDX[(-k) % 3]; perm[Y_IDX[k]] = Y_IDX[(-k) % 3]
    perm[P_IDX[k]] = Q_IDX[(-k) % 3]; perm[Q_IDX[k]] = P_IDX[(-k) % 3]
def iota(Q):
    out = np.zeros(NV, dtype=np.int64); out[perm] = Q; return out
# the shift sh: (r_k, y_k) -> (r_(k+2), y_(k+2)), (p_i, q_i) -> (p_(i+1), q_(i+1)) also preserves M_x and the class;
# the three reflections are iota, sh iota sh^-1, sh^2 iota sh^-2.
shp = np.zeros(NV, dtype=np.int64)
for k in range(3):
    shp[R_IDX[k]] = R_IDX[(k + 2) % 3]; shp[Y_IDX[k]] = Y_IDX[(k + 2) % 3]
    shp[P_IDX[k]] = P_IDX[(k + 1) % 3]; shp[Q_IDX[k]] = Q_IDX[(k + 1) % 3]
def sh(Q):
    out = np.zeros(NV, dtype=np.int64); out[shp] = Q; return out
def shinv(Q): return sh(sh(Q))
def refl_fixed(Q):
    a = iota(Q); b = sh(iota(shinv(Q))); c = shinv(iota(sh(Q)))
    return np.array_equal(a, Q) or np.array_equal(b, Q) or np.array_equal(c, Q)
N = int(sys.argv[1])
for n in range(0, N + 1):
    comps = compositions(n).astype(np.int64); base = comps @ INC; D = comps @ INC_D
    pos = defaultdict(int); neg = defaultdict(int); cnt = defaultdict(int)
    for qi, Q in enumerate(FORMS):
        g = base + Q[None, :]; rho = g % 3
        sg = kappa_sign(rho) * np.all(rho <= 1, axis=1)
        for rix in np.nonzero(sg)[0]:
            w = multinomial_int(comps[rix])
            for j in range(NV): w *= poch_int(int(rho[rix, j]), int(g[rix, j] // 3))
            key = (qi, int(D[rix, 0]), int(D[rix, 1])); cnt[key] += 1
            if sg[rix] > 0: pos[key] += w
            else: neg[key] += w
    if not cnt: print("n = %2d: no terms" % n); continue
    fixed = [k for k in cnt if refl_fixed(FORMS[k[0]])]
    free = [k for k in cnt if k not in set(fixed)]
    okfree = all(pos[k] == neg[k] and pos[k] > 0 for k in free)
    ex = max(free, key=lambda k: cnt[k]) if free else None
    print("n = %2d: cells %4d; with Q fixed by a reflection: %3d; other: %4d, each with positive part = negative part > 0: %s"
          % (n, len(cnt), len(fixed), len(free), okfree))
    if ex is not None:
        print("        example cell: Q = x_%s, x-exponents (%d,%d,%d), %d terms, positive part = %d, negative part = %d"
              % (np.nonzero(FORMS[ex[0]])[0].tolist(), ex[1], ex[2], n - ex[1] - ex[2], cnt[ex], pos[ex], neg[ex]))
