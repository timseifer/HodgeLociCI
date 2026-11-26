"""
VALIDATION of the blind checker's period code.

(1) arc F_0(g_tau x), g_tau = 1 + tau A + tau^2 B (random sparse integer matrices): every period equation of every
    class must vanish (isotrivial family).  Tested: each plane P_z separately, kappa, delta, and also an unrelated
    'random squarefree sextic' period polynomial (which must ALSO pass, because every (5,5)-class of the Fermat
    cubic stays (5,5) along a coordinate change; this shows what the test does and does not validate).
(2) the same arc with the sign of the perturbation flipped: F_0 - (F_0(g x) - F_0): must fail.
(3) algebraic pinning of the period polynomial of a plane (up to scalar) and of the relative scalars:
    (x_a - c x_b) * P_L in (x_i^2), and the sum over a pencil is 0.
"""
import sys, random, time
import numpy as np
import flint
import pcore, arcs
from arcs import X, TAU, F0, ctx


def random_g(rng, nA=10, nB=4):
    lin = []
    A = {}
    B = {}
    while len(A) < nA:
        A[(rng.randrange(12), rng.randrange(12))] = rng.choice([-3, -2, -1, 1, 2, 3])
    while len(B) < nB:
        B[(rng.randrange(12), rng.randrange(12))] = rng.choice([-2, -1, 1, 2])
    for i in range(12):
        li = X[i]
        for (a, b), c in A.items():
            if a == i:
                li = li + c * TAU * X[b]
        for (a, b), c in B.items():
            if a == i:
                li = li + c * TAU**2 * X[b]
        lin.append(li)
    return lin, A, B


def main():
    seed = int(sys.argv[1]) if len(sys.argv) > 1 else 1
    N = int(sys.argv[2]) if len(sys.argv) > 2 else 8
    primes = [2147483629, 2147483587] if len(sys.argv) <= 3 else [int(t) for t in sys.argv[3].split(",")]
    rng = random.Random(seed)
    lin, A, B = random_g(rng)
    print("seed", seed, "A =", A, "B =", B)
    Fg = sum(l**3 for l in lin)
    G = Fg - F0
    nonsqf = sum(1 for e in G.to_dict() if max(e[:12]) >= 2)
    print("terms of G:", len(G.to_dict()), " non-squarefree terms:", nonsqf, " tau-degrees:",
          sorted(set(int(e[12]) for e in G.to_dict())))
    Ql = pcore.standard_forms()
    for p in primes:
        assert p % 3 == 1
        z = pcore.cube_roots_of_minus_one(p)
        planes = [pcore.plane(zz, p) for zz in z]
        kap = pcore.comb([(planes[0], -1), (planes[1], -1), (planes[2], -1)], p)
        assert kap == pcore.kappa_poly(p), "rational formula for kappa disagrees"
        dl = pcore.comb([(planes[0], 1), (planes[1], -1)], p)
        dl2 = pcore.comb([(planes[1], 1), (planes[2], -1)], p)
        # a random squarefree sextic as fake 'period polynomial'
        import itertools
        rr = random.Random(seed + 77)
        fake = {}
        for c in rr.sample(list(itertools.combinations(range(12), 6)), 40):
            e = [0] * 12
            for i in c:
                e[i] = 1
            fake[tuple(e)] = rr.randrange(1, p)
        classes = planes + [kap, dl, dl2, fake]
        cname = ["P_z1", "P_z2", "P_z3", "kappa", "delta12", "delta23", "random sextic"]
        for sign, label in ((1, "F0(g x)"), (-1, "sign flipped")):
            Gp = arcs.split_tau(sign * G, p, N)
            t0 = time.time()
            res, first = pcore.expansion(Gp, N, p, classes, Ql, verbose=False)
            print(f"p={p} {label}: N={N}, first nonzero order per class:",
                  dict(zip(cname, first)), f"({time.time()-t0:.1f}s)")
    # (3) algebraic pinning, exact over Q(z), z^2 - z + 1 = 0, done with sympy
    import sympy as sp
    zz = sp.symbols("z")
    xs = sp.symbols("x0:12")
    def PL(pairs):
        out = 1
        for a, b, c in pairs:
            out *= 3 * c * (xs[a] + c * xs[b])
        return sp.expand(out)
    def red(e):
        e = sp.expand(e)
        e = sp.Poly(e, *xs, zz)
        out = 0
        for mon, c in e.terms():
            if max(mon[:12]) >= 2:
                continue
            out += c * sp.prod([xs[i]**mon[i] for i in range(12)]) * zz**mon[12]
        return sp.rem(sp.expand(out), zz**2 - zz + 1, zz)
    roots = [zz, -1, sp.rem(zz**5, zz**2 - zz + 1, zz)]
    ok1 = True
    for c in roots:
        prs = [(0, 1, -1), (2, 3, -1), (4, 5, -1), (6, 7, c), (8, 9, c), (10, 11, c)]
        P = PL(prs)
        for a, b, cc in prs:
            ok1 &= (red((xs[a] - cc * xs[b]) * P) == 0)
    print("EXACT: (x_a - c x_b) * P_L = 0 in the Jacobian ring of F0, all 6 equations, all 3 planes:", ok1)
    ok2 = True
    for (c1, c2) in [(roots[0], roots[0]), (roots[0], roots[1]), (roots[2], roots[1])]:
        s = 0
        for c in roots:
            s += PL([(0, 1, -1), (2, 3, -1), (4, 5, -1), (6, 7, c), (8, 9, c1), (10, 11, c2)])
        s = sp.Poly(sp.expand(s), *xs)
        ok2 &= all(sp.rem(cf, zz**2 - zz + 1, zz) == 0 for cf in s.coeffs())
    print("EXACT: the three planes of a pencil (one root varies) have period polynomials adding to 0:", ok2)
    # kappa polynomial is rational: -(sum of three) = const * prod(r_k - y_k) * (P - Q)
    s = 0
    for c in roots:
        s += PL([(0, 1, -1), (2, 3, -1), (4, 5, -1), (6, 7, c), (8, 9, c), (10, 11, c)])
    s = sp.expand(sp.rem(sp.expand(s), zz**2 - zz + 1, zz))
    target = sp.expand((xs[0]-xs[1])*(xs[2]-xs[3])*(xs[4]-xs[5])*(xs[6]*xs[8]*xs[10]-xs[7]*xs[9]*xs[11]))
    ratio = sp.simplify(s / target)
    print("EXACT: sum of the three period polynomials / [prod(r_k-y_k)*(P-Q)] =", ratio)


if __name__ == "__main__":
    main()
