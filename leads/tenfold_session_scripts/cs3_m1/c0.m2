-- (c0a) Fermat cubic tenfold, linear cycle P^5: AG ideal of [P] at t = 0 from the package's closed-form periods
-- (fermatPeriodGD, pole 6) vs Movasati's complete intersection (f_i, g_i), F0 = sum f_i g_i.  usage: M2 --script c0.m2 prime
pr = s -> (stderr << s << endl << flush);
path = append(path, "/home/claude/hodge/package/HodgeLociCI/M2/"); needsPackage "HodgeLociCI";
p = value scriptCommandLine#1;
S = fermatRing(3, 10, p); kk = coefficientRing S;
load "/home/claude/hodge/discovery/checks/cs3_m1/m1ag.m2";
T0 = cpuTime();
for L in {{{0,1,1},{2,3,1},{4,5,1},{6,7,1},{8,9,1},{10,11,1}}, {{0,1,1},{2,4,3},{3,6,1},{5,7,5},{8,11,1},{9,10,3}}} do (
    P = fermatPeriodPolynomial(S, L);
    IL = fermatLinearSpaceIdeal(S, L);
    fs = flatten entries mingens IL;
    gs = apply(L, t -> (xa := S_(t#0); xb := S_(t#1); q := (xa^3 + xb^3); fl := select(fs, f -> (q % ideal f) == 0 and diff(xa, f) != 0 and diff(xb, f) != 0); q // (first fl)));
    CI = ideal(fs | gs);
    lam = apply(flatten entries basis(6, S), m -> fermatPeriodGD(P, m, 6));
    hx = agIndex 6;
    ok = true;
    for k from 1 to 3 do (
        C = agCat(lam, k, 6, hx);
        Kc = gens kernel C;
        ci = agCoef(flatten entries super basis(k, CI), k);
        sm = (rank(Kc | ci) == rank Kc and rank Kc == rank ci);
        if not sm then ok = false;
        pr("L " | toString L | " k=" | toString k | ": dim I(delta)_k " | toString numColumns Kc | ", dim CI_k " | toString rank ci | ", EQUAL " | toString sm));
    pr("  F0 in CI: " | toString((sum(12, i -> S_i^3)) % CI == 0) | "; c0a " | (if ok then "PASS" else "FAIL") | " " | toString(cpuTime() - T0)));
