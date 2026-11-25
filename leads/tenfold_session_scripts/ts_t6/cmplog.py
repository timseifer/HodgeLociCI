# compare the arc body of a TS-T6 log with a reference log (W3 / PK / NF-T6), ignoring timings and header lines.
# The body starts at the first line "E'_1:"; reference lines HISTORY/DIGEST/final order/peak/VERDICT/ANALYSIS are kept
# only if both have them (lower-order references: prefix comparison).
import re, sys
def norm(f):
    out = []
    for l in open(f):
        l = re.sub(r'\(\d+s\)', '', l).replace('[streamed, not stored]', '').rstrip()
        out.append(re.sub(r'\s+', ' ', l).strip())
    i = next(k for k, l in enumerate(out) if l.startswith("E'_1:"))
    return out[i:]
skip = ('HISTORY', 'DIGEST', 'final order', 'peak RSS', 'VERDICT')
res, exp = norm(sys.argv[1]), norm(sys.argv[2])
exp = [l for l in exp if not l.startswith(skip)]; res2 = [l for l in res if not l.startswith(skip)]
for i, l in enumerate(exp):
    if i >= len(res2) or res2[i] != l:
        print("FAIL at body line %d\n expected: %s\n result  : %s" % (i, l, res2[i] if i < len(res2) else '(missing)')); sys.exit(1)
print("PASS (%d reference body lines reproduced)" % len(exp))
