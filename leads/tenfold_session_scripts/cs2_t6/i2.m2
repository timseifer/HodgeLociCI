-- CS2-T6 type I2: P^3-bundles over T other than V. I2a: Z = J(l0, W'), W' = union_e <m_e, sigma(e)>, sigma(e) = M a(e) in the plane C = (x8,x9,x10),
-- l0 = line (x6,x7); fibre over p in m_e: <l0, p, sigma(e)> = P^3 (bundle O^2 + O_T(-1) + pi^*L_a^-1 on T); degree 9, spans P^10 (x11 = 0).
-- usage: M2 --script i2.m2 seed p I2a
pr = s -> (stderr << s << endl << flush);
BR = 1500; sd = value scriptCommandLine#1; p = value scriptCommandLine#2; typ = scriptCommandLine#3;
kk = ZZ/p; S = kk[x_0..x_11]; setRandomSeed(sd);
load "/home/claude/hodge/discovery/checks/cs2_t6/cslibS2.m2";
fB = {x_0,x_1,x_2}; hA = {x_3,x_4,x_5};
qs = apply(3, k -> (Nk := random(kk^3, kk^3); sum flatten apply(3, i -> apply(3, j -> Nk_(i,j) * fB#i * hA#j))));
IT = trim saturate(ideal qs : intersect(ideal fB, ideal hA));
M = random(kk^3, kk^3); MA = M * transpose matrix{hA};
IZ = trim(saturate(IT + minors(2, (transpose matrix{{x_8, x_9, x_10}}) | MA), ideal hA) + ideal(x_11));
pr("I_Z(3) dimension: " | toString numColumns super basis(3, IZ));
B3 = super basis(3, IZ); F = (B3 * random(kk^(numColumns B3), kk^1))_(0,0);
kd = 10; typ = "I2 " | typ;
load "/home/claude/hodge/discovery/checks/cs2_t6/common_tail.m2";
