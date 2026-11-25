-- CS-T6 type F. usage: M2 --script f1.m2 seed p mode   (mode a: X random in F_T; mode b: X containing V u J(Pi,P'))
pr = s -> (stderr << s << endl << flush);
sd = value scriptCommandLine#1; p = value scriptCommandLine#2; mode = scriptCommandLine#3;
kk = ZZ/p; S = kk[x_0..x_11]; setRandomSeed(sd);
load "/home/claude/hodge/discovery/checks/w1/w1lib.m2";
IV = trim w1cycle("J2T");
pr("V: dim " | toString(dim IV - 1) | " deg " | toString degree IV);
m3 = basis(3, S); L3 = flatten entries m3; cf = M -> lift(last coefficients(M, Monomials => m3), kk);
B6 = basis(6, S); mons = flatten entries B6; idx = new MutableHashTable; scan(#mons, i -> idx#(mons#i) = i);
funcs = (F, I) -> (
    IJ := ideal gens gb (I + ideal jacobian matrix{{F}});
    bt := lift(basis(6, S/IJ), S); m := numColumns bt;
    C := lift(last coefficients(B6 % IJ, Monomials => bt), kk);
    (m, apply(m, j -> flatten entries C^{j}), dim IJ));
pairing = v -> matrix table(#L3, #L3, (i,j) -> v_(idx#(L3#i * L3#j)));
if mode == "a" then (
    F = (super basis(3, IV) * random(kk^(numColumns super basis(3, IV)), kk^1))_(0,0);
    (m, rows, dIJ) = funcs(F, IV);
    pr("dim(I_V+J) = " | toString dIJ | " (0: X smooth along V); m = codim (I_V+J)_6 = " | toString m);
    PV = pairing(rows#0); pr("codim T NL([V]) = " | toString rank PV);
    (c0, c1, h0) = w1codimP8(F, IV);
    -- rank of (T F_T).S_3 + J_6 inside S_6 via normal form: equivalently check pi_V kills T F_T . S_3
    TF = cf(matrix{w1TFpolys}); pr("rank T F_T = " | toString rank TF);
    pr("pi_V(T F_T . S_3) = 0: " | toString(PV * TF == 0));
    pr("RESULT F-a seed " | toString sd | " p " | toString p | ": m = " | toString m | ", codim T NL = " | toString rank PV | ", codim F_T = " | toString c1 | " (Hom_0 " | toString h0 | ")");
    ) else (
    Pw = ideal random(S^1, S^{6:-1});   -- random 5-plane, disjoint from V
    pr("P1: dim " | toString(dim Pw - 1) | "; dim(V n P1) = " | toString(dim(IV + Pw) - 1));
    T6 = kk[t_0..t_5]; Mp = random(kk^12, kk^6); par = map(T6, S, flatten entries (matrix{gens T6} * transpose Mp));
    Pw = ideal(vars S * sub(gens ker transpose Mp, S));
    pr("P1 check: " | toString(par(Pw) == 0) | ", dim " | toString(dim Pw - 1) | "; dim(V n P1) = " | toString(dim(IV + Pw) - 1));
    BV = super basis(3, IV); m3T = basis(3, T6);
    Cnd = lift(last coefficients(par BV, Monomials => m3T), kk);
    KB = gens ker Cnd; pr("h0 I_(VuP1)(3) = " | toString numColumns KB);
    F = (BV * KB * random(kk^(numColumns KB), kk^1))_(0,0);
    (mV, rV, dV) = funcs(F, IV); (mP, rP, dP) = funcs(F, Pw);
    pr("smooth along V: " | toString(dV == 0) | ", along P1: " | toString(dP == 0) | "; m_V = " | toString mV | ", m_P1 = " | toString mP);
    PV = pairing(rV#0); PP = pairing(rP#0);
    pr("codim T NL(V) = " | toString rank PV | ", T NL(P1) = " | toString rank PP | ", T NL(V) n T NL(P1) = " | toString rank(PV || PP));
    s = random kk; Ps = pairing(rV#0 + s * rP#0); pr("codim T NL(V + s P1), random s = " | toString rank Ps);
    (d0, d1, g0) = w1codimP8(F, IV); TFT = cf(matrix{w1TFpolys});
    lp = flatten entries gens Pw; gco = F // gens Pw;
    TP = cf(matrix{flatten entries super basis(3, Pw) | flatten apply(6, i -> apply(12, j -> S_j * gco_(i,0))) | flatten entries ((jacobian matrix{{F}}) * vars S)});
    rA = rank TFT; rB = rank TP; rAB = rank(TFT | TP); dimInt = rA + rB - rAB;
    pr("dim T F_T = " | toString rA | ", dim T F_P1 = " | toString rB | ", family(V u P1) tangent = intersection, codim " | toString(364 - dimInt));
    pr("RESULT F-b seed " | toString sd | " p " | toString p | ": m_V " | toString mV | " m_P1 " | toString mP | "; family(V u P1) codim " | toString(364 - dimInt) | ", F_T codim here " | toString d1 | ", T NL(V) " | toString rank PV | ", T NL(P1) " | toString rank PP | ", joint " | toString rank(PV || PP) | ", V+sP1 " | toString rank Ps);
    );
