#!/usr/bin/env python3
"""Blind check 12, claim C1 -- OWN implementation (no package code, no B_own.py).

Period functional of a linear space in the Fermat cubic sixfold, derived from first principles up to one
overall scalar (see REPORT.md):  lambda_P(y^r) for r squarefree of degree 4 is non-zero iff r contains exactly
one index of every pair {a,b} of P (x_a = z^e x_b), and then equals c_P * prod_{pairs with a in r} z^e.
Relative constant c_P2 / c_P1 = z^2, obtained from the automorphism of the Fermat cubic carrying P1 to P2.

Periods along F_eps = F0 - S, S = sum eps^n T_n :
   int y_i Omega / F_eps^3  =  9 * Lam( y_i * exp(S/3) ),      int Q Omega / F_eps^4 = Lam( Q * exp(S/3) ),
   Lam(y^g) = lambda(y^(g mod 3)) * prod_k c(g_k),  c(3q+r) = prod_{s=1..q} (3s + r - 2), zero if some g_k = 2 mod 3.
Everything exact over QQ(z), z^2 = z - 1, with python-flint fmpq / fmpq_mpoly.
"""
import sys, re, time, itertools
from flint import fmpq, fmpq_mpoly_ctx, Ordering
import sympy

REPO = "/home/claude/hodgelocici"
ARC = REPO + "/leads/tenfold_twodet/matrices/arc_true_order19.txt"
CERT = REPO + "/M2/HodgeLociCI/data/six_lam-1_arc.txt"
PER = REPO + "/leads/tenfold_twodet/matrices/periods_deg4_order19.txt"
NMAX = int(sys.argv[1]) if len(sys.argv) > 1 else 19
QMAX = int(sys.argv[2]) if len(sys.argv) > 2 else NMAX   # order to which the quartic periods are compared

t0 = time.time()
xs = sympy.symbols("x_0:8"); zs = sympy.Symbol("z")

def parse_poly(s):
    """string -> {exponent tuple: (a, b)}  meaning coefficient a + b z (fmpq)."""
    e = sympy.sympify(s, locals={**{"x_%d" % i: xs[i] for i in range(8)}, "z": zs})
    p = sympy.Poly(sympy.expand(e), *xs, zs)
    out = {}
    for mon, c in p.terms():
        ex, zd = mon[:8], mon[8]
        a = fmpq(int(c.p), int(c.q))
        # reduce z^zd with z^2 = z - 1
        u, v = fmpq(1), fmpq(0)
        for _ in range(zd):
            u, v = -v, u + v
        A, B = out.get(ex, (fmpq(0), fmpq(0)))
        out[ex] = (A + a * u, B + a * v)
    return {k: v for k, v in out.items() if v != (0, 0)}

# ---- the arc
lines = [l.strip() for l in open(ARC) if l.strip() and not l.startswith("#")]
T = [parse_poly(l) for l in lines]
print("arc terms read:", len(T), " monomials per term:", [len(t) for t in T])

# ---- C1(c): no monomial contains y5
allmons = set(m for t in T for m in t)
print("C1(c) distinct monomials in T_1..T_19:", sorted(allmons, reverse=True))
print("C1(c) some monomial contains y5:", any(m[5] != 0 for m in allmons))
print("     all terms homogeneous cubics:", all(sum(m) == 3 for m in allmons))

# ---- C1(b): compare with the certificate
cert = {}
for l in open(CERT):
    mm = re.match(r"T_(\d+) = (.*)$", l.strip())
    if mm:
        s = mm.group(2).replace("[", "(").replace("]", ")")
        s = re.sub(r"x(\d)", lambda g: "x_" + g.group(1), s)
        s = s.replace("x_8", "X8").replace("x_9", "X9")
        e = sympy.sympify(s, locals={**{"x_%d" % i: xs[i] for i in range(8)}, "z": zs,
                                     "X8": sympy.Symbol("X8"), "X9": sympy.Symbol("X9")})
        # eightfold -> sixfold: x6 = x7 = 0, then x8 -> y6, x9 -> y7
        e = e.subs({xs[6]: 0, xs[7]: 0}).subs({sympy.Symbol("X8"): xs[6], sympy.Symbol("X9"): xs[7]})
        cert[int(mm.group(1))] = parse_poly(str(e)) if e != 0 else {}
        cert_raw_has67 = bool(re.search(r"x[67](?!\d)", mm.group(2)))
        if cert_raw_has67:
            print("   note: certificate T_%s involves x6 or x7 before restriction" % mm.group(1))
