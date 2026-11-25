#!/usr/bin/env python3
# [TS-T6] (AI-generated, unreviewed): formal arcs of NL([P1] + lambda [P2]) at the Thom-Sebastiani point
# F = Fermat4(x0..x5) + G(x6..x11), G = f^T M0 h (Gseed 0: Fermat, i.e. F = Fermat tenfold; Gseed >= 1: integer random M0),
# along generic rank-1 directions v = c0 + bOf(a x l or l x a), c0 uniform in T Cone_T. MOD p.
# Arc logic, analysis and log lines from the first 'Ts = [v]' line on: VERBATIM copy of jobs/cloud-job-1/hodge_job.py (PK),
# which is W3's gen_dirs.py / SP-T6 run_job logic. Only the engine (tseng.TSEngine) and the direction setup differ.
#   python3 tsjob.py --lam -1 --p 67108837 --gseed 1 --seed 1 --kind al --N 6 --threads 2 --out runs
import sys, os, time, json, argparse, hashlib, resource, numpy as np
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
sys.path.insert(0, HERE); from enginedir import ENGINE_DIR; sys.path.insert(0, ENGINE_DIR)
from w3eng import W3Engine
from tseng import TSEngine
from split import psi_tables
from tssetup import Geometry

ap = argparse.ArgumentParser()
ap.add_argument('--lam', required=True, help='integer or r/s'); ap.add_argument('--p', type=int, required=True)
ap.add_argument('--z', type=int, default=0, help='0: first root of z^2 - z + 1 from primes.json')
ap.add_argument('--gseed', type=int, required=True)
ap.add_argument('--seed', type=int, required=True); ap.add_argument('--kind', choices=['al', 'la'], required=True)
ap.add_argument('--N', type=int, required=True)
ap.add_argument('--threads', type=int, default=os.cpu_count())
ap.add_argument('--out', default=os.path.join(HERE, 'runs'))
ap.add_argument('--tables', default=os.path.join(HERE, 'tables'))
ap.add_argument('--tag', default=None)
ap.add_argument('--mc', default=None, help='Fermat only: inputs/mc_<p>_lam<lam>.json -> T Cone_T basis exactly as hodge_job.py (reproduces W3 directions)')
ap.add_argument('--vjson', default=None, help='use this direction v (JSON {"v": [...]}) instead of generating one')
ap.add_argument('--geometry-only', action='store_true')
ap.add_argument('--force-analysis-at', type=int, default=0)
A = ap.parse_args(); N = A.N; p = A.p; seed = A.seed; kind = A.kind
if '/' in A.lam: r_, s_ = A.lam.split('/'); lam = int(r_) * pow(int(s_), p - 2, p) % p; lamtxt = A.lam.replace('/', 'o')
else: lam = int(A.lam) % p; lamtxt = A.lam
os.makedirs(A.out, exist_ok=True); os.makedirs(A.tables, exist_ok=True)
tag = A.tag or "ts_g%d_lam%s_%d_s%d_%s_N%d" % (A.gseed, lamtxt, p, seed, kind, N)
t00 = time.time()
def say(*a): print(*a, "(%.0fs)" % (time.time() - t00), flush=True)
PR = json.load(open(os.path.join(HERE, 'primes.json')))['roots_of_z2_minus_z_plus_1']
zp = A.z if A.z else PR[str(p)][0]
Dmax = max(15, 3 * N + 3)
tf = os.path.join(A.tables, 'psiB_g%d_%d_z%d_D%d.npz' % (A.gseed, p, zp, Dmax))
if os.path.exists(tf):
    Z = np.load(tf); PB1, PB2, OFF = Z['PB1'], Z['PB2'], Z['OFF']; say("Psi_B tables loaded", tf)
else:
    Tt, tabs, Y, data = psi_tables(p, zp, A.gseed, Dmax, log=say)
    PB1, PB2, OFF = tabs[0], tabs[1], Tt.OFF
    np.savez(tf, PB1=PB1, PB2=PB2, OFF=OFF); say("Psi_B tables built and saved", tf)
def engine_version():
    h = hashlib.sha256()
    for f in ('tsk.cpp', 'tseng.py', 'psib.py', 'split.py', 'tssetup.py', 'tsjob.py'):
        h.update(open(os.path.join(HERE, f), 'rb').read())
    return h.hexdigest()[:12]
