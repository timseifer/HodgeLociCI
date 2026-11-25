import sys, numpy as np, itertools
sys.path.insert(0, '/home/claude/hodge/discovery/checks/ex_t6'); sys.path.insert(0, '/home/claude/hodge/discovery/t6_unsolved/e')
from ana import setup, mono
p=32029
for lam in (2,-1):
    E,X=setup(p,lam); TV=X['TV']%p; rTV=E.rank(TV); Mc=X['Mc']%p
    ys=[i for i,m in enumerate(E.mons) if all(m[j]==0 for j in range(6))]
    print("lam",lam,"z",E.z, "hodge row on pure-y:")
    for i in ys:
        m=E.mons[i]; idx=[j for j in range(12) if m[j]]
        e=np.zeros(220,np.int64); e[i]=1
        inTV = E.rank(np.concatenate([TV,e[:,None]],1))==rTV
        print(idx, "Mc row65:", int(Mc[-1,i]), "Mc nnz", int(np.count_nonzero(Mc[:,i])), "inTV", inTV)
