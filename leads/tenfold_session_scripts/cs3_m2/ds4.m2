-- CS3-M2 type DS: double structure Z on V inside X, Z = ker(phi), phi in Hom(I_V, S/I_V)_e, phi(F) = 0 (random in that space).
-- usage: M2 --script ds1.m2 seed p e [sdl]   (sdl: optional syzygy degree limit -> cslibS3, lower bound on codim)
pr = s -> (stderr << s << endl << flush);
BR = 1500; sd = value scriptCommandLine#1; p = value scriptCommandLine#2; ee = value scriptCommandLine#3;
smax = if #scriptCommandLine > 4 then value scriptCommandLine#4 else 5; ntr = if #scriptCommandLine > 5 then value scriptCommandLine#5 else 40;
kk = ZZ/p; S = kk[x_0..x_11]; setRandomSeed(sd);
load "/home/claude/hodge/discovery/checks/cs3_m2/csLow.m2";
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
-- generic double structure, F4 route (06:5xZ attempts with Buchberger did not finish)
cands = sort(flatten entries gens(IV^2) | flatten entries (g * Klift), u -> first degree u);
cands = select(cands, u -> u != 0);
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
Gc = gb(ideal chosen, Algorithm => LinearAlgebra);
LTc = ideal leadTerm gens Gc; LTf = ideal leadTerm Gm;
pr("check: HF(0..7) of chosen " | toString apply(8, i -> numColumns basis(i, S/LTc)) | " vs full " | toString apply(8, i -> numColumns basis(i, S/LTf)));
pr("Z: degree " | toString degree LTf | ", dim " | toString(dim LTf - 1) | "; F in I_Z: " | toString((matrix{{F}} % (forceGB Gm)) == 0) | "; mingens degrees " | toString tally apply(chosen, u -> first degree u));
-- m_Z and T NL not recomputed (ARG): Z_red = V, the class is 2[V], whose period functional is twice that of [V] (m = 1, T NL codim 54 as V);
-- X smooth along Z iff X smooth along V (printed above).
m = 1; rks = {"54 (as V, ARG)"};
Gfull = forceGB Gm; gl = matrix{select(chosen, u -> first degree u <= 3)};
(c0, c1, h0) = csLowBound(F, gl, Gfull, LTf, smax, 3000, ntr);
pr("RESULT DS-LOW e=" | toString ee | " smax " | toString smax | " seed " | toString sd | " p " | toString p | ": deg Z " | toString degree LTf | ", m_Z " | toString m | ", T NL codim " | toString rks | ", low-Hom superset " | toString h0 | ", codim w/o moduli " | toString c0 | ", codim WITH >= " | toString c1);
