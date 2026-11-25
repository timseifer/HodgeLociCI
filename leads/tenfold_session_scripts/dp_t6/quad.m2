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
-- DP-T6 quad: the T_f-row quadric Q_h(a) = psi(h e(a) e(a)), h random in T_f, from decompositions of the products e_i e_j only
b3 = basis(3, S); toP = v -> (b3 * sub(v, S))_(0,0); Eg = apply(es, toP);
prs = flatten apply(n, i -> apply(toList(i..n-1), j -> (i,j)));
Rm = matrix{apply(prs, ij -> Eg#(ij#0) * Eg#(ij#1))};
caR = decomp(H, N, Rm); pf("nu(e_i e_j) = 0 all pairs", caR#"rem" == 0);
A = kk[a_1..a_n];
quadOf = cR -> (
    W := sum(#dirs, l -> cR_(l,0) * (dirs#l)#0);
    hl := select(#dirs, l -> (dirs#l)#1 =!= null and cR_(l,0) != 0);
    dr := if #hl == 0 then (W, null) else (W, sum(hl, l -> cR_(l,0) * (dirs#l)#1));
    col := famMatrix(H, N, caR, {dr});           -- #prs x 1 : psi(h e_i e_j)
    sum(#prs, t -> (if prs#t#0 == prs#t#1 then 1 else 2) * col_(t,0) * A_(prs#t#0) * A_(prs#t#1)));
nd = #dirs;
Q1 = quadOf(random(kk^nd, kk^1));
Q2 = quadOf(random(kk^nd, kk^1));
Q3 = quadOf(random(kk^224, kk^1) || map(kk^(nd-224), kk^1, 0));    -- pure I_3 direction
hess = Q -> rank sub(diff(transpose vars A, diff(vars A, Q)), kk);
pf("QUAD seed", sd, "p", p, "Q nonzero", Q1 != 0, "rank Hessian Q1 Q2 Q3", hess Q1, hess Q2, hess Q3, "Q1,Q2,Q3 proportional (span dim)", numcols super basis(2, ideal(Q1,Q2,Q3)));
pf("Q1 =", toString Q1);
pf "QUAD DONE";
