import sys, numpy as np
sys.path.insert(0, '/home/claude/hodge/discovery/checks/ex_t6'); sys.path.insert(0, '/home/claude/hodge/discovery/t6_unsolved/e')
from ana import setup
from choose import make
import run2x
p=int(sys.argv[1])
V0 = {2: [(1,[7,9,11]),(1,[6,9,11]),(-1,[6,8,11])], -1: [(1,[7,9,11])]}
AL = [([1,1,2],[{1:1},{3:1},{5:1,1:1}]), ([1,0,0],[{1:1},{3:1},{5:1}]), ([1,-1,0],[{1:1},{3:1},{5:1}]), ([1,1,1],[{1:1},{3:1},{5:1}])]
for lam in (2,-1):
    E,X=setup(p,lam)
    for a,l in AL:
        v,info=make(E,X,V0[lam],a,l)
        print(lam,a,l,info,flush=True)
        if info['v_notTV'] and info['v0_notTV']:
            run2x.run(p,lam,0,'ex',7 if lam==-1 else 6,v=v)
