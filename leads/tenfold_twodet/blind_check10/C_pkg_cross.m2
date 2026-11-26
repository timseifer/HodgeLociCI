-- cross-check only: the package function hodgeLocusTangentCodim on the seed-1 instance of claim C (same construction as C_check.m2)
needsPackage("HodgeLociCI", FileName => "/home/claude/hodgelocici/M2/HodgeLociCI.m2");
pr = s -> (stdio << s << endl << flush;);
setRandomSeed 1;
kk = ZZ/32003;
S = kk[x_0..x_11];
lin8 = () -> sum(8, i -> random(kk) * x_i);
A = matrix table(3, 3, (i,j) -> lin8());
B = matrix table(3, 3, (i,j) -> lin8());
Q1 = random(2, S); Q2 = random(2, S);
F = x_10*Q1 + x_11*Q2 + det A + det B;
pr("checksum " | toString sub(F, matrix{apply(12, i -> (i+1)_kk)}));
T5 = ideal(x_10, x_11) + minors(2, A^{0,1}) + minors(2, B^{0,1});
t0 = cpuTime();
r = hodgeLocusTangentCodim(F, T5);
pr(toString r);
pr("time " | toString(cpuTime() - t0));
