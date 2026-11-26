-- C1(a) via the PACKAGE function fermatExpansion (not my own implementation)
needsPackage("HodgeLociCI", FileName => "/home/claude/hodgelocici/M2/HodgeLociCI.m2");
S = fermatRing(3, 6);
z = fermatRoot S;
use S;
L1 = {{0,1,1},{2,3,1},{4,5,1},{6,7,1}};
L2 = {{1,2,3},{3,4,3},{0,5,3},{6,7,3}};
P = fermatPeriodPolynomial(S, L1) - fermatPeriodPolynomial(S, L2);
ls = select(lines get "/home/claude/hodgelocici/leads/tenfold_twodet/matrices/arc_true_order19.txt", l -> #l > 0 and l#0 != "#");
arc = apply(ls, l -> value l);
<< "number of arc terms " << #arc << endl;
N = 19;
tt = elapsedTiming (M = fermatExpansion(P, arc, N));
<< "time " << tt#0 << endl;
<< "rows " << numrows M << " cols " << numcols M << endl;
<< "matrix zero: " << (M == 0) << endl;
<< "columns zero: " << apply(N, c -> M_{c} == 0) << endl;
-- sanity: perturb T_19 and T_5 and see that the matrix is no longer zero
arc2 = apply(#arc, i -> if i == 18 then arc#i + x_0*x_1*x_3 else arc#i);
M2x = fermatExpansion(P, arc2, N);
<< "perturbed T_19: columns zero: " << apply(N, c -> M2x_{c} == 0) << endl;
