#!/usr/bin/env python3
# S7: period identity check (blind, written from the definitions).
import sys, random, itertools
from math import comb, factorial

def monos(d):
    return [(a, b, d - a - b) for a in range(d, -1, -1) for b in range(d - a, -1, -1)]

class Ctx:
    def __init__(self, pr, lam, rng):
        self.p = pr
        self.lam = lam % pr
        self.rng = rng
        self.mon = {}
        self.idx = {}
        self.cache = {}

    def M(self, d):
        if d not in self.mon:
            self.mon[d] = monos(d)
            self.idx[d] = {m: i for i, m in enumerate(self.mon[d])}
        return self.mon[d]

    def I(self, d):
        self.M(d)
        return self.idx[d]

    def dh(self, i):
        # dh/dp_i = 3 p_i^2 + 3 lam p_{i+1} p_{i+2}  as dict exponent->coeff
        e = [0, 0, 0]; e[i] = 2
        f = [1, 1, 1]; f[i] = 0
        return {tuple(e): 3 % self.p, tuple(f): (3 * self.lam) % self.p}

    def Tmat(self, d):
        """matrix of (A_0,A_1,A_2) in (R_{d-2})^3 -> sum A_i dh/dp_i in R_d ; rows = monomials of degree d"""
        p = self.p
        src = self.M(d - 2); tgt = self.I(d)
        m = len(self.M(d)); n = 3 * len(src)
        T = [[0] * n for _ in range(m)]
        for i in range(3):
            dhi = self.dh(i)
            for k, mo in enumerate(src):
                col = i * len(src) + k
                for e, c in dhi.items():
                    t = (mo[0] + e[0], mo[1] + e[1], mo[2] + e[2])
                    T[tgt[t]][col] = (T[tgt[t]][col] + c) % p
        return T

    def Divmat(self, d):
        """matrix of (A_0,A_1,A_2) in (R_{d-2})^3 -> sum dA_i/dp_i in R_{d-3}"""
        p = self.p
        src = self.M(d - 2)
        if d - 3 < 0:
            raise ValueError
        tgt = self.I(d - 3)
        m = len(self.M(d - 3)); n = 3 * len(src)
        D = [[0] * n for _ in range(m)]
        for i in range(3):
            for k, mo in enumerate(src):
                if mo[i] > 0:
                    t = list(mo); t[i] -= 1
                    D[tgt[tuple(t)]][i * len(src) + k] = mo[i] % p
        return D

    def solve_all(self, T, extra_cols=None, randomize=True):
        """For each unit vector e_k (k over rows of T) return a solution x of T x = e_k, free variables random.
        Returns list of solution vectors (as columns: sol[k] is a list of length n). Asserts T surjective."""
        p = self.p
        m = len(T); n = len(T[0])
        A = [T[r][:] + [1 if r == c else 0 for c in range(m)] for r in range(m)]
        piv = []
        row = 0
        for col in range(n):
            pr_ = None
            for r in range(row, m):
                if A[r][col]:
                    pr_ = r; break
            if pr_ is None:
                continue
            A[row], A[pr_] = A[pr_], A[row]
            inv = pow(A[row][col], p - 2, p)
            A[row] = [(v * inv) % p for v in A[row]]
            for r in range(m):
                if r != row and A[r][col]:
                    f = A[r][col]
                    Ar = A[r]; Aw = A[row]
                    A[r] = [(a - f * b) % p for a, b in zip(Ar, Aw)]
            piv.append(col)
            row += 1
            if row == m:
                break
        assert row == m, "map not surjective: rank %d < %d" % (row, m)
        pivset = set(piv)
        free = [c for c in range(n) if c not in pivset]
        sols = []
        for k in range(m):
            x = [0] * n
            fv = {c: (self.rng.randrange(p) if randomize else 0) for c in free}
            for c in free:
                x[c] = fv[c]
            for r, pc in enumerate(piv):
                s = A[r][n + k]
                Ar = A[r]
                for c in free:
                    if Ar[c] and fv[c]:
                        s -= Ar[c] * fv[c]
                x[pc] = s % p
            sols.append(x)
        return sols

    def functionals(self, d, randomize=True, tag=0):
        """return (pi, dv): lists indexed by monomials of degree d"""
        key = (d, randomize, tag)
        if key in self.cache:
            return self.cache[key]
        p = self.p
        if d == 0:
            res = ([0], [1])
        elif d == 3:
            # S = c0 * p0p1p2 + sum A_i dh_i, A_i linear: unique
            T = self.Tmat(3)             # 10 x 9
            m = len(T)
            col0 = [0] * m
            col0[self.I(3)[(1, 1, 1)]] = 1
            T2 = [[col0[r]] + T[r] for r in range(m)]   # 10 x 10, unknowns (c0, A)
            sols = self.solve_all(T2, randomize=False)
            D = self.Divmat(3)           # 1 x 9
            pi = []; dv = []
            for k in range(m):
                x = sols[k]
                pi.append(x[0] % p)
                dv.append(sum(D[0][c] * x[1 + c] for c in range(9)) % p)
            res = (pi, dv)
        else:
            assert d % 3 == 0 and d >= 6
            T = self.Tmat(d)
            sols = self.solve_all(T, randomize=randomize)
            D = self.Divmat(d)
            pi_l, dv_l = self.functionals(d - 3, randomize, tag)
            ml = len(pi_l)
            n = len(T[0])
            # functional on source: w = pi_l . D ,  v = dv_l . D
            w = [0] * n; v = [0] * n
            for r in range(ml):
                Dr = D[r]
                a = pi_l[r]; b = dv_l[r]
                if a or b:
                    for c in range(n):
                        if Dr[c]:
                            w[c] = (w[c] + a * Dr[c]) % p
                            v[c] = (v[c] + b * Dr[c]) % p
            pi = []; dv = []
            for k in range(len(T)):
                x = sols[k]
                pi.append(sum(a * b for a, b in zip(w, x)) % p)
                dv.append(sum(a * b for a, b in zip(v, x)) % p)
            res = (pi, dv)
        self.cache[key] = res
        return res

