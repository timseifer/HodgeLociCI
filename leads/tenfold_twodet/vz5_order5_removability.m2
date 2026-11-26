-- vz5: is the order-5 obstruction along a direction of the 13-dimensional piece removable by a change of T_2?
-- (PREREG_vz.md, section 4, P6a / P6b).   MOD p.
-- usage (repository root):  M2 --script leads/tenfold_twodet/vz5_order5_removability.m2 p seed lambda [case]
--   case: one letter as in vz4 (default d).  Same Fermat point, pair and T_1 construction as vz4.
needsPackage("HodgeLociCI", FileName => "M2/HodgeLociCI.m2");
pp = value(scriptCommandLine#1); sd = value(scriptCommandLine#2); lam = value(scriptCommandLine#3);
cs = if #scriptCommandLine > 4 then scriptCommandLine#4 else "d";
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
mkNet = c -> (
    if c == "d" then (g := rnd(3,3); hh := rnd(3,3); return apply(orth3(), X -> g * blk(X) * hh));
    if c == "c" then (u := rnd(3,1); return {u * rnd(1,3), u * rnd(1,3), u * rnd(1,3)});
    if c == "E" then return {rnd(3,2) * rnd(2,3), 0 * rnd(3,3), 0 * rnd(3,3)};
    error "case must be d, c or E");
Ns = mkNet cs;
T1 = y0 + tOf Ns;
obsVec = E -> (
    if E#"obstructedAtOrder" === null then return null;
    if E#"obstructedAtOrder" != 5 then error("obstructed at order " | toString E#"obstructedAtOrder");
    o := E#"obstruction"; lift(o, kk));
tm = cpuTime();
E0 = fermatExtendArc(P, {T1}, 5);
<< "p = " << pp << ", seed " << sd << ", lambda = " << lam << ", case " << cs << " ; base run: reached order " << E0#"order" << " ; obstructed at order "
   << toString E0#"obstructedAtOrder" << " ; cpu " << cpuTime() - tm << endl << flush;
if E0#"obstructedAtOrder" === null then (print "RESULT order 5 passes with the package's own lower terms"; exit 0);
T2 = (E0#"arc")#1; o0 = obsVec E0; nr = numrows o0;
zeroCol = map(kk^nr, kk^1, 0);
E3 = (i, j, k) -> (tOf apply(3, kkk -> if kkk == k then matrix(kk, table(3, 3, (a, b) -> if (a, b) == (i, j) then 1 else 0)) else map(kk^3, kk^3, 0)));
dirs = flatten flatten apply(3, k -> apply(3, i -> apply(3, j -> E3(i, j, k))));
col = k -> (
    E := fermatExtendArc(P, {T1, T2 + k}, 5);
    o := obsVec E;
    (if o === null then zeroCol else o) - o0);
Dm = map(kk^nr, kk^0, 0);
scan(#dirs, i -> (Dm = Dm | col(dirs#i); if i % 9 == 8 then << "  " << i + 1 << " of 27 net directions done ; rank so far " << rank Dm << " ; cpu " << cpuTime() - tm << endl << flush));
<< "RESULT obstruction space: " << nr << " ; rank of the image of the 27 net directions: " << rank Dm << " ; rank with o_0 adjoined: " << rank(Dm | o0)
   << " ; removable at order 5: " << (rank(Dm | o0) == rank Dm) << endl << flush;
-- control: random elements of ker L give nothing new
KL = gens ker Lm;
scan(3, t -> (
    kv := KL * random(kk^(numcols KL), kk^1);
    k := (matrix{mons} * promote(kv, S))_(0,0);
    c := col k;
    << "control, random element of ker L: its column lies in the span of the 27: " << (rank(Dm | c) == rank Dm) << endl << flush));
-- if removable: the corrected T_2 and one more check
if rank(Dm | o0) == rank Dm then (
    sol := - (o0 // Dm);
    k := sum(#dirs, i -> sol_(i,0) * dirs#i);
    E := fermatExtendArc(P, {T1, T2 + k}, 6);
    << "RESULT with the corrected T_2: reached order " << E#"order" << " ; obstructed at order " << toString E#"obstructedAtOrder" << endl);
<< "DONE cpu " << cpuTime() - tm << endl;
