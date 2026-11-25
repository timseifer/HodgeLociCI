-- CS3-M2 validation of csLowBound (all generators of degree <= 3, so with smax large it must equal the full Hom computation):
-- typ V (expect Hom_0 81, codim 55) and DSK (expect Hom_0 178, codim 55, as dsk.m2 / csCodimPkS2). usage: M2 --script vlow.m2 seed p typ smax
pr = s -> (stderr << s << endl << flush);
sd = value scriptCommandLine#1; p = value scriptCommandLine#2; typ = scriptCommandLine#3; smax = value scriptCommandLine#4; ntr = if #scriptCommandLine > 5 then value scriptCommandLine#5 else 40;
kk = ZZ/p; S = kk[x_0..x_11]; setRandomSeed(sd);
load "/home/claude/hodge/discovery/checks/cs3_m2/csLow.m2";
load "/home/claude/hodge/discovery/checks/cs2_t6/tlib.m2";
B3 = super basis(3, IV); F = (B3 * random(kk^(numColumns B3), kk^1))_(0,0);
IZ = if typ == "V" then IV else (Q = apply(3, j -> diff(x_(9+j), F) % IV); trim(IT + ideal(x_11, x_9^2, x_9*x_10, x_10^2, x_9*Q#0 + x_10*Q#1)));
G = forceGB gens gb IZ; LT = ideal leadTerm gens gb IZ;
(c0, c1, h0) = csLowBound(F, mingens IZ, G, LT, smax, 3000, ntr);
pr("RESULT VLOW " | typ | " smax " | toString smax | " seed " | toString sd | " p " | toString p | ": Hom superset " | toString h0 | ", codim w/o " | toString c0 | ", codim WITH >= " | toString c1);
