# Small exact field classes (own implementation; only ring arithmetic of flint fmpq_poly is used).
from fractions import Fraction as Fr
from flint import fmpq_poly, fmpq


def to_fmpq(c):
    if isinstance(c, Fr):
        return fmpq(c.numerator, c.denominator)
    if isinstance(c, int):
        return fmpq(c)
    return c


class NF:
    """Element of QQ[t]/(m), m irreducible (then a field).  Inverses via xgcd, checked."""
    __slots__ = ("p", "K")

    def __init__(self, p, K):
        self.p = p
        self.K = K

    def _c(self, o):
        if isinstance(o, NF):
            return o.p
        return fmpq_poly([to_fmpq(o)])

    def __add__(self, o):
        return NF(self.p + self._c(o), self.K)

    __radd__ = __add__

    def __sub__(self, o):
        return NF(self.p - self._c(o), self.K)

    def __rsub__(self, o):
        return NF(self._c(o) - self.p, self.K)

    def __neg__(self):
        return NF(-self.p, self.K)

    def __mul__(self, o):
        if isinstance(o, NF):
            return NF((self.p * o.p) % self.K.m, self.K)
        return NF(self.p * to_fmpq(o), self.K)

    __rmul__ = __mul__

    def inv(self):
        g, s, t = self.p.xgcd(self.K.m)
        if g.degree() != 0:
            raise ZeroDivisionError("not invertible (gcd degree %d)" % g.degree())
        r = NF(s % self.K.m, self.K)   # g is monic 1
        assert ((r.p * self.p) % self.K.m) == fmpq_poly([1])
        return r

    def __truediv__(self, o):
        if isinstance(o, NF):
            return self * o.inv()
        return NF(self.p / to_fmpq(o), self.K)

    def __rtruediv__(self, o):
        return self.inv() * o

    def __eq__(self, o):
        return (self.p - self._c(o)).is_zero()

    def __ne__(self, o):
        return not self.__eq__(o)

    def __hash__(self):
        return hash(str(self.p))

    def is_zero(self):
        return self.p.is_zero()

    def __repr__(self):
        return "NF(%s)" % self.p


class NumberField:
    def __init__(self, m):
        self.m = m
        self.deg = m.degree()
        self.zero = NF(fmpq_poly([0]), self)
        self.one = NF(fmpq_poly([1]), self)
        self.gen = NF(fmpq_poly([0, 1]) % m, self)

    def elem(self, p):
        if isinstance(p, fmpq_poly):
            return NF(p % self.m, self)
        return NF(fmpq_poly([to_fmpq(p)]), self)

    def lift(self, vec):
        return [self.elem(c) for c in vec]


def poly_from_fractions(coeffs):
    return fmpq_poly([to_fmpq(c) for c in coeffs])


class MP:
    """Thin wrapper around flint fmpq_mpoly so that generic code can multiply by Fractions."""
    __slots__ = ("p",)

    def __init__(self, p):
        self.p = p

    @staticmethod
    def _c(o):
        if isinstance(o, MP):
            return o.p
        return to_fmpq(o)

    def __add__(self, o):
        return MP(self.p + MP._c(o))

    __radd__ = __add__

    def __sub__(self, o):
        return MP(self.p - MP._c(o))

    def __rsub__(self, o):
        return MP(MP._c(o) - self.p)

    def __neg__(self):
        return MP(-self.p)

    def __mul__(self, o):
        return MP(self.p * MP._c(o))

    __rmul__ = __mul__

    def __truediv__(self, o):
        assert not isinstance(o, MP)
        return MP(self.p * (1 / to_fmpq(o)))

    def __eq__(self, o):
        return (self.p - MP._c(o)).is_zero()

    def __ne__(self, o):
        return not self.__eq__(o)

    def is_zero(self):
        return self.p.is_zero()

    def __repr__(self):
        return str(self.p)


def mp_ring(names):
    from flint import fmpq_mpoly_ctx, Ordering
    ctx = fmpq_mpoly_ctx.get(tuple(names), Ordering.degrevlex)
    gens = [MP(g) for g in ctx.gens()]
    zero = MP(ctx.from_dict({}))
    one = zero + 1
    return ctx, gens, zero, one


# ---- univariate polynomials over a field, as coefficient lists (low -> high) ----
def ptrim(p):
    p = list(p)
    while p and p[-1] == 0:
        p.pop()
    return p


def prem(a, b, zero, one):
    """remainder of a mod b (b nonzero), field coefficients."""
    a = ptrim(a)
    b = ptrim(b)
    inv = one / b[-1]
    while len(a) >= len(b):
        f = a[-1] * inv
        sh = len(a) - len(b)
        for i in range(len(b)):
            a[sh + i] = a[sh + i] - f * b[i]
        a = ptrim(a)
    return a


def pgcd(a, b, zero, one):
    a = ptrim(a)
    b = ptrim(b)
    while b:
        a, b = b, prem(a, b, zero, one)
    inv = one / a[-1]
    return [c * inv for c in a]


def peval(p, x, zero):
    s = zero
    for c in reversed(p):
        s = s * x + c
    return s


