# C3: exact count on a plane (default: the plane pi of the statement) and Z_a tests at the points.
import sys, json, time
from common import *
from fields import *
from ztest import *
from flint import fmpq_poly, fmpq

def run(plane_cols, label, out):
    def P(*a):
        s = " ".join(str(x) for x in a)
        print(s); out.write(s + "\n"); out.flush()
    P("=== plane:", label)
    ctx, (u0, u1, u2), zero, one = mp_ring(["u0", "u1", "u2"])
    us = [u0, u1, u2]
    y = [zero] * N
    for j in range(3):
        for i in range(N):
            y[i] = y[i] + us[j] * plane_cols[j][i]
    f = forms(y, zero)
    P("F restricted to the plane is identically zero:", f["F"].is_zero())
    Q, G, l1, l2 = f["Qa"].p, f["G"].p, f["l1"].p, f["l2"].p
    P("Q_a on plane: total degree", Q.total_degree(), " terms", len(Q.to_dict()))
    P("G on plane: total degree", G.total_degree(), " terms", len(G.to_dict()))
    P("gcd(Q_a, G) on plane:", Q.gcd(G))
    P("Q_a irreducible on plane? factorisation:", [(str(a), b) for a, b in Q.factor()[1]])
    # coefficient of u0^2 in Q (so (1:0:0) is not on the conic)
    P("Q(1,0,0) =", Q.to_dict().get((2, 0, 0), 0))
    R = Q.resultant(G, 0)   # homogeneous of degree 10 in u1,u2
    P("Res_{u0}(Q,G): total degree", R.total_degree(), "; is zero:", R.is_zero())
    d = R.to_dict()
    assert all(k[0] == 0 for k in d)
    coeffs = [fmpq(0)] * 11
    for k, c in d.items():
        coeffs[k[1]] = c     # dehomogenise u2=1: polynomial in u1
    m = fmpq_poly(coeffs)
    P("dehomogenised (u2=1) resultant: degree", m.degree(), " (10 means no point with u2=0 lost)")
    P("squarefree:", m.gcd(m.derivative()).degree() == 0)
    c, facs = m.factor()
    P("irreducible factors over QQ (degree, multiplicity):", [(g.degree(), e) for g, e in facs])
    # no common zero of Q, l1, l2 on the plane
    R1 = Q.resultant(l1, 0); R2 = Q.resultant(l2, 0)
    P("gcd(Res(Q,l1), Res(Q,l2)) =", R1.gcd(R2), " (1 => no point of plane cap {Q_a=0} with l1=l2=0)")
    summary = []
    for g, e in facs:
        g = g * (1 / g.leading_coefficient())
        K = NumberField(g)
        iz = lambda a_: (a_ == 0)
        P("--- closed point of degree", K.deg, "; min poly of u1/u2:", g)
        t = K.gen
        # Q, G as polynomials in u0 over K (u1=t,u2=1)
        def uni(poly):
            dd = poly.to_dict()
            deg = max(k[0] for k in dd)
            cs = [K.zero] * (deg + 1)
            for k, cf in dd.items():
                tp = K.one
                for _ in range(k[1]):
                    tp = tp * t
                cs[k[0]] = cs[k[0]] + tp * cf
            return cs
        Qk, Gk = uni(Q), uni(G)
        gg = pgcd(Qk, Gk, K.zero, K.one)
        P("degree in u0 of gcd(Q,G) over the field:", len(gg) - 1)
        assert len(gg) == 2
        u0v = K.zero - gg[0]
        uvals = [u0v, t, K.one]
        yk = [K.zero] * N
        for j in range(3):
            for i in range(N):
                yk[i] = yk[i] + uvals[j] * plane_cols[j][i]
        t0 = time.time()
        r = za_test(yk, K.zero, K.one, iz)
        for key in ["F=0", "Qa=0", "G=0", "l1=0", "l2=0", "l_tau(y)=0", "b_tau(y)=0", "rankJ", "a in tangent",
                    "a+vtau in tangent", "y in tangent", "nonvanishing cubic coefficients of F on tangent",
                    "tangent in Y", "on Z_a", "status"]:
            if key in r:
                P("   ", key, ":", r[key])
        rk, dimint = w_smooth_test(yk, K.zero, K.one, iz, plane_cols)
        P("    rank Jac(F,Q_a,G) at y:", rk, "; affine dim of (T_y W cap plane):", dimint,
          " (1 = only the point itself)")
        # degree of tau = t1/t2 over QQ: minimal polynomial degree via powers
        if "tau" in r:
            t1, t2 = r["tau"]
            if not (t2 == 0):
                ratio = t1 / t2
                # degree of QQ(ratio): rank of powers
                from flint import fmpq_mat
                pw = [K.one]
                for _ in range(K.deg - 1):
                    pw.append(pw[-1] * ratio)
                rows = [[(p_.p.coeffs() + [fmpq(0)] * K.deg)[:K.deg] for p_ in pw]][0]
                P("    degree of QQ(tau) :", fmpq_mat(rows).rank())
        P("    time for tests: %.1fs" % (time.time() - t0))
        summary.append((K.deg, r.get("on Z_a"), rk, dimint))
    P("SUMMARY", label, ":", summary)
    return summary

if __name__ == "__main__":
    out = open("/home/claude/blind_check11/c3.out", "w")
    run(PI_COLS, "pi (statement)", out)
