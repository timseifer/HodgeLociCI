-- P4b: type B planes span(V-, v+) (V- = odd eigenspace of iota, a P^3 contained in every iota-invariant cubic), v+ in P(V+) = P^4;
--      and type A in all charts.  Pre-registration as in p4.m2.
pp = value(scriptCommandLine#1); sd = value(scriptCommandLine#2);
setRandomSeed sd; kk = ZZ/pp;
x = apply(3, i -> random kk); lam = random kk;
hes = (v, l) -> v#0^3+v#1^3+v#2^3 + 3*l*v#0*v#1*v#2;
a0 = - hes(x, lam) / (27*(1+lam^3));
ev = {{1,0,0,0,0,0,0,0,0},{0,1,1,0,0,0,0,0,0},{0,0,0,1,0,0,1,0,0},{0,0,0,0,1,0,0,0,1},{0,0,0,0,0,1,0,1,0}};
od = {{0,1,-1,0,0,0,0,0,0},{0,0,0,1,0,0,-1,0,0},{0,0,0,0,1,0,0,0,-1},{0,0,0,0,0,1,0,-1,0}};
Fof = (pt) -> ( zz := take(pt, 3); ps := take(pt, {3,5}); qs := take(pt, {6,8});
    a0 * hes(zz, lam) + hes(ps, lam) + hes(qs, lam) + sum flatten apply(3, i -> apply(3, j -> zz#((i+j)%3) * x#((i-j)%3) * ps#i * qs#j)));
-- type B: point = sum_j t_j od_j + t_4 * sum_i v_i ev_i
P = kk[v_0..v_4]; R = P[t_0..t_4];
pt = apply(9, k -> sum(4, j -> t_j * od#j#k) + t_4 * sum(5, i -> v_i * ev#i#k));
F = Fof pt; (mons, cf) = coefficients F;
I = ideal apply(flatten entries cf, f -> lift(f, P));
Is = saturate I;
<< "type B: #equations " << numgens I << " ; projective solution set in P^4: dim " << dim Is - 1 << " degree " << (if dim Is > 0 then degree Is else 0) << endl << flush;
-- restriction of F to V- alone
<< "F vanishes on P(V-): " << (sub(F, {t_4 => 0}) == 0) << endl;
-- type A in homogeneous form: 4-dim subspace of V+ = kernel of the linear form c on V+; line in V- spanned by d
P2 = kk[c_0..c_4, d_0..d_3, Degrees => {5:{1,0}, 4:{0,1}}];
-- parametrize ker(c) by wedge: use charts c_m = 1
scan(5, m -> scan(4, n -> (
    Pm := kk[kc_0..kc_4, ee_0..ee_3]; Rm := Pm[s_0..s_4];
    others := select(5, i -> i != m);
    cs := apply(5, i -> if i == m then 1_Pm else kc_i); ds := apply(4, j -> if j == n then 1_Pm else ee_j);
    ptA := apply(9, k -> sum(4, a -> (i := others#a; s_a * (ev#i#k - cs#i * ev#m#k))) + s_4 * sum(4, j -> ds#j * od#j#k));
    FA := Fof ptA; (mo, cfa) := coefficients FA;
    IA := ideal apply(flatten entries cfa, f -> lift(f, Pm)) + ideal(kc_m, ee_n);
    if IA != ideal(1_Pm) then << "type A chart (" << m << "," << n << "): solutions: dim " << dim IA << " degree " << degree IA << endl << flush)));
<< "type A scan done" << endl;
-- examine the type B plane: find v+, then intersect the plane with Sing(Y)
use P;
vsol = apply(5, i -> v_i % Is);
<< "v+ normal forms: " << vsol << endl;
S9 = kk[z_0..z_2, p_0..p_2, q_0..q_2];
Z = {z_0,z_1,z_2}; Pv = {p_0,p_1,p_2}; Qv = {q_0,q_1,q_2};
F9 = a0 * hes(Z, lam) + hes(Pv, lam) + hes(Qv, lam) + sum flatten apply(3, i -> apply(3, j -> Z#((i+j)%3) * x#((i-j)%3) * Pv#i * Qv#j));
-- solve for v+: the saturated ideal is a point: its linear generators
L = select(flatten entries gens gb Is, f -> first degree f == 1);
Mv = matrix(kk, apply(L, f -> apply(5, i -> coefficient(v_i, f))));
vv = flatten entries gens ker Mv;
<< "v+ = " << vv << endl;
rows = od | {apply(9, k -> sum(5, i -> vv#i * ev#i#k))};
Lin = gens ker matrix(kk, rows);
IL = ideal((vars S9) * sub(Lin, S9));
<< "F vanishes on the plane: " << (F9 % IL == 0) << endl;
Ising = saturate ideal jacobian matrix{{F9}};
C = saturate(Ising + IL);
<< "plane ∩ Sing(Y): dim " << dim C - 1 << " degree " << degree C << " ; Hilbert polynomial " << toString hilbertPolynomial(C, Projective => false) << endl;
-- tangent space to the Fano scheme of 4-planes at this plane: H^0(N) = {4 linear forms' worth of first-order moves keeping F = 0}
Rpl = S9/IL;
-- N_{plane/Y}: sections = Hom(I_L/I_L^2, O)(...) with F condition: phi in (Rpl_1)^4 with sum phi_i * dF/dl_i = 0 on the plane
lf = flatten entries ((vars S9) * sub(Lin, S9));       -- the 4 linear forms l_i
-- write F = sum l_i Q_i ; Q_i restricted to the plane
Qc = F9 // matrix{lf};
Qr = sub(Qc, Rpl);
K = ker map(Rpl^{3}, Rpl^{4:1}, transpose Qr);
<< "dim H^0(N_{P^4/Y}) (degree-0 part of the kernel, i.e. linear-form coefficients): " << hilbertFunction(0, K) << endl;
