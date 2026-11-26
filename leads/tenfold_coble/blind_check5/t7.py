"""
T7: the arc with no symmetry.  MOD p (numpy engine pcore.py).

  lam = lam1*tau, x = tau*xi, a = -h_lam(x)/(27(1+lam^3)), theta^3 = 1-a, theta(0)=1,
  F_tau = F_0 + 3 lam (P+Q) + 3 a lam Y + M_x + sum_k (r_k + theta y_k) tau phi_k.

usage: python3 t7.py SEED N PRIME [variants]     (variants: comma list from true,i,ii,iii,iv ; default all)
"""
import sys, random, time, itertools
import numpy as np
import pcore
from pcore import R, Y, Pv, Qv, mono

VARNAMES = {}
for k in range(3):
    VARNAMES[R(k)] = f"r{k}"; VARNAMES[Y(k)] = f"y{k}"; VARNAMES[Pv(k)] = f"p{k}"; VARNAMES[Qv(k)] = f"q{k}"


def series_mul(A, B, N, p):
    C = [0] * (N + 1)
    for i, a in enumerate(A):
        if a:
            for j, b in enumerate(B):
                if i + j > N:
                    break
                C[i + j] = (C[i + j] + a * b) % p
    return C


def make_a_theta(xi, lam1, N, p, variant):
    """power series a(tau), theta(tau) mod p up to tau^N"""
    inv = lambda t: pow(t % p, p - 2, p)
    h0 = (xi[0]**3 + xi[1]**3 + xi[2]**3) % p
    prod = (xi[0] * xi[1] * xi[2]) % p
    num = [0] * (N + 1)            # h_lam(x) = tau^3 h0(xi) + 3 lam1 tau^4 xi0 xi1 xi2
    if N >= 3:
        num[3] = h0
    if N >= 4 and variant != "ii":
        num[4] = (3 * lam1 * prod) % p
    den_inv = [0] * (N + 1)        # 1/(1 + lam1^3 tau^3)
    if variant == "iii":
        den_inv[0] = 1
    else:
        c = 1
        for k in range(0, N + 1, 3):
            den_inv[k] = c
            c = (-c * pow(lam1, 3, p)) % p
    a = series_mul(num, den_inv, N, p)
    a = [(-t * inv(27)) % p for t in a]
    # theta = (1-a)^(1/3) = sum_k binom(1/3,k) (-a)^k
    theta = [0] * (N + 1)
    theta[0] = 1
    ma = [(-t) % p for t in a]
    powk = [1] + [0] * N
    binom = 1
    third = inv(3)
    for k in range(1, N // 3 + 2):
        powk = series_mul(powk, ma, N, p)
        binom = binom * ((third - (k - 1)) % p) % p * inv(k) % p
        theta = [(theta[i] + binom * powk[i]) % p for i in range(N + 1)]
    # check theta^3 = 1 - a
    t3 = series_mul(series_mul(theta, theta, N, p), theta, N, p)
    chk = [(t3[i] + a[i]) % p for i in range(N + 1)]
    assert chk[0] == 1 and not any(chk[1:]), "theta^3 != 1-a"
    if variant == "iv":
        theta = [1] + [0] * N
    return a, theta


def build_arc(p, xi, lam1, phis, N, variant="true"):
    """returns dict j -> pcore.Poly"""
    a, theta = make_a_theta(xi, lam1, N + 1, p, variant)
    G = {}

    def add(j, key, c):
        if j > N:
            return
        d = G.setdefault(j, {})
        d[key] = (d.get(key, 0) + c) % p
    Pk = mono(Pv(0), Pv(1), Pv(2)); Qk = mono(Qv(0), Qv(1), Qv(2)); Yk = mono(Y(0), Y(1), Y(2))
    add(1, Pk, 3 * lam1); add(1, Qk, 3 * lam1)
    for i in range(3):
        for j in range(3):
            add(1, mono(Y(i + j), Pv(i), Qv(j)), xi[(i - j) % 3])
    if variant != "i":
        for m in range(N + 1):
            if a[m]:
                add(m + 1, Yk, 3 * a[m] * lam1)
    for k in range(3):
        for (c, (u, v)) in phis[k]:
            add(1, mono(R(k), u, v), c)
            for m in range(N + 1):
                if theta[m]:
                    add(m + 1, mono(Y(k), u, v), theta[m] * c)
    return {j: pcore.from_dict(d, p) for j, d in G.items()}, a, theta


def random_data(seed, p, sizes=(2, 2, 2), small=False):
    rng = random.Random(seed)
    rnd = (lambda: rng.choice([t for t in range(-9, 10) if t != 0]) % p) if small else (lambda: rng.randrange(1, p))
    xi = [rnd() for _ in range(3)]
    lam1 = rnd()
    quads = list(itertools.combinations_with_replacement(range(12), 2))
    phis = []
    for k in range(3):
        ms = rng.sample(quads, sizes[k])
        phis.append([(rnd(), m) for m in ms])
    return xi, lam1, phis


def describe(phis, p):
    def sgn(c):
        return c if c <= p // 2 else c - p
    return [" + ".join(f"{sgn(c)}*{VARNAMES[u]}*{VARNAMES[v]}" for c, (u, v) in ph) for ph in phis]


def main():
    seed = int(sys.argv[1]); N = int(sys.argv[2]); p = int(sys.argv[3])
    variants = sys.argv[4].split(",") if len(sys.argv) > 4 else ["true", "i", "ii", "iii", "iv"]
    sizes = tuple(int(t) for t in sys.argv[5].split(",")) if len(sys.argv) > 5 else (2, 2, 2)
    small = (len(sys.argv) > 6 and sys.argv[6] == "small")
    xi, lam1, phis = random_data(seed, p, sizes, small)
    print(f"seed {seed}, p = {p}, N = {N}, sizes {sizes}, small-integer data: {small}")
    print("  xi =", xi, " lam1 =", lam1)
    print("  phi =", describe(phis, p))
    kap = pcore.kappa_poly(p)
    Ql = pcore.standard_forms()
    classes = [kap]; names = ["kappa"]
    if p % 3 == 1:
        z = pcore.cube_roots_of_minus_one(p)
        pl = [pcore.plane(zz, p) for zz in z]
        assert pcore.comb([(pl[0], -1), (pl[1], -1), (pl[2], -1)], p) == kap
        classes += [pcore.comb([(pl[0], 1), (pl[1], -1)], p), pcore.comb([(pl[1], 1), (pl[2], -1)], p),
                    pcore.comb([(pl[0], 1), (pl[2], -1)], p)]
        names += ["delta(z1,z2)", "delta(z2,z3)", "delta(z1,z3)"]
    for var in variants:
        G, a, theta = build_arc(p, xi, lam1, phis, N, var)
        nt = {j: len(G[j]) for j in sorted(G)}
        t0 = time.time()
        if var == "true":
            res, first = pcore.expansion(G, N, p, [kap], Ql, verbose=True)
            print(f"  TRUE ARC: terms of G per order {nt}")
            print(f"     class kappa: first order with a nonzero period equation: {first[0] if first[0] else 'none up to ' + str(N)}")
            if len(classes) > 1:
                res2, first2 = pcore.expansion(G, min(N, 4), p, classes[1:], Ql, verbose=False, stop_at_first=True)
                for nm, f, rr in zip(names[1:], first2, res2):
                    cnt = sum(1 for t in rr[f] if t) if f else 0
                    print(f"     variant (v) class {nm}: first order with a nonzero period equation: "
                          f"{f if f else 'none up to ' + str(min(N, 4))}" + (f"  ({cnt} of 221 forms nonzero there)" if f else ""))
        else:
            res, first = pcore.expansion(G, N, p, [kap], Ql, verbose=False, stop_at_first=True)
            f = first[0]
            cnt = sum(1 for t in res[0][f] if t) if f else 0
            print(f"  variant ({var}), class kappa: first order with a nonzero period equation: "
                  f"{f if f else 'none up to ' + str(N)}" + (f"  ({cnt} of 221 forms nonzero there)" if f else ""))
        print(f"     [{time.time()-t0:.1f} s]", flush=True)


if __name__ == "__main__":
    main()
