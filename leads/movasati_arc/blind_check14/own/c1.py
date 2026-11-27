import sys; sys.path.insert(0, "/home/claude/blind_check14/own")
from own import *
p = int(sys.argv[1]); z = {32029: 31556, 31981: 12637}[p]
S = Ctx(p, z)
P1 = S.Pspace(L1); P2 = S.Pspace(L2)
for fn, lam, N in [("exact_g_lam2_order5.txt", 2, 6), ("exact_g_lam-1_order7.txt", -1, 7), ("exact_s_lam-1_order9.txt", -1, 9)]:
    Ts = [S.parse(l) for l in read_lines(fn)]
    t0 = time.time()
    tab = S.ptable(P1 + P2 * (lam % p)); tabm = S.ptable(P1 - P2 * (lam % p))
    E = S.expseries(Ts, N)
    nz = [int(np.count_nonzero(S.periods(E[n], tab))) for n in range(1, N+1)]
    nzm = int(np.count_nonzero(S.periods(E[1], tabm)))
    # control: perturb last term
    Tc = list(Ts); Tc[len(Ts)-1] = Tc[len(Ts)-1] + S.x[0]*S.x[3]*S.x[9]
    Ec = S.expseries(Tc, len(Ts))
    ctl = int(np.count_nonzero(S.periods(Ec[len(Ts)], tab)))
    print(fn, "p", p, "terms", len(Ts), "lam", lam, "nonzero per order 1..%d:" % N, nz, "| lam", -lam, "order1:", nzm,
          "| control T_last + x0x3x9 at order", len(Ts), ":", ctl, "| #E_N", len(E[N]), "| %.0fs" % (time.time()-t0), flush=True)
