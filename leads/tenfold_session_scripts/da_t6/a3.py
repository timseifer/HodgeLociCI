import sys, itertools, numpy as np
sys.path.insert(0,'/home/claude/hodge/discovery/checks/da_t6')
sys.path.insert(0,'/home/claude/hodge/discovery/t6_unsolved/e')
from fe import Engine
p=32003; rng=np.random.default_rng(5)
E=Engine.__new__(Engine); E.p=p  # only linear algebra helpers used
def mons(nv,d): return [e for e in itertools.product(range(d+1),repeat=nv) if sum(e)==d]
def rlin(nv): return {tuple(1 if k==i else 0 for k in range(nv)): int(rng.integers(1,p)) for i in range(nv)}
def rpoly(nv,d): return {e:int(rng.integers(1,p)) for e in mons(nv,d)}
def mul(A,B):
    o={}
    for a,x in A.items():
        for b,y in B.items():
            k=tuple(i+j for i,j in zip(a,b)); o[k]=(o.get(k,0)+x*y)%p
    return o
def add(*P):
    o={}
    for Q in P:
        for k,v in Q.items(): o[k]=(o.get(k,0)+v)%p
    return o
def neg(P): return {k:(-v)%p for k,v in P.items()}
def det3(M):
    t={}
    for perm in itertools.permutations(range(3)):
        s=1
        for i in range(3):
            for j in range(i+1,3):
                if perm[i]>perm[j]: s=-s
        q=mul(mul(M[0][perm[0]],M[1][perm[1]]),M[2][perm[2]]); t=add(t,q if s==1 else neg(q))
    return t
def cof(M): return [add(mul(M[r[0]][c[0]],M[r[1]][c[1]]),neg(mul(M[r[0]][c[1]],M[r[1]][c[0]]))) for r in [(0,1),(0,2),(1,2)] for c in [(0,1),(0,2),(1,2)]]
def deriv(P,i,nv):
    o={}
    for k,v in P.items():
        if k[i]: kk=list(k); kk[i]-=1; o[tuple(kk)]=(o.get(tuple(kk),0)+v*k[i])%p
    return o
def codim(nv, pieces):
    # pieces: list of ('lQ') or ('det'); build F and tangent generators
    F={}; gens=[]
    S1=[{e:1} for e in mons(nv,1)]; S2=[{e:1} for e in mons(nv,2)]
    for kind in pieces:
        if kind=='lQ':
            l=rlin(nv); Q=rpoly(nv,2); F=add(F,mul(l,Q)); gens+= [mul(l,q) for q in S2]+[mul(Q,x) for x in S1]
        else:
            M=[[rlin(nv) for _ in range(3)] for _ in range(3)]; F=add(F,det3(M)); gens+=[mul(c,x) for c in cof(M) for x in S1]
    J=[mul(deriv(F,i,nv),x) for i in range(nv) for x in S1]
    m3=mons(nv,3); ix={e:i for i,e in enumerate(m3)}
    def vec(P):
        v=np.zeros(len(m3),dtype=np.int64)
        for k,c in P.items(): v[ix[k]]=c
        return v
    A=np.stack([vec(g) for g in J],1); B=np.stack([vec(g) for g in gens+J],1)
    rJ=E.rank(A); rB=E.rank(B)
    return len(m3)-rB, len(m3)-rJ
for nv,pieces in [(8,['det','det']),(10,['lQ','det','det']),(12,['lQ','lQ','det','det']),(12,['det','det','det']),(12,['lQ']*4+['det'])]:
    print(nv,pieces,"codim of family in moduli, (dim moduli):",codim(nv,pieces),flush=True)
