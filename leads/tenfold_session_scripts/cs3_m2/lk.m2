-- CS3-M2 liaison extensions in X n P^8 (P^8 = span V = {x9 = x10 = x11 = 0}); usage: M2 --script lk.m2 seed p typ
-- R24: residual of V in X n P^8 n (q, Q4), q a net quadric, Q4 a random quartic of I_V (class 8h^5 - [V], d 18)
-- DL23: residual of R22 = (q1,q2,F,u):I_V in X n P^8 n (q', c''), q' random in I_R22(2), c'' random in I_R22(3) (class 2h^5 + [V], d 12)
-- DL33: residual of R22 in X n P^8 n (c1'', c2'') (class 5h^5 + [V], d 21)
pr = s -> (stderr << s << endl << flush);
BR = 1500; sd = value scriptCommandLine#1; p = value scriptCommandLine#2; typ = scriptCommandLine#3;
kk = ZZ/p; S = kk[x_0..x_11]; setRandomSeed(sd);
load "/home/claude/hodge/discovery/checks/cs2_t6/cslibS2.m2";
load "/home/claude/hodge/discovery/checks/cs2_t6/tlib.m2";
B3 = super basis(3, IV); F = (B3 * random(kk^(numColumns B3), kk^1))_(0,0);
pr("X smooth along V: " | toString(dim(IV + ideal jacobian matrix{{F}}) == 0));
u = ideal(x_9, x_10, x_11);
rnd = (I, e) -> (Bq := super basis(e, I + u); ((Bq * random(kk^(numColumns Bq), kk^1))_(0,0)) % u);
q = () -> sum(qs, g -> random(kk) * g);
if typ == "R24" or typ == "R25" then (
   CI = ideal(F) + ideal(q(), rnd(IV, if typ == "R24" then 4 else 5)) + u;
   pr("CI: codim " | toString codim CI | " degree " | toString degree CI);
   IZ = trim saturate(CI : IV)) else if typ == "DL24V" then (
   q0 = q(); CI0 = ideal(F) + ideal(q0, rnd(IV, 4)) + u; IR = trim saturate(CI0 : IV);
   pr("R24: degree " | toString degree IR | ", mingens " | toString tally apply(flatten entries mingens IR, g -> first degree g));
   n4 = numColumns super basis(4, IR + u) - numColumns super basis(4, u); n4q = numColumns super basis(4, CI0) - numColumns super basis(4, u);
   pr("dim I_R24(4) mod u = " | toString n4 | ", of which (q, Q4, F)_4: " | toString n4q);
   CI = ideal(F) + ideal(q0, rnd(IR, 4)) + u;
   pr("CI: codim " | toString codim CI | " degree " | toString degree CI);
   IZ = trim saturate(CI : IR);
   pr("Z vs V: Z = V? " | toString(IZ == IV) | "; dim(Z n V) = " | toString(dim(IZ + IV) - 1) | "; Z a cone (has a vertex point)? linear forms " | toString numColumns super basis(1, IZ))) else (
   CI0 = ideal(F) + ideal(q(), q()) + u; IR = trim saturate(CI0 : IV);
   pr("R22: degree " | toString degree IR | ", mingens " | toString tally apply(flatten entries mingens IR, g -> first degree g));
   n2 = numColumns super basis(2, IR + u) - numColumns super basis(2, u); n3 = numColumns super basis(3, IR + u) - numColumns super basis(3, u);
   n3q = numColumns super basis(3, ideal(qs) + ideal(F) + u) - numColumns super basis(3, u);
   pr("dim I_R22(2) mod u = " | toString n2 | ", dim I_R22(3) mod u = " | toString n3 | ", of which (net)S_1 + F: " | toString n3q);
   forms = if typ == "DL23" then {rnd(IR, 2), rnd(IR, 3)} else {rnd(IR, 3), rnd(IR, 3)};
   CI = ideal(F) + ideal(forms) + u;
   pr("CI: codim " | toString codim CI | " degree " | toString degree CI);
   IZ = trim saturate(CI : IR);
   pr("Z vs V: Z = V? " | toString(IZ == IV) | "; dim(Z n V) = " | toString(dim(IZ + IV) - 1)));
kd = 8; typ = "LK " | typ;
load "/home/claude/hodge/discovery/checks/cs2_t6/common_tail.m2";
