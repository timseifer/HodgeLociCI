# Q1: Chern-class side. (Sigma.Sigma)_X = c_k(N_{Sigma/X}),  c(N_{Sigma/X}) = (1+h)^(2k+2) / ((1+3h) c(T_Sigma))
# predicted N = c_k( N^v_{Sigma/H} (3h) ),  c(N_{Sigma/H}) = (1+h)^(2k+1)/c(T_Sigma)
import sympy as sp
t = sp.symbols('t')
def trunc(expr, k, gens):
    # keep terms of total degree <= k in gens
    p = sp.Poly(sp.expand(expr), *gens)
    return sum(c*sp.prod([g**e for g,e in zip(gens,m)]) for m,c in p.terms() if sum(m)<=k)
def inv(expr, k, gens):
    # inverse of 1 + (higher) up to degree k
    x = trunc(expr,k,gens) - 1
    res = 0; pw = 1
    for i in range(k+1):
        res += (-1)**i*pw
        pw = trunc(pw*x,k,gens)
    return trunc(res,k,gens)
def degpart(expr,k,gens):
    p = sp.Poly(sp.expand(expr), *gens)
    return sum(c*sp.prod([g**e for g,e in zip(gens,m)]) for m,c in p.terms() if sum(m)==k)
def chern_twist_dual_top(cN, k, h, gens, r=None):
    # c_k(N^v (x) O(3h)) for rank k bundle N with total chern class cN: sum_i c_i(N^v) (3h)^(k-i) = sum (-1)^i c_i (3h)^(k-i)
    tot = 0
    for i in range(k+1):
        tot += (-1)**i*degpart(cN,i,gens)*(3*h)**(k-i)
    return sp.expand(tot)
def run(name,k,h,cT,gens,integ):
    cNX = trunc((1+h)**(2*k+2)*inv((1+3*h)*cT,k,gens),k,gens)
    cNH = trunc((1+h)**(2*k+1)*inv(cT,k,gens),k,gens)
    SS = integ(degpart(cNX,k,gens)); m = integ(sp.expand(h**k))
    N = integ(degpart(chern_twist_dual_top(cNH,k,h,gens),k,gens))
    ckNH = integ(degpart(cNH,k,gens))
    print(f"{name}: k={k} m={m} Sigma.Sigma={SS} disc=3SS-m^2={3*SS-m*m}  predicted N={N}  (-1)^k 2N={(-1)**k*2*N}  c_k(N_Sigma/H)={ckNH} (m^2={m*m})")
h=sp.symbols('h'); a,b,e,f=sp.symbols('a b e f')
def int1(top,d):  # single generator h with h^k = d
    return lambda expr: sp.Poly(expr,h).all_coeffs()[0]*d if expr!=0 else 0
run("plane in P4",2,h,(1+h)**3,[h],lambda x: sp.Poly(x,h).coeff_monomial(h**2))
# cubic scroll F1: e^2=-1, ef=1, f^2=0 ; h=e+2f ; c1 = 2e+3f ; c2 = 4 pt. encode pt via monomials
def intF1(x):
    p=sp.Poly(sp.expand(x),e,f,sp.Symbol('pt'))
    pt=sp.Symbol('pt'); tot=0
    for mon,c in p.terms():
        if mon==(2,0,0): tot+=-c
        elif mon==(1,1,0): tot+=c
        elif mon==(0,2,0): tot+=0
        elif mon==(0,0,1): tot+=c
        else: raise Exception(mon)
    return tot
# handle c2 = 4 pt: treat pt as degree-2 class: use generator trick: gens e,f and pt separately
pt=sp.Symbol('pt')
def trunc2(expr):
    p = sp.Poly(sp.expand(expr), e,f,pt)
    return sum(c*e**m[0]*f**m[1]*pt**m[2] for m,c in p.terms() if m[0]+m[1]+2*m[2]<=2)
cT = 1+(2*e+3*f)+4*pt
hh = e+2*f
x = cT*(1+3*hh)-1
invv = trunc2(1 - x + x*x)
cNX = trunc2((1+hh)**6*invv)
def deg2(expr):
    p = sp.Poly(sp.expand(expr), e,f,pt)
    return sum(c*e**m[0]*f**m[1]*pt**m[2] for m,c in p.terms() if m[0]+m[1]+2*m[2]==2)
def deg1(expr):
    p = sp.Poly(sp.expand(expr), e,f,pt)
    return sum(c*e**m[0]*f**m[1]*pt**m[2] for m,c in p.terms() if m[0]+m[1]+2*m[2]==1)
SS=intF1(deg2(cNX)); m=intF1(sp.expand(hh**2))
y = cT-1
cNH = trunc2((1+hh)**5*(1-y+y*y))
N = intF1(sp.expand(9*hh**2 - 3*hh*deg1(cNH) + deg2(cNH)))
print(f"cubic scroll in P4: k=2 m={m} Sigma.Sigma={SS} disc={3*SS-m*m} predicted N={N} (+2N={2*N}) c_2(N_Sigma/H)={intF1(deg2(cNH))}")
K=-2*e-3*f
print("   surface formula 6h^2+3hK+K^2-chi_top =", 6*intF1(sp.expand(hh**2))+3*intF1(sp.expand(hh*K))+intF1(sp.expand(K*K))-4)
run("P3 in P6",3,h,(1+h)**4,[h],lambda x: sp.Poly(x,h).coeff_monomial(h**3))
def intP1P2(x): return sp.Poly(sp.expand(x),a,b).coeff_monomial(a*b**2)
run("P1xP2 in P5 in P6",3,a+b,(1+a)**2*(1+b)**3,[a,b],intP1P2)
# V5: c1=2h, c2 = (12/5) h^2, c3 = (4/5) h^3 (numerically), h^3=5
run("V5 = G(2,5) n P6",3,h,1+2*h+sp.Rational(12,5)*h**2+sp.Rational(4,5)*h**3,[h],lambda x: 5*sp.Poly(x,h).coeff_monomial(h**3))
def intP2P2(x): return sp.Poly(sp.expand(x),a,b).coeff_monomial(a**2*b**2)
run("P2xP2 in P8",4,a+b,(1+a)**3*(1+b)**3,[a,b],intP2P2)
# linear spaces: P^k in cubic 2k-fold
for k in range(1,6):
    run(f"P^{k} in P^{2*k}",k,h,(1+h)**(k+1),[h],lambda x,k=k: sp.Poly(x,h).coeff_monomial(h**k))
