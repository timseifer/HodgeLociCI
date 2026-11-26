import sys, time
sys.path.insert(0, "/home/claude/blind_check13")
from c3_lib import *
fn = sys.argv[1]; p = int(sys.argv[2])
hdr, idx, D, tl = read_arc(fn)
S = Setup(p)
Ts = [S.parse(l) for l in tl]
L1s = [(2 * i, 2 * i + 1, 1) for i in range(5)]; L2s = [(2 * i, 2 * i + 1, 3 if i < 3 else 1) for i in range(5)]
tab = S.table([L1s, L2s], [1, 2])
t0 = time.time()
X = C3(S, tab, Ts)
print("==", fn, "p", p, " lambda 2 ; terms", len(Ts), [len(t) for t in Ts], " E sizes", [len(e) for e in X.E], " time %.1fs" % (time.time() - t0))
print("orders 1..6 of the file jet (T_6 = 0): non-zero entries among 45:", [int(np.count_nonzero(c)) for c in X.c])
L = X.J[0]
print("rank L =", rank(L, p), " ; order 6: c_6 in im L (i.e. solvable by T_6):", rank(np.hstack([L, X.c[5].reshape(-1, 1)]), p) == rank(L, p),
      " ; non-zero entries of the projection to coker L:", int(np.count_nonzero(X.Kl @ X.c[5] % p)), "of 26")
# validate the identity v(Y) = c(T^0 + Y) on a random sparse and a random dense Y
for sp in (8, 0):
    y = X.rng.integers(0, p, size=480)
    if sp:
        mask = np.zeros(480, dtype=np.int64); mask[X.rng.choice(480, size=4 * sp, replace=False)] = 1; y = y * mask
    t1 = time.time(); a = (X.v(y) + 0) % p; t2 = time.time(); bdir = X.direct(y); t3 = time.time()
    print("identity check (", "sparse" if sp else "dense", "Y): c(T0+Y) == c(T0) + Lin Y + NL(Y):", bool(((a - bdir) % p == 0).all()),
          "  time formula %.2fs, direct %.1fs" % (t2 - t1, t3 - t2))
# linearised test in the full space
print("LINEARISED full-space test: rank Lin =", rank(X.Lin, p), " rank [Lin | b] =", rank(np.hstack([X.Lin, X.b.reshape(-1, 1)]), p),
      " (206 x 480)  => order-6 defect removable by a first-order change of T_2..T_6:", rank(X.Lin, p) == rank(np.hstack([X.Lin, X.b.reshape(-1, 1)]), p))
t1 = time.time(); q = X.NL(X.rng.integers(0, p, size=480)); print("one dense NL evaluation: %.2fs" % (time.time() - t1))