W = TSEngine(p, lam, zp, PB1, PB2, OFF, Dmax, nthreads=A.threads)
WP1 = TSEngine(p, 0, zp, PB1, PB2, OFF, Dmax, weights=(1, 0))
WP2 = TSEngine(p, 0, zp, PB1, PB2, OFF, Dmax, weights=(0, 1))
SL = W.solveL_matrix(); kerL = W.kerL; Kl = W.Kl; nk = kerL.shape[1]
GE = Geometry(p, zp, A.gseed, W, WP1, WP2, log=say)
say("GEOMETRY J(F)_3 inside T Cone: %s; codim T Cone in S_3: %d" % (GE.J3_in_TCone, GE.codimTCone_S3))
if A.mc:
    MC = json.load(open(A.mc)); assert MC['z'] == zp
    Mc = np.array(MC['Mc'], np.int64) % p
    TCb = W.kernel(Mc)
    say("Mc given: span(ker Mc) = my T Cone_T:", W.rank(np.concatenate([TCb, GE.TCT], 1)) == W.rank(TCb) == W.rank(GE.TCT))
else:
    TCb = GE.TCT
# second order on ker L (NF-T6 B1a): K.c_2 for T_1 = random v in ker L (generic, not only Sigma1)
r2nd = np.random.default_rng(424242)
sil = []
for t in range(3):
    vv = kerL @ r2nd.integers(0, p, nk) % p
    E1, acc1, _ = W.Eprime(1, [W.vec_to_poly(vv)], [W.poly_one()], store=False)
    c2 = W.MH_from_acc(acc1) @ vv % p * pow(2, p - 2, p) % p
    sil.append(bool((Kl @ c2 % p).any()))
say("SECOND ORDER: K.c_2 nonzero for random v in ker L (3 samples):", sil)
if A.geometry_only: sys.exit(0)
say("p", p, "z", zp, "lam", A.lam, "gseed", A.gseed, "seed", seed, "kind", kind, "rank L", W.Lrank, "dim T Cone_T", TCb.shape[1], "T Cone_T in ker L:", not (W.L @ TCb % p).any())
rng = np.random.default_rng(seed)
def bOf(M): return GE.bOf(M)
a = rng.integers(1, p, 3); l = rng.integers(0, p, (3, 3))
if kind == 'al': M = [[{u: int(a[i] * l[j, k] % p) for k, u in enumerate((1, 3, 5))} for j in range(3)] for i in range(3)]
else: M = [[{u: int(a[j] * l[i, k] % p) for k, u in enumerate((1, 3, 5))} for j in range(3)] for i in range(3)]
c0 = TCb @ rng.integers(0, p, TCb.shape[1]) % p
v = (c0 + bOf(M)) % p
if A.vjson:
    v = np.array(json.load(open(A.vjson))['v'], np.int64) % p; say("direction v read from", A.vjson)
say("v: nnz", int(np.count_nonzero(v)), " L v = 0:", not (W.L @ v % p).any(), " v not in T Cone_T:", W.rank(np.concatenate([GE.TCT, v[:, None]], 1)) > W.rank(GE.TCT),
    " L_P1 v != 0 (not in T V_Z):", bool((WP1.L @ v % p).any()), " nnz of c0 in x-variables:", int(sum(1 for i, m in enumerate(W.mons) if c0[i] and any(m[:6]))))
v_digest = hashlib.sha256(np.ascontiguousarray(v, np.int64).tobytes()).hexdigest()[:16]
Ts = [v]; Es = [W.poly_one()]; MHs = [W.L]; xs = {}
def rebuild(m0, m1, store_upto):
    global Es, MHs
    Es = Es[:m0]; MHs = MHs[:m0]
    Tp = [W.vec_to_poly(T) for T in Ts]
    for m in range(m0, m1 + 1):
        t = time.time()
        E, acc, nt = W.Eprime(m, Tp, Es, store=(m <= store_upto))
        Es.append(E if m <= store_upto else None); MHs.append(W.MH_from_acc(acc))
        say("   E'_%d: %d terms (%.0fs)" % (m, nt, time.time() - t))
def coeff(m):
    inv = pow(m, p - 2, p); c = np.zeros(221, np.int64)
    for j in range(1, m):
        c = (c + j * (MHs[m - j] @ Ts[j - 1] % p)) % p
    return c * inv % p
def lin(j, dT0, n):
    dT = {j: dT0 % p}; dc = {}
    for m in range(j + 1, n + 1):
        acc = np.zeros((221, dT0.shape[1]), np.int64)
        for i in range(j, m):
            acc = (acc + MHs[m - i] @ dT[i]) % p
        dc[m] = acc; dT[m] = SL @ acc % p
    return dc, dT
