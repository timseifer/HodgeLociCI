#!/usr/bin/env python3 -I
# Claim B: independent implementation (Python, exact arithmetic in Q(z), z^2 = z - 1) of the closed formula
#   Phi_Q(F0 - T) ~ Psi_P(Q exp(T)),  Psi_P(x^g) = prod_j ((1+r_j)/3)_(m_j) * [coeff of x^((1..1)-r) in P], g_j = 3 m_j + r_j,
# used by the package.  Shares only the FORMULA with the package (stated in the header of Fermat.m2), no code.
import re, sys, itertools
from fractions import Fraction as Fr

FILE = "/home/claude/hodgelocici/M2/HodgeLociCI/data/six_lam-1_arc.txt"

# ---- Q(z) arithmetic: pairs (a, b) = a + b z, z^2 = z - 1
ZERO = (Fr(0), Fr(0)); ONE = (Fr(1), Fr(0)); Z = (Fr(0), Fr(1))
def add(u, v): return (u[0]+v[0], u[1]+v[1])
def sub(u, v): return (u[0]-v[0], u[1]-v[1])
def mul(u, v):
    a, b = u; c, d = v
    return (a*c - b*d, a*d + b*c + b*d)
def smul(s, u): return (s*u[0], s*u[1])
def iszero(u): return u[0] == 0 and u[1] == 0
def inv(u):
    a, b = u   # norm of a + b z = a^2 + a b + b^2 ; conj(z) = 1 - z
    n = a*a + a*b + b*b
    return ((a + b)/n, -b/n)
def zpow(e):
    r = ONE
    for _ in range(e % 6): r = mul(r, Z)
    return r

# ---- polynomials: dict exponent-tuple -> element of Q(z)
def padd(p, q, s=ONE):
    r = dict(p)
    for k, v in q.items():
        w = add(r.get(k, ZERO), mul(s, v))
        if iszero(w): r.pop(k, None)
        else: r[k] = w
    return r
def pmul(p, q):
    r = {}
    for k1, v1 in p.items():
        for k2, v2 in q.items():
            k = tuple(x+y for x, y in zip(k1, k2))
            w = add(r.get(k, ZERO), mul(v1, v2))
            if iszero(w): r.pop(k, None)
            else: r[k] = w
    return r
def pscal(s, p): return {k: mul(s, v) for k, v in p.items()}
def mono(nv, idxs):
    e = [0]*nv
    for i in idxs: e[i] += 1
    return tuple(e)

def perm_sign(s):
    sg = 1
    for i in range(len(s)):
        for j in range(i+1, len(s)):
            if s[i] > s[j]: sg = -sg
    return sg

def period_poly(nv, L):
    # sign(a1,b1,a2,b2,...) * prod 3 c (x_a + c x_b), c = z^e
    P = {tuple([0]*nv): (Fr(perm_sign([t for ab in L for t in ab[:2]])), Fr(0))}
    for (a, b, e) in L:
        c = zpow(e)
        f = {mono(nv, [a]): smul(3, c), mono(nv, [b]): smul(3, mul(c, c))}
        P = pmul(P, f)
    return P

def poch(r, m):
    v = Fr(1)
    for i in range(m): v *= Fr(1 + r, 3) + i
    return v

