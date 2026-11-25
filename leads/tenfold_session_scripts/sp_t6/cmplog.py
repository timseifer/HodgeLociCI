# compare two hi_* logs ignoring timings "(123s)" and lines that only exist in one variant (DIGEST/filter)
import re, sys
def norm(f):
    out = []
    for l in open(f):
        if l.startswith('DIGEST') or l.startswith('filter:') or l.startswith('fsc:'): continue
        out.append(re.sub(r'\(\d+s\)', '', l).rstrip())
    return out
a, b = norm(sys.argv[1]), norm(sys.argv[2])
n = min(len(a), len(b)); diff = [i for i in range(n) if a[i] != b[i]]
print("lines", len(a), len(b), "differing", len(diff), "IDENTICAL" if (not diff and len(a) == len(b)) else "DIFFERENT")
for i in diff[:5]: print(" <", a[i]); print(" >", b[i])
