-- determine x_a = psi(c_a m0) from sparse P with known psi.  usage: M2 --script cub2.m2 seed
pr = s -> (stderr << s << endl << flush);
kk = ZZ/32003; S = kk[x_0..x_11]; setRandomSeed value scriptCommandLine#1;
load "/home/claude/hodge/discovery/checks/so_t6/w1lib.m2";
load "/home/claude/hodge/discovery/checks/so_t6/solib.m2";
I = trim w1cycle("J2T");
B3 = super basis(3, I); F = (B3 * random(kk^(numColumns B3), kk^1))_(0,0);
(piRow, IJ, m0) = soNF(F, I);
lin = soPsiBlin(F, I, piRow, IJ, m0);
Jr = flatten entries jacobian matrix{{F}}; g = flatten entries mingens I; cs = select(g, u -> first degree u == 3);
m7 = flatten entries basis(7, S); m3 = flatten entries basis(3, S);
-- J-type: P = mu7 * dF_j, known psi = pi(d_j mu7)/6;  I^2-type: P = c * c' * mu3, known 0
eqs = {};
t0 = cpuTime();
for t from 0 to 7 do (
    j := random 12; mu := m7#(random(#m7));
    P := mu * Jr#j; known := (first piRow matrix{{diff(S_j, mu)}}) / 6;
    vc := first lin matrix{{P}};
    eqs = append(eqs, (vc#1, known - vc#0));
    pr("J-type eq " | toString t | ": coefs " | toString(vc#1) | " rhs " | toString(known - vc#0) | " time " | toString(cpuTime()-t0)));
for t from 0 to 3 do (
    P := cs#(t % 2) * (g#(random(#g))) * m3#(random(#m3)) * (if t > 1 then x_8^2 else 1_S);
    if first degree P != 9 then continue;
    vc := first lin matrix{{P}};
    eqs = append(eqs, (vc#1, 0 - vc#0));
    pr("I2-type eq: coefs " | toString(vc#1) | " rhs " | toString(0 - vc#0) | " time " | toString(cpuTime()-t0)));
Mx = matrix apply(eqs, e -> e#0); bx = matrix apply(eqs, e -> {e#1});
pr("rank coefs " | toString rank Mx | ", rank augmented " | toString rank(Mx | bx) | " (consistent iff equal)");
if rank Mx == #cs then (xs = flatten entries solve(Mx, bx); pr("x = psi(c m0) = " | toString xs));
