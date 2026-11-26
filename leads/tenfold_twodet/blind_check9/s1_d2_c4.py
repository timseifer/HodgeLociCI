# D2: excess intersection formula; C4: Wu class of cubic tenfold
import sympy as sp
from math import comb
h = sp.symbols('h')
print("D2: f(m) from (1+h)^(m+1)/(1+3h), degree-m coefficient")
for m in range(-1, 6):
    if m == -1:
        val = 0
    else:
        ser = sp.series((1+h)**(m+1)/(1+3*h), h, 0, m+1).removeO()
        val = sp.Poly(ser, h).coeff_monomial(h**m)
    closed = sp.Rational(1 - (-2)**(m+1), 3)
    print(m, val, closed, val == closed)
# independent derivation of the excess bundle: c(E) = c(TX|Z) c(TZ) / (c(TP1|Z) c(TP2|Z))
for m in range(0, 6):
    cE = (1+h)**12/(1+3*h) * (1+h)**(m+1) / ((1+h)**6*(1+h)**6)
    ser = sp.series(cE, h, 0, m+1).removeO()
    print("  excess-bundle check m=%d:" % m, sp.Poly(ser, h).coeff_monomial(h**m))
# self-intersection: c_5(N_{P/X}), N = TX|P / TP
ser = sp.series((1+h)**12/((1+3*h)*(1+h)**6), h, 0, 6).removeO()
print("c_5(N_P/X) =", sp.Poly(ser, h).coeff_monomial(h**5))

print("\nC4: Wu class. w(X) = (1+h)^12/(1+3h) mod 2")
N = 11  # truncate at h^11 (h^k != 0 mod 2 for k<=10)
def polmul(a, b):
    c = [0]*N
    for i, x in enumerate(a):
        if x:
            for j, y in enumerate(b):
                if y and i+j < N:
                    c[i+j] ^= 1
    return c
# w mod 2 computed honestly from c(X) = (1+h)^12/(1+3h) over Z then reduced
ser = sp.series((1+h)**12/(1+3*h), h, 0, N).removeO()
w = [int(sp.Poly(ser, h).coeff_monomial(h**k)) % 2 for k in range(N)]
w11 = [comb(11, k) % 2 for k in range(N)]
print("w mod 2      :", w)
print("(1+h)^11 mod2:", w11, w == w11)
# solve Sq(v) = w with v = sum v_k h^k, Sq(h^k) = (h+h^2)^k
one = [1]+[0]*(N-1)
u = [0, 1, 1] + [0]*(N-3)
pw = [one]
for k in range(1, N):
    pw.append(polmul(pw[-1], u))
v = [0]*N
rem = w[:]
for k in range(N):
    if rem[k]:
        v[k] = 1
        rem = [(a ^ b) for a, b in zip(rem, pw[k])]
print("v (coeffs of h^k, k=0..10):", v, " remainder:", rem)
print("v_k for k>5 must vanish:", v[6:], "; coefficient of h^5 (Wu class in degree 10):", v[5])
print("compare C(10-k,k) mod 2 (CP^10 pattern):", [comb(10-k, k) % 2 if 10-k >= k else 0 for k in range(N)])
# consistency with known numbers
print("parity checks: P.P=-21 vs P.h^5=1:", (-21) % 2 == 1 % 2, "; h^5.h^5=3 vs 3:", True)
# rank / signature bookkeeping
prim = (2**12 + 2)//3
hn = [comb(12, 3*(q+1)-12) if 0 <= 3*(q+1)-12 <= 12 else 0 for q in range(0, 11)]
print("primitive rank:", prim, " h^{10-q,q}_prim:", hn, sum(hn))
pos = hn[4] + hn[6]; neg = hn[3] + hn[5] + hn[7]
print("signature of L (pos,neg):", (pos, neg), " H:", (pos+1, neg), " sign(H) mod 8 =", (pos+1-neg) % 8, "vs h^5.h^5 mod 8 =", 3)
print("model A2 + U^438 + E8(-1)^61 has signature", (2+438, 438+8*61))
