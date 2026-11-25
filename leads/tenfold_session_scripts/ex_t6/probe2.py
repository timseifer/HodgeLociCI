import sys, numpy as np
sys.path.insert(0, '/home/claude/hodge/discovery/checks/ex_t6'); sys.path.insert(0, '/home/claude/hodge/discovery/t6_unsolved/e')
from ana import setup
from choose import make
import run2x
p=32029
cands = {'A': [(1,[6,9,11]),(-1,[7,8,11])], 'B': [(1,[6,9,11]),(-1,[7,9,10])], 'C': [(1,[6,9,11]),(-1,[7,8,11]),(1,[6,8,10]),(1,[7,9,11])],
         'D': [(1,[6,9,11]),(-1,[7,8,11]),(1,[8,9,10])]}
for lam in (2,-1):
    E,X=setup(p,lam)
    for k,V0 in cands.items():
        for a,l in [([1,1,2],[{1:1},{3:1},{5:1,1:1}]), ([1,0,0],[{1:1},{3:1},{5:1}]), ([1,1,0],[{1:1},{3:1},{5:1}])]:
            v,info=make(E,X,V0,a,l)
            print(lam,k,a,l,info,flush=True)
            if info['v_notTV'] and info['v0_notTV']:
                run2x.run(p,lam,0,'ex',6,v=v)
