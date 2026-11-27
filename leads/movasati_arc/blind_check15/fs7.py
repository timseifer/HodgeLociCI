#!/usr/bin/env python3
"""Blind check 15: extend the bc14 full-space reduction by one order (MOD p).
Unknowns T_2..T_6 squarefree cubics (T_7 enters order 7 only via L T_7 -> project to coker L).
T_n = k_n - X c'_n, ob_n = Kl c'_n, n = 2..7."""
import sys; sys.path.insert(0, "/home/claude/blind_check15/bc14_own")
from fs import *

class FS7(FS):
    def __init__(s, S, P, T1, seed=1):
        p = S.p
        FS.__init__(s, S, P, T1, seed)
        one = S.ctx.from_dict({(0,)*M: 1})
        F = [one]
        for k in range(1, 8): F.append(F[-1] * T1 * pow(k, p-2, p))
        s.F = F
        s.M3 = s.M3 + [s.batch(F[k], s.m3) for k in range(5, 6)]   # M3[0..5]
        s.M6 = s.M6 + [s.batch(F[3], s.m6)]                        # M6[0..3]
        s.fper = [S.periods(F[n], s.tab) for n in range(8)]
    def cprime(s, n, T, P):
        if n <= 6: return FS.cprime(s, n, T, P)
        p = s.p; h = pow(2, p-2, p); S = s.S
        c = s.fper[7].copy()
        for j in range(2, 7): c = c + s.M3[7 - j] @ T[j]
        c = c + s.M6[3] @ (s.v6(P[2] * P[2]) * h % p)
        c = c + s.M6[2] @ s.v6(P[2] * P[3])
        c = c + s.M6[1] @ ((s.v6(P[2] * P[4]) + s.v6(P[3] * P[3]) * h) % p)
        c = c + s.M6[0] @ ((s.v6(P[2] * P[5]) + s.v6(P[3] * P[4])) % p)
        c = c + S.periods(s.T1 * P[2] * P[2] * P[2] * pow(6, p-2, p), s.tab)
        c = c + S.periods(P[2] * P[2] * P[3] * h, s.tab)
        return c % p
    def evaluate(s, k, top=7):
        p = s.p; T = {}; P = {}; ob = {}
        for n in range(2, top + 1):
            c = s.cprime(n, T, P)
            ob[n] = s.Kl @ c % p
            if n <= top - 1:
                T[n] = (s.K @ k[n] - s.X @ c) % p; P[n] = s.poly3(T[n])
        return ob, T
    def rk(s):
        return {n: s.rng.integers(0, s.p, size=s.K.shape[1]) for n in range(2, 7)}
    def direct(s, T, T7, N=7):
        Ts = [s.T1] + [s.poly3(T[n]) for n in range(2, 7)] + [s.poly3(T7)]
        E = s.S.expseries(Ts, N)
        return [int(np.count_nonzero(s.S.periods(E[n], s.tab))) for n in range(1, N+1)]
