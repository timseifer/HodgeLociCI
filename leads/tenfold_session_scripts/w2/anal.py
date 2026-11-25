import sys, numpy as np
from fiber import *
np.set_printoptions(precision=3, suppress=True, linewidth=150)
for s in sys.argv[1:]:
    x = np.load('fib_%s.npy' % s); al, be, C = unpack(x)
    al = al / np.linalg.norm(al, axis=1, keepdims=True); be = be / np.linalg.norm(be, axis=1, keepdims=True)
    # plane A = common zeros of rows of al: kernel (3-dim) in C^6; report its f/h components
    def kern(m):
        u, sv, vh = np.linalg.svd(m); return sv, vh[3:].conj().T
    sa, KA = kern(al); sb, KB = kern(be)
    print('seed', s, 'sv al', sa, 'sv be', sb)
    # principal angles of plane A with P1' = span(h-coords: e3,e4,e5) and P2' = span(e0,e1,e2)
    E1 = np.eye(6)[:, 3:]; E2 = np.eye(6)[:, :3]
    def angles(K, E):
        return np.linalg.svd(K.conj().T @ E, compute_uv=False)
    print('  A vs P1 (f=0):', angles(KA, E1), ' A vs P2 (h=0):', angles(KA, E2))
    print('  B vs P1 (f=0):', angles(KB, E1), ' B vs P2 (h=0):', angles(KB, E2))
    P, q = quads(al, be, C); qn = q / np.linalg.norm(q, axis=1, keepdims=True)
    sq = np.linalg.svd(qn, compute_uv=False); print('  net sv', sq)
    # quadric matrices; test common linear factor: stack symmetric 6x6 matrices
    from polyt import M, IDX
    def symm(v):
        S = np.zeros((6, 6), complex)
        for i, m in enumerate(M[2]):
            nz = [k for k in range(6) for _ in range(m[k])]
            a, b = nz
            if a == b: S[a, a] += v[i]
            else: S[a, b] += v[i] / 2; S[b, a] += v[i] / 2
        return S
    Ss = [symm(v) for v in qn]
    print('  ranks of net members (sv):', [np.linalg.svd(S, compute_uv=False).round(3) for S in Ss])
    # fraction of each quadric in (f)(h) span: monomials f_i h_j
    fh = [IDX[2][tuple(1 if k in (i, 3 + j) else 0 for k in range(6))] for i in range(3) for j in range(3)]
    print('  weight on f_i h_j monomials:', [np.linalg.norm(v[fh]) for v in qn])
