-- vz1: the cone arc on the Fermat tenfold (PREREG_vz.md, predictions P1 and P2).
-- Run from the repository root:  M2 --script leads/tenfold_twodet/vz1_fermat_cone_arc.m2 [first]
--   (argument "first" also runs fermatTangentData; that part is slower)
-- The arc is T3's export M2/HodgeLociCI/data/six_lam-1_arc.txt: an arc at the eightfold pair X1 in the variables
-- x0..x5, x8, x9 only. Here it is read as an arc of cubic tenfolds: Fermat_10 - (eps T_1 + ... + eps^9 T_9).
needsPackage("HodgeLociCI", FileName => "M2/HodgeLociCI.m2");
D = fermatReadCertificate("M2/HodgeLociCI/data/six_lam-1_arc.txt");
S8 = D#"ring"; arc8 = D#"arc";
S = fermatRing(3, 10); z = fermatRoot S;
phi = map(S, S8, apply(10, i -> S_i));
arc = apply(arc8, T -> phi T);
L1 = {{0,1,1},{2,3,1},{4,5,1},{6,7,1},{8,9,1},{10,11,1}};
L2 = {{1,2,3},{3,4,3},{0,5,3},{6,7,1},{8,9,3},{10,11,1}};
<< "pair on the Fermat tenfold: P1 = " << toString L1 << " ; P2 = " << toString L2 << endl;
I1 = fermatLinearSpaceIdeal(S, L1); I2 = fermatLinearSpaceIdeal(S, L2);
<< "dim of P1 n P2 (projective): " << dim(I1 + I2) - 1 << endl;
P = fermatPeriodPolynomial(S, L1) - fermatPeriodPolynomial(S, L2);
t0 = cpuTime();
v = fermatVerifyArc(P, arc, 9);
<< "RESULT P2 arc: pass " << v#"pass" << " ; first failing order " << toString v#"firstFailingOrder" << " ; order " << v#"order"
   << " ; forms " << v#"numberOfForms" << " ; " << v#"label" << endl;
<< "cpu " << cpuTime() - t0 << endl;
-- control: the same arc for the class P1 + P2 must fail
t0 = cpuTime();
Pp = fermatPeriodPolynomial(S, L1) + fermatPeriodPolynomial(S, L2);
vp = fermatVerifyArc(Pp, arc, 9);
<< "RESULT control P1 + P2: pass " << vp#"pass" << " ; first failing order " << toString vp#"firstFailingOrder" << endl;
-- T_1 against the first-order maps
Lm = fermatFirstOrderMatrix P; mons = fermatDeformationMonomials S;
K = coefficientRing S;
vecOf = T -> matrix(K, apply(mons, a -> {lift(coefficient(a, T), K)}));
La = fermatFirstOrderMatrix fermatPeriodPolynomial(S, L1);
<< "RESULT T_1 in ker L: " << (Lm * vecOf(arc#0) == 0) << " ; T_1 in ker L_P1: " << (La * vecOf(arc#0) == 0) << endl;
<< "RESULT rank L (first-order codimension of the Hodge locus of P1 - P2): " << rank Lm << " of " << numcols Lm << " monomials" << endl;
<< "RESULT rank L for P1 + P2: " << rank fermatFirstOrderMatrix Pp << endl;
<< "RESULT rank [L_P1; L_P2]: " << rank(La || fermatFirstOrderMatrix fermatPeriodPolynomial(S, L2)) << endl;
if #scriptCommandLine > 1 and scriptCommandLine#1 == "first" then (
    t0 = cpuTime();
    t = fermatTangentData(S, {L1, L2}, {1, -1});
    << "RESULT P1 first order: Hodge codimension " << t#"hodgeCodimension" << " ; joint persistence codimension " << t#"jointPersistenceCodimension"
       << " ; excess " << t#"excess" << " ; " << t#"label" << endl;
    << "cpu " << cpuTime() - t0 << endl);
