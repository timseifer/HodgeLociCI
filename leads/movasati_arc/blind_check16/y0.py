import sys; sys.path.insert(0, "/home/claude/hodgelocici/leads/movasati_arc/blind_check14/own")
from fs import *
p=32029; z=31556; S=Ctx(p,z); x=S.x
P1=S.Pspace(L1); P2=S.Pspace(L2)
m20=[tuple(1 if i in c else 0 for i in range(M)) for c in itertools.combinations(range(6),3)]
def mat(P):
    tab=S.ptable(P)
    return np.array([S.periods(S.ctx.from_dict({m:1}),tab) for m in m20]).T%p
A1=mat(P1);A2=mat(P2)
print("rank A1",rank(A1,p),"rank A2",rank(A2,p),"rank [A1;A2]",rank(np.vstack([A1,A2]),p))
for lam in [1,2,3,(p+1)//2,p-1]:
    print(lam, "rank A1+lam A2", rank((A1+lam*A2)%p,p))
# net check
