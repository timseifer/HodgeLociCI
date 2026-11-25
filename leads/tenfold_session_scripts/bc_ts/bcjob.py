#!/usr/bin/env python3
# [BC-TS] (AI-generated, unreviewed) blind checker: order-6 test at the split point with OWN Psi_B tables (bcpsi.py), OWN
# engine (bceng.py / bck.cpp) and OWN driver. Shared with TS-T6: the geometry (tssetup.Geometry for T Cone_T and the
# b-forms, fed with MY L / ker L) and the direction recipe (rng(seed): a, l, c0) and the documented order-6 criterion
# (W3 / hodge_job): K.c5 in Im DG4(v) -> x_2; K.c6 in Im DG4 -> EXTENDS; else Lambda(ker DG4) test + one random k
# quadratic check -> OBSTRUCTED_GENUINE / OBSTRUCTED_CHOICE / UNRESOLVED. MOD p.
import sys, os, time, json, argparse, hashlib, numpy as np
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
from bcla import rank, kernel, solve, in_span, mm
from bceng import BCEngine
TS = '/home/claude/hodge/discovery/checks/ts_t6'
ap = argparse.ArgumentParser()
ap.add_argument('--lam', required=True); ap.add_argument('--p', type=int, required=True)
ap.add_argument('--gseed', type=int, default=1); ap.add_argument('--seed', type=int, required=True)
ap.add_argument('--kind', choices=['al', 'la'], required=True); ap.add_argument('--out', default=os.path.join(HERE, 'runs'))
A = ap.parse_args(); p = A.p
if '/' in A.lam: r_, s_ = A.lam.split('/'); lam = int(r_) * pow(int(s_), p - 2, p) % p
else: lam = int(A.lam) % p
tag = "bc_g%d_lam%s_%d_s%d_%s" % (A.gseed, A.lam.replace('/', 'o'), p, A.seed, A.kind)
os.makedirs(A.out, exist_ok=True)
t00 = time.time()
def say(*a): print(*a, "(%.0fs)" % (time.time() - t00), flush=True)
z = json.load(open(os.path.join(TS, 'primes.json')))['roots_of_z2_minus_z_plus_1'][str(p)][0]
Dmax = 21
Z = np.load(os.path.join(HERE, 'psiB_bc_g%d_%d_D%d.npz' % (A.gseed, p, Dmax)))
t1 = {d: Z['Q1_%d' % d] for d in range(0, Dmax + 1, 3)}; t2 = {d: Z['Q2_%d' % d] for d in range(0, Dmax + 1, 3)}
W = BCEngine(p, lam, z, t1, t2, Dmax)
WP1 = BCEngine(p, 0, z, t1, t2, Dmax, weights=(1, 0)); WP2 = BCEngine(p, 0, z, t1, t2, Dmax, weights=(0, 1))
L, Kl, kerL, SL = W.L, W.Kl, W.kerL, W.SL; nk = kerL.shape[1]
say("own engine: rank L", W.Lrank, "dim ker L", nk, "rank L_P1", rank(WP1.L, p), "rank L_P2", rank(WP2.L, p))
sys.path.insert(0, TS)
from tssetup import Geometry          # shared geometry code (allowed): T Cone, T Cone_T = T Cone n ker L (my ker L), b-forms
GE = Geometry(p, z, A.gseed, W, WP1, WP2, log=say)
TCb = GE.TCT
rng = np.random.default_rng(A.seed)
a = rng.integers(1, p, 3); l = rng.integers(0, p, (3, 3))
if A.kind == 'al': M = [[{u: int(a[i] * l[j, k] % p) for k, u in enumerate((1, 3, 5))} for j in range(3)] for i in range(3)]
else: M = [[{u: int(a[j] * l[i, k] % p) for k, u in enumerate((1, 3, 5))} for j in range(3)] for i in range(3)]
c0 = TCb @ rng.integers(0, p, TCb.shape[1]) % p
v = (c0 + GE.bOf(M)) % p
v_digest = hashlib.sha256(np.ascontiguousarray(v, np.int64).tobytes()).hexdigest()[:16]
say("direction: nnz %d, L v = 0: %s, outside T Cone_T: %s, L_P1 v != 0: %s, digest %s" % (np.count_nonzero(v), not (L @ v % p).any(),
    rank(np.concatenate([TCb, v[:, None]], 1), p) > rank(TCb, p), bool((WP1.L @ v % p).any()), v_digest))

def arc(xs, nmax):
    """T_1 = v, T_m = SL c_m + kerL xs[m]; returns Ts, MHs (0..nmax-1), cs (2..nmax)"""
    Ts = [v]; Es = [W.one()]; MHs = [L]; cs = {}
    for m in range(2, nmax + 1):
        Tp = [W.vec_to_poly(T) for T in Ts]
        t = time.time()
        E = W.Eprime(m - 1, Tp, Es); Es.append(E if m - 1 <= nmax - 2 else None); MHs.append(W.MH(E))
        say("   E'_%d: %d terms (%.0fs)" % (m - 1, len(E[0]), time.time() - t)); del E
        inv = pow(m, p - 2, p); c = np.zeros(221, np.int64)
        for j in range(1, m): c = (c + j * (MHs[m - j] @ Ts[j - 1] % p)) % p
        cs[m] = c * inv % p
        if m == nmax: break
        T = SL @ cs[m] % p
        if m in xs: T = (T + kerL @ xs[m]) % p
        Ts.append(T)
    return Ts, MHs, cs

