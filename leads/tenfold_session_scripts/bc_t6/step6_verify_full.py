# Re-verify a saved arc against ALL 364 cubic forms P (full equation set, no symmetry reduction), mod p.
# usage: python3 step6_verify_full.py arcfile
import sys, json
sys.path.insert(0, '/home/claude/hodge/discovery/checks/bc_t6')
from arc import *
fn = sys.argv[1]
lines = open(fn).read().strip().split("\n")
meta = json.loads(lines[0]); p = meta["p"]; lam = meta["lam"]
F = Field(p); assert F.z == meta["z"]
St = Setup(p, lam, range(12))
St.P = cubic_monos()  # all 364 cubic monomials
Fs = []
for ln in lines[1:]:
    terms = json.loads(ln.split(": ", 1)[1])
    Fs.append(Poly(p, [enc(b) for b, c in terms], [c for b, c in terms]).norm())
E = expE(Fs, p, len(Fs))
res = []
for n in range(1, len(Fs) + 1):
    f = St.phi2(E[n]); r = (f[:, 0] + St.lam * f[:, 1]) % p
    res.append(int((r != 0).sum()))
    print(f"order {n}: |E_n| = {len(E[n])}, #nonzero among 364 equations of delta = {res[-1]};  single planes: P1 nonzero {int((f[:,0]!=0).sum())}, P2 nonzero {int((f[:,1]!=0).sum())}", flush=True)
# the arc must not lie in V_Z: show the P1-periods are not all zero
print("VERDICT:", "all 364 equations vanish through order", max([k for k in range(len(res) + 1) if all(x == 0 for x in res[:k])]))
