pr = s -> (stderr << s << endl << flush);
kk = ZZ/32003; S = kk[x_0..x_11]; setRandomSeed(1);
load "/home/claude/hodge/discovery/checks/w1/w1lib.m2"; load "/home/claude/hodge/discovery/checks/cs_t6/cslib.m2";
IV = trim w1cycle("J2T"); B3 = super basis(3, IV); F = (B3 * random(kk^(numColumns B3), kk^1))_(0,0);
pr("P8 version: " | toString csCodimP8(F, IV)); pr("Pk k=8: " | toString csCodimPk(F, IV, 8)); pr("Pk k=9: " | toString csCodimPk(F, IV, 9));
