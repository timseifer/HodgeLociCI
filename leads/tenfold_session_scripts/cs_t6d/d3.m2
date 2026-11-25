-- CS-T6D: copy of cs_t6/d2.m2 with the streamed kernel (cslibS.m2). usage: M2 --script d3.m2 seed p typ
-- typ: R22 (two net quadrics), R23 (net quadric + cubic of I_V), R33 (two cubics of I_V)
pr = s -> (stderr << s << endl << flush);
BR = 1500; sd = value scriptCommandLine#1; p = value scriptCommandLine#2; typ = scriptCommandLine#3;
kk = ZZ/p; S = kk[x_0..x_11]; setRandomSeed(sd);
load "/home/claude/hodge/discovery/checks/w1/w1lib.m2"; load "/home/claude/hodge/discovery/checks/cs_t6d/cslibS.m2";
IV = trim w1cycle("J2T");
B3 = super basis(3, IV); F = (B3 * random(kk^(numColumns B3), kk^1))_(0,0);
J = ideal jacobian matrix{{F}};
pr("X smooth along V: " | toString(dim(IV + J) == 0));
u = ideal(x_9, x_10, x_11);
Q2 = select(flatten entries mingens IV, g -> first degree g == 2);   -- net quadrics (in x0..x5)
C3 = flatten entries super basis(3, IV);
q = () -> sum(Q2, g -> random(kk) * g);
c = () -> ((sum(C3, g -> random(kk) * g)) % u);
forms = if typ == "R22" then {q(), q()} else if typ == "R23" then {q(), c()} else if typ == "R33" then {c(), c()} else {q(), q(), q() + x_9 * sum(9, k -> random(kk) * x_k)};
CI = if typ == "R222" then ideal(F) + ideal(forms) + ideal(x_10, x_11) else ideal(F) + ideal(forms) + u;
pr("CI: codim " | toString codim CI | " degree " | toString degree CI);
IR = trim saturate(CI : IV);
pr("R: dim " | toString(dim IR - 1) | " degree " | toString degree IR | "; mingens degrees " | toString tally apply(flatten entries mingens IR, g -> first degree g));
pr("dim(R n V) = " | toString(dim(IR + IV) - 1) | ", deg(R n V) = " | toString degree(IR + IV));
pr("X smooth along R: " | toString(dim(IR + J) == 0));
-- Hodge-tangent of [R] (class a h^5 - [V]) and family codim
IJ = ideal gens gb (IR + J); bt = lift(basis(6, S/IJ), S); m = numColumns bt; pr("m_R = codim (I_R + J)_6 = " | toString m);
B6 = basis(6, S); mons = flatten entries B6; idx = new MutableHashTable; scan(#mons, i -> idx#(mons#i) = i);
L3 = flatten entries basis(3, S);
Cm = lift(last coefficients(B6 % IJ, Monomials => bt), kk);
rks = apply(m, j -> (v := flatten entries Cm^{j}; rank matrix table(#L3, #L3, (a,b) -> v_(idx#(L3#a * L3#b)))));
pr("codim T NL per functional: " | toString rks);
(c0, c1, h0) = if typ == "R222" then csCodimPkS(F, IR, 9, BR) else csCodimPkS(F, IR, 8, BR);
pr("RESULT D " | typ | " seed " | toString sd | " p " | toString p | ": deg R " | toString degree IR | ", m_R " | toString m | ", T NL codim " | toString rks | ", Hom_0 " | toString h0 | ", family codim w/o moduli " | toString c0 | ", WITH " | toString c1);
