"""validation of the second (exact, flint) engine: arc F_0(g_tau x), class kappa, exact over QQ; and sign flip."""
import random, sys
import flint
import exact_eval as ee, validate, arcs
seed = int(sys.argv[1]) if len(sys.argv) > 1 else 1
N = int(sys.argv[2]) if len(sys.argv) > 2 else 6
rng = random.Random(seed)
lin, A, B = validate.random_g(rng)
G = sum(l**3 for l in lin) - arcs.F0
ctx = flint.fmpq_mpoly_ctx.get([f"x{i}" for i in range(12)], "degrevlex")
def split(Gpoly, sign):
    out = {}
    for e, c in Gpoly.to_dict().items():
        j = int(e[12])
        out.setdefault(j, {})[tuple(int(t) for t in e[:12])] = sign * c
    return {j: ctx.from_dict(d) for j, d in out.items()}
kap = ee.kappa_poly(); Ql = ee.standard_forms()
for sign, label in ((1, "F0(g x)"), (-1, "sign flipped")):
    res = ee.expansion(split(G, sign), N, ctx, kap, Ql, verbose=False, stop_at_first=True)
    first = [n for n in sorted(res) if any(res[n])]
    print(f"EXACT engine, seed {seed}, {label}: kappa: first nonzero order: {first[0] if first else 'none up to ' + str(N)}")
