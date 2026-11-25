-- BC-SO3 validation 2: non-CI cycle (cone J(P^1, twisted cubic), 3-fold in P^7) in a random cubic sixfold containing it.
-- Engine (o3bc.m2) vs direct Groebner routes: psi on S/I^2 (BC-SO solib psiDirect) and psi3 on S/I^3 (below, own).
load "/home/claude/hodge/discovery/checks/bc_so3/o3bc.m2";
pr = value(scriptCommandLine#1); sd = value(scriptCommandLine#2);
pf = x -> (print x; stdio << flush);
setRandomSeed sd;
kk = ZZ/pr;
S = kk[w_0..w_3, y_0, y_1, z_0, z_1];
IC = minors(2, matrix{{w_0, w_1, w_2}, {w_1, w_2, w_3}});
IV = ideal(z_0, z_1) + IC;
I3b = super basis(3, IV);
F = (I3b * random(kk^(numcols I3b), kk^1))_(0,0);
E = engineSetup(F, IV); H = E#"H"; k = E#"k";
pf("smooth along V", dim(IV + H#"J") == 0, "sig", E#"sig", "nW", E#"nW");
C2 = psiSetup(H, IV, (E#"N")#"nuv");
psiD = P -> (psiDirect(H, matrix{{P}}, C2))_(0,0);
-- direct psi3: P = A.dF mod I^3, psi3(P) = psi(div A)/(k+2)
Q3 = S/(IV^3); jQ3 = sub(transpose jacobian matrix{{F}}, Q3);
t0 = cpuTime(); GQ3 = gb(jQ3, ChangeMatrix => true, DegreeLimit => E#"sig" + 6); pf("GB S/I^3 cpu", cpuTime() - t0);
psi3D = P -> (
    PQ := sub(matrix{{P}}, Q3);
    if PQ % GQ3 != 0 then error "psi3D: (I^3+J) not everything";
    A := lift(PQ // GQ3, S);
    psiD(sum(numgens S, i -> diff(S_i, A_(i,0)))) / (k+2));
-- internal checks of the direct routes
W1 = (gens IV)_(0,0); W2 = (gens IV)_(0,1); W3 = (gens IV)_(0,2);
pf("direct psi3 on I^3 sample:", psi3D(W1*W2*W3*random(E#"sig" + 6 - 3, S)) == 0);
Rel = kappaRelations(E, 3 * E#"nW", sd, 30);
(kap, rk, cons) = solveKappa(E, Rel);
pf("kappa relations: rows", numrows Rel, "rank", rk, "nW", E#"nW", "consistent", cons);
I3 = super basis(3, IV);
okI = apply(3, i -> (W := (I3 * random(kk^(numcols I3), kk^1))_(0,0); Y := random(E#"sig", S); row := psiI(E, W*Y);
    (determined(E, Rel, row), evalRow(row, kap) == psiD(W*Y), evalRow(row, kap) != 0)));
pf("CHECK psi on I: (determined, engine == direct, nonzero):", okI);
(TNL, K0) = tangentData(H, (E#"N")#"nuv");
pf("dim T NL", numcols TNL, "dim K_l", numcols K0);
G = (basis(3, S) * sub(TNL * random(kk^(numcols TNL), kk^1), S))_(0,0);
gSetup(E, G);
okG = apply(3, i -> (Y := random(E#"sig", S); row := GammaG(E, Y); (determined(E, Rel, row), evalRow(row, kap) == psiD(G*Y))));
pf("CHECK psi(G Y): (determined, engine == direct):", okG);
t0 = cpuTime();
ok3 = apply(3, i -> (K := random(E#"dQ", S); row := psi3GGX(E, K*G);
    (determined(E, Rel, row), evalRow(row, kap) == psi3D(K*G^3), evalRow(row, kap) != 0)));
pf("CHECK psi3(K G^3): (determined, engine == direct, nonzero):", ok3, "cpu", cpuTime() - t0);
pf "VNC6 DONE";
