-- BC-SO validation of famlib (family-derivative psi) on cubic sixfolds:
-- (A) a P^3 (CI) against the package secondOrderFunctional; (B) a non-CI cone J(P^1, twisted cubic) against the direct GB route (solib psiDirect)
needsPackage("HodgeLociCI", FileName => "/home/claude/hodgelocici/M2/HodgeLociCI.m2");
load "solib.m2"; load "order2.m2"; load "famlib.m2";
sd = value(scriptCommandLine#1); pr = value(scriptCommandLine#2);
setRandomSeed sd;
homDirs = (H, I, nr) -> (
    S := H#"S"; kk := coefficientRing S;
    Hm := Hom(module I, S^1/I); b0 := basis(0, Hm);
    cf := (matrix{{H#"F"}}) // (gens I);
    apply(nr, t -> (
        v := b0 * random(kk^(numcols b0), kk^1);
        phi := matrix{apply(numgens I, j -> lift((matrix homomorphism(v))_(0,j), S))};
        ((phi * cf)_(0,0), phi)))
    );
derivDir = (H, I) -> (
    S := H#"S"; ell := apply(numgens S, i -> random(1, S));
    xi := u -> sum(numgens S, i -> ell#i * diff(S_i, u));
    ((xi H#"F"), matrix{apply(flatten entries gens I, xi)}, ell)
    );
runCase = (name, H, I, psiRef) -> (
    S := H#"S"; kk := coefficientRing S; k := H#"k"; q0 := H#"q0";
    N := nuSetup(H, I);
    (TNL, K0) := tangentData(H, N#"nuv");
    G := (basis(H#"d", S) * sub(TNL * random(kk^(numcols TNL), kk^1), S))_(0,0);
    bq := basis(q0, S);
    ca := decomp(H, N, G * bq);
    W := (gens I) * random(source gens I, S^{-H#"d"}); W = W_(0,0);
    (hx, phx, ell) := derivDir(H, I);
    hd := homDirs(H, I, 2);
    dirs := {(W, null), (hx, phx)} | hd;
    Mm := famMatrix(H, N, ca, dirs);
    Ref := matrix(kk, apply(numcols bq, m -> apply(dirs, dr -> psiRef(dr#0 * G * bq_(0,m)))));
    print(name, "psi(h G mu): famlib vs reference, equal:", Mm == Ref, "nonzero:", Ref != 0);
    gdx := matrix(kk, {apply(numcols bq, m -> (promote(1/(k+1), kk)) * (nuApply(H, N, matrix{{sum(numgens S, i -> diff(S_i, ell#i * G * bq_(0,m)))}}))_(0,0))});
    print(name, "derivation direction: famlib vs Griffiths-Dwork:", Mm_{1} == transpose gdx);
    qv := qVector(H, N, G, ca);
    qr := matrix(kk, {apply(numcols bq, m -> psiRef(G * G * bq_(0,m)))});
    print(name, "q: psi(G^2 mu) famlib vs reference, equal:", qv == qr, "nonzero:", qr != 0);
    -- also h outside T NL? psi(W * w * mu) for w with nu(w mu) != 0 is NOT covered (c' term); skip
    print(name, "dims: T NL", numcols TNL, "K0", numcols K0, "nu gb time", N#"time");
    );
-- (A) P^3 in a cubic sixfold (package CI data)
D = randomCyclePair(3, {1,1,1}, {1,1,1}, {1}, Seed => sd, CoefficientRing => ZZ/pr);
S = D#"ring"; F = D#"F"; kk = coefficientRing S;
f = D#"f"; p = D#"p"; s = D#"s"; M = D#"M"; h0 = D#"h";
g = flatten entries (M * transpose matrix{h0});
H = hsData F; I1 = ideal(f | p);
R1 = residueFunctional(f|p|g|s); L1 = secondOrderFunctional(f|p, g|s);
N1 = nuSetup(H, I1); r1m = R1(N1#"mstd");
print("(A) check nu proportional to residue functional:", rank(N1#"nuv" || (matrix{apply(flatten entries basis(H#"sig",S), u -> R1 u)} ** kk)));
runCase("(A) P^3/CI", H, I1, P -> L1(P) / (H#"k"+1) / r1m);
-- (B) non-CI: V = J(P^1_y, twisted cubic in P^3_w) in P^7, z0 = z1 = 0
S2 = (ZZ/pr)[w_0..w_3, y_0, y_1, z_0, z_1];
IC = minors(2, matrix{{w_0, w_1, w_2}, {w_1, w_2, w_3}});
IV2 = ideal(z_0, z_1) + IC;
I3b = super basis(3, IV2);
F2 = (I3b * random((ZZ/pr)^(numcols I3b), (ZZ/pr)^1))_(0,0);
H2 = hsData F2;
print("(B) smooth along V:", dim(IV2 + H2#"J") == 0);
N2 = nuSetup(H2, IV2);
C2 = psiSetup(H2, IV2, N2#"nuv");
print("(B) syz consistency", syzTest(H2, C2, 2));
runCase("(B) cone/non-CI", H2, IV2, P -> (psiDirect(H2, matrix{{P}}, C2))_(0,0));
print "VAL6 DONE";
