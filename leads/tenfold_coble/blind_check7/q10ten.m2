load "common.m2"
p = 32003;
if #scriptCommandLine > 1 then p = value scriptCommandLine#1;
kk = ZZ/p;
pr("===== Q10 on a tenfold hyperplane section (P^10, Pfaffian, 56 nodes) MOD " | toString p | " =====");
R = kk[y_0..y_8];
M0 = random(R^6, R^{6:-1}); M = M0 - transpose M0;
G = (gens pfaffians(6, M))_(0,0);
R11 = kk[y_0..y_8,w_0,w_1];
inc = map(R11, R, take(gens R11, 9));
f = inc(G) + w_0*inc(random(2,R)) + w_1*inc(random(2,R)) + sum apply({w_0^2, w_0*w_1, w_1^2}, m -> m * inc random(1,R)) + random(kk)*w_0^3 + random(kk)*w_0^2*w_1 + random(kk)*w_0*w_1^2 + random(kk)*w_1^3;
q10test("Q10 Pfaffian tenfold section, 56 nodes", f, 4);
