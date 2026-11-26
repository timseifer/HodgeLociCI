-- R9 of PREREG_pairing.md (section 9): do the quadrics through the nodes survive when the nodes move?
-- AI-written, unreviewed.  usage (from this folder):  M2 --script pr9_quadrics.m2 p seed          MOD p.
-- For g in (I_Z)_3 the nodes move with velocity x = -H^(-1) grad g.   mu_g : (I_Z)_2 -> functions on Z / quadrics,
-- q -> [grad q . x].   Necessary for V_0 to lie in the closure of {det A + det B}: dim ker mu_g >= 18 for all g.
pp = value(scriptCommandLine#1); sd = value(scriptCommandLine#2); kk = ZZ/pp; setRandomSeed sd;
UT = kk[T];
quadTest = (nm, f0, IZ0, W0) -> ( R := ring f0; n := numgens R - 1;
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
    mons3 := flatten apply(4, d -> flatten entries basis(d, Ra));
    mons2 := flatten apply(3, d -> flatten entries basis(d, Ra));
    W3 := fold((u, v) -> u | v, apply(mons3, m -> cT red ev m));
    W2 := fold((u, v) -> u | v, apply(mons2, m -> cT red ev m));
    K3 := gens ker W3; K2 := gens ker W2;
    fa := deh f;
    Hs := matrix apply(n, i -> apply(n, j -> red ev diff(Ra_i, diff(Ra_j, fa))));
    Dd := red det Hs; gc := gcdCoefficients(Dd, chi);
    if first degree gc#0 != 0 then error "the Hessian is degenerate at a node";
    Dinv := red(gc#1 * (1 / leadCoefficient gc#0));
    rws := toList(0..n-1);
    adjH := matrix apply(n, i -> apply(n, j -> (-1)^(i+j) * red det submatrix(Hs, select(rws, a -> a != j), select(rws, b -> b != i))));
    AX := UT / ideal(chi);
    HinvA := sub(adjH, AX) * sub(Dinv, AX);
    G3 := sub(matrix apply(n, i -> apply(mons3, m -> red ev diff(Ra_i, m))), AX);        -- gradients of the cubic monomials
    G2 := sub(matrix apply(n, i -> apply(mons2, m -> red ev diff(Ra_i, m))), AX);        -- gradients of the quadric monomials
    GQ := G2 * sub(K2, AX);                                                              -- gradients of a basis of (I_Z)_2
    vecs := M -> ( L := lift(M, UT); matrix(kk, apply(N, i -> apply(numColumns L, c -> coefficient(T^i, L_(0,c))))) );
    muRank := c3 -> ( x := - HinvA * (G3 * sub(c3, AX));                                 -- velocity of the nodes, n x 1 over AX
        Vq := vecs((transpose x) * GQ);                                                  -- N x dim (I_Z)_2: the functions grad q . x
        rank(W2 | Vq) - rank W2 );
    rk := apply(4, i -> muRank(K3 * random(kk^(numColumns K3), kk^1)));
    -- sanity: for an infinitesimal coordinate change the node scheme only moves, so mu must be 0
    trivc := lift(last coefficients(matrix{{deh(sum(n+1, i -> sum(n+1, j -> random(kk) * R_i * diff(R_j, f))))}}, Monomials => matrix{mons3}), kk);
    << "RESULT " << nm << ": " << N << " nodes ; conditions on quadrics " << rank W2 << ", dim (I_Z)_2 = " << numColumns K2 << " ; dim (I_Z)_3 = " << numColumns K3
       << " ; rank of mu_g for four random g in (I_Z)_3: " << toString rk << " ; for a random coordinate change: " << muRank trivc << endl << flush;
    if W0 =!= null then ( W0M := lift(last coefficients(matrix{apply(W0, w -> deh gch w)}, Monomials => matrix{mons3}), kk);
        rk0 := apply(3, i -> muRank(W0M * random(kk^(numColumns W0M), kk^1)));
        -- the span of the images and the common kernel over several general g
        gs := apply(6, i -> K3 * random(kk^(numColumns K3), kk^1));
        imgs := apply(gs, c3 -> ( x := - HinvA * (G3 * sub(c3, AX)); vecs((transpose x) * GQ) ));
        big := fold((u, v) -> u || v, apply(imgs, Vq -> ( Qm := gens ker transpose W2; (transpose Qm) * Vq )));      -- stacked maps (I_Z)_2 -> coker
        << "      for three random g tangent to the family of sections of rung members: " << toString rk0
           << " ; six general g together: the common kernel in (I_Z)_2 has dimension " << numColumns K2 - rank big << endl << flush );
    rk);
skew6 = R -> ( Lf := new MutableHashTable; scan(6, i -> scan(6, j -> if i < j then Lf#(i,j) = random(1, R)));
    matrix table(6, 6, (i,j) -> if i < j then Lf#(i,j) else if i > j then -Lf#(j,i) else 0_R));
hs = (v, l) -> v#0^3+v#1^3+v#2^3 + 3*l*v#0*v#1*v#2;
R9 = kk[z_0..z_2, p_0..p_2, q_0..q_2];
lam = random kk; xx = apply(3, i -> random kk); a0 = - hs(xx, lam) / (27 * (1 + lam^3));
zz = {z_0,z_1,z_2}; ps = {p_0,p_1,p_2}; qs = {q_0,q_1,q_2};
FC = a0 * hs(zz, lam) + hs(ps, lam) + hs(qs, lam) + sum flatten apply(3, i -> apply(3, j -> zz#((i+j)%3) * xx#((i-j)%3) * ps#i * qs#j));
<< "Coble cubic of this seed: singular locus of degree " << degree saturate ideal jacobian matrix{{FC}} << endl << flush;
U = kk[x_0..x_8];
Qs = apply(4, j -> random(2, U));
quadTest("control: sevenfold through a P^4", sum(4, j -> U_(5+j) * Qs#j), ideal(x_5, x_6, x_7, x_8) + ideal Qs, null);
A3 = matrix table(3, 3, (i,j) -> random(1, U)); B3 = matrix table(3, 3, (i,j) -> random(1, U));
quadTest("control: det A + det B", det A3 + det B3, minors(2, A3) + minors(2, B3), null);
U = kk[u_0..u_7, t]; U0 = kk[u_0..u_7]; inc = map(U, U0, (vars U)_{0..7});
Mk = skew6 U0; Psi = inc random(2, U0);
quadTest("control: section of the Pfaffian rung", inc((gens pfaffians(6, Mk))_(0,0)) + t * Psi + t^2 * random(1, U), inc pfaffians(4, Mk) + ideal(Psi, t), null);
par = map(U0, R9, apply(9, i -> random(1, U0))); G = par FC; Psi = inc random(2, U0);
IC = saturate ideal jacobian matrix{{G}};
W0 = (apply(flatten entries super basis(3, IC), w -> inc w)) | (apply(8, j -> Psi * U_j)) | (apply(flatten entries basis(2, U), m -> t * m));
quadTest("THE CASE: section of the Coble rung", inc G + t * Psi + t^2 * random(1, U), inc ideal jacobian matrix{{G}} + ideal(Psi, t), W0);
<< "DONE p " << pp << " seed " << sd << endl;
