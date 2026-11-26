-- R11 of PREREG_pairing.md (section 10): at a member of the Coble rung, is the tangent space of the Hodge locus
-- (R5: codimension 25) spanned by the first-order deformations that keep the 36 nodes of some member of the pencil?
-- AI-written, unreviewed.  usage (from this folder):  M2 --script pr11_cone.m2 p seed          MOD p.
-- (Two earlier runs were stopped by the time limit; the node ideals are now saturated with respect to u_7 only,
-- which is the full saturation because no node lies on u_7 = 0: that is checked for the two members used for the class.)
-- Eightfold F = G(u) + t_1 Psi_1 + t_2 Psi_2 + ..., G = Coble n P^7.  Hyperplane H_c: t_2 = c t_1; its section has the
-- nodes Z_c = C n {Psi_1 + c Psi_2 = 0} and normal quadric Psi_2.  Everything divisible by t_1 or t_2 keeps the nodes,
-- so only cubics in u matter:  J_c = (I_(Z_c))_3 + Psi_2 * (linear forms)  inside k[u]_3 (codimension 27).
-- The class: delta_c(P) = rho_c(P / Psi_2) on quintics in u (as in pr5_tangent.m2), I_3 = kernel of its pairing.
pp = value(scriptCommandLine#1); sd = value(scriptCommandLine#2); kk = ZZ/pp; setRandomSeed sd;
hs = (v, l) -> v#0^3+v#1^3+v#2^3 + 3*l*v#0*v#1*v#2;
R9 = kk[z_0..z_2, p_0..p_2, q_0..q_2];
lam = random kk; xx = apply(3, i -> random kk); a0 = - hs(xx, lam) / (27 * (1 + lam^3));
zz = {z_0,z_1,z_2}; ps = {p_0,p_1,p_2}; qs = {q_0,q_1,q_2};
FC = a0 * hs(zz, lam) + hs(ps, lam) + hs(qs, lam) + sum flatten apply(3, i -> apply(3, j -> zz#((i+j)%3) * xx#((i-j)%3) * ps#i * qs#j));
U = kk[u_0..u_7];
par = map(U, R9, apply(9, i -> random(1, U))); G = par FC;
IC = saturate ideal jacobian matrix{{G}};
Psi1 = random(2, U); Psi2 = random(2, U);
B3 = basis(3, U); B2 = basis(2, U);
coef3 = L -> lift(last coefficients(matrix{L}, Monomials => B3), kk);
<< "Coble n P^7: curve of degree " << degree IC << ", genus " << genus IC << endl << flush;
-- the kernel in degree 3 of the pairing of the class built from the pencil member c
classKer = c -> ( IZ := saturate(IC + ideal(Psi1 + c * Psi2), U_7); N := degree IZ; e := 3; xl := U_7;
    if dim(IZ + ideal xl) > 0 then error "a node on the last coordinate hyperplane";
    A := U / IZ; K1 := basis(e+1, A); K3 := basis(e+3, A);
    c1 := lift(last coefficients(sub(xl * basis(e, U), A), Monomials => K1), kk);
    rho := gens ker transpose c1;
    if numColumns rho != 1 then error "number of relations on cubics is not 1";
    MQ := lift(last coefficients(sub(Psi2, A) * K1, Monomials => K3), kk);
    S5 := basis(e+2, U);
    Vm := lift(last coefficients(sub(xl * S5, A), Monomials => K3), kk);
    dl := (transpose rho) * (inverse MQ) * Vm;
    mons := flatten entries S5; H := hashTable apply(#mons, i -> mons#i => dl_(0,i));
    D := matrix(kk, apply(flatten entries B3, a -> apply(flatten entries B2, b -> H#(a*b))));       -- 120 x 36
    (N, rank D, gens ker transpose D, IZ));
cs = apply(5, i -> random kk);
r0 = classKer(cs#0); r1 = classKer(cs#1);
Ker = r0#2;
<< "RESULT class from the pencil member c_1: " << r0#0 << " nodes, pairing of rank " << r0#1 << " (R5: 25) ; from c_2: rank " << r1#1
   << " ; the two kernels in degree 3 coincide: " << (rank(Ker | r1#2) == rank Ker and rank Ker == rank r1#2) << " (dimension " << rank Ker << " of 120)" << endl << flush;
IZs = {r0#3, r1#3} | apply(drop(cs, 2), c -> saturate(IC + ideal(Psi1 + c * Psi2), U_7));
-- (I_Z)_3 as the kernel of the reduction of cubics modulo the node ideal (the earlier "super basis(3, IZ)" was too slow)
deg3 = IZ -> ( A := U / IZ; gens ker lift(last coefficients(sub(B3, A), Monomials => basis(3, A)), kk) );
Js = apply(IZs, IZ -> deg3(IZ) | coef3(apply(8, j -> Psi2 * U_j)));
<< "RESULT for five members of the pencil: dim J_c = " << toString apply(Js, rank) << " (93 = codimension 27) ; each J_c lies in the kernel: "
   << toString apply(Js, J -> rank(Ker | J) == rank Ker) << endl;
sums = apply(5, k -> rank fold((a, b) -> a | b, take(Js, k+1)));
<< "RESULT dimension of J_(c_1) + ... + J_(c_k), k = 1..5: " << toString sums << " ; codimension " << toString apply(sums, s -> 120 - s)
   << " ; the sum of all five equals the kernel (codimension 25): " << (sums#4 == rank Ker) << endl;
-- what the sum over the pencil contains in simple terms
base = coef3((flatten entries super basis(3, IC)) | apply(8, j -> Psi1 * U_j) | apply(8, j -> Psi2 * U_j));
<< "      (I_C)_3 + Psi_1 S_1 + Psi_2 S_1 has dimension " << rank base << " ; so the nodes of the pencil members add " << sums#4 - rank base << " dimensions" << endl;
-- R11b (section 13): the 2-planes J_c / base in the 4-dimensional quotient kernel / base, and their Pluecker vectors
Bb = mingens image base; Comp = Ker * random(kk^(numColumns Ker), kk^4);
Bf = Bb | Comp;
if rank Bf != rank Ker then error "the complement was badly chosen";
pl = apply(Js, J -> ( cq := (J // Bf)^(toList(numColumns Bb..numColumns Bb + 3)); two := mingens image cq;
    (numColumns two, gens minors(2, two)) ));
<< "RESULT R11b: dimension of J_c modulo the tangent space of the rung, five members: " << toString apply(pl, x -> x#0)
   << " ; their Pluecker vectors span a space of dimension " << rank fold((a, b) -> a || b, apply(pl, x -> x#1)) << " (3 = lines of one ruling of a quadric; 5 = general)" << endl;
<< "DONE p " << pp << " seed " << sd << endl;
