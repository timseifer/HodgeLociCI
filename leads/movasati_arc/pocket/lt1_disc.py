# lt1: disc(Z) = 3 Z.Z - deg(Z)^2 for smooth 4-folds Z in a cubic eightfold X in P^9. EXACT (sympy, truncated Chow rings).
# Z.Z = int_Z c_4(N_{Z/X}), c(N_{Z/X}) = (1+H)^10 / ((1+3H) c(T_Z)).
import sympy as sp
from math import isqrt
def trunc(e, gens, degs):  # keep monomials allowed by relations gens[i]^(degs[i]+1)=0 and total degree <= 4
    e=sp.expand(e); p=sp.Poly(e,*gens); out=0
    for mon,c in p.terms():
        if all(m<=d for m,d in zip(mon,degs)) and sum(mon)<=4: out+=c*sp.prod([g**m for g,m in zip(gens,mon)])
    return sp.expand(out)
def inv(e, gens, degs):
    # 1/(1+x) series to degree 4
    x=sp.expand(e-1); s=0
    for k in range(5): s+=(-x)**k
    return trunc(s,gens,degs)
def part4(e,gens): return sum(c*sp.prod([g**m for g,m in zip(gens,mon)]) for mon,c in sp.Poly(sp.expand(e),*gens).terms() if sum(mon)==4)
def report(name, gens, degs, cT, H, integ):
    cN=trunc((1+H)**10*inv(1+3*H,gens,degs)*inv(cT,gens,degs),gens,degs)
    zz=integ(part4(cN,gens)); dg=integ(part4(sp.expand(H**4),gens)); ds=3*zz-dg**2
    sq= ds>0 and isqrt(ds)**2==ds
    print(f"RESULT {name}: deg {dg}, Z.Z {zz}, disc {ds}, nonzero square {sq}")
    return ds
h=sp.symbols('h')
# complete intersections in P^9: c(T)=(1+h)^10/prod(1+d h), int h^4 = prod d
for t in [(1,1,1,1,1),(1,1,1,1,2),(1,1,1,2,2),(1,1,2,2,2),(1,2,2,2,2),(1,1,1,1,3)]:
    pr=sp.prod(t); cT=trunc((1+h)**10*inv(trunc(sp.prod([1+d*h for d in t]),[h],[4]),[h],[4]),[h],[4])
    report("CI"+str(t),[h],[4],cT,h,lambda e,pr=pr: sp.Poly(e,h).coeff_monomial(h**4)*pr)
# Segre P^m x P^n, H = a + b
a,b=sp.symbols('a b')
def seg(name,m,n,extra=None):
    cT=trunc((1+a)**(m+1)*(1+b)**(n+1),[a,b],[m,n]); H=a+b
    def integ(e): return sp.Poly(e,a,b).coeff_monomial(a**m*b**n)
    return report(name,[a,b],[m,n],cT,H,integ)
seg("P^1 x P^3",1,3); seg("P^2 x P^2",2,2)
# P^1 x Q^3: Q^3 in P^4, Chow ring with b^4 = 0 and int b^3 = 2
cT=trunc((1+a)**2*(1+b)**5*inv(1+2*b,[a,b],[1,3]),[a,b],[1,3])
report("P^1 x Q^3",[a,b],[1,3],cT,a+b,lambda e: 2*sp.Poly(e,a,b).coeff_monomial(a*b**3))
# del Pezzo 4-fold of degree 5 = G(2,5) n P^7. Use Schubert calculus: tangent of G = S^* (x) Q.
# Chow ring of G(2,5) via Chern roots of S^*: x1,x2; H = x1+x2. Integrate over G(2,5) by the localization-free formula:
# int_G f(x1,x2) = coefficient extraction: int_G f = [x1^4 x2^4]... use the standard formula
# int_{G(2,5)} f = (1/2) * Res-type: sum over symmetric: coefficient of x1^4 x2^4 in f*(x1-x2)^2 * (-1)^? -- do it via
# the known Schubert basis instead: work in sympy with sigma1, sigma2 and relations of G(2,5).
s1,s2=sp.symbols('s1 s2')
# c(S^*) = 1 + s1 + s2 ; c(Q) = 1/c(S) with c(S) = 1 - s1 + s2. Relations: degree-4 and degree-5 parts of 1/c(S) vanish.
cSinv=0; x=-(-s1+s2)
for k in range(8): cSinv+=x**k
cQ=sp.expand(cSinv)
def deg(mon): return mon[0]+2*mon[1]
def part(e,d): return sum(c*s1**m[0]*s2**m[1] for m,c in sp.Poly(sp.expand(e),s1,s2).terms() if deg(m)==d)
q4=part(cQ,4); q5=part(cQ,5)
G=sp.groebner([q4,q5]+[ s1**i*s2**j for i in range(13) for j in range(7) if i+2*j>6 ],s1,s2,order='grevlex')
def red(e): return G.reduce(sp.expand(e))[1]
# top class: s1^6 has degree 5 on G(2,5); define int via s2^3 ... compute normalising: int s1^6 = 5
top=red(s1**6)
def intG(e):
    e=red(part(e,6) if True else e)
    return sp.nsimplify(5*sp.simplify(e/top)) if e!=0 else 0
