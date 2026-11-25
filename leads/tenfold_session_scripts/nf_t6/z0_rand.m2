-- NF-T6 B1: random NON-Fermat point of Z_0 (MOD p): f = x0..x2, h = x3..x5, p = x6..x8, Pi coordinates x9..x11;
-- M random with entries in (f, h, p) (M|Pi = 0), s random quadrics. No symmetry imposed.
load "/home/claude/hodge/discovery/checks/nf_t6/nfb.m2";
sd = value(scriptCommandLine#1); pr = value(scriptCommandLine#2);
lams = value(scriptCommandLine#3);
setRandomSeed sd;
kk = ZZ/pr; S = kk[x_0..x_11];
f = {x_0, x_1, x_2}; h = {x_3, x_4, x_5}; p = {x_6, x_7, x_8};
lin9 = () -> sum(9, i -> random(kk) * x_i);
M = matrix table(3, 3, (i, j) -> lin9());
s = apply(3, i -> random(2, S));
ells = {x_9, x_10, x_11};
print("seed", sd, "p", pr);
r = nfAnalyze(f, h, p, M, s, ells, lams, sd);
print r;
