-- SO-T6 main tenfold test.  usage: M2 --script t10c.m2 seed [prime] [mode]
-- mode "G" (default): first factor = the extra direction G_e;  mode "h": first factor = a random h in T F_T (control c1).
-- Matrix M[y,z] = psi(A y z), A the first factor, y in Y (spanning T F_T), z in Z = Y u {G_e} (spanning T NL).
-- Y = Yi (basis of I_3) u Yj (x_l dF/dx_j) u Yh (the 54 Hom'_0 directions of w1codimP8; its 27 u-directions lie in I_3 + J S_1).
pr = s -> (stderr << s << endl << flush);
sd = value scriptCommandLine#1;
p = if #scriptCommandLine > 2 then value scriptCommandLine#2 else 32003;
mode = if #scriptCommandLine > 3 then scriptCommandLine#3 else "G";
kk = ZZ/p; S = kk[x_0..x_11];
setRandomSeed(sd);
load "/home/claude/hodge/discovery/checks/so_t6/w1lib.m2";
load "/home/claude/hodge/discovery/checks/so_t6/solib.m2";
T0 = cpuTime();
tm = () -> toString(round(cpuTime() - T0)) | "s";
I = trim w1cycle("J2T");
B3 = super basis(3, I); F = (B3 * random(kk^(numColumns B3), kk^1))_(0,0);
w1codimP8(F, I);
(piRow, IJ, m0) = soNF(F, I);
pr("m0 = " | toString m0 | "; HF_9 S/(I^2+J) = " | toString hilbertFunction(9, S/(ideal gens trim(I^2) + ideal jacobian matrix{{F}})));
m3 = basis(3, S); L3 = flatten entries m3; cf = M -> lift(last coefficients(M, Monomials => m3), kk);
B6 = basis(6, S); B4 = basis(4, S);
Pi6 = (B6 * transpose matrix{piRow B6})_(0,0);
pr("Pi6 terms " | toString(#terms Pi6) | " " | tm());
-- first-order pairing and T NL
idx = new MutableHashTable; mons = flatten entries B6; scan(#mons, i -> idx#(mons#i) = i);
pv = flatten entries lift(last coefficients(Pi6, Monomials => B6), kk);
Pm = matrix table(#L3, #L3, (i,j) -> pv#(idx#(L3#i * L3#j)));
TNL = matrix nullSpace mutableMatrix Pm; pr("dim T NL = " | toString numColumns TNL);
-- generating sets
nIb = numColumns super basis(3, I);
Yi = flatten entries super basis(3, I);
nh = #w1TFpolys - nIb - 27 - 144; Yh = take(drop(w1TFpolys, nIb), nh);
Yj = flatten table(12, 12, (l, j) -> x_l * diff(x_j, F));
TFall = cf(matrix{Yi | Yh | Yj}); rTF = rank TFall;
pr("#Yi " | toString(#Yi) | " #Yh " | toString(#Yh) | " #Yj " | toString(#Yj) | "; rank span = " | toString rTF | " (W1: 309); rank incl. u-dirs " | toString rank cf(matrix{w1TFpolys}));
pr("T F_T inside T NL: " | toString(rank(TNL | TFall) == numColumns TNL));
Ge = null; for j from 0 to numColumns TNL - 1 do if rank(TFall | TNL_{j}) > rTF then (Ge = (m3 * sub(TNL_{j}, S))_(0,0); break);
-- c2: a random cubic is not in T NL
gout = random(3, S); pr("c2: rank of Q -> pi(Q g), g random (should be > 0): " | toString rank matrix{piRow(m3 * gout)});
A = if mode == "G" then Ge else (matrix{Yi | Yh | Yj} * random(kk^(#Yi + #Yh + #Yj), kk^1))_(0,0);
Zs = Yi | Yj | Yh | {Ge};
nYi = #Yi; nYj = #Yj; nYh = #Yh; nZ = #Zs;
-- decompositions W_z = A z = c_z m0 + (I part) + sum_i C_(z,i) dF_i
Jr = flatten entries jacobian matrix{{F}};
g = flatten entries mingens I; r = #g; GIJ = matrix{g | Jr};
Wm = matrix{apply(Zs, z -> A * z)};
cofW = Wm // GIJ; cW = flatten entries lift(last coefficients(Wm % IJ, Monomials => matrix{{m0}}), kk);
pr("W decompositions " | tm());
Wvec = lift(last coefficients(Wm, Monomials => B6), kk);                    -- 12376 x nZ
Cvec = fold((a, b) -> a || b, apply(12, i -> lift(last coefficients(cofW^{r + i}, Monomials => B4), kk)));  -- (12*1365) x nZ
pr("coefficient matrices " | tm());
-- rows Yj: (1/6) < W_z , contract(x_l, Pi^(j)) >
PiI = apply(12, i -> x_i * diff(x_i, x_i * Pi6));
DJ = fold((a, b) -> a || b, flatten table(12, 12, (l, j) -> transpose lift(last coefficients(contract(x_l, PiI#j), Monomials => B6), kk)));
inv6 = 1_kk / 6;
MJ = inv6 * (DJ * Wvec);                                                       -- nYj x nZ
pr("rows Yj " | tm());
-- psi(g m0), g in Yi, by the generic evaluator (Option B)
(psiB, psiCub) = soPsiB(F, I, piRow, IJ, m0, 0);
(psiB2, psiCub2) = soPsiB(F, I, piRow, IJ, m0, 1);
pr("psi(g_a m0), cubic generators, two splittings of m0 (c4): " | toString psiCub | " / " | toString psiCub2);
pgm = psiB matrix{apply(Yi, u -> u * m0)};
pr("psi(g m0) for g in I_3 " | tm());
DI = fold((a, b) -> a || b, apply(Yi, u -> matrix{flatten apply(12, i -> flatten entries lift(last coefficients(contract(diff(x_i, u), Pi6), Monomials => B4), kk))}));
MI = inv6 * (DI * Cvec) + (transpose matrix{pgm}) * matrix{cW};                  -- nYi x nZ
pr("rows Yi " | tm());
-- c4: symmetry between the two formulas
symII = MI_{0 .. nYi - 1} - transpose(MI_{0 .. nYi - 1});
symIJ = MI_{nYi .. nYi + nYj - 1} - transpose(MJ_{0 .. nYi - 1});
symJJ = MJ_{nYi .. nYi + nYj - 1} - transpose(MJ_{nYi .. nYi + nYj - 1});
pr("c4 symmetry (all should be 0): I-I " | toString rank symII | ", I-J " | toString rank symIJ | ", J-J " | toString rank symJJ);
-- generic block: y, z in Yh u {Ge}
E = Yh | {Ge}; nE = #E;
MEE = mutableMatrix(kk, nE, nE);
for a from 0 to nE - 1 do (
    vals := psiB matrix{apply(nE, b -> A * E#a * E#b)};
    for b from 0 to nE - 1 do MEE_(a,b) = vals#b;
    if a % 10 == 0 then pr("  generic row " | toString a | " " | tm()));
MEE = matrix MEE;
pr("c4 symmetry of generic block (0): " | toString rank(MEE - transpose MEE));
-- check generic evaluator against the cheap formulas on a sample (c4)
smp = apply(5, t -> (random nYi, random nYj));
pr("c4 generic vs I-formula on A*g*xl dF_j: " | toString apply(smp, ab -> ((psiB matrix{{A * Yi#(ab#0) * Yj#(ab#1)}})#0, MI_(ab#0, nYi + ab#1))));
pr("c4 generic vs J-formula on A*Yh*xl dF_j: " | toString apply(3, t -> (a := random nYh; b := random nYj; ((psiB matrix{{A * Yh#a * Yj#b}})#0, MJ_(b, nYi + nYj + a)))));
-- assemble M[Y, Z]: Z order = Yi | Yj | Yh | Ge
MY = MI || MJ || (transpose(MI_{nYi + nYj .. nZ - 2}) | transpose(MJ_{nYi + nYj .. nZ - 2}) | MEE^{0 .. nYh - 1});
qrow = (transpose(MI_{nZ - 1}) | transpose(MJ_{nZ - 1}) | MEE^{nYh});
rB = rank MY; rBq = rank(MY || qrow);
pr("mode " | mode | ": rank B(A, T F_T) on T NL = " | toString rB | "; rank [B; q(A)] = " | toString rBq | "; q(A) on T NL nonzero entries " | toString(#select(flatten entries qrow, v -> v != 0)));
if mode == "G" then pr("RESULT seed " | toString sd | " p " | toString p | ": " | (if rBq > rB then "OBSTRUCTED at order 2 (no h in T F_T repairs G_e)" else "UNOBSTRUCTED at order 2 (G_e + h solvable)") | "  " | tm())
else pr("RESULT c1 seed " | toString sd | ": psi(h y z), h random in T F_T, y in T F_T, z in T NL: rank " | toString rB | " (0 expected)  " | tm());
"/home/claude/hodge/discovery/checks/so_t6/t10c_" | mode | "_" | toString sd | "_" | toString p | ".txt" << toString {F, Ge, A, entries MY, entries qrow} << close;
