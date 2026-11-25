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
-- I_Z degree-wise (the syzygy route blew up, 06:25Z): I_Z(t) = {G in I_V(t) : phi(G) = 0 in (S/I_V)_(t+1)}, t <= 4, plus I_V^2
gl = flatten entries g;
IZt = t -> (
   sp := flatten apply(r, i -> (dgi := first degree gl#i; if dgi > t then {} else apply(flatten entries basis(t - dgi, S), mm -> (mm * gl#i, mm * phiRow_(0,i)))));
   Bt1 := lift(basis(t + 1, S/IV), S);
   Mt := lift(last coefficients(matrix{apply(sp, u -> u#1 % IV)}, Monomials => Bt1), kk);
   Kt := gens ker Mt;
   matrix{apply(sp, u -> u#0)} * sub(Kt, S));
IZ = IV^2; for t from 2 to 4 do (IZ = IZ + ideal IZt(t); pr("  I_Z built through degree " | toString t));
IZ = trim IZ;
rk5 = (sp := flatten apply(r, i -> (dgi := first degree gl#i; apply(flatten entries basis(5 - dgi, S), mm -> mm * phiRow_(0,i)))); rank lift(last coefficients(matrix{apply(sp, u -> u % IV)}, Monomials => lift(basis(6, S/IV), S)), kk));
pr("check generation: HF_Z(5) from ideal = " | toString numColumns basis(5, S/IZ) | ", expected HF_V(5) + rank phi on I_V(5) = " | toString(numColumns basis(5, S/IV) + rk5));
pr("I_V^2 in I_Z: " | toString(isSubset(IV^2, IZ)) | "; I_Z in I_V: " | toString(isSubset(IZ, IV)) | "; F in I_Z: " | toString(F % IZ == 0));
pr("linear forms in I_Z: " | toString numColumns super basis(1, IZ));
kd = 11 - numColumns super basis(1, IZ);
if kd < 11 then error "Z in a smaller span; recoordinatise first";
typ = "DS e=" | toString ee;
if sdl > 0 then (csCodimPkS2 = (F, I, kd, batchRows) -> csCodimPkS3(F, I, kd, batchRows, sdl); typ = typ | " sdl " | toString sdl);
load "/home/claude/hodge/discovery/checks/cs2_t6/common_tail.m2";
