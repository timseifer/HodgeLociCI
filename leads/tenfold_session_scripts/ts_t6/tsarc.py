# [TS-T6] copy of jobs/cloud-job-1/run_arc.py with the engine replaced by tseng.TSEngine at the split point G (--gseed;
# gseed 0 = Fermat tenfold, used for validation (v1)); arc logic unchanged.
# Original: Remote job (SP-T6 package of W3's hi_order.py, logic unchanged): extend EX-T6's exact lambda = -1 arc (reduced mod p)
# to order N with top-term corrections (exactly affine for n >= 7), fallback to the full linearised freedom.
# python3 run_arc.py p zidx kind N [--threads T] [--engine fast|py] [--out results]
import sys, time, pickle, numpy as np
import os, argparse, json; HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE); from enginedir import ENGINE_DIR; sys.path.insert(0, ENGINE_DIR)
from fractions import Fraction
from w3eng import W3Engine
ap = argparse.ArgumentParser(); ap.add_argument('p', type=int); ap.add_argument('zidx', type=int); ap.add_argument('kind'); ap.add_argument('N', type=int)
ap.add_argument('--engine', default='fast'); ap.add_argument('--threads', type=int, default=os.cpu_count())
ap.add_argument('--out', default=os.path.join(HERE, 'results'))
ap.add_argument('--gseed', type=int, default=0); ap.add_argument('--tables', default=os.path.join(HERE, 'tables'))
ap.add_argument('--highmem', action='store_true', help='store policy of w3/hi_order.py (default: w3/hi_order2.py, less memory)')
A = ap.parse_args(); p, zidx, kind, N = A.p, A.zidx, A.kind, A.N
os.makedirs(A.out, exist_ok=True)
t00 = time.time()
def say(*a): print(*a, "(%.0fs)" % (time.time() - t00), flush=True)
def red(s):
    x = Fraction(s); assert x.denominator % p
    return x.numerator % p * pow(x.denominator % p, p - 2, p) % p
zp = json.load(open(os.path.join(HERE, 'primes.json')))['roots_of_z2_minus_z_plus_1'][str(p)][zidx]
sys.path.insert(0, HERE)
from tseng import TSEngine
from split import psi_tables
Dmax = max(15, 3 * N + 3)
tf = os.path.join(A.tables, 'psiB_g%d_%d_z%d_D%d.npz' % (A.gseed, p, zp, Dmax))
if os.path.exists(tf): Z = np.load(tf); PB1, PB2, OFF = Z['PB1'], Z['PB2'], Z['OFF']
else:
    Tt, tabs, Y, data = psi_tables(p, zp, A.gseed, Dmax, log=say); PB1, PB2, OFF = tabs[0], tabs[1], Tt.OFF
    os.makedirs(A.tables, exist_ok=True); np.savez(tf, PB1=PB1, PB2=PB2, OFF=OFF)
W = TSEngine(p, -1, zp, PB1, PB2, OFF, Dmax, nthreads=A.threads)
SL = W.solveL_matrix(); kerL = W.kerL; Kl = W.Kl; nk = kerL.shape[1]
d = json.load(open(os.path.join(HERE, 'exarc_%s.json' % kind)))
Ts = [np.array([(red(T[i]) + red(T[220 + i]) * zp) % p for i in range(220)], np.int64) for T in d['Ts']]
c8x = np.array([(red(d['c8'][i]) + red(d['c8'][221 + i]) * zp) % p for i in range(221)], np.int64)
say("p", p, "z", zp, "kind", kind, "N", N, "rank L", W.Lrank, "dim ker L", nk)
Es = [W.poly_one()]; MHs = [W.L]

def rebuild(m0, m1, store_upto):
    """recompute E'_m and MH_m for m = m0..m1 from the current Ts (T_m included when available)"""
    global Es, MHs
    Es = Es[:m0]; MHs = MHs[:m0]
    Tp = [W.vec_to_poly(T) for T in Ts]
    for m in range(m0, m1 + 1):
        t = time.time()
        E, acc, nt = W.Eprime(m, Tp, Es, store=(m <= store_upto))
        Es.append(E if m <= store_upto else None); MHs.append(W.MH_from_acc(acc))
        say("   E'_%d: %d terms (%.0fs)%s" % (m, nt, time.time() - t, "" if m <= store_upto else " [streamed, not stored]"))

def coeffs(n):
    cs = {}
    for m in range(2, n + 1):
        inv = pow(m, p - 2, p); c = np.zeros(221, np.int64)
        for j in range(1, m):
            c = (c + j * (MHs[m - j] @ Ts[j - 1] % p)) % p
        cs[m] = c * inv % p
    return cs

def lin(j, dT0, n):
    dT = {j: dT0 % p}; dc = {}
    for m in range(j + 1, n + 1):
        acc = np.zeros((221, dT0.shape[1]), np.int64)
        for i in range(j, m):
            acc = (acc + MHs[m - i] @ dT[i]) % p
        dc[m] = acc; dT[m] = SL @ acc % p
    return dc, dT

