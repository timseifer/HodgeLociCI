-- SR-T6: semiregularity test. usage: M2 --script sr.m2 seed p mode   (mode V: J(P^2,T) in random X of F_T; P: 5-plane in random cubic; Z: union of two 5-planes meeting in P^2)
-- ob: S_3 -> coker(beta) in Ext^2_X(O_C,O_C), ker ob = T_sh = Hilbert-pair image (when H^1(O_C) = 0 and depth A_C >= 2);
-- sigma_4 o ob has kernel T NL([C]).  ker(sigma_4 | im ob) = dim T NL - dim T_sh.
pr = s -> (stderr << s << endl << flush);
sd = value scriptCommandLine#1; p = value scriptCommandLine#2; mode = scriptCommandLine#3;
needsPackage("HodgeLociCI", FileName => "/home/claude/hodgelocici/M2/HodgeLociCI.m2");
kk = ZZ/p; S = kk[x_0..x_11]; setRandomSeed(sd);
load "/home/claude/hodge/discovery/checks/w1/w1lib.m2";
load "/home/claude/hodge/discovery/checks/cs_t6/cslib.m2";
m3 = basis(3, S); L3 = flatten entries m3; cf = M -> lift(last coefficients(M, Monomials => m3), kk);
B6 = basis(6, S); mons = flatten entries B6; idx = new MutableHashTable; scan(#mons, i -> idx#(mons#i) = i);
funcs = (F, I) -> (
    IJ := ideal gens gb (I + ideal jacobian matrix{{F}});
    bt := lift(basis(6, S/IJ), S); m := numColumns bt;
    C := lift(last coefficients(B6 % IJ, Monomials => bt), kk);
    (m, apply(m, j -> flatten entries C^{j}), dim IJ));
pairing = v -> matrix table(#L3, #L3, (i,j) -> v_(idx#(L3#i * L3#j)));
-- local cohomology checks of A = S'/I' (cycle in P^8 = V(x_9,x_10,x_11)): H^i_m(A)_k dual to Ext^(9-i)(A, S')_(-k-9)
Sp = kk[z_0..z_8]; toP = map(Sp, S, (gens Sp) | {0_Sp,0_Sp,0_Sp});
lcCheck = I -> (
    Ip := trim toP I; A := Sp^1/Ip; t0 := cpuTime();
    C := res(A, LengthLimit => 10); pd := length C;
    pr("  pdim A = " | toString pd | " -> depth A = " | toString(9 - pd) | ", dim A = " | toString(dim Ip) | "  (" | toString(cpuTime()-t0) | " s)");
    -- H^2_m(A) <-> Ext^7 : zero iff pd < 7
    e7 := if pd >= 7 then Ext^7(A, Sp^1) else 0;
    pr("  H^0_m = H^1_m = 0 (depth >= 2): " | toString(9 - pd >= 2) | ";  H^2_m(A) = 0, i.e. H^1(O_C(k)) = 0 for all k: " | toString(pd < 7 or e7 == 0));
    (9 - pd, pd < 7 or e7 == 0));
if mode == "V" then (
    IV = trim w1cycle("J2T");
    -- check on T itself: H^1(O_T) = H^2_(m_B)(B)_0 = dual of Ext^4_(S_T)(B, S_T)_(-6)
    R6 = kk[u_0..u_5]; IT = trim (map(R6, S, gens R6 | toList(6:0_R6))) (IV + ideal(x_6,x_7,x_8));
    E4 = Ext^4(R6^1/IT, R6^1); pr("T: dim " | toString(dim IT - 1) | " deg " | toString degree IT | "; h^1(O_T) = dim Ext^4(B,S_T)_(-6) = " | toString hilbertFunction(-6, E4));
    ) else if mode == "P" then (
    IV = ideal(x_0,x_1,x_2,x_9,x_10,x_11);
    ) else if mode == "Z" then (
    IV = intersect(ideal(x_0,x_1,x_2,x_9,x_10,x_11), ideal(x_3,x_4,x_5,x_9,x_10,x_11));
    );
IV = trim IV;
pr("mode " | mode | " seed " | toString sd | " p " | toString p | ": C dim " | toString(dim IV - 1) | " deg " | toString degree IV);
(dep, h1zero) = lcCheck IV;
-- random X containing C (for Z: in the package's form f^T M h + p.s, so the package's T NL at lambda0 applies)
if mode == "Z" then (
    M = random(S^3, S^{3:-1}); s = flatten entries random(S^1, S^{3:-2});
    D = cyclePair({x_0,x_1,x_2}, {x_3,x_4,x_5}, {x_9,x_10,x_11}, M, s);
    F = D#"F"; pr("F in I_Z: " | toString(F % IV == 0) | "; package: tau " | toString D#"tau" | ", lambda0 " | toString D#"lambda0");
    ex = excessFromData D; codNL = ex#"codimNLAtLambda0";
    pr("package excessFromData (Hilbert functions, MOD p; identification with Hodge-locus codims: paper 3 Thm 2, AI-written, unreviewed): codim V_Z = " | toString ex#"codimVZ" | ", excess at lambda0 = " | toString ex#"excessAtLambda0" | ", codim NL([P1]+lambda0[P2]) = " | toString codNL | ", excess elsewhere = " | toString ex#"excessElsewhere");
    dIJ = dim(IV + ideal jacobian matrix{{F}}); m = "n/a";
    ) else (
    F = (super basis(3, IV) * random(kk^(numColumns super basis(3, IV)), kk^1))_(0,0);
    (m, rows, dIJ) = funcs(F, IV);
    PV = pairing(rows#0); codNL = rank PV;
    );
pr("X smooth along C: " | toString(dIJ == 0) | "; m = codim (I_C + J)_6 = " | toString m | "; codim T NL([C]) = " | toString codNL);
(c0, c1, h0) = csCodimP8(F, IV);
TF = cf(matrix{w1TFpolys}); dTF = rank TF; dI3 = numColumns super basis(3, IV);
J1 = cf(matrix{flatten entries ((jacobian matrix{{F}}) * vars S)});
if mode != "Z" then pr("T_sh = T(Hilb pair image) inside T NL (pi kills T_sh . S_3): " | toString(PV * TF == 0));
-- beta: Hom_0 -> H^0(O_C(3)) = (S/I_C)_3 ; rank beta = dim T_sh - dim I_C(3)
rb = dTF - dI3;
pr("dim (I_C)_3 = " | toString dI3 | ", h^0(O_C(3)) = " | toString(364 - dI3) | ", Hom_0 = h^0(N_C) = " | toString h0 | ", rank beta = " | toString rb | " (beta injective: " | toString(rb == h0) | ", i.e. Ext^1_X(O_C,O_C) = ker beta = " | toString(h0 - rb) | ")");
dimImOb = 364 - dTF; rkSig = codNL; kerSig = dimImOb - rkSig;
pr("RESULT mode " | mode | " seed " | toString sd | " p " | toString p | ": depth A " | toString dep | ", H^1(O_C(*)) = 0 " | toString h1zero | ", dim im ob = codim T_sh = " | toString dimImOb | " (= codim F_C " | toString c1 | "), rank sigma_4 o ob = codim T NL = " | toString rkSig | ", dim ker(sigma_4 | im ob) = " | toString kerSig | ", Ext^1_X(O_C,O_C) = " | toString(h0 - rb));
pr "SR DONE";
