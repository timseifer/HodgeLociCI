import sys, time, subprocess, os, itertools
sys.path.insert(0, "/home/claude/hodgelocici/leads/movasati_arc/blind_check14/own")
from own import Ctx, L1, L2, M
import numpy as np
from flint import nmod_mat
p=31981; S=Ctx(p,12637); lam=2
P=S.Pspace(L1)+S.Pspace(L2)*lam
tab=S.ptable(P)
W=np.zeros(128,dtype=np.int64); W[:80]=S.W
W.tofile("W.bin"); tab.astype(np.int64).tofile("tab.bin")
Ts=[S.parse(l) for l in open("/home/claude/hodgelocici/leads/movasati_arc/arcs/jet8_31981_s_lam2.txt") if l.strip()]
assert len(Ts)==8
T0=time.time()
def log(*a): print("[%6.0fs]"%(time.time()-T0),*a,flush=True)
def monlist(D):  # same ordering as phi.c: increasing key sum s_j (D+1)^j
    B=D+1; out=[]
    for k in range(B**M):
        t=k; s=[]
        for j in range(M): s.append(t%B); t//=B
        if sum(s)==D: out.append(tuple(s))
    return out
mon2=monlist(2); i2={m:i for i,m in enumerate(mon2)}
def mon5():
    # avoid 6^10 loop in python: generate all deg-5 monomials then sort by key
    ms=[tuple(np.bincount(c,minlength=M)) for c in itertools.combinations_with_replacement(range(M),5)]
    ms=[tuple(int(v) for v in m) for m in ms]
    ms.sort(key=lambda s: sum(s[j]*6**j for j in range(M)))
    return ms
m5=mon5(); i5={m:i for i,m in enumerate(m5)}
cub=[tuple(int(v) for v in np.bincount(c,minlength=M)) for c in itertools.combinations_with_replacement(range(M),3)]
assert len(cub)==220 and len(m5)==2002
def dump(f,fn):
    n=len(f)
    rec=np.zeros(n,dtype=[('e','u1',(10,)),('c','<u4')])
    rec['e']=np.fromiter(itertools.chain.from_iterable(f.monoms()),dtype=np.uint8,count=n*M).reshape(n,M)
    rec['c']=np.fromiter((int(c) for c in f.coeffs()),dtype=np.uint32,count=n)
    rec.tofile(fn)
def phi(f,D,tag):
    fn="t_%s.bin"%tag; dump(f,fn)
    subprocess.run(["./phi",str(D),"W.bin","tab.bin",fn,"o_%s.bin"%tag],check=True)
    r=np.fromfile("o_%s.bin"%tag,dtype=np.int64); os.remove(fn); return r
def per(f,tag):  # 45 periods via C
    r=phi(f,2,tag); return np.array([r[i2[q]] for q in S.Q],dtype=np.int64)
# --- expansion
E=S.expseries(Ts+[S.ctx.from_dict({})],9)
log("sizes E_0..E_9", [len(e) for e in E])
c={}
for n in range(1,10):
    c[n]=per(E[n],"c%d"%n)
    log("c_%d nonzero components (C code): %d"%(n,np.count_nonzero(c[n])))
# cross-check with own.py periods for n<=8
for n in range(1,9):
    o=S.periods(E[n],tab)
    log("own.py periods c_%d nonzero %d, agrees with C: %s"%(n,np.count_nonzero(o),bool((o%p==c[n]).all())))
np.save("c9.npy",c[9]); log("c_9 =",list(c[9]))
# --- derivative blocks A_k[q,m] = Psi(q m E_k)
A={}
for k in range(0,8):
    r=phi(E[k],5,"A%d"%k)
    A[k]=np.array([[r[i5[tuple(a+b for a,b in zip(q,m))]] for m in cub] for q in S.Q],dtype=np.int64)
    log("A_%d rank %d"%(k,nmod_mat(45,220,[int(v) for v in A[k].flatten()],p).rank()))
np.savez("A.npz",**{"A%d"%k:A[k] for k in A})
# J: rows orders n=2..9 (8 blocks of 45), cols unknown dT_j j=2..9 (8 blocks of 220; j=9 is T_9)
J=np.zeros((45*8,220*8),dtype=np.int64)
for n in range(2,10):
    for j in range(2,n+1):
        J[45*(n-2):45*(n-1),220*(j-2):220*(j-1)]=A[n-j]
np.save("J.npy",J)
def rk(X): return nmod_mat(X.shape[0],X.shape[1],[int(v) for v in (X%p).flatten()],p).rank()
r28=rk(J[:45*7]); r29=rk(J); log("rank Dc orders 2..8 (cols dT_2..dT_8; T_9 cols zero there):",r28,"| orders 2..9:",r29)
rhs=np.zeros(45*8,dtype=np.int64); rhs[45*7:]=(-c[9])%p
ra=rk(np.hstack([J,rhs[:,None]])); log("rank [J | (0,..,0,-c_9)] =",ra,"->", "SOLVABLE" if ra==r29 else "NO SOLUTION")
# squarefree-only variant
sf=[i for i,m in enumerate(cub) if max(m)<=1]; cols=[220*b+i for b in range(8) for i in sf]
Js=J[:,cols]; log("squarefree-only: rank",rk(Js),"augmented",rk(np.hstack([Js,rhs[:,None]])))
# order-9 cokernel picture: rank of order-9 rows of J restricted to kernel of orders 2..8 is r29-r28
log("rank of A_0 (T_9 alone):",rk(A[0]))
# --- controls: linearized recursion on a random direction, independent of the block formula
rng=np.random.default_rng(20)
def rcub(): return S.ctx.from_dict({m:int(v) for m,v in zip(cub,rng.integers(1,p,220))})
dT=[S.ctx.from_dict({})]+[rcub() for _ in range(8)]   # dT_1=0, dT_2..dT_9
Tsf=Ts+[S.ctx.from_dict({})]
dE=[S.ctx.from_dict({})]
for n in range(1,10):
    acc=S.ctx.from_dict({})
    for j in range(1,n+1):
        acc=acc+(dT[j-1]*E[n-j]+Tsf[j-1]*dE[n-j])*j
    dE.append(acc*pow(n,p-2,p))
log("linearized dE sizes",[len(e) for e in dE])
dc=np.concatenate([per(dE[n],"d%d"%n) for n in range(2,10)])
log("order-1 derivative periods nonzero:",np.count_nonzero(per(dE[1],"d1")))
vec=np.concatenate([np.array([int(dT[j-1][m]) for m in cub],dtype=np.int64) for j in range(2,10)])
log("block-formula J v == linearized-recursion periods:",bool(((J@vec-dc)%p==0).all()))
log("control (a): rank [J | Dc(v)] =",rk(np.hstack([J,dc[:,None]])),"vs rank J",r29)
del E
log("done")
