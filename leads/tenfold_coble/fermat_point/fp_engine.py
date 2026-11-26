# Section 3 of PREREG_fermat.md: gate G and test H with the repository's Fermat engine (tooling/fermat_series, written
# by the previous agent), patched ONLY in its table of plane coefficients.  AI-written, unreviewed.
# usage: python3 fp_engine.py gate  p N          -> G: coordinate-change arcs (and sign-flipped controls)
#        python3 fp_engine.py ref   p seed N     -> G: engine against the dictionary implementation on the arc of H
#        python3 fp_engine.py kernel p seed N    -> all 924 eigenclasses along the arc H': which survive to order n
#        python3 fp_engine.py arcs  p seed N [m] -> H and the controls H1-H4 (m monomials per quadric phi_k, default 2)
# Coordinates: r_k = x_(2k), y_k = x_(2k+1), p_i = x_(6+2i), q_i = x_(7+2i).  Engine convention (fe_ref.py):
# F_tau = F_0 - sum_j tau^j T_j,  c_n[Q] = const_Q Psi(Q E_n),  E_n = [tau^n] exp(sum_j tau^j T_j).
import sys, os, itertools, time, random
import numpy as np
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, "..", "..", "..", "tooling", "fermat_series"))
os.environ.setdefault("FSC_SO_DIR", "/tmp/fsc_build"); os.makedirs(os.environ["FSC_SO_DIR"], exist_ok=True)
from fsc import FastEngine
from fe_ref import pack, NV, PAIRS
from fp_lib import R_IDX, Y_IDX, P_IDX, Q_IDX, IJ

P1 = (1, 1, 1); P2 = (3, 3, 3); P3 = (5, 5, 5)

def class_patterns(p, z, planes):
    """table of the engine: for each choice in {0,1}^6, (residue pattern r, sum_coef coef * prod (3c or 3c^2))"""
    pats = []
    for choice in itertools.product([0, 1], repeat=6):
        r = [0] * NV; tot = 0
        for k, (a, b) in enumerate(PAIRS):
            if choice[k] == 0: r[a] = 0; r[b] = 1
            else: r[a] = 1; r[b] = 0
        for coef, exps in planes:
            val = coef % p
            for k in range(6):
                ck = pow(z, exps[k], p)
                val = val * 3 * (ck if choice[k] == 0 else ck * ck % p) % p
            tot = (tot + val) % p
        pats.append((tuple(r), tot))
    return pats

def make_engine(p, planes, nthreads=2):
    W = FastEngine(p, 1, nthreads=nthreads)
    W.patterns = class_patterns(p, W.z, planes)
    W.poch_big = None; W._poch()
    tab = np.zeros(64, np.int64)
    for ch, v in W.tabv.items(): tab[sum(b << k for k, b in enumerate(ch))] = v % p
    W.tab = tab; W.vis = W.visible_table()
    return W

def set_class(W, planes, flip_eigen=False):
    p = W.p
    W.patterns = class_patterns(p, W.z, planes)
    if flip_eigen:   # change the sign of the coefficient on the patterns with residue 1 on p_0, p_1, p_2
        W.patterns = [(r, (-v) % p if all(r[a] == 1 for a in P_IDX) else v) for r, v in W.patterns]
    W.poch_big = None; W._poch()
    tab = np.zeros(64, np.int64)
    for ch, v in W.tabv.items(): tab[sum(b << k for k, b in enumerate(ch))] = v % p
    W.tab = tab; W.vis = W.visible_table()

def kappa(e): return [(1, (e, e, e) + P1), (1, (e, e, e) + P2), (1, (e, e, e) + P3)]
def delta(e, A=P1, B=P2): return [(1, (e, e, e) + A), (-1, (e, e, e) + B)]

# ---------------- polynomials as dicts {exponent tuple: coefficient mod p}
def dmul(A, B, p):
    out = {}
    for ea, ca in A.items():
        for eb, cb in B.items():
            e = tuple(x + y for x, y in zip(ea, eb))
            out[e] = (out.get(e, 0) + ca * cb) % p
    return {e: c for e, c in out.items() if c}
