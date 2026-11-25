-- DP-T6 main: order-2 surviving cone of the excess E = T NL([V']) / T_f at a dP6-cone point.
-- V' = J(Pi, S') as in CS-T6 a1.m2; psi by BC-SO famlib (family-derivative route), cross terms by dplib qPair.
-- usage: M2 --script dp.m2 seed p
sd = value scriptCommandLine#1; p = value scriptCommandLine#2;
pf = x -> (print x; stdio << flush);
tick = s -> pf("  [" | s | " cpu " | toString cpuTime() | " s]");
kk = ZZ/p; S = kk[x_0..x_11]; setRandomSeed(sd); pr = s -> (stderr << s << endl << flush);
load "/home/claude/hodge/discovery/checks/w1/w1lib.m2";
load "/home/claude/hodge/discovery/checks/bc_so/solib.m2"; load "/home/claude/hodge/discovery/checks/bc_so/order2.m2";
load "/home/claude/hodge/discovery/checks/bc_so/famlib.m2"; load "/home/claude/hodge/discovery/checks/dp_t6/dplib.m2";
-- construction (identical to cs_t6/a1.m2)
(R5, IT0) = w1T(); IT = (map(S, R5, {x_0,x_1,x_2,x_3,x_4,x_5})) IT0;
q2s = select(flatten entries mingens IT, g -> first degree g == 2); c3s = flatten entries super basis(3, IT);
rq = () -> sum(q2s, g -> random(kk) * g); rc = () -> sum(c3s, g -> random(kk) * g);
IS = trim ((ideal(rq(), rq(), rc()) + ideal(x_6..x_11)) : (IT + ideal(x_6..x_11)));
IS5 = trim(IS + ideal(x_6..x_11));
u = ideal(x_9, x_10, x_11);
IV = trim(ideal((gens IS5) % ideal(x_6,x_7,x_8,x_9,x_10,x_11)) + u);
B3 = super basis(3, IV); F = (B3 * random(kk^(numColumns B3), kk^1))_(0,0);
-- class data: S' vs T (Hilbert polynomials in P^5), degrees
R5b = kk[y_0..y_5]; toR5 = map(R5b, S, {y_0,y_1,y_2,y_3,y_4,y_5,0,0,0,0,0,0});
ISp = trim toR5 IS5; ITp = trim toR5 IT;
pf("S': dim, deg, hilbpoly, smooth (dim sing locus, -1 = smooth)", dim ISp - 1, degree ISp, hilbertPolynomial(ISp, Projective=>false), dim (ISp + minors(3, jacobian ISp)) - 1);
pf("T : dim, deg, hilbpoly", dim ITp - 1, degree ITp, hilbertPolynomial(ITp, Projective=>false));
pf("S' n T: dim, deg", dim(ISp + ITp) - 1, degree(ISp + ITp), "S' u T = (q1,q2,c)? deg", degree intersect(ISp, ITp));
pf("I_S' degrees of mingens", apply(flatten entries mingens ISp, g -> first degree g));
H = hsData F;
pf("V': dim, deg, F in I_V'", dim IV - 1, degree IV, F % IV == 0);
pf("X smooth along V'", dim(IV + H#"J") == 0);
N = nuSetup(H, IV); pf("nu gb time", N#"time", "mstd", N#"mstd", "gens degs", N#"degs"); tick "nu";
(TNL, K0) = tangentData(H, N#"nuv");
pf("dim T NL", numcols TNL, "codim", 364 - numcols TNL, "K0 = T NL", rank(TNL|K0) == numcols TNL and numcols K0 == numcols TNL);
I3m = super basis(3, IV); I3 = flatten entries I3m;
Hm = Hom(module IV, S^1/IV); b0 = basis(0, Hm); cf = (matrix{{F}}) // (gens IV);
homD = apply(numcols b0, i -> (phi := matrix{apply(numgens IV, j -> lift((matrix homomorphism(b0_{i}))_(0,j), S))}; ((phi * cf)_(0,0), phi)));
dirs = apply(I3, w -> (w, null)) | homD;
famC = coefM(S, 3, matrix{apply(dirs, x -> x#0)});
jac3 = coefM(S, 3, flatten((vars S) ** transpose(jacobian matrix{{F}})));
rf = rank famC;
pf("dim (I_V')_3", #I3, "dim Hom_0", numcols b0, "dim T_f", rf, "codim T_f", 364 - rf, "J_3 in T_f", rank(famC | jac3) == rf,
   "T_f in T NL", rank(TNL | famC) == numcols TNL); tick "family";
-- excess basis e_1..e_n: TNL columns outside span famC
cur = famC; es = {};
for j from 0 to numcols TNL - 1 do (if rank(cur | TNL_{j}) > rank cur then (cur = cur | TNL_{j}; es = append(es, TNL_{j})));
n = #es; pf("excess n", n, "check", n == numcols TNL - rf);
b3 = basis(3, S);
toP = v -> (b3 * sub(v, S))_(0,0);
Eg = apply(es, toP);
cas = {}; Mms = {};
for i from 0 to n-1 do (
    ca := decomp(H, N, Eg#i * b3);
    if ca#"rem" != 0 then error "nu(e_i mu) != 0";
    Mm := famMatrix(H, N, ca, dirs);      -- 364 x #dirs : psi(h e_i mu)
    remove(ca, "Acoef");
    cas = append(cas, ca); Mms = append(Mms, Mm); tick("e_" | toString i));
nI = #I3;
Bs = apply(Mms, Mm -> (transpose TNL) * Mm);           -- rows K in T NL basis, cols dirs
Qrow = new MutableHashTable;
preps = apply(n, j -> qPrep(H, N, Eg#j, (Mms#j)_(toList(0..nI-1)), I3m)); tick "qPrep";
for i from 0 to n-1 do for j from 0 to n-1 do Qrow#(i,j) = qPairC(H, N, preps#j, cas#i);   -- psi(e_j e_i mu)
tick "qPair";
Qs = new MutableHashTable; for i from 0 to n-1 do for j from i to n-1 do Qs#(i,j) = transpose(Qrow#(i,j) * TNL);
Qs = new HashTable from Qs;
C = coneAnalysis(kk, Bs, Qs); tick "cone";
pf("CONE: rank Bcoef", C#"rankBcoef", "rows killing B", C#"lk", "#quadrics Iq", C#"numIq", "projdim V(Iq)", C#"dimIq", "rgen B'", C#"rgen", "strata (rank, projdim)", C#"strata");
pf("Iq hilbert (dim span of quadrics)", numcols super basis(2, C#"Iq"));
try (pf("Iq quadric Hessian ranks:", apply(flatten entries gens C#"Iq", g -> rank sub(diff(transpose vars C#"ring", diff(vars C#"ring", g)), kk)), " Iq:", toString C#"Iq");) else pf "CHECK ERROR";
try (pf("rank-0 stratum (B'(a) = 0 and q'(a) = 0 on V(Iq)) radical:", toString radical(C#"Iq" + minors(1, C#"Bp") + minors(1, C#"qp")));) else pf "CHECK ERROR";
try (pf("B'(a) generic rank-1 entries ideal (where B' = 0):", toString radical(minors(1, C#"Bp")), " cubic f(a) = psi(e(a)^3) in Iq?:", (sum flatten apply(n, i -> apply(n, j -> apply(n, l -> (C#"ring")_i * (C#"ring")_j * (C#"ring")_l * sub((Qrow#(i,j) * es#l)_(0,0), C#"ring"))))) % C#"Iq" == 0);) else pf "CHECK ERROR";
pts = apply(4, t -> pointTest(kk, Bs, Qs, apply(n, i -> random kk)));
pf("random points a (rank B(a), rank [B(a)|q(a)]):", pts);
pf("RESULT seed", sd, "p", p, "codim TNL", 364 - numcols TNL, "codim T_f", 364 - rf, "excess", n, "dimZ (proj)", C#"dimZ", "VERDICT", verdictOf C);
-- validation of the cross-term code
symOK = all(n, i -> all(n, j -> Qrow#(i,j) == Qrow#(j,i)));
diagOK = try (qVector(H, N, Eg#0, cas#0) == Qrow#(0,0)) else "ERROR";
tworoute = all(n, i -> all(n, j -> (Qrow#(i,j)) * famC == (transpose es#j) * (Mms#i)));
try (pf("CHECK uncached qPair == cached (0,1):", qPair(H, N, Eg#1, cas#0, (Mms#1)_(toList(0..nI-1)), I3m) == Qrow#(0,1));) else pf "CHECK ERROR";
try (pf("CHECK cross terms symmetric psi(e_i e_j mu):", symOK, " qPair diag == famlib qVector (e_0):", diagOK, " two routes psi(e_i e_j h):", tworoute);) else pf "CHECK ERROR";
try (pf("CHECK psi(W e_i W') = 0 for W,W' in I_3:", all(n, i -> ((transpose famC_(toList(0..nI-1))) * (Mms#i)_(toList(0..nI-1))) == 0));) else pf "CHECK ERROR";
try (pf("CHECK symmetry psi(h e_i h') on T_f:", all(n, i -> (transpose famC) * Mms#i == transpose((transpose famC) * Mms#i)));) else pf "CHECK ERROR";
try (pf("NONTRIVIAL: rank psi(h e_i mu) over S_3 x dirs:", apply(Mms, rank), " psi(e_i e_j mu) nonzero on S_3 (#pairs of", n*n, "):", #select(flatten apply(n, i -> apply(n, j -> Qrow#(i,j) != 0)), x -> x));) else pf "CHECK ERROR";
try (pf("psi(K e_i e_j) on T NL nonzero pairs:", #select(flatten apply(n, i -> apply(n, j -> Qrow#(i,j) * TNL != 0)), x -> x),
   " B_i ranks on T NL x T_f:", apply(Bs, rank), " psi(h' e_i h) = 0 for h, h' in T_f:", all(Mms, Mm -> (transpose famC) * Mm == 0));) else pf "CHECK ERROR";
-- control c1: random family direction h
cas = null; Qrow = null; collectGarbage();
cR = random(kk^(#dirs), kk^1);
hP = sum(#dirs, i -> cR_(i,0) * (dirs#i)#0);
ca2 = decomp(H, N, hP * b3); pf("c1: nu(h mu) = 0", ca2#"rem" == 0);
Mm2 = famMatrix(H, N, ca2, dirs); qv2 = qVector(H, N, hP, ca2);
B2 = (transpose TNL) * Mm2; q2 = qv2 * TNL;
pf("c1 family direction h: psi(K h h') = 0 (K in T NL, h' in T_f):", B2 == 0, " psi(K h^2) = 0:", q2 == 0, " nontrivial psi(h h' mu) over S_3:", rank Mm2);
-- cross check: psi(e_i h K) from Mm_i vs psi(h e_i K) from Mm2 (h random family direction)
pf("c4 cross: psi(h e_i mu) famMatrix vs qPair(e_i; h mu decomposition):", all(n, i -> transpose((Mms#i) * cR) == qPairC(H, N, preps#i, ca2)));
tick "c1";
pf "DP DONE";
