-- DP-T6 light c1 control (same setup as dp.m2, no excess computation). Was main: order-2 surviving cone of the excess E = T NL([V']) / T_f at a dP6-cone point.
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
b3 = basis(3, S);
-- control c1: random family direction h
cR = random(kk^(#dirs), kk^1);
hP = sum(#dirs, i -> cR_(i,0) * (dirs#i)#0);
ca2 = decomp(H, N, hP * b3); pf("c1: nu(h mu) = 0", ca2#"rem" == 0);
Mm2 = famMatrix(H, N, ca2, dirs); qv2 = qVector(H, N, hP, ca2);
B2 = (transpose TNL) * Mm2; q2 = qv2 * TNL;
pf("c1 family direction h: psi(K h h') = 0 (K in T NL, h' in T_f):", B2 == 0, " psi(K h^2) = 0:", q2 == 0, " nontrivial psi(h h' mu) over S_3:", rank Mm2);
tick "c1";
pf "C1 DONE";