def dadd(p, *terms):
    out = {}
    for c0, A in terms:
        for e, c in A.items(): out[e] = (out.get(e, 0) + c0 * c) % p
    return {e: c for e, c in out.items() if c}
def to_poly(D, p):
    if not D: return (np.zeros(0, np.int64), np.zeros(0, np.int64))
    ks = np.array([pack(e) for e in D], dtype=np.int64); vs = np.array([D[e] % p for e in D], dtype=np.int64)
    o = np.argsort(ks); return (ks[o], vs[o])
def var(i):
    e = [0] * NV; e[i] = 1; return {tuple(e): 1}
def lin(coefs, p):
    out = {}
    for i, c in coefs.items():
        e = [0] * NV; e[i] = 1; out[tuple(e)] = c % p
    return out

def series_engine(W, Td, N, label="", quiet=False):
    """Td: list of dict polys T_1, T_2, ... ; returns list over n = 1..N of (number of nonzero period equations
    among the 221 forms, number of terms of E_n)"""
    p = W.p
    Tp = [to_poly(T, p) for T in Td]
    Es = [W.poly_one()]; res = []
    for n in range(1, N + 1):
        t0 = time.time()
        E, acc, nt = W.Eprime(n, Tp, Es, store=(n < N))
        out = np.zeros(3 ** NV, dtype=np.int64); out[W.keep_codes] = acc
        cv = (W.consts * out[W.form_codes]) % p
        res.append((int(np.count_nonzero(cv)), nt, cv))
        if n < N: Es.append(E)
        if not quiet:
            print("   %s n = %2d: terms of E_n %9d, nonzero period equations %3d of 221   [%.1fs]"
                  % (label, n, nt, res[-1][0], time.time() - t0), flush=True)
    return res

def first_fail(res):
    for n, r in enumerate(res, 1):
        if r[0]: return n
    return None

