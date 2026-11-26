-- mx3b: the extended arc passes the period test to order 19, and its terms T_8, T_9 differ from those of the
-- exported certificate six_lam-1_arc.txt.   EXACT over QQ(zeta_6).
-- usage (repository root): M2 --script leads/tenfold_twodet/matrices/mx3b_verify_arc.m2
needsPackage("HodgeLociCI", FileName => "M2/HodgeLociCI.m2");
D = fermatReadCertificate("M2/HodgeLociCI/data/six_lam-1_arc.txt");
S8 = D#"ring"; arc8 = D#"arc";
S = fermatRing(3, 6); z = fermatRoot S;
phi = map(S, S8, {S_0, S_1, S_2, S_3, S_4, S_5, 0, 0, S_6, S_7});
old = apply(arc8, T -> phi T);
prev = select(lines get "leads/tenfold_twodet/matrices/arc_true_order19.txt", l -> #l > 0 and l#0 != "#");
use S;
arc = apply(prev, l -> value replace("z", "(fermatRoot S)", replace("x_", "S_", l)));
<< "RESULT terms " << #arc << endl;
<< "RESULT first seven terms equal to the certificate's: " << all(7, i -> arc#i == old#i) << endl;
<< "RESULT T_8 equal: " << (arc#7 == old#7) << " ; T_9 equal: " << (arc#8 == old#8) << endl;
<< "RESULT monomials of the arc: " << toString sort unique flatten apply(arc, T -> flatten entries monomials T) << endl;
<< "RESULT coefficient of x_2*x_4*x_6: in T_1: " << toString coefficient(S_2*S_4*S_6, arc#0) << " ; in the later terms all zero: " << all(toList(1..#arc-1), i -> coefficient(S_2*S_4*S_6, arc#i) == 0) << endl;
L1 = {{0,1,1},{2,3,1},{4,5,1},{6,7,1}};
L2 = {{1,2,3},{3,4,3},{0,5,3},{6,7,3}};
P = fermatPeriodPolynomial(S, L1) - fermatPeriodPolynomial(S, L2);
tm = cpuTime();
E = fermatExpansion(P, arc, 19);
<< "RESULT expansion " << numrows E << " x " << numcols E << " is zero: " << (E == 0) << " ; cpu " << cpuTime() - tm << endl;
E9 = fermatExpansion(P, old, 9);
<< "RESULT the certificate arc: expansion to order 9 is zero: " << (E9 == 0) << endl;
