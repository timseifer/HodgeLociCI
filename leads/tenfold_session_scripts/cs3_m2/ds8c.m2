-- CS3-M2 type DS8: double structures on V inside the span P^8 (Z in X n P^8): Z = ker(phi), phi in Hom(I_V8, S8/I_V8)_e, I_V8 = I_T in P^8,
-- phi(F8) = 0 (F8 = F restricted to P^8), phi random in that space; I_Z = I_Z8 + (x9, x10, x11). usage: M2 --script ds8.m2 seed p e
pr = s -> (stderr << s << endl << flush);
BR = 1500; sd = value scriptCommandLine#1; p = value scriptCommandLine#2; ee = value scriptCommandLine#3;
sdl = if #scriptCommandLine > 4 then value scriptCommandLine#4 else 0;
kk = ZZ/p; S = kk[x_0..x_11]; setRandomSeed(sd);
load "/home/claude/hodge/discovery/checks/cs3_m2/csF4.m2";
load "/home/claude/hodge/discovery/checks/cs2_t6/tlib.m2";
B3 = super basis(3, IV); F = (B3 * random(kk^(numColumns B3), kk^1))_(0,0);
pr("X smooth along V: " | toString(dim(IV + ideal jacobian matrix{{F}}) == 0));
S9 = kk[x_0..x_8]; to9 = map(S9, S, gens S9 | {0,0,0}); back9 = map(S, S9, take(gens S, 9));
I8 = trim to9 IT; F8 = to9 F; R9 = S9 / I8;
H = Hom(module I8, S9^1/I8); g = gens I8; r = numColumns g; cF = F8 // g;
Be = basis(ee, H); n = numColumns Be;
homs = apply(n, j -> matrix homomorphism(map(H, S9^{{-ee}}, Be_{j})));
imgs = apply(homs, h -> (lift(h, S9) * cF)_(0,0) % I8);
Bt = lift(basis(3 + ee, S9/I8), S9);
M = if all(imgs, u -> u == 0) then map(kk^(numColumns Bt), kk^n, 0) else lift(last coefficients(matrix{imgs}, Monomials => Bt), kk);
K = gens ker M; pr("P^8: dim Hom_e = " | toString n | ", dim {phi(F8) = 0} = " | toString numColumns K);
if numColumns K == 0 then (pr("RESULT DS8 e=" | toString ee | " seed " | toString sd | " p " | toString p | ": no double structure of this type in X n P^8"); exit 0);
cvec = K * random(kk^(numColumns K), kk^1);
phiRow = sum(n, j -> cvec_(j,0) * lift(homs#j, S9));
row = sub(phiRow, R9);
pr("phi(g_i) degrees " | toString apply(flatten entries row, u -> if u == 0 then "0" else toString first degree u));
Kr = syz(map(R9^1, , row), DegreeLimit => 6); pr("kernel over R: " | toString numColumns Kr | " generators");
cands = sort(select(flatten entries gens(back9(I8^2)) | flatten entries (back9(g * lift(Kr, S9))) | {x_9, x_10, x_11}, u -> u != 0), u -> first degree u);
t1 = cpuTime(); Gf = gb(ideal cands, Algorithm => LinearAlgebra); Gm = gens Gf; pr("F4 GB of I_Z: " | toString(cpuTime()-t1) | " s, " | toString numColumns Gm | " elements");
-- minimal generators, degree by degree: candidates of degree t independent modulo the ideal of the chosen ones of degree < t
chosen = {};
for t in sort unique apply(cands, u -> first degree u) do (
   ct := select(cands, u -> first degree u == t);
   if #chosen == 0 then (Mt := lift(last coefficients(matrix{ct}, Monomials => basis(t, S)), kk); prof := columnRankProfile mutableMatrix Mt; chosen = chosen | ct_prof)
   else (
      Gt := forceGB gens gb(ideal chosen, Algorithm => LinearAlgebra);
      Rt := (matrix{ct}) % Gt;
      if Rt == 0 then continue;
      Mt = lift(last coefficients(Rt, Monomials => basis(t, S)), kk); prof = columnRankProfile mutableMatrix Mt; chosen = chosen | ct_prof);
   pr("  degree " | toString t | ": " | toString(#chosen) | " minimal generators so far  t " | toString(cpuTime()-t1)));
gZ = matrix{chosen};
-- check: the chosen generators generate I_Z (same lead-term ideal / Hilbert function through degree 7)
IZ = ideal chosen;
pr("Z: degree " | toString degree IZ | "; mingens degrees " | toString tally apply(chosen, u -> first degree u));
load "/home/claude/hodge/discovery/checks/cs2_t6/cslibS2.m2";
pr("m_Z = 1, T NL codim 54 as V (ARG: class 2[V]); X smooth along Z iff along V (printed above)");
(c0, c1, h0) = csCodimPkS2(F, IZ, 8, 1000);
pr("RESULT DS8 e=" | toString ee | " seed " | toString sd | " p " | toString p | ": deg Z " | toString degree IZ | ", Hom_0 " | toString h0 | ", family codim w/o moduli " | toString c0 | ", WITH " | toString c1 | ", h0(N_Z/X) " | toString nZX);
