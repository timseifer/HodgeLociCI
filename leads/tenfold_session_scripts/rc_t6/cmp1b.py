# RC-T6: equivariance of BC's plane functional under sigma (pairs 3-5: sigma^* x_a = z^2 x_b, sigma^* x_b = x_a),
# sigma P(w) = P(z^2/w): P1 (w = z) fixed, fe-P2 (w = -1) -> BC-P2 (w = z^5). Expect psi_{sigma P}(g) = det * psi_P(sigma^* g)
# with the SAME constant for P1 and P2 (then lambda is preserved).
import sys, numpy as np
sys.path.insert(0, '/home/claude/hodge/discovery/checks/bc_t6')
import hl
p = 32029; z = (-473) % p
F = hl.Field(p); F.z = z; F.zb = pow(z, 5, p)
TP1 = hl.pair_tables(F, [z] * 6); TQ2m = hl.pair_tables(F, [z, z, z, p - 1, p - 1, p - 1]); TQ2b = hl.pair_tables(F, [z, z, z, F.zb, F.zb, F.zb])
rng = np.random.default_rng(3); w = z * z % p
r1, r2 = set(), set()
for t in range(300):
    g = []
    for e in range(6):
        if rng.integers(2): g += [3 * int(rng.integers(0, 4)) + 1, 3 * int(rng.integers(0, 4))]
        else: g += [3 * int(rng.integers(0, 4)), 3 * int(rng.integers(0, 4)) + 1]
    gs = list(g); c = 1
    for e in (3, 4, 5):
        a, b = 2 * e, 2 * e + 1
        gs[a], gs[b] = g[b], g[a]; c = c * pow(w, g[a], p) % p
    val = lambda T, gg, cc: int(hl.functional(hl.Poly(p, [hl.enc(gg)], [cc]), [T], [[0] * 12], p)[0, 0])
    a1 = val(TP1, g, 1); b1 = val(TP1, gs, c)
    a2 = val(TQ2b, g, 1); b2 = val(TQ2m, gs, c)
    r1.add(a1 * pow(b1, p - 2, p) % p); r2.add(a2 * pow(b2, p - 2, p) % p)
print("psi_P1(g)/psi_P1(sigma^* g):", r1, " psi_BC-P2(g)/psi_fe-P2(sigma^* g):", r2, " (-1 = %d)" % (p - 1))
