-- BC-SO main (tenfold), family-derivative psi (famlib.m2, validated by val6.m2)
load "setup.m2"; load "solib.m2"; load "order2.m2"; load "famlib.m2";
sd = value(scriptCommandLine#1); pr = value(scriptCommandLine#2);
pf = x -> (print x; stdio << flush);
tick = () -> pf("  [cpu " | toString cpuTime() | " s]");
D = setupX(pr, sd); S = D#"S"; kk = D#"kk"; F = D#"F"; IV = D#"IV";
pf("seed", sd, "p", pr, "curve (a,b,x0,y0)", D#"curve");
pf("T: codim, degree, hilbpoly, smooth", codim D#"IT", degree D#"IT", hilbertPolynomial(D#"IT", Projective=>false), dim singularLocus((ring D#"IT")/(D#"IT")));
H = hsData F; pf("sig sig2 q0", H#"sig", H#"sig2", H#"q0");
pf("V: dim(proj), degree, F in I_V", dim IV - 1, degree IV, F % IV == 0);
pf("X smooth along V (affine dim of I_V+J = 0)", dim(IV + H#"J") == 0);
N = nuSetup(H, IV); pf("nu gb time", N#"time", "mstd", N#"mstd"); tick();
(TNL, K0) = tangentData(H, N#"nuv");
pf("dim T NL", numcols TNL, "K0 = T NL", rank(TNL|K0) == numcols TNL and numcols K0 == numcols TNL);
-- family directions: (W, 0) for W in basis (I_V)_3, and Hom(I_V, S/I_V)_0 directions (phi(F), phi)
I3 = flatten entries D#"I3";
Hm = Hom(module IV, S^1/IV); b0 = basis(0, Hm); cf = (matrix{{F}}) // (gens IV);
homD = apply(numcols b0, i -> (phi := matrix{apply(numgens IV, j -> lift((matrix homomorphism(b0_{i}))_(0,j), S))}; ((phi * cf)_(0,0), phi)));
dirs = apply(I3, w -> (w, null)) | homD;
famC = coefM(S, 3, matrix{apply(dirs, x -> x#0)});
jac3 = coefM(S, 3, flatten((vars S) ** transpose(jacobian matrix{{F}})));
pf("dim (I_V)_3", #I3, "dim Hom_0", numcols b0, "dim T F_T", rank famC, "J_3 in T F_T", rank(famC | jac3) == rank famC,
   "T F_T in T NL", rank(TNL | famC) == numcols TNL);
-- G_e: random element of T NL (has a component outside T F_T unless T F_T = T NL)
Gc = TNL * random(kk^(numcols TNL), kk^1);
pf("G_e outside T F_T", rank(famC | Gc) > rank famC);
Ge = (basis(3, S) * sub(Gc, S))_(0,0);
b3 = basis(3, S);
ca = decomp(H, N, Ge * b3); pf("nu(G_e mu) = 0 for all mu in S_3", ca#"rem" == 0); tick();
Mm = famMatrix(H, N, ca, dirs); tick();                  -- 364 x #dirs : psi(h G_e mu)
Cols = famC | Gc;                                           -- spans T NL
Bp = (transpose Mm) * Cols;                                 -- rows h in T F_T (spanning set), cols K in T NL
qv = qVector(H, N, Ge, ca); tick();                         -- 1 x 364 : psi(G_e^2 mu)
qp = qv * Cols;
nI = #I3;
pf("CHECK symmetry psi(h G_e h') (h,h' in T F_T):", Bp_(toList(0..#dirs-1)) == transpose(Bp_(toList(0..#dirs-1))));
pf("CHECK psi(W G_e W') = 0 for W,W' in I_3 (I^2):", (Bp^(toList(0..nI-1)))_(toList(0..nI-1)) == 0);
pf("CHECK q on T F_T two routes (qVector vs family column):", qv * famC == (transpose Gc) * Mm);
pf("NONTRIVIAL: rank psi(h G_e mu), h in T F_T, mu in S_3:", rank Mm, " psi(G_e^2 mu) on S_3 nonzero:", qv != 0,
   " rank psi(G_e^2 mu) restricted to T NL complement test:", rank(qv * TNL));
pf("RESULT seed", sd, "p", pr, "dimTNL", numcols TNL, "dimTFT", rank famC, "rankB", rank Bp, "rank[B;q]", rank(Bp || qp),
   "B=0", Bp == 0, "q=0", qp == 0, "psi(G_e^3)", (qp_{numcols Cols - 1})_(0,0));
-- self-check: a random family direction h' must be unobstructed
cR = random(kk^(#dirs), kk^1);
hP = sum(#dirs, i -> cR_(i,0) * (dirs#i)#0);
pf("h' in T NL", rank(TNL | coefM(S,3,matrix{{hP}})) == numcols TNL);
ca2 = decomp(H, N, hP * b3); pf("nu(h' mu)=0", ca2#"rem" == 0);
Mm2 = famMatrix(H, N, ca2, dirs); qv2 = qVector(H, N, hP, ca2);
B2 = (transpose Mm2) * Cols; q2 = qv2 * Cols;
pf("SELFCHECK family direction h': rankB", rank B2, "rank[B;q]", rank(B2 || q2), "B=0", B2 == 0, "q=0", q2 == 0);
tick();
pf "MAIN2 DONE";
