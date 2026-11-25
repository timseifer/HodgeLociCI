pr = s -> (stderr << s << endl << flush);
p = 32003; kk = ZZ/p; S = kk[x_0..x_11];
setRandomSeed(value scriptCommandLine#1); typ = scriptCommandLine#2;
load "/home/claude/hodge/discovery/checks/w1/w1lib.m2";
IV = trim w1cycle("J2T");
B3 = super basis(3, IV); F = (B3 * random(kk^(numColumns B3), kk^1))_(0,0);
IZ = (if typ == "U9" then (
     Pi1 := (map(S, ring first w1planes, {x_0,x_1,x_2,x_3,x_4,x_5})) (first w1planes);
     L := ideal (gens Pi1 * random(kk^3, kk^2));     -- P^3 through Pi1 in P^5; P^6 = J(vertex, P^3)
     L + ideal(x_9, x_10, x_11, F))
  else if typ == "U12" then (
     Hs := sum(6, i -> random(kk) * x_i);
     q2 := select(flatten entries mingens IV, gg -> first degree gg == 2);
     qq := sum(q2, gg -> random(kk) * gg);
     ideal(Hs, qq, x_9, x_10, x_11, F))
  else error "typ");
I = trim intersect(IV, IZ);
pr("type " | typ | ": dim " | toString(dim I - 1) | " degree " | toString(degree I) | "  Z: dim " | toString(dim IZ - 1) | " deg " | toString(degree IZ) | "; V n Z: dim " | toString(dim(IV + IZ) - 1) | " deg " | toString degree(IV + IZ));
if #scriptCommandLine > 3 then w1codimP8(F, I) else w1codim(F, I);