def build_all(n, store_upto):
    """exact rebuild of the arc from T_1 = v with the current xs: T_m = SL c_m + kerL x_m (m < n); returns c_2..c_n"""
    global Ts, Es, MHs
    Ts = [v]; Es = [W.poly_one()]; MHs = [W.L]; cs = {}
    for m in range(2, n + 1):
        if len(MHs) < m: rebuild(m - 1, m - 1, store_upto)
        cs[m] = coeff(m)
        if m == n: break
        T = SL @ cs[m] % p
        if m in xs: T = (T + kerL @ xs[m]) % p
        Ts.append(T)
    return cs

def mm(A, B, ch=512):
    """A @ B mod p without int64 overflow for long inner dimensions (entries < p < 2^26)"""
    out = np.zeros((A.shape[0],) + B.shape[1:], np.int64)
    for i in range(0, A.shape[1], ch):
        out = (out + A[:, i:i + ch] @ B[i:i + ch] % p) % p
    return out

def analyse(n, Kcn, DG):
    """PK: general obstruction analysis at order n (K.c_n not in Im DG4(v) with the top term x_(n-3)).
    Freedom: x_2 .. x_(n-3) (each in ker L coordinates).  Stage B (linear, with lower-order constraints): the
    first-order effects of all x_j on K.c_3 .. K.c_(n-1) must vanish (kernel Z); S = Im DG4 + (order-n effect of Z).
      K.c_n in S  -> apply the linear solution, rebuild EXACTLY from T_2 and recompute: all K.c_m = 0 (m <= n)
                     -> OBSTRUCTED_CHOICE (the obstruction came from earlier choices; arc continues with other x's);
                     otherwise OBSTRUCTED_UNRESOLVED (linearly removable but not exactly; nonlinear analysis needed).
      K.c_n not in S -> Stage C (nonlinear parts, step (e)/W3 criterion generalised): random k in Z, exact rebuild
                     with x + k; if K.c_3..K.c_(n-1) stay 0 and the non-linear part q = K.c_n(x+k) - K.c_n(x) - J_n k
                     lies in Im DG4(v): OBSTRUCTED_GENUINE (no integral arc with this tangent; MOD p, one random k,
                     same standard as W3 / RC-T6), else OBSTRUCTED_UNRESOLVED.
    At n = 6 this is exactly W3's criterion (x_2 in ker DG4 gives Lambda(ker DG4), x_3 gives Im DG4)."""
    global xs, Ts, Es, MHs
    js = list(range(2, n - 2))
    blocks = {}
    for jj in js:
        dcj, _ = lin(jj, kerL, n)
        blocks[jj] = {m: Kl @ dcj[m] % p for m in dcj}
    lower = [m for m in range(3, n)]
    zero = np.zeros((Kl.shape[0], nk), np.int64)
    Low = np.concatenate([np.concatenate([blocks[jj].get(m, zero) for jj in js], 1) for m in lower], 0)
    Jn = np.concatenate([blocks[jj][n] for jj in js], 1)
    Z = W.kernel(Low)
    S = mm(Jn, Z)
    SI = np.concatenate([DG, S], 1)
    rS = W.rank(SI); inS = W.in_span(SI, Kcn)
    say("ANALYSIS order %d: freedom x_2..x_%d (%d coords); lower-order constraints K.c_3..K.c_%d: rank %d, dim Z = %d; rank [Im DG4 | J_n Z] = %d; K.c_n in it: %s"
        % (n, n - 3, Jn.shape[1], n - 1, W.rank(Low), Z.shape[1], rS, inS))
    Es = Es[:2]; MHs = MHs[:2]     # free the stored levels before the exact rebuild (memory)
    if inS:
        y = W.solve(np.concatenate([DG, S], 1), (-Kcn) % p)
        # map back to x_j coordinates: DG part = top term x_(n-3); S part = Z combination
        xfull = mm(Z, y[DG.shape[1]:])
        top = W.solve(blocks[n - 3][n], (DG @ y[:DG.shape[1]]) % p)
        for i, jj in enumerate(js):
            xs[jj] = (xs.get(jj, np.zeros(nk, np.int64)) + xfull[i * nk:(i + 1) * nk]) % p
        xs[n - 3] = (xs.get(n - 3, np.zeros(nk, np.int64)) + top) % p
        cs2 = build_all(n, n - 2)
        bad = [m for m in range(2, n + 1) if (Kl @ cs2[m] % p).any()]
        say("ANALYSIS order %d: linear solution applied, exact recomputation: K.c_m nonzero for m <= n: %s" % (n, bad))
        if not bad: return 'OBSTRUCTED_CHOICE', 'K.c_%d removable by earlier-order corrections (exact recomputation passes)' % n
        return 'OBSTRUCTED_UNRESOLVED', 'linearly removable at order %d but exact recomputation leaves K.c at %s' % (n, bad)
    r2 = np.random.default_rng(10007 * seed + n)
    k = mm(Z, r2.integers(0, p, Z.shape[1]))
    lin_k = mm(Jn, k)
    for i, jj in enumerate(js):
        xs[jj] = (xs.get(jj, np.zeros(nk, np.int64)) + k[i * nk:(i + 1) * nk]) % p
    cs2 = build_all(n, n - 2)
    lowbad = [m for m in range(3, n) if (Kl @ cs2[m] % p).any()]
    q = (Kl @ cs2[n] - Kcn - lin_k) % p
    qin = W.in_span(DG, q)
    say("ANALYSIS order %d: random k in Z, exact rebuild: K.c_3..K.c_%d still 0: %s %s; non-linear part in Im DG4(v): %s"
        % (n, n - 1, not lowbad, lowbad, qin))
    if not lowbad and qin:
        return 'OBSTRUCTED_GENUINE', 'K.c_%d not in Im DG4 + J_n(Z); non-linear part in Im DG4 (one random k)' % n
    return 'OBSTRUCTED_UNRESOLVED', 'K.c_%d not in Im DG4 + J_n(Z) but nonlinear test inconclusive (lower %s, q in Im %s)' % (n, lowbad, qin)

