-- R5 (added after R1-R4; predictions in PREREG_pairing.md, section 5, written before the first run of this file).
-- The class attached to a relation among the nodes, as a functional, and the Hilbert function of its Artinian
-- Gorenstein algebra; in particular the tangent codimension of its Hodge locus.
-- AI-written, unreviewed.  usage (from this folder):  M2 --script pr5_tangent.m2 p seed
--
-- Setting: X = {F = 0} a smooth cubic 2k-fold, H = {s = 0} a hyperplane, F = f + s Q, V = {f = 0} in H with nodes Z
-- (reduced), one relation rho among the nodes on forms of degree e = k - 1.  ARG (not proved here): the Hodge class is,
-- up to a scalar, the functional on forms P of degree e + 2 = (k+1)(d-2)
--          delta(P) = rho( P / Q )            (P/Q is a function on Z of "degree e"; Q does not vanish on Z)
-- It kills s and the Jacobian ideal: d_y F = d_y f = 0 at the nodes, and d_s F = Q gives rho(P') = 0, P' of degree e.
-- CORRECTION after the blind check (26 Nov 2026): that property is true but does not characterise delta (in the first
-- case below the functionals killing s and the Jacobian ideal form a space of dimension 14).  What characterises
-- delta, up to a scalar, is that it kills the SATURATED ideal of the nodes and Q: ker delta = (I_Z + (Q)) in degree
-- e + 2.  That the Hodge class kills I_Z is an argument, not a proof.  The code is unchanged.
-- The Artinian Gorenstein ideal I = {P : delta(P P') = 0 for all P'} then has: dim (S/I)_3 = codimension of the tangent
-- space of the Hodge locus of the class.   Everything is MOD p, random instance of the seed.
pp = value(scriptCommandLine#1); sd = value(scriptCommandLine#2); kk = ZZ/pp; setRandomSeed sd;
agHF = (nm, IZ0, Qp, e, pred) -> ( R := ring IZ0; n := numgens R; xl := R_(n-1);
    IZ := saturate IZ0; N := degree IZ;
    if dim IZ != 1 or dim(IZ + ideal xl) > 0 then error "nodes: not finite, or one of them on the last coordinate hyperplane";
    if sub(Qp, R/IZ) == 0 or degree(IZ + ideal Qp) != 0 and dim(IZ + ideal Qp) > 0 then error "Q vanishes at a node";
    A := R/IZ; K1 := basis(e+1, A); K3 := basis(e+3, A);
    if numColumns K1 != N or numColumns K3 != N then error "Hilbert function of the nodes not yet constant in degree e+1";
    Se := basis(e, R);
    c1 := lift(last coefficients(sub(xl * Se, A), Monomials => K1), kk);
    rho := gens ker transpose c1;
    if numColumns rho != 1 then error("number of relations among the nodes in degree e is " | toString numColumns rho);
    MQ := lift(last coefficients(sub(Qp, A) * K1, Monomials => K3), kk);
    S2 := basis(e+2, R);
    Vm := lift(last coefficients(sub(xl * S2, A), Monomials => K3), kk);
    dl := (transpose rho) * (inverse MQ) * Vm;
    mons := flatten entries S2; H := hashTable apply(#mons, i -> mons#i => dl_(0,i));
    hf := apply(e+3, j -> ( Sj := flatten entries basis(j, R); Sk := flatten entries basis(e+2-j, R);
        rank matrix(kk, apply(Sj, a -> apply(Sk, b -> H#(a*b)))) ));
    << "RESULT " << nm << ": " << N << " nodes, Hilbert function of the Gorenstein algebra of the class " << toString hf
       << " (sum " << sum hf << "), in degree 3: " << hf#3 << " ; predicted " << pred << endl << flush; hf);
skew6 = R -> ( Lf := new MutableHashTable; scan(6, i -> scan(6, j -> if i < j then Lf#(i,j) = random(1, R)));
    matrix table(6, 6, (i,j) -> if i < j then Lf#(i,j) else if i > j then -Lf#(j,i) else 0_R));
hs = (v, l) -> v#0^3+v#1^3+v#2^3 + 3*l*v#0*v#1*v#2;
R9 = kk[z_0..z_2, p_0..p_2, q_0..q_2];
lam = random kk; xx = apply(3, i -> random kk); a0 = - hs(xx, lam) / (27 * (1 + lam^3));
zz = {z_0,z_1,z_2}; ps = {p_0,p_1,p_2}; qs = {q_0,q_1,q_2};
FC = a0 * hs(zz, lam) + hs(ps, lam) + hs(qs, lam) + sum flatten apply(3, i -> apply(3, j -> zz#((i+j)%3) * xx#((i-j)%3) * ps#i * qs#j));
IA = saturate ideal jacobian matrix{{FC}};
<< "Coble cubic of this seed: singular locus of dim " << dim IA - 1 << ", degree " << degree IA << endl << flush;

-- sixfolds (k = 3, e = 2): nodes in the hyperplane P^6, Q = the quadric of F = f + s Q restricted to s = 0
U = kk[y_0..y_6];
agHF("sixfold +1, l*Q + Pf", pfaffians(4, skew6 U), random(2, U), 2, "7 (registry: 1,7,12,7,1)");
par = map(U, R9, apply(9, i -> random(1, U)));
agHF("sixfold -1, hyperplane section Coble n P^6", ideal jacobian matrix{{par FC}}, random(2, U), 2, "at most 7; 7 means tangent codimension 7");

-- eightfolds (k = 4, e = 3)
U = kk[u_0..u_7];
agHF("eightfold +1, P^7-section Pfaffian", pfaffians(4, skew6 U) + ideal random(2, U), random(2, U), 3, "19 (registry: codim NL(1) = 19)");
par = map(U, R9, apply(9, i -> random(1, U)));
agHF("eightfold -1, P^7-section Coble n P^7", ideal jacobian matrix{{par FC}} + ideal random(2, U), random(2, U), 3, "at most 25; compare with 26 (codim of l*Q + det A + det B)");
U = kk[x_0..x_8];
A3 = matrix table(3, 3, (i,j) -> random(1, U)); B3 = matrix table(3, 3, (i,j) -> random(1, U));
agHF("eightfold -1, l*Q + det A + det B", minors(2, A3) + minors(2, B3), random(2, U), 3, "26 (registry: D-EIGHTFOLD-FAMILY-TD)");

-- tenfolds (k = 5, e = 4)
U = kk[y_0..y_8];
agHF("tenfold +1, P^8-section Pfaffian (K3)", pfaffians(4, skew6 U) + ideal(random(2, U), random(2, U)), random(2, U), 4, "38 (registry: 1,9,27,38,27,9,1)");
par = map(U, R9, apply(9, i -> random(1, U)));
agHF("tenfold -1, P^8-section Coble (abelian)", (map(U, R9, vars U)) IA + ideal(random(2, U), random(2, U)), random(2, U), 4, "54 (registry: codim 54)");
<< "DONE p " << pp << " seed " << sd << endl;
