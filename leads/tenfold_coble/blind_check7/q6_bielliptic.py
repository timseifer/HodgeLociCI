# Q6: bielliptic surface (E x F)/<(tau,sigma)> in P^8, everything MOD p (p = 3 mod 4)
import numpy as np, itertools, random, sys
def rref_null(M, p):
    """rank and nullspace (columns relation) of M mod p; returns (rank, null basis as rows)"""
    A = np.array(M, dtype=np.int64) % p
    r = 0; m, n = A.shape; piv = []
    for c in range(n):
        if r == m: break
        nz = np.nonzero(A[r:, c])[0]
        if len(nz) == 0: continue
        i = r + nz[0]
        if i != r: A[[r, i]] = A[[i, r]]
        A[r] = (A[r] * pow(int(A[r, c]), p - 2, p)) % p
        col = A[:, c].copy(); col[r] = 0
        A = (A - np.outer(col, A[r])) % p
        piv.append(c); r += 1
    free = [c for c in range(n) if c not in piv]
    null = []
    for fc in free:
        v = np.zeros(n, dtype=np.int64); v[fc] = 1
        for k, pc in enumerate(piv): v[pc] = (-A[k, fc]) % p
        null.append(v)
    return r, null
def monos(nv, d):
    return [e for e in itertools.product(range(d + 1), repeat=nv) if sum(e) == d]
def evalmat(pts, mons, p):
    P = np.array(pts, dtype=np.int64)
    out = np.ones((len(pts), len(mons)), dtype=np.int64)
    # powers
    maxd = max(max(e) for e in mons)
    pw = [np.ones_like(P)]
    for k in range(maxd): pw.append((pw[-1] * P) % p)
    for j, e in enumerate(mons):
        col = np.ones(len(pts), dtype=np.int64)
        for i, ei in enumerate(e):
            if ei: col = (col * pw[ei][:, i]) % p
        out[:, j] = col
    return out
def sing_cubics(pts, p):
    """dimension of space of cubics whose 9 partials vanish at all pts"""
    nv = len(pts[0]); m3 = monos(nv, 3); m2 = monos(nv, 2); idx2 = {e: j for j, e in enumerate(m2)}
    E2 = evalmat(pts, m2, p)
    rows = []
    for i in range(nv):
        blk = np.zeros((len(pts), len(m3)), dtype=np.int64)
        for j, e in enumerate(m3):
            if e[i] > 0:
                e2 = list(e); e2[i] -= 1
                blk[:, j] = (e[i] * E2[:, idx2[tuple(e2)]]) % p
        rows.append(blk)
    M = np.vstack(rows)
    r, null = rref_null(M, p)
    return len(m3) - r, null, m3
def sqrt_mod(a, p):
    a %= p
    if a == 0: return 0
    if pow(a, (p - 1) // 2, p) != 1: return None
    return pow(a, (p + 1) // 4, p)
def bielliptic_points(p, M, al, be, g, which, rng):
    pts = []
    while len(pts) < M:
        u = rng.randrange(1, p); s = rng.randrange(p)
        v = sqrt_mod(u**4 + al * u * u + be, p); w = sqrt_mod(s**3 + g[2] * s * s + g[1] * s + g[0], p)
        if v is None or w is None or v == 0 or w == 0: continue
        if rng.random() < .5: v = p - v
        if rng.random() < .5: w = p - w
        if which == 'L':      # invariant sections
            f = [1, u*u, u*v, s, u*u*s, u*v*s, u*w, u**3*w, v*w]
        else:                 # anti-invariant sections = sections of L + K_S
            f = [u, u**3, v, u*s, u**3*s, v*s, w, u*u*w, u*v*w]
        pts.append([x % p for x in f])
    return pts
def segre_points(p, M, rng):
    pts = []
    for _ in range(M):
        a = [rng.randrange(p) for _ in range(3)]; b = [rng.randrange(p) for _ in range(3)]
        pts.append([(x * y) % p for x in a for y in b])
    return pts
def report(name, pts, p, maxdeg=5):
    nv = 9; hf = []
    for d in range(1, maxdeg + 1):
        m = monos(nv, d)
        npts = min(len(pts), 9 * d * d + 120)
        r, null = rref_null(evalmat(pts[:npts], m, p), p)
        r2 = r
        if d <= 3:
            r2, _ = rref_null(evalmat(pts[:npts // 2 + 40], m, p), p)   # stability with fewer points
        hf.append((d, r, len(m) - r, r2))
    print(f"{name} MOD {p}: (degree, HF = rank of evaluation, dim of ideal, rank with fewer points):", hf)
    k, null, m3 = sing_cubics(pts[:260], p)
    k2, _, _ = sing_cubics(pts[:130], p)
    print(f"   cubics singular along the surface (all 9 partials vanish at 260 points / at 130 points): {k} / {k2}")
    return hf, k
if __name__ == "__main__":
    for p in (32003, 31991, 30011):
        assert p % 4 == 3
        rng = random.Random(1000 + p)
        hfS, kS = report("CONTROL Segre P2xP2 (expect HF 9,36,100,... ; 1 singular cubic = det)", segre_points(p, 900, rng), p, maxdeg=3)
        for trial in range(2):
            al, be = rng.randrange(1, p), rng.randrange(1, p); g = [rng.randrange(1, p) for _ in range(3)]
            for which in ('L', 'L+K'):
                pts = bielliptic_points(p, 420, al, be, g, which, rng)
                report(f"bielliptic [{which}] al={al} be={be} g={g}", pts, p, maxdeg=5 if trial == 0 else 3)
        sys.stdout.flush()
