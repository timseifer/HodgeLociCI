-- BC-SO3: export sixfold validation cases for o3np.py with reference values from the validated M2 engine o3bc.m2
load "/home/claude/hodge/discovery/checks/bc_so3/o3bc.m2"; load "/home/claude/hodge/discovery/checks/bc_so3/exp3.m2";
needsPackage("HodgeLociCI", FileName => "/home/claude/hodgelocici/M2/HodgeLociCI.m2");
pr = value(scriptCommandLine#1); sd = value(scriptCommandLine#2); which = scriptCommandLine#3;
setRandomSeed sd;
if which == "cone" then (
    kk = ZZ/pr; S = kk[w_0..w_3, y_0, y_1, z_0, z_1];
    IV = ideal(z_0, z_1) + minors(2, matrix{{w_0, w_1, w_2}, {w_1, w_2, w_3}});
    I3b = super basis(3, IV); F = (I3b * random(kk^(numcols I3b), kk^1))_(0,0)) else (
    S = fermatRing(3, 6, pr); kk = coefficientRing S; F = sum(8, i -> S_i^3);
    IV = fermatLinearSpaceIdeal(S, {{0,1,1},{2,3,1},{4,5,1},{6,7,1}}));
E = engineSetup(F, IV); H = E#"H";
Rel = kappaRelations(E, 3 * E#"nW", sd, 30); (kap, rk, cons) = solveKappa(E, Rel);
(TNL, K0) = tangentData(H, (E#"N")#"nuv");
G = (basis(3, S) * sub(TNL * random(kk^(numcols TNL), kk^1), S))_(0,0);
dir = "/home/claude/hodge/discovery/checks/bc_so3/x6_" | which | "_" | toString pr;
exportData(dir, E, G, new HashTable from {"syzdeg" => 5, "qv" => true});
refs = apply(3, i -> (K := random(E#"dQ", S); row := psi3GGX(E, K*G);
    {flatten entries lift(coefM(S, E#"dQ", matrix{{K}}), ZZ), lift(evalRow(row, kap), ZZ)}));
wlist(dir | "/refs.txt", refs);
print "VEXP6 DONE";
