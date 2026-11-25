-- CS3-M2 type DSK: Koszul double structures on V in X (special members of DS): phi(x9) = Q2, phi(x10) = -Q1, phi(x11) = 0, phi(I_T) = 0,
-- Q_j = dF/dx_(9+j) (restricted to V mod I_V). I_Z = I_T + (x11) + (x9,x10)^2 + (x9 Q1 + x10 Q2) [+ check kernel equality in degrees <= 4].
-- usage: M2 --script dsk.m2 seed p [sdl]
pr = s -> (stderr << s << endl << flush);
BR = 1500; sd = value scriptCommandLine#1; p = value scriptCommandLine#2;
sdl = if #scriptCommandLine > 3 then value scriptCommandLine#3 else 0;
kk = ZZ/p; S = kk[x_0..x_11]; setRandomSeed(sd);
load "/home/claude/hodge/discovery/checks/cs2_t6/cslibS2.m2"; load "/home/claude/hodge/discovery/checks/cs2_t6/cslibS3.m2";
load "/home/claude/hodge/discovery/checks/cs2_t6/tlib.m2";
B3 = super basis(3, IV); F = (B3 * random(kk^(numColumns B3), kk^1))_(0,0);
pr("X smooth along V: " | toString(dim(IV + ideal jacobian matrix{{F}}) == 0));
Q = apply(3, j -> diff(x_(9+j), F) % IV);
IZ0 = trim(IT + ideal(x_11, x_9^2, x_9*x_10, x_10^2, x_9*Q#0 + x_10*Q#1));
-- kernel description check: I_Z(t) = {G in I_V(t) : phi(G) in I_V}, compare HF with V + rank of phi
IZ = saturate IZ0;
pr("I_Z saturated = I_Z0: " | toString(IZ == IZ0) | "; mingens degrees " | toString tally apply(flatten entries mingens IZ, g -> first degree g));
pr("Z: degree " | toString degree IZ | ", dim " | toString(dim IZ - 1) | ", radical = I_V: " | toString(radical IZ == IV) | ", F in I_Z: " | toString(F % IZ == 0) | ", I_V^2 in I_Z: " | toString isSubset(IV^2, IZ));
-- Z spans P^10 = {x11 = 0}: move x11 last (already last): kd = 10
kd = 10; typ = "DSK";
if sdl > 0 then (csCodimPkS2 = (F, I, kd, batchRows) -> csCodimPkS3(F, I, kd, batchRows, sdl); typ = typ | " sdl " | toString sdl);
load "/home/claude/hodge/discovery/checks/cs2_t6/common_tail.m2";
