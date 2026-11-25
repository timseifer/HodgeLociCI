# polynomial multiplication tensors in 6 variables (f1,f2,f3,h1,h2,h3), coordinates where Y_0 = sum f_i h_i (f_i + h_i)
import itertools, numpy as np
NV = 6
def mons(d):
    out = []
    for c in itertools.combinations_with_replacement(range(NV), d):
        e = [0]*NV
        for i in c: e[i] += 1
        out.append(tuple(e))
    return out
M = {d: mons(d) for d in range(0, 6)}
IDX = {d: {m: i for i, m in enumerate(M[d])} for d in M}
def multensor(d1, d2):
    T = np.zeros((len(M[d1]), len(M[d2]), len(M[d1 + d2])))
    for i, a in enumerate(M[d1]):
        for j, b in enumerate(M[d2]):
            T[i, j, IDX[d1 + d2][tuple(x + y for x, y in zip(a, b))]] = 1
    return T
T11 = multensor(1, 1); T21 = multensor(2, 1); T23 = multensor(2, 3); T32 = multensor(3, 2); T12 = multensor(1, 2)
def lin(v): return np.asarray(v, dtype=complex)
def Y0vec(w=(1, 1, 1)):
    # sum_i f_i h_i (f_i + h_i): f_i = var i, h_i = var 3+i
    y = np.zeros(len(M[3]), dtype=complex)
    for i in range(3):
        e = [0]*6; e[i] = 2; e[3+i] = 1; y[IDX[3][tuple(e)]] += w[i]
        e = [0]*6; e[i] = 1; e[3+i] = 2; y[IDX[3][tuple(e)]] += w[i]
    return y
