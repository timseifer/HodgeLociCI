-- CS3-M2 type DS: double structure Z on V inside X, Z = ker(phi), phi in Hom(I_V, S/I_V)_e, phi(F) = 0 (random in that space).
-- usage: M2 --script ds1.m2 seed p e [sdl]   (sdl: optional syzygy degree limit -> cslibS3, lower bound on codim)
pr = s -> (stderr << s << endl << flush);
BR = 1500; sd = value scriptCommandLine#1; p = value scriptCommandLine#2; ee = value scriptCommandLine#3;
sdl = if #scriptCommandLine > 4 then value scriptCommandLine#4 else 0;
kk = ZZ/p; S = kk[x_0..x_11]; setRandomSeed(sd);
load "/home/claude/hodge/discovery/checks/cs2_t6/cslibS2.m2"; load "/home/claude/hodge/discovery/checks/cs2_t6/cslibS3.m2";
load "/home/claude/hodge/discovery/checks/cs2_t6/tlib.m2";
B3 = super basis(3, IV); F = (B3 * random(kk^(numColumns B3), kk^1))_(0,0);
pr("X smooth along V: " | toString(dim(IV + ideal jacobian matrix{{F}}) == 0));
H = Hom(module IV, S^1/IV); g = gens IV; r = numColumns g; cF = F // g;
Be = basis(ee, H); n = numColumns Be;
homs = apply(n, j -> matrix homomorphism(map(H, S^{{-ee}}, Be_{j})));   -- each: 1 x r matrix over S/IV (images of generators)
imgs = apply(homs, h -> (lift(h, S) * cF)_(0,0) % IV);
Bt = lift(basis(3 + ee, S/IV), S);
M = lift(last coefficients(matrix{imgs}, Monomials => Bt), kk);
K = gens ker M; pr("dim Hom_e = " | toString n | ", dim {phi(F) = 0} = " | toString numColumns K);
cvec = K * random(kk^(numColumns K), kk^1);
phiRow = sum(n, j -> cvec_(j,0) * lift(homs#j, S));   -- 1 x r over S, images of generators of I_V (mod I_V)
-- I_Z via syzygies over R = k[x0..x8]/I_T (coordinate ring of V): I_Z = I_V^2 + { sum a_i g_i : sum a_i phi(g_i) = 0 in R }
S9 = kk[x_0..x_8]; to9 = map(S9, S, gens S9 | {0,0,0}); R9 = S9 / trim to9(IT); toR = map(R9, S, (gens R9) | {0_R9, 0_R9, 0_R9});
row = toR phiRow;
pr("phi(g_i) degrees " | toString apply(flatten entries row, u -> if u == 0 then "0" else toString first degree u));
Kr = syz(map(R9^1, , row), DegreeLimit => 6);
pr("kernel over R: " | toString numColumns Kr | " generators");
back9 = map(S, S9, take(gens S, 9));
Klift = back9 lift(Kr, S9);
IZr = IV^2 + ideal(g * Klift);
t1 = cpuTime(); Gf = gb(IZr, Algorithm => LinearAlgebra); pr("F4 gb of I_Z: " | toString(cpuTime() - t1) | " s, #GB elements " | toString numColumns gens Gf);
t1 = cpuTime(); IZ = ideal mingens IZr; pr("mingens: " | toString(cpuTime() - t1) | " s, degrees " | toString tally apply(flatten entries gens IZ, u -> first degree u));
pr("degree " | toString degree IZ | ", HF(0..5) " | toString apply(6, i -> numColumns basis(i, S/IZ)));
exit 0;
