-- DP-T6 control c3: sixfold, two P^3 meeting in a point (package randomCyclePair), class P1 + lam P2,
-- BC-SO direct psi (solib psiSetup/psiG, validated against package in pc1), cone analysis by dplib.
needsPackage("HodgeLociCI", FileName => "/home/claude/hodgelocici/M2/HodgeLociCI.m2");
load "/home/claude/hodge/discovery/checks/bc_so/solib.m2"; load "/home/claude/hodge/discovery/checks/bc_so/order2.m2";
load "/home/claude/hodge/discovery/checks/dp_t6/dplib.m2";
sd = value(scriptCommandLine#1); pr = value(scriptCommandLine#2);
D = randomCyclePair(3, {1,1,1},{1,1,1},{1}, Seed => sd, CoefficientRing => ZZ/pr);
S = D#"ring"; F = D#"F"; kk = coefficientRing S; setRandomSeed(sd);
f = D#"f"; h = D#"h"; p = D#"p"; s = D#"s"; M = D#"M";
g = flatten entries (M * transpose matrix{h}); q = flatten entries (transpose M * transpose matrix{f});
H = hsData F; I1 = ideal(f|p); I2 = ideal(h|p);
R1 = residueFunctional(f|p|g|s); R2 = residueFunctional(h|p|q|s);
b4 = flatten entries basis(H#"sig", S);
r1 = matrix{apply(b4, u -> R1 u)} ** kk; r2 = matrix{apply(b4, u -> R2 u)} ** kk;
C1 = psiSetup(H, I1, r1); C2 = psiSetup(H, I2, r2);
L1 = secondOrderFunctional(f|p, g|s);
P0 = random(H#"sig2", S); print("psi own vs package/(k+1):", (psiDirect(H, matrix{{P0}}, C1))_(0,0), L1(P0)/4);
(T1,K1) = tangentData(H, r1); (T2,K2) = tangentData(H, r2);
TVZ = gens intersect(image T1, image T2);
bd = basis(3, S);
runC = (lam, Tf, label) -> (
  pl := r1 + lam_kk * r2;
  (TL, KL) := tangentData(H, pl);
  psiFun := G -> (psiG(H,{G},C1))#0 + lam_kk * (psiG(H,{G},C2))#0;
  ex := rank(Tf | TL) - rank Tf;
  cur := Tf; es := {};
  for j from 0 to numcols TL - 1 do (if #es == ex then break; if rank(cur | TL_{j}) > rank cur then (cur = cur | TL_{j}; es = append(es, TL_{j})));
  Bfs := apply(es, e -> pairMat(S, 3, H#"q0", psiFun((bd * sub(e, S))_(0,0))));   -- psi(e u v), u in S_3, v in S_q0
  Bs := apply(Bfs, Bf -> (transpose KL) * (transpose Bf) * Tf);
  Qs := new MutableHashTable;
  for i from 0 to #es-1 do for j from i to #es-1 do Qs#(i,j) = (transpose KL) * (transpose Bfs#i) * es#j;
  -- symmetry check of cross terms
  sym := all(#es, i -> all(#es, j -> (transpose KL) * (transpose Bfs#i) * es#j == (transpose KL) * (transpose Bfs#j) * es#i));
  C := coneAnalysis(kk, Bs, new HashTable from Qs);
  -- family control: random h in Tf: psi(h Tf K) = 0 and psi(h^2 K) = 0
  hv := Tf * random(kk^(numcols Tf), kk^1); Bh := pairMat(S, 3, H#"q0", psiFun((bd * sub(hv,S))_(0,0)));
  c1 := ((transpose KL) * (transpose Bh) * Tf == 0);
  pts := apply(3, t -> pointTest(kk, Bs, new HashTable from Qs, apply(#es, i -> random kk)));
  print(label, "lambda", lam, "dimTNL", numcols TL, "dimTf", rank Tf, "excess", ex, "dimK0", numcols KL, "sym", sym, "c1 family", c1,
     "rankBcoef", C#"rankBcoef", "Iq", C#"Iq", "dimIq", C#"dimIq", "rgen", C#"rgen", "strata (rank, projdim)", C#"strata",
     "dimZ", C#"dimZ", "VERDICT", verdictOf C, "random points (rkB, rk[B|q])", pts);
  );
for lam in {2, 1} do runC(lam, TVZ, "E1");
TVZ2 = TVZ * random(kk^(numcols TVZ), kk^(numcols TVZ - 1));
for lam in {2, 1} do runC(lam, TVZ2, "E2(shrunk family)");
print "C3 DONE";
