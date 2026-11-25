-- CS2-T6 type I4: unions V u Z', Z' = X n (linear / quadric section) meeting V in a 4-fold, beyond W1's U9/U12. usage: M2 --script i4.m2 seed p typ
-- I4a: Z' = X n P^6, P^6 = <P^4_e, e_9, e_10> (P^4_e = J(Pi, m_e) a ruling 4-plane of V); V n Z' = P^4_e
-- I4b: Z' = X n P^7 n q, P^7 = <l, P^5> (l a line of Pi), q a net quadric; V n Z' = J(l, T)
-- I4e: Z' = X n P^6, P^6 = <Pi, m_e, m_e'> (two disjoint ruling lines); V n Z' contains P^4_e u P^4_e'
pr = s -> (stderr << s << endl << flush);
BR = 1500; sd = value scriptCommandLine#1; p = value scriptCommandLine#2; typ = scriptCommandLine#3;
kk = ZZ/p; S = kk[x_0..x_11]; setRandomSeed(sd);
load "/home/claude/hodge/discovery/checks/cs2_t6/cslibS2.m2"; load "/home/claude/hodge/discovery/checks/cs2_t6/tlib.m2";
B3 = super basis(3, IV); F = (B3 * random(kk^(numColumns B3), kk^1))_(0,0);
pr("X smooth along V: " | toString(dim(IV + ideal jacobian matrix{{F}}) == 0));
z3 = matrix{{0_kk},{0_kk},{0_kk}}; e3 = apply(3, i -> matrix apply(3, j -> {if i == j then 1_kk else 0_kk}));
Pivecs = apply(3, i -> pt(z3, z3, e3#i, z3));
IZp = (if typ == "I4a" then (
      (a, b) := rulingPoint();
      vv := Pivecs | {pt(z3, a, z3, z3), pt(b, z3, z3, z3), pt(z3, z3, z3, e3#0), pt(z3, z3, z3, e3#1)};
      linIdeal(vv) + ideal F)
   else if typ == "I4b" then (
      l := sum(3, i -> random(kk) * x_(6+i));
      q := sum(qs, g -> random(kk) * g);
      ideal(l, x_9, x_10, x_11, q, F))
   else if typ == "I4e" then (
      (a1, b1) := rulingPoint(); (a2, b2) := rulingPoint();
      vv2 := Pivecs | {pt(z3, a1, z3, z3), pt(b1, z3, z3, z3), pt(z3, a2, z3, z3), pt(b2, z3, z3, z3)};
      linIdeal(vv2) + ideal F)
   else error "typ");
pr("Z': dim " | toString(dim IZp - 1) | " degree " | toString degree IZp | "; V n Z': dim " | toString(dim(IV + IZp) - 1) | " degree " | toString degree(IV + IZp));
IZ = trim intersect(IV, IZp);
kd = if typ == "I4a" then 10 else 8; typ = "I4 " | typ;
load "/home/claude/hodge/discovery/checks/cs2_t6/common_tail.m2";
