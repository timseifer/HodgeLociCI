"""
Blind checker's own period code (mod p, numpy).  Written from the closed formula only:

  Fermat cubic tenfold F0 = x_0^3+...+x_11^3, n = 10, pole order of the middle piece n/2+1 = 6.
  Psi_P(x^g), g_j = 3 m_j + r_j:  prod_j ((1+r_j)/3)_(m_j) * [coeff of x^((1,..,1)-r) in P]  if all r_j<=1, else 0.
  Period of Q Omega/(F0+G)^k on the class with period polynomial P is a nonzero constant times Psi_P(Q exp(-G)).
  P_L for the linear space {x_a = c x_b} (c^3=-1) on a perfect matching: prod_j 3 c_j (x_a + c_j x_b).

Variables: x_(2k)=r_k, x_(2k+1)=y_k (k=0,1,2), x_(6+2i)=p_i, x_(7+2i)=q_i.
Sparse polynomials mod p: (keys int64 sorted unique, vals int64 in [0,p)); key = sum e_i << (5 i).
"""
import numpy as np
import itertools

NV = 12
SH = 5
MASK = 31


def R(k): return 2 * (k % 3)
def Y(k): return 2 * (k % 3) + 1
def Pv(i): return 6 + 2 * (i % 3)
def Qv(i): return 7 + 2 * (i % 3)


def key_of(exps):
    k = 0
    for i, e in enumerate(exps):
        k |= int(e) << (SH * i)
    return k


def exps_of(key):
    return tuple((int(key) >> (SH * i)) & MASK for i in range(NV))


def mono(*vars_):
    e = [0] * NV
    for v in vars_:
        e[v] += 1
    return key_of(e)


class Poly:
    """sparse polynomial mod p"""
    __slots__ = ("k", "v")

    def __init__(self, k, v):
        self.k = k
        self.v = v

    def __len__(self):
        return len(self.k)


def from_dict(d, p):
    items = sorted((int(k), int(v) % p) for k, v in d.items() if int(v) % p)
    if not items:
        return Poly(np.zeros(0, np.int64), np.zeros(0, np.int64))
    k = np.array([a for a, _ in items], dtype=np.int64)
    v = np.array([b for _, b in items], dtype=np.int64)
    return Poly(k, v)


def to_dict(P):
    return {int(a): int(b) for a, b in zip(P.k, P.v)}


def combine(keys, vals, p):
    """sort, merge equal keys, drop zeros"""
    if len(keys) == 0:
        return Poly(np.zeros(0, np.int64), np.zeros(0, np.int64))
    order = np.argsort(keys, kind="stable")
    ks = keys[order]
    vs = vals[order]
    del order
    start = np.empty(len(ks), dtype=bool)
    start[0] = True
    np.not_equal(ks[1:], ks[:-1], out=start[1:])
    idx = np.flatnonzero(start)
    sums = np.add.reduceat(vs, idx) % p
    ku = ks[idx]
    nz = sums != 0
    return Poly(ku[nz], sums[nz])


def add_list(polys, p):
    polys = [q for q in polys if len(q)]
    if not polys:
        return Poly(np.zeros(0, np.int64), np.zeros(0, np.int64))
    return combine(np.concatenate([q.k for q in polys]), np.concatenate([q.v for q in polys]), p)


def scale(P, c, p):
    c %= p
    return Poly(P.k, (P.v * c) % p)


def mul_small(A, B, p, c=1, group=6):
    """A (big) times B (small) times scalar c, merged"""
    if len(A) == 0 or len(B) == 0:
        return Poly(np.zeros(0, np.int64), np.zeros(0, np.int64))
    parts = []
    bk = [int(t) for t in B.k]
    bv = [(int(t) * c) % p for t in B.v]
    for s in range(0, len(bk), group):
        ks = np.concatenate([A.k + bk[j] for j in range(s, min(s + group, len(bk)))])
        vs = np.concatenate([(A.v * bv[j]) % p for j in range(s, min(s + group, len(bk)))])
        parts.append(combine(ks, vs, p))
        del ks, vs
    if len(parts) == 1:
        return parts[0]
    return add_list(parts, p)


def mul_general(A, B, p):
    if len(A) < len(B):
        A, B = B, A
    return mul_small(A, B, p)


def digits(keys):
    """residues mod 3 of the 12 exponents, as a base-3 code"""
    code = np.zeros(len(keys), dtype=np.int32)
    w = 1
    for i in range(NV):
        e = (keys >> (SH * i)) & MASK
        code += (e % 3).astype(np.int32) * w
        w *= 3
    return code