def pmul(f, g, p):
    r = {}
    for e1, c1 in f.items():
        for e2, c2 in g.items():
            e = tuple(a + b for a, b in zip(e1, e2))
            r[e] = (r.get(e, 0) + c1 * c2) % p
    return {e: c for e, c in r.items() if c}

def ppow_list(f, n, p):
    out = [{(0,) * len(next(iter(f))): 1}]
    for _ in range(n):
        out.append(pmul(out[-1], f, p))
    return out

def multinom(al):
    n = sum(al)
    return factorial(n) // (factorial(al[0]) * factorial(al[1]) * factorial(al[2]))

def apply_fun(fun, idx, poly, p):
    return sum(fun[idx[e]] * c for e, c in poly.items()) % p

def bracket_Bn(ctx, b, n, withP=False, tag=0, randomize=True):
    """<< P^eps * B^n >> with B = sum b_ij p_i q_j ; uses B^n = sum_alpha multinom(alpha) p^alpha L^alpha(q)."""
    p = ctx.p
    L = []
    for i in range(3):
        d = {}
        for j in range(3):
            e = [0, 0, 0]; e[j] = 1
            if b[i][j] % p:
                d[tuple(e)] = b[i][j] % p
        L.append(d if d else {(0, 0, 0): 0})
    pw = [ppow_list(L[i], n, p) for i in range(3)]
    dp = n + (3 if withP else 0)
    pi_p, dv_p = ctx.functionals(dp, randomize, tag)
    pi_q, dv_q = ctx.functionals(n, randomize, tag)
    idx_p = ctx.I(dp); idx_q = ctx.I(n)
    tot = 0
    for al in ctx.M(n):
        La = pmul(pmul(pw[0][al[0]], pw[1][al[1]], p), pw[2][al[2]], p)
        piL = apply_fun(pi_q, idx_q, La, p)
        dvL = apply_fun(dv_q, idx_q, La, p)
        e = (al[0] + 1, al[1] + 1, al[2] + 1) if withP else al
        tot += multinom(al) * (dv_p[idx_p[e]] * piL - pi_p[idx_p[e]] * dvL)
    return tot % p

