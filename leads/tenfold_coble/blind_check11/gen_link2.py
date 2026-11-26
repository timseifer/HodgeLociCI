# Same link as gen_link.py for the degree-8 points on pi (statement) and on pi_2, pi_3 (own choices).
import json
from common import *
from fields import *
from ztest import *
from flint import fmpq_poly, fmpq
import gen_link as GL

def plane_points(plane_cols):
    ctx, (u0, u1, u2), zero, one = mp_ring(["u0", "u1", "u2"])
    us = [u0, u1, u2]
    y = [zero] * N
    for j in range(3):
        for i in range(N):
            y[i] = y[i] + us[j] * plane_cols[j][i]
    f = forms(y, zero)
    Q, G = f["Qa"].p, f["G"].p
    R = Q.resultant(G, 0)
    d = R.to_dict()
    coeffs = [fmpq(0)] * 11
    for k, c in d.items():
        coeffs[k[1]] = c
    m = fmpq_poly(coeffs)
    pts = []
    for g, e in m.factor()[1]:
        g = g * (1 / g.leading_coefficient())
        K = NumberField(g)
        t = K.gen
        def uni(poly):
            dd = poly.to_dict()
            deg = max(k[0] for k in dd)
            cs = [K.zero] * (deg + 1)
            for k, cf in dd.items():
                cs[k[0]] = cs[k[0]] + (t ** k[1]) * cf
            return cs
        gg = pgcd(uni(Q), uni(G), K.zero, K.one)
        assert len(gg) == 2
        uvals = [K.zero - gg[0], t, K.one]
        yk = [K.zero] * N
        for j in range(3):
            for i in range(N):
                yk[i] = yk[i] + uvals[j] * plane_cols[j][i]
        pts.append((K, yk))
    return pts

d = json.load(open("/home/claude/blind_check11/c1_data.json"))
Pp = [[Fr(c) for c in w] for w in d["Pprime"]]
planes = {"pi": PI_COLS}
for name, comb in {"pi_2": [(1, 0, 2, -1, 1), (0, 1, -1, 3, 2), (2, -1, 0, 1, -3)],
                   "pi_3": [(3, 1, 0, 0, -2), (1, -2, 1, 0, 1), (0, 1, 1, -1, 4)]}.items():
    planes[name] = [[sum(c[j] * Pp[j][i] for j in range(5)) for i in range(N)] for c in comb]
res = {}
for name, cols_ in planes.items():
    for K, yk in plane_points(cols_):
        if K.deg == 8:
            res[name] = GL.link(yk, K, "degree-8 point on " + name)
GL.P("RESULTS (degree-8 points):", res)
