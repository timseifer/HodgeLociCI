-- CS-T6 type B (E3 test), via: smooth X has an Eckardt-type point p (X n T_pX a cone with vertex p) iff p in X and
-- rank Hess_F(p) <= 2 (polar quadric = T_pX u another hyperplane; ARG). Necessary condition tested: 3x3 minors of the
-- compressed symmetric matrix R^T Hess(p) R (R random 12 x 7) have no common zero in P^11. usage: seed p mode (FT | ctl)
pr = s -> (stderr << s << endl << flush);
sd = value scriptCommandLine#1; p = value scriptCommandLine#2; mode = scriptCommandLine#3;
kk = ZZ/p; S = kk[x_0..x_11]; setRandomSeed(sd);
load "/home/claude/hodge/discovery/checks/w1/w1lib.m2";
F = if mode == "FT" then (IV := trim w1cycle("J2T"); B3 := super basis(3, IV); (B3 * random(kk^(numColumns B3), kk^1))_(0,0)) else (G := random(3, kk[x_2..x_11]); g0 := x_0^2*x_1 + x_1^3 + sub(G, S); (map(S, S, random(S^1, S^{12:-1}))) g0);
H = diff(transpose vars S, diff(vars S, F));   -- 12 x 12 symmetric, linear entries
R = random(kk^12, kk^7); M = transpose(sub(R, S)) * H * sub(R, S);
t0 = cpuTime(); I3 = minors(3, M); pr("minors: " | toString numgens I3 | " time " | toString(cpuTime() - t0));
I3a = I3 + ideal F;
d = dim I3a; pr("dim (affine cone) of {rank R^T H R <= 2} n X = " | toString d | " time " | toString(cpuTime() - t0));
pr("RESULT B-eckardt " | mode | " seed " | toString sd | " p " | toString p | ": projective dim = " | toString(d - 1) | " (-1: no Eckardt point)");
