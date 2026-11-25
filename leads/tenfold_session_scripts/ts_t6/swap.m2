-- [TS-T6] is there sigma in GL6 with G o sigma = G and sigma(Q1) = Q2, sigma(Q2) = Q1 ?  (w = (f1,f2,f3,h1,h2,h3); Q1 = V(f), Q2 = V(h))
-- sigma^*: f_i -> sum_k B_ik h_k, h_j -> sum_k C_jk f_k  (swap of the two planes). Scalar absorbed (G o sigma = c G, c = t^3).
load "m0.m2";
s = value(scriptCommandLine#1); pr = value(scriptCommandLine#2);
M0 = if s == 1 then M0_1 else M0_2;
kk = ZZ/pr;
R = kk[b_(0,0)..b_(2,2), c_(0,0)..c_(2,2)];
S = kk[b_(0,0)..b_(2,2), c_(0,0)..c_(2,2), w_0..w_5];
G = sum(3, i -> sum(3, j -> w_i * w_(3+j) * sum(6, k -> M0#i#j#k * w_k)));
fimg = apply(3, i -> sum(3, k -> b_(i,k) * w_(3+k)));
himg = apply(3, j -> sum(3, k -> c_(j,k) * w_k));
phi = map(S, S, take(gens S, 18) | fimg | himg);
D = phi(G) - G;
toR = map(R, S, gens R | toList(6:0_R));
I = ideal toR (coefficients(D, Variables => toList(w_0..w_5)))#1;
detB = toR det matrix table(3, 3, (i,k) -> b_(i,k)); detC = toR det matrix table(3, 3, (i,k) -> c_(i,k));
t0 = cpuTime();
J = saturate(I, detB * detC);
print("seed", s, "prime", pr, "number of equations", numgens I, "saturated ideal = (1):", J == ideal(1_R), "dim", dim J, "time", cpuTime() - t0);
