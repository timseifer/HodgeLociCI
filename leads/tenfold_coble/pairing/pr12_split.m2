-- R12 of PREREG_pairing.md (section 11): the algebra of endomorphisms of the 18 surviving quadrics that preserve
-- their linear syzygies.   AI-written, unreviewed.  usage (from this folder):  M2 --script pr12_split.m2 p seed      MOD p.
pp = value(scriptCommandLine#1); sd = value(scriptCommandLine#2); kk = ZZ/pp; setRandomSeed sd;
UT = kk[T];
splitTest = (nm, f0, IZ0) -> ( R := ring f0; n := numgens R - 1;
    gch := map(R, R, (vars R) * random(kk^(n+1), kk^(n+1)));
    f := gch f0; IZ := saturate gch IZ0;
    Ra := kk(monoid[Variables => n]);
    deh := map(Ra, R, (vars Ra) | matrix{{1_Ra}});
    Ia := deh IZ; N := degree IZ;
    if dim Ia != 0 or degree Ia != N then error "a node on the hyperplane at infinity of the chart";
    Aq := Ra / Ia; Bq := basis Aq;
    cds := q -> lift(last coefficients(matrix{{q}}, Monomials => Bq), kk);
    ell := (sub((vars Ra) * random(kk^n, kk^1), Aq))_(0,0);
    pw := {1_Aq}; scan(N, i -> pw = append(pw, (last pw) * ell));
    Pm := fold((u, v) -> u | v, apply(N, i -> cds(pw#i)));
    Pinv := inverse Pm;
    toT := v -> sum(N, i -> v_(i,0) * T^i);
    chi := T^N - toT(Pinv * cds(pw#N));
    Xs := apply(n, j -> toT(Pinv * cds(sub(Ra_j, Aq))));
    ev := map(UT, Ra, Xs);
    red := q -> q % chi;
    cT := q -> transpose matrix{apply(N, i -> coefficient(T^i, q))};
    mons3 := flatten apply(4, d -> flatten entries basis(d, Ra));
    mons2 := flatten apply(3, d -> flatten entries basis(d, Ra));
    W3 := fold((u, v) -> u | v, apply(mons3, m -> cT red ev m));
    W2 := fold((u, v) -> u | v, apply(mons2, m -> cT red ev m));
    K3 := gens ker W3; K2 := gens ker W2;
    fa := deh f;
    Hs := matrix apply(n, i -> apply(n, j -> red ev diff(Ra_i, diff(Ra_j, fa))));
    Dd := red det Hs; gc := gcdCoefficients(Dd, chi);
    Dinv := red(gc#1 * (1 / leadCoefficient gc#0));
    rws := toList(0..n-1);
    adjH := matrix apply(n, i -> apply(n, j -> (-1)^(i+j) * red det submatrix(Hs, select(rws, a -> a != j), select(rws, b -> b != i))));
    AX := UT / ideal(chi);
    HinvA := sub(adjH, AX) * sub(Dinv, AX);
    G3 := sub(matrix apply(n, i -> apply(mons3, m -> red ev diff(Ra_i, m))), AX);
    G2 := sub(matrix apply(n, i -> apply(mons2, m -> red ev diff(Ra_i, m))), AX);
    GQ := G2 * sub(K2, AX);
    vecs := M -> ( L := lift(M, UT); matrix(kk, apply(N, i -> apply(numColumns L, c -> coefficient(T^i, L_(0,c))))) );
    Qm := gens ker transpose W2;
    big := fold((u, v) -> u || v, apply(6, i -> ( x := - HinvA * (G3 * sub(K3 * random(kk^(numColumns K3), kk^1), AX)); (transpose Qm) * vecs((transpose x) * GQ) )));
    Lc := K2 * gens ker big;                                                           -- the surviving quadrics, coefficient vectors
    r := numColumns Lc;
    qs := flatten entries (matrix{mons2} * sub(Lc, Ra));
    lin := {1_Ra} | flatten entries vars Ra;
    Mm := lift(last coefficients(matrix{flatten apply(qs, q -> apply(lin, l -> q * l))}, Monomials => matrix{mons3}), kk);      -- 165 x 9r
    Sz := gens ker Mm; s := numColumns Sz;
    cols := flatten apply(r, a -> apply(r, b -> ( P := (Mm_(toList(9*a..9*a+8))) * (Sz^(toList(9*b..9*b+8))); transpose matrix{flatten entries P} )));
    Cond := fold((u, v) -> u | v, cols);
    Alg := gens ker Cond;                                                             -- columns: phi as r x r, entry (a,b) at index r*a + b
    << "RESULT " << nm << ": " << N << " nodes ; surviving quadrics: " << r << " ; dim L S_1 = " << rank Mm << " ; linear syzygies: " << s
       << " ; DIMENSION OF THE ALGEBRA: " << numColumns Alg << endl << flush;
    if numColumns Alg >= 2 then (
        va := Alg * random(kk^(numColumns Alg), kk^1);                                  -- ONE random element of the algebra
        phi := matrix(kk, apply(r, a -> apply(r, b -> va_(r*a+b, 0))));
        Pc := kk[lambda]; cp := det(lambda * id_(Pc^r) - sub(phi, Pc));
        fac := factor cp;
        << "      a random element: characteristic polynomial factors with (degree, multiplicity): " << toString apply(toList fac, t -> (first degree t#0, t#1)) << endl << flush;
        lf := select(toList fac, t -> first degree t#0 == 1);
        hom := kk(monoid[Variables => n+1]);
        toHom := q -> ( h := homogenize(sub(q, apply(n, j -> Ra_j => hom_j)), hom_n); h );
        scan(lf, t -> ( ev0 := - sub(t#0, lambda => 0) / leadCoefficient(t#0);
            Kr := gens ker (phi - ev0 * id_(kk^r))^(t#1);
            qsub := flatten entries (matrix{qs} * sub(Kr, Ra));
            I := ideal apply(qsub, q -> toHom q);
            << "      eigenvalue with multiplicity " << t#1 << ": generalised eigenspace of dimension " << numColumns Kr << " ; eigenspace " << numColumns gens ker(phi - ev0 * id_(kk^r))
               << " ; its quadrics cut a scheme of dimension " << dim I - 1 << " and degree " << degree I << " ; Hilbert polynomial " << toString hilbertPolynomial(I, Projective => false) << endl << flush )));
    numColumns Alg);
hs = (v, l) -> v#0^3+v#1^3+v#2^3 + 3*l*v#0*v#1*v#2;
R9 = kk[z_0..z_2, p_0..p_2, q_0..q_2];
lam = random kk; xx = apply(3, i -> random kk); a0 = - hs(xx, lam) / (27 * (1 + lam^3));
zz = {z_0,z_1,z_2}; ps = {p_0,p_1,p_2}; qs9 = {q_0,q_1,q_2};
FC = a0 * hs(zz, lam) + hs(ps, lam) + hs(qs9, lam) + sum flatten apply(3, i -> apply(3, j -> zz#((i+j)%3) * xx#((i-j)%3) * ps#i * qs9#j));
U = kk[x_0..x_8];
A3 = matrix table(3, 3, (i,j) -> random(1, U)); B3 = matrix table(3, 3, (i,j) -> random(1, U));
splitTest("control: det A + det B", det A3 + det B3, minors(2, A3) + minors(2, B3));
U = kk[u_0..u_7, t]; U0 = kk[u_0..u_7]; inc = map(U, U0, (vars U)_{0..7});
par = map(U0, R9, apply(9, i -> random(1, U0))); G = par FC; Psi = inc random(2, U0);
splitTest("THE CASE: section of the Coble rung", inc G + t * Psi + t^2 * random(1, U), inc ideal jacobian matrix{{G}} + ideal(Psi, t));
<< "DONE p " << pp << " seed " << sd << endl;
