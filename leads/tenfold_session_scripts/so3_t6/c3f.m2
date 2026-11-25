-- c3' (part 1): engine vs the package's closed-form Fermat periods (all pole orders), cubic sixfold, one 3-plane.
-- usage: M2 --script c3f.m2 seed prime
pr = s -> (stderr << s << endl << flush);
path = append(path, "/home/claude/hodge/package/HodgeLociCI/M2/"); needsPackage "HodgeLociCI";
sd = value scriptCommandLine#1; p = value scriptCommandLine#2;
S = fermatRing(3, 6, p); kk = coefficientRing S; setRandomSeed sd;
load "/home/claude/hodge/discovery/checks/so3_t6/o3lib.m2";
F = sum(8, i -> S_i^3);
for L in {{{0,1,1},{2,3,1},{4,5,1},{6,7,1}}, {{0,1,3},{2,3,3},{4,5,3},{6,7,3}}, {{0,1,1},{2,4,1},{3,6,1},{5,7,3}}} do (
    I = fermatLinearSpaceIdeal(S, L); P = fermatPeriodPolynomial(S, L);
    H = o3Setup(F, flatten entries mingens I, 3, 1_kk);
    pi0 = fermatPeriodGD(P, H#"m0", 4); H#"PiT" = pi0 * H#"PiT";
    pr("L = " | toString L | " m0 = " | toString H#"m0" | " pi0 = " | toString pi0);
    one = matrix{{1_S}};
    for m from 1 to 3 do (
        d = 3*(3+m) - 8;
        Ps = apply(4, i -> random(d, S));
        eng = apply(Ps, Pp -> (v := first o3Eval(H, m, one, null, matrix{{Pp}}); (v#"1")_(0,0)));
        fer = apply(Ps, Pp -> fermatPeriodGD(P, Pp, 3 + m));
        pr("  level " | toString m | " (pole " | toString(3+m) | ", deg " | toString d | "): engine " | toString eng | " Fermat " | toString fer | " AGREE " | toString(eng == fer)));
    -- factored mode with multipliers z in S_1 (as used by the order-3 test)
    Bz = basis(1, S);
    W = random(9, S); (v, st) = o3Eval(H, 3, Bz, W, null);
    fer = apply(flatten entries Bz, z -> fermatPeriodGD(P, z * W, 6));
    pr("  factored level 3, z in S_1: AGREE " | toString(flatten entries v#"1" == fer) | "  stats " | toString pairs st | " other keys " | toString select(keys v, kx -> kx =!= "1"));
    W = random(6, S); (v, st) = o3Eval(H, 2, Bz, W, null);
    fer = apply(flatten entries Bz, z -> fermatPeriodGD(P, z * W, 5));
    pr("  factored level 2, z in S_1: AGREE " | toString(flatten entries v#"1" == fer));
    );
pr("time " | toString cpuTime());
