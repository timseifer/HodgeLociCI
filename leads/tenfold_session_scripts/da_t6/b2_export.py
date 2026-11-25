import sys, numpy as np
sys.path.insert(0, '/home/claude/hodge/discovery/t6_unsolved/e')
from ana import setup
p=32029; E,X=setup(p,-1)
Ts=np.load('/home/claude/hodge/discovery/t6_unsolved/e/arc2_32029_-1_1_al_8.npy')
def poly(v): return "+".join("%d*%s"%(int(c),"*".join("x_%d"%i for i,e in enumerate(m) if e)) for c,m in zip(v,E.mons) if c%p) or "0"
with open('b2_arc.txt','w') as f:
    for n in range(3): f.write("T%d %s\n"%(n+1,poly(Ts[n])))
cs,_,_=E.series([Ts[0],Ts[1],Ts[2]],4)
np.save('b2_fe_cs.npy',np.array(cs))
# Kl row-space comparison at lambda=-1
A=X['Kl']%p; B=E.Kl%p
print("Kl ranks", E.rank(A), E.rank(B), "joint", E.rank(np.concatenate([A,B],0)))
