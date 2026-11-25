-- [TS-T6] necessary condition for a plane-swapping automorphism sigma of Y = V(G), G = f^T M0 h (w = (f, h)):
-- sigma^*(h) = C f maps the quadric-surface fibration of Q1 (projection t = f) to that of Q2 (projection u = h), so the
-- discriminant sextics satisfy Delta2(C t) = c Delta1(t) with C invertible.  We test whether such C exists (over kk-bar).
load "m0.m2";
s = value(scriptCommandLine#1); pr = value(scriptCommandLine#2);
M0 = if s == 1 then M0_1 else M0_2;
kk = ZZ/pr;
T = kk[t_0..t_2, s0, v_0..v_2];
G = (fl, hl) -> sum(3, i -> sum(3, j -> fl#i * hl#j * sum(6, k -> M0#i#j#k * (fl | hl)#k)));
-- Q1: f = s0 t, h = v ; residual quadric G/s0 in (s0, v)
q1 = G(apply(3, i -> s0 * t_i), toList(v_0..v_2)) // s0;
q2 = G(toList(v_0..v_2), apply(3, i -> s0 * t_i)) // s0;     -- Q2: h = s0 t, f = v
vars4 = {s0, v_0, v_1, v_2};
D1 = det matrix table(4, 4, (a, b) -> diff(vars4#a, diff(vars4#b, q1)));
D2 = det matrix table(4, 4, (a, b) -> diff(vars4#a, diff(vars4#b, q2)));
print("degrees of Delta1, Delta2:", first degree D1, first degree D2, "Delta1 == Delta2 (identically):", D1 == D2);
R = kk[c_(0,0)..c_(2,2)];
U = R[t_0..t_2];
toU = map(U, T, {t_0, t_1, t_2, 0, 0, 0, 0});
d1 = toU D1; d2 = toU D2;
Ct = apply(3, i -> sum(3, k -> c_(i,k) * t_k));
d2C = sub(d2, {t_0 => Ct#0, t_1 => Ct#1, t_2 => Ct#2});
mons = flatten entries basis(6, U);
co1 = apply(mons, m -> lift(coefficient(m, d1), R)); co2 = apply(mons, m -> coefficient(m, d2C));
i0 = position(co1, x -> x != 0);
I = ideal apply(#mons, m -> co1#i0 * co2#m - co1#m * co2#i0);
detC = det matrix table(3, 3, (i, k) -> c_(i,k));
t0 = cpuTime();
J = saturate(saturate(I, detC), co2#i0);
print("seed", s, "prime", pr, ": ideal of C with Delta2(C t) ~ Delta1(t), C invertible, saturated = (1):", J == ideal(1_R), "dim", dim J, "time", cpuTime() - t0);
