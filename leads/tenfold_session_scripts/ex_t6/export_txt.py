# EX-T6: human-readable export of the exact arcs: one line per nonzero coefficient "n exponent-vector a b" meaning
# T_n has coefficient a + b z at that squarefree cubic monomial (z^2 - z + 1 = 0; fe.py slice, exp(sum t^j T_j) convention).
import sys, pickle
sys.path.insert(0, '/home/claude/hodge/discovery/checks/ex_t6')
from fex import bounded_exps
mons = bounded_exps(12, 3, 1)
for pk, out, extra in [('arc_lam2_exact.pkl', 'arc_lam2_exact.txt', 'lambda = 2, T_1..T_5 (K.c_2..K.c_5 = 0, order-6 obstruction certified by y)'),
                       ('arc_lam1_exact.pkl', 'arc_lam1_exact.txt', 'lambda = -1, T_1..T_7 (K.c_2..K.c_8 = 0)'),
                       ('arc_lam2_exact_la.pkl', 'arc_lam2_exact_la.txt', 'lambda = 2, l x a type, T_1..T_5'),
                       ('arc_lam2_exact_alt.pkl', 'arc_lam2_exact_alt.txt', 'lambda = 2, a = (1,1,1), l = (u1,u3,u5), T_1..T_5'),
                       ('arc_lam1_exact_la.pkl', 'arc_lam1_exact_la.txt', 'lambda = -1, l x a type, T_1..T_7 (K.c_2..K.c_8 = 0)')]:
    d = pickle.load(open(pk, 'rb'))
    with open(out, 'w') as f:
        f.write("# EX-T6 exact arc, %s. Columns: n, exponent vector of the monomial (x0..x11), a, b : coefficient a + b z\n" % extra)
        for n, T in enumerate(d['Ts'], 1):
            for i in range(220):
                if T[i] != '0' or T[220 + i] != '0':
                    f.write("%d %s %s %s\n" % (n, ''.join(map(str, mons[i])), T[i], T[220 + i]))
    print(out, sum(1 for _ in open(out)) - 1, "coefficients")
