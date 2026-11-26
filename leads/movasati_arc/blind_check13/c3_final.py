#!/usr/bin/env python3
"""C3, decisive identity tests in the full space of squarefree cubics.  usage: c3_final.py file p lam"""
import sys, time
exec(open("/home/claude/blind_check13/c3_red.py").read().split("# identity tests of the polynomial structure")[0])
t1 = time.time()
I3 = rref(lev3.T, p)[0]
def in3(v): return rank(np.vstack([I3, v % p]), p) == len(I3)
Lf = nullspace(I3, p)                        # functionals l with l . im(level3) = 0   (26 x 19)
le = Lf.T @ e6 % p
print("functionals vanishing on im(level3): dim", Lf.shape[1], " ; of these, non-zero on the order-6 defect e6:", int(np.count_nonzero(le)))
n1 = 8; ok3 = ok4 = ok5 = 0
for t in range(n1):
    a2 = rng.integers(0, p, size=101); k2 = Kb @ a2 % p; k3, k4, k5 = rk(), rk(), rk()
    o = ob(k2, k3, k4, k5)
    ok3 += not o[:26].any(); ok4 += not o[26:52].any(); ok5 += not ((o[52:78] - lev3 @ a2) % p).any()
print("(I1) %d random dense points (k2,k3,k4,k5) in (ker L)^4:  ob3 = 0: %d   ob4 = 0: %d   ob5 = level3 k2: %d" % (n1, ok3, ok4, ok5))
n2 = 10; okin = 0; okl = 0; nz = 0
for t in range(n2):
    k2 = rk(K3); k3, k4, k5 = rk(), rk(), rk()
    o6 = ob(k2, k3, k4, k5)[78:]
    nz += bool(((o6 - e6) % p).any())
    okin += in3(o6 - e6); okl += not ((Lf.T @ o6 - le) % p).any()
print("(I2) %d random dense points, k2 in ker(level3), k3,k4,k5 in ker L:  ob6 - e6 non-zero: %d ;  ob6 - e6 in im(level3): %d ;  l.ob6 = l.e6 for all 19 functionals: %d"
      % (n2, nz, okin, okl))
if e6.any() and not in3(e6):
    print("CONCLUSION (MOD p = %d, random identity tests): order 5 forces k2 in ker(level3); then ob6 = e6 mod im(level3), e6 not in im(level3):" % p)
    print("   no T_2..T_6 in the full space of squarefree cubics satisfies orders 2..6 with this T_1.")
elif not e6.any():
    print("CONCLUSION: the order-6 defect of the base jet is zero (no obstruction at order 6 for this jet).")
else:
    print("CONCLUSION: e6 lies in im(level3): order 6 can be repaired by T_3.")
print("time %.1fs (total %.1fs)" % (time.time() - t1, time.time() - t0))
