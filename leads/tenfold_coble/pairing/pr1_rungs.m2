-- R1 of PREREG_pairing.md: node counts on the sixfold and eightfold rungs, coefficients +1 and -1.
-- AI-written, unreviewed.  usage (from this folder):  M2 --script pr1_rungs.m2 p seed
-- Uses tooling/node_section/NodeSection.m2 (nodalSectionReport).  Every number is MOD p, for the random instance of the seed.
load "../../../tooling/node_section/NodeSection.m2";
pp = value(scriptCommandLine#1); sd = value(scriptCommandLine#2); kk = ZZ/pp; setRandomSeed sd;
showRes = (nm, r) -> (<< "RESULT " << nm << ": dim Sing " << r#"singularLocusDim" << ", points " << r#"singularPoints" << ", all ODP "
    << r#"allOrdinaryDoublePoints" << ", form degree " << r#"formDegree" << ", conditions " << r#"conditions" << ", defect " << r#"defect"
    << ", Hilbert function of the nodes " << toString r#"hilbertFunctionOfNodes" << "  [" << r#"label" << "]" << endl << flush);
skew6 = R -> ( Lf := new MutableHashTable; scan(6, i -> scan(6, j -> if i < j then Lf#(i,j) = random(1, R)));
    matrix table(6, 6, (i,j) -> if i < j then Lf#(i,j) else if i > j then -Lf#(j,i) else 0_R));
hs = (v, l) -> v#0^3+v#1^3+v#2^3 + 3*l*v#0*v#1*v#2;
-- a random Coble cubic in the normal form of the lead note (section 2): a h(z) + h(p) + h(q) + M_x(z,p,q), 27 (1 + lam^3) a + h_lam(x) = 0
R9 = kk[z_0..z_2, p_0..p_2, q_0..q_2];
cobleCubic = () -> ( lam := random kk; xx := apply(3, i -> random kk);
    a0 := - hs(xx, lam) / (27 * (1 + lam^3));
    zz := {z_0,z_1,z_2}; ps := {p_0,p_1,p_2}; qs := {q_0,q_1,q_2};
    a0 * hs(zz, lam) + hs(ps, lam) + hs(qs, lam) + sum flatten apply(3, i -> apply(3, j -> zz#((i+j)%3) * xx#((i-j)%3) * ps#i * qs#j)));
FC = cobleCubic();
IsC = saturate ideal jacobian matrix{{FC}};
<< "Coble cubic of this seed: singular locus of dim " << dim IsC - 1 << ", degree " << degree IsC << ", Hilbert polynomial "
   << toString hilbertPolynomial(IsC, Projective => false) << endl << flush;

-- (a) sixfold, +1: l*Q + Pf(M)
S = kk[x_0..x_7];
F = x_7 * random(2, S) + (gens pfaffians(6, skew6 S))_(0,0);
smoothX = G -> (dim ideal leadTerm groebnerBasis(ideal jacobian matrix{{G}}, Strategy => "F4") == 0);
<< "(a) the sixfold is smooth: " << smoothX F << endl << flush;
showRes("(a) sixfold +1, l*Q + Pf, section l=0", nodalSectionReport(F, x_7));

-- (b) eightfold, +1: X n P^7 Pfaffian
U = kk[u_0..u_7]; S = kk[u_0..u_7, t_1, t_2]; inc = map(S, U, (vars S)_{0..7});
-- (one statement on one line: in Macaulay2 a line that starts with "+" is a new statement; the first version of this
--  script lost the terms of degree 2 in t that way, the eightfold was singular along the line u = 0 and the section
--  showed a 29th singular point; log kept in logs/first_version/)
F = inc((gens pfaffians(6, skew6 U))_(0,0)) + t_1 * inc random(2, U) + t_2 * inc random(2, U) + t_1^2 * random(1, S) + t_1 * t_2 * random(1, S) + t_2^2 * random(1, S);
smoothX = G -> (dim ideal leadTerm groebnerBasis(ideal jacobian matrix{{G}}, Strategy => "F4") == 0);
<< "(b) the eightfold is smooth: " << smoothX F << endl << flush;
<< "(b) singular locus of X n P^7: " << (J := saturate ideal jacobian matrix{{sub(F, {t_1 => 0, t_2 => 0})}} + ideal(t_1, t_2); (dim J - 1, degree J, genus J)) << " (dim, degree, genus)" << endl;
showRes("(b) eightfold +1, P^7-section Pfaffian, hyperplane through it", nodalSectionReport(F, t_2 - random(kk) * t_1));

-- (c) sixfold, -1: a hyperplane section equal to (Coble cubic) n P^6
S = kk[y_0..y_6, t]; U = kk[y_0..y_6];
par = map(U, R9, apply(9, i -> random(1, U))); inc = map(S, U, (vars S)_{0..6});
F = inc par FC + t * random(2, S);
<< "(c) the sixfold is smooth: " << smoothX F << endl << flush;
showRes("(c) sixfold -1, hyperplane section = Coble n P^6", nodalSectionReport(F, t));

-- (d) eightfold, -1: X n P^7 = (Coble cubic) n P^7
U = kk[u_0..u_7]; S = kk[u_0..u_7, t_1, t_2]; inc = map(S, U, (vars S)_{0..7});
par = map(U, R9, apply(9, i -> random(1, U)));
G = par FC;
<< "(d) singular locus of Coble n P^7: " << (J = saturate ideal jacobian matrix{{G}}; (dim J - 1, degree J, genus J)) << " (dim, degree, genus)" << endl;
F = inc G + t_1 * inc random(2, U) + t_2 * inc random(2, U) + t_1^2 * random(1, S) + t_1 * t_2 * random(1, S) + t_2^2 * random(1, S);
<< "(d) the eightfold is smooth: " << smoothX F << endl << flush;
showRes("(d) eightfold -1, P^7-section = Coble n P^7, hyperplane through it", nodalSectionReport(F, t_2 - random(kk) * t_1));

-- (e) eightfold, -1, the registry's family l*Q + det A + det B
S = kk[x_0..x_9];
A = matrix table(3, 3, (i,j) -> random(1, S)); B = matrix table(3, 3, (i,j) -> random(1, S));
F = x_9 * random(2, S) + det A + det B;
Iseg = ideal(x_9) + minors(2, A) + minors(2, B);
<< "(e) the two Segre fourfolds in l = 0 meet in a scheme of dim " << dim Iseg - 1 << ", degree " << degree Iseg << endl;
<< "(e) the eightfold is smooth: " << smoothX F << endl << flush;
r = nodalSectionReport(F, x_9);
showRes("(e) eightfold -1, l*Q + det A + det B, section l=0", r);
Jsec = saturate(ideal(x_9) + ideal jacobian matrix{{sub(F, x_9 => 0)}});
<< "(e) singular scheme of the section equals the intersection of the two Segre fourfolds: " << (Jsec == saturate Iseg) << endl;
<< "DONE p " << pp << " seed " << sd << endl;
