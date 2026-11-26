-- writes the seed-1 instance of claim C as a Singular script (same construction and seed as C_check.m2 / C_smooth.m2)
sd = if #scriptCommandLine > 1 then value scriptCommandLine#1 else 1;
setRandomSeed sd;
kk = ZZ/32003;
S = kk[x_0..x_11];
lin8 = () -> sum(8, i -> random(kk) * x_i);
A = matrix table(3, 3, (i,j) -> lin8());
B = matrix table(3, 3, (i,j) -> lin8());
Q1 = random(2, S); Q2 = random(2, S);
F = x_10*Q1 + x_11*Q2 + det A + det B;
chk = sub(F, matrix{apply(12, i -> (i+1)_kk)});
fs = replace("x_", "x", toString F);
out = "ring r = 32003,(x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11),dp;\n" |
    "poly F = " | fs | ";\n" |
    "\"checksum (M2 says " | toString chk | "):\"; subst(F,x0,1,x1,2,x2,3,x3,4,x4,5,x5,6,x6,7,x7,8,x8,9,x9,10,x10,11,x11,12);\n" |
    "ideal J = jacob(F);\n" |
    "ideal sq = x0^2,x1^2,x2^2,x3^2,x4^2,x5^2,x6^2,x7^2,x8^2,x9^2,x10^2,x11^2;\n" |
    "intvec hv = hilb(std(sq),1);\n" |
    "int t = timer;\n" |
    "ideal G = std(J, hv);\n" |
    "\"Hilbert-driven std: size, dim, vdim, time:\"; size(G); dim(G); vdim(G); timer - t;\n" |
    "\"second Hilbert series of S/J:\"; hilb(G,2);\n" |
    "\"all elements of G reduce to 0 mod G (trivial) and J reduces to 0 mod G:\"; size(reduce(J,G));\n" |
    "quit;\n";
("C_singular_" | toString sd | ".sing") << out << close;
print("written, checksum " | toString chk);
