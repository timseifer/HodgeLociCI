-- mx0: exact Taylor coefficients (orders 0..9) of the periods of all quartic monomials for the class P1 - P2 along
-- T2's sixfold arc (file six_lam-1_arc.txt read in the variables x0..x5, x8, x9).  EXACT over QQ(zeta_6).
-- usage (repository root): M2 --script leads/tenfold_twodet/matrices/mx0_export_periods.m2 outfile [arcfile N]
--   without arcfile: the exported certificate arc, order 9 (its terms T_8, T_9 are NOT on the extendable arc);
--   with arcfile (written by mx3_extend_arc.m2) and N: the first N terms of that file, expansion to order N.
needsPackage("HodgeLociCI", FileName => "M2/HodgeLociCI.m2");
D = fermatReadCertificate("M2/HodgeLociCI/data/six_lam-1_arc.txt");
S8 = D#"ring"; arc8 = D#"arc";
S = fermatRing(3, 6); z = fermatRoot S; K = coefficientRing S;
phi = map(S, S8, {S_0, S_1, S_2, S_3, S_4, S_5, 0, 0, S_6, S_7});
arc = apply(arc8, T -> phi T);
NN = 9;
if #scriptCommandLine > 3 then (
    prev := select(lines get scriptCommandLine#2, l -> #l > 0 and l#0 != "#");
    NN = value(scriptCommandLine#3);
    use S;
    arc = apply(take(prev, NN), l -> value replace("z", "(fermatRoot S)", replace("x_", "S_", l))));
<< "arc terms: " << #arc << " ; order " << NN << endl << flush;
L1 = {{0,1,1},{2,3,1},{4,5,1},{6,7,1}};
L2 = {{1,2,3},{3,4,3},{0,5,3},{6,7,3}};
P = fermatPeriodPolynomial(S, L1) - fermatPeriodPolynomial(S, L2);
forms = flatten entries basis(4, S);
tm = cpuTime();
E = fermatExpansion(P, arc, NN, Forms => forms);
<< "expansion: " << numrows E << " x " << numcols E << " ; cpu " << cpuTime() - tm << endl;
c0 = apply(forms, Q -> fermatPeriod(P, Q));
k0 = coefficientRing K; kz = ambient k0;
ab = c -> ( f := lift(lift(lift(c, K), k0), kz); (toString coefficient(1_kz, f), toString coefficient(kz_0, f)) );
out = openOut(scriptCommandLine#1);
out << "# form exponents (8 integers) ; then for orders 0..N: a b  (value a + b*z, z = zeta_6)" << endl;
scan(#forms, i -> (
    out << toString first exponents forms#i << " ;";
    (a, b) := ab(c0#i); out << " " << a << " " << b << " ;";
    scan(numcols E, j -> ( (a, b) = ab(E_(i,j)); out << " " << a << " " << b << " ;"));
    out << endl));
close out;
<< "written " << #forms << " forms" << endl;
