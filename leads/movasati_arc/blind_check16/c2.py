from sympy import symbols, series, binomial, Matrix, gcd, expand, Rational
h=symbols('h')
for m in range(0,5):
    c=series((1+h)**(m+1)/(1+3*h),h,0,m+1).removeO().coeff(h,m)
    print("m",m,"excess c_m",c,"f(m)",Rational(1-(-2)**(m+1),3))
print("P.P via normal bundle c_4((1+h)^5/(1+3h)):", series((1+h)**5/(1+3*h),h,0,5).removeO().coeff(h,4))
r,s=symbols('r s')
G=Matrix([[3,r+s],[r+s,11*r**2-2*r*s+11*s**2]]); print("det",expand(G.det()))
hits={}
for a in range(-30,31):
    for b in range(-30,31):
        if b==0 or gcd(a,b)!=1: continue
        v=16*a*a-4*a*b+16*b*b
        if v<=40: hits.setdefault(v,[]).append((a,b))
print(sorted(hits.items()))
