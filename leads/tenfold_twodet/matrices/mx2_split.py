"""mx2: from the exact period series of the transported class [P1] - [P2] along T2's arc (periods_deg4.txt, orders
0..9) to numbers at a fixed eps: the catalecticant Cat(2,2), its kernel Q (18 quadrics), the linear syzygies, the
algebra of endomorphisms of Q respecting them, the two nets, and the two cubics G_A, G_B.     NUMERICAL.
usage (repository root): python3 leads/tenfold_twodet/matrices/mx2_split.py eps [outfile.npz]"""
import sys, itertools, numpy as np
from fractions import Fraction
sys.path.insert(0, "leads/tenfold_twodet/matrices")
from mx_common import *
np.set_printoptions(linewidth=200, precision=3, suppress=False)
eps = float(sys.argv[1])
def load_periods(path="leads/tenfold_twodet/matrices/periods_deg4.txt"):
    per = {}
    for line in open(path):
        if line.startswith("#"): continue
        parts = line.strip().rstrip(";").split(";")
        ex = tuple(int(t) for t in parts[0].strip().strip("{}").split(","))
        vals = []
        for p in parts[1:]:
            a, b = p.split()
            vals.append(float(Fraction(a)) + float(Fraction(b)) * ZETA)
        per[ex] = np.array(vals)
    return per
per = load_periods()
powers = eps ** np.arange(10)
lam = {ex: np.dot(v, powers) for ex, v in per.items()}            # class functional on quartic monomials at this eps
quad = [tuple(sorted(c)) for c in itertools.combinations_with_replacement(range(8), 2)]       # 36
cub = [tuple(sorted(c)) for c in itertools.combinations_with_replacement(range(8), 3)]        # 120
cidx = {c: i for i, c in enumerate(cub)}
def expo(idx):
    e = [0] * 8
    for i in idx: e[i] += 1
    return tuple(e)
Cat = np.array([[lam[expo(a + b)] for b in quad] for a in quad])
U, sv, Vh = np.linalg.svd(Cat)
print(f"eps = {eps}: singular values of Cat(2,2): largest 12: {sv[0]:.2e} .. {sv[11]:.2e} ; next 6: {sv[12]:.2e} .. {sv[17]:.2e} ; last 18: {sv[18]:.2e} .. {sv[35]:.2e}")
Q = Vh[18:].conj()                                                 # rows: 18 quadrics (coefficient vectors on the 36 monomials)
# check: the partial derivatives of F_eps lie in the kernel
arc = parse_arc(); F = cubic_terms(eps, arc)
def dF(v):
    q = np.zeros(36, dtype=complex)
    for idx, c in F.items():
        for pos in range(3):
            if idx[pos] == v:
                rest = tuple(sorted(idx[:pos] + idx[pos + 1:]))
                q[quad.index(rest)] += c
    return q
PD = np.array([dF(v) for v in range(8)])
print("   distance of the 8 partial derivatives from the kernel (relative):", f"{np.linalg.norm(PD - (PD @ Q.conj().T) @ Q) / np.linalg.norm(PD):.1e}")
# multiplication Q (x) S_1 -> S_3
def mult_matrix(Qrows):
    n = Qrows.shape[0]
    M = np.zeros((120, n * 8), dtype=complex)
    for a in range(n):
        for qi, qm in enumerate(quad):
            c = Qrows[a, qi]
            if c == 0: continue
            for v in range(8):
                M[cidx[tuple(sorted(qm + (v,)))], a * 8 + v] += c
    return M
M = mult_matrix(Q)
s3 = np.linalg.svd(M, compute_uv=False)
print(f"   Q (x) S_1 -> S_3: singular values 110..114: {s3[109]:.2e} {s3[110]:.2e} {s3[111]:.2e} | {s3[112]:.2e} {s3[113]:.2e} ; smallest {s3[-1]:.2e}  (rank 112 expected: 32 syzygies)")
_, _, Vs = np.linalg.svd(M)
Syz = Vs[112:].conj()                                              # 32 x 144
# endomorphisms phi of Q (18 x 18) with (phi (x) 1) Syz inside Syz:  M * (phi (x) 1) * syz = 0 for every syzygy
rows = []
for sidx in range(Syz.shape[0]):
    Smat = Syz[sidx].reshape(18, 8)                                # coefficient of q_a y_v
    # (phi (x) 1) s has coefficients sum_a phi[b,a] Smat[a,v];  M applied: sum_{b,v} M[:, b*8+v] * that
    blk = np.zeros((120, 18, 18), dtype=complex)
    for b in range(18):
        Mb = M[:, b * 8:(b + 1) * 8]                               # 120 x 8
        blk[:, b, :] = Mb @ Smat.T                                 # 120 x 18 (index a)
    rows.append(blk.reshape(120, 324))
Emat = np.vstack(rows)
se = np.linalg.svd(Emat, compute_uv=False)
print(f"   endomorphism equations: smallest singular values: {se[-4]:.2e} {se[-3]:.2e} | {se[-2]:.2e} {se[-1]:.2e}  (kernel of dimension 2 expected)")
_, _, Ve = np.linalg.svd(Emat)
ker = Ve[-2:].conj().reshape(2, 18, 18)
phi = ker[0] - np.trace(ker[0]) / 18 * np.eye(18)
if np.linalg.norm(phi) < 1e-6 * np.linalg.norm(ker[0]): phi = ker[1] - np.trace(ker[1]) / 18 * np.eye(18)
ev, W = np.linalg.eig(phi)
order = np.argsort(ev.real * 1.0 + ev.imag * 1e-3)
ev = ev[order]; W = W[:, order]
print("   eigenvalues of the trace-free generator (sorted):", np.array2string(ev, precision=3))
# split by the two clusters
c0 = ev[:9].mean(); c1 = ev[9:].mean()
print(f"   two clusters: spread {np.abs(ev[:9] - c0).max():.1e} and {np.abs(ev[9:] - c1).max():.1e} around {c0:.3f} and {c1:.3f} ; condition number of the eigenvector matrix: {np.linalg.cond(W):.1e}")
IA = (W[:, :9].T @ Q); IB = (W[:, 9:].T @ Q)                       # 9 quadrics each (rows)
MA = mult_matrix(IA); MB = mult_matrix(IB)
print(f"   ranks of I_A (x) S_1, I_B (x) S_1 (56 expected): {np.linalg.matrix_rank(MA, tol=1e-8 * np.linalg.norm(MA))}, {np.linalg.matrix_rank(MB, tol=1e-8 * np.linalg.norm(MB))}")
Fv = np.zeros(120, dtype=complex)
for idx, c in F.items(): Fv[cidx[idx]] = c
sol, resid, rk, _ = np.linalg.lstsq(np.hstack([MA, MB]), Fv, rcond=1e-10)
GA = MA @ sol[:72]; GB = MB @ sol[72:]
print(f"   F = G_A + G_B: residual {np.linalg.norm(GA + GB - Fv):.1e} ; norms |G_A| = {np.linalg.norm(GA):.3e}, |G_B| = {np.linalg.norm(GB):.3e}, |G_A + G_B| = {np.linalg.norm(Fv):.2f} ; |G_A| eps^6 = {np.linalg.norm(GA) * eps**6:.3e}")
if len(sys.argv) > 2:
    np.savez(sys.argv[2], eps=eps, Q=Q, IA=IA, IB=IB, GA=GA, GB=GB, Fv=Fv)
