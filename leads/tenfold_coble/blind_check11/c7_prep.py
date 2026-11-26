from common import *
def fstr():
    terms = []
    for idx, c in sorted(FMON.items()):
        terms.append("(%s)*%s" % (c, "*".join(NAMES[i] for i in idx)))
    return " + ".join(terms)
F = fstr()
open("F_string.txt", "w").write(F)
m2 = """R = QQ[z0,z1,z2,p0,p1,p2,q0,q1,q2];
F = %s;
J = ideal jacobian ideal F;
t0 = cpuTime();
print("Sing(Y) over QQ: projective dimension, degree, Hilbert polynomial:");
print(dim J - 1);
print(degree J);
print(toString hilbertPolynomial(J, Projective=>false));
print(cpuTime() - t0);
-- is the Jacobian ideal saturated / radical?  compare with its saturation
Js = saturate J;
print("Jacobian ideal saturated:"); print(Js == J);
print("number and degrees of generators of saturation:"); print(toString tally flatten degrees Js);
quit;
""" % F
open("c7.m2", "w").write(m2)
# parameter non-speciality (author's test)
x = XX; lam = LAM
rel = [(i, j, k) for i in range(3) for j in range(3) for k in range(3) if i < j and k not in (i, j) and x[i] + x[j] == lam * x[k]]
rel_all = [(i, j, k) for i in range(3) for j in range(3) for k in range(3) if x[i] + x[j] == lam * x[k]]
print("relations x_i + x_j = lam*x_k with {i,j,k}={0,1,2}:", rel, "; with arbitrary indices (i,j,k):", rel_all)
print("h(x) =", hval(x), " 1+lam^3 =", 1 + lam ** 3)
