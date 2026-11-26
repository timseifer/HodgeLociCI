"""compare the probe (singular G_x at integer points of [-4,4]^3, exact, from M2) with the guess
   'G_x singular  <=>  w^e0 x0 + w^e1 x1 + w^e2 x2 = -3 for some e in (Z/3)^3, or x_i = -3 w^k' (36 hyperplanes)."""
import re, itertools, cmath
txt = open('/home/claude/blind_check5/logs_disc_probe.txt').read()
line = [l for l in txt.splitlines() if l.startswith('{({')][0]
bad = set(tuple(int(t) for t in m.group(1).split(',')) for m in re.finditer(r'\(\{([-0-9, ]+)\},', line))
w = cmath.exp(2j*cmath.pi/3)
def guess(x):
    for e in itertools.product(range(3), repeat=3):
        if abs(sum(w**e[i]*x[i] for i in range(3)) + 3) < 1e-9:
            return True
    return any(x[i] == -3 for i in range(3))
pts = list(itertools.product(range(-4, 5), repeat=3))
g = set(x for x in pts if guess(x))
print("probe: singular at", len(bad), "points; guess predicts", len(g), "; equal sets:", bad == g)
