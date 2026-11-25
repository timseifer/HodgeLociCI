-- CS3-M2 degree-3 cell, scroll cone not tested before: Z = cone with vertex P^3 (x4..x7) over a twisted cubic in P^3 (x0..x3), span P^7.
-- random linear change of coordinates on P^7, random cubic containing Z. usage: M2 --script sc.m2 seed p typ (typ: SC3)
pr = s -> (stderr << s << endl << flush);
BR = 1500; sd = value scriptCommandLine#1; p = value scriptCommandLine#2; typ = scriptCommandLine#3;
kk = ZZ/p; S = kk[x_0..x_11]; setRandomSeed(sd);
load "/home/claude/hodge/discovery/checks/cs2_t6/cslibS2.m2";
A = random(kk^8, kk^8); ch = map(S, S, flatten entries ((matrix{take(gens S, 8)}) * A) | drop(gens S, 8));
IZ = trim(ch(minors(2, matrix{{x_0, x_1, x_2}, {x_1, x_2, x_3}})) + ideal(x_8, x_9, x_10, x_11));
B3 = super basis(3, IZ); F = (B3 * random(kk^(numColumns B3), kk^1))_(0,0);
kd = 7; typ = "SC3";
load "/home/claude/hodge/discovery/checks/cs2_t6/common_tail.m2";
