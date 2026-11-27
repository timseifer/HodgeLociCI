# lc1: pre-registered test PREREG_linear_cycles.md, T-A and T-B. MOD p.
# usage: python3 lc1_linear_cycles.py p z jetfile
import sys, re, itertools
p=int(sys.argv[1]); z=int(sys.argv[2])%p; jet=sys.argv[3]
def parse(s):
    T={}
    s=s.replace(' ','').replace('-','+-')
    for term in s.split('+'):
        if not term: continue
        c=1; mon=[0]*10
        for f in term.split('*'):
            m=re.fullmatch(r'(-?)x_(\d+)(?:\^(\d+))?',f)
            if m:
                if m.group(1): c=-c
                mon[int(m.group(2))]+=int(m.group(3) or 1)
            else: c*=int(f)
        T[tuple(mon)]=(T.get(tuple(mon),0)+c)%p
    return {k:v for k,v in T.items() if v}
lines=open(jet).read().strip().split('\n'); T1=parse(lines[0])
def matchings(idx):
    if not idx: yield []; return
    a=idx[0]
    for i in range(1,len(idx)):
        for rest in matchings(idx[1:i]+idx[i+1:]): yield [(a,idx[i])]+rest
zp=[pow(z,e,p) for e in range(6)]
def sqfree_restriction(T,L):
    # L: list of (a,b,e): x_a = z^e x_b. returns dict of square-free monomials in the b-variables
    sub={}
    for (a,b,e) in L: sub[a]=(b,zp[e]); sub[b]=(b,1)
    out={}
    for mon,c in T.items():
        key=[]; cc=c; ok=True
        for i,k in enumerate(mon):
            if k:
                bb,f=sub[i]; cc=cc*pow(f,k,p)%p; key+= [bb]*k
        if len(set(key))<len(key): continue
        key=tuple(sorted(key)); out[key]=(out.get(key,0)+cc)%p
    return {k:v for k,v in out.items() if v}
def passes(T,L): return not sqfree_restriction(T,L)
P1=[(2*i,2*i+1,1) for i in range(5)]; P2=[(2*i,2*i+1,3 if i<3 else 1) for i in range(5)]
# control direction f_0 h_1 x_7 (tangent to V_P1 and V_P2)
def polymul(A,B):
    C={}
    for m1,c1 in A.items():
        for m2,c2 in B.items():
            m=tuple(x+y for x,y in zip(m1,m2)); C[m]=(C.get(m,0)+c1*c2)%p
    return {k:v for k,v in C.items() if v}
def lin(d):
    out={}
    for i,c in d.items():
        m=[0]*10; m[i]=1; out[tuple(m)]=c%p
    return out
ctl=polymul(polymul(lin({0:1,1:-zp[1]}),lin({2:1,3:-zp[3]})),lin({7:1}))
print("control f0 h1 x7: P1 pass",passes(ctl,P1),"P2 pass",passes(ctl,P2))
print("T_1: P1 pass",passes(T1,P1),"P2 pass",passes(T1,P2), "; T_1 has",len(T1),"monomials")
S=[]; n=0
for M in matchings(list(range(10))):
    for es in itertools.product((1,3,5),repeat=5):
        L=[(a,b,e) for (a,b),e in zip(M,es)]; n+=1
        if passes(T1,L): S.append(L)
print("linear P^4 tested:",n,"; tangent to T_1:",len(S))
for L in S[:50]: print("  ",L)
# T-B: Gram matrix
def eqs(L):
    rows=[]
    for (a,b,e) in L:
        r=[0]*10; r[a]=1; r[b]=(-zp[e])%p; rows.append(r)
    return rows
def rank(rows):
    M=[r[:] for r in rows]; rk=0; cols=len(M[0]) if M else 0
    for c in range(cols):
        piv=next((i for i in range(rk,len(M)) if M[i][c]),None)
        if piv is None: continue
        M[rk],M[piv]=M[piv],M[rk]; inv=pow(M[rk][c],p-2,p)
        M[rk]=[x*inv%p for x in M[rk]]
        for i in range(len(M)):
            if i!=rk and M[i][c]:
                f=M[i][c]; M[i]=[(x-f*y)%p for x,y in zip(M[i],M[rk])]
        rk+=1
    return rk
f3={-1:0,0:1,1:-1,2:3,3:-5,4:11}
def dot(L,Lp): return f3[10-rank(eqs(L)+eqs(Lp))-1]
if S:
    # classes as vectors of pairings: use Gram rank over QQ via fractions on small sets
    from fractions import Fraction
    def qrank(G):
        M=[[Fraction(x) for x in r] for r in G]; rk=0
        for c in range(len(M[0])):
            piv=next((i for i in range(rk,len(M)) if M[i][c]!=0),None)
            if piv is None: continue
            M[rk],M[piv]=M[piv],M[rk]
            for i in range(len(M)):
                if i!=rk and M[i][c]!=0:
                    f=M[i][c]/M[rk][c]; M[i]=[x-f*y for x,y in zip(M[i],M[rk])]
            rk+=1
        return rk
    # basis: h, L in S; extra c = P1 + 2 P2. pairing(c, L) = dot(P1,L)+2 dot(P2,L); c.c = 11+44+4*(-1)=51; c.h=3
    B=['h']+S
    def pr(u,v):
        if u=='h' and v=='h': return 3
        if u=='h' or v=='h': return 1
        return dot(u,v)
    G=[[pr(u,v) for v in B] for u in B]
    cvec=[3]+[dot(P1,L)+2*dot(P2,L) for L in S]
    G2=[r+[cvec[i]] for i,r in enumerate(G)]+[cvec+[51]]
    r1=qrank(G); r2=qrank(G2)
    print("T-B: rank Gram(h, S) =",r1,"; with c = P1 + 2 P2:",r2,"; c in span:",r1==r2)