def bracket_bruteforce(ctx, b, n, withP=False):
    """independent route: expand P^eps*B^n as polynomial in 6 variables, then apply <<,>> monomial by monomial"""
    p = ctx.p
    B = {}
    for i in range(3):
        for j in range(3):
            e = [0] * 6; e[i] = 1; e[3 + j] = 1
            if b[i][j] % p:
                B[tuple(e)] = b[i][j] % p
    G = {(0,) * 6: 1}
    for _ in range(n):
        G = pmul(G, B, p)
    if withP:
        G = pmul(G, {(1, 1, 1, 0, 0, 0): 1}, p)
    dp = n + (3 if withP else 0)
    pi_p, dv_p = ctx.functionals(dp)
    pi_q, dv_q = ctx.functionals(n)
    idx_p = ctx.I(dp); idx_q = ctx.I(n)
    tot = 0
    for e, c in G.items():
        a = idx_p[e[:3]]; bb = idx_q[e[3:]]
        tot += c * (dv_p[a] * pi_q[bb] - pi_p[a] * dv_q[bb])
    return tot % p

def hc(v, lam, p):
    return (v[0] ** 3 + v[1] ** 3 + v[2] ** 3 + 3 * lam * v[0] * v[1] * v[2]) % p

def det3(m, p):
    return (m[0][0] * (m[1][1] * m[2][2] - m[1][2] * m[2][1])
            - m[0][1] * (m[1][0] * m[2][2] - m[1][2] * m[2][0])
            + m[0][2] * (m[1][0] * m[2][1] - m[1][1] * m[2][0])) % p

def sgn(v, p):
    return v if v <= p // 2 else v - p

