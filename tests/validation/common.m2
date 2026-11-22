-- tests/validation/common.m2  (agent PC)
-- Shared helpers of the validation suite of HodgeLociCI. Loaded by every test with
--     load (currentFileDirectory | "common.m2")
-- The package is loaded from the repository itself (no installation needed).
-- STATUS: written by an AI agent, not reviewed by a human.

pcDir = currentFileDirectory;
needsPackage("HodgeLociCI", FileName => realpath(pcDir | "../../M2/HodgeLociCI.m2"));

pcChecks = 0; pcFails = 0;

-- one checked value: prints a RESULT line (these lines are compared with tests/expected/*.out by run_all.sh)
expect = (lab, got, want) -> (
    pcChecks = pcChecks + 1;
    ok := (got === want) or (try (got == want) else false);
    if not ok then pcFails = pcFails + 1;
    << "RESULT " << lab << " = " << toString got
       << (if ok then "   ok" else "   MISMATCH: expected " | toString want) << endl;
    ok);

-- A RECORDED DISAGREEMENT between the package and a published number (as read by machine). Neither side is
-- adjusted: the line is printed in every run and counted by run_all.sh. If the two values ever agree, that is
-- reported as a failure, so that the record gets looked at again.
pcDisagree = 0;
knownDisagreement = (lab, got, published, note) -> (
    if got === published or (try (got == published) else false) then (
        pcChecks = pcChecks + 1; pcFails = pcFails + 1;
        << "RESULT " << lab << " = " << toString got << "   MISMATCH: a disagreement with the published value was recorded here, but the values now agree" << endl;)
    else (
        pcDisagree = pcDisagree + 1;
        << "DISAGREE " << lab << ": package = " << toString got << "; published (as read by machine) = " << toString published
           << "   [" << note << "]" << endl;);
    );

-- a value that is printed but has no published or recorded expected value
report = (lab, got) -> (<< "INFO   " << lab << " = " << toString got << endl;);

finish = () -> (
    if pcFails == 0 then (<< "ALL " << pcChecks << " CHECKS PASSED"
        << (if pcDisagree > 0 then "; " | toString pcDisagree | " RECORDED DISAGREEMENT(S) WITH A PUBLISHED NUMBER" else "") << endl; exit 0)
    else (<< pcFails << " OF " << pcChecks << " CHECKS FAILED" << endl; exit 1));

-- wall-clock time since the previous call (TIME lines are not compared with the expected output)
pcLast = currentTime();
pcT0 = cpuTime();
tick = lab -> (t := cpuTime(); << "TIME   " << lab << " : " << toString(round(10*(t - pcT0))/10.) << " s cpu" << endl; pcT0 = t;);

ones = n -> toList(n : 1);

-- random data for two k-planes meeting in dimension k-c on a hypersurface of degree d (MOD p, fixed seed)
linearPair = (d, k, c, seed) -> randomCyclePair(d, ones c, ones c, ones(k+1-c), Seed => seed);

-- a primitive 2d-th root of unity in the prime field kk (needs char kk = 1 mod 2d)
pcRoot = (kk, d) -> (
    p := char kk;
    if (p - 1) % (2*d) != 0 then error "pcRoot: need p = 1 mod 2d";
    for a from 2 to 500 do (
        z := (a_kk)^((p-1)//(2*d));
        if z^d == -1_kk and all(toList(1..2*d-1), j -> z^j != 1_kk) then return z;
        );
    error "pcRoot: no primitive root found");

-- The Fermat hypersurface x_0^d + ... + x_(2k+1)^d over ZZ/p with "Movasati's two planes"
--   P1: x_(2i) = z x_(2i+1) for all i;   P2: x_(2i) = z^3 x_(2i+1) for i < c, x_(2i) = z x_(2i+1) for i >= c,
-- written as a CyclePair (f,h,p,M,s): F = f^T M h + sum p_l s_l with M diagonal. z = a primitive 2d-th root of 1.
-- Independent of the Fermat module of the package (used to cross-check the two).
fermatPairModP = (d, k, c, p) -> (
    kk := ZZ/p;
    y := getSymbol "y";
    S := kk(monoid[y_0..y_(2*k+1)]);
    z := pcRoot(kk, d);
    lin := (i, e) -> S_(2*i) - z^e * S_(2*i+1);
    f := apply(c, i -> lin(i, 1));
    h := apply(c, i -> lin(i, 3));
    pp := apply(toList(c..k), l -> lin(l, 1));
    M := matrix(S, table(c, c, (i, j) -> if i == j then product(toList(2..d-1), jj -> lin(i, 2*jj+1)) else 0_S));
    s := apply(toList(c..k), l -> product(toList(1..d-1), jj -> lin(l, 2*jj+1)));
    D := cyclePair(f, h, pp, M, s);
    if D#"F" != sum(2*k+2, i -> (S_i)^d) then error "fermatPairModP: internal error, F is not the Fermat polynomial";
    D);

-- Movasati-type linear spaces for the Fermat module of the package: lists {a,b,e} meaning x_a = z^e x_b
fermatSpaces = (k, c) -> (
    apply(k+1, i -> {2*i, 2*i+1, 1}),
    apply(k+1, i -> {2*i, 2*i+1, if i < c then 3 else 1}));
