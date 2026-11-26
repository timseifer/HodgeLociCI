import sys, time
sys.path.insert(0, "/home/claude/blind_check13")
from lib13 import *
fn = sys.argv[1]; p = int(sys.argv[2]); N = int(sys.argv[3])
hdr, idx, D, tl = read_arc(fn)
S = Setup(p)
Ts = [S.parse(l) for l in tl]
print(hdr); print("z =", S.z, " terms:", len(Ts), " monomials per T_n:", [len(t) for t in Ts])
t0 = time.time()
E = [None]
E = S.expseries(Ts, N)
for n in range(N + 1):
    print("E_%d: %d terms" % (n, len(E[n])))
print("time %.1fs" % (time.time() - t0))