hist = []; verdict = None; note = ''; reached = 3; analysis = None
Ts = [v]; Es = [W.poly_one()]; MHs = [W.L]
for n in range(4, N + 1):
    cs = {}
    for m in range(2, n + 1):
        if len(MHs) < m: rebuild(m - 1, m - 1, N - 2)
        cs[m] = coeff(m)
        if m == n: break
        if len(Ts) < m:
            T = SL @ cs[m] % p
            if m in xs: T = (T + kerL @ xs[m]) % p
            Ts.append(T)
    Kc = {m: Kl @ cs[m] % p for m in cs}
    low = [m for m in range(2, n) if Kc[m].any()]
    say("ORDER", n, ": K.c_m nonzero for m < n:", low, " K.c_n nnz", int(np.count_nonzero(Kc[n])))
    if low:
        say("RESULT order", n - 1 if low else n, "linear correction did not survive the exact recomputation (nonlinear needed)"); hist.append((low[0], 'nonlinear'))
        verdict, note = 'OBSTRUCTED_UNRESOLVED', 'top-term correction did not survive exact recomputation at order %d' % low[0]; break
    if not Kc[n].any():
        hist.append((n, 'zero')); reached = n; continue
    if n == 4:
        say("RESULT G4(v) != 0: v not in V(G4)"); hist.append((4, 'G4 != 0')); verdict, note = 'ERROR', 'G4(v) != 0 (direction not on Sigma1?)'; break
    j = n - 3
    dc, dT = lin(j, kerL, n)
    Dn = Kl @ dc[n] % p
    if n == 5:
        DG = Dn; say("   rank DG4(v) =", W.rank(DG))
    inIm = W.in_span(Dn, Kc[n])
    say("   x_%d effect rank %d, equals DG4(v): %s; K.c_n in Im DG4(v): %s" % (j, W.rank(Dn), np.array_equal(Dn, DG), inIm))
    if A.force_analysis_at == n:
        say("TEST: --force-analysis-at %d: running the obstruction analysis although K.c_n in Im DG4(v): %s" % (n, inIm))
        verdict, note = analyse(n, Kc[n], DG); verdict = 'TEST_' + verdict; analysis = verdict
        say("RESULT (TEST) order", n, verdict, note); hist.append((n, verdict)); break
    if not inIm:
        if n == 6:
            # quadratic-freedom criterion: Lambda(ker DG4(v)) via the first-order formula (x_2 -> k in ker DG4)
            kD = W.kernel(DG)                     # coordinates in ker L
            dc2, _ = lin(2, kerL @ kD % p, 6)
            Lam = Kl @ dc2[6] % p
            low2 = [m for m in (3, 4, 5) if (Kl @ dc2[m] % p).any()]
            rIL = W.rank(np.concatenate([DG, Lam], 1))
            inIL = W.in_span(np.concatenate([DG, Lam], 1), Kc[6])
            say("   dim ker DG4(v) = %d; k in ker DG4 leaves K.c3..5 unchanged to first order: %s; rank [Im DG4 | Lambda(ker)] = %d; K.c6 in it: %s"
                % (kD.shape[1], not low2, rIL, inIL))
            k = kD @ rng.integers(0, p, kD.shape[1]) % p
            save = (list(Ts), list(Es), list(MHs), dict(xs))
            xs[2] = (xs.get(2, np.zeros(nk, np.int64)) + k) % p
            Ts = Ts[:1]; Es = Es[:2]; MHs = MHs[:2]
            cs2 = {}
            for m in range(2, 7):
                if len(MHs) < m: rebuild(m - 1, m - 1, 5)
                cs2[m] = coeff(m)
                if m == 6: break
                if len(Ts) < m:
                    T = SL @ cs2[m] % p
                    if m in xs: T = (T + kerL @ xs[m]) % p
                    Ts.append(T)
            lamk = Kl @ (lin(2, (kerL @ k % p)[:, None], 6)[0][6]) % p
            Ts, Es, MHs, xs = save
            q = (Kl @ cs2[6] - Kc[6] - lamk[:, 0]) % p
            qin6 = W.in_span(DG, q); still0 = all(not (Kl @ cs2[m] % p).any() for m in (3, 4, 5))
            say("   random k: K.c3..5 still 0:", still0, "; quadratic part in Im DG4(v):", qin6)
            res = 'OBSTRUCTED at order 6 (K.c6 not in Im DG4 + Lambda(ker DG4))' if not inIL else 'order 6 removable with quadratic freedom'
            say("RESULT", res); hist.append((6, res))
            # PK: the general analysis must agree with W3's criterion
            v2, note2 = analyse(6, Kc[6], DG); analysis = v2
            w3v = 'OBSTRUCTED_GENUINE' if (not inIL and still0 and qin6) else ('OBSTRUCTED_CHOICE' if inIL else 'OBSTRUCTED_UNRESOLVED')
            say("ANALYSIS verdict %s (W3 criterion: %s) agree: %s" % (v2, w3v, v2 == w3v))
            verdict = v2 if v2 == w3v else 'OBSTRUCTED_UNRESOLVED'
            note = note2 if v2 == w3v else 'general analysis (%s) disagrees with W3 criterion (%s)' % (v2, w3v)
            break
        say("RESULT order", n, "not in Im DG4(v) (top term); stop"); hist.append((n, 'not in Im DG4'))
        verdict, note = analyse(n, Kc[n], DG); analysis = verdict
        say("ANALYSIS verdict", verdict, "-", note)
        break
    x = W.solve(Dn, (-Kc[n]) % p)
    xs[j] = (xs.get(j, np.zeros(nk, np.int64)) + x) % p
    if n == N:
        dTx = {m: dT[m] @ x % p for m in dT}; dcx = {m: dc[m] @ x % p for m in dc}
        aff = all(not (Kl @ ((cs[m] + dcx.get(m, 0)) % p) % p).any() for m in range(2, n + 1))
        say("   final order: corrected x_%d, K.c_m = 0 (m = 2..%d) by the exact affine formula (valid for n >= 7): %s" % (j, n, aff))
        hist.append((n, 'corrected x%d (affine)' % j)); reached = n
        if not aff: verdict, note = 'OBSTRUCTED_UNRESOLVED', 'affine formula check failed at the final order'
        break
    hist.append((n, 'corrected x%d' % j)); reached = n
    Ts = Ts[:j - 1]; Es = Es[:j]; MHs = MHs[:j]
