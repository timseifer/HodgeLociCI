-- CS2-T6 type G3: residual Z of V = J(Pi,T) in X n W, W a non-CI 6-fold containing V. usage: M2 --script g1.m2 seed p typ
-- typ L1: W = J(<Pi, e_9>, T)  (Z in P^9);  L2: W = J(Pi, J(e_5, T)) (cone over T from a general point of P^5; Z in P^8)
pr = s -> (stderr << s << endl << flush);
BR = 1500; sd = value scriptCommandLine#1; p = value scriptCommandLine#2; typ = scriptCommandLine#3;
kk = ZZ/p; S = kk[x_0..x_11]; setRandomSeed(sd);
load "/home/claude/hodge/discovery/checks/w1/w1lib.m2"; load "/home/claude/hodge/discovery/checks/cs2_t6/cslibS2.m2";
IV = trim w1cycle("J2T");
B3 = super basis(3, IV); F = (B3 * random(kk^(numColumns B3), kk^1))_(0,0);
J = ideal jacobian matrix{{F}};
pr("X smooth along V: " | toString(dim(IV + J) == 0));
IT = ideal select(flatten entries mingens IV, g -> not member(g, {x_9,x_10,x_11}));
IW = (if typ == "V0" then IV + ideal(x_9) else if typ == "L1" then IT + ideal(x_10, x_11) else if typ == "L2" then (ITc := eliminate(x_5, ideal((gens IT) % ideal(x_6..x_11))); trim(ITc + ideal(x_9,x_10,x_11))) else error "typ");
pr("W: dim " | toString(dim IW - 1) | " degree " | toString degree IW | "; W contains V: " | toString(isSubset(IW, IV)) | "; mingens degrees " | toString tally apply(flatten entries mingens IW, g -> first degree g));
IZ = if typ == "V0" then IV else trim saturate((IW + ideal F) : IV);
pr("Z: dim " | toString(dim IZ - 1) | " degree " | toString degree IZ | "; mingens degrees " | toString tally apply(flatten entries mingens IZ, g -> first degree g));
pr("dim(Z n V) = " | toString(dim(IZ + IV) - 1) | ", deg(Z n V) = " | toString degree(IZ + IV));
pr("Z contained in X: " | toString(F % IZ == 0) | "; X smooth along Z: " | toString(dim(IZ + J) == 0));
pr("Hilbert function of Z (deg 0..4): " | toString apply(5, i -> numColumns basis(i, S/IZ)));
IJ = ideal gens gb (IZ + J); bt = lift(basis(6, S/IJ), S); m = numColumns bt; pr("m_Z = codim (I_Z + J)_6 = " | toString m);
B6 = basis(6, S); mons = flatten entries B6; idx = new MutableHashTable; scan(#mons, i -> idx#(mons#i) = i);
L3 = flatten entries basis(3, S);
Cm = lift(last coefficients(B6 % IJ, Monomials => bt), kk);
rks = apply(min(m,3), j -> (v := flatten entries Cm^{j}; rank matrix table(#L3, #L3, (a,b) -> v_(idx#(L3#a * L3#b)))));
pr("codim T NL per functional: " | toString rks);
kd = if typ == "L1" then 9 else 8;
(c0, c1, h0) = csCodimPkS2(F, IZ, kd, BR);
pr("RESULT G " | typ | " seed " | toString sd | " p " | toString p | ": deg Z " | toString degree IZ | ", m_Z " | toString m | ", T NL codim " | toString rks | ", Hom_0 " | toString h0 | ", family codim w/o moduli " | toString c0 | ", WITH " | toString c1 | ", h0(N_Z/X) " | toString nZX | ", HF_Z(3) - Hom_0 " | toString(hf3Z - h0));
