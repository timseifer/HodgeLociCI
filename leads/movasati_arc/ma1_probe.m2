-- ma1: probe at the EIGHTFOLD Movasati point (PREREG_arc.md, step 1).   MOD p.
-- usage (repository root):  M2 --script leads/movasati_arc/ma1_probe.m2 p seed lambda order [cases]
-- Fermat eightfold, Movasati's pair: P1 = {x_(2i) = z x_(2i+1), all i}, P2 = {x_(2i) = z^3 x_(2i+1) for i < 3,
-- x_(2i) = z x_(2i+1) for i = 3, 4}; P1 n P2 is the line with coordinates x_7, x_9.
-- T_1 = y_0 + sum N_ijk f_i h_j x_(7+2k) modulo squares; cases: a generic net, d generic in the 11-dimensional
-- piece, s the symmetric direction A = E01 + E10, B = E01 - E10, E cone type (A of rank 2, B = 0).
needsPackage("HodgeLociCI", FileName => "M2/HodgeLociCI.m2");
pp = value(scriptCommandLine#1); sd = value(scriptCommandLine#2); lam = value(scriptCommandLine#3); ord = value(scriptCommandLine#4);
cases = if #scriptCommandLine > 5 then scriptCommandLine#5 else "adsE";
setRandomSeed sd;
S = fermatRing(3, 8, pp); z = fermatRoot S; kk = coefficientRing S;
L1 = apply(5, i -> {2*i, 2*i+1, 1});
L2 = apply(5, i -> {2*i, 2*i+1, if i < 3 then 3 else 1});
P = fermatPeriodPolynomial(S, L1) + lam * fermatPeriodPolynomial(S, L2);
mons = fermatDeformationMonomials S;
vecOf = T -> matrix(kk, apply(mons, a -> {lift(coefficient(a, T), kk)}));
Lm = fermatFirstOrderMatrix P; La = fermatFirstOrderMatrix fermatPeriodPolynomial(S, L1); Lb = fermatFirstOrderMatrix fermatPeriodPolynomial(S, L2);
<< "RESULT p = " << pp << ", seed " << sd << ", lambda = " << lam << " ; monomials " << #mons << " ; equations " << numrows Lm << " ; rank L = " << rank Lm << " ; rank [L_P1; L_P2] = " << rank(La || Lb) << endl;
m6 = select(mons, a -> all(toList(6..9), i -> degree(S_i, a) == 0));
V6 = matrix{apply(m6, a -> vecOf a)};
K6 = gens ker(Lm * V6);
<< "squarefree cubics in x_0..x_5: " << #m6 << " ; of them in ker L: " << numcols K6 << " ; in ker L_P1 and ker L_P2: " << numcols gens ker((La || Lb) * V6) << endl;
y0 = null;
for t from 0 to 20 do (
    c := K6 * random(kk^(numcols K6), kk^1);
    cand := (matrix{m6} * promote(c, S))_(0,0);
    if La * vecOf(cand) != 0 then (y0 = cand; break));
if y0 === null then error "no y_0 found";
sq = ideal apply(10, i -> (S_i)^2);
f = apply(3, i -> S_(2*i) - z * S_(2*i+1)); h = apply(3, i -> S_(2*i) - z^3 * S_(2*i+1)); zz = {S_7, S_9};
tOf = Ns -> (sum(2, k -> sum(3, i -> sum(3, j -> (Ns#k)_(i,j) * f#i * h#j * zz#k)))) % sq;
rnd = (m, n) -> random(kk^m, kk^n);
blk = X -> (X | matrix{{0_kk},{0_kk}}) || matrix{{0_kk, 0_kk, 0_kk}};
polar = (X, Y) -> X_(0,0)*Y_(1,1) + X_(1,1)*Y_(0,0) - X_(0,1)*Y_(1,0) - X_(1,0)*Y_(0,1);
orth2 = () -> (
    X := rnd(2, 2); while polar(X, X) == 0 do X = rnd(2, 2);
    Y := rnd(2, 2); Y = polar(X, X) * Y - polar(X, Y) * X; while polar(Y, Y) == 0 do (Y = rnd(2, 2); Y = polar(X, X) * Y - polar(X, Y) * X);
    {X, Y});
RN = kk[w_0, w_1];
onV4 = Ns -> (
    Nw := sum(2, k -> w_k * sub(Ns#k, RN));
    all(flatten entries gens minors(2, Nw), m -> coefficient(w_0*w_1, m) == 0));
E01 = matrix(kk, {{0,1,0},{0,0,0},{0,0,0}}); E10 = matrix(kk, {{0,0,0},{1,0,0},{0,0,0}});
nets = new HashTable from {
    "a" => (() -> {rnd(3,3), rnd(3,3)}, "generic net (rank 3)"),
    "d" => (() -> (g := rnd(3,3); hh := rnd(3,3); apply(orth2(), X -> g * blk(X) * hh)), "11-dimensional piece: common kernel and cokernel, orthogonal blocks (rank 2)"),
    "s" => (() -> {E01 + E10, E01 - E10}, "symmetric direction A = E01 + E10, B = E01 - E10 (in the piece)"),
    "E" => (() -> {rnd(3,2) * rnd(2,3), 0 * rnd(3,3)}, "y_1 C', rank C' = 2 (cone over a sixfold direction)")};
scan(characters cases, ch -> (
    (mk, desc) := nets#ch;
    Ns := mk();
    t := tOf Ns; T1 := y0 + t;
    tm := cpuTime();
    okV := (La * vecOf t == 0) and (Lb * vecOf t == 0);
    E := fermatExtendArc(P, {T1}, ord);
    << "RESULT case " << ch << " [" << desc << "]: net on the model cone: " << onV4 Ns << " ; t in T V: " << okV
       << " ; T_1 in ker L: " << (Lm * vecOf T1 == 0) << " ; arc reached order " << E#"order"
       << " ; obstructed at order " << toString E#"obstructedAtOrder" << " ; cpu " << cpuTime() - tm << endl << flush));
<< "DONE" << endl;
