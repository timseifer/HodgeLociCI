#!/usr/bin/env python3
"""Blind check 12, extra for C3/C6: how does |det A - GA| compare with |F_eps| (= |GA + GB|), and is det A - GA
tangent to the GL_8-orbit of GA?   usage: c3_extra.py DEN      (re-uses the helper part of my own c2_num.py)"""
import sys
src = open("/home/claude/blind_check12/c2_num.py").read().split("y5cube = ")[0]
exec(src)
A = [[[acb(arb(a), arb(b)) for a, b in J["A"][i][j]] for j in range(3)] for i in range(3)]
def mul_lin(p, l):
    out = {}
    for m, c in p.items():
        for k in range(8):
            mm = tuple(sorted(m + (k,)))
            out[mm] = out.get(mm, acb(0)) + c * l[k]
    return out
def lin(l): return {(k,): l[k] for k in range(8)}
det = {}
for perm, sgn in (((0, 1, 2), 1), ((1, 2, 0), 1), ((2, 0, 1), 1), ((0, 2, 1), -1), ((2, 1, 0), -1), ((1, 0, 2), -1)):
    p = mul_lin(mul_lin(lin(A[0][perm[0]]), A[1][perm[1]]), A[2][perm[2]])
    for m, c in p.items(): det[m] = det.get(m, acb(0)) + sgn * c
dv = [det.get(m, acb(0)) for m in mons3]
nGA = norm(GA)
d1 = [a - b for a, b in zip(dv, GA)]
d2 = [a + b for a, b in zip(dv, GB)]
print("eps = 1/%d" % den)
print("  |det A - GA| / |GA| = %.3e     |det A + GB| / |GB| = %.3e     |F_eps| / |GA| = %.3e" % (fl(norm(d1) / nGA), fl(norm(d2) / norm(GB)), fl(norm(Fv) / nGA)))
print("  absolute: |det A - GA| = %.3e   |det A + GB| = %.3e   |F_eps| = %.3f   ratio |det A - GA| / |F_eps| = %.3e" % (fl(norm(d1)), fl(norm(d2)), fl(norm(Fv)), fl(norm(d1) / norm(Fv))))
# component of det A - GA outside the tangent space of the orbit GL_8.GA (column space of the Lie map of GA, rank 56)
M = liemat(GA)
sv, cols = gram_eig(M, True)
MH = M.conjugate().transpose()
for name, d in (("det A - GA", d1), ("det A + GB", d2), ("F_eps", Fv)):
    rhs = matvec(MH, d)
    x = [acb(0)] * 64
    for k in range(8, 64):
        c = hdot(cols[k], rhs) / (sv[k] ** 2)
        x = [a + c * b for a, b in zip(x, cols[k])]
    res = [a - b for a, b in zip(d, matvec(M, x))]
    print("  %-11s: norm %.3e ; part outside the tangent space of the orbit of GA: %.3e (relative to |GA|: %.3e) ; size of the 8x8 matrix X used: %.3e" % (
        name, fl(norm(d)), fl(norm(res)), fl(norm(res) / nGA), fl(norm(x))))
