needsPackage("HodgeLociCI", FileName => "/home/claude/hodgelocici/M2/HodgeLociCI.m2");
load "solib.m2"; load "order2.m2";
sd = value(scriptCommandLine#1); pr = value(scriptCommandLine#2);
D = randomCyclePair(3, {1,1,1},{1,1,1},{1}, Seed => sd, CoefficientRing => ZZ/pr);
S = D#"ring"; F = D#"F"; kk = coefficientRing S;
f = D#"f"; h = D#"h"; p = D#"p"; s = D#"s"; M = D#"M";
g = flatten entries (M * transpose matrix{h}); q = flatten entries (transpose M * transpose matrix{f});
print("check F decomp", F - sum(#f, i-> f#i*g#i) - sum(#p, i -> p#i*s#i), F - sum(#h, i-> h#i*q#i) - sum(#p, i -> p#i*s#i));
H = hsData F; print(H#"sig", H#"sig2", H#"q0");
I1 = ideal(f|p); I2 = ideal(h|p);
pi1 = piVector(H, I1); pi2 = piVector(H, I2);
R1 = residueFunctional(f|p|g|s); R2 = residueFunctional(h|p|q|s);
b4 = flatten entries basis(H#"sig", S);
r1 = matrix{apply(b4, u -> R1 u)} ** kk; r2 = matrix{apply(b4, u -> R2 u)} ** kk;
print("own pi proportional to residue:", rank(pi1 || r1), rank(pi2 || r2));
C1 = psiSetup(H, I1, r1); C2 = psiSetup(H, I2, r2);
print("gb times", C1#"gbTime", C2#"gbTime", "std", C1#"std", C2#"std");
L1 = secondOrderFunctional(f|p, g|s); L2 = secondOrderFunctional(h|p, q|s);
for t from 1 to 3 do (P = random(H#"sig2", S);
   print("psi own vs package/(k+1):", (psiDirect(H, matrix{{P}}, C1))_(0,0), L1(P)/4, (psiDirect(H, matrix{{P}}, C2))_(0,0), L2(P)/4));
-- psiG vs direct
G0 = random(3,S); m0 = (basis(H#"sig",S))_(0,7);
print("psiG vs direct", ((psiG(H,{G0},C1))#0)_(0,7), (psiDirect(H, matrix{{G0*m0}}, C1))_(0,0));
print("psi(F m) = pi(m)?", (psiDirect(H, matrix{{F*m0}}, C1))_(0,0), (r1 * coefM(S, H#"sig", matrix{{m0}}))_(0,0));
print("syz tests", syzTest(H, C1, 2));
(T1,K1) = tangentData(H, r1); (T2,K2) = tangentData(H, r2);
TVZ = gens intersect(image T1, image T2);
print("dims TV1 TV2 TVZ", numcols T1, numcols T2, numcols TVZ, "of", numcols basis(3,S));
for lam in {2, 1, 5} do (
  pl = r1 + lam_kk * r2;
  (TL, KL) = tangentData(H, pl);
  psiFun = G -> (psiG(H,{G},C1))#0 + lam_kk * (psiG(H,{G},C2))#0;
  o = orderTwo(H, TVZ, TL, KL, psiFun);
  print("lambda", lam, "dimTNL", o#"dimTNL", "dimFam", o#"dimFam", "excess", o#"excess", "dimK0", o#"dimK0",
     "rankB", o#"rankB", "rank[B;q]", o#"rankBq", "q=0", o#"qzero", "B=0", o#"Bzero", "rank psi_Ge on S_d x S_q0", o#"rankBfull");
  print("famCheck (rank on Fam x K0, rank on S_d x K0, rank full)", famCheck(H, TVZ, KL, psiFun));
);
