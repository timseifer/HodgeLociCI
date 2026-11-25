-- CS-T6 type C: determinantal 5-folds of degree 6 not of join type. usage: M2 --script c1.m2 seed p typ
-- typ D34: {rank M <= 2}, M a random 3 x 4 matrix of linear forms on P^7 (codim 2, degree 6)
pr = s -> (stderr << s << endl << flush);
sd = value scriptCommandLine#1; p = value scriptCommandLine#2; typ = scriptCommandLine#3;
kk = ZZ/p; S = kk[x_0..x_11]; setRandomSeed(sd);
load "/home/claude/hodge/discovery/checks/w1/w1lib.m2"; load "/home/claude/hodge/discovery/checks/cs_t6/cslib.m2";
M = matrix table(3, 4, (i,j) -> sum(8, k -> random(kk) * x_k));
IZ = trim(minors(3, M) + ideal(x_8..x_11));
pr("Z: dim " | toString(dim IZ - 1) | " deg " | toString degree IZ | " sing dim " | toString(dim(IZ + minors(2, M)) - 1));
B3 = super basis(3, IZ); F = (B3 * random(kk^(numColumns B3), kk^1))_(0,0);
J = ideal jacobian matrix{{F}};
IJ = ideal gens gb (IZ + J); pr("dim Sing(X) n Z = " | toString(dim IJ - 1));
bt = lift(basis(6, S/IJ), S); m = numColumns bt;
B6 = basis(6, S); mons = flatten entries B6; idx = new MutableHashTable; scan(#mons, i -> idx#(mons#i) = i);
L3 = flatten entries basis(3, S);
Cm = lift(last coefficients(B6 % IJ, Monomials => bt), kk);
rks = apply(min(m,4), j -> (v := flatten entries Cm^{j}; rank matrix table(#L3, #L3, (a,b) -> v_(idx#(L3#a * L3#b)))));
pr("m = " | toString m | ", codim T NL per functional " | toString rks);
(c0, c1, h0) = csCodimP8(F, IZ);
pr("RESULT C " | typ | " seed " | toString sd | " p " | toString p | ": m " | toString m | ", T NL codim " | toString rks | ", Hom_0 " | toString h0 | ", family codim w/o moduli " | toString c0 | ", WITH " | toString c1);