def lin(MHs, j, dT0, n):
    dT = {j: dT0 % p}; dc = {}
    for m in range(j + 1, n + 1):
        acc = np.zeros((221, dT0.shape[1]), np.int64)
        for i in range(j, m): acc = (acc + MHs[m - i] @ dT[i]) % p
        dc[m] = acc; dT[m] = SL @ acc % p
    return dc

res = {'tag': tag, 'v_digest': v_digest}
Ts, MHs, cs = arc({}, 5)
Kc = {m: Kl @ cs[m] % p for m in cs}
low = [m for m in (2, 3, 4) if Kc[m].any()]
say("ORDER 5 build: K.c_m nonzero for m in 2..4:", low, "; K.c5 nnz", int(np.count_nonzero(Kc[5])))
DG = Kl @ lin(MHs, 2, kerL, 5)[5] % p
rDG = rank(DG, p); in5 = in_span(DG, Kc[5], p)
say("rank DG4(v) = %d; K.c5 in Im DG4: %s" % (rDG, in5))
res.update({'low_nonzero': low, 'Kc5_nnz': int(np.count_nonzero(Kc[5])), 'rank_DG4': rDG, 'Kc5_in_ImDG4': in5})
np.save(os.path.join(A.out, tag + '_Kc5.npy'), Kc[5])
verdict = None
if low: verdict = 'ERROR_low_orders'
elif not in5: verdict = 'OBSTRUCTED_AT_5'
else:
    x2 = solve(DG, (-Kc[5]) % p, p)
    xs = {2: x2}
    Ts, MHs, cs = arc(xs, 6)
    Kc = {m: Kl @ cs[m] % p for m in cs}
    low = [m for m in (2, 3, 4, 5) if Kc[m].any()]
    Dn = Kl @ lin(MHs, 3, kerL, 6)[6] % p
    in6 = in_span(Dn, Kc[6], p)
    say("ORDER 6 (x_2 applied): K.c_m nonzero m <= 5: %s; K.c6 nnz %d; x_3 effect rank %d equals DG4: %s; K.c6 in Im DG4: %s"
        % (low, np.count_nonzero(Kc[6]), rank(Dn, p), np.array_equal(Dn, DG), in6))
    np.save(os.path.join(A.out, tag + '_Kc6.npy'), Kc[6])
    res.update({'low6': low, 'Kc6_nnz': int(np.count_nonzero(Kc[6])), 'Kc6_in_ImDG4': in6, 'Dn_eq_DG': bool(np.array_equal(Dn, DG))})
    if low: verdict = 'UNRESOLVED_low'
    elif in6:
        x3 = solve(Dn, (-Kc[6]) % p, p); xs[3] = x3
        # check: with x_3 the order-6 K-part vanishes to first order (exact: c_6 is affine in x_3 since T_3 enters c_6 linearly)
        dc = lin(MHs, 3, (kerL @ x3 % p)[:, None], 6)
        ok = not ((Kl @ ((cs[6] + dc[6][:, 0]) % p)) % p).any()
        say("x_3 correction: K.c6 = 0 after correction (affine): %s" % ok)
        verdict = 'EXTENDS_6' if ok else 'UNRESOLVED_affine'
        Ts = Ts + [(SL @ cs[6] % p)]
    else:
        kD = kernel(DG, p)
        dc2 = lin(MHs, 2, kerL @ kD % p, 6)
        Lam = Kl @ dc2[6] % p
        low2 = [m for m in (3, 4, 5) if (Kl @ dc2[m] % p).any()]
        rIL = rank(np.concatenate([DG, Lam], 1), p); inIL = in_span(np.concatenate([DG, Lam], 1), Kc[6], p)
        say("dim ker DG4 = %d; first-order effect on K.c3..5 zero: %s; rank [Im DG4 | Lambda(ker)] = %d; K.c6 in it: %s" % (kD.shape[1], not low2, rIL, inIL))
        k = kD @ np.random.default_rng(777 + A.seed).integers(0, p, kD.shape[1]) % p
        xs2 = {2: (x2 + k) % p}
        Ts2, MHs2, cs2 = arc(xs2, 6)
        still0 = not any((Kl @ cs2[m] % p).any() for m in (2, 3, 4, 5))
        lamk = Kl @ lin(MHs, 2, (kerL @ k % p)[:, None], 6)[6][:, 0] % p
        q = (Kl @ cs2[6] - Kc[6] - lamk) % p
        qin = in_span(DG, q, p)
        say("random k in ker DG4: K.c2..5 still 0: %s; quadratic part in Im DG4: %s" % (still0, qin))
        res.update({'dim_kerDG4': int(kD.shape[1]), 'rank_DG_Lam': rIL, 'Kc6_in_DG_Lam': inIL, 'still0': still0, 'quad_in_ImDG4': qin})
        if not inIL and still0 and qin: verdict = 'OBSTRUCTED_GENUINE'
        elif inIL: verdict = 'OBSTRUCTED_CHOICE'
        else: verdict = 'OBSTRUCTED_UNRESOLVED'
np.save(os.path.join(A.out, tag + '_arc.npy'), np.array(Ts, np.int64))
res['arc_digest'] = hashlib.sha256(np.array(Ts, np.int64).tobytes()).hexdigest()[:16]
res['verdict'] = verdict; res['runtime_s'] = round(time.time() - t00)
import resource; res['peak_rss_gb'] = round(resource.getrusage(resource.RUSAGE_SELF).ru_maxrss / 2**20, 2)
say("BC-VERDICT", verdict, json.dumps(res))
json.dump(res, open(os.path.join(A.out, tag + '.json'), 'w'), indent=1)