def psi(P, G, shift):
    # Psi_P(x^shift * G)
    tot = ZERO
    for g, cf in G.items():
        w = Fr(1); key = []
        ok = True
        for gj, sj in zip(g, shift):
            t = gj + sj
            r = t % 3
            if r == 2: ok = False; break
            key.append(1 - r)
            if t >= 3: w *= poch(r, t // 3)
        if not ok: continue
        pc = P.get(tuple(key))
        if pc is None: continue
        tot = add(tot, smul(w, mul(cf, pc)))
    return tot

# ---- parse the arc
def parse_num(s):
    s = s.replace(" ", "")
    parts = re.findall(r"\(([-0-9/]+)\)(\*z)?", s)
    if not parts:
        return (Fr(s), Fr(0))
    a = Fr(0); b = Fr(0)
    for num, isz in parts:
        if isz: b += Fr(num)
        else: a += Fr(num)
    return (a, b)
def parse_T(rhs, nv):
    rhs = rhs.strip()
    if rhs == "0": return {}
    P = {}
    for term in re.findall(r"\[([^\]]*)\]\*([x0-9\*\^]+)", rhs):
        c = parse_num(term[0])
        idxs = []
        for f in term[1].split("*"):
            m = re.fullmatch(r"x(\d+)(\^(\d+))?", f)
            idxs += [int(m.group(1))] * (int(m.group(3)) if m.group(3) else 1)
        P = padd(P, {mono(nv, idxs): c})
    return P
def read_arc(nv):
    Ts = {}
    for line in open(FILE):
        m = re.match(r"^T_(\d+) *= *(.*)$", line.strip())
        if m: Ts[int(m.group(1))] = parse_T(m.group(2), nv)
    return [Ts.get(j, {}) for j in range(1, max(Ts)+1)]

def exp_series(Ts, N, nv):
    E = [{tuple([0]*nv): ONE}]
    for n in range(1, N+1):
        acc = {}
        for j in range(1, min(n, len(Ts))+1):
            if Ts[j-1]:
                acc = padd(acc, pmul(pscal((Fr(j), Fr(0)), Ts[j-1]), E[n-j]))
        E.append(pscal((Fr(1, n), Fr(0)), acc))
    return E

def squarefree(nv, deg):
    return [mono(nv, c) for c in itertools.combinations(range(nv), deg)]

def rank_Qz(rows):
    rows = [r[:] for r in rows]
    rk = 0; ncols = len(rows[0])
    for c in range(ncols):
        p = None
        for i in range(rk, len(rows)):
            if not iszero(rows[i][c]): p = i; break
        if p is None: continue
        rows[rk], rows[p] = rows[p], rows[rk]
        iv = inv(rows[rk][c])
        prow = [mul(iv, x) if not iszero(x) else ZERO for x in rows[rk]]
        rows[rk] = prow
        nz = [k for k in range(ncols) if not iszero(prow[k])]
        for i in range(len(rows)):
            if i != rk and not iszero(rows[i][c]):
                f = rows[i][c]
                ri = rows[i]
                for k in nz: ri[k] = sub(ri[k], mul(f, prow[k]))
        rk += 1
    return rk

def first_order_matrix(P, forms, mons):
    M = []
    one = {tuple([0]*len(mons[0])): ONE}
    for q in forms:
        M.append([psi(P, {m: ONE}, q) for m in mons])
    return M

def fmt(u): return "(%s)+(%s)z" % (u[0], u[1])

def main():
    out = []
    def P(*a):
        s = " ".join(str(x) for x in a); print(s, flush=True)
    # ------------------------------------------------ tenfold
    nv = 12
    Ts = read_arc(nv)
    used = sorted({i for T in Ts for k in T for i, e in enumerate(k) if e})
    P("(i) number of T_j:", len(Ts), "; variables used:", used, "; subset of {0..5,8,9}:", set(used) <= {0,1,2,3,4,5,8,9})
    P1 = [(0,1,1),(2,3,1),(4,5,1),(6,7,1),(8,9,1),(10,11,1)]
    P2 = [(1,2,3),(3,4,3),(0,5,3),(6,7,1),(8,9,3),(10,11,1)]
    p1 = period_poly(nv, P1); p2 = period_poly(nv, P2)
    # sign-convention check through intersection numbers: socle pairing in S/(x_i^2) is proportional to the
    # intersection pairing of primitive parts, which for 5-planes meeting in P^m is  -(-2)^(m+1)/3.
    def pairing(a, b):
        full = tuple([1]*nv); tot = ZERO
        for k, v in a.items():
            kc = tuple(1-x for x in k)
            if kc in b: tot = add(tot, mul(v, b[kc]))
        return tot
    s11 = pairing(p1, p1); s22 = pairing(p2, p2); s12 = pairing(p1, p2)
    P("sign check: <P1,P1> =", fmt(s11), " <P2,P2> =", fmt(s22), " <P1,P2> =", fmt(s12),
      " ratio <P1,P2>/<P1,P1> =", fmt(mul(s12, inv(s11))), " (intersection theory predicts (-2)^(2-5) = -1/8)")
    # more pairs: change exponents of P1 in j pairs (meet in P^(5-j)); predicted ratio (-2)^(-j)
    for j in range(1, 7):
        Pj = [(a, b, 3 if i < j else e) for i, (a, b, e) in enumerate(P1)]
        pj = period_poly(nv, Pj)
        P("   P1 vs P1 with %d exponents changed (m=%d): ratio =" % (j, 5-j), fmt(mul(pairing(p1, pj), inv(s11))), " predicted", Fr((-2)**(6-j), 64))
    forms = [tuple([0]*nv)] + squarefree(nv, 3)
    P("number of forms:", len(forms))
    E = exp_series(Ts, 9, nv)
    P("number of terms of E_n, n=0..9:", [len(e) for e in E])
    def consts(q):
        k = (sum(q) + nv)//3
        f = 1
        for i in range(1, k): f *= i
        return Fr(120, f)     # (n/2)!/(k-1)!, n/2 = 5
    for name, PP in (("P1-P2", padd(p1, p2, (Fr(-1), Fr(0)))), ("P1+P2", padd(p1, p2)), ("P1", p1), ("P2", p2)):
        first_fail = None; nonzero_per_order = []
        for n in range(1, 10):
            cnt = 0
            for q in forms:
                if not iszero(psi(PP, E[n], q)): cnt += 1
            nonzero_per_order.append(cnt)
            if cnt and first_fail is None: first_fail = n
        P("(ii) class %s: number of forms with nonzero coefficient at orders 1..9: %s ; first failing order: %s" % (name, nonzero_per_order, first_fail))
    # ------------------------------------------------ Thom-Sebastiani check against the eightfold (10 variables)
    nv8 = 10
    Ts8 = read_arc(nv8)
    Q1 = [(0,1,1),(2,3,1),(4,5,1),(6,7,1),(8,9,1)]
    Q2 = [(1,2,3),(3,4,3),(0,5,3),(6,7,1),(8,9,3)]
    q1 = period_poly(nv8, Q1); q2 = period_poly(nv8, Q2)
    E8 = exp_series(Ts8, 9, nv8)
    forms8 = squarefree(nv8, 2)
    for name, PP8 in (("P1-P2", padd(q1, q2, (Fr(-1), Fr(0)))), ("P1+P2", padd(q1, q2))):
        nz = []
        for n in range(1, 10):
            nz.append(sum(1 for q in forms8 if not iszero(psi(PP8, E8[n], q))))
        P("eightfold, class %s, 45 quadric forms: nonzero coefficients at orders 1..9: %s" % (name, nz))
    # compare the tenfold period functions of P1 alone with the eightfold ones: Psi10(Q' x10 E) = 3 z^2 Psi8(Q' E), Psi10(Q' x11 E) = 3 z Psi8(Q' E)
    ok = True; nonzero_seen = 0; other_nonzero = 0
    c10 = smul(3, mul(Z, Z)); c11 = smul(3, Z)
    for n in range(1, 10):
        for q in forms[1:]:
            v = psi(p1, E[n], q)
            a, b = q[10], q[11]
            if a + b == 1:
                q8 = q[:10]
                w = psi(q1, E8[n], q8)
                tgt = mul(c10 if a == 1 else c11, w)
                if not iszero(sub(v, tgt)): ok = False
                if not iszero(v): nonzero_seen += 1
            else:
                if not iszero(v): other_nonzero += 1
    P("Thom-Sebastiani check (class P1 alone, orders 1..9): tenfold value = const * eightfold value for all forms Q' x10, Q' x11:", ok,
      "; nonzero values compared:", nonzero_seen, "; nonzero values at forms not of this shape:", other_nonzero)
    # ------------------------------------------------ first-order ranks, exact over Q(z)
    mons = squarefree(nv, 3)
    L1 = first_order_matrix(p1, forms, mons); L2 = first_order_matrix(p2, forms, mons)
    Lm = [[sub(x, y) for x, y in zip(r1, r2)] for r1, r2 in zip(L1, L2)]
    Lp = [[add(x, y) for x, y in zip(r1, r2)] for r1, r2 in zip(L1, L2)]
    P("(iii) exact ranks over Q(z): rank L(P1-P2) =", rank_Qz(Lm), "; rank [L_P1; L_P2] =", rank_Qz(L1 + L2),
      "; rank L_P1 =", rank_Qz(L1), "; rank L_P2 =", rank_Qz(L2), "; rank L(P1+P2) =", rank_Qz(Lp))
    idx = {m: i for i, m in enumerate(mons)}
    v = [ZERO]*len(mons)
    for k, c in Ts[0].items(): v[idx[k]] = c
    def apply(M):
        return [any(not iszero(x) for x in [__import__("functools").reduce(add, [mul(r[i], v[i]) for i in range(len(v)) if not iszero(v[i])], ZERO)]) for r in M]
    P("    T_1 in ker L(P1-P2):", not any(apply(Lm)), "; in ker L_P1:", not any(apply(L1)), "; in ker L_P2:", not any(apply(L2)), "; in ker L(P1+P2):", not any(apply(Lp)))

if __name__ == "__main__":
    main()
