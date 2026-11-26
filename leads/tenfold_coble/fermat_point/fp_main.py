# Steps A, C, D and controls K1-K4 of PREREG_fermat.md (AI-written, unreviewed).
# usage: python3 fp_main.py exact N1        -> step C, EXACT over QQ, identically in x, orders 0..N1
#        python3 fp_main.py classes N p     -> steps A, D, K1, K2: all 924 eigenclasses, MOD p, identically in x
#        python3 fp_main.py perturb N p     -> control K3 (numeric x, one coefficient of M changed), MOD p
#        python3 fp_main.py classes55 N p   -> as "classes", with the forms Q of degree 9 and 12 added: the classes
#                                              that stay of type (5,5) (not only in F^5) to order N
import sys, os, time, itertools, numpy as np
from collections import defaultdict
from fp_lib import *

FORMS = forms()
FQ = np.array(FORMS)                       # (221, 12)

def exact_kappa(N1):
    """S(Q, n) for the three-plane class as a polynomial in x_0, x_1, x_2, exact integers (common factor dropped).
    Prints, per order: number of individual nonzero terms, number of (Q, x-monomial) cells with terms,
    number of cells whose sum is nonzero."""
    allzero = True
    for n in range(0, N1 + 1):
        t0 = time.time()
        comps = compositions(n).astype(np.int64)
        base = comps @ INC                              # (ncomp, 12)
        D = comps @ INC_D                               # (ncomp, 3)
        cells = defaultdict(int); nterms = 0; qs_with_terms = set()
        for qi, Q in enumerate(FORMS):
            g = base + Q[None, :]
            rho = g % 3
            if not np.all(rho.max(axis=1) <= 2): raise RuntimeError
            # cheap pre-filters
            ok = np.all(rho <= 1, axis=1)
            if not ok.any(): continue
            sg = kappa_sign(rho) * ok
            rows = np.nonzero(sg)[0]
            if len(rows) == 0: continue
            qs_with_terms.add(qi)
            for rix in rows:
                gg = g[rix]; rr = rho[rix]
                w = multinomial_int(comps[rix])
                for j in range(NV): w *= poch_int(int(rr[j]), int((gg[j] - rr[j]) // 3))
                cells[(qi, int(D[rix, 0]), int(D[rix, 1]))] += int(sg[rix]) * w
                nterms += 1
        bad = {k: v for k, v in cells.items() if v != 0}
        if bad: allzero = False
        print("EXACT n = %2d: compositions %8d, individual terms %7d, forms Q with terms %3d, cells with terms %6d, "
              "cells with nonzero sum %d   [%.1fs]" % (n, len(comps), nterms, len(qs_with_terms), len(cells), len(bad),
                                                      time.time() - t0), flush=True)
        if bad:
            for k in list(bad)[:5]: print("   nonzero: Q =", np.nonzero(FORMS[k[0]])[0].tolist(), "x-exps", k[1:], "value", bad[k])
    print("RESULT exact_kappa orders 0..%d: %s" % (N1, "ALL ZERO (identically in x)" if allzero else "NONZERO FOUND"))

def rows_for_order(n, p, T, fact, facti, pidx, npat, coefs=None):
    """yields (qi, array rows x npat) : for each form Q the matrix [x-monomial cell, pattern] of
    sum multinomial * prod poch (mod p).  If coefs (9 numbers mod p) is given, the x-monomials are replaced by
    the numeric value prod c_ij^n_ij (a single cell)."""
    comps = compositions(n).astype(np.int64)
    base = comps @ INC
    mult = fact[n] * np.ones(len(comps), dtype=np.int64)
    for t in range(9): mult = mult * facti[comps[:, t]] % p
    if coefs is None:
        D = comps @ INC_D
        cell = D[:, 0] * (n + 1) + D[:, 1]; ncell = (n + 1) ** 2
    else:
        for t in range(9):
            pw = np.array([pow(int(coefs[t]), e, p) for e in range(n + 1)], dtype=np.int64)
            mult = mult * pw[comps[:, t]] % p
        cell = np.zeros(len(comps), dtype=np.int64); ncell = 1
    pw2 = 1 << np.arange(NV)
    for qi, Q in enumerate(FORMS):
        g = base + Q[None, :]
        rho = g % 3
        ok = np.all(rho <= 1, axis=1) & (rho.sum(axis=1) == 6)
        if not ok.any(): continue
        g = g[ok]; rho = rho[ok]; m = g // 3
        w = mult[ok].copy()
        for j in range(NV): w = w * T[rho[:, j], m[:, j]] % p
        pc = pidx[rho @ pw2]
        M = np.zeros((ncell, npat), dtype=np.int64)
        # accumulate without overflow: chunks of < 2^31 terms each < 2^31 fit in int64
        np.add.at(M, (cell[ok], pc), w)
        M %= p
        nz = np.nonzero(M.any(axis=1))[0]
        if len(nz): yield qi, M[nz]

def rref_add(basis, piv, rows, p):
    """add rows to a row-reduced basis (list of arrays with leading 1 at piv); returns number of new pivots"""
    new = 0
    for r in rows:
        r = r.copy() % p
        for b, c in zip(basis, piv):
            if r[c]: r = (r - r[c] * b) % p
        nz = np.nonzero(r)[0]
        if len(nz) == 0: continue
        c = int(nz[0]); r = r * pow(int(r[c]), p - 2, p) % p
        for t in range(len(basis)):
            if basis[t][c]: basis[t] = (basis[t] - basis[t][c] * r) % p
        basis.append(r); piv.append(c); new += 1
    return new

def classes(N, p, tag=""):
    z = root6(p)
    pats, idx = patterns55(); npat = len(pats)
    pidx = -np.ones(1 << NV, dtype=np.int64)
    for code, t in idx.items(): pidx[code] = t
    T = poch_table(p); fact, facti = fact_tables(p)
    P1 = (1, (1, 1, 1, 1, 1, 1)); P2 = (1, (1, 1, 1, 3, 3, 3)); P3 = (1, (1, 1, 1, 5, 5, 5))
    neg = lambda P: (p - 1, P[1])
    named = {
        "kappa = P1+P2+P3 (mod h^5)": plane_class_vector(p, z, [P1, P2, P3], pats),
        "P1 - P2 (Movasati)": plane_class_vector(p, z, [P1, neg(P2)], pats),
        "P1 - P3": plane_class_vector(p, z, [P1, neg(P3)], pats),
        "P2 - P3": plane_class_vector(p, z, [P2, neg(P3)], pats),
        "P1 alone": plane_class_vector(p, z, [P1], pats),
        "P1 + P2": plane_class_vector(p, z, [P1, P2], pats),
    }
    # K2: kappa with the sign of one of its two (p,q)-patterns flipped
    vk = named["kappa = P1+P2+P3 (mod h^5)"].copy()
    flip = vk.copy()
    for t, c in enumerate(pats):
        if all(a in c for a in P_IDX): flip[t] = (-flip[t]) % p
    named["K2: kappa, one eigen-sign flipped"] = flip
    print("supports (number of eigenclasses with nonzero coefficient):")
    for nm, v in named.items(): print("   %-36s %d" % (nm, int(np.count_nonzero(v))))
    # all 27 kappa_theta: roots z^(1,3,5) independently on the first three pairs
    kth = []
    for e in itertools.product((1, 3, 5), repeat=3):
        kth.append(plane_class_vector(p, z, [(1, e + (1, 1, 1)), (1, e + (3, 3, 3)), (1, e + (5, 5, 5))], pats))
    kth = np.array(kth)
    bk = []; pk = []; rref_add(bk, pk, kth, p)
    print("span of the 27 classes kappa_theta: dimension", len(bk))
    first_fail = {nm: None for nm in named}
    basis = []; piv = []                         # row space of all conditions
    for n in range(0, N + 1):
        t0 = time.time(); nrows = 0
        for qi, M in rows_for_order(n, p, T, fact, facti, pidx, npat):
            nrows += len(M)
            for nm, v in named.items():
                if first_fail[nm] is None and np.any(M @ v % p): first_fail[nm] = n
            rref_add(basis, piv, M, p)
        # is every kappa_theta still in the solution space?
        B = np.array(basis) if basis else np.zeros((0, npat), dtype=np.int64)
        kin = bool(len(B) == 0 or not np.any((B @ kth.T) % p))
        print("MOD %d n = %2d: condition rows %6d, rank so far %3d, solution space dim %3d, all 27 kappa_theta inside: %s  [%.1fs]"
              % (p, n, nrows, len(basis), npat - len(basis), kin, time.time() - t0), flush=True)
    print("first order at which each named class violates a condition (None = none up to %d):" % N)
    for nm in named: print("   %-36s %s" % (nm, first_fail[nm]))
    # description of the solution space by the r-part s of the pattern
    B = np.array(basis); pivset = set(piv)
    by_s = defaultdict(lambda: [0, 0])
    for t, c in enumerate(pats):
        s = tuple(1 if a in c else 0 for a in R_IDX)
        by_s[s][0] += 1
        if t not in pivset: by_s[s][1] += 1
    print("solution space by r-part s of the pattern (patterns, free columns):")
    for s in sorted(by_s): print("   s =", s, by_s[s])
    if os.environ.get("FP_SAVE"): np.save("logs/solution_rowspace%s_N%d_p%d.npy" % (tag, N, p), B)   # 5 MB
    print("RESULT classes%s N=%d p=%d: solution space dim %d; kappa first failure %s; Movasati class first failure %s"
          % (tag, N, p, npat - len(basis), first_fail["kappa = P1+P2+P3 (mod h^5)"], first_fail["P1 - P2 (Movasati)"]))

def perturb(N, p):
    z = root6(p)
    pats, idx = patterns55(); npat = len(pats)
    pidx = -np.ones(1 << NV, dtype=np.int64)
    for code, t in idx.items(): pidx[code] = t
    T = poch_table(p); fact, facti = fact_tables(p)
    vk = plane_class_vector(p, z, [(1, (1, 1, 1, 1, 1, 1)), (1, (1, 1, 1, 3, 3, 3)), (1, (1, 1, 1, 5, 5, 5))], pats)
    rng = np.random.default_rng(20261125)
    x = [int(a) for a in rng.integers(2, p - 1, size=3)]
    for label, mod in (("unperturbed (must pass)", None), ("c_01 changed", (0, 1)), ("c_00 changed", (0, 0)),
                       ("c_12 changed", (1, 2))):
        coefs = [x[(i - j) % 3] for (i, j) in IJ]
        if mod is not None: coefs[IJ.index(mod)] = (coefs[IJ.index(mod)] + 12345) % p
        ff = None; nt = 0
        for n in range(0, N + 1):
            for qi, M in rows_for_order(n, p, T, fact, facti, pidx, npat, coefs=coefs):
                val = M @ vk % p; nt += 1
                if np.any(val) and ff is None: ff = n
            if ff is not None: break
        print("K3 MOD %d, numeric x: %-26s first failing order: %s" % (p, label, ff), flush=True)

if __name__ == "__main__":
    mode = sys.argv[1]
    if mode == "exact": exact_kappa(int(sys.argv[2]))
    elif mode == "classes": classes(int(sys.argv[2]), int(sys.argv[3]))
    elif mode == "perturb": perturb(int(sys.argv[2]), int(sys.argv[3]))
    elif mode == "classes55":
        extra = []
        for c in itertools.combinations(range(NV), 9):
            e = np.zeros(NV, dtype=np.int64); e[list(c)] = 1; extra.append(e)
        extra.append(np.ones(NV, dtype=np.int64))
        FORMS.extend(extra)
        classes(int(sys.argv[2]), int(sys.argv[3]), tag="55")
