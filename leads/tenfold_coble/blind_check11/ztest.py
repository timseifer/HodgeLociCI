# The forms Q_a, l_i, B_ij, G and the Z_a-membership test of C2, generic over any field / ring.
from common import *
import json

_d = json.load(open("/home/claude/blind_check11/c1_data.json"))
V1 = [Fr(c) for c in _d["v1"]]
V2 = [Fr(c) for c in _d["v2"]]
HA = hess(A_PT, Fr(0))


def forms(y, zero, v1=V1, v2=V2):
    """returns dict with F, Qa, l1, l2, B11, B12, B22, G at y (y entries in a ring; zero its zero)."""
    g = grad(y, zero)
    v1k = [zero + c for c in v1]
    v2k = [zero + c for c in v2]
    l1 = dot(v1k, g, zero)
    l2 = dot(v2k, g, zero)
    Hay = [dot([zero + c for c in row], y, zero) for row in HA]
    Qa = dot(y, Hay, zero)
    B11 = tri(v1k, v1k, y, zero)
    B12 = tri(v1k, v2k, y, zero)
    B22 = tri(v2k, v2k, y, zero)
    G = (B22 * l1 * l1 - B12 * l1 * l2 * 2 + B11 * l2 * l2) * 2
    return dict(F=Fval(y, zero), Qa=Qa, l1=l1, l2=l2, B11=B11, B12=B12, B22=B22, G=G, grad=g, Hay=Hay)


def gradG(y, zero, v1=V1, v2=V2):
    f = forms(y, zero, v1, v2)
    v1k = [zero + c for c in v1]
    v2k = [zero + c for c in v2]
    H = hess(y, zero)
    dl1 = matvec(H, v1k, zero)
    dl2 = matvec(H, v2k, zero)
    dB11 = hess_vec(v1k, v1k, zero)
    dB12 = hess_vec(v1k, v2k, zero)
    dB22 = hess_vec(v2k, v2k, zero)
    l1, l2, B11, B12, B22 = f["l1"], f["l2"], f["B11"], f["B12"], f["B22"]
    out = []
    for i in range(N):
        t = (dB22[i] * l1 * l1 + B22 * l1 * dl1[i] * 2
             - (dB12[i] * l1 * l2 + B12 * (dl1[i] * l2 + l1 * dl2[i])) * 2
             + dB11[i] * l2 * l2 + B11 * l2 * dl2[i] * 2) * 2
        out.append(t)
    return out


def za_test(y, zero, one, iszero, v1=V1, v2=V2, verbose=False):
    """Membership test of C2 at a point y of W = {F=Qa=G=0} over a field.
    Returns dict of booleans/values."""
    f = forms(y, zero, v1, v2)
    r = {}
    r["F=0"] = iszero(f["F"])
    r["Qa=0"] = iszero(f["Qa"])
    r["G=0"] = iszero(f["G"])
    r["l1=0"] = iszero(f["l1"])
    r["l2=0"] = iszero(f["l2"])
    if r["l1=0"] and r["l2=0"]:
        r["status"] = "l1=l2=0: direction not forced"
        return r
    t1, t2 = f["l2"], zero - f["l1"]
    vt = [t1 * a + t2 * b for a, b in zip(v1, v2)]
    r["vtau"] = vt
    r["tau"] = (t1, t2)
    H = hess(y, zero)
    J = [f["grad"], f["Hay"], matvec(H, vt, zero), hess_vec(vt, vt, zero)]
    r["l_tau(y)=0"] = iszero(dot(vt, f["grad"], zero))
    r["b_tau(y)=0"] = iszero(tri(vt, vt, y, zero))
    r["rankJ"] = rank(J, zero, one, iszero)
    if r["rankJ"] != 4:
        r["status"] = "Jacobian rank < 4: test not applicable"
        return r
    K = nullspace(J, zero, one, iszero)
    assert len(K) == 5
    r["tangent"] = K
    ak = [zero + c for c in A_PT]
    r["a in tangent"] = all(iszero(c) for c in matvec(J, ak, zero))
    r["a+vtau in tangent"] = all(iszero(c) for c in matvec(J, vt, zero))
    r["y in tangent"] = all(iszero(c) for c in matvec(J, y, zero))
    nonvan = 0
    for i in range(5):
        for j in range(i, 5):
            for k in range(j, 5):
                if not iszero(tri(K[i], K[j], K[k], zero)):
                    nonvan += 1
    r["nonvanishing cubic coefficients of F on tangent"] = nonvan
    r["tangent in Y"] = (nonvan == 0)
    r["on Z_a"] = r["tangent in Y"] and r["a in tangent"] and r["a+vtau in tangent"]
    r["status"] = "ok"
    return r


def w_smooth_test(y, zero, one, iszero, plane_cols, v1=V1, v2=V2):
    """rank of Jacobian of (F,Qa,G) at y and dim of (tangent space of W) cap (span of plane_cols)."""
    f = forms(y, zero, v1, v2)
    Qgrad = [c * 2 for c in f["Hay"]]
    J3 = [f["grad"], Qgrad, gradG(y, zero, v1, v2)]
    rk = rank(J3, zero, one, iszero)
    # restrict to the plane: J3 * P
    P = [[zero + c for c in col] for col in plane_cols]
    M = [[dot(row, col, zero) for col in P] for row in J3]
    rkM = rank(M, zero, one, iszero)
    return rk, len(plane_cols) - rkM
