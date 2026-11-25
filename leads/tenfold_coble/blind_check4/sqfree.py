import sys, re
from flint import fmpq, fmpq_mat, fmpq_poly, fmpz, nmod_poly, fmpz_poly
fn = sys.argv[1]
lines = [l.strip() for l in open(fn) if l.strip()]
def parse(s):
    rows = re.findall(r'\{([^{}]*)\}', s)
    M = []
    for r in rows:
        ent = []
        for e in r.split(','):
            e = e.strip()
            if '/' in e:
                a,b = e.split('/'); ent.append(fmpq(int(a),int(b)))
            else:
                ent.append(fmpq(int(e)))
        M.append(ent)
    return fmpq_mat(M)
M1 = parse(lines[0]); M2 = parse(lines[1])
print("sizes", M1.nrows(), M1.ncols(), M2.nrows(), M2.ncols())
d2 = M2.det(); d1 = M1.det()
print("det M2 != 0:", d2 != 0, " det M1 != 0:", d1 != 0)
C = M2.inv() * M1        # roots of charpoly = l1/l2 at the points
chi = C.charpoly()
print("charpoly degree", chi.degree())
g = chi.gcd(chi.derivative())
print("gcd(chi, chi') degree:", g.degree())
# factor structure over QQ
num = chi.numer()   # fmpz_poly
c, fac = num.factor()
print("irreducible factors over QQ (degree, multiplicity):", sorted([(f.degree(), m) for f, m in fac]))
print("content/leading:", str(c)[:60], " max coefficient bits of primitive part:", max(abs(x).bit_length() if hasattr(abs(x),'bit_length') else int(abs(x)).bit_length() for x in [int(a) for a in num.coeffs()]))
# discriminant mod a few primes (independent of gcd over QQ)
for p in (32003, 31991, 30011, 1000003):
    lc = int(num.coeffs()[-1]) % p
    fp = nmod_poly([int(a) % p for a in num.coeffs()], p)
    gp = fp.gcd(fp.derivative())
    print(" mod", p, ": lead coeff nonzero", lc != 0, " deg", fp.degree(), " gcd(f,f') degree", gp.degree())
# cross-check with the binary form directly at sample points: det(s*M2 - t*M1) vs det(M2)*t^72*chi(s/t)
import random
random.seed(1)
ok = True
for _ in range(3):
    s = fmpq(random.randint(-9,9)); t = fmpq(random.randint(1,9))
    lhs = (M2*s - M1*t).det()
    rhs = d2 * (t**72) * chi(s/t)
    ok = ok and (lhs == rhs)
print("binary form identity det(s*M2 - t*M1) = det(M2) t^72 chi(s/t) at samples:", ok)
