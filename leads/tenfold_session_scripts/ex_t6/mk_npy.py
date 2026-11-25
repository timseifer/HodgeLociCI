# reduce an exact arc (pickle) mod p at z = zp, save npy for eval_hl_x.py; add y.c6 mod p to a copy of the certificate
import sys, pickle, json, numpy as np
from flint import fmpq
def red(s, p):
    x = fmpq(s); assert int(x.q) % p
    return int(x.p % p) * pow(int(x.q % p), p - 2, p) % p
pk, p, zp, out = sys.argv[1], int(sys.argv[2]), int(sys.argv[3]), sys.argv[4]
d = pickle.load(open(pk, 'rb'))
Ts = [np.array([(red(T[i], p) + red(T[220 + i], p) * zp) % p for i in range(220)], np.int64) for T in d['Ts']]
np.save(out, np.array(Ts))
if 'y' in d and len(sys.argv) > 5:
    n = 221; y = d['y']
    c6 = [(red(d['c6'][i], p) + red(d['c6'][n + i], p) * zp) % p for i in range(n)]
    yc = sum((y[i] + y[n + i] * zp) * c6[i] for i in range(n)) % p
    cert = json.load(open(sys.argv[5])); cert.setdefault('y_dot_c6_modp', {})[str(p) + '_' + str(zp)] = int(yc)
    json.dump(cert, open(sys.argv[5], 'w'))
print("saved", out)