# T_G = S^* (x) Q: Chern class via splitting is messy; use c(T_G) for G(2,5) through the formula c(S^*(x)Q) computed
# from roots: S^* roots x1,x2 (s1=x1+x2,s2=x1x2); Q of rank 3 with c(Q)=cQ. c(x (x) Q) = sum_k c_k(Q)(1+x)^(3-k).
x1,x2=sp.symbols('x1 x2')
cQx=sp.expand(cQ.subs({s1:x1+x2,s2:x1*x2}))
def cQpart(k): return sp.expand(part(cQ,k).subs({s1:x1+x2,s2:x1*x2}))
def ctw(xx): return sum(cQpart(k)*(1+xx)**(3-k) for k in range(4))
cTG=sp.expand(ctw(x1)*ctw(x2))
# symmetrise back to s1, s2 (truncate to degree 6)
def tosym(e):
    e=sp.expand(e); res=0
    P=sp.Poly(e,x1,x2)
    for d in range(7):
        ed=sum(c*x1**m[0]*x2**m[1] for m,c in P.terms() if m[0]+m[1]==d)
        if ed==0: continue
        # express symmetric ed in s1,s2
        A=sp.symbols('A0:%d'%(d//2+1))
        cand=sum(A[j]*s1**(d-2*j)*s2**j for j in range(d//2+1))
        eqs=sp.Poly(sp.expand(cand.subs({s1:x1+x2,s2:x1*x2})-ed),x1,x2).coeffs()
        sol=sp.solve(eqs,A,dict=True)[0]; res+=cand.subs(sol)
    return sp.expand(res)
cTGs=tosym(cTG)
# Z = zero locus of two sections of O(1): c(T_Z) = c(T_G)/(1+s1)^2, int_Z f = int_G f*s1^2
gens=[s1,s2]
def truncG(e,dmax): return sum(c*s1**m[0]*s2**m[1] for m,c in sp.Poly(sp.expand(e),s1,s2).terms() if deg(m)<=dmax)
def invG(e):
    xx=sp.expand(e-1); s=0
    for k in range(7): s+=(-xx)**k
    return truncG(s,4)
cTZ=truncG(cTGs*invG((1+s1)**2),4)
cN=truncG((1+s1)**10*invG(1+3*s1)*invG(cTZ),4)
zz=intG(part(cN,4)*s1**2); dg=intG(s1**6)
print("RESULT dP5 = G(2,5) n P^7 (calibration, expect disc 56): deg",dg,", Z.Z",zz,", disc",3*zz-dg**2)
# Smooth rational normal scrolls S(a1..a4) = P(O(a1)+...+O(a4)) over P^1, a_i >= 1, H = tautological class.
f,H=sp.symbols('f H')
for A in [(1,1,1,1),(1,1,1,2),(1,1,2,2),(1,1,1,3),(1,2,2,2),(1,1,2,3),(1,1,1,4)]:
    d=sum(A)
    def red(e):
        e=sp.expand(e)
        e=sp.Poly(e,f,H)
        out=0
        for (i,j),c in e.terms():
            if i>=2: continue
            out+=c*f**i*H**j
        out=sp.expand(out)
        # reduce H^4 = d H^3 f, H^k with k>4 -> 0 in degree >4 (dropped by truncation)
        out=sp.expand(out.subs(H**4, d*H**3*f)) if False else out
        return out
    def truncS(e):
        return sum(c*f**m[0]*H**m[1] for m,c in sp.Poly(sp.expand(e),f,H).terms() if m[0]<=1 and sum(m)<=4)
    def integS(e):
        # int f H^3 = 1, int H^4 = d
        P=sp.Poly(sp.expand(e),f,H); return P.coeff_monomial(f*H**3)+d*P.coeff_monomial(H**4)
    def invS(e):
        xx=sp.expand(e-1); s=0
        for k in range(5): s+=(-xx)**k
        return truncS(s)
    cT=truncS((1+2*f)*sp.prod([1+H-a*f for a in A]))
    cN=truncS((1+H)**10*invS(1+3*H)*invS(cT))
    zz=integS(part4(cN,[f,H])); dg=integS(H**4); ds=3*zz-dg**2
    print(f"RESULT scroll S{A} (in P^{d+3}): deg {dg}, Z.Z {zz}, disc {ds}, nonzero square {ds>0 and isqrt(ds)**2==ds}")
