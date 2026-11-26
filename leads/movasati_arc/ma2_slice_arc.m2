-- ma2: the arc in a transversal monomial slice at the EIGHTFOLD Movasati point (PREREG_arc.md, step 2).   MOD p.
-- usage (repository root):  M2 --script leads/movasati_arc/ma2_slice_arc.m2 p seed lambda N case [sliceSeed] [outfile]
-- Same point, pair, y_0 and nets as ma1_probe.m2 (same seed gives the same T_1).  T_n (n >= 2) is taken in the span
-- of 19 monomials (dependent part) and 7 net directions (free part); when order n is not solvable, the free part of
-- T_(n-3) is corrected with the 26 x 7 matrix D.
needsPackage("HodgeLociCI", FileName => "M2/HodgeLociCI.m2");
pp = value(scriptCommandLine#1); sd = value(scriptCommandLine#2); lam = value(scriptCommandLine#3); Nmax = value(scriptCommandLine#4);
cs = scriptCommandLine#5;
ssd = if #scriptCommandLine > 6 then value(scriptCommandLine#6) else 1;
outf = if #scriptCommandLine > 7 then scriptCommandLine#7 else null;
setRandomSeed sd;
S = fermatRing(3, 8, pp); z = fermatRoot S; kk = coefficientRing S;
L1 = apply(5, i -> {2*i, 2*i+1, 1});
L2 = apply(5, i -> {2*i, 2*i+1, if i < 3 then 3 else 1});
P = fermatPeriodPolynomial(S, L1) + lam * fermatPeriodPolynomial(S, L2);
mons = fermatDeformationMonomials S;
vecOf = T -> matrix(kk, apply(mons, a -> {lift(coefficient(a, T), kk)}));
Lm = fermatFirstOrderMatrix P; La = fermatFirstOrderMatrix fermatPeriodPolynomial(S, L1);
m6 = select(mons, a -> all(toList(6..9), i -> degree(S_i, a) == 0));
V6 = matrix{apply(m6, a -> vecOf a)};
K6 = gens ker(Lm * V6);
y0 = null;
for t from 0 to 20 do (
    c := K6 * random(kk^(numcols K6), kk^1);
    cand := (matrix{m6} * promote(c, S))_(0,0);
    if La * vecOf(cand) != 0 then (y0 = cand; break));
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
E01 = matrix(kk, {{0,1,0},{0,0,0},{0,0,0}}); E10 = matrix(kk, {{0,0,0},{1,0,0},{0,0,0}});
-- the nets are drawn in the same order as in ma1_probe.m2 with cases "dsE", so that the same seed gives the same T_1
netD = (g := rnd(3,3); hh := rnd(3,3); apply(orth2(), X -> g * blk(X) * hh));
netS = {E01 + E10, E01 - E10};
netE = {rnd(3,2) * rnd(2,3), 0 * rnd(3,3)};
Ns = if cs == "d" then netD else if cs == "s" then netS else if cs == "E" then netE else error "case: d, s or E";
T1 = y0 + tOf Ns;
<< "p = " << pp << ", seed " << sd << ", lambda = " << lam << ", case " << cs << " ; rank L = " << rank Lm << " ; T_1 in ker L: " << (Lm * vecOf T1 == 0) << " ; not in ker L_P1: " << (La * vecOf T1 != 0) << endl;
-- the slice
setRandomSeed(1000 + ssd);
-- the slice: T_1, 19 monomials with independent columns of L (greedy over a shuffled list; the dependent part of
-- each T_n is then unique), and 7 net directions f_i h_j x_(7+2k) chosen below so that D is injective on them
sh = random mons;
U = {}; LU = map(kk^(numrows Lm), kk^0, 0);
scan(sh, a -> if #U < 19 then ( M := LU | (Lm * vecOf a); if rank M > rank LU then (U = append(U, a); LU = M)));
if #U != 19 then error "no 19 independent columns";
E3 = (i, j, k) -> (tOf apply(2, kkk -> if kkk == k then matrix(kk, table(3, 3, (a, b) -> if (a, b) == (i, j) then 1 else 0)) else map(kk^3, kk^3, 0)));
netIdx = flatten flatten apply(2, k -> apply(3, i -> apply(3, j -> (i, j, k))));
netDirs = apply(netIdx, t -> E3 t);                                   -- 18 cubics tangent to V
<< "slice seed " << ssd << " : 19 monomials with independent columns of L ; 18 net directions in ker L: " << all(netDirs, t -> Lm * vecOf t == 0) << endl << flush;
taus = null;                                                          -- chosen at the first obstruction
nos = Ts -> fermatNextOrderSystem(P, Ts, Monomials => U);
tm = cpuTime();
-- extend Ts by k orders with the package's solutions; returns (list, null) or (list so far, system at the stop)
extendArc = (Ts, k) -> (
    cur := Ts;
    for i from 1 to k do ( sy := nos cur; if not sy#"solvable" then return (cur, sy); cur = append(cur, sy#"solution"));
    (cur, null));
-- change T_(n-3) by tau, re-extend orders n-2, n-1; returns (terms, obstruction at order n, system at order n)
respond = (Ts, n, tau) -> (
    base := take(Ts, n - 4) | {Ts#(n-4) + tau};
    (cur, st) := extendArc(base, 2);
    if st =!= null then error("re-extension not solvable at order " | toString(#cur + 1));
    sy := nos cur;
    (cur, lift(sy#"obstruction", kk), sy));
Dm = null; stat = "reached"; stopOrder = null; pick = null;
Ts = {T1};
-- state file: the choice of free directions, D, and the terms found so far (so that a run can be continued)
saveState = () -> if outf =!= null then (
    fo := openOut outf;
    fo << "# p = " << pp << " seed " << sd << " slice " << ssd << " lambda " << lam << " case " << cs << " ; line 2: free net directions ; line 3: D ; then T_1.. one per line" << endl;
    fo << toString pick << endl << (if Dm === null then "null" else toString entries Dm) << endl;
    scan(Ts, T -> fo << toString T << endl); close fo);
if outf =!= null and fileExists outf then (
    ll := select(lines get outf, l -> #l > 0 and l#0 != "#");
    use S;
    pick = value ll#0;
    if ll#1 != "null" then Dm = matrix(kk, value ll#1);
    Ts = apply(drop(ll, 2), l -> value l);
    if Ts#0 != T1 then error "the state file belongs to another T_1";
    if pick =!= null then taus = apply(pick, i -> netDirs#i);
    << "  continued from " << outf << " : " << #Ts << " terms, D " << (if Dm === null then "not yet measured" else "read") << endl << flush);
while #Ts < Nmax do (
    n := #Ts + 1;
    sy := nos Ts;
    if sy#"solvable" then ( Ts = append(Ts, sy#"solution"); saveState(); << "  order " << n << " solvable ; cpu " << cpuTime() - tm << endl << flush; continue);
    o := lift(sy#"obstruction", kk);
    if n < 5 then ( stat = "obstructed (no earlier free term to correct)"; stopOrder = n; break);
    if taus === null then (
        D18 := matrix{apply(netDirs, t -> (respond(Ts, n, t))#1 - o)};
        r18 := rank D18;
        << "  order " << n << " : D on the 18 net directions: rank " << r18 << " (7 = 18 - 11 expected) ; D(y_0) = 0: " << ((respond(Ts, n, y0))#1 - o == 0) << " ; cpu " << cpuTime() - tm << endl << flush;
        ord18 := random toList(0..17); pick = {}; Mx := map(kk^(numrows D18), kk^0, 0);
        scan(ord18, i -> if #pick < r18 then ( M2x := Mx | D18_{i}; if rank M2x > rank Mx then (pick = append(pick, i); Mx = M2x)));
        taus = apply(pick, i -> netDirs#i);
        << "  free directions of the slice: the net directions " << toString apply(pick, i -> netIdx#i) << endl << flush);
    if Dm === null then (
        Dm = matrix{apply(taus, tau -> (respond(Ts, n, tau))#1 - o)};
        cc := random(kk^(#taus), kk^1);
        lin := (respond(Ts, n, sum(#taus, i -> cc_(i,0) * taus#i)))#1 - o;
        << "  order " << n << " : D on the slice: " << numrows Dm << " x " << numcols Dm << ", rank " << rank Dm << " ; linear on a random combination: " << (lin == Dm * cc) << endl << flush);
    Dn := Dm;
    if rank Dn < #taus then ( stat = "slice not transversal (rank D < 7)"; stopOrder = n; break);
    if rank(Dn | o) > rank Dn then ( stat = "OBSTRUCTED: the obstruction is not in Im D"; stopOrder = n; break);
    x := - (o // Dn);
    tau := sum(#taus, i -> x_(i,0) * taus#i);
    (cur, onew, sy2) := respond(Ts, n, tau);
    if onew != 0 then (
        -- D is measured once (it was found equal at orders 5 and 6); if the correction fails, measure it at this order
        Dn = matrix{apply(taus, tau -> (respond(Ts, n, tau))#1 - o)};
        << "  order " << n << " : correction with the stored D failed; D measured at this order, equal to the stored one: " << (Dn == Dm) << " ; rank " << rank Dn << endl << flush;
        if rank(Dn | o) > rank Dn then ( stat = "OBSTRUCTED: the obstruction is not in Im D (D measured at this order)"; stopOrder = n; break);
        x = - (o // Dn); tau = sum(#taus, i -> x_(i,0) * taus#i);
        (cur, onew, sy2) = respond(Ts, n, tau);
        if onew != 0 then ( stat = "correction did not remove the obstruction"; stopOrder = n; break));
    Ts = append(cur, sy2#"solution");
    saveState();
    << "  order " << n << " : obstruction in Im D, removed by the free part of T_" << n - 3 << " ; cpu " << cpuTime() - tm << endl << flush);
<< "RESULT p = " << pp << ", seed " << sd << ", slice " << ssd << ", lambda = " << lam << ", case " << cs << " : arc of " << #Ts << " terms ; status: " << stat << (if stopOrder =!= null then " at order " | toString stopOrder else "") << " ; cpu " << cpuTime() - tm << endl << flush;
v = fermatVerifyArc(P, Ts);
<< "RESULT fermatVerifyArc on the " << #Ts << " terms: pass " << v#"pass" << " ; first failing order " << toString v#"firstFailingOrder" << " ; forms " << numrows Lm << endl;
<< "RESULT T_1 leaves V (not in ker L_P1): " << (La * vecOf T1 != 0) << " ; number of free directions " << (if taus === null then "not needed" else toString(#taus)) << endl;
saveState();
<< "DONE cpu " << cpuTime() - tm << endl;
