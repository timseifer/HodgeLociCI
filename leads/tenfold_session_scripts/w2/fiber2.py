# W2: reduced-chart version of fiber.py. A = {x : [I|X] x = 0}, B = {x : [Yb|I] x = 0}, net = rowspace of [I | G] in the 9-dim I_A I_B
import sys, numpy as np, time
from scipy.optimize import least_squares
from polyt import *
from fiber import ITbasis as ITb_full
def unpack(x):
    z = x[:36] + 1j * x[36:]
    X = z[:9].reshape(3, 3); Yb = z[9:18].reshape(3, 3); G = z[18:].reshape(3, 6)
    al = np.hstack([np.eye(3), X]); be = np.hstack([Yb, np.eye(3)])
    Cm = np.hstack([np.eye(3), G]).reshape(3, 3, 3)
    return al, be, Cm
def make_resid(Yt):
    Yt = Yt / np.linalg.norm(Yt)
    def resid(x):
        al, be, C = unpack(x)
        K = ITb_full(al, be, C)
        r = Yt - K @ (K.conj().T @ Yt)
        return np.concatenate([r.real, r.imag])
    return resid
def solve(Yt, x0, nfev=60):
    return least_squares(make_resid(Yt), x0, method='lm', max_nfev=nfev * 73, xtol=1e-15, ftol=1e-15, gtol=1e-15)
