# Repetition of C3 (exact, over QQ) with other rational planes inside P' = g(P_B), own choice.
import json
from common import *
from c3 import run
d = json.load(open("/home/claude/blind_check11/c1_data.json"))
Pp = [[Fr(c) for c in w] for w in d["Pprime"]]
choices = {
    "pi_2": [(1, 0, 2, -1, 1), (0, 1, -1, 3, 2), (2, -1, 0, 1, -3)],
    "pi_3": [(3, 1, 0, 0, -2), (1, -2, 1, 0, 1), (0, 1, 1, -1, 4)],
}
out = open("/home/claude/blind_check11/c3_pi2.out", "w")
for name, comb in choices.items():
    cols_ = [[sum(c[j] * Pp[j][i] for j in range(5)) for i in range(N)] for c in comb]
    assert rank(cols_, Fr(0), Fr(1)) == 3
    print(name, "columns:", [[str(x) for x in c] for c in cols_]); out.write("%s columns: %s\n" % (name, [[str(x) for x in c] for c in cols_]))
    print("contains a:", rank(cols_ + [A_PT], Fr(0), Fr(1)) == 3)
    run(cols_, name + " (own choice inside P')", out)