def run(pr, seed):
    rng = random.Random(seed)
    while True:
        lam = rng.randrange(1, pr)
        if (1 + lam ** 3) % pr:
            break
    ctx = Ctx(pr, lam, rng)
    print("=== prime %d seed %d lam %d" % (pr, seed, lam))
    # --- sanity checks of red ---
    pi3, dv3 = ctx.functionals(3)
    i3 = ctx.I(3)
    third = pow(3, pr - 2, pr)
    ok3 = True
    for mo in ctx.M(3):
        exp_pi = (-lam) % pr if max(mo) == 3 else (1 if mo == (1, 1, 1) else 0)
        exp_dv = third if max(mo) == 3 else 0
        if pi3[i3[mo]] != exp_pi or dv3[i3[mo]] != exp_dv:
            ok3 = False
    print("sanity: cubic table pi(p_i^3)=-lam, dv(p_i^3)=1/3, pi(P)=1, dv(P)=0, others 0 :", ok3)
    # choice independence: two different random choices of the A_i at each step
    for d in (6, 9, 12, 15):
        f1 = ctx.functionals(d, True, 1)
        f2 = ctx.functionals(d, True, 2)
        f0 = ctx.functionals(d, False, 0)
        print("sanity: degree %d functionals independent of the choice of A_i (random vs random vs zero free vars): %s"
              % (d, f1 == f2 == f0))
    # rule gamma(A dh_i) = gamma(dA/dp_i): test on random A of degree d-2
    for d in (6, 9, 12):
        pi_d, dv_d = ctx.functionals(d)
        pi_l, dv_l = ctx.functionals(d - 3)
        okr = True
        for i in range(3):
            A = {mo: rng.randrange(pr) for mo in ctx.M(d - 2)}
            S = pmul(A, ctx.dh(i), pr)
            dA = {}
            for mo, c in A.items():
                if mo[i]:
                    t = list(mo); t[i] -= 1
                    dA[tuple(t)] = (dA.get(tuple(t), 0) + c * mo[i]) % pr
            if apply_fun(pi_d, ctx.I(d), S, pr) != apply_fun(pi_l, ctx.I(d - 3), dA, pr): okr = False
            if apply_fun(dv_d, ctx.I(d), S, pr) != apply_fun(dv_l, ctx.I(d - 3), dA, pr): okr = False
        print("sanity: red(A*dh_i) == red(dA/dp_i) for random A, degree %d: %s" % (d, okr))

    inv27 = pow(27 * (1 + lam ** 3) % pr, pr - 2, pr)
    # --- (i),(ii): rank-one b ---
    for inst in range(2):
        u = [rng.randrange(1, pr) for _ in range(3)]
        x = [rng.randrange(1, pr) for _ in range(3)]
        b = [[u[(i + j) % 3] * x[(i - j) % 3] % pr for j in range(3)] for i in range(3)]
        bp = [[0] * 3 for _ in range(3)]
        for i in range(3):
            for j in range(3):
                bp[(i + j) % 3][(i - j) % 3] = b[i][j]
        print("-- rank-one instance %d: u=%s x=%s ; det(b')=%d ; det(b)=%d" % (inst, u, x, det3(bp, pr), det3(b, pr)))
        Ns = [bracket_Bn(ctx, b, 3 * m) for m in range(1, 6)]
        print("(i)  N_1..N_5 =", Ns, " -> all zero:", all(v == 0 for v in Ns))
        if inst == 0:
            print("     cross-check brute-force expansion: N_1 =", bracket_bruteforce(ctx, b, 3), " N_2 =", bracket_bruteforce(ctx, b, 6))
        c = hc(x, lam, pr) * hc(u, lam, pr) * inv27 % pr
        res = []
        for m in range(0, 5):
            br = bracket_Bn(ctx, b, 3 * m, withP=True)
            Pm = ((-1) ** m * br * pow(factorial(3 * m), pr - 2, pr)) % pr
            pred = (-pow(-c % pr, m, pr) * pow(factorial(m), pr - 2, pr)) % pr
            res.append((m, Pm, pred, Pm == pred))
        print("(ii) c = %d ; (m, Pm, -(-c)^m/m!, equal):" % c, res)
        if inst == 0:
            print("     cross-check brute-force: <<P B^3>> =", bracket_bruteforce(ctx, b, 3, True), " vs ", bracket_Bn(ctx, b, 3, True),
                  " ; <<P B^6>> =", bracket_bruteforce(ctx, b, 6, True), " vs ", bracket_Bn(ctx, b, 6, True))
        # controls for (ii): wrong sign / wrong constant
        alt = [("c -> -c", (-c) % pr), ("c -> 2c", 2 * c % pr), ("c without 1/(27(1+lam^3))", hc(x, lam, pr) * hc(u, lam, pr) % pr)]
        for name, c2 in alt:
            okalt = all(((-pow(-c2 % pr, m, pr) * pow(factorial(m), pr - 2, pr)) % pr) == res[m][1] for m in range(5))
            print("     control (%s) would also fit: %s" % (name, okalt))
    # --- (iii): full-rank control ---
    ratios = []
    for inst in range(4):
        b = [[rng.randrange(pr) for _ in range(3)] for _ in range(3)]
        bp = [[0] * 3 for _ in range(3)]
        for i in range(3):
            for j in range(3):
                bp[(i + j) % 3][(i - j) % 3] = b[i][j]
        N1 = bracket_Bn(ctx, b, 3)
        N2 = bracket_Bn(ctx, b, 6)
        d = det3(bp, pr)
        db = det3(b, pr)
        ratio = N1 * pow(d, pr - 2, pr) % pr if d else None
        ratios.append(ratio)
        print("(iii) random b inst %d: N_1=%d det(b')=%d ratio N_1/det(b')=%s (signed %s) ; N_1/det(b)=%s ; N_2=%d"
              % (inst, N1, d, ratio, sgn(ratio, pr) if ratio is not None else None,
                 (N1 * pow(db, pr - 2, pr) % pr) if db else None, N2))
    print("(iii) ratio constant over instances:", len(set(ratios)) == 1, " value (signed):", sgn(ratios[0], pr),
          " ; compare candidates: -6/(1+lam^3)... ", {
              "1": 1, "lam": lam, "1+lam^3": (1 + lam ** 3) % pr,
              "ratio*(1+lam^3)": sgn(ratios[0] * (1 + lam ** 3) % pr, pr),
              "ratio*27*(1+lam^3)": sgn(ratios[0] * 27 * (1 + lam ** 3) % pr, pr),
              "ratio/lam": sgn(ratios[0] * pow(lam, pr - 2, pr) % pr, pr)})

if __name__ == "__main__":
    pr = int(sys.argv[1]); seed = int(sys.argv[2])
    run(pr, seed)
