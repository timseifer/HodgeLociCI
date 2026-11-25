-- CS3-M1 main run.  usage: M2 --script m1run.m2 seed prime mode Nmax
--   mode G: arc F + t G_e + t^2 g2_0 + t^3 f3 (f3 solved here);  cp: (c+) (F + tW) o g_t^(-1);  cm: (c-) F + t w, w random cubic
sd = value scriptCommandLine#1; p = value scriptCommandLine#2; mode = scriptCommandLine#3; Nmax = value scriptCommandLine#4;
tag = mode | "_" | toString sd | "_" | toString p;
logf = "/home/claude/hodge/discovery/checks/cs3_m1/log_" | tag | ".txt";
pr = s -> (stderr << s << endl << flush; f := openOutAppend logf; f << s << endl; close f);
load "/home/claude/hodge/discovery/checks/cs3_m1/m1setup.m2";
load "/home/claude/hodge/discovery/checks/cs3_m1/m1lib.m2";
load "/home/claude/hodge/discovery/checks/cs3_m1/m1ag.m2";
odir = "/home/claude/hodge/discovery/checks/cs3_m1/";
dat = value get("/home/claude/hodge/discovery/checks/so3_t6/t3_G_" | toString sd | "_" | toString p | ".txt");
pr("START " | tag | " Nmax " | toString Nmax | "; F matches SO3-T6 file " | toString(dat#0 == F) | ", Ge matches " | toString(dat#1 == Ge));
if dat#0 != F then error "F mismatch";
-- arc
setRandomSeed(1000 + sd);
fs = if mode == "G" then {Ge, dat#3} else if mode == "cm" then {random(3, S)} else (
    W := (super basis(3, I) * random(kk^(numColumns super basis(3, I)), kk^1))_(0,0);
    Am := random(kk^12, kk^12);
    R2 := kk[y_0..y_11, T]; toR := map(R2, S, take(gens R2, 12)); toS := map(S, R2, gens S | {0_S});
    xv := vars R2; Wl := toR W; Fl := toR F;
    Ginv := sum(4, i -> (-1)^i * T^i * (sub(Am, R2))^i);
    sb := map(R2, R2, flatten entries (xv_{0..11} * transpose Ginv) | {T});
    Ft := sb(Fl + T * Wl);
    cT := i -> toS sum(select(terms Ft, u -> degree(T, u) == i), u -> u // T^i);
    if cT 0 != F then error "c+ arc";
    cpSub = (q -> (qq := sb(toR q); apply(4, i -> toS sum(select(terms qq, u -> degree(T, u) == i), u -> u // T^i))));
    apply(3, i -> cT(i + 1)));
pr("arc: " | toString(#fs) | " given terms, degrees " | toString apply(fs, f -> if f == 0 then "0" else toString first degree f));
-- Jacobian data
JD = m1JacSetup(F, 6, fs, odir | "jac_" | tag);
Bc = JD#"Bc"; stdI = JD#"std";
if #stdI != 924 then error "std count";
-- order 0 and DP check
lams = {pv};
chk0 = m1Extend(JD, {}, 0, apply(stdI, i -> pv#i), toList(364:0_kk), {}, 6, 5);
pr("DP check order 0 (pi from its values on std monomials): " | toString(chk0 == pv) | " " | tm());
if chk0 != pv then error "DP check failed";
-- AG data
Jk = new HashTable from {1 => map(kk^12, kk^0, 0), 2 => agCoef(Jr, 2), 3 => agCoef(flatten apply(Jr, u -> apply(12, l -> x_l * u)), 3)};
IVJ = new HashTable from apply({1,2,3}, k -> k => (agCoef(flatten entries super basis(k, I), k) | Jk#k));
hx = agIndex 6;
Cs = new MutableHashTable; scan({1,2,3}, k -> Cs#k = {agCat(pv, k, 6, hx)});
agRes = {};
doAG = N -> (
    Ls := new HashTable from apply({1,2,3}, k -> k => agLead(Cs#k, N));
    rep := agReport(Ls, Jk, IVJ, "AG order N=" | toString N);
    agRes = append(agRes, (N, rep));
    odir | "ag_" | tag | "_N" | toString N | ".txt" << toString {N, rep, apply({1,2,3}, k -> entries Ls#k)} << close;
    Ls);
Ls0 = doAG 0;
pr("  generators at t=0, degree 1: " | toString agPolys(Ls0#1, 1));
-- orders
for j from 1 to Nmax do (
    pr("ORDER " | toString j | " " | tm());
    lfile := odir | "lam_" | tag | "_j" | toString j | ".txt"; efile := odir | "eng_" | tag | "_j" | toString j | ".txt";
    if fileExists lfile and fileExists efile then (
        ed := value get efile; fs = apply(ed#2, u -> value u);
        lams = append(lams, value get lfile);
        pr("  resumed order " | toString j | " from checkpoint (lambda_j full, arc terms " | toString(#fs) | ")");
        scan({1,2,3}, k -> Cs#k = append(Cs#k, agCat(last lams, k, 6, hx)));
        doAG j;
        continue);
    ff := fs;
    (lamB, mu) := m1Order(ff, j, Bc, m3);
    if mode == "G" and j == 3 then (
        rest := mu;  -- mu_3 without the f3 term
        c3f := value get("/home/claude/hodge/discovery/checks/so3_t6/t3_G_" | toString sd | "_" | toString p | "_res.txt");
        pr("  mu_3 (no f3) == 5 * SO3-T6 c3: " | toString(rest == 5 * sub(matrix c3f#0, kk)));
        y := transpose(rest * (1_kk/5)) // Pm;
        if Pm * y != transpose(rest * (1_kk/5)) then error "order 3 not solvable";
        f3 := (m3 * sub(y, S))_(0,0);
        fs = append(fs, f3);
        lamB = lamB + (-6) * m1Lev(2, Bc, f3);
        mu = mu + (-5) * m1Lev(1, m3, f3);
        pr("  f3 solved (pi(Q f3) = mu_3'/5), f3 == 0: " | toString(f3 == 0)));
    pr("  mu_" | toString j | " on S_3 (Hodge condition, 0 expected for G and c+): nonzero " | toString(#select(flatten entries mu, v -> v != 0)) | " of 364");
    odir | "eng_" | tag | "_j" | toString j | ".txt" << toString {entries lamB, entries mu, apply(fs, toString)} << close;
    lamF := m1Extend(JD, fs, j, flatten entries lamB, flatten entries mu, lams, 6, 5);
    lams = append(lams, lamF);
    odir | "lam_" | tag | "_j" | toString j | ".txt" << toString lamF << close;
    -- check extension on random R by direct engine evaluation (explicit route)
    if false then (
        Rs := {random(6, S)};
        dv := flatten entries m1Direct(fs, j, Rs);
        ev := apply(Rs, R -> m1Eval(lamF, JD, R));
        pr("  extension check (direct engine on 1 random R): direct " | toString dv | " extended " | toString ev | " AGREE " | toString(dv == ev) | " " | tm()));
    scan({1,2,3}, k -> Cs#k = append(Cs#k, agCat(lamF, k, 6, hx)));
    doAG j;
    if mode == "cp" then (
        -- truncated I_{V_t}: generators q o g_t^(-1)
        bad := 0;
        LamD := apply(lams, v -> sum(#mons6, a -> v#a * mons6#a));
        for q in flatten entries mingens I do (
            qs := cpSub q; kq := first degree q;
            for jj from 0 to j do (
                D := sum(jj + 1, i -> contract(qs#i, LamD#(jj - i)));
                if D != 0 then bad = bad + 1));
        pr("  c+ check: truncated I_{V_t} generators annihilated by pi_t mod t^" | toString(j+1) | ": failures " | toString bad));
    pr("ORDER " | toString j | " done " | tm()));
pr("END " | tag | " " | tm());
