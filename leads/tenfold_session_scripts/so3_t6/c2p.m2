-- SO3-T6 control c2' (positive control at third order) + c3' (engine vs package on the actual order-3 inputs).
-- Fermat cubic sixfold, P1 = {x0=-x1,x2=-x3,x4=-x5,x6=-x7}, P2 = {x0=z x1,x2=z x4,x3=z x6,x5=-x7} (corank-1 pair of [T2] 04:33Z,
-- blind-checked EXACTLY by C5: order-3 obstruction along w + s e equals s^2 psi_lam(w), psi_lam = lam(lam-1) psi, no s^0 term).
-- Class [P1] + lam [P2].  The same order-3 pipeline as t3.m2 (k = 3: Q in S_1, order 2: pi(Q g2) = 2 psi(Q G^2),
-- order 3: c3(Q) = 4 psi(Q G g2) - (10/3) psi3(Q G^3), test on the left kernel Kl of the first-order map, freedom
-- 4 psi(Kl G w), w in T NL, computed in FULL).  Evaluated twice: engine o3lib.m2 and the package's closed-form Fermat periods.
-- usage: M2 --script c2p.m2 seed prime
pr = s -> (stderr << s << endl << flush);
path = append(path, "/home/claude/hodge/package/HodgeLociCI/M2/"); needsPackage "HodgeLociCI";
sd = value scriptCommandLine#1; p = value scriptCommandLine#2;
S = fermatRing(3, 6, p); kk = coefficientRing S; setRandomSeed sd;
load "/home/claude/hodge/discovery/checks/so3_t6/o3lib.m2";
T0 = cpuTime(); tm = () -> toString(round(cpuTime() - T0)) | "s";
F = sum(8, i -> S_i^3);
Ls = {{{0,1,3},{2,3,3},{4,5,3},{6,7,3}}, {{0,1,1},{2,4,1},{3,6,1},{5,7,3}}};
Hs = apply(Ls, L -> (
    I := fermatLinearSpaceIdeal(S, L); P := fermatPeriodPolynomial(S, L);
    H := o3Setup(F, flatten entries mingens I, 3, 1_kk);
    H#"PiT" = fermatPeriodGD(P, H#"m0", 4) * H#"PiT"; H#"P" = P; H#"I" = I; H));
B1 = basis(1, S); B3 = basis(3, S);
cf3 = M -> lift(last coefficients(M, Monomials => B3), kk);
-- per-plane first-order maps (8 x 120) from the package
L1map = H -> matrix apply(flatten entries B1, q -> apply(flatten entries B3, u -> fermatPeriodGD(H#"P", q * u, 4)));
Lp = apply(Hs, L1map);
kerL = M -> generators kernel M;
TSig = generators intersect(image kerL(Lp#0), image kerL(Lp#1));
pr("dim ker L1 = " | toString numColumns kerL(Lp#0) | ", ker L2 = " | toString numColumns kerL(Lp#1) | ", T_Sigma = " | toString numColumns TSig | " " | tm());
runCase = (lam, arm) -> (
    co := {1_kk, lam * 1_kk};
    psiE := (m, Bz, W) -> sum(2, i -> co#i * (first o3Eval(Hs#i, m, Bz, W, null))#"1");
    psiP := (m, Bz, W) -> matrix{apply(flatten entries Bz, z -> sum(2, i -> co#i * fermatPeriodGD(Hs#i#"P", z * W, 3 + m)))};
    L := Lp#0 + lam * Lp#1;
    Kl := transpose generators kernel transpose L;          -- rows: left kernel (Q-combinations)
    TN := generators kernel L;                              -- columns: T NL
    G := if arm == "generic" then (B3 * sub(TN * random(kk^(numColumns TN), kk^1), S))_(0,0)
         else (B3 * sub(TSig * random(kk^(numColumns TSig), kk^1), S))_(0,0);
    out := {};
    for ev in {"engine", "package"} do (
        psiF := if ev == "engine" then psiE else psiP;
        v2 := psiF(2, B1, G^2);
        o2 := Kl * transpose v2;
        y := (2 * transpose v2) // L;
        if L * y != 2 * transpose v2 then (pr("  order 2 not solvable"); out = append(out, null); continue);
        g2 := (B3 * sub(y, S))_(0,0);
        c3 := 4 * psiF(2, B1, G * g2) - (10_kk / 3) * psiF(3, B1, G^3);
        Fr := matrix apply(numColumns TN, j -> flatten entries (Kl * transpose (4 * psiF(2, B1, G * (B3 * sub(TN_{j}, S))_(0,0)))));
        k3 := Kl * transpose c3;
        solv := rank(transpose Fr | k3) == rank transpose Fr;
        pr("  lam " | toString lam | " arm " | arm | " [" | ev | "]: dim Kl " | toString numRows Kl | ", dim T NL " | toString numColumns TN | "; order 2 on Kl " | toString entries o2 | "; Kl.c3 = " | toString entries k3 | "; rank freedom " | toString rank Fr | " => " | (if solv then "SOLVABLE (unobstructed at order 3)" else "OBSTRUCTED at order 3") | " " | tm());
        out = append(out, (c3, solv)));
    if out#0 =!= null and out#1 =!= null then pr("  c3' engine vs package: c3 vectors equal " | toString(out#0#0 == out#1#0) | ", verdicts equal " | toString(out#0#1 == out#1#1));
    out);
runCase(2, "generic");
runCase(2, "TSigma");
runCase(1, "generic");
runCase(-1, "generic");
pr("time " | tm());
