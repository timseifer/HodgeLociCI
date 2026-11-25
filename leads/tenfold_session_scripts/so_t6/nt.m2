-- SO-T6 main tenfold test (structured).  usage: M2 --script t10d.m2 seed [prime] [mode]
-- mode "G": first factor A = the extra direction G_e;  mode "h": A = random h in T F_T (control c1: M must vanish).
-- M[y,z] = psi(A y z), y in Y (spans T F_T), z in Z = Y u {G_e} (spans T NL).
-- Y = Yi (spanning set of I_3: u_a*mu2, q_j*x_l, cubic generators) u Yj (x_l dF/dx_j) u Ysp (2 Hom'_0 directions spanning
-- T F_T modulo I_3 + J S_1; W1: codim 57 without, 55 with V-moduli).
-- Formulas: psi(A g g') = 0 (I^2);  psi(A z x_l dF_j) = (1/6) pi(d_j(x_l A z));  psi(g A z) = c psi(g m0) + (1/6) pi(sum_i C_i d_i g)
-- where A z = c m0 + (I part) + sum C_i dF_i;  remaining 3x3 block by the generic evaluator soPsiB.
pr = s -> (stderr << s << endl << flush);
sd = value scriptCommandLine#1;
p = if #scriptCommandLine > 2 then value scriptCommandLine#2 else 32003;
mode = if #scriptCommandLine > 3 then scriptCommandLine#3 else "G";
kk = ZZ/p; S = kk[x_0..x_11];
setRandomSeed(sd);
load "/home/claude/hodge/discovery/checks/so_t6/w1lib.m2";
load "/home/claude/hodge/discovery/checks/so_t6/solib.m2";
T0 = cpuTime(); tm = () -> toString(round(cpuTime() - T0)) | "s";
I = trim w1cycle("J2T");
B3 = super basis(3, I); F = (B3 * random(kk^(numColumns B3), kk^1))_(0,0);
w1codimP8(F, I);
(piRow, IJ, m0) = soNF(F, I);
inv6 = 1_kk / 6;
m3 = basis(3, S); L3 = flatten entries m3; cf = M -> lift(last coefficients(M, Monomials => m3), kk);
B6 = basis(6, S);
Pi6 = (B6 * transpose matrix{piRow B6})_(0,0);
idx = new MutableHashTable; mons = flatten entries B6; scan(#mons, i -> idx#(mons#i) = i);
pv = flatten entries lift(last coefficients(Pi6, Monomials => B6), kk);
Pm = matrix table(#L3, #L3, (i,j) -> pv#(idx#(L3#i * L3#j)));
TNL = matrix nullSpace mutableMatrix Pm; pr("m0 = " | toString m0 | "; dim T NL = " | toString numColumns TNL | " " | tm());
Jr = flatten entries jacobian matrix{{F}};
g = flatten entries mingens I; r = #g; dg = apply(g, u -> first degree u); GIJ = matrix{g | Jr};
uu = {x_9, x_10, x_11}; qs = select(g, u -> first degree u == 2); cs = select(g, u -> first degree u == 3);
mu2 = flatten entries basis(2, S);
Yi = flatten apply(uu, a -> apply(mu2, m -> a * m)) | flatten apply(qs, q -> apply(12, l -> q * x_l)) | cs;
nI3 = numColumns super basis(3, I);
pr("generators: " | toString tally dg | "; rank Yi = " | toString rank cf(matrix{Yi}) | " = dim I_3 = " | toString nI3);
Yj = flatten table(12, 12, (l, j) -> x_l * diff(x_j, F));
r0 = rank cf(matrix{Yi | Yj});
nh = #w1TFpolys - nI3 - 27 - 144; Yh = take(drop(w1TFpolys, nI3), nh);
Ysp = {}; cur = cf(matrix{Yi | Yj});
for h in Yh do (if rank(cur | cf(matrix{{h}})) > rank cur then (Ysp = append(Ysp, h); cur = cur | cf(matrix{{h}})));
rTF = rank cur;
pr("rank(I_3 + J S_1) = " | toString r0 | ", + Hom'_0 dirs: " | toString rTF | " (W1: 309), #Ysp = " | toString(#Ysp) | "; T F_T in T NL: " | toString(rank(TNL | cur) == numColumns TNL));
Ge = null; for j from 0 to numColumns TNL - 1 do if rank(cur | TNL_{j}) > rTF then (Ge = (m3 * sub(TNL_{j}, S))_(0,0); break);
pr("c2: rank of Q -> pi(Q g), g random cubic (> 0 expected): " | toString rank matrix{piRow(m3 * random(3, S))});
stripU = f -> sum(select(terms f, t -> degree(x_9, t) + degree(x_10, t) + degree(x_11, t) == 0));
Ge = stripU Ge; Ysp = apply(Ysp, stripU);
pr("Ge, Ysp stripped of u-monomials; still Ge in T NL, outside T F_T: " | toString(rank(TNL | cf(matrix{{Ge}})) == numColumns TNL, rank(cur | cf(matrix{{Ge}})) > rTF) | "; Ysp still span T F_T: " | toString(rank cf(matrix{Yi | Yj | Ysp}) == rTF));
A = if mode == "G" then Ge else (matrix{Yi | Yj | Ysp} * random(kk^(#Yi + #Yj + #Ysp), kk^1))_(0,0);
E3 = Ysp | {Ge};
Zs = Yi | Yj | E3; nYi = #Yi; nYj = #Yj; nE = #E3; nZ = #Zs;
-- psi(g m0), g in Yi; generic evaluator = Option B with psi(c m0) for cubic generators from their own lift (coefficients must be 0)
lin = soPsiBlin(F, I, piRow, IJ, m0);
lcm0 = lin matrix{apply(cs, c -> c * m0)};
pr("lin(c m0), cubic generators: " | toString lcm0 | " " | tm());
if any(lcm0, vc -> any(vc#1, t -> t != 0)) then error "cubic unknowns enter";
xs = apply(lcm0, vc -> vc#0);
psiB = soPsiBx(lin, xs);
cubv = xs;
L8 = matrix{apply(mu2, m -> m * m0)}; c8 = L8 // GIJ;
L7 = matrix{apply(12, l -> x_l * m0)}; c7 = L7 // GIJ;
if L8 % IJ != 0 or L7 % IJ != 0 then error "deg 7/8 not in I+J";
pu = flatten apply(3, a -> apply(piRow matrix{flatten entries c8^{r + 9 + a}}, v -> inv6 * v));
pq = flatten apply(qs, q -> piRow matrix{apply(12, l -> sum(12, i -> c7_(r + i, l) * diff(x_i, q)))});
pq = apply(pq, v -> inv6 * v);
pgm = pu | pq | cubv;
pr("psi(g m0) for Yi (" | toString(#pgm) | " values) " | tm());
-- rows Yj by the dual formula
Wm = matrix{apply(Zs, z -> A * z)};
Wvec = lift(last coefficients(Wm, Monomials => B6), kk);
PiI = apply(12, i -> x_i * diff(x_i, x_i * Pi6));
DJ = fold((a, b) -> a || b, flatten table(12, 12, (l, j) -> transpose lift(last coefficients(contract(x_l, PiI#j), Monomials => B6), kk)));
MJ = inv6 * (DJ * Wvec);
pr("rows Yj " | tm() | "; c4 J-J symmetry (0): " | toString rank(MJ_{nYi .. nYi + nYj - 1} - transpose MJ_{nYi .. nYi + nYj - 1}));
-- I-formula for columns z (list of indices into Zs)
dgI = matrix{Yi};  -- 1 x nYi
jacYi = jacobian dgI;  -- 12 x nYi
Iform = zl -> (
    Wz := matrix{apply(zl, t -> A * Zs#t)};
    cof := Wz // GIJ; cz := flatten entries lift(last coefficients(Wz % IJ, Monomials => matrix{{m0}}), kk);
    matrix apply(#zl, t -> (
        Ct := matrix{apply(12, i -> cof_(r + i, t))};       -- 1 x 12
        v := piRow(Ct * jacYi);
        apply(nYi, a -> inv6 * v#a + cz#t * pgm#a))));     -- (#zl) x nYi
-- nontriviality + nonzero c4 (seed as given): w random cubic outside T NL
wr = random(3, S); Zs = append(Zs, wr); nZ = #Zs;
Nw = Iform({nZ - 1});
pr("pi(A w) (nonzero expected) " | toString piRow matrix{{A * wr}} | "; I-formula psi(A w g), g in Yi: nonzero entries " | toString(#select(flatten entries Nw, v -> v != 0)) | " of " | toString(nYi) | " " | tm());
ic = apply(cs, c -> position(Yi, u -> u == c)) | {random nYi};
pr("c4 nonzero: generic psi(A w g) vs I-formula, g = 2 cubic gens + 1 random: " | toString(psiB matrix{apply(ic, t -> A * wr * Yi#t)}, apply(ic, t -> Nw_(0, t))) | " " | tm());
