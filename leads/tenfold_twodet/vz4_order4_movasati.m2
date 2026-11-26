-- vz4: order 4 at the tenfold Movasati point along chosen directions (PREREG_vz.md, prediction P5).   MOD p.
-- usage (repository root):  M2 --script leads/tenfold_twodet/vz4_order4_movasati.m2 p seed lambda order [cases]
--   lambda: the class is [P1] + lambda [P2] (integer); order: highest order asked of fermatExtendArc (4 for P5);
--   cases: a string of letters among a b c C d D e E (default: all)
-- Fermat tenfold, Movasati's pair: P1 = {x_(2i) = z x_(2i+1), all i}, P2 = {x_(2i) = z^3 x_(2i+1) for i < 3,
-- x_(2i) = z x_(2i+1) for i >= 3}; Pi = P1 n P2 has coordinates x_7, x_9, x_11.
-- T_1 = y_0 + sum_(i,j,k) N_ijk f_i h_j x_(7+2k), f_i = x_(2i) - z x_(2i+1), h_i = x_(2i) - z^3 x_(2i+1),
-- reduced modulo the squares x_i^2 (the Jacobian ideal of the Fermat cubic); y_0 a cubic in x_0..x_5 in ker L and
-- not in ker L_P1. The second summand is tangent to V_Z (it changes M only) and its net is N.
needsPackage("HodgeLociCI", FileName => "M2/HodgeLociCI.m2");
pp = value(scriptCommandLine#1); sd = value(scriptCommandLine#2); lam = value(scriptCommandLine#3); ord = value(scriptCommandLine#4);
cases = if #scriptCommandLine > 5 then scriptCommandLine#5 else "abcCdDeE";
setRandomSeed sd;
S = fermatRing(3, 10, pp); z = fermatRoot S; kk = coefficientRing S;
L1 = apply(6, i -> {2*i, 2*i+1, 1});
L2 = apply(6, i -> {2*i, 2*i+1, if i < 3 then 3 else 1});
P = fermatPeriodPolynomial(S, L1) + lam * fermatPeriodPolynomial(S, L2);
mons = fermatDeformationMonomials S;
vecOf = T -> matrix(kk, apply(mons, a -> {lift(coefficient(a, T), kk)}));
Lm = fermatFirstOrderMatrix P; La = fermatFirstOrderMatrix fermatPeriodPolynomial(S, L1); Lb = fermatFirstOrderMatrix fermatPeriodPolynomial(S, L2);
<< "p = " << pp << ", seed " << sd << ", lambda = " << lam << " ; rank L = " << rank Lm << " ; rank [L_P1; L_P2] = " << rank(La || Lb) << endl;
-- y_0: a combination of the squarefree cubics in x_0..x_5 that lies in ker L and not in ker L_P1
m6 = select(mons, a -> all(toList(6..11), i -> degree(S_i, a) == 0));
V6 = matrix{apply(m6, a -> vecOf a)};          -- 220 x 20
K6 = gens ker(Lm * V6);
<< "squarefree cubics in x_0..x_5: " << #m6 << " ; of them in ker L: " << numcols K6 << " ; in ker L_P1 and ker L_P2: " << numcols gens ker((La || Lb) * V6) << endl;
y0 = null;
for t from 0 to 20 do (
    c := K6 * random(kk^(numcols K6), kk^1);
    cand := (matrix{m6} * promote(c, S))_(0,0);
    if La * vecOf(cand) != 0 then (y0 = cand; break));
if y0 === null then error "no y_0 found";
sq = ideal apply(12, i -> (S_i)^2);
f = apply(3, i -> S_(2*i) - z * S_(2*i+1)); h = apply(3, i -> S_(2*i) - z^3 * S_(2*i+1)); zz = {S_7, S_9, S_11};
tOf = Ns -> (sum(3, k -> sum(3, i -> sum(3, j -> (Ns#k)_(i,j) * f#i * h#j * zz#k)))) % sq;
rnd = (m, n) -> random(kk^m, kk^n);
blk = X -> (X | matrix{{0_kk},{0_kk}}) || matrix{{0_kk, 0_kk, 0_kk}};
polar = (X, Y) -> X_(0,0)*Y_(1,1) + X_(1,1)*Y_(0,0) - X_(0,1)*Y_(1,0) - X_(1,0)*Y_(0,1);
orth3 = () -> (
    X := rnd(2, 2); while polar(X, X) == 0 do X = rnd(2, 2);
    Y := rnd(2, 2); Y = polar(X, X) * Y - polar(X, Y) * X; while polar(Y, Y) == 0 do (Y = rnd(2, 2); Y = polar(X, X) * Y - polar(X, Y) * X);
    Z := rnd(2, 2); Z = polar(X, X) * Z - polar(X, Z) * X; Z = polar(Y, Y) * Z - polar(Y, Z) * Y;
    {X, Y, Z});
-- the 27 model quadrics, evaluated on a net
RN = kk[w_0..w_2];
onV4 = Ns -> (
    Nw := sum(3, k -> w_k * sub(Ns#k, RN));
    all(flatten entries gens minors(2, Nw), m -> all({w_0*w_1, w_0*w_2, w_1*w_2}, mm -> coefficient(mm, m) == 0)));
nets = new HashTable from {
    "a" => (() -> {rnd(3,3), rnd(3,3), rnd(3,3)}, "generic net (rank 3)"),
    "b" => (() -> (g := rnd(3,2); {g * rnd(2,3), g * rnd(2,3), g * rnd(2,3)}), "generic net with a common cokernel vector (rank 2)"),
    "c" => (() -> (u := rnd(3,1); {u * rnd(1,3), u * rnd(1,3), u * rnd(1,3)}), "Segre cone, common column vector (rank 1)"),
    "C" => (() -> (v := rnd(1,3); {rnd(3,1) * v, rnd(3,1) * v, rnd(3,1) * v}), "Segre cone, common row vector (rank 1)"),
    "d" => (() -> (g := rnd(3,3); hh := rnd(3,3); apply(orth3(), X -> g * blk(X) * hh)), "13-dimensional piece: common kernel and cokernel, orthogonal blocks (rank 2)"),
    "D" => (() -> (g := rnd(3,3); hh := rnd(3,3); apply(orth3(), X -> g * blk(X) * hh)), "13-dimensional piece, second sample"),
    "e" => (() -> {rnd(3,3), 0 * rnd(3,3), 0 * rnd(3,3)}, "z_0 C', C' invertible (rank 3)"),
    "E" => (() -> {rnd(3,2) * rnd(2,3), 0 * rnd(3,3), 0 * rnd(3,3)}, "z_0 C', rank C' = 2 (cone-type direction)")};
scan(characters cases, ch -> (
    (mk, desc) := nets#ch;
    Ns := mk();
    t := tOf Ns; T1 := y0 + t;
    tm := cpuTime();
    okV := (La * vecOf t == 0) and (Lb * vecOf t == 0);
    E := fermatExtendArc(P, {T1}, ord);
    << "RESULT case " << ch << " [" << desc << "]: net on V_4: " << onV4 Ns << " ; t in T V_Z: " << okV
       << " ; T_1 in ker L: " << (Lm * vecOf T1 == 0) << " ; arc reached order " << E#"order"
       << " ; obstructed at order " << toString E#"obstructedAtOrder" << " ; cpu " << cpuTime() - tm << endl << flush));
<< "DONE" << endl;
