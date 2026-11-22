-- VALIDATION TEST 14
-- Source:    THE SESSION'S OWN RESULTS (AI-produced, unreviewed; each file was confirmed once by a blind AI check):
--            team T3's exported Fermat certificates, discovery/t3_window/export_c3/ (six files) and export_x1/
--            (copied unchanged by agent PB to tests/data/fermat/, with SHA256SUMS). SOURCES.md entry E8.
-- Statement: for the Fermat cubic sixfold (NV = 8) / eightfold (NV = 10), Movasati's two planes and
--            delta = [P1] + lambda [P2], lambda in {-1, 2, 5/3}: the listed arc F_0 - (eps T_1 + ...) is tangent to the Hodge
--            locus and not to V_Z; all period functions vanish to order N-1 (N = 5, resp. 4); the vector c_N of
--            coefficients of eps^N is as listed and is NOT in the image of the first-order map L (rank L = 7, resp. 19,
--            against 8, resp. 20, for the pair of planes): a left-kernel vector K with K.c_N != 0 is listed.
--            export_x1: at a second pair "X1" of 4-planes, an obstruction at order 5 for lambda = 2 and an arc to order 7
--            for lambda = -1; two arcs (six_lam2_arc.txt, six_lam-1_arc.txt) along which all 45 period functions
--            vanish to order 9.
-- Computed:  fermatVerifyCertificate(file): every checkable claim of each file is recomputed over Q(zeta_6).
--            Two negative controls: a certificate with one changed coefficient must be rejected.
-- Label:     EXACT (Q(zeta_6)). What the certificates imply about the Hodge locus is CONDITIONAL (see SOURCES.md, E8)
--            and is not tested here. NOT COVERED: claim 4 of x1_lam2_obstruction.txt (independence of the choice of
--            T_2..T_4), which is not checkable from the file; the reading of the six_* files as arcs of cubic
--            sixfolds; the rank statements of README_export_x1_round4.txt (computed modulo primes in the session).
-- Expected:  "pass" => true for all files; "pass" => false for the corrupted ones.
load (currentFileDirectory | "common.m2")
dataDir = realpath(pcDir | "../data/fermat") | "/";

for f in {"cert_n6_lam-1.txt", "cert_n6_lam2.txt", "cert_n6_lam5o3.txt", "cert_n8_lam-1.txt", "cert_n8_lam2.txt", "cert_n8_lam5o3.txt"} do (
    C := fermatReadCertificate(dataDir | f);
    v := fermatVerifyCertificate C;
    expect(f | ": {pass, vanishing order, obstruction order, number of checks failed}",
        {v#"pass", v#"vanishingOrder", v#"obstructionOrder", #select(v#"checks", c -> not c#1)},
        {true, if C#"dimension" == 6 then 4 else 3, if C#"dimension" == 6 then 5 else 4, 0});
    expect(f | ": claimed ranks {rank L, rank [L_P1; L_P2]} (verified inside 'pass')",
        {(C#"claimedRanks")#"L", (C#"claimedRanks")#"L12"}, if C#"dimension" == 6 then {7, 8} else {19, 20});
    expect(f | ": label", match("EXACT", v#"label"), true);
    );
for f in {"x1_lam2_obstruction.txt", "x1_lam-1_arc.txt"} do (
    v := fermatVerifyCertificate(dataDir | f);
    expect(f | ": {pass, vanishing order, obstruction order}", {v#"pass", v#"vanishingOrder", v#"obstructionOrder"},
        if f == "x1_lam2_obstruction.txt" then {true, 4, 5} else {true, 7, null});
    );
for f in {"six_lam2_arc.txt", "six_lam-1_arc.txt"} do (
    v := fermatVerifyCertificate(dataDir | f);
    expect(f | ": {pass, vanishing order}", {v#"pass", v#"vanishingOrder"}, {true, 9});
    );
-- negative controls: change one coefficient of T_2, resp. one listed value of c_5, in cert_n6_lam-1.txt
txt = get(dataDir | "cert_n6_lam-1.txt");
bad1 = temporaryFileName() | ".txt";
bad1 << replace("T_2 = \\[-1/3\\]\\*x0\\*x2\\*x6", "T_2 = [-1/2]*x0*x2*x6", txt) << close;
expect("control file 1 really differs from the certificate", get bad1 != txt, true);
v = fermatVerifyCertificate bad1;
expect("corrupted arc (one coefficient of T_2 changed): pass", v#"pass", false);
report("corrupted arc: first failing order", v#"firstFailingOrder");
bad2 = temporaryFileName() | ".txt";
bad2 << replace("c_5\\[x7\\] = \\(-18\\)\\+\\(9\\)\\*z", "c_5[x7] = (-18)+(8)*z", txt) << close;
expect("control file 2 really differs from the certificate", get bad2 != txt, true);
v = fermatVerifyCertificate bad2;
expect("corrupted claim (one listed value of c_5 changed): pass", v#"pass", false);
finish()