print("certificate terms:", sorted(cert))
for n in sorted(cert):
    same = (cert[n] == T[n - 1])
    print("C1(b) T_%d equal to certificate: %s" % (n, same))
    if not same:
        keys = sorted(set(cert[n]) | set(T[n - 1]))
        for k in keys:
            print("      ", k, " arc:", T[n - 1].get(k), " cert:", cert[n].get(k))

# ---- polynomial arithmetic over QQ(z): pairs (A, B) of fmpq_mpoly, meaning A + z B
ctx = fmpq_mpoly_ctx.get(["y%d" % i for i in range(8)], Ordering.lex)
def topoly(d):
    A = ctx.from_dict({k: v[0] for k, v in d.items() if v[0] != 0})
    B = ctx.from_dict({k: v[1] for k, v in d.items() if v[1] != 0})
    return (A, B)
def mul(p, q):
    A, B = p; C, D = q
    BD = B * D
    return (A * C - BD, A * D + B * C + BD)
def add(p, q): return (p[0] + q[0], p[1] + q[1])
def scal(c, p): return (p[0] * c, p[1] * c)
ZERO = (ctx.from_dict({}), ctx.from_dict({}))
ONE = (ctx.from_dict({(0,) * 8: fmpq(1)}), ctx.from_dict({}))
Tp = [topoly(t) for t in T]

# ---- the functional
def zpow(k):
    u, v = fmpq(1), fmpq(0)
    for _ in range(k % 6):
        u, v = -v, u + v
    return (u, v)
def zmul(p, q):
    return (p[0] * q[0] - p[1] * q[1], p[0] * q[1] + p[1] * q[0] + p[1] * q[1])
L1 = [(0, 1, 1), (2, 3, 1), (4, 5, 1), (6, 7, 1)]
L2 = [(1, 2, 3), (3, 4, 3), (0, 5, 3), (6, 7, 3)]
def lam_space(L):
    out = {}
    for choice in itertools.product((0, 1), repeat=4):
        r = [0] * 8; e = 0
        for (a, b, ex), ch in zip(L, choice):
            if ch == 0:
                r[a] = 1; e += ex
            else:
                r[b] = 1
        out[tuple(r)] = zpow(e)
    return out
lam1, lam2 = lam_space(L1), lam_space(L2)
z2 = zpow(2)
lam = {}
for r, v in lam1.items():
    lam[r] = v
for r, v in lam2.items():
    w = zmul(z2, v)
    old = lam.get(r, (fmpq(0), fmpq(0)))
    lam[r] = (old[0] - w[0], old[1] - w[1])
lam = {r: v for r, v in lam.items() if v != (0, 0)}
print("support of lambda_0 = lam_P1 - z^2 lam_P2 (unit constant):", len(lam), "squarefree quartics")

cc = {}
def cfac(g):
    if g not in cc:
        q, r = divmod(g, 3)
        v = fmpq(1)
        for s in range(1, q + 1):
            v *= (3 * s + r - 2)
        cc[g] = v if r != 2 else fmpq(0)
    return cc[g]

# ---- E_n = [eps^n] exp(S/3):  n E_n = sum_j j (T_j/3) E_{n-j}
E = [ONE]
third = fmpq(1, 3)
for n in range(1, NMAX + 1):
    acc = ZERO
    for j in range(1, min(n, len(Tp)) + 1):
        acc = add(acc, scal(fmpq(j), mul(Tp[j - 1], E[n - j])))
    E.append(scal(third / n, acc))
print("E_n built to order", NMAX, " sizes:", [len(e[0].to_dict() | e[1].to_dict()) for e in E],
      " time %.1fs" % (time.time() - t0))

# terms of E_n grouped by residue class mod 3
def grouped(n):
    dA, dB = E[n][0].to_dict(), E[n][1].to_dict()
    g = {}
    for mu in set(dA) | set(dB):
        mu_t = tuple(int(a) for a in mu)
        rho = tuple(a % 3 for a in mu_t)
        g.setdefault(rho, []).append((mu_t, dA.get(mu, fmpq(0)), dB.get(mu, fmpq(0))))
    return g
G = [grouped(n) for n in range(NMAX + 1)]
print("residue classes per order:", [len(g) for g in G], " time %.1fs" % (time.time() - t0))

def Lam_times(beta, n):
    """Lam(y^beta * E_n) as (a, b) = a + b z."""
    ra, rb = fmpq(0), fmpq(0)
    for rho, terms in G[n].items():
        r = tuple((rho[k] + beta[k]) % 3 for k in range(8))
        if r not in lam:
            continue
        la, lb = lam[r]
        sa, sb = fmpq(0), fmpq(0)
        for mu, ca, cb in terms:
            f = fmpq(1)
            for k in range(8):
                f *= cfac(mu[k] + beta[k])
            sa += f * ca; sb += f * cb
        w = zmul((sa, sb), (la, lb))
        ra += w[0]; rb += w[1]
    return (ra, rb)

