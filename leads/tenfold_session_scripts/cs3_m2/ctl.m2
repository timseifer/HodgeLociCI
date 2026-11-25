-- CS3-M2 controls: typ V (Z = V = J(P^2,T) in random X in F_T; expect codim 55, h0 0) or VZ (two 5-planes meeting in a P^2, random cubic containing them; expect codim 39)
pr = s -> (stderr << s << endl << flush);
BR = 1500; sd = value scriptCommandLine#1; p = value scriptCommandLine#2; typ = scriptCommandLine#3;
kk = ZZ/p; S = kk[x_0..x_11]; setRandomSeed(sd);
load "/home/claude/hodge/discovery/checks/cs2_t6/cslibS2.m2";
load "/home/claude/hodge/discovery/checks/cs2_t6/tlib.m2";
if typ == "V" then (IZ = IV) else (
  IZ = intersect(ideal(x_3,x_4,x_5,x_9,x_10,x_11), ideal(x_0,x_1,x_2,x_9,x_10,x_11)));
B3 = super basis(3, IZ); F = (B3 * random(kk^(numColumns B3), kk^1))_(0,0);
kd = 8; typ = "CTL " | typ;
load "/home/claude/hodge/discovery/checks/cs2_t6/common_tail.m2";
