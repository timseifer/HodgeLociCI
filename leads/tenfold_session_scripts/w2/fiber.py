# W2: numerical scouting of the fiber over the Fermat fourfold of the AHTV incidence {(Y, T): Y in I_T(3)}
import sys, numpy as np, time
from scipy.optimize import least_squares
from polyt import *
Y0 = Y0vec(); Y0 = Y0 / np.linalg.norm(Y0)
def unpack(x):
    z = x[:63] + 1j * x[63:]
    al = z[:18].reshape(3, 6); be = z[18:36].reshape(3, 6); C = z[36:].reshape(3, 3, 3)
    return al, be, C
def quads(al, be, C):
    ab = np.einsum('ia,jb->ijab', al, be).reshape(9, 36)
    P = ab @ T11.reshape(36, 21)                                # p_ij = al_i be_j (9,21)
    q = C.reshape(3, 9) @ P
    return P, q
def ITbasis(al, be, C, ret_sv=False):
    al = al / np.linalg.norm(al, axis=1, keepdims=True); be = be / np.linalg.norm(be, axis=1, keepdims=True)
    P, q = quads(al, be, C)
    q = q / np.linalg.norm(q, axis=1, keepdims=True)
    V5 = (q @ T23.reshape(21, -1)).reshape(-1, 252)           # q_k * cubic monomials (3*56, 252)
    U, s, Vh = np.linalg.svd(V5, full_matrices=False)
    U5 = Vh[:150].conj().T                                    # 252 x 150 orthonormal basis of (N)_5
    Pn = P / np.linalg.norm(P, axis=1, keepdims=True)
    Phi = (Pn @ T23.reshape(21, -1)).reshape(9 * 56, 252)       # rows (p, cubic monomial): p * m
    Phi = Phi - (Phi @ U5) @ U5.conj().T                         # project off (N)_5
    A = Phi.reshape(9, 56, 252).transpose(0, 2, 1).reshape(-1, 56)
    _, s2, Vh2 = np.linalg.svd(A, full_matrices=False)
    K = Vh2[-20:].conj().T
    if ret_sv: return K, s, s2
    return K
def resid(x):
    al, be, C = unpack(x)
    K = ITbasis(al, be, C)
    r = Y0 - K @ (K.conj().T @ Y0)
    return np.concatenate([r.real, r.imag])
def run(seed, maxfev=70):
    rng = np.random.default_rng(seed)
    x0 = rng.normal(size=126)
    t = time.time()
    sol = least_squares(resid, x0, method='trf', max_nfev=maxfev, xtol=1e-14, ftol=1e-14, gtol=1e-14)
    return sol, time.time() - t
if __name__ == '__main__':
    for seed in range(int(sys.argv[1]), int(sys.argv[2])):
        sol, dt = run(seed)
        al, be, C = unpack(sol.x)
        K, s, s2 = ITbasis(al, be, C, True)
        print('seed', seed, 'd =', np.linalg.norm(sol.fun), 'nfev', sol.nfev, 'time %.1f' % dt,
              'sv N5 around 150:', s[148:152].round(6), 'sv Phi tail:', s2[-22:-18].round(6), flush=True)
        np.save('fib_%d.npy' % seed, sol.x)
