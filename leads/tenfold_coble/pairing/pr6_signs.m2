-- R6 of PREREG_pairing.md (section 6): the relation among the nodes has coefficients +- 1/sqrt(Hessian determinant).
-- AI-written, unreviewed.  usage (from this folder):  M2 --script pr6_signs.m2 p seed          MOD p.
-- For a cubic f in P^n with reduced node scheme Z (ideal given) and exactly one relation rho on forms of degree
-- e = n/2 - 1:  write rho = Tr(g .) on the coordinate ring of Z (one affine chart), D = det of the affine Hessian of f.
-- Test: g^2 D is a constant function on Z.  Method: after a random change of coordinates, the coordinate ring of Z is
-- k[T]/(chi) for a random linear form T (checked), and everything is done with polynomials in T.
pp = value(scriptCommandLine#1); sd = value(scriptCommandLine#2); kk = ZZ/pp; setRandomSeed sd;
UT = kk[T];
signTest = (nm, f0, IZ0, e) -> ( R := ring f0; n := numgens R - 1;
    gch := map(R, R, (vars R) * random(kk^(n+1), kk^(n+1)));
    f := gch f0; IZ := saturate gch IZ0;
    Ra := kk(monoid[Variables => n]);
    deh := map(Ra, R, (vars Ra) | matrix{{1_Ra}});
    Ia := deh IZ; N := degree IZ;
    if dim Ia != 0 or degree Ia != N then error "a node on the hyperplane at infinity of the chart";
    Aq := Ra / Ia; Bq := basis Aq;
    cds := q -> lift(last coefficients(matrix{{q}}, Monomials => Bq), kk);
    ell := sub((vars Ra) * random(kk^n, kk^1), Aq); ell = ell_(0,0);
    pw := {1_Aq}; scan(N, i -> pw = append(pw, (last pw) * ell));
    Pm := fold((u, v) -> u | v, apply(N, i -> cds(pw#i)));
    if det Pm == 0 then error "the linear form does not generate the coordinate ring";
    Pinv := inverse Pm;
    toT := v -> sum(N, i -> v_(i,0) * T^i);
    chi := T^N - toT(Pinv * cds(pw#N));
    Xs := apply(n, j -> toT(Pinv * cds(sub(Ra_j, Aq))));
    ev := map(UT, Ra, Xs);
    red := q -> q % chi;
    cT := q -> transpose matrix{apply(N, i -> coefficient(T^i, q))};
    -- the relation: annihilator of the polynomials of degree <= e
    mons := flatten apply(e+1, d -> flatten entries basis(d, Ra));
    Wm := fold((u, v) -> u | v, apply(mons, m -> cT red ev m));
    rr := gens ker transpose Wm;
    if numColumns rr != 1 then error("number of relations: " | toString numColumns rr);
    -- Frobenius form on k[T]/chi: (a, b) -> coefficient of T^(N-1) in a b; it equals Tr(a b / chi')
    tp := {1_UT}; scan(2*N-2, i -> tp = append(tp, red(T * last tp)));
    Bm := matrix(kk, apply(N, i -> apply(N, j -> coefficient(T^(N-1), tp#(i+j)))));
    hh := toT((inverse Bm) * rr);
    gc := gcdCoefficients(diff(T, chi), chi);
    if first degree gc#0 != 0 then error "chi is not squarefree: the node scheme is not reduced";
    g := red(hh * gc#1 * (1 / leadCoefficient gc#0));
    fa := deh f;
    Hs := matrix apply(n, i -> apply(n, j -> red ev diff(Ra_i, diff(Ra_j, fa))));
    Dd := red det Hs;
    val := red(g^2 * Dd);
    Dc := red det submatrix(Hs, toList(0..n-2), toList(0..n-2));              -- control: a principal minor instead of the determinant
    valc := red(g^2 * Dc);
    gradOK := all(n, i -> red ev diff(Ra_i, fa) == 0) and red ev fa == 0;
    << "RESULT " << nm << ": " << N << " nodes ; f and its gradient vanish on them: " << gradOK << " ; D invertible on Z: " << (first degree gcd(Dd, chi) == 0)
       << " ; g^2 D is a nonzero constant: " << (first degree val == 0 and val != 0) << "  (degree of g^2 D mod chi as a polynomial in T: " << first degree val << ") ; control with a principal (n-1) x (n-1) minor in place of D: constant "
       << (first degree valc == 0) << " (degree " << first degree valc << ")" << endl << flush);
skew6 = R -> ( Lf := new MutableHashTable; scan(6, i -> scan(6, j -> if i < j then Lf#(i,j) = random(1, R)));
    matrix table(6, 6, (i,j) -> if i < j then Lf#(i,j) else if i > j then -Lf#(j,i) else 0_R));
hs = (v, l) -> v#0^3+v#1^3+v#2^3 + 3*l*v#0*v#1*v#2;
R9 = kk[z_0..z_2, p_0..p_2, q_0..q_2];
lam = random kk; xx = apply(3, i -> random kk); a0 = - hs(xx, lam) / (27 * (1 + lam^3));
zz = {z_0,z_1,z_2}; ps = {p_0,p_1,p_2}; qs = {q_0,q_1,q_2};
FC = a0 * hs(zz, lam) + hs(ps, lam) + hs(qs, lam) + sum flatten apply(3, i -> apply(3, j -> zz#((i+j)%3) * xx#((i-j)%3) * ps#i * qs#j));
IA = saturate ideal jacobian matrix{{FC}};
<< "Coble cubic of this seed: singular locus of dim " << dim IA - 1 << ", degree " << degree IA << endl << flush;
-- (a) sixfold +1
U = kk[y_0..y_6]; Mk = skew6 U;
signTest("(a) sixfold +1, Pfaffian section", (gens pfaffians(6, Mk))_(0,0), pfaffians(4, Mk), 2);
-- (c) sixfold -1, Coble n P^6
par = map(U, R9, apply(9, i -> random(1, U))); G = par FC;
signTest("(c) sixfold -1, Coble n P^6", G, ideal jacobian matrix{{G}}, 2);
-- (b) eightfold +1: hyperplane section f = Pf(u) + t Psi(u) + t^2 L + c t^3
U = kk[u_0..u_7, t]; U0 = kk[u_0..u_7]; inc = map(U, U0, (vars U)_{0..7});
Mk = skew6 U0; Psi = inc random(2, U0);
signTest("(b) eightfold +1, Pfaffian rung", inc((gens pfaffians(6, Mk))_(0,0)) + t * Psi + t^2 * random(1, U), inc pfaffians(4, Mk) + ideal(Psi, t), 3);
-- (d) eightfold -1: Coble n P^7
par = map(U0, R9, apply(9, i -> random(1, U0))); G = par FC; Psi = inc random(2, U0);
signTest("(d) eightfold -1, Coble rung", inc G + t * Psi + t^2 * random(1, U), inc ideal jacobian matrix{{G}} + ideal(Psi, t), 3);
-- (e) det A + det B in P^8
U = kk[x_0..x_8];
A3 = matrix table(3, 3, (i,j) -> random(1, U)); B3 = matrix table(3, 3, (i,j) -> random(1, U));
signTest("(e) eightfold -1, det A + det B", det A3 + det B3, minors(2, A3) + minors(2, B3), 3);
-- tenfolds
U = kk[y_0..y_8, w_0, w_1]; U0 = kk[y_0..y_8]; inc = map(U, U0, (vars U)_{0..8});
Mk = skew6 U0; Psa = inc random(2, U0); Psb = inc random(2, U0);
signTest("tenfold +1, Pfaffian (K3)", inc((gens pfaffians(6, Mk))_(0,0)) + w_0 * Psa + w_1 * Psb + w_0^2 * random(1, U) + w_0 * w_1 * random(1, U) + w_1^2 * random(1, U), inc pfaffians(4, Mk) + ideal(Psa, Psb, w_0, w_1), 4);
Psa = inc random(2, U0); Psb = inc random(2, U0);
signTest("tenfold -1, Coble (abelian)", inc((map(U0, R9, vars U0)) FC) + w_0 * Psa + w_1 * Psb + w_0^2 * random(1, U) + w_0 * w_1 * random(1, U) + w_1^2 * random(1, U), inc((map(U0, R9, vars U0)) IA) + ideal(Psa, Psb, w_0, w_1), 4);
<< "DONE p " << pp << " seed " << sd << endl;
