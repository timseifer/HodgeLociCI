-- ex1_setup.m2: the named rational member, the point a, the 4-planes and the forms Q_a, G.  EXACT over QQ.
-- Loaded by ex2_count.m2 (load "ex1_setup.m2"); can also be run alone:  M2 --script ex1_setup.m2
-- Coble cubic in the normal form of ../pl1_count.m2:
--   F = a0 h_lam(z) + h_lam(p) + h_lam(q) + sum_{i,j} z_(i+j) x_(i-j) p_i q_j,  a0 = - h_lam(x) / (27 (1 + lam^3)).
-- iota: z_1 <-> z_2, p_0 <-> q_0, p_1 <-> q_2, p_2 <-> q_1 preserves F.  A point b of the odd eigenspace is
-- b = (0, s, -s, pa, pb, pc, -pa, -pc, -pb); the parameters (lam, x) with b in Sing(Y) form a line (linear algebra).
kk = QQ;
bOdd = {1, 1, 2, 3};                 -- (s, pa, pb, pc)
uPar = 1;                            -- the point x_2 = uPar of that line
hes = (v, l) -> v#0^3+v#1^3+v#2^3 + 3*l*v#0*v#1*v#2;
-- step 1: the parameters
Pp = kk[lamv, xv_0..xv_2];
Rz0 = Pp[zt_0..zt_2, pt_0..pt_2, qt_0..qt_2];
zt = {zt_0,zt_1,zt_2}; ptt = {pt_0,pt_1,pt_2}; qtt = {qt_0,qt_1,qt_2}; xsv = {xv_0,xv_1,xv_2};
Fn = - hes(xsv, lamv) * hes(zt, lamv) + 27*(1+lamv^3) * (hes(ptt, lamv) + hes(qtt, lamv)
     + sum flatten apply(3, i -> apply(3, j -> zt#((i+j)%3) * xsv#((i-j)%3) * ptt#i * qtt#j)));
(sB, paB, pbB, pcB) = toSequence bOdd;
bvec = {0, sB, -sB, paB, pbB, pcB, -paB, -pcB, -pbB};
eqs = apply(flatten entries jacobian matrix{{Fn}}, g -> lift(sub(g, apply(9, i -> Rz0_i => bvec#i)), Pp));
Ipar = saturate(ideal eqs, ideal(1 + lamv^3));
<< "parameters (lam, x) with b = " << toString bvec << " singular on Y: dim " << dim Ipar << ", degree " << degree Ipar << " (a line)" << endl;
sol = flatten entries gens gb(Ipar + ideal(xv_2 - uPar));
solM = matrix(kk, apply(sol, f -> apply(gens Pp, v -> coefficient(v, f)) | {coefficient(1_Pp, f)}));
parv = flatten entries ((-1) * (inverse solM_{0,1,2,3}) * solM_{4});          -- lam, x_0, x_1, x_2
lam = parv#0; x = drop(parv, 1);
<< "NAMED MEMBER: lam = " << lam << ", x = " << toString x << " ; a = b = " << toString bvec << endl;
-- step 2: the cubic over QQ
R = kk[z_0..z_2, p_0..p_2, q_0..q_2];
zz = {z_0,z_1,z_2}; ps = {p_0,p_1,p_2}; qs = {q_0,q_1,q_2};
a0 = - hes(x, lam) / (27*(1+lam^3));
F = a0 * hes(zz, lam) + hes(ps, lam) + hes(qs, lam) + sum flatten apply(3, i -> apply(3, j -> zz#((i+j)%3) * x#((i-j)%3) * ps#i * qs#j));
grad = jacobian matrix{{F}};
HessF = jacobian transpose grad;
apt = bvec;
evA = apply(9, i -> R_i => apt#i);
<< "a0 = " << a0 << " ; gradient of F at a is zero: " << (sub(grad, evA) == 0) << " ; special-parameter tests (x_i + x_j = lam x_k for some i,j,k; h_lam(x) = 0; 1 + lam^3 = 0): "
   << toString(any(3, k -> x#((k+1)%3) + x#((k+2)%3) == lam * x#k), hes(x, lam) == 0, 1 + lam^3 == 0) << endl;
-- step 3: data at a (as baseData of ../pl1_count.m2, with T_aA := ker Hess_a F)
Ha = lift(sub(HessF, evA), kk);
TA = gens ker Ha;
am = transpose matrix(kk, {apt});
V = TA * (gens ker transpose (TA \\ am));
yv = transpose vars R;
Qa = ((transpose yv) * sub(Ha, R) * yv)_(0,0);
Bm = (transpose sub(V, R)) * HessF * sub(V, R);
lv = (transpose sub(V, R)) * grad;
G = 2 * (Bm_(1,1) * lv_(0,0)^2 - 2 * Bm_(0,1) * lv_(0,0) * lv_(1,0) + Bm_(0,0) * lv_(1,0)^2);
<< "at a: rank of the Hessian " << rank Ha << " ; dim ker " << numColumns TA << " ; a in ker: " << (Ha * am == 0) << " ; rank (a | V) = " << rank(am | V)
   << " ; degrees of Q_a, G: " << toString(first degree Qa, first degree G) << endl;
-- step 4: the 4-plane P_B through the odd eigenspace of iota (as mode B of ../pl1_count.m2), and its image under the
-- symmetry g: z_k -> z_(k+2), p_i -> p_(i+1), q_j -> q_(j+1)
evp = {{1,0,0,0,0,0,0,0,0},{0,1,1,0,0,0,0,0,0},{0,0,0,1,0,0,1,0,0},{0,0,0,0,1,0,0,0,1},{0,0,0,0,0,1,0,1,0}};
od = {{0,1,-1,0,0,0,0,0,0},{0,0,0,1,0,0,-1,0,0},{0,0,0,0,1,0,0,0,-1},{0,0,0,0,0,1,0,-1,0}};
Pv = kk[vv_0..vv_4]; Rt = Pv[tt_0..tt_4];
ptB = apply(9, k -> sum(4, j -> tt_j * od#j#k) + tt_4 * sum(5, i -> vv_i * evp#i#k));
FB = (a0 * hes(take(ptB, 3), lam) + hes(take(ptB, {3,5}), lam) + hes(take(ptB, {6,8}), lam)
     + sum flatten apply(3, i -> apply(3, j -> (take(ptB, 3))#((i+j)%3) * x#((i-j)%3) * (take(ptB, {3,5}))#i * (take(ptB, {6,8}))#j)));
IB = saturate ideal apply(flatten entries last coefficients FB, f -> lift(f, Pv));
LB = select(flatten entries gens gb IB, f -> first degree f == 1);
<< "the even point of P_B: scheme of dim " << dim IB - 1 << ", degree " << degree IB << " ; linear forms in its ideal: " << #LB << endl;
vB = flatten entries gens ker matrix(kk, apply(LB, f -> apply(5, i -> coefficient(Pv_i, f))));
PmB = transpose matrix(kk, od | {apply(9, k -> sum(5, i -> vB#i * evp#i#k))});            -- 9 x 5
use R;
gmap = map(R, R, {z_2, z_0, z_1, p_1, p_2, p_0, q_1, q_2, q_0});
Gm = transpose matrix(kk, apply(9, i -> apply(9, j -> coefficient(R_j, gmap R_i))));      -- candidate matrix of g on points
C5 = kk[c_0..c_4];
onY = Pm -> ((map(C5, R, flatten entries (sub(Pm, C5) * transpose vars C5))) F == 0);
Pm = Gm * PmB;
if not onY Pm then Pm = (transpose Gm) * PmB;
<< "g preserves F: " << (gmap F == F) << " ; P_B: rank " << rank PmB << ", inside Y: " << onY PmB << ", contains a: " << (rank(PmB | am) == 5)
   << ", meets P(ker Hess_a) in a line or more: " << (rank(PmB | TA) <= 6) << endl;
<< "P' = g(P_B): rank " << rank Pm << ", inside Y: " << onY Pm << ", contains a: " << (rank(Pm | am) == 5) << " ; dim of P_B n P' (projective): " << 9 - rank(PmB | Pm) << endl;