# ---- C1(a): the eight linear periods, orders 1..NMAX   (constant 9 irrelevant)
print("C1(a) OWN implementation: Taylor coefficients of the 8 periods int y_i Omega/F_eps^3 over [P1]-[P2]")
allzero = True
for n in range(0, NMAX + 1):
    row = []
    for i in range(8):
        beta = tuple(1 if k == i else 0 for k in range(8))
        row.append(Lam_times(beta, n))
    zero = all(v == (0, 0) for v in row)
    if n >= 1: allzero = allzero and zero
    print("   order %2d: all eight zero: %s" % (n, zero), "" if zero else [str(v) for v in row])
print("C1(a) orders 1..%d all zero: %s   time %.1fs" % (NMAX, allzero, time.time() - t0))

# sanity (negative control): change one coefficient of T_k and look for the first non-zero order
for kbad in (3, 12, 19):
    if kbad > NMAX: continue
    Tb = list(Tp)
    Tb[kbad - 1] = add(Tp[kbad - 1], topoly({(1, 1, 0, 1, 0, 0, 0, 0): (fmpq(1, 1000), fmpq(0))}))
    Eb = [ONE]
    for n in range(1, NMAX + 1):
        acc = ZERO
        for j in range(1, n + 1):
            acc = add(acc, scal(fmpq(j), mul(Tb[j - 1], Eb[n - j])))
        Eb.append(scal(third / n, acc))
    first = None
    for n in range(1, NMAX + 1):
        dA, dB = Eb[n][0].to_dict(), Eb[n][1].to_dict()
        ok = True
        for i in range(8):
            ra, rb = fmpq(0), fmpq(0)
            for mu in set(dA) | set(dB):
                g = [int(a) for a in mu]; g[i] += 1
                r = tuple(a % 3 for a in g)
                if r in lam:
                    f = fmpq(1)
                    for a in g: f *= cfac(a)
                    w = zmul((f * dA.get(mu, fmpq(0)), f * dB.get(mu, fmpq(0))), lam[r])
                    ra += w[0]; rb += w[1]
            if (ra, rb) != (0, 0): ok = False
        if not ok:
            first = n; break
    print("   control: T_%d + (1/1000) x0 x1 x3 -> first order with a non-zero period: %s" % (kbad, first))
print("time %.1fs" % (time.time() - t0))

# ---- the quartic periods: compare with periods_deg4_order19.txt (up to ONE overall constant)
def pq(s):
    s = s.strip()
    if "/" in s:
        a, b = s.split("/"); return fmpq(int(a), int(b))
    return fmpq(int(s))
filep = {}
for l in open(PER):
    if l.startswith("#") or not l.strip(): continue
    parts = [p.strip() for p in l.split(";")]
    beta = tuple(int(a) for a in parts[0].strip("{}").split(","))
    vals = []
    for p in parts[1:]:
        if not p: continue
        a, b = p.split()
        vals.append((pq(a), pq(b)))
    filep[beta] = vals
print("periods file: %d quartics, orders 0..%d" % (len(filep), len(next(iter(filep.values()))) - 1))
# overall constant from one order-0 entry
const = None
for beta, vals in filep.items():
    if vals[0] != (0, 0):
        mine = Lam_times(beta, 0)
        # const = file / mine in QQ(z): 1/(a+bz) = (a+b-bz)/(a^2+ab+b^2)
        a, b = mine; nrm = a * a + a * b + b * b
        const = zmul(vals[0], ((a + b) / nrm, -b / nrm))
        print("overall constant file/own (from", beta, "):", const)
        break
bad = 0; cnt = 0; firstbad = None
for n in range(0, QMAX + 1):
    badn = 0
    for beta, vals in filep.items():
        mine = zmul(const, Lam_times(beta, n))
        cnt += 1
        if mine != vals[n]:
            badn += 1
            if firstbad is None: firstbad = (beta, n, mine, vals[n])
    bad += badn
    print("   quartic periods, order %2d: mismatches %d of %d   (non-zero in file: %d)   time %.1fs" %
          (n, badn, len(filep), sum(1 for v in filep.values() if v[n] != (0, 0)), time.time() - t0))
    sys.stdout.flush()
print("quartic periods compared: %d entries, mismatches %d" % (cnt, bad), firstbad if firstbad else "")
# C2(b) exact part: every quartic divisible by y5^2 has identically zero series in the file
print("file: all series of quartics with y5-exponent >= 2 are identically zero:",
      all(all(v == (0, 0) for v in vals) for beta, vals in filep.items() if beta[5] >= 2),
      " (number of such quartics: %d)" % sum(1 for b in filep if b[5] >= 2))
