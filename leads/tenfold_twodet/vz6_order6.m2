-- vz6: order 6 along a direction of the 13-dimensional piece at Movasati's point (PREREG_vz.md, section 6).  MOD p.
-- usage (repository root):  M2 --script leads/tenfold_twodet/vz6_order6.m2 p seed lambda [nrandom]
-- Same point, pair and T_1 (case d) as vz5.  Steps: (1) T_2 corrected so that order 5 holds (as vz5);
-- (2) o6 = order-6 obstruction vector with the corrected T_2; (3) its changes under T_2 -> T_2 + k for k in the
-- kernel of the order-5 map D: the 13 net directions tangent to the piece, y_0, and nrandom random elements of
-- ker L made D-free; (4) is o6 in Im D + span of those changes?
needsPackage("HodgeLociCI", FileName => "M2/HodgeLociCI.m2");
pp = value(scriptCommandLine#1); sd = value(scriptCommandLine#2); lam = value(scriptCommandLine#3);
nrand = if #scriptCommandLine > 4 then value(scriptCommandLine#4) else 6;
setRandomSeed sd;
S = fermatRing(3, 10, pp); z = fermatRoot S; kk = coefficientRing S;
L1 = apply(6, i -> {2*i, 2*i+1, 1});
L2 = apply(6, i -> {2*i, 2*i+1, if i < 3 then 3 else 1});
P = fermatPeriodPolynomial(S, L1) + lam * fermatPeriodPolynomial(S, L2);
mons = fermatDeformationMonomials S;
vecOf = T -> matrix(kk, apply(mons, a -> {lift(coefficient(a, T), kk)}));
Lm = fermatFirstOrderMatrix P; La = fermatFirstOrderMatrix fermatPeriodPolynomial(S, L1);
m6 = select(mons, a -> all(toList(6..11), i -> degree(S_i, a) == 0));
V6 = matrix{apply(m6, a -> vecOf a)};
K6 = gens ker(Lm * V6);
y0 = null;
for t from 0 to 20 do (
    c := K6 * random(kk^(numcols K6), kk^1);
    cand := (matrix{m6} * promote(c, S))_(0,0);
    if La * vecOf(cand) != 0 then (y0 = cand; break));
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
gR = rnd(3,3); hR = rnd(3,3); Ns = apply(orth3(), X -> gR * blk(X) * hR);
T1 = y0 + tOf Ns;
tm = cpuTime();
obsAt = (E, n) -> (
    if E#"obstructedAtOrder" === null then return null;
    if E#"obstructedAtOrder" != n then error("obstructed at order " | toString E#"obstructedAtOrder" | ", expected " | toString n);
    lift(E#"obstruction", kk));
E0 = fermatExtendArc(P, {T1}, 5);
T2 = (E0#"arc")#1; o0 = obsAt(E0, 5); nr = numrows o0; zeroCol = map(kk^nr, kk^1, 0);
E3 = (i, j, k) -> (tOf apply(3, kkk -> if kkk == k then matrix(kk, table(3, 3, (a, b) -> if (a, b) == (i, j) then 1 else 0)) else map(kk^3, kk^3, 0)));
dirs = flatten flatten apply(3, k -> apply(3, i -> apply(3, j -> E3(i, j, k))));
col5 = k -> ( E := fermatExtendArc(P, {T1, T2 + k}, 5); o := obsAt(E, 5); (if o === null then zeroCol else o) - o0);
Dm = map(kk^nr, kk^0, 0);
scan(#dirs, i -> Dm = Dm | col5(dirs#i));
<< "p = " << pp << ", seed " << sd << ", lambda = " << lam << " ; order 5: rank D = " << rank Dm << " ; o_5 in Im D: " << (rank(Dm | o0) == rank Dm) << " ; cpu " << cpuTime() - tm << endl << flush;
sol = - (o0 // Dm);
T2c = T2 + sum(#dirs, i -> sol_(i,0) * dirs#i);
Kn = gens ker Dm;                                                              -- 27 x 13: net directions tangent to the piece
<< "tangent net directions (kernel of D on nets): " << numcols Kn << endl << flush;
obs6 = k -> ( E := fermatExtendArc(P, {T1, T2c + k}, 6); o := obsAt(E, 6); if o === null then zeroCol else o);
o6 = obs6(0_S);
<< "RESULT order 6 with the corrected T_2: obstruction vector zero: " << (o6 == 0) << " ; in Im D (removable by T_3 alone): " << (rank(Dm | o6) == rank Dm) << " ; cpu " << cpuTime() - tm << endl << flush;
Bm = Dm;
scan(numcols Kn, j -> (
    k := sum(#dirs, i -> Kn_(i,j) * dirs#i);
    Bm = Bm | (obs6(k) - o6);
    << "  tangent direction " << j + 1 << " of " << numcols Kn << " : rank so far " << rank Bm << " ; o6 in the span: " << (rank(Bm | o6) == rank Bm) << " ; cpu " << cpuTime() - tm << endl << flush));
<< "RESULT after the tangent net directions: rank " << rank Bm << " ; o6 in Im D + span: " << (rank(Bm | o6) == rank Bm) << endl << flush;
Bm = Bm | (obs6(y0) - o6);
<< "  y_0 : rank " << rank Bm << " ; o6 in the span: " << (rank(Bm | o6) == rank Bm) << endl << flush;
KL = gens ker Lm;
scan(nrand, t -> (
    kv := KL * random(kk^(numcols KL), kk^1);
    k := (matrix{mons} * promote(kv, S))_(0,0);
    c := col5 k;                                                               -- make it D-free
    cs := c // Dm;
    k = k - sum(#dirs, i -> cs_(i,0) * dirs#i);
    r0 := rank Bm;
    Bm = Bm | (obs6(k) - o6);
    << "  random D-free element of ker L " << t + 1 << " : rank " << r0 << " -> " << rank Bm << " ; o6 in the span: " << (rank(Bm | o6) == rank Bm) << " ; cpu " << cpuTime() - tm << endl << flush));
<< "RESULT final: rank " << rank Bm << " ; o6 in Im D + span of all tested first-order changes: " << (rank(Bm | o6) == rank Bm) << endl;
<< "DONE cpu " << cpuTime() - tm << endl;
