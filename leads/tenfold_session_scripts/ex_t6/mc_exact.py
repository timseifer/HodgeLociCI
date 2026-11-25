# EX-T6: exact T Cone_T conditions Mc (replicates setup_p.m2: condMat || hodgeRow lam) over Q(z), realified.
from fex import *
import itertools

def mc_exact(X, lam):
    U = [1, 3, 5]; Y = [6, 7, 8, 9, 10, 11]
    forb = []
    for c in itertools.combinations_with_replacement(range(12), 3):
        e = [0] * 12
        for i in c: e[i] += 1
        if any(e[i] > 0 for i in (0, 2, 4)): continue
        du = sum(e[i] for i in U); dy = sum(e[i] for i in Y)
        if (du == 3 and all(e[i] <= 1 for i in U)) or (du == 2 and dy == 1 and all(e[i] <= 1 for i in U)) or \
           (du == 1 and dy == 2 and all(e[i] <= 1 for i in Y)):
            forb.append(tuple(e))
    findex = {f: k for k, f in enumerate(forb)}
    nf = len(forb)
    M0 = objzeros((nf + 1) * X.nm).reshape(nf + 1, X.nm); M1 = objzeros((nf + 1) * X.nm).reshape(nf + 1, X.nm)
    for j, m in enumerate(X.mons):
        k = m[0] + m[2] + m[4]
        r = list(m); r[1] += r[0]; r[3] += r[2]; r[5] += r[4]; r[0] = r[2] = r[4] = 0
        r = tuple(r)
        if r in findex:
            a, b = ZP[k % 6]; M0[findex[r], j] += fmpq(a); M1[findex[r], j] += fmpq(b)
        if all(m[i] == 0 for i in range(6)):
            ys = [i for i in range(6, 12) if m[i]]
            pairs = [(6, 7), (8, 9), (10, 11)]
            if all(sum(m[a] + m[b] for (a, b) in [pr]) == 1 for pr in pairs):
                e1 = 0; e2 = 0
                for (a, b) in pairs:
                    if m[a]: e1 += 2; e2 += 6
                    else: e1 += 1; e2 += 3
                a1, b1 = ZP[e1 % 6]; a2, b2 = ZP[e2 % 6]
                M0[nf, j] = 27 * (fmpq(a1) + lam * a2); M1[nf, j] = 27 * (fmpq(b1) + lam * b2)
    return real_mat(M0, M1), nf + 1
