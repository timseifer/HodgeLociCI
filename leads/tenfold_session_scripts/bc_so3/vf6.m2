-- BC-SO3 validation of o3bc.m2 against the package's closed-form Fermat periods (cubic sixfold, one 3-plane P1).
needsPackage("HodgeLociCI", FileName => "/home/claude/hodgelocici/M2/HodgeLociCI.m2");
load "/home/claude/hodge/discovery/checks/bc_so3/o3bc.m2";
pr = value(scriptCommandLine#1); sd = value(scriptCommandLine#2);
pf = x -> (print x; stdio << flush);
setRandomSeed sd;
S = fermatRing(3, 6, pr); kk = coefficientRing S;
F = sum(8, i -> S_i^3);
L1 = {{0,1,1},{2,3,1},{4,5,1},{6,7,1}};
I1 = fermatLinearSpaceIdeal(S, L1); P1 = fermatPeriodPolynomial(S, L1);
E = engineSetup(F, I1);
pf("sig dQ nW mstd", E#"sig", E#"dQ", E#"nW", (E#"N")#"mstd");
c0 = fermatPeriod(P1, (E#"N")#"mstd");
pf("package pi(mstd)", c0);
-- package closed form is scaled by (m-1)!/k! relative to the GD convention Phi_(m+1)(A.dF) = Phi_m(div A)/m (checked: literal fermatPeriodGD)
per = P -> (dg := first degree P; q := (dg - E#"sig") // 3; fac := product(q, i -> E#"k" + 1 + i); fermatPeriod(P1, P) / c0 / fac);
perGD = P -> (dg := first degree P; fermatPeriodGD(P1, P, (dg + 8) // 3) / fermatPeriodGD(P1, (E#"N")#"mstd", E#"k" + 1));
-- check nu vs package on random degree-7 forms (pi)
pf("CHECK pi: engine nu == package on 3 random P in S_sig:", all(3, i -> (P := random(E#"sig", S); nuOf(E, P) == per P)));
t0 = cpuTime();
Rel = kappaRelations(E, 3 * E#"nW", sd, 30);
(kap, rk, cons) = solveKappa(E, Rel);
pf("kappa relations: rows", numrows Rel, "rank", rk, "nW", E#"nW", "consistent", cons, "cpu", cpuTime() - t0);
-- psi on I_10: random W in I_3, Y in S_7
I3 = super basis(3, E#"I");
okI = apply(3, i -> (
    W := (I3 * random(kk^(numcols I3), kk^1))_(0,0); Y := random(E#"sig", S);
    row := psiI(E, W*Y);
    (determined(E, Rel, row), evalRow(row, kap) == per(W*Y), evalRow(row, kap) != 0)));
pf("CHECK psi on I: (determined, engine == package, nonzero):", okI);
(TNL, K0) = tangentData(E#"H", (E#"N")#"nuv");
pf("dim T NL", numcols TNL, "dim K_l", numcols K0);
G = (basis(3, S) * sub(TNL * random(kk^(numcols TNL), kk^1), S))_(0,0);
gSetup(E, G);
okG = apply(3, i -> (Y := random(E#"sig", S); row := GammaG(E, Y); (determined(E, Rel, row), evalRow(row, kap) == per(G*Y))));
pf("CHECK psi(G Y), Y random in S_sig: (determined, engine == package):", okG);
t0 = cpuTime();
ok3 = apply(2, i -> (
    K := random(E#"dQ", S); row := psi3GGX(E, K*G);
    (determined(E, Rel, row), evalRow(row, kap) == per(K*G^3), evalRow(row, kap) != 0)));
pf("CHECK psi3(K G^3), K random in S_dQ: (determined, engine == package, nonzero):", ok3, "cpu", cpuTime() - t0);
-- also with X = W G (W in I_3) and X = G*Q for Q in K_l
Kl = (basis(E#"dQ", S) * sub(K0 * random(kk^(numcols K0), kk^1), S))_(0,0);
row = psi3GGX(E, Kl*G);
pf("CHECK psi3(Kl G^3), Kl random in K_l:", determined(E, Rel, row), evalRow(row, kap) == per(Kl*G^3), " literal GD agrees:", per(Kl*G^3) == perGD(Kl*G^3));
pf "VF6 DONE";
