-- CS3-M1 library: t-expansion of the period functional pi_t of delta_t on S_sig along an arc F + sum t^i f_i.
-- Expects S, kk, pr, H (o3Setup), Kv, o3lib loaded.  ek = engine k (H#"k"); sig = 3(ek+1) - numgens S.
m1E = (fs, r, j) -> (   -- [t^j] (sum_i t^i f_i)^r
    if r == 0 then return (if j == 0 then 1_S else 0_S);
    if r == 1 then return (if j >= 1 and j <= #fs then fs#(j-1) else 0_S);
    sum(toList(1..min(j, #fs)), i -> fs#(i-1) * m1E(fs, r-1, j-i)));
m1Lev = (m, Bz, W) -> (
    if W == 0 then return map(kk^1, kk^(numColumns Bz), 0);
    (v, st) := o3Eval(H, m, Bz, W, null);
    (row, unr) := o3Subst(v, new HashTable from Kv);
    if #unr > 0 then error("m1Lev: unresolved keys " | toString unr);
    pr("    level " | toString m | " nz " | toString numColumns Bz | " stats " | toString pairs st | " " | tm());
    row);
-- engine part at order j: (lambda_j on Bc, mu_j on B3); mu_j omits nothing (f_j included)
m1Order = (fs, j, Bc, B3) -> (
    ek := H#"k";
    lam := map(kk^1, kk^(numColumns Bc), 0); mu := map(kk^1, kk^(numColumns B3), 0);
    for r from 1 to j do (
        E := m1E(fs, r, j);
        if E == 0 then continue;
        lam = lam + ((-1)^r * binomial(ek + r, r)) * m1Lev(1 + r, Bc, E);
        mu = mu + ((-1)^r * binomial(ek - 1 + r, r)) * m1Lev(r, B3, E));
    (lam, mu));
-- Jacobian Groebner data in degree sig via Singular liftstd (M2's ChangeMatrix gb was too slow): returns JD.
-- fs: arc terms known now (h_{g,i} = sum_l cof_{g,l} d_l f_i exported for them); more added later by m1JacMoreH.
m1toSing = f -> replace("x_([0-9]+)", "x(\\1)", toString f);
m1fromSing = s -> value replace("x\\(([0-9]+)\\)", "x_\\1", s);
m1Sing = (body, base) -> (
    fn := base | ".sing";
    fn << body << endl << "quit;" << endl << close;
    t1 := currentTime();
    rc := run("Singular -q " | fn | " > " | base | ".singout 2>&1");
    if rc != 0 then error("Singular failed, see " | base | ".singout");
    pr("  Singular " | base | ": " | toString(currentTime() - t1) | "s wall"));
m1JacSetup = (F, sig, fs, base) -> (
    N := numgens S;
    hdr := "ring r = " | toString char kk | ", (x(0.." | toString(N-1) | ")), dp; option(redSB); degBound = " | toString sig | ";\n";
    body := hdr | "poly F = " | m1toSing F | ";\nideal J = jacob(F);\nmatrix T[" | toString N | "][1];\nideal G = liftstd(J, T);\n" |
        "write(\"ssi:w " | base | "_T.ssi\", T);\n" |
        "if (size(ideal(matrix(J) * T - matrix(G))) != 0) { \"CHANGE MATRIX FAIL\"; }\n" |
        "write(\":w " | base | "_G.txt\", string(G));\n" |
        "int g; int l; poly d; string s = \"\"; for (g = 1; g <= ncols(T); g++) { d = 0; for (l = 1; l <= " | toString N | "; l++) { d = d + diff(T[l, g], x(l-1)); } if (g > 1) { s = s + \",\"; } s = s + string(d); }\n" |
        "write(\":w " | base | "_divcof.txt\", s);\n";
    if fileExists(base | "_divcof.txt") and fileExists(base | "_T.ssi") and fileExists(base | "_G.txt") then pr("  reusing Singular liftstd files " | base) else (
    m1Sing(body, base);
    if match("FAIL", get(base | ".singout")) then error "Singular change matrix check failed");
    gl := m1fromSing("{" | get(base | "_G.txt") | "}");
    lcs := apply(gl, u -> leadCoefficient u);
    gl = apply(#gl, i -> gl#i * (1_kk / lcs#i));
    dc := m1fromSing("{" | get(base | "_divcof.txt") | "}");
    dc = apply(#dc, i -> sub(dc#i, S) * (1_kk / lcs#i));
    pr("  Jacobian gb (deg <= " | toString sig | "): " | toString(#gl) | " elements (Singular liftstd, change matrix checked)");
    Bs := basis(sig, S); ms := flatten entries Bs;
    idx := new MutableHashTable; scan(#ms, i -> idx#(ms#i) = i);
    LM := apply(gl, u -> leadMonomial u);
    asg := new MutableHashTable;
    for gi from 0 to #gl - 1 do (
        dgi := first degree gl#gi;
        if dgi > sig then continue;
        scan(flatten entries basis(sig - dgi, S), xa -> (ii := idx#(xa * LM#gi); if not asg#?ii then asg#ii = (gi, xa))));
    std := select(#ms, i -> not asg#?i);
    pr("  standard monomials in degree " | toString sig | ": " | toString(#std));
    ord := sort apply(keys asg, i -> (ms#i, i));
    JD := new MutableHashTable from {"gl" => gl, "lcs" => lcs, "tail" => apply(gl, u -> u - leadTerm u), "idx" => idx, "ms" => ms,
        "asg" => new HashTable from asg, "std" => std, "ord" => apply(ord, pq -> pq#1), "Bc" => matrix{apply(std, i -> ms#i)},
        "divcof" => dc, "h" => new MutableHashTable, "base" => base, "hdr" => hdr};
    JD);
-- h_{g,i} = sum_l cof_{g,l} d_l f_i (normalised by lc g), via Singular from the saved change matrix
m1JacMoreH = (JD, i, f) -> (
    base := JD#"base"; N := numgens S;
    body := JD#"hdr" | "def T = read(\"ssi:r " | base | "_T.ssi\");\npoly f = " | m1toSing f | ";\nmatrix Hm = matrix(jacob(f)) * T;\n" |
        "int g; string s = \"\"; for (g = 1; g <= ncols(Hm); g++) { if (g > 1) { s = s + \",\"; } s = s + string(Hm[1, g]); }\n" |
        "write(\":w " | base | "_h" | toString i | ".txt\", s);\n";
    m1Sing(body, base | "_h" | toString i);
    hl := m1fromSing("{" | get(base | "_h" | toString i | ".txt") | "}");
    (JD#"h")#i = apply(#hl, g -> sub(hl#g, S) * (1_kk / (JD#"lcs")#g)));
-- cofactors themselves (needed only when mu != 0, control c-)
m1JacCof = JD -> (
    base := JD#"base"; N := numgens S;
    body := JD#"hdr" | "def T = read(\"ssi:r " | base | "_T.ssi\");\n" |
        "int g; int l; string s = \"\"; for (g = 1; g <= ncols(T); g++) { for (l = 1; l <= " | toString N | "; l++) { if (g + l > 2) { s = s + \",\"; } s = s + string(T[l, g]); } }\n" |
        "write(\":w " | base | "_cof.txt\", s);\n";
    m1Sing(body, base | "_cof");
    cl := m1fromSing("{" | get(base | "_cof.txt") | "}");
    JD#"cof" = apply(#(JD#"gl"), g -> apply(N, l -> sub(cl#(g * N + l), S) * (1_kk / (JD#"lcs")#g))));
-- extension of lambda_j from the standard monomials to all of S_sig by Griffiths-Dwork along the arc.
-- rhs(x^a g) = sum_l <x^a T_lg, nu_l> + (1/ek) mu(div(x^a T_g)),  nu_l = -sum_i lambda_(j-i)(. d_l f_i)  (dual forms);
-- per g the dual form W_g (value at x^a = rhs) is computed in Singular from the saved change matrix T.
m1Extend = (JD, fs, j, lamBc, mu, lamPrev, sig, ekk) -> (
    N := numgens S; ms := JD#"ms"; idx := JD#"idx"; gl := JD#"gl";
    lam := new MutableList from (#ms : null);
    scan(#(JD#"std"), s -> lam#((JD#"std")#s) = lamBc#s);
    m3l := flatten entries basis(sig - 3, S);
    Mu := sum(#m3l, i -> mu#i * m3l#i);
    Dg := null;
    if j > 0 then (
        LamP := apply(lamPrev, v -> sum(#ms, i -> if v#i == 0 then 0_S else v#i * ms#i));
        nu := apply(N, l -> sum(toList(1..min(j, #fs)), i -> - contract(diff(S_l, fs#(i-1)), LamP#(j-i))));
        base := JD#"base"; wf := base | "_W" | toString j | ".txt";
        body := JD#"hdr" | "def T = read(\"ssi:r " | base | "_T.ssi\");\npoly n(1.." | toString N | ");\n" |
            concatenate apply(N, l -> "n(" | toString(l+1) | ") = " | m1toSing(nu#l) | ";\n") |
            "poly Mu = " | m1toSing(Mu) | ";\nint muNZ = (Mu != 0);\npoly w; poly c; poly d; int g; int l;\n" |
            "write(\":w " | wf | "\", \"\");\n" |
            "for (g = 1; g <= ncols(T); g++) { w = 0; d = 0;\n" |
            "  for (l = 1; l <= " | toString N | "; l++) { if (T[l, g] != 0) {\n" |
            "    w = w + contract(ideal(T[l, g]), ideal(n(l)))[1, 1];\n" |
            "    if (muNZ) { c = contract(ideal(T[l, g]), ideal(Mu))[1, 1]; w = w + (1/" | toString ekk | ") * x(l-1) * diff(x(l-1) * c, x(l-1)); d = d + diff(T[l, g], x(l-1)); } } }\n" |
            "  if (muNZ) { w = w + (1/" | toString ekk | ") * contract(ideal(d), ideal(Mu))[1, 1]; }\n" |
            "  write(\":a " | wf | "\", string(w) + \",\"); }\n";
        m1Sing(body, base | "_W" | toString j);
        str := get wf; str = replace("[\n ]", "", str); str = substring(0, #str - 1, str);
        Wl := m1fromSing("{" | str | "}");
        if #Wl != #gl then error "W count";
        Dg = apply(#gl, gi -> sub(Wl#gi, S) * (1_kk / (JD#"lcs")#gi)));
    t1 := cpuTime();
    for i in JD#"ord" do (
        (gi, xa) := (JD#"asg")#i;
        v := if Dg === null then 0_kk else lift(coefficient(xa, Dg#gi), kk);
        P := xa * (JD#"tail")#gi;
        (mons, cfs) := coefficients P;
        ml := flatten entries mons; cl := flatten entries cfs;
        for q from 0 to #ml - 1 do (
            u := lam#(idx#(ml#q));
            if u === null then error "m1Extend: order violation";
            v = v - lift(cl#q, kk) * u);
        lam#i = v);
    pr("  extension order " | toString j | ": DP " | toString(cpuTime() - t1) | "s");
    toList lam);
-- direct evaluation of lambda_j on given polynomials R (check of the extension)
m1Direct = (fs, j, Rs) -> (
    ek := H#"k"; out := map(kk^1, kk^(#Rs), 0);
    for r from 1 to j do (E := m1E(fs, r, j); if E != 0 then out = out + ((-1)^r * binomial(ek + r, r)) * (first o3Subst(first o3Eval(H, 1 + r, matrix{{1_S}}, null, matrix{apply(Rs, R -> R * E)}), new HashTable from Kv)));
    out);
m1Eval = (lamFull, JD, R) -> (   -- value of a full functional on a polynomial R of degree sig
    (mons, cfs) := coefficients R; ml := flatten entries mons; cl := flatten entries cfs;
    sum(#ml, q -> lift(cl#q, kk) * lamFull#((JD#"idx")#(ml#q))));
