-- R8 of PREREG_pairing.md (section 8): the second-order obstruction to keeping the nodes of a cubic sevenfold in P^8.
-- AI-written, unreviewed.  usage (from this folder):  M2 --script pr8_equisingular.m2 p seed          MOD p.
-- V = {f = 0} in P^8 with N reduced nodes p_i and exactly one relation sum c_i g(p_i) = 0 on cubics.  On
-- (I_Z)_3 = {cubics through the nodes} = the tangent space of the germ ES of cubics with N nodes:
--        h(g) = sum_i c_i  grad g(p_i)^T  H_i^(-1)  grad g(p_i)            (H_i = Hessian of f at p_i, one affine chart)
-- is the quadratic term of sum c_i b_i (b_i = the local equation of the i-th branch of the discriminant), which
-- vanishes on ES.   h != 0 on (I_Z)_3  =>  dim ES = 165 - N;   h == 0  =>  no obstruction at second order.
-- Method as in pr6_signs.m2: after a random change of coordinates the coordinate ring of the node scheme is k[T]/(chi).
pp = value(scriptCommandLine#1); sd = value(scriptCommandLine#2); kk = ZZ/pp; setRandomSeed sd;
UT = kk[T];
esTest = (nm, f0, IZ0, W0) -> ( R := ring f0; n := numgens R - 1; tm := cpuTime();
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
    if det Pm == 0 then error "the linear form does not generate the coordinate ring";
    Pinv := inverse Pm;
    toT := v -> sum(N, i -> v_(i,0) * T^i);
    chi := T^N - toT(Pinv * cds(pw#N));
    Xs := apply(n, j -> toT(Pinv * cds(sub(Ra_j, Aq))));
    ev := map(UT, Ra, Xs);
    red := q -> q % chi;
    cT := q -> transpose matrix{apply(N, i -> coefficient(T^i, q))};
    monsA := flatten apply(4, d -> flatten entries basis(d, Ra));                       -- the 165 monomials of degree <= 3
    Wm := fold((u, v) -> u | v, apply(monsA, m -> cT red ev m));                      -- N x 165: values on the nodes
    rr := gens ker transpose Wm;
    if numColumns rr != 1 then error("number of relations on cubics: " | toString numColumns rr);
    Kc := gens ker Wm;                                                                  -- (I_Z)_3, as coefficient vectors
    tp := {1_UT}; scan(2*N-2, i -> tp = append(tp, red(T * last tp)));
    Bm := matrix(kk, apply(N, i -> apply(N, j -> coefficient(T^(N-1), tp#(i+j)))));     -- Frobenius form of k[T]/chi
    hOf := r -> toT((inverse Bm) * r);                                                  -- functional r  ->  h with r(a) = coeff_(N-1)(h a)
    hh := hOf rr;
    fa := deh f;
    Hs := matrix apply(n, i -> apply(n, j -> red ev diff(Ra_i, diff(Ra_j, fa))));
    Dd := red det Hs;
    gc := gcdCoefficients(Dd, chi);
    if first degree gc#0 != 0 then error "the Hessian is degenerate at a node";
    Dinv := red(gc#1 * (1 / leadCoefficient gc#0));
    rws := toList(0..n-1);
    adjH := matrix apply(n, i -> apply(n, j -> (-1)^(i+j) * red det submatrix(Hs, select(rws, a -> a != j), select(rws, b -> b != i))));
    AX := UT / ideal(chi);
    HinvA := sub(adjH, AX) * sub(Dinv, AX);
    invOK := ((sub(Hs, AX) * HinvA - id_(AX^n)) == 0);                                  -- (comparing with == id directly fails on the degrees of the free modules; first log kept)
    GmA := sub(matrix apply(n, i -> apply(monsA, m -> red ev diff(Ra_i, m))), AX);      -- n x 165: gradients of the monomials
    Mfull := (transpose GmA) * HinvA * GmA;                                             -- 165 x 165 over k[T]/chi
    formOf := h0 -> ( E := lift(sub(h0, AX) * Mfull, UT); matrix(kk, apply(#monsA, a -> apply(#monsA, b -> coefficient(T^(N-1), E_(a,b))))) );
    Mh := formOf hh;
    hK := (transpose Kc) * Mh * Kc;
    -- infinitesimal coordinate changes x_i d f / d x_j: must vanish on the nodes and lie in the kernel of h on (I_Z)_3
    triv := flatten apply(n+1, i -> apply(n+1, j -> deh(R_i * diff(R_j, f))));
    Tv := lift(last coefficients(matrix{triv}, Monomials => matrix{monsA}), kk);
    trivOK := (Wm * Tv == 0) and ((transpose Kc) * Mh * Tv == 0);
    -- teeth: a random functional in place of the relation
    MhR := formOf hOf random(kk^N, kk^1);
    << "RESULT " << nm << ": " << N << " nodes, " << rank Wm << " conditions on cubics ; dim (I_Z)_3 = " << numColumns Kc
       << " ; H^(-1) correct: " << invOK << " ; form symmetric: " << (Mh == transpose Mh) << " ; rank of h on all cubics: " << rank Mh
       << " ; coordinate changes in the kernel: " << trivOK << " (rank " << rank Tv << ")"
       << " ; RANK OF h ON (I_Z)_3: " << rank hK << " ; teeth (random functional instead of the relation): rank " << rank((transpose Kc) * MhR * Kc)
       << " ; cpu " << cpuTime() - tm << endl << flush;
    if W0 =!= null then ( W0M := lift(last coefficients(matrix{apply(W0, w -> deh gch w)}, Monomials => matrix{monsA}), kk);
        << "      the tangent space of the family of sections of rung members: rank " << rank W0M << " ; vanishes on the nodes: " << (Wm * W0M == 0)
           << " ; h vanishes on it: " << ((transpose W0M) * Mh * W0M == 0) << " ; rank of the pairing of it with (I_Z)_3 under h: " << rank((transpose Kc) * Mh * W0M)
           << " ; rank of h on (I_Z)_3 modulo its radical is the number above" << endl << flush );
    rank hK);
skew6 = R -> ( Lf := new MutableHashTable; scan(6, i -> scan(6, j -> if i < j then Lf#(i,j) = random(1, R)));
    matrix table(6, 6, (i,j) -> if i < j then Lf#(i,j) else if i > j then -Lf#(j,i) else 0_R));
hs = (v, l) -> v#0^3+v#1^3+v#2^3 + 3*l*v#0*v#1*v#2;
R9 = kk[z_0..z_2, p_0..p_2, q_0..q_2];
lam = random kk; xx = apply(3, i -> random kk); a0 = - hs(xx, lam) / (27 * (1 + lam^3));
zz = {z_0,z_1,z_2}; ps = {p_0,p_1,p_2}; qs = {q_0,q_1,q_2};
FC = a0 * hs(zz, lam) + hs(ps, lam) + hs(qs, lam) + sum flatten apply(3, i -> apply(3, j -> zz#((i+j)%3) * xx#((i-j)%3) * ps#i * qs#j));
<< "Coble cubic of this seed: singular locus of degree " << degree saturate ideal jacobian matrix{{FC}} << endl << flush;
-- control 1: a cubic sevenfold containing a P^4 (16 nodes; the cubics containing a P^4 form a family of dimension 150 = 165 - 15)
U = kk[x_0..x_8];
Qs = apply(4, j -> random(2, U));
esTest("control: sevenfold through a P^4", sum(4, j -> U_(5+j) * Qs#j), ideal(x_5, x_6, x_7, x_8) + ideal Qs, null);
-- control 2: det A + det B (36 nodes; family of dimension 130)
A3 = matrix table(3, 3, (i,j) -> random(1, U)); B3 = matrix table(3, 3, (i,j) -> random(1, U));
esTest("control: det A + det B", det A3 + det B3, minors(2, A3) + minors(2, B3), null);
-- control 3: section of the Pfaffian rung (28 nodes; family of dimension 138)
U = kk[u_0..u_7, t]; U0 = kk[u_0..u_7]; inc = map(U, U0, (vars U)_{0..7});
Mk = skew6 U0; Psi = inc random(2, U0);
esTest("control: section of the Pfaffian rung", inc((gens pfaffians(6, Mk))_(0,0)) + t * Psi + t^2 * random(1, U), inc pfaffians(4, Mk) + ideal(Psi, t), null);
-- the case in question: section through the P^7 of a Coble-rung eightfold
par = map(U0, R9, apply(9, i -> random(1, U0))); G = par FC; Psi = inc random(2, U0);
IC = saturate ideal jacobian matrix{{G}};
<< "Coble n P^7: singular curve of degree " << degree IC << ", genus " << genus IC << " ; cubics through it: " << numColumns super basis(3, IC) << " (120 - 45 = 75)" << endl << flush;
W0 = (apply(flatten entries super basis(3, IC), w -> inc w)) | (apply(8, j -> Psi * U_j)) | (apply(flatten entries basis(2, U), m -> t * m));
esTest("THE CASE: section of the Coble rung", inc G + t * Psi + t^2 * random(1, U), inc ideal jacobian matrix{{G}} + ideal(Psi, t), W0);
<< "DONE p " << pp << " seed " << sd << endl;