def code_of_res(res):
    c = 0
    w = 1
    for i in range(NV):
        c += (res[i] % 3) * w
        w *= 3
    return c


# ---------------------------------------------------------------------------------------------
# period polynomials (dict: tuple of 12 exponents in {0,1} with six ones -> coefficient mod p)
# ---------------------------------------------------------------------------------------------
def linear_space_polynomial(pairs, p):
    """pairs: list of (a, b, c) meaning x_a = c x_b, c^3 = -1 mod p. returns prod 3c (x_a + c x_b) as dict"""
    out = {tuple([0] * NV): 1}
    for (a, b, c) in pairs:
        new = {}
        for e, v in out.items():
            e1 = list(e); e1[a] += 1
            e2 = list(e); e2[b] += 1
            new[tuple(e1)] = (new.get(tuple(e1), 0) + v * 3 * c) % p
            new[tuple(e2)] = (new.get(tuple(e2), 0) + v * 3 * c * c) % p
        out = new
    return {e: v % p for e, v in out.items() if v % p}


def plane(zeta, p):
    """P_zeta = { r_k = -y_k, p_i = zeta q_i }"""
    prs = [(R(k), Y(k), p - 1) for k in range(3)] + [(Pv(i), Qv(i), zeta % p) for i in range(3)]
    return linear_space_polynomial(prs, p)


def comb(polys_coeffs, p):
    out = {}
    for P, c in polys_coeffs:
        for e, v in P.items():
            out[e] = (out.get(e, 0) + c * v) % p
    return {e: v for e, v in out.items() if v}


