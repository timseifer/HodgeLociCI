-- CS-T6 type B (E3 test): does X have an Eckardt-type point p (X n T_pX a cone with vertex p)?  Every member of a
-- vertex-point cone family (X n P^10 = cone over a cubic eightfold) has one. usage: M2 --script b1.m2 seed p mode (FT | ctl)
pr = s -> (stderr << s << endl << flush);
sd = value scriptCommandLine#1; p = value scriptCommandLine#2; mode = scriptCommandLine#3;
kk = ZZ/p; S = kk[x_0..x_11]; setRandomSeed(sd);
load "/home/claude/hodge/discovery/checks/w1/w1lib.m2";
F = if mode == "FT" then (IV := trim w1cycle("J2T"); B3 := super basis(3, IV); (B3 * random(kk^(numColumns B3), kk^1))_(0,0)) else (G := random(3, kk[x_2..x_11]); g0 := x_0^2*x_1 + x_1^3 + sub(G, S); (map(S, S, random(S^1, S^{12:-1}))) g0);
pr("X smooth: " | toString(dim ideal jacobian matrix{{F}} == 0));
R = kk[y_0..y_11, a_0..a_11, MonomialOrder => GRevLex];
toR = map(R, S, take(gens R, 12));
FR = toR F; gR = apply(12, i -> toR diff(S_i, F)); HR = table(12, 12, (i,j) -> toR diff(S_i, diff(S_j, F)));
eqs = {FR} | flatten apply(12, i -> apply(toList(i..11), j -> HR#i#j - (gR#i * a_j + gR#j * a_i)));
chart = sum(12, i -> random(kk) * y_i) - 1;
Ieq = ideal(eqs | {chart});
t0 = cpuTime(); Gb = gb(Ieq, DegreeLimit => 12);
isUnit = (1_R % Gb) == 0;
pr("GB (degree limit 12) time " | toString(cpuTime() - t0) | "; unit ideal found: " | toString isUnit);
if not isUnit then (t1 := cpuTime(); d := dim Ieq; pr("dim of solution set (affine chart) = " | toString d | " time " | toString(cpuTime()-t1)));
pr("RESULT B-eckardt " | mode | " seed " | toString sd | " p " | toString p | ": unit (no Eckardt point in chart) = " | toString isUnit);
