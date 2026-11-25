-- NF-T6 control: nfAnalyze at the Fermat point (Movasati pair), MOD 32029. Expect rank L 38, codims 65/66,
-- T V_Z + T Cone_T = ker L, and q = 0 on all of ker L (T6d: G2 = 0 on ker L), hence beta = 0.
load "/home/claude/hodge/discovery/checks/nf_t6/nfb.m2";
pr = 32029; kk = ZZ/pr;
z = (select(toList(2..pr-1), a -> (a^2 - a + 1) % pr == 0))#0; z = z_kk;
S = kk[x_0..x_11];
p = {x_0 - z*x_1, x_2 - z*x_3, x_4 - z*x_5};
f = {x_6 - z*x_7, x_8 - z*x_9, x_10 - z*x_11};
h = {x_6 + x_7, x_8 + x_9, x_10 + x_11};
z5 = z^5;
M = diagonalMatrix{x_6 - z5*x_7, x_8 - z5*x_9, x_10 - z5*x_11};
s = {(x_0 + x_1)*(x_0 - z5*x_1), (x_2 + x_3)*(x_2 - z5*x_3), (x_4 + x_5)*(x_4 - z5*x_5)};
F = (matrix{f} * M * transpose matrix{h})_(0,0) + sum(3, i -> p#i * s#i);
print("F == Fermat:", F == sum(12, i -> x_i^3));
ells = {x_1, x_3, x_5};
r = nfAnalyze(f, h, p, M, s, ells, {-1, 2}, 0);
print r;
