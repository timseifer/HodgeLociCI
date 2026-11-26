"""
Second, independent-of-numpy implementation of the period functional, EXACT over QQ (python-flint + Fractions).
Polynomials: flint fmpq_mpoly whose first 12 generators are x0..x11; further generators are parameters.
"""
from fractions import Fraction
import itertools
import flint

NV = 12
R = lambda k: 2 * (k % 3)
Y = lambda k: 2 * (k % 3) + 1
Pv = lambda i: 6 + 2 * (i % 3)
Qv = lambda i: 7 + 2 * (i % 3)


def kappa_poly():
    """prod_k (r_k - y_k) * (P - Q)  (the period polynomial of kappa up to the nonzero constant 2187)"""
    out = {}
    for choice in itertools.product([0, 1], repeat=3):
        sgn = 1
        e = [0] * NV
        for k in range(3):
            if choice[k]:
                e[Y(k)] = 1; sgn = -sgn
            else:
                e[R(k)] = 1
        for which, c in ((0, 1), (1, -1)):
            ee = list(e)
            for i in range(3):
                ee[Pv(i) if which == 0 else Qv(i)] = 1
            out[tuple(ee)] = sgn * c
    return out


def standard_forms():
    Ql = [tuple([0] * NV)]
    for c in itertools.combinations(range(NV), 3):
        e = [0] * NV
        for i in c:
            e[i] = 1
        Ql.append(tuple(e))
    return Ql


_poch = {}


def poch(r, m):
    key = (r, m)
    if key not in _poch:
        v = Fraction(1)
        a = Fraction(1 + r, 3)
        for t in range(m):
            v *= (a + t)
        _poch[key] = v
    return _poch[key]


def make_table(Pd, Ql):
    tab = {}
    for qi, q in enumerate(Ql):
        for mu, cmu in Pd.items():
            res = tuple((1 - mu[i] - q[i]) % 3 for i in range(NV))
            tab.setdefault(res, []).append((qi, q, cmu))
    return tab


STATS = {"hits": 0, "abs": 0}


def evaluate(poly, tab, nQ):
    """returns list over Q of dict (parameter exponents) -> Fraction : Psi_P(Q * poly).
    STATS counts the individual contributions (to show that a zero result is a cancellation, not an empty sum)."""
    out = [dict() for _ in range(nQ)]
    STATS["hits"] = 0
    STATS["abs"] = 0
    for exps, c in poly.to_dict().items():
        g = exps[:NV]
        hit = tab.get(tuple(int(e) % 3 for e in g))
        if not hit:
            continue
        par = tuple(int(e) for e in exps[NV:])
        cf = Fraction(int(c.p), int(c.q))
        for qi, q, cmu in hit:
            w = cf * cmu
            for i in range(NV):
                t = int(g[i]) + q[i]
                w *= poch(t % 3, t // 3)
            d = out[qi]
            d[par] = d.get(par, 0) + w
            STATS["hits"] += 1
            STATS["abs"] += abs(w)
    return [{k: v for k, v in d.items() if v != 0} for d in out]


def expansion(Gj, N, ctx, Pd, Ql=None, verbose=True, stop_at_first=False):
    """Gj: dict j -> fmpq_mpoly (coefficient of tau^j of F_tau - F_0).  E_0=1, n E_n = -sum j G_j E_(n-j).
    returns dict n -> number of forms Q with a nonzero tau^n coefficient, and the values."""
    import time
    if Ql is None:
        Ql = standard_forms()
    tab = make_table(Pd, Ql)
    E = {0: ctx.from_dict({tuple([0] * ctx.nvars()): 1})}
    res = {}
    for n in range(1, N + 1):
        t0 = time.time()
        acc = ctx.from_dict({})
        for j in range(1, n + 1):
            if j in Gj:
                acc = acc + (-j) * Gj[j] * E[n - j]
        E[n] = acc / n
        vals = evaluate(E[n], tab, len(Ql))
        res[n] = vals
        nz = sum(1 for v in vals if v)
        if verbose:
            print(f"  order {n}: terms(E_n) = {len(E[n])}, forms with nonzero equation: {nz}; "
                  f"individual nonzero contributions summed: {STATS['hits']} (sum of |contributions| ~ {float(STATS['abs']):.3g})  [{time.time()-t0:.1f}s]", flush=True)
        if stop_at_first and nz:
            break
    return res
