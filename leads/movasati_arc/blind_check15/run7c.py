"""Full linear test of q on A2 (q affine in k2 on V6, independent of ker J3, k5, k6 per run7b)."""
import sys
exec(open("/home/claude/blind_check15/run7b.py").read().split("# degree probe")[0])
k0 = point(0, 0); o_, qb = q(k0)
dirs4 = fs.rng.integers(0, p, size=(dimK, 12)); J4r, _ = jac(k0, 7, 4, 7, dirs4)
print("J4 on 12 random k4-directions: rank", rank(J4r, p), "; im inside im J3:", rank(np.hstack([J3, J4r]), p) == rank(J3, p), flush=True)
KJ = nullspace(J3, p); kq = {n: (k0[n] + (KJ @ fs.rng.integers(0, p, size=KJ.shape[1]) if n == 3 else (fs.rng.integers(0, p, size=dimK) if n in (4, 5, 6) else 0))) % p for n in k0}
oq, qq_ = q(kq)
print("random ker-J3 move of k3 + random k4,k5,k6: ob_2..6 nonzero", [int(np.count_nonzero(oq[n])) for n in range(2, 7)], "; q changed:", bool(((qq_ - qb) % p).any()), flush=True)
cols = []
for i in range(N2.shape[1]):
    k = {n: base[n].copy() for n in base}; k[2] = (base[2] + N2[:, i]) % p
    o6 = ev(k, 6)[6]; k[3] = (k[3] - Y @ o6) % p
    cols.append((q(k)[1] - qb) % p)
Lam = np.array(cols).T % p
print("Lambda (19 x %d): rank" % N2.shape[1], rank(Lam, p), "; q(base) nonzero comps", int(np.count_nonzero(qb)), "%.0fs" % (time.time()-t0), flush=True)
a1 = fs.rng.integers(0, p, size=N2.shape[1]); a2 = fs.rng.integers(0, p, size=N2.shape[1])
def qa(a):
    k = {n: base[n].copy() for n in base}; k[2] = (base[2] + N2 @ a) % p
    o6 = ev(k, 6)[6]; k[3] = (k[3] - Y @ o6) % p; return q(k)
qa1 = qa(a1)[1]; qa2 = qa(a2)[1]; qa12 = qa((a1 + a2) % p)[1]
print("affine check: q(a1)=qb+Lam a1:", not ((qa1 - qb - Lam @ a1) % p).any(), "; second difference zero:", not ((qa12 - qa1 - qa2 + qb) % p).any(), flush=True)
Jh = np.hstack([Lam, qb.reshape(-1, 1)])
if rank(Jh, p) != rank(Lam, p):
    an = nullspace(Lam.T, p); vals = an.T @ qb % p
    print("OBSTRUCTED (on V6 as parametrised): q(base) not in im Lambda; annihilators of im Lambda:", an.shape[1], "; nonzero values on q(base):", int(np.count_nonzero(vals)), flush=True)
else:
    Nn = nullspace(Jh, p); jj = int(np.flatnonzero(Nn[-1])[0]); a = Nn[:-1, jj] * pow(int(Nn[-1, jj]), p-2, p) % p
    k = {n: base[n].copy() for n in base}; k[2] = (base[2] + N2 @ a) % p
    o6 = ev(k, 6)[6]; k[3] = (k[3] - Y @ o6) % p
    o, qq = q(k); print("solution point: ob_2..6 nonzero", [int(np.count_nonzero(o[n])) for n in range(2, 7)], "q nonzero", int(np.count_nonzero(qq)), flush=True)
    dirs = fs.rng.integers(0, p, size=(dimK, 16)); J4, o7 = jac(k, 7, 4, 7, dirs)
    Jh = np.hstack([J4, o7.reshape(-1, 1)])
    if rank(Jh, p) == rank(J4, p):
        Nn = nullspace(Jh, p); jj = int(np.flatnonzero(Nn[-1])[0]); a = Nn[:-1, jj] * pow(int(Nn[-1, jj]), p-2, p) % p
        k[4] = (k[4] + dirs @ a) % p
        o, T = fs.evaluate(k, 7)
        c7 = fs.cprime(7, T, {n: fs.poly3(T[n]) for n in range(2, 7)}); T7 = (-fs.X @ c7) % p
        print("DIRECT verification of jet T_1..T_7: nonzero c_n among 45, n=1..7:", fs.direct(T, T7), flush=True)
    else: print("k4-solve not solvable")
print("total %.0fs" % (time.time()-t0))
