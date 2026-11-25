-- CS-T6 type E: V' = J(Pi, T'), T' a degeneration of the AHTV scroll (special qnet). usage: M2 --script e1.m2 seed p typ
-- typ: gen (control), PL (qnet vanishing on a plane meeting P_f in a line, P_h in a point), PP (plane meeting each in a point)
pr = s -> (stderr << s << endl << flush);
sd = value scriptCommandLine#1; p = value scriptCommandLine#2; typ = scriptCommandLine#3;
kk = ZZ/p; S = kk[x_0..x_11]; setRandomSeed(sd);
load "/home/claude/hodge/discovery/checks/w1/w1lib.m2";
f = {x_0,x_1,x_2}; hv = {x_3,x_4,x_5};
zeroPos = if typ == "gen" then {} else if typ == "PL" then {(0,0),(1,0)} else if typ == "PL2" then {(0,0),(1,0),(1,1),(2,1)} else {(0,0),(0,1),(1,0),(1,1)};
qnet = apply(3, k -> (N := mutableMatrix random(kk^3, kk^3); scan(zeroPos, ij -> N_(ij#0, ij#1) = 0);
       sum flatten apply(3, i -> apply(3, j -> N_(i,j) * f#i * hv#j))));
w = ideal(x_6..x_11);
IT = trim saturate((ideal qnet + w) : intersect(ideal f + w, ideal hv + w));
pr("T': dim " | toString(dim IT - 1) | " deg " | toString degree IT | " Hilbert poly " | toString hilbertPolynomial(IT, Projective => false));
pr("T' components (dim, deg): " | toString apply(decompose IT, P -> (dim P - 1, degree P)));
IV = trim(ideal((gens IT) % w) + ideal(x_9, x_10, x_11));
pr("V': dim " | toString(dim IV - 1) | " deg " | toString degree IV);
B3 = super basis(3, IV); F = (B3 * random(kk^(numColumns B3), kk^1))_(0,0);
J = ideal jacobian matrix{{F}};
IJ = ideal gens gb (IV + J); pr("dim Sing(X) n V' = " | toString(dim IJ - 1) | " (-1: X smooth along V')");
bt = lift(basis(6, S/IJ), S); m = numColumns bt;
B6 = basis(6, S); mons = flatten entries B6; idx = new MutableHashTable; scan(#mons, i -> idx#(mons#i) = i);
L3 = flatten entries basis(3, S);
Cm = lift(last coefficients(B6 % IJ, Monomials => bt), kk);
rks = apply(min(m,4), j -> (v := flatten entries Cm^{j}; rank matrix table(#L3, #L3, (a,b) -> v_(idx#(L3#a * L3#b)))));
pr("m = " | toString m | ", codim T NL per functional " | toString rks);
(c0, c1, h0) = w1codimP8(F, IV);
pr("RESULT E " | typ | " seed " | toString sd | " p " | toString p | ": m " | toString m | ", T NL codim " | toString rks | ", Hom_0 " | toString h0 | ", family codim w/o moduli " | toString c0 | ", WITH " | toString c1);