def cube_roots_of_minus_one(p):
    """the three roots of z^3 = -1 mod p (p = 1 mod 3)"""
    assert p % 3 == 1
    roots = [z for z in range(1, 1)]
    # find a primitive 6th root of unity
    g = 2
    while True:
        z = pow(g, (p - 1) // 6, p)
        if pow(z, 3, p) == p - 1 and (z * z - z + 1) % p == 0:
            break
        g += 1
    return [z, p - 1, pow(z, 5, p)]


def kappa_poly(p):
    """period polynomial of kappa = h^5 - sum of the three planes: minus the sum (h^5 has no primitive periods).
    Rational: computed here without roots of unity, as -(sum over the roots) = 3^6 * (-1)^3*... evaluated exactly
    below via the symmetric functions sum z = 0, sum z^2 = 0, sum z^3 = -3."""
    # prod_k 3(-1)(r_k - y_k) * sum_z prod_i 3 z (p_i + z q_i); sum_z z^3 prod_i(p_i+z q_i) = -(3 P - 3 Q)
    out = {}
    for choice in itertools.product([0, 1], repeat=3):
        e = [0] * NV
        sgn = 1
        for k in range(3):
            if choice[k] == 0:
                e[R(k)] = 1
            else:
                e[Y(k)] = 1
                sgn = -sgn
        c0 = (-27) * sgn            # prod_k (-3)(r_k - y_k)
        for which, coef in ((0, -3 * 27), (1, 3 * 27)):   # 27 * sum_z z^3 prod(p+zq) = 27*(-3P + 3Q)
            ee = list(e)
            for i in range(3):
                ee[Pv(i) if which == 0 else Qv(i)] = 1
            out[tuple(ee)] = (-(c0 * coef)) % p   # minus: kappa = h^5 - sum
    return out


# ---------------------------------------------------------------------------------------------
# the functional
# ---------------------------------------------------------------------------------------------
class Functional:
    def __init__(self, p, maxm=40):
        self.p = p
        inv3 = pow(3, p - 2, p)
        # T[r][m] = ((1+r)/3)_m mod p
        self.T = np.zeros((2, maxm + 1), dtype=np.int64)
        for r in (0, 1):
            a = ((1 + r) * inv3) % p
            val = 1
            self.T[r, 0] = 1
            for m in range(1, maxm + 1):
                val = (val * ((a + m - 1) % p)) % p
                self.T[r, m] = val

    def useful_table(self, Pdicts, Qlist):
        """boolean table over residue codes of monomials x^g such that Q x^g can have a nonzero value"""
        tab = np.zeros(3 ** NV, dtype=bool)
        supp = set()
        for Pd in Pdicts:
            supp.update(Pd.keys())
        for q in Qlist:
            for mu in supp:
                res = [(1 - mu[i] - q[i]) % 3 for i in range(NV)]
                tab[code_of_res(res)] = True
        return tab

    def evaluate(self, keys, vals, Pd, Qlist, codes=None):
        """vector over Qlist of Psi_P(Q * poly) mod p; poly need not be merged"""
        p = self.p
        out = [0] * len(Qlist)
        if len(keys) == 0:
            return out
        if codes is None:
            codes = digits(keys)
        order = np.argsort(codes, kind="stable")
        cs = codes[order]
        ks = keys[order]
        vs = vals[order]
        # exponent columns
        cols = [((ks >> (SH * i)) & MASK).astype(np.int64) for i in range(NV)]
        T = self.T
        Pitems = list(Pd.items())
        for qi, q in enumerate(Qlist):
            tot = 0
            for mu, cmu in Pitems:
                res = [(1 - mu[i] - q[i]) % 3 for i in range(NV)]
                code = code_of_res(res)
                lo = np.searchsorted(cs, code, side="left")
                hi = np.searchsorted(cs, code, side="right")
                if hi <= lo:
                    continue
                w = vs[lo:hi].copy()
                for i in range(NV):
                    r = 1 - mu[i]                     # residue of g+q
                    m = (cols[i][lo:hi] + q[i]) // 3
                    w = (w * T[r][m]) % p
                tot = (tot + cmu * int(w.sum() % p)) % p
            out[qi] = tot
        return out


def standard_forms():
    """Q = 1 and the 220 squarefree cubic monomials, as exponent tuples"""
    Ql = [tuple([0] * NV)]
    for c in itertools.combinations(range(NV), 3):
        e = [0] * NV
        for i in c:
            e[i] = 1
        Ql.append(tuple(e))
    return Ql


# ---------------------------------------------------------------------------------------------
# expansion along an arc
# ---------------------------------------------------------------------------------------------
def expansion(G, N, p, Pdicts, Qlist=None, verbose=False, stop_at_first=False, last_filtered=True):
    """G: dict j -> Poly (coefficient of tau^j in F_tau - F_0), j>=1.
    Returns list over classes of dict n -> vector over Qlist of the tau^n coefficient of Psi_P(Q exp(-G)).
    E_0 = 1, n E_n = - sum_j j G_j E_(n-j).  The last order is computed only on the residue classes that can
    contribute (the full E_N is never formed)."""
    import time
    if Qlist is None:
        Qlist = standard_forms()
    fun = Functional(p)
    useful = fun.useful_table(Pdicts, Qlist)
    E = {0: Poly(np.array([0], dtype=np.int64), np.array([1], dtype=np.int64))}
    res = [dict() for _ in Pdicts]
    first = [None] * len(Pdicts)
    for n in range(1, N + 1):
        t0 = time.time()
        invn = pow(n, p - 2, p)
        if n < N or not last_filtered:
            parts = []
            for j in range(1, n + 1):
                if j in G and len(G[j]):
                    parts.append(mul_small(E[n - j], G[j], p, c=(-(j * invn)) % p))
            En = add_list(parts, p)
            del parts
            E[n] = En
            codes = digits(En.k)
            sel = useful[codes]
            kk, vv, cc = En.k[sel], En.v[sel], codes[sel]
            nterms = len(En)
        else:
            kl, vl, cl = [], [], []
            for j in range(1, n + 1):
                if j in G and len(G[j]):
                    A = E[n - j]
                    cA = digits(A.k)
                    dig = {}
                    for bk_, bv_ in zip(G[j].k, G[j].v):
                        be = exps_of(bk_)
                        cn = cA.copy()
                        w = 1
                        for i in range(NV):
                            if be[i] % 3:
                                if i not in dig:
                                    dig[i] = (((A.k >> (SH * i)) & MASK) % 3).astype(np.int8)
                                d = dig[i].astype(np.int32)
                                cn += (((d + be[i]) % 3) - d) * w
                            w *= 3
                        sel = useful[cn]
                        coef = (int(bv_) * (-(j * invn))) % p
                        kl.append(A.k[sel] + int(bk_))
                        vl.append((A.v[sel] * coef) % p)
                        cl.append(cn[sel])
                    del dig, cA
            kk = np.concatenate(kl); vv = np.concatenate(vl); cc = np.concatenate(cl)
            nterms = -1
        for ci, Pd in enumerate(Pdicts):
            vec = fun.evaluate(kk, vv, Pd, Qlist, codes=cc)
            res[ci][n] = vec
            if first[ci] is None and any(vec):
                first[ci] = n
        if verbose:
            print(f"  order {n}: terms(E_n)={nterms}, relevant={len(kk)}, "
                  f"nonzero counts={[sum(1 for t in res[ci][n] if t) for ci in range(len(Pdicts))]}, "
                  f"{time.time()-t0:.1f}s", flush=True)
        if stop_at_first and all(f is not None for f in first):
            break
    return res, first
