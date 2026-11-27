import sys; sys.path.insert(0, "/home/claude/hodgelocici/leads/movasati_arc/blind_check14/own")
from own import *
p=32029; z=31556; S=Ctx(p,z)
for fn in ["exact_g_lam2_order5.txt","exact_g_lam-1_order7.txt"]:
    l=read_lines(fn)[0]
    f=S.parse(l)
    y=S.ctx.from_dict({m:c for m,c in zip(f.monoms(),f.coeffs()) if sum(m[6:])==0})
    print(fn, len(y)); print(y)
