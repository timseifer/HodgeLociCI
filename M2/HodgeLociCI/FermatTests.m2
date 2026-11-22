-- HodgeLociCI/FermatTests.m2  (owner: agent PB)
-- TEST blocks of item 3 (Fermat-point higher-order expansion). Every test is deterministic and states what is
-- EXACT / MOD p and where the expected values come from. Data files: HodgeLociCI/data/ (copies of the session's
-- exports discovery/t3_window/export_c3 and export_x1; see tests/data/fermat/SOURCES_fermat.md in the repository).

-- Test F1. Period polynomials of linear spaces. EXACT over QQ(zeta_6) and QQ(zeta_8).
-- Sources: (a) P_L = det Jac(f_1,g_1,...) (normalisation of Villaflor Loyola, arXiv:1812.03964; ASSUMED, the test only
-- checks that the product formula equals the determinant); (b) the listing "period polynomial P_delta" at the end of
-- export_c3/cert_n6_lam2.txt (produced by the session's cert.py, re-derived by blind check C3);
-- (c) a pencil of d linear spaces is a complete intersection with X, so its primitive periods vanish.
TEST ///
  jacP = (S, d, L) -> (z := fermatRoot S;
      fg := flatten apply(L, t -> (f := S_(t#0) - z^(t#2)*S_(t#1); {f, ((S_(t#0))^d + (S_(t#1))^d) // f}));
      det jacobian matrix {fg});
  S = fermatRing(3, 6); z = fermatRoot S; use S;
  L1 = {{0,1,1},{2,3,1},{4,5,1},{6,7,1}}; L2 = {{0,1,3},{2,3,3},{4,5,3},{6,7,1}};
  P1 = fermatPeriodPolynomial(S, L1); P2 = fermatPeriodPolynomial(S, L2);
  assert(P1 == jacP(S, 3, L1) and P2 == jacP(S, 3, L2));
  P = P1 + 2*P2;
  -- (b) four of the sixteen coefficients listed in cert_n6_lam2.txt
  assert(coefficient(x_0*x_2*x_4*x_6, P) == -243*z);
  assert(coefficient(x_1*x_3*x_4*x_6, P) == 81 - 162*z);
  assert(coefficient(x_0*x_2*x_4*x_7, P) == 243 - 243*z);
  assert(coefficient(x_1*x_3*x_5*x_7, P) == -243 + 243*z);
  assert(#terms P == 16);
  -- (c) pencils
  assert(sum({1,3,5}, e -> fermatPeriodPolynomial(S, {{0,1,e},{2,3,1},{4,5,3},{6,7,5}})) == 0);
  -- a matching that is not (01)(23)..: the second space of the pair X1 of export_x1 (cubic eightfold)
  S8 = fermatRing(3, 8);
  X2 = {{1,2,3},{3,4,3},{0,5,3},{6,7,1},{8,9,3}};
  assert(fermatPeriodPolynomial(S8, X2) == jacP(S8, 3, X2));
  -- the same space written with pairs reversed (x_b = z^(-e) x_a) and reordered
  assert(fermatPeriodPolynomial(S8, {{9,8,-3},{2,1,3},{3,4,3},{5,0,3},{6,7,1}}) == fermatPeriodPolynomial(S8, X2));
  -- quartic sixfold
  S4 = fermatRing(4, 6);
  M1 = {{0,1,1},{2,3,3},{4,5,5},{6,7,7}};
  assert(fermatPeriodPolynomial(S4, M1) == jacP(S4, 4, M1));
  assert(sum({1,3,5,7}, e -> fermatPeriodPolynomial(S4, {{0,1,e},{2,3,1},{4,5,1},{6,7,1}})) == 0);
  -- ideals: the spaces lie in the Fermat variety
  assert(sum(8, i -> S_i^3) % fermatLinearSpaceIdeal(S, L2) == 0);
  assert(sum(8, i -> S4_i^4) % fermatLinearSpaceIdeal(S4, M1) == 0);
///

-- Test F2. The period functional on monomials: closed form against the literal pole-order reduction and against two
-- INDEPENDENT engines of the session. EXACT.
-- Sources of the hard-coded values: discovery/checks/c3/lib.py (blind check C3, own code written from the README only;
-- Periods.I = literal reduction, run on 22 Nov 2026 for delta = [P1] + 2[P2] on the Fermat cubic sixfold, reduction
-- orders 'first' and 'last' agree); discovery/checks/c18/eng18.py (blind check C18; Eng.series with shift = 1 for the
-- pair X1, lambda = -1, first three terms of export_x1/x1_lam-1_arc.txt).
TEST ///
  S = fermatRing(3, 6); z = fermatRoot S;
  mon = e -> product(#e, i -> S_i^(e#i));
  L1 = {{0,1,1},{2,3,1},{4,5,1},{6,7,1}}; L2 = {{0,1,3},{2,3,3},{4,5,3},{6,7,1}};
  P = fermatPeriodPolynomial(S, L1) + 2*fermatPeriodPolynomial(S, L2);
  -- (exponent vector, pole order, I by c3/lib.py, Psi by c3/lib.py)
  ref = {({0,1,0,1,0,4,0,1}, 5, (-81/2)*z, -162*z),
         ({0,4,1,0,0,1,1,3}, 6, -9/10 + (9/5)*z, -18 + 36*z),
         ({0,4,1,3,3,1,1,0}, 7, -1/20 + (1/10)*z, -6 + 12*z),
         ({0,4,4,3,1,0,3,1}, 8, 1/210 - (1/105)*z, 4 - 8*z)};
  scan(ref, r -> (
      assert(fermatPeriodGD(P, mon r#0, r#1) == r#2);
      assert(fermatPeriodGD(P, mon r#0, r#1, Strategy => "Last") == r#2);
      assert(fermatPeriod(P, mon r#0) == r#3)));
  -- closed form == literal reduction * (k-1)!/(n/2)! on all monomials of a product (pole order 7), both strategies
  use S;
  f = x_0*(x_0*x_1*x_7 + x_0*x_2*x_4 + x_1*x_3*x_5 + x_2*x_5*x_6 + x_3*x_4*x_7 + x_6^2*x_7 + x_5^3 + x_1^2*x_6)^4;
  ms = flatten entries monomials f;
  assert(#ms > 100);
  assert(all(ms, m -> fermatPeriod(P, m) == (6!/3!) * fermatPeriodGD(P, m, 7)));
  assert(all(take(ms, 60), m -> fermatPeriodGD(P, m, 7) == fermatPeriodGD(P, m, 7, Strategy => "Last")));
  assert(any(ms, m -> fermatPeriod(P, m) != 0));
  assert(fermatPeriod(P, f) == sum(terms f, t -> leadCoefficient t * fermatPeriod(P, leadMonomial t)));
  -- eng18 (C18): the series pi_eps(N) = Psi(N exp(T(eps))) for three monomials N of degree 5, coefficients of eps^0..eps^3
  D = fermatReadCertificate(HodgeLociCI#"auxiliary files" | "data/x1_lam-1_arc.txt");
  R = D#"ring"; w = fermatRoot R; Pd = D#"periodPolynomial";
  fs = {R_7*R_8*R_9^3, R_4*R_5*R_9^3, R_2*R_4*R_5*R_7*R_9};
  C = fermatExpansion(Pd, take(D#"arc", 3), 3, Forms => fs);
  assert(C == matrix(coefficientRing R, {{0, 0, -90 + 72*w}, {0, 18 - 9*w, 0}, {0, 0, 24*w}}));
  assert(apply(fs, q -> fermatPeriod(Pd, q)) == {0, 0, -243*w});
///

-- Test F3. Quartic sixfold: the closed form against the session's flc.py, and the "fake linear cycle" as an integer
-- combination of linear spaces. MOD p = 30089 for the values; EXACT over QQ(zeta_8) for the identity and the ranks.
-- Sources: discovery/t1_fake_linear/flc.py, Ctx(30089).phi_mono (run 22 Nov 2026; z8 = 14004, cs = [17552, 14004, 14004,
-- 14004]); its docstring for the fake factor c_1 = zeta8 (3-4i)/5 <-> 3[pt_1] + [pt_2] - 3[pt_4]. The rank 19 is the
-- classical count 35 - 16 (quartic forms on a 3-plane minus the dimension of the Grassmannian G(4,8)).
TEST ///
  S = fermatRing(4, 6, 30089); w = fermatRoot S;
  assert(w == 14004);
  I = w^2; u = (3 - 4*I)/5; cs = {w*u, w, w, w};
  assert(cs#0 == 17552);
  P = product(4, j -> (S_(2*j))^2 + cs#j*S_(2*j)*S_(2*j+1) + (cs#j)^2*(S_(2*j+1))^2);
  mon = e -> product(#e, i -> S_i^(e#i));
  ref = {({0,6,1,1,4,2,1,1}, 2245), ({2,0,5,1,4,6,2,0}, 15135), ({1,1,0,2,4,2,4,2}, 1097), ({0,2,1,1,4,2,1,1}, 13023)};
  assert(all(ref, r -> fermatPeriod(P, mon r#0) == r#1));
  -- exact: 3[L_1] + [L_2] - 3[L_4] has a decomposable period polynomial with first factor c_1 = z(3-4z^2)/5
  T = fermatRing(4, 6); v = fermatRoot T;
  sp = e -> {{0,1,e},{2,3,1},{4,5,1},{6,7,1}};
  Pfake = 3*fermatPeriodPolynomial(T, sp 1) + fermatPeriodPolynomial(T, sp 3) - 3*fermatPeriodPolynomial(T, sp 7);
  c1 = v*(3 - 4*v^2)/5;
  Pdec = product(4, j -> (c := if j == 0 then c1 else v; (T_(2*j))^2 + c*T_(2*j)*T_(2*j+1) + c^2*(T_(2*j+1))^2));
  assert(Pfake == 4*v*(3 + 4*v^2) * (4*v)^3 * Pdec);
  -- first order for a true linear space: codimension 19, with the Jacobian-basis forms (267 of them: 1 of pole order 2,
  -- 266 of pole order 3) and with all 330 quartic monomials of pole order 3
  P1 = fermatPeriodPolynomial(T, sp 1);
  assert(#fermatPeriodForms T == 267 and #fermatPeriodForms(T, AllMonomials => true) == 330);
  L = fermatFirstOrderMatrix P1;
  assert(numrows L == 267 and numcols L == 266 and rank L == 19);
  assert(rank fermatFirstOrderMatrix(P1, Forms => fermatPeriodForms(T, AllMonomials => true)) == 19);
///

-- Test F4. Re-verification of exported certificates of the session, with negative controls. EXACT over QQ(zeta_6).
-- Sources: discovery/t3_window/export_c3/cert_n6_lam2.txt and cert_n8_lam-1.txt (obstruction certificates at Movasati's
-- two points; produced by cert.py, checked blind in discovery/checks/c3). Expected: every claim reproduced.
TEST ///
  dir = HodgeLociCI#"auxiliary files" | "data/";
  D = fermatReadCertificate(dir | "cert_n6_lam2.txt");
  assert(D#"dimension" == 6 and D#"degree" == 3 and D#"vanishingOrder" == 4 and D#"obstructionOrder" == 5);
  assert(#(D#"ignoredLines") == 1);   -- one continuation line of prose
  V = fermatVerifyCertificate D;
  assert(V#"pass" and V#"firstFailingOrder" === null and match("^EXACT over QQ\\(zeta_6\\); COMPUTED ONLY", V#"label"));
  assert(#(V#"checks") == 11 and all(V#"checks", c -> c#1));
  -- the listed value K.c_5 = -3 + 6z, recomputed through fermatNextOrderSystem
  S = D#"ring"; z = fermatRoot S; arc = D#"arc";
  H = fermatNextOrderSystem(D#"periodPolynomial", arc);
  assert(H#"order" == 5 and H#"lowerOrdersVanish" and not H#"solvable");
  assert(numrows H#"cokernel" == 1 and H#"cokernel" * H#"matrix" == 0);
  K0 = H#"cokernel"; lam = (z - 1)/K0_(0,6);
  assert(lam * K0 == matrix {{0,0,0,0,0,0,z-1,1_(coefficientRing S)}});
  assert(lam * (H#"obstruction")_(0,0) == -3 + 6*z);
  -- NEGATIVE CONTROLS: perturbed certificates must fail, at the right order
  perturb = (key, val) -> new HashTable from (pairs D | {(key, val)});
  V2 = fermatVerifyCertificate perturb("arc", {arc#0, arc#1 + (1/1000)*S_0*S_2*S_6, arc#2, arc#3});
  assert(not V2#"pass" and V2#"firstFailingOrder" == 2);
  V4 = fermatVerifyCertificate perturb("arc", {arc#0, arc#1, arc#2, arc#3 + (1/1000)*S_0*S_2*S_4});
  assert(not V4#"pass" and V4#"firstFailingOrder" == 4);
  cl = new MutableHashTable from D#"obstructionCoefficients"; cl#(S_6) = cl#(S_6) + 1/7;
  V5 = fermatVerifyCertificate perturb("obstructionCoefficients", new HashTable from cl);
  assert(not V5#"pass" and V5#"firstFailingOrder" == 5);
  fn = first D#"functionals";
  V6 = fermatVerifyCertificate perturb("functionals", {{{{S_6, z - 1}, {S_5, 1_(coefficientRing S)}}, fn#1}});
  assert(not V6#"pass" and V6#"firstFailingOrder" == 5);
  -- wrong class: the same arc for lambda = 3 fails at once
  Pw = fermatPeriodPolynomial(S, D#"spaces"#0) + 3*fermatPeriodPolynomial(S, D#"spaces"#1);
  assert((fermatVerifyArc(Pw, arc))#"firstFailingOrder" == 1);
  -- cubic eightfold certificate
  V8 = fermatVerifyCertificate(dir | "cert_n8_lam-1.txt");
  assert(V8#"pass" and V8#"vanishingOrder" == 3 and V8#"obstructionOrder" == 4 and #(V8#"checks") == 11);
///

-- Test F5. The arc of export_x1 for lambda = -1 to order 7 and the obstruction file for lambda = 2 (cubic eightfold,
-- pair X1), with a negative control; the sparse arc six_lam-1_arc.txt to order 9. EXACT over QQ(zeta_6); the order-9
-- arc is also run MOD p = 32749.
-- Sources: discovery/t3_window/export_x1/ (x1_lam-1_arc.txt, x1_lam2_obstruction.txt, six_lam-1_arc.txt; checked blind in
-- discovery/checks/c11 and c18). Expected: all 45 period functions vanish to order 7 (resp. 9); Lambda.c_5 = 1 + z.
TEST ///
  dir = HodgeLociCI#"auxiliary files" | "data/";
  D = fermatReadCertificate(dir | "x1_lam-1_arc.txt");
  assert(#(D#"arc") == 7 and D#"vanishingOrder" == 7 and D#"obstructionOrder" === null and #(D#"forms") == 45);
  V = fermatVerifyCertificate D;
  assert(V#"pass" and V#"firstFailingOrder" === null and match("^EXACT over QQ\\(zeta_6\\); COMPUTED ONLY", V#"label"));
  -- negative control: T_5 changed by 1/1000 of a monomial -> first failing order 5
  S = D#"ring"; arc = D#"arc";
  bad = apply(7, j -> if j == 4 then arc#j + (1/1000)*S_0*S_6*S_8 else arc#j);
  H = fermatVerifyArc(D#"periodPolynomial", bad);
  assert(not H#"pass" and H#"firstFailingOrder" == 5);
  -- obstruction at lambda = 2
  W = fermatVerifyCertificate(dir | "x1_lam2_obstruction.txt");
  assert(W#"pass" and W#"vanishingOrder" == 4 and W#"obstructionOrder" == 5);
  D2 = fermatReadCertificate(dir | "x1_lam2_obstruction.txt");
  assert((first D2#"functionals")#1 == 1 + fermatRoot(D2#"ring"));
  -- order 9, exact and mod p
  V9 = fermatVerifyCertificate(dir | "six_lam-1_arc.txt");
  assert(V9#"pass" and V9#"vanishingOrder" == 9);
  V9p = fermatVerifyCertificate(dir | "six_lam-1_arc.txt", Prime => 32749);
  assert(V9p#"pass" and match("^MOD p = 32749 .*evidence, not a proof.*; COMPUTED ONLY", V9p#"label"));
///

-- Test F6. Tangent spaces at the Fermat point for the two Movasati points and for single linear spaces. EXACT.
-- Sources: export_c3/README.txt ("rank L = 7 against rank [L_P1; L_P2] = 8 for NV = 8; 19 against 20 for NV = 10");
-- these are the pairs (H,K) of Table 1 of Movasati, arXiv:1602.06607, as recorded in tests/SOURCES.md.
-- Classical counts for one linear space: cubic sixfold 20 - 16 = 4, cubic eightfold 35 - 25 = 10, cubic fourfold
-- 10 - 9 = 1 (cubic fourfolds containing a plane form a divisor), quartic surface 5 - 4 = 1 (quartics with a line).
-- The period computation (ranks of first-order maps) and the ideal computation ((I(L)+Jac F0)_d) are independent.
TEST ///
  S = fermatRing(3, 6);
  L1 = {{0,1,1},{2,3,1},{4,5,1},{6,7,1}}; L2 = {{0,1,3},{2,3,3},{4,5,3},{6,7,1}};
  H = fermatTangentData(S, {L1, L2}, {1, 2});
  assert(H#"ambientDimension" == 120 and H#"hodgeCodimension" == 7 and H#"jointPeriodCodimension" == 8);
  assert(H#"jointPersistenceCodimension" == 8 and H#"excess" == 1);
  assert(H#"singleHodgeCodimensions" == {4, 4} and H#"persistenceCodimensions" == {4, 4});
  -- the same for other coefficients, including the control lambda = 1 of the session
  assert(all({1, -1, 5/3}, lam -> (fermatTangentData(S, {L1, L2}, {1, lam}))#"hodgeCodimension" == 7));
  -- bases: Hodge tangent space of one space == persistence tangent space, dimension 116 = 120 - 4
  B = fermatHodgeTangent fermatPeriodPolynomial(S, L1);
  assert(numcols B == 116 and image B == image fermatPersistenceTangent(S, {L1}));
  assert(numcols fermatPersistenceTangent(S, {L1, L2}) == 112);
  -- the Hodge tangent space of the combination contains the joint persistence space with codimension 1
  Bd = fermatHodgeTangent(fermatPeriodPolynomial(S, L1) + 2*fermatPeriodPolynomial(S, L2));
  assert(numcols Bd == 113 and isSubset(image fermatPersistenceTangent(S, {L1, L2}), image Bd));
  -- rank of the first-order matrix by the package's row reduction agrees with Macaulay2's rank
  Lm = fermatFirstOrderMatrix(fermatPeriodPolynomial(S, L1) + 2*fermatPeriodPolynomial(S, L2));
  assert(numrows Lm == 8 and numcols Lm == 56 and rank Lm == 7);
  -- cubic eightfold
  S8 = fermatRing(3, 8);
  M1 = {{0,1,1},{2,3,1},{4,5,1},{6,7,1},{8,9,1}}; M2 = {{0,1,1},{2,3,1},{4,5,3},{6,7,3},{8,9,3}};
  H8 = fermatTangentData(S8, {M1, M2}, {1, 2});
  assert(H8#"ambientDimension" == 220 and H8#"hodgeCodimension" == 19 and H8#"jointPeriodCodimension" == 20);
  assert(H8#"jointPersistenceCodimension" == 20 and H8#"excess" == 1);
  assert(H8#"singleHodgeCodimensions" == {10, 10} and H8#"persistenceCodimensions" == {10, 10});
  -- small classical cases
  S34 = fermatRing(3, 4);
  assert((fermatTangentData(S34, {{{0,1,1},{2,3,1},{4,5,1}}}, {1}))#"hodgeCodimension" == 1);
  S42 = fermatRing(4, 2);
  H42 = fermatTangentData(S42, {{{0,1,1},{2,3,1}}}, {1});
  assert(H42#"hodgeCodimension" == 1 and H42#"persistenceCodimensions" == {1});
///

-- Test F7. Order-by-order extension, parameters, mod p against exact, and the file format. EXACT and MOD p.
-- Sources: export_c3/README.txt (control: "at lambda = 1 the same construction gives c_N in the image of L");
-- cert_n6_lam2.txt for the obstruction at order 5. The extension at lambda = 1 is COMPUTED here (order 7).
TEST ///
  dir = HodgeLociCI#"auxiliary files" | "data/";
  D = fermatReadCertificate(dir | "cert_n6_lam2.txt");
  S = D#"ring"; z = fermatRoot S; arc = D#"arc"; P = D#"periodPolynomial";
  -- from T_1 alone: order 4 is reached, order 5 is obstructed
  E = fermatExtendArc(P, {arc#0}, 6);
  assert(E#"order" == 4 and E#"obstructedAtOrder" == 5 and E#"obstruction" != 0);
  assert((fermatVerifyArc(P, E#"arc"))#"pass");
  -- control lambda = 1: the same T_1 recipe (excess part + w) extends; here to order 7
  P1 = fermatPeriodPolynomial(S, D#"spaces"#0) + fermatPeriodPolynomial(S, D#"spaces"#1);
  w = D#"extra"#"tangentPart";
  B = fermatHodgeTangent P1;
  LP1 = fermatFirstOrderMatrix fermatPeriodPolynomial(S, D#"spaces"#0);
  sqf = fermatDeformationMonomials S;
  ex = first select(flatten entries B, t -> LP1 * transpose matrix {apply(sqf, a -> coefficient(a, t))} != 0);
  E1 = fermatExtendArc(P1, {ex + w}, 7);
  assert(E1#"order" == 7 and E1#"obstructedAtOrder" === null);
  assert((fermatVerifyArc(P1, E1#"arc"))#"pass");
  -- a given arc that does not satisfy the equations is refused
  assert(try (fermatExtendArc(P, {arc#0, arc#1 + S_0*S_2*S_6}, 3); false) else true);
  -- write, read back, verify (round trip of the text format)
  f = temporaryFileName() | ".txt";
  fermatWriteCertificate(f, hashTable {"ring" => S, "spaces" => D#"spaces", "coefficients" => {1, 1}, "arc" => E1#"arc"});
  D1 = fermatReadCertificate f;
  assert(D1#"vanishingOrder" == 7 and #(D1#"ignoredLines") == 0);
  assert((fermatVerifyCertificate D1)#"pass");
  assert((fermatVerifyCertificate(f, Prime => 32749))#"pass");
  -- round trip of the session certificate itself, including the obstruction part
  f2 = temporaryFileName() | ".txt";
  fermatWriteCertificate(f2, D);
  V2 = fermatVerifyCertificate f2;
  assert(V2#"pass" and V2#"obstructionOrder" == 5);
  -- MOD p against EXACT: the coefficients of eps^5 of the certificate, reduced at z -> root mod p
  Dp = fermatReadCertificate(dir | "cert_n6_lam2.txt", Prime => 32749);
  Sp = Dp#"ring"; zp = fermatRoot Sp;
  Cp = fermatExpansion(Dp#"periodPolynomial", Dp#"arc", 5);
  C = fermatExpansion(P, arc, 5);
  assert(Cp_{0,1,2,3} == 0 and C_{0,1,2,3} == 0);
  q = (a, b) -> a_(coefficientRing Sp) / b_(coefficientRing Sp);
  -- the eight values c_5[x_i] listed in the file, written in ZZ/p with the root zp
  listed = {q(82,9) - q(26,9)*zp, -q(20,9) - q(8,9)*zp, q(82,9) - q(26,9)*zp, -q(20,9) - q(8,9)*zp,
            q(37,9) - q(29,9)*zp, q(10,9) + q(79,9)*zp, -3*zp, -6 + 6*zp};
  assert(flatten entries Cp_{4} == listed);
  assert(flatten entries C_{4} == {82/9 - (26/9)*z, -20/9 - (8/9)*z, 82/9 - (26/9)*z, -20/9 - (8/9)*z, 37/9 - (29/9)*z, 10/9 + (79/9)*z, -3*z, -6 + 6*z});
  -- PARAMETERS: T_2 moved by s*w (w in the kernel of L); the result is polynomial in s and specialises correctly
  St = fermatRing(3, 6, Parameters => {symbol s}); zt = fermatRoot St; use St;
  Pt = fermatPeriodPolynomial(St, D#"spaces"#0) + 2*fermatPeriodPolynomial(St, D#"spaces"#1);
  wt = x_0*x_1*x_7 + x_2*x_3*x_7 + x_4*x_5*x_7;
  U1 = wt + (1/3+(1/3)*zt)*x_0*x_2*x_4 + x_0*x_2*x_5;
  U2 = (-1/9-(1/9)*zt)*x_0*x_2*x_6 + (-5/9+(1/9)*zt)*x_0*x_3*x_6 + (-1/9+(2/9)*zt)*x_0*x_4*x_6 + (-2/9+(1/9)*zt)*x_0*x_5*x_6 + (-1/9+(2/9)*zt)*x_2*x_4*x_6 + (-2/9+(1/9)*zt)*x_2*x_5*x_6;
  Ct = fermatExpansion(Pt, {U1, U2 + s*wt}, 3);
  assert(Ct_{0,1} == 0);
  assert(sub(Ct, s => 0) == 0);                      -- the certificate has T_3 = 0 and c_3 = 0
  -- specialisation at s = 2 agrees with the direct computation with the number 2 (which is not zero at order 3)
  C2 = fermatExpansion(Pt, {U1, U2 + 2*wt}, 3);
  assert(sub(Ct, s => 2) == C2 and C2_{2} != 0);
  -- order 3 is solvable for every s, with a solution polynomial in s
  Ht = fermatNextOrderSystem(Pt, {U1, U2 + s*wt});
  assert(Ht#"order" == 3 and Ht#"lowerOrdersVanish" and Ht#"solvable" and Ht#"obstruction" == 0);
  assert((fermatVerifyArc(Pt, {U1, U2 + s*wt, Ht#"solution"}))#"pass");
  -- the higher-order system: orders 3, 4 are solved polynomially in s; the order-5 obstruction K.c_5(s) is the
  -- constant -3 + 6z of the certificate, independent of s (COMPUTED here; compare claim 4 of x1_lam2_obstruction.txt)
  E5 = fermatExtendArc(Pt, {U1, U2 + s*wt}, 6);
  assert(E5#"order" == 4 and E5#"obstructedAtOrder" == 5);
  assert(numrows E5#"obstruction" == 1 and (E5#"obstruction")_(0,0) == 6*zt - 3);
  assert(any(E5#"arc", t -> member(s, support t)));
///

-- Test F8. Quartic sixfold, order by order. MOD p = 30089 (the prime of the session's quartic computations).
-- No external source for the numbers: this is an internal consistency test (COMPUTED): an arc built with the
-- Jacobian-basis forms (pole orders 2 and 3) also annihilates all 330 monomial forms of pole order 3 to the same order,
-- as it must because both families span the same piece of the Hodge filtration near the Fermat point.
TEST ///
  S = fermatRing(4, 6, 30089);
  L = {{0,1,1},{2,3,1},{4,5,1},{6,7,1}};
  P = fermatPeriodPolynomial(S, L);
  B = fermatHodgeTangent P;
  assert(numcols B == 330 - 19);
  -- a tangent direction outside the Jacobian ideal, with few terms
  J = ideal apply(8, i -> S_i^3);
  cand = select(flatten entries B, t -> t % J != 0);
  T1 = cand#0 + cand#5 + 2*cand#17;
  E = fermatExtendArc(P, {T1}, 3);
  assert(E#"order" == 3 and E#"obstructedAtOrder" === null);
  allQ = fermatPeriodForms(S, AllMonomials => true);
  assert((fermatVerifyArc(P, E#"arc", 3, Forms => allQ))#"pass");
  -- negative control in both conventions
  bad = {T1, E#"arc"#1 + S_0^2*S_2*S_4, E#"arc"#2};
  assert((fermatVerifyArc(P, bad))#"firstFailingOrder" == 2);
  assert((fermatVerifyArc(P, bad, 3, Forms => allQ))#"firstFailingOrder" == 2);
///

-- Test F9. Input validation: clear errors instead of wrong answers.
TEST ///
  fails = f -> try (f(); false) else true;
  assert fails(() -> fermatRing(3, 5));                 -- odd dimension
  assert fails(() -> fermatRing(1, 6));                 -- degree < 2
  assert fails(() -> fermatRing(3, 6, 32003));          -- 32003 is not 1 mod 6
  assert fails(() -> fermatRing(3, 6, 91));             -- not a prime
  S = fermatRing(3, 6); use S;
  assert fails(() -> fermatPeriodPolynomial(S, {{0,1,1},{2,3,1},{4,5,1}}));           -- too few pairs
  assert fails(() -> fermatPeriodPolynomial(S, {{0,1,1},{2,3,1},{4,5,1},{6,6,1}}));   -- not a matching
  assert fails(() -> fermatPeriodPolynomial(S, {{0,1,2},{2,3,1},{4,5,1},{6,7,1}}));   -- even exponent
  assert fails(() -> fermatLinearSpaceIdeal(QQ[a,b], {{0,1,1}}));                     -- not a fermatRing
  P = fermatPeriodPolynomial(S, {{0,1,1},{2,3,1},{4,5,1},{6,7,1}});
  assert fails(() -> fermatExpansion(P, {x_0*x_1}, 2));                  -- arc term of the wrong degree
  assert fails(() -> fermatExpansion(P, {x_0*x_1*x_2}, 0));              -- order < 1
  assert fails(() -> fermatExpansion(P, {x_0*x_1*x_2}, 2, Forms => {x_0*x_1}));   -- form of an impossible degree
  assert fails(() -> fermatExpansion(P, {x_0*x_1*x_2}, 2, Forms => {x_0 + x_1})); -- not a monomial
  assert fails(() -> fermatExpansion(x_0*x_1*x_2, {x_0*x_1*x_2}, 2));    -- not a period polynomial (degree 3, not 4)
  assert fails(() -> fermatPeriodGD(P, x_0^2, 5));                       -- wrong degree for the pole order
  assert fails(() -> fermatFirstOrderMatrix(P, Monomials => {x_0*x_1}));
  assert fails(() -> fermatReadCertificate "/nonexistent/file.txt");
  assert fails(() -> fermatTangentData(S, {{{0,1,1},{2,3,1},{4,5,1},{6,7,1}}}, {1, 2}));
  St = fermatRing(3, 6, Parameters => {symbol s});
  assert fails(() -> fermatHodgeTangent fermatPeriodPolynomial(St, {{0,1,1},{2,3,1},{4,5,1},{6,7,1}}));
  -- zero class and zero arc are legitimate
  use S;
  assert(fermatExpansion(P - P, {x_0*x_1*x_2}, 2) == 0);
  assert((fermatVerifyArc(P, {0_S, 0_S}))#"pass");
///

-- Test F10. Cross-check of item 3 against item 1 of this package (agent PA's code: periodPolynomial and
-- hodgeLocusTangentCodim, which work at any smooth point by Jacobian-ring computations and do not use the closed
-- forms at Fermat). MOD p = 32749 for the codimensions, EXACT for the period polynomials.
-- Expected: the same period polynomial and the same tangent codimension 4, 10, 19 for one linear space in the Fermat
-- cubic sixfold, cubic eightfold, quartic sixfold (classical counts 20 - 16, 35 - 25, 35 - 16).
TEST ///
  cross = (S, d, L) -> (
      z := fermatRoot S; nv := numgens S;
      phi := apply(L, t -> S_(t#0) - z^(t#2)*S_(t#1));
      psi := apply(#L, j -> ((S_(L#j#0))^d + (S_(L#j#1))^d) // phi#j);
      assert(periodPolynomial(phi, psi) == fermatPeriodPolynomial(S, L));
      F := sum(nv, i -> S_i^d);
      r := hodgeLocusTangentCodim(F, fermatLinearSpaceIdeal(S, L));
      t := fermatTangentData(S, {L}, {1});
      assert(r#"codim" == t#"hodgeCodimension" and r#"codim" == (t#"persistenceCodimensions")#0);
      r#"codim");
  assert(cross(fermatRing(3, 6, 32749), 3, {{0,1,1},{2,3,1},{4,5,3},{6,7,5}}) == 4);
  assert(cross(fermatRing(3, 8, 32749), 3, {{1,2,3},{3,4,3},{0,5,3},{6,7,1},{8,9,3}}) == 10);
  assert(cross(fermatRing(4, 6, 30089), 4, {{0,1,1},{2,3,3},{4,5,5},{6,7,7}}) == 19);
  -- exact period polynomials
  S = fermatRing(3, 6); z = fermatRoot S; L = {{0,1,1},{2,3,1},{4,5,3},{6,7,5}};
  phi = apply(L, t -> S_(t#0) - z^(t#2)*S_(t#1));
  psi = apply(#L, j -> ((S_(L#j#0))^3 + (S_(L#j#1))^3) // phi#j);
  assert(periodPolynomial(phi, psi) == fermatPeriodPolynomial(S, L));
///
