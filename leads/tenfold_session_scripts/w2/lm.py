# W2: own Levenberg-Marquardt (FD Jacobian) for the fibre problem dist(Y, I_T(3)) -> 0 over AHTV data (chart of fiber2.py)
import sys, time, numpy as np
from fiber2 import unpack, make_resid
def lm(Y, x0, iters=40, lam=1e-3, h=1e-7, verbose=False, tol=1e-12):
    f = make_resid(Y); x = x0.copy(); r = f(x); c = r @ r
    for it in range(iters):
        J = np.empty((r.size, x.size))
        for k in range(x.size):
            e = np.zeros_like(x); e[k] = h; J[:, k] = (f(x + e) - r) / h
        g = J.T @ r; H = J.T @ J
        while True:
            dx = -np.linalg.solve(H + lam * np.diag(np.diag(H) + 1e-12), g)
            rn = f(x + dx); cn = rn @ rn
            if cn < c: x, r, c = x + dx, rn, cn; lam = max(lam / 3, 1e-12); break
            lam *= 4
            if lam > 1e8: break
        if verbose: print('   it', it, 'd =', np.sqrt(c), 'lam', lam, flush=True)
        if np.sqrt(c) < tol or lam > 1e8: break
    return x, np.sqrt(c)
if __name__ == '__main__':
    from fiber import ITbasis as ITb_full
    rng = np.random.default_rng(5)
    xs = rng.normal(size=72) * 0.7
    al, be, C = unpack(xs); K = ITb_full(al, be, C)
    Ycal = K @ (rng.normal(size=20) + 1j * rng.normal(size=20))
    t = time.time()
    x, d = lm(Ycal, xs + rng.normal(size=72) * 0.3, iters=15, verbose=True)
    print('calib final d', d, 'time', time.time() - t)
