-- W1 (a): Hodge-locus tangent codim of [V] at a random X containing V (MOD p).
-- usage: M2 --script hlft.m2 seed type
-- Period functional pi on S_6 vanishes on (I_V + J_F)_6; tangent space = {G in S_3 : pi(G S_3) = 0}.
-- If ann (I+J)_6 has dim m > 1 we report rank for each basis functional and for a random combination.
pr = s -> (stderr << s << endl << flush);
p = 32003; kk = ZZ/p; S = kk[x_0..x_11];
setRandomSeed(value scriptCommandLine#1); typ = scriptCommandLine#2;
load "/home/claude/hodge/discovery/checks/w1/w1lib.m2";
I0 = w1cycle(typ);
I = trim (map(S, S, random(S^1, S^{12:-1}))) I0;
pr("type " | typ | ": dim " | toString(dim I - 1) | " degree " | toString(degree I));
B3 = super basis(3, I);
F = (B3 * random(kk^(numColumns B3), kk^1))_(0,0);
J = ideal jacobian matrix{{F}};
t0 = cpuTime();
pr("smoothness not checked");
(r, m) = w1tangent(F, I);
pr("RESULT codimIJ m = " | toString m | "; ranks per basis functional / random combination: " | toString r);