# ---------- rational functions QQ(t) ----------
class RF:
    """num/den with fmpq_poly, den monic, gcd(num,den)=1."""
    __slots__ = ("n", "d")

    def __init__(self, n, d=None, normalise=True):
        if d is None:
            d = fmpq_poly([1])
        if normalise:
            if n.is_zero():
                d = fmpq_poly([1])
            else:
                g = n.gcd(d)
                if g.degree() > 0:
                    n = n // g
                    d = d // g
                lc = d.leading_coefficient()
                if lc != 1:
                    n = n * (1 / lc)
                    d = d * (1 / lc)
        self.n = n
        self.d = d

    @staticmethod
    def _c(o):
        if isinstance(o, RF):
            return o
        return RF(fmpq_poly([to_fmpq(o)]), None, False)

    def __add__(self, o):
        o = RF._c(o)
        if self.d == o.d:
            return RF(self.n + o.n, self.d)
        return RF(self.n * o.d + o.n * self.d, self.d * o.d)

    __radd__ = __add__

    def __neg__(self):
        return RF(-self.n, self.d, False)

    def __sub__(self, o):
        return self + (-RF._c(o))

    def __rsub__(self, o):
        return RF._c(o) + (-self)

    def __mul__(self, o):
        o = RF._c(o)
        return RF(self.n * o.n, self.d * o.d)

    __rmul__ = __mul__

    def inv(self):
        if self.n.is_zero():
            raise ZeroDivisionError
        return RF(self.d, self.n)

    def __truediv__(self, o):
        return self * RF._c(o).inv()

    def __rtruediv__(self, o):
        return RF._c(o) * self.inv()

    def __eq__(self, o):
        o = RF._c(o)
        return (self.n * o.d - o.n * self.d).is_zero()

    def __ne__(self, o):
        return not self.__eq__(o)

    def is_zero(self):
        return self.n.is_zero()

    def __repr__(self):
        return "(%s)/(%s)" % (self.n, self.d)


RF_ZERO = RF(fmpq_poly([0]))
RF_ONE = RF(fmpq_poly([1]))
RF_T = RF(fmpq_poly([0, 1]))


# ---------- simple algebraic extension B[alpha]/(m), m monic over a field B ----------
class ExtField:
    def __init__(self, m, bzero, bone):
        """m: list of base-field coefficients low->high, monic."""
        assert m[-1] == bone
        self.m = m
        self.deg = len(m) - 1
        self.bzero = bzero
        self.bone = bone
        self.zero = Ext([bzero] * self.deg, self)
        self.one = Ext([bone] + [bzero] * (self.deg - 1), self)
        self.gen = Ext([bzero, bone] + [bzero] * (self.deg - 2), self) if self.deg >= 2 else Ext([bzero - m[0]], self)

    def from_base(self, c):
        return Ext([c] + [self.bzero] * (self.deg - 1), self)


class Ext:
    __slots__ = ("c", "K")

    def __init__(self, c, K):
        self.c = c
        self.K = K

    def _l(self, o):
        if isinstance(o, Ext):
            return o
        return Ext([self.K.bzero + o] + [self.K.bzero] * (self.K.deg - 1), self.K)

    def __add__(self, o):
        o = self._l(o)
        return Ext([a + b for a, b in zip(self.c, o.c)], self.K)

    __radd__ = __add__

    def __neg__(self):
        return Ext([-a for a in self.c], self.K)

    def __sub__(self, o):
        o = self._l(o)
        return Ext([a - b for a, b in zip(self.c, o.c)], self.K)

    def __rsub__(self, o):
        return self._l(o) - self

    def __mul__(self, o):
        if not isinstance(o, Ext):
            return Ext([a * o for a in self.c], self.K)
        d = self.K.deg
        prod = [self.K.bzero] * (2 * d - 1)
        for i, a in enumerate(self.c):
            if a == 0:
                continue
            for j, b in enumerate(o.c):
                prod[i + j] = prod[i + j] + a * b
        m = self.K.m
        for k in range(2 * d - 2, d - 1, -1):
            f = prod[k]
            if f == 0:
                continue
            for i in range(d):
                prod[k - d + i] = prod[k - d + i] - f * m[i]
        return Ext(prod[:d], self.K)

    __rmul__ = __mul__

    def inv(self):
        # solve self * x = 1 by linear algebra over the base field (checked)
        d = self.K.deg
        K = self.K
        cols = []
        e = K.one
        basis = []
        for j in range(d):
            basis.append(e)
            cols.append((self * e).c)
            e = e * K.gen
        # matrix M[i][j] = cols[j][i]; solve M x = e_0
        M = [[cols[j][i] for j in range(d)] + [K.bone if i == 0 else K.bzero] for i in range(d)]
        # gaussian elimination
        for c in range(d):
            p = None
            for i in range(c, d):
                if not (M[i][c] == 0):
                    p = i
                    break
            if p is None:
                raise ZeroDivisionError("zero divisor in extension")
            M[c], M[p] = M[p], M[c]
            iv = K.bone / M[c][c]
            M[c] = [x * iv for x in M[c]]
            for i in range(d):
                if i != c and not (M[i][c] == 0):
                    f = M[i][c]
                    M[i] = [x - f * y_ for x, y_ in zip(M[i], M[c])]
        r = Ext([M[i][d] for i in range(d)], K)
        assert (r * self) == K.one
        return r

    def __truediv__(self, o):
        if isinstance(o, Ext):
            return self * o.inv()
        return Ext([a / o for a in self.c], self.K)

    def __rtruediv__(self, o):
        return self.inv() * o

    def __eq__(self, o):
        o = self._l(o)
        return all(a == b for a, b in zip(self.c, o.c))

    def __ne__(self, o):
        return not self.__eq__(o)

    def is_zero(self):
        return all(a == 0 for a in self.c)

    def __repr__(self):
        return "Ext(%s)" % (self.c,)


def _rf_pow(self, n):
    r = RF_ONE
    b = self
    while n:
        if n & 1:
            r = r * b
        b = b * b
        n >>= 1
    return r


RF.__pow__ = _rf_pow


def _nf_pow(self, n):
    r = self.K.one
    b = self
    while n:
        if n & 1:
            r = r * b
        b = b * b
        n >>= 1
    return r


NF.__pow__ = _nf_pow
