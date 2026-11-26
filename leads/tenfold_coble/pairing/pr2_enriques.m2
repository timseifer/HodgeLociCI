-- R2 of PREREG_pairing.md: an Enriques surface of degree 16 in P^8 as the singular locus of a cubic sevenfold.
-- AI-written, unreviewed.  usage (from this folder):  M2 --script pr2_enriques.m2 p seed
-- X, Y symmetric 3 x 3; P^11 = P(Sym^2 + Sym^2); the P^8 is the graph of three random linear forms (b_3, b_4, b_5 in terms
-- of the other nine coordinates).  S = {rank X <= 1, rank Y <= 1} n P^8 is the quotient of the K3 surface
-- {q_i(x) + q'_i(y) = 0} in P^5 by (x, y) -> (x, -y), embedded by the invariant quadrics.  Every number is MOD p.
load "../../../tooling/node_section/NodeSection.m2";
pp = value(scriptCommandLine#1); sd = value(scriptCommandLine#2); kk = ZZ/pp; setRandomSeed sd;
R = kk[a_0..a_5, b_0..b_2];
ell = apply(3, i -> random(1, R));
symm = v -> matrix{{v#0, v#1, v#2}, {v#1, v#3, v#4}, {v#2, v#4, v#5}};
X = symm {a_0, a_1, a_2, a_3, a_4, a_5}; Y = symm {b_0, b_1, b_2, ell#0, ell#1, ell#2};
IS = minors(2, X) + minors(2, Y);
<< "E1: S: dim " << dim IS - 1 << ", degree " << degree IS << ", Hilbert polynomial " << toString hilbertPolynomial(IS, Projective => false)
   << " ; Hilbert function in degrees 0..5: " << toString apply(6, j -> hilbertFunction(j, R/IS)) << " (8 n^2 + 1: " << toString apply(6, j -> 8*j^2+1) << ")"
   << " ; saturated: " << (saturate IS == IS) << endl << flush;
-- the K3 double cover and its involution
P5 = kk[x_0..x_2, y_0..y_2];
mon = v -> {v#0^2, v#0*v#1, v#0*v#2, v#1^2, v#1*v#2, v#2^2};
xm = mon {x_0,x_1,x_2}; ym = mon {y_0,y_1,y_2};
toK = map(P5, R, xm | take(ym, 3));
IK = ideal apply(3, i -> ym#(3+i) - toK ell#i);
singK = IK + minors(3, jacobian IK);
<< "E1: K3 cover {q_i(x) + q'_i(y) = 0}: dim " << dim IK - 1 << ", degree " << degree IK << ", smooth: " << (dim singK <= 0)
   << " ; no point with y = 0: " << (dim(IK + ideal(y_0,y_1,y_2)) <= 0) << " ; no point with x = 0: " << (dim(IK + ideal(x_0,x_1,x_2)) <= 0) << endl << flush;
-- Smoothness of S: the map (x, y) -> (x x^T, y y^T) from P^5 minus {x = 0} u {y = 0} to the join of the two Veronese
-- surfaces is an etale double cover of the smooth part of the join, and the K3 surface is the preimage of S; so S is
-- smooth because the K3 surface is smooth and has no point with x = 0 or y = 0 (ARG).  A direct check (rank of the
-- Jacobian of 8 random combinations of the 12 quadrics) did not finish in 12 minutes and is run only with a third
-- argument "full".
if #scriptCommandLine > 3 then (
    gS := gens IS; cmb := gS * random(kk^(numColumns gS), kk^8);
    tm = cpuTime(); mJ := minors(6, jacobian cmb);
    << "E1: S smooth (Jacobian of 8 random combinations of the quadrics has rank 6 at every point): " << (dim(IS + mJ) <= 0) << " ; cpu " << cpuTime() - tm << endl << flush);
-- E2: the cubics singular along S
B3 = super basis(3, IS); nb = numColumns B3;
m2 = basis(2, R);
rows = apply(9, i -> ( D := diff(R_i, B3) % IS; (coefficients(D, Monomials => m2))#1 ));
Mat = lift(fold((u, v) -> u || v, rows), kk);
Ker = gens ker Mat;
cubs = flatten entries (B3 * sub(Ker, R));
<< "E2: cubics containing S: " << nb << " (165 - 73 = 92) ; cubics singular along S: " << numColumns Ker << endl;
dX = det X; dY = det Y;
inSpan = f -> ( cf := (coefficients(matrix{cubs | {f}}, Monomials => basis(3, R)))#1; rank lift(cf, kk) == numColumns Ker );
<< "E2: det X and det Y are singular along S: " << (((jacobian matrix{{dX}}) | (jacobian matrix{{dY}})) % IS == 0)
   << " ; they span the space of such cubics: " << (inSpan dX and inSpan dY and numColumns Ker == 2) << endl << flush;
-- E3: a general member of the pencil
c = random kk; G = dX + c * dY;
tm = cpuTime(); Jsat = saturate ideal jacobian matrix{{G}};
<< "E3: Y_c = {det X + c det Y = 0}, c = " << c << ": saturation of the Jacobian ideal equals I_S: " << (Jsat == IS) << " ; cpu " << cpuTime() - tm << endl << flush;
-- E4: a tenfold through Y_c and the nodes of a hyperplane section through the P^8
T = kk[a_0..a_5, b_0..b_2, w_0..w_2]; inc = map(T, R, (vars T)_{0..8});
Psi = apply(3, k -> random(2, R));
F = inc G + sum(3, k -> T_(9+k) * inc Psi#k) + sum flatten apply(3, k -> apply(3, l -> T_(9+k) * T_(9+l) * random(1, T)));
<< "E4: the tenfold is smooth: " << (dim ideal leadTerm groebnerBasis(ideal jacobian matrix{{F}}, Strategy => "F4") == 0)
   << " ; X n {w = 0} = Y_c: " << (sub(F, {w_0 => 0, w_1 => 0, w_2 => 0}) == inc G) << endl << flush;
r = nodalSectionReport(F, w_2 - random(kk) * w_1 - random(kk) * w_0);
<< "RESULT Enriques, hyperplane section through the P^8: dim Sing " << r#"singularLocusDim" << ", points " << r#"singularPoints" << ", all ODP "
   << r#"allOrdinaryDoublePoints" << ", form degree " << r#"formDegree" << ", conditions " << r#"conditions" << ", defect " << r#"defect"
   << ", Hilbert function of the nodes " << toString r#"hilbertFunctionOfNodes" << "  [" << r#"label" << "]" << endl << flush;
-- the same count on S: S n {Psi-combination 1 = Psi-combination 2 = 0}
<< "E4: on S, two random quadrics cut " << (Z := IS + ideal(random(2, R), random(2, R)); degree Z) << " points with Hilbert function "
   << toString apply(7, j -> hilbertFunction(j, R/Z)) << endl;
<< "DONE p " << pp << " seed " << sd << endl;
