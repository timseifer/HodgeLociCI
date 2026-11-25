-- NF-T6 B1 (Cone_18 with Y GENERIC in C_18, MOD 32003): X n P^8 = cone (vertex Pi = <x6,x7,x8>) over a random cubic
-- fourfold Y(x0..x5) containing an AHTV elliptic sextic scroll T (W1's w1T, generic member of C_18, no planes);
-- V = J(Pi, T) (class of [P1] - [P2] type, lambda = -1); rest of F random: F = Y + x9 Q1 + x10 Q2 + x11 Q3.
-- Computes: rank of the period pairing of [V] (= codim T NL, W1's w1tangent), codim T Cone, rank of L on T Cone,
-- codim T Cone_T = T Cone n ker L, dim ker L / T Cone_T, and the F_T family codim (w1codimLA).
needsPackage("HodgeLociCI", FileName => "/home/claude/hodge/package/HodgeLociCI/M2/HodgeLociCI.m2");
pr = s -> (stderr << s << endl << flush);
p = 32003; kk = ZZ/p; S = kk[x_0..x_11];
sd = value(scriptCommandLine#1); setRandomSeed sd;
load "/home/claude/hodge/discovery/checks/w1/w1lib.m2";
(R5, IT) = w1T();
toS = map(S, R5, {x_0,x_1,x_2,x_3,x_4,x_5});
I = toS(IT) + ideal(x_9, x_10, x_11);
BT = super basis(3, toS IT);   -- cubics in x0..x5 containing T
Y = (BT * random(kk^(numColumns BT), kk^1))_(0,0);
F = Y + x_9 * random(2, S) + x_10 * random(2, S) + x_11 * random(2, S);
print("seed", sd, "F in I_V:", F % (ideal gens gb I) == 0, "dim/deg V:", dim I - 1, degree I);

-- period pairing of [V] on S_3 x S_3 (W1's method: functional on S_6 killing (I+J)_6)
J = ideal jacobian matrix{{F}};
print("(I+J)_6 codim m =", m);
B = basis(3, S); m3 = flatten entries B;
-- T Cone (P^8 = V(x9,x10,x11), vertex <x6,x7,x8>, cone over cubics in x0..x5), P^8 and vertex moving
tt = symbol tt; S8 = kk[tt_0..tt_8];
rS8 = map(S8, S, {tt_0,tt_1,tt_2,tt_3,tt_4,tt_5,tt_6,tt_7,tt_8,0,0,0});
B8 = basis(3, S8); R8 = lift((coefficients(rS8 B, Monomials => B8))#1, kk);
ww = symbol ww; Sw = kk[ww_0..ww_5]; wc = flatten entries basis(3, Sw); wsub = map(S8, Sw, {tt_0,tt_1,tt_2,tt_3,tt_4,tt_5});
Ugens = apply(wc, u -> wsub u) | flatten apply(12, i -> apply(9, k -> tt_k * rS8(diff(S_i, F))));
U = lift((coefficients(matrix{Ugens}, Monomials => B8))#1, kk);
Nn = gens ker transpose U; TCone = gens ker (transpose Nn * R8);
intersectSpaces = (A1, B1) -> (N := gens ker (A1 | B1); A1 * N^(toList(0..numColumns A1 - 1)));
print("rank U", rank U, "numcols", numColumns U, "rank R8", rank R8, "wc", #wc, rank lift((coefficients(matrix{apply(wc, u -> wsub u)}, Monomials => B8))#1, kk));
print(take(Ugens, {56, 60}));
