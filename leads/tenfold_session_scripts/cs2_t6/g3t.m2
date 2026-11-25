-- CS2-T6 type G3 (L3): non-product join deformation. T = residual of P_f u P_h in a random net q_k = B^T N_k A (B = x0..x2, A = x3..x5),
-- ruling m_e = line(a(e), b(e)), e in E (plane cubic). sigma(e) = M a(e) in P^2' = (x9,x10,x11). W' = union <m_e, sigma(e)> (3-fold scroll over E,
-- degree 9), W = J(Pi, W') (Pi = x6..x8), Z = residual of V = J(Pi,T) in X n W (degree 21, class 9h^5 - [V]). usage: M2 --script g3.m2 seed p L3
pr = s -> (stderr << s << endl << flush);
BR = 1500; SDL = value scriptCommandLine#4; sd = value scriptCommandLine#1; p = value scriptCommandLine#2; typ = scriptCommandLine#3 | "sdl" | scriptCommandLine#4;
kk = ZZ/p; S = kk[x_0..x_11]; setRandomSeed(sd);
load "/home/claude/hodge/discovery/checks/cs2_t6/cslibS3.m2";
f = {x_0,x_1,x_2}; hA = {x_3,x_4,x_5};
qs = apply(3, k -> (Nk := random(kk^3, kk^3); sum flatten apply(3, i -> apply(3, j -> Nk_(i,j) * f#i * hA#j))));
IT = trim saturate(ideal qs : intersect(ideal f, ideal hA));
pr("T: dim " | toString(dim(IT + ideal(x_6..x_11)) - 1) | " degree " | toString degree(IT + ideal(x_6..x_11)) | " Hilbert poly " | toString hilbertPolynomial(IT + ideal(x_6..x_11), Projective => false));
IV = trim(IT + ideal(x_9, x_10, x_11));
M = random(kk^3, kk^3); MA = M * transpose matrix{hA};
IWp = trim saturate(IT + minors(2, (transpose matrix{{x_9, x_10, x_11}}) | MA), ideal hA);
pr("W: dim " | toString(dim IWp - 1) | " degree " | toString degree IWp | "; contains V: " | toString isSubset(IWp, IV) | "; mingens degrees " | toString tally apply(flatten entries mingens IWp, g -> first degree g));
B3 = super basis(3, IV); F = (B3 * random(kk^(numColumns B3), kk^1))_(0,0);
J = ideal jacobian matrix{{F}};
pr("X smooth along V: " | toString(dim(IV + J) == 0));
IZ = trim saturate((IWp + ideal F) : IV);
pr("Z: dim " | toString(dim IZ - 1) | " degree " | toString degree IZ | "; mingens degrees " | toString tally apply(flatten entries mingens IZ, g -> first degree g));
pr("dim(Z n V) = " | toString(dim(IZ + IV) - 1) | ", deg(Z n V) = " | toString degree(IZ + IV));
pr("Z contained in X: " | toString(F % IZ == 0) | "; X smooth along Z: " | toString(dim(IZ + J) == 0));
pr("Hilbert function of Z (deg 0..4): " | toString apply(5, i -> numColumns basis(i, S/IZ)));
G6 = gb(IZ + J, DegreeLimit => 6); LT = ideal leadTerm gens G6; bt = lift(basis(6, S/LT), S); m = numColumns bt; pr("m_Z = codim (I_Z + J)_6 = " | toString m);
rks = {"= T NL([V]) (m_Z = 1; class 9h^5 - [V]; ARG)"};
pr("codim T NL per functional: " | toString rks);
(c0, c1, h0) = csCodimPkS3(F, IZ, 11, BR, SDL);
pr("RESULT G " | typ | " seed " | toString sd | " p " | toString p | ": deg Z " | toString degree IZ | ", m_Z " | toString m | ", T NL codim " | toString rks | ", Hom_0 " | toString h0 | ", family codim w/o moduli " | toString c0 | ", WITH " | toString c1 | ", h0(N_Z/X) " | toString nZX | ", HF_Z(3) - Hom_0 " | toString(hf3Z - h0));