if verdict is None:
    verdict = 'EXTENDS'; note = 'arc to order %d' % reached
say("HISTORY", hist)
np.save(os.path.join(A.out, "arc_%s.npy" % tag), np.array(Ts, np.int64))
arc_digest = hashlib.sha256(np.array(Ts, np.int64).tobytes()).hexdigest()[:16]
say("DIGEST arc", arc_digest)
rss = resource.getrusage(resource.RUSAGE_SELF).ru_maxrss / 2**20
say("peak RSS %.2f GB" % rss)
say("VERDICT %s order_reached %d lam %s p %d gseed %d seed %d kind %s | %s" % (verdict, reached, A.lam, p, A.gseed, seed, kind, note))
json.dump({'tag': tag, 'lambda': A.lam, 'gseed': A.gseed, 'prime': p, 'seed': seed, 'kind': kind, 'order_requested': N, 'order_reached': reached,
           'verdict': verdict, 'note': note, 'history': [list(h) for h in hist], 'runtime_s': round(time.time() - t00, 1),
           'peak_rss_gb': round(rss, 3), 'engine_version': engine_version(), 'v_digest': v_digest, 'arc_digest': arc_digest,
           'threads': A.threads}, open(os.path.join(A.out, tag + '.json'), 'w'), indent=1)
