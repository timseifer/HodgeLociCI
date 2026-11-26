"""exact construction of arcs with python-flint (fmpq_mpoly in x0..x11 and tau), and reduction mod p"""
import flint
from fractions import Fraction
import pcore

names = [f"x{i}" for i in range(12)] + ["tau"]
ctx = flint.fmpq_mpoly_ctx.get(names, "lex")
gens = ctx.gens()
X = list(gens[:12])
TAU = gens[12]
r = [X[0], X[2], X[4]]
y = [X[1], X[3], X[5]]
pp = [X[6], X[8], X[10]]
qq = [X[7], X[9], X[11]]
F0 = sum(v**3 for v in X)


def h0(v):
    return v[0]**3 + v[1]**3 + v[2]**3


def Mform(xpar, yv=y, pv=pp, qv=qq):
    """M_x(y,p,q) = sum_{i,j} x_(i-j) y_(i+j) p_i q_j ; xpar: 3 coefficients (numbers or polynomials)"""
    s = 0
    for i in range(3):
        for j in range(3):
            s = s + xpar[(i - j) % 3] * yv[(i + j) % 3] * pv[i] * qv[j]
    return s


def fmod(c, p):
    c = flint.fmpq(c)
    return (int(c.p) % p) * pow(int(c.q) % p, p - 2, p) % p


def split_tau(G, p, N=None):
    """G: fmpq_mpoly, divisible by tau.  returns dict j -> pcore.Poly mod p (coefficient of tau^j)"""
    byj = {}
    for e, c in G.to_dict().items():
        j = int(e[12])
        if N is not None and j > N:
            continue
        k = pcore.key_of(e[:12])
        byj.setdefault(j, {})
        byj[j][k] = (byj[j].get(k, 0) + fmod(c, p)) % p
    assert 0 not in byj, "arc does not start at F0"
    return {j: pcore.from_dict(d, p) for j, d in byj.items()}


def trunc_tau(G, N):
    """drop terms of tau-degree > N"""
    d = {e: c for e, c in G.to_dict().items() if int(e[12]) <= N}
    return ctx.from_dict(d) if d else ctx.from_dict({})