# orders <= 8: reproduce EX-T6
rebuild(1, 7, 7)
cs = coeffs(8)
say("check vs exact arc: K.c_n nnz n=2..8:", [int(np.count_nonzero(Kl @ cs[m] % p)) for m in range(2, 9)],
    " L T_n + c_n = 0 n=2..7:", all(not ((W.L @ Ts[m - 1] + cs[m]) % p).any() for m in range(2, 8)), " c8 == exact:", np.array_equal(cs[8], c8x))
# DG4(v)
dc5, _ = lin(2, kerL, 5); DG = Kl @ dc5[5] % p; rD = W.rank(DG)
say("rank DG4(v) =", rD)
hist = []
for n in range(9, N + 1):
    # T_(n-1) = SL c_(n-1); E'_(n-1)
    Ts = Ts[:n - 2] + [SL @ cs[n - 1] % p]
    rebuild(n - 1, n - 1, N - 2 if A.highmem else n - 2)     # hi_order2: E'_(n-1) streamed (rebuilt after the correction)
    cs = coeffs(n)
    low = [m for m in range(2, n) if (Kl @ cs[m] % p).any()]
    Kc = Kl @ cs[n] % p
    say("ORDER", n, ": recomputation K.c_m = 0 for m < n:", not low, low, " K.c_n nnz", int(np.count_nonzero(Kc)))
    if low: say("ERROR lower orders nonzero"); break
    if not Kc.any():
        hist.append((n, 'zero'))
        if n < N and not A.highmem: rebuild(n - 1, n - 1, N - 2)
        continue
    j = n - 3
    dc, dT = lin(j, kerL, n)
    Dn = Kl @ dc[n] % p
    lowd = [m for m in range(j + 1, n) if (Kl @ dc[m] % p).any()]
    inIm = W.in_span(Dn, Kc)
    say("   x_%d effect: rank %d, equals DG4(v): %s, no K-effect on orders %d..%d: %s; K.c_n in Im DG4(v): %s" %
        (j, W.rank(Dn), np.array_equal(Dn, DG), j + 1, n - 1, not lowd, inIm))
    if not inIm:
        # full linearised freedom x_2..x_(n-3)
        blocks = []
        for jj in range(2, n - 2):
            dcj, _ = lin(jj, kerL, n)
            blocks.append(Kl @ dcj[n] % p)
            lowj = [m for m in range(max(5, jj + 1), n) if (Kl @ dcj[m] % p).any()]
            say("   x_%d: K-effect on lower orders >= 5: %s" % (jj, lowj))
        J = np.concatenate(blocks, 1)
        say("   rank of full order-%d linearisation (x_2..x_%d, ignoring lower-order constraints): %d; K.c_n in its span: %s"
            % (n, n - 3, W.rank(J), W.in_span(J, Kc)))
        say("RESULT order", n, "NOT removable by the top term; stop for the quadratic-freedom analysis")
        hist.append((n, 'NOT in Im DG4'))
        pickle.dump({'Ts': Ts, 'cs': cs, 'Kc': Kc}, open(os.path.join(A.out, 'obstr_%d_%d_%s_%d.pkl' % (p, zidx, kind, n)), 'wb'))
        break
    x = W.solve(Dn, (-Kc) % p)
    dTx = {m: dT[m] @ x % p for m in dT}
    dcx = {m: dc[m] @ x % p for m in dc}
    for m in range(j, n):
        Ts[m - 1] = (Ts[m - 1] + dTx[m]) % p
    cs_aff = {m: (cs[m] + dcx[m]) % p if m in dcx else cs[m] for m in cs}
    ok = [not (Kl @ cs_aff[m] % p).any() for m in range(2, n + 1)]
    lt = [not ((W.L @ Ts[m - 1] + cs_aff[m]) % p).any() for m in range(2, n)]
    say("   corrected x_%d: by the exact affine formula K.c_m = 0 (m = 2..%d): %s; L T_m + c_m = 0 (m = 2..%d): %s" % (j, n, all(ok), n - 1, all(lt)))
    hist.append((n, 'corrected x%d' % j))
    cs = cs_aff
    if n < N:
        rebuild(j, n - 1, N - 2)   # E'_(n-3) .. E'_(n-1) with the corrected T's
os.makedirs(A.out, exist_ok=True); np.save(os.path.join(A.out, 'exarc_%d_%d_%s_N%d.npy' % (p, zidx, kind, N)), np.array(Ts))
say("HISTORY", hist)
import hashlib
say("DIGEST arc", hashlib.sha256(np.array(Ts, np.int64).tobytes()).hexdigest()[:16],
    "c_n", hashlib.sha256(np.array([cs[m] for m in sorted(cs)], np.int64).tobytes()).hexdigest()[:16],
    "MH", hashlib.sha256(np.array([M for M in MHs if M is not None], np.int64).tobytes()).hexdigest()[:16])

import resource
say("peak RSS %.2f GB" % (resource.getrusage(resource.RUSAGE_SELF).ru_maxrss / 2**20))
