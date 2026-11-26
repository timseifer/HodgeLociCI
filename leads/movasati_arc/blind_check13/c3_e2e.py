#!/usr/bin/env python3
"""C3 end-to-end validation of the reduced evaluator against the direct definition: random admissible jets in the full
space (T_2 changed by a dense element of ker(level3), T_3, T_4, T_5 by dense elements of ker L, pivot parts re-solved):
orders 2..5 must vanish identically (all 45 entries each) and the order-6 defect must equal ob6.  usage: file p lam"""
import sys, time
exec(open("/home/claude/blind_check13/c3_red.py").read().split("# identity tests of the polynomial structure")[0])
I3 = rref(lev3.T, p)[0]
for trial in range(2):
    k2 = rk(K3); k3, k4, k5 = rk(), rk(), rk()
    o, (d2, d3, d4, d5) = ob(k2, k3, k4, k5, full=True)
    y = np.concatenate([d2, d3, d4, d5]) % p
    c = X.direct(y)                                   # c_2..c_5 (45 each), then Kl c_6
    nzT = [int(np.count_nonzero(y[120 * j:120 * (j + 1)])) for j in range(4)]
    print("random admissible jet %d: non-zero coefficients of the changes of T_2..T_5: %s ; direct: non-zero entries of c_2..c_5: %s ; Kl c_6 equals ob6: %s ; non-zero: %d of 26 ; (Kl c_6 - e6) in im(level3): %s ; Kl c_6 in im(level3): %s"
          % (trial + 1, nzT, [int(np.count_nonzero(c[45 * j:45 * (j + 1)])) for j in range(4)], not ((c[180:] - o[78:]) % p).any(),
             int(np.count_nonzero(c[180:])), rank(np.vstack([I3, (c[180:] - e6) % p]), p) == len(I3), rank(np.vstack([I3, c[180:]]), p) == len(I3)))
# a non-admissible change of T_2 (k2 not in ker level3): order 5 must fail
k2 = rk(); o = ob(k2, Z, Z, Z)
print("non-admissible T_2 change (k2 random in ker L): ob5 non-zero entries:", int(np.count_nonzero(o[52:78])))