# ---------------- reference: dictionary polynomials and the closed formula, no engine code
def series_ref(p, z, planes, Td, N):
    inv3 = pow(3, p - 2, p)
    def poch(r, m):
        v = 1
        for l in range(m): v = v * ((1 + r + 3 * l) * inv3 % p) % p
        return v
    tabv = {}
    for r, val in class_patterns(p, z, planes): tabv[r] = val
    forms = [tuple([0] * NV)] + [tuple(1 if i in c else 0 for i in range(NV)) for c in itertools.combinations(range(NV), 3)]
    # the engine orders its 220 cubics differently; compare as multisets keyed by the form
    E = [{tuple([0] * NV): 1}]; out = []
    for n in range(1, N + 1):
        inv = pow(n, p - 2, p)
        En = dadd(p, *[(j * inv % p, dmul(Td[j - 1], E[n - j], p)) for j in range(1, n + 1) if j - 1 < len(Td) and Td[j - 1]])
        E.append(En)
        cv = {}
        for Q in forms:
            tot = 0
            for e, c in En.items():
                g = [a + b for a, b in zip(e, Q)]
                rho = tuple(x % 3 for x in g)
                if max(rho) > 1 or rho not in tabv: continue
                w = c * tabv[rho] % p
                for j in range(NV): w = w * poch(rho[j], g[j] // 3) % p
                tot = (tot + w) % p
            cv[Q] = tot * (20 if sum(Q) == 0 else 5) % p
        out.append(cv)
    return out

# ---------------- arcs
def gauge_arc(p, seed, flip=False):
    """F_0(g_tau x), g_tau = 1 + tau A + tau^2 B with sparse random A, B; returns the T_j (j = 1..6)"""
    rnd = random.Random(seed)
    A = {}; B = {}
    for _ in range(5): A[(rnd.randrange(NV), rnd.randrange(NV))] = rnd.randrange(1, p)
    for _ in range(3): B[(rnd.randrange(NV), rnd.randrange(NV))] = rnd.randrange(1, p)
    # image of x_i: x_i + tau sum_j A[i,j] x_j + tau^2 sum_j B[i,j] x_j  -> polynomial in tau with dict coefficients
    Fser = {}                                    # power of tau -> dict poly
    for i in range(NV):
        l0 = var(i); l1 = lin({j: c for (ii, j), c in A.items() if ii == i}, p); l2 = lin({j: c for (ii, j), c in B.items() if ii == i}, p)
        L = {0: l0, 1: l1, 2: l2}
        sq = {}
        for a in L:
            for b in L:
                if L[a] and L[b]: sq[a + b] = dadd(p, (1, sq.get(a + b, {})), (1, dmul(L[a], L[b], p)))
        for a in sq:
            for b in L:
                if sq[a] and L[b]: Fser[a + b] = dadd(p, (1, Fser.get(a + b, {})), (1, dmul(sq[a], L[b], p)))
    sgn = 1 if flip else -1                      # convention F = F_0 - sum tau^j T_j  ->  T_j = -[tau^j] F
    return [dadd(p, (sgn % p, Fser.get(j, {}))) for j in range(1, 7)], (A, B)

NMON = 2
def coble_arc(p, seed, N, theta0=1, mode="true"):
    """the arc of PREREG section 3.  mode: "true" | "theta1" (H1) | "thetaflip" (H2) | "wrongP8" (H4)"""
    rnd = random.Random(seed)
    xi = [rnd.randrange(1, p) for _ in range(3)]
    M = {}
    for (i, j) in IJ:
        e = [0] * NV; e[Y_IDX[(i + j) % 3]] += 1; e[P_IDX[i]] += 1; e[Q_IDX[j]] += 1
        M[tuple(e)] = (M.get(tuple(e), 0) + xi[(i - j) % 3]) % p
    phis = []
    for k in range(3):
        phi = {}
        while len(phi) < NMON:
            a, b = rnd.randrange(NV), rnd.randrange(NV)
            e = [0] * NV; e[a] += 1; e[b] += 1; phi[tuple(e)] = rnd.randrange(1, p)
        phis.append(phi)
    Rphi = dadd(p, *[(1, dmul(var(R_IDX[k]), phis[k], p)) for k in range(3)])
    Yphi = dadd(p, *[(1, dmul(var(Y_IDX[k]), phis[k], p)) for k in range(3)])
    h = sum(pow(a, 3, p) for a in xi) % p
    cc = h * pow(27, p - 2, p) % p
    if mode == "thetaflip": cc = (-cc) % p
    # theta(tau) = theta0 * (1 + cc tau^3)^(1/3) = theta0 * sum_j binom(1/3, j) cc^j tau^(3j)
    inv3 = pow(3, p - 2, p); th = [theta0 % p]; b = 1
    for j in range(1, N // 3 + 2):
        b = b * ((inv3 - (j - 1)) % p) % p * pow(j, p - 2, p) % p
        th.append(theta0 * b % p * pow(cc, j, p) % p)
    if mode == "theta1": th = [theta0 % p] + [0] * (len(th) - 1)
    t0 = th[0] if mode != "wrongP8" else 2 * th[0] % p
    Td = [dict() for _ in range(N)]
    Td[0] = dadd(p, (p - 1, M), (p - 1, Rphi), ((-t0) % p, Yphi))
    for j in range(1, len(th)):
        if 3 * j + 1 <= N: Td[3 * j] = dadd(p, ((-th[j]) % p, Yphi))
    return Td, dict(xi=xi, phis=phis, theta=th)

def smul(A, B, p, N):
    out = [0] * (N + 1)
    for i, a in enumerate(A):
        if a:
            for j, b in enumerate(B):
                if i + j > N: break
                out[i + j] = (out[i + j] + a * b) % p
    return out
def sinv(A, p, N):
    """1/A for a series with A[0] != 0"""
    out = [0] * (N + 1); a0 = pow(A[0], p - 2, p); out[0] = a0
    for n in range(1, N + 1):
        s = sum(A[k] * out[n - k] for k in range(1, min(n, len(A) - 1) + 1)) % p
        out[n] = (-s * a0) % p
    return out
def scuberoot1(A, p, N):
    """(1 + A)^(1/3) for a series A with A[0] = 0"""
    inv3 = pow(3, p - 2, p); out = [0] * (N + 1); out[0] = 1; pw = [1] + [0] * N; b = 1
    for j in range(1, N + 1):
        pw = smul(pw, A, p, N); b = b * ((inv3 - (j - 1)) % p) % p * pow(j, p - 2, p) % p
        out = [(o + b * c) % p for o, c in zip(out, pw)]
    return out

def coble_arc_lam(p, seed, N, mode="true"):
    """the arc of PREREG section 4 (lam = lam_1 tau).  mode: "true" | "noY" (H'1) | "h0" (H'2) | "nolam3" (H'3).
    Returns the T_j (convention F = F_0 - sum tau^j T_j) and the data."""
    rnd = random.Random(seed)
    xi = [rnd.randrange(1, p) for _ in range(3)]; lam1 = rnd.randrange(1, p)
    M = {}
    for (i, j) in IJ:
        e = [0] * NV; e[Y_IDX[(i + j) % 3]] += 1; e[P_IDX[i]] += 1; e[Q_IDX[j]] += 1
        M[tuple(e)] = (M.get(tuple(e), 0) + xi[(i - j) % 3]) % p
    phis = []
    for k in range(3):
        phi = {}
        while len(phi) < NMON:
            a, b = rnd.randrange(NV), rnd.randrange(NV)
            e = [0] * NV; e[a] += 1; e[b] += 1; phi[tuple(e)] = rnd.randrange(1, p)
        phis.append(phi)
    Rphi = dadd(p, *[(1, dmul(var(R_IDX[k]), phis[k], p)) for k in range(3)])
    Yphi = dadd(p, *[(1, dmul(var(Y_IDX[k]), phis[k], p)) for k in range(3)])
    def mon3(idx):
        e = [0] * NV
        for i in idx: e[i] = 1
        return {tuple(e): 1}
    PQ = dadd(p, (1, mon3(P_IDX)), (1, mon3(Q_IDX))); Ym = mon3(Y_IDX)
    h0 = sum(pow(a, 3, p) for a in xi) % p; Xi = xi[0] * xi[1] * xi[2] % p
    inv27 = pow(27, p - 2, p)
    # series in tau, index = power
    hl = [0] * (N + 2); hl[3] = h0
    if mode != "h0": hl[4] = 3 * lam1 * Xi % p
    den = [0] * (N + 2); den[0] = 1
    if mode != "nolam3" and N + 1 >= 3: den[3] = pow(lam1, 3, p)
    a = [(-c * inv27) % p for c in smul(hl, sinv(den, p, N + 1), p, N + 1)]          # a(tau)
    theta = scuberoot1([(-c) % p for c in a], p, N + 1)                               # theta = (1 - a)^(1/3)
    F = {}                                                                            # power of tau -> dict poly (F - F_0)
    def put(k, c, D):
        if k <= N and c % p: F[k] = dadd(p, (1, F.get(k, {})), (c % p, D))
    put(1, 3 * lam1, PQ); put(1, 1, M); put(1, 1, Rphi)
    for k, c in enumerate(theta): put(k + 1, c, Yphi)
    if mode != "noY":
        for k, c in enumerate(a): put(k + 1, 3 * lam1 * c, Ym)
    Td = [dadd(p, (p - 1, F.get(j, {}))) for j in range(1, N + 1)]
    return Td, dict(xi=xi, lam1=lam1, phis=phis, a=a, theta=theta, M=M, Rphi=Rphi, Yphi=Yphi, PQ=PQ, Ym=Ym)

def check_section(p, info, tau, N):
    """numeric check MOD p at a value of tau of the hand algebra: the truncated arc restricted to r = -theta y
    equals the normal form a h_lam(y) + h_lam(p) + h_lam(q) + M_x, with the series a, theta summed to order N
    (so the check is of the algebra, at random points y, p, q; agreement holds up to the truncation in tau,
    which is avoided by using the summed values consistently on both sides)."""
    rnd = random.Random(7)
    aval = sum(c * pow(tau, k, p) for k, c in enumerate(info["a"])) % p
    th = sum(c * pow(tau, k, p) for k, c in enumerate(info["theta"])) % p
    lam = info["lam1"] * tau % p; x = [c * tau % p for c in info["xi"]]
    ok = True
    for _ in range(5):
        y = [rnd.randrange(p) for _ in range(3)]; pp = [rnd.randrange(p) for _ in range(3)]; qq = [rnd.randrange(p) for _ in range(3)]
        r = [(-th * v) % p for v in y]
        pt = [0] * NV
        for k in range(3): pt[R_IDX[k]] = r[k]; pt[Y_IDX[k]] = y[k]; pt[P_IDX[k]] = pp[k]; pt[Q_IDX[k]] = qq[k]
        ev = lambda D: sum(c * __import__("functools").reduce(lambda u, t: u * pow(pt[t[0]], t[1], p) % p, enumerate(e), 1) for e, c in D.items()) % p
        h0v = lambda v: sum(pow(t, 3, p) for t in v) % p
        hl = lambda v: (h0v(v) + 3 * lam * v[0] * v[1] * v[2]) % p
        Mx = sum(x[(i - j) % 3] * y[(i + j) % 3] * pp[i] * qq[j] for i in range(3) for j in range(3)) % p
        # tenfold at this tau with the SUMMED a and theta (phi-terms vanish on the section by construction)
        Ften = (h0v(r) + h0v(y) + h0v(pp) + h0v(qq) + 3 * lam * (pp[0] * pp[1] * pp[2] + qq[0] * qq[1] * qq[2])
                + 3 * aval * lam * y[0] * y[1] * y[2] + Mx) % p
        normal = (aval * hl(y) + hl(pp) + hl(qq) + Mx) % p
        # theta^3 = 1 - a holds only up to the truncation; use the identity with the residual made explicit
        resid = (pow(th, 3, p) - (1 - aval)) % p
        if (Ften - normal + resid * h0v(y)) % p != 0: ok = False
    return ok


def kernel_run(p, seed, N):
    """Which classes survive along the arc H'?  For all 924 torus eigenclasses of type (5,5) at once: the space of
    combinations v whose period equations (221 forms) vanish to order n along the arc, n = 1..N.  (This replicates
    an observation of the fifth blind checker, its item T8.1, with this code.)"""
    from fe_ref import unpack
    from fp_lib import patterns55, poch_table
    from fp_main import rref_add
    W = make_engine(p, kappa(3)); inv3 = pow(3, p - 2, p)
    pats, idx = patterns55(); npat = len(pats)
    pidx = -np.ones(1 << NV, dtype=np.int64)
    for code, t in idx.items(): pidx[code] = t
    # Pochhammer weights WITH the factors 1/3: along an arc with terms T_j of several orders the monomials of E_n
    # have different degrees, so 3^(-sum m_j) is not a common factor (it is one in fp_main.py, where only T_1 occurs)
    T = np.ones((2, 64), dtype=np.int64)
    for r in range(2):
        for m in range(1, 64): T[r, m] = T[r, m - 1] * ((1 + r + 3 * (m - 1)) * inv3 % p) % p
    Td, info = coble_arc_lam(p, seed, N)
    Tp = [to_poly(Tj, p) for Tj in Td]; Es = [W.poly_one()]
    forms = np.array([list(e) for e in W.fexps], dtype=np.int64)
    # the three-plane class as a vector over the patterns (coefficient of Psi_rho): from the engine's own table
    vk = np.zeros(npat, dtype=np.int64)
    for r, val in class_patterns(p, W.z, kappa(3)):
        vk[idx[sum(1 << a for a in range(NV) if r[a] == 1)]] = val
    basis = []; piv = []; pw2 = 1 << np.arange(NV)
    for n in range(1, N + 1):
        E, acc, nt = W.Eprime(n, Tp, Es, store=True); Es.append(E)
        ex = unpack(E[0]); cf = E[1].astype(np.int64) % p
        rows = []
        for Q in forms:
            g = ex + Q[None, :]; rho = g % 3
            ok = np.all(rho <= 1, axis=1) & (rho.sum(axis=1) == 6)
            if not ok.any(): continue
            g = g[ok]; rho = rho[ok]; m = g // 3; w = cf[ok].copy()
            for j in range(NV): w = w * T[rho[:, j], m[:, j]] % p
            row = np.zeros(npat, dtype=np.int64); np.add.at(row, pidx[rho @ pw2], w); row %= p
            if row.any(): rows.append(row)
        rref_add(basis, piv, rows, p)
        B = np.array(basis)
        print("KERNEL MOD %d seed %d, n = %d: forms with a non-zero row %3d, rank so far %3d, classes that survive: dimension %3d; "
              "the three-plane class among them: %s" % (p, seed, n, len(rows), len(basis), npat - len(basis), not np.any(B @ vk % p)), flush=True)

if __name__ == "__main__":
    mode = sys.argv[1]; p = int(sys.argv[2])
    if mode == "kernel":
        if len(sys.argv) > 5: NMON = int(sys.argv[5])
        kernel_run(p, int(sys.argv[3]), int(sys.argv[4])); sys.exit(0)
    if mode == "arcsl":
        seed = int(sys.argv[3]); N = int(sys.argv[4])
        if len(sys.argv) > 5: NMON = int(sys.argv[5])
        W = make_engine(p, kappa(3))
        Td, info = coble_arc_lam(p, seed, N)
        # the relation 27 (1 + lam^3) a + h_lam(x) = 0 and theta^3 = 1 - a as series, and the section, numerically
        lam3 = [0] * (N + 2); lam3[0] = 1; lam3[3] = pow(info["lam1"], 3, p)
        hl = [0] * (N + 2); hl[3] = sum(pow(c, 3, p) for c in info["xi"]) % p; hl[4] = 3 * info["lam1"] * info["xi"][0] * info["xi"][1] * info["xi"][2] % p
        rel = [(27 * c + d) % p for c, d in zip(smul(lam3, info["a"], p, N + 1), hl)]
        t3 = smul(smul(info["theta"], info["theta"], p, N + 1), info["theta"], p, N + 1)
        rel2 = [(c + d - (1 if k == 0 else 0)) % p for k, (c, d) in enumerate(zip(t3, info["a"]))]
        print("MOD %d seed %d: xi = %s, lam_1 = %d; series relations hold to order %d: %s, %s; section identity at 3 values of tau: %s"
              % (p, seed, info["xi"], info["lam1"], N + 1, not any(rel), not any(rel2), [check_section(p, info, t, N) for t in (2, 3, 5)]), flush=True)
        print("   terms of T_1: %d; orders with nonzero T_j: %s" % (len(Td[0]), [j + 1 for j, T in enumerate(Td) if T]))
        res = series_engine(W, Td, N, label="H' three-plane class")
        print("RESULT H' MOD %d seed %d: three-plane class along the Coble arc with lam, orders 1..%d: first failing order %s" % (p, seed, N, first_fail(res)), flush=True)
        Nc = min(N, 9)
        for nm, md in (("H'1 no term 3 a lam Y", "noY"), ("H'2 h_0 in place of h_lam", "h0"), ("H'3 no factor (1 + lam^3)", "nolam3")):
            Tc, _ = coble_arc_lam(p, seed, Nc, mode=md)
            rc = series_engine(W, Tc, Nc, quiet=True)
            print("CONTROL %-28s: first failing order %s (orders 1..%d)" % (nm, first_fail(rc), Nc), flush=True)
        Tt, _ = coble_arc_lam(p, seed, min(N, 5))
        set_class(W, delta(3)); rc = series_engine(W, Tt, min(N, 5), quiet=True)
        print("CONTROL %-28s: first failing order %s (orders 1..%d)" % ("H'4 P1 - P2", first_fail(rc), min(N, 5)), flush=True)
        sys.exit(0)
    if mode == "gate":
        N = int(sys.argv[3])
        W = make_engine(p, delta(1))
        for seed in (1, 2, 3):
            for flip in (False, True):
                Td, _ = gauge_arc(p, seed, flip)
                for nm, planes in (("P1 - P2", delta(1)), ("three-plane class", kappa(1))):
                    set_class(W, planes)
                    res = series_engine(W, Td, N, quiet=True)
                    print("GATE MOD %d seed %d, %s, class %-18s: first failing order %s (orders 1..%d; terms of E_n: %s)"
                          % (p, seed, "signs flipped (control)" if flip else "coordinate change       ", nm, first_fail(res), N,
                             [r[1] for r in res]), flush=True)
    elif mode == "ref":
        seed = int(sys.argv[3]); N = int(sys.argv[4])
        W = make_engine(p, kappa(1))
        for nm, planes in (("three-plane class", kappa(1)), ("P1 - P2", delta(1))):
            set_class(W, planes)
            Td, info = coble_arc(p, seed, N)
            res = series_engine(W, Td, N, quiet=True)
            ref = series_ref(p, W.z, planes, Td, N)
            forms = [tuple(W.fexps[i]) for i in range(len(W.fexps))]
            same = all(int(res[n][2][qi]) == ref[n][forms[qi]] for n in range(N) for qi in range(len(forms)))
            print("REF MOD %d seed %d class %-18s: engine and dictionary implementation agree on all 221 period equations, orders 1..%d: %s"
                  " (nonzero entries per order: %s)" % (p, seed, nm, N, same, [r[0] for r in res]), flush=True)
    elif mode == "arcs":
        seed = int(sys.argv[3]); N = int(sys.argv[4])
        if len(sys.argv) > 5: NMON = int(sys.argv[5])      # monomials per quadric phi_k (default 2)
        W = make_engine(p, kappa(1))
        # which root on the first three pairs goes with the P^8 {r_k = -y_k}: first-order test on the three choices
        Td, info = coble_arc(p, seed, 1)
        ok = {}
        for e in (1, 3, 5):
            set_class(W, kappa(e)); ok[e] = first_fail(series_engine(W, Td, 1, quiet=True)) is None
        print("MOD %d seed %d: xi = %s; first-order test of w * phi for the three roots on the pairs (r_k, y_k): %s" % (p, seed, info["xi"], ok), flush=True)
        es = [e for e in ok if ok[e]]
        if len(es) != 1: print("RESULT: cannot identify the P^8; stop"); sys.exit(1)
        e = es[0]
        # is L(T_4) != 0 (so that H1 can fail at order 4)?
        Td, info = coble_arc(p, seed, 4)
        set_class(W, kappa(e)); r4 = series_engine(W, [Td[3]], 1, quiet=True)
        print("   L(T_4) has %d nonzero entries (H1 can fail at order 4 only if this is > 0)" % r4[0][0], flush=True)
        Td, info = coble_arc(p, seed, N)
        print("   terms of T_1: %d" % len(Td[0]))
        set_class(W, kappa(e))
        res = series_engine(W, Td, N, label="H three-plane class")
        print("RESULT H MOD %d seed %d: three-plane class along the Coble arc, orders 1..%d: first failing order %s" % (p, seed, N, first_fail(res)), flush=True)
        Nc = min(N, 7)
        for nm, md in (("H1 theta = 1", "theta1"), ("H2 sign of h_0(xi) flipped", "thetaflip"), ("H4 wrong P^8", "wrongP8")):
            Tc, _ = coble_arc(p, seed, Nc, mode=md)
            rc = series_engine(W, Tc, Nc, quiet=True)
            print("CONTROL %-28s: first failing order %s (orders 1..%d)" % (nm, first_fail(rc), Nc), flush=True)
        Tt, _ = coble_arc(p, seed, Nc)
        for nm, planes, fl in (("H3 P1 - P2", delta(e), False), ("H3 P1 - P3", delta(e, P1, P3), False),
                               ("H3 one eigen-sign flipped", kappa(e), True)):
            set_class(W, planes, flip_eigen=fl); rc = series_engine(W, Tt, Nc, quiet=True)
            print("CONTROL %-28s: first failing order %s (orders 1..%d)" % (nm, first_fail(rc), Nc), flush=True)
