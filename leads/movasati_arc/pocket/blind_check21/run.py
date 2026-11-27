import re,sys,itertools,random,time
import numpy as np
from flint import nmod_mpoly_ctx, nmod, Ordering, nmod_mat
M=10
SUBS=list(itertools.combinations(range(M),5)); IDX={sum(1<<j for j in s):i for i,s in enumerate(SUBS)}
codemap=np.full(1<<M,-1,dtype=np.int64)
for k,i in IDX.items(): codemap[k]=i
def run(p,z,fn):
    assert (z*z-z+1)%p==0
    ctx=nmod_mpoly_ctx.get(["x_%d"%i for i in range(M)],p,Ordering.degrevlex); x=ctx.gens()
    def parse(l):
        t=re.sub(r"(?<![_\d])(\d+)",r"N(\1)",l).replace("^","**")
        env={"N":lambda n:nmod(n,p),"z":nmod(z,p)}
        for i in range(M): env["x_%d"%i]=x[i]
        return ctx.from_dict({})+eval(t,env)
    T=[parse(l) for l in open(fn) if l.strip()]; assert len(T)==8
    W=np.zeros(90,dtype=np.int64); inv3=pow(3,p-2,p)
    for g in range(90):
        q,r=divmod(g,3)
        if r==2: continue
        a=(1+r)*inv3%p; v=1
        for t in range(q): v=v*(a+t)%p
        W[g]=v
    # period polynomial vectors (coeff on squarefree monomials x^S)
    def PL(pairs):  # pairs: (a,b,e): factor 3c(x_a + c x_b), c=z^e
        v=np.zeros(252,dtype=np.int64)
        for choice in itertools.product((0,1),repeat=5):
            coef=1; code=0
            for (a,b,e),ch in zip(pairs,choice):
                c=pow(z,e,p); coef=coef*3*c%p
                if ch==0: code|=1<<a
                else: code|=1<<b; coef=coef*c%p
            v[codemap[code]]=(v[codemap[code]]+coef)%p
        return v
    def matchings(s):
        if not s: yield []; return
        a=s[0]
        for i in range(1,len(s)):
            for m in matchings(s[1:i]+s[i+1:]): yield [(a,s[i])]+m
    allm=list(matchings(list(range(M))))
    random.seed(1); Hv=[]
    for mt in allm:
        for es in itertools.product((1,3,5),repeat=5):
            if random.random()<0.01: Hv.append(PL([(a,b,e) for (a,b),e in zip(mt,es)]))
    dimH=nmod_mat([list(map(int,r)) for r in Hv],p).rank()
    c=(PL([(2*i,2*i+1,1) for i in range(5)])+2*PL([(2*i,2*i+1,3 if i<3 else 1) for i in range(5)]))%p
    E=[ctx.from_dict({(0,)*M:1})]
    for n in range(1,9):
        acc=ctx.from_dict({})
        for j in range(1,n+1): acc+=T[j-1]*E[n-j]*j
        E.append(acc*pow(n,p-2,p))
    Qs=list(itertools.combinations(range(M),2)); pw2=1<<np.arange(M,dtype=np.int64)
    rows=[]; out=[]
    for m in range(1,9):
        f=E[m]; N=len(f)
        ex=np.array(f.monoms(),dtype=np.int64); co=np.array([int(t) for t in f.coeffs()],dtype=np.int64)
        for (a,b) in Qs:
            h=ex.copy(); h[:,a]+=1; h[:,b]+=1; r=h%3; ok=(r!=2).all(1)&(r.sum(1)==5)
            hh=h[ok]; w=co[ok].copy()
            for j in range(M): w=w*W[hh[:,j]]%p
            col=codemap[((1-r[ok])*pw2).sum(1)]; assert (col>=0).all()
            row=np.zeros(252,dtype=np.int64); np.add.at(row,col,w); row%=p
            rows.append(row)
        A=nmod_mat([list(map(int,r)) for r in rows],p)
        dimL=252-A.rank()
        cz=int(np.count_nonzero(np.array(rows)@c%p))  # c control (int64 ok: 252*p^2 < 9e18)
        out.append((m,dimL,cz))
    # does c span Lambda_8 ?
    A=nmod_mat([list(map(int,r)) for r in rows],p)
    span_ok = (out[-1][1]==1 and cz==0 and np.any(c))
    # negative control: random P not annihilated
    rnd=np.array([random.randrange(p) for _ in range(252)])
    neg=int(np.count_nonzero(np.array(rows)@rnd%p))
    return dimH,out,span_ok,neg,len(Hv)
for p,z,f in [(31981,12637,"jet8_31981_s_lam2.txt"),(32029,31556,"jet8_32029_s_lam2.txt")]:
    print(p,run(p,z,"/home/claude/hodgelocici/leads/movasati_arc/arcs/"+f),flush=True)
