# higher-order validation: arcs that stay in V_P1 (resp. GL-orbit) must have all periods of P1 (resp. delta) = 0
import sys
sys.path.insert(0, '/home/claude/hodge/discovery/checks/bc_t6')
from arc import *
p = int(sys.argv[1]) if len(sys.argv) > 1 else 2000000011
St = Setup(p, -1, range(12))
x = St.x; u = St.u
rng = np.random.default_rng(5)
def rnd_quad(vars_):
    acc = Poly(p)
    for _ in range(3):
        i, j = rng.choice(vars_, 2)
        acc = acc + (x(int(i)) * x(int(j))).scale(int(rng.integers(1, p)))
    return acc
# arc in V_P1: every F_j in I(P1)
Fs = [u(0) * rnd_quad(range(12)), u(3) * rnd_quad(range(12)), u(5) * rnd_quad(range(12)) + u(1) * rnd_quad(range(12))]
E = expE(Fs, p, 5)
for n in range(1, 6):
    f = St.phi2(E[n])
    print("V_P1 arc order", n, "len E", len(E[n]), "P1 periods all zero:", not f[:, 0].any(), " P2 periods zero:", not f[:, 1].any())
# a non-trivial control: generic F1 -> nonzero
E = expE([rnd_quad(range(12)) * x(0) + x(1) * x(2) * x(5)], p, 2)
print("control generic: order1 P1 zero?", not St.phi2(E[1])[:, 0].any(), " order2 P1 zero?", not St.phi2(E[2])[:, 0].any())
