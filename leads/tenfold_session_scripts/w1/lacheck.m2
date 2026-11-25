pr = s -> (stderr << s << endl << flush);
p = 32003; kk = ZZ/p; S = kk[x_0..x_11];
setRandomSeed(value scriptCommandLine#1);
load "/home/claude/hodge/discovery/checks/w1/w1lib.m2";
I = trim w1cycle(scriptCommandLine#2);
B3 = super basis(3, I); F = (B3 * random(kk^(numColumns B3), kk^1))_(0,0);
if scriptCommandLine#3 == "P8" then w1codimP8(F, I) else w1codimLA(F, I);
