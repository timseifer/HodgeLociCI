# Multi-parameter nonlinear correction at the first obstructed order (slices 10/12), exact mod p.
# Re-uses the setup of step5_hensel.py (same F1 = v0 + b for the same arguments).
# Unknowns: K_2 = sum s_i d_i, K_3 = sum r_i e_i, K_4 = sum q_i f_i (random kernel directions).
# The cokernel coordinates of the orders 2..n are polynomials in (s,r,q) of weighted degree <= n
# (weights 2,3,4); they are interpolated exactly and the system is written for Macaulay2.
# usage: python3 step8_multiparam.py p lam N slice btype seed n m2 m3 m4
import sys, time, json, os, itertools
args = sys.argv[1:]
n_target, m2, m3, m4 = int(args[6]), int(args[7]), int(args[8]), int(args[9])
sys.argv = [sys.argv[0]] + args[:6]
src = open('/home/claude/hodge/discovery/checks/bc_t6/step5_hensel.py').read().split("K = {}\nlog = []")[0]
exec(src)
n = n_target
Kbase = {}
arcfile = os.environ.get("BASEARC")
if arcfile:
    lines_ = open(arcfile).read().strip().split("\n")[1:]
    FsA = [Poly(p, [enc(b_) for b_, c_ in json.loads(l.split(": ", 1)[1])], [c_ for b_, c_ in json.loads(l.split(": ", 1)[1])]).norm() for l in lines_]
    FsB = [F1]
    for k in range(2, len(FsA) + 1):
        E_ = expE(FsB + [Poly(p)], p, k); Fv_, c_ = split(St.phi(E_[k]))
        Kbase[k] = (St.Wvec(FsA[k - 1]) - Fv_) % p
        FsB.append(FsA[k - 1])
    print("base arc loaded:", arcfile, "length", len(FsA), flush=True)
_build0 = build
def build(Kx, nn):
    K_ = dict(Kbase)
    for j, w in Kx.items(): K_[j] = (K_.get(j, np.zeros(nW, np.int64)) + w) % p
    return _build0(K_, nn)
Fs0, cs0 = build({}, n)
bad = [k for k in range(2, n + 1) if cs0[k].any()]
print("orders with nonzero coker before correction:", bad, flush=True)
rng2 = np.random.default_rng(1000 + seed)
D2 = mm(rng2.integers(0, p, size=(m2, len(Ker))), Ker, p)
D3 = mm(rng2.integers(0, p, size=(m3, len(Ker))), Ker, p)
D4 = mm(rng2.integers(0, p, size=(m4, len(Ker))), Ker, p) if m4 else np.zeros((0, nW), np.int64)
names = [f"s{i}" for i in range(m2)] + [f"r{i}" for i in range(m3)] + [f"q{i}" for i in range(m4)]
wts = [2] * m2 + [3] * m3 + [4] * m4
M = len(names)
# allowed monomials: weighted degree contribution w(mono) + (#v factors >= 0)  <= n ; keep degree <= floor(n/2)
mons = [()]
for i in range(M): mons.append((i,))
for i in range(M):
    for j in range(i, M):
        if wts[i] + wts[j] <= n: mons.append((i, j))
if n >= 6:
    for i in range(M):
        for j in range(i, M):
            for k in range(j, M):
                if wts[i] + wts[j] + wts[k] <= n: mons.append((i, j, k))
print(f"params {M} (m2={m2}, m3={m3}, m4={m4}); monomials to interpolate: {len(mons)}", flush=True)
def evalpt(x):
    K2 = {2: mm(x[None, :m2], D2, p)[0], 3: mm(x[None, m2:m2 + m3], D3, p)[0]}
    if m4: K2[4] = mm(x[None, m2 + m3:], D4, p)[0]
    _, cs = build(K2, n)
    return np.concatenate([cs[k] for k in range(2, n + 1)])
pts = rng2.integers(0, p, size=(len(mons) + 3, M))
t1 = time.time()
vals = []
for i, x in enumerate(pts):
    vals.append(evalpt(x))
    if i == 2: print(f"  ~{(time.time()-t1)/3:.1f}s per evaluation", flush=True)
vals = np.array(vals, np.int64)
def monval(x, mo):
    r = 1
    for i in mo: r = r * int(x[i]) % p
    return r
V = np.array([[monval(x, mo) for mo in mons] for x in pts], np.int64)
nm = len(mons)
# solve V[:nm] C = vals[:nm]; check on the extra points
Rv, pv = rref(np.c_[V[:nm], np.eye(nm, dtype=np.int64)], p)
assert len(pv) == nm and pv[-1] == nm - 1, "Vandermonde singular"
Vinv = Rv[:, nm:]
C = mm(Vinv, vals[:nm], p)
chk = (mm(V[nm:], C, p) - vals[nm:]) % p
print("interpolation check on extra points:", "OK" if not chk.any() else "FAILED (degree bound wrong)", flush=True)
ncoord = C.shape[1]
nzcols = [c for c in range(ncoord) if C[:, c].any()]
print("nonzero coker-coordinate polynomials:", len(nzcols), "of", ncoord, flush=True)
# write M2 input
fn = f'/home/claude/hodge/discovery/checks/bc_t6/mp_{p}_{lam}_{sl}_{btype}_{seed}_n{n}.m2'
with open(fn, 'w') as fh:
    fh.write(f"kk = ZZ/{p};\nR = kk[{','.join(names)}];\n")
    polys = []
    for c in nzcols:
        terms = []
        for mo, co in zip(mons, C[:, c]):
            if co:
                terms.append(f"({int(co)})" + "".join(f"*{names[i]}" for i in mo))
        polys.append("+".join(terms))
    fh.write("I = ideal(" + ",\n".join(polys) + ");\n")
    fh.write('print("codim/dim of solution set over the algebraic closure of F_p:"); g = gens gb I; print(numgens source g); print(dim I); if dim I >= 0 then print(degree I);\n')
np.save(fn.replace('.m2', '_C.npy'), C)
json.dump({"mons": mons, "m2": m2, "m3": m3, "m4": m4, "nzcols": nzcols}, open(fn.replace('.m2', '.json'), 'w'))
print("wrote", fn, f"({time.time()-t0:.0f}s)", flush=True)
