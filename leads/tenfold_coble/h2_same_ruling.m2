-- H3/H3b: two 4-planes of the family through a common point of A: same ruling of the tangent cone or not.  MOD p.
-- Pre-registration: PREREG_step1.md (H3, H3b).   usage: M2 --script h2_same_ruling.m2 p seed
pp = value(scriptCommandLine#1); sd = value(scriptCommandLine#2);
setRandomSeed sd; kk = ZZ/pp;
x = apply(3, i -> random kk); lam = random kk;
hes = (v, l) -> v#0^3+v#1^3+v#2^3 + 3*l*v#0*v#1*v#2;
a0 = - hes(x, lam) / (27*(1+lam^3));
ev = {{1,0,0,0,0,0,0,0,0},{0,1,1,0,0,0,0,0,0},{0,0,0,1,0,0,1,0,0},{0,0,0,0,1,0,0,0,1},{0,0,0,0,0,1,0,1,0}};
od = {{0,1,-1,0,0,0,0,0,0},{0,0,0,1,0,0,-1,0,0},{0,0,0,0,1,0,0,0,-1},{0,0,0,0,0,1,0,-1,0}};
Fof = (pt) -> ( zz := take(pt, 3); ps := take(pt, {3,5}); qs := take(pt, {6,8});
    a0 * hes(zz, lam) + hes(ps, lam) + hes(qs, lam) + sum flatten apply(3, i -> apply(3, j -> zz#((i+j)%3) * x#((i-j)%3) * ps#i * qs#j)));
-- the iota-invariant plane of type B (as in p4b)
P = kk[v_0..v_4]; Rt = P[t_0..t_4];
pt = apply(9, k -> sum(4, j -> t_j * od#j#k) + t_4 * sum(5, i -> v_i * ev#i#k));
(mons, cf) = coefficients Fof pt;
Is = saturate ideal apply(flatten entries cf, f -> lift(f, P));
L = select(flatten entries gens gb Is, f -> first degree f == 1);
vv = flatten entries gens ker matrix(kk, apply(L, f -> apply(5, i -> coefficient(v_i, f))));
<< "type B plane: solution set dim " << dim Is - 1 << " degree " << degree Is << " ; v+ = " << vv << endl;
rowsP = matrix(kk, od | {apply(9, k -> sum(5, i -> vv#i * ev#i#k))});          -- 5 x 9, rows span the plane P
S9 = kk[z_0..z_2, p_0..p_2, q_0..q_2];
Z = {z_0,z_1,z_2}; Pv = {p_0,p_1,p_2}; Qv = {q_0,q_1,q_2};
F9 = a0 * hes(Z, lam) + hes(Pv, lam) + hes(Qv, lam) + sum flatten apply(3, i -> apply(3, j -> Z#((i+j)%3) * x#((i-j)%3) * Pv#i * Qv#j));
-- automorphisms: sigma: z_k -> z_{k+2}, p_i -> p_{i+1}, q_j -> q_{j+1}   (as a substitution of variables)
sg = map(S9, S9, {z_2, z_0, z_1, p_1, p_2, p_0, q_1, q_2, q_0});
<< "sigma preserves F: " << (sg F9 == F9) << endl;
-- action on points: a point c (coordinates) goes to the point c' with F(c') = F(c): c'_(variable sg maps v to) ...
-- use the pull-back of linear forms instead: plane P = {linear forms = 0}; gP = {sg^-1 forms = 0}.  Any g works, so use sg on forms.
formsOf = rows -> flatten entries ((vars S9) * sub(gens ker rows, S9));
lfP = formsOf rowsP; IP = ideal lfP;
<< "F vanishes on P: " << (F9 % IP == 0) << endl;
Isg = saturate ideal jacobian matrix{{F9}};
scan({1, 2}, e -> (
    g := if e == 1 then sg else sg*sg;
    IgP := ideal apply(lfP, f -> g f);
    << "g = sigma^" << e << " : F vanishes on gP: " << (F9 % IgP == 0) << " ; gP = P: " << (IgP == IP) << endl;
    Icap := IP + IgP;
    << "   H3: projective dimension of P ∩ gP = " << dim Icap - 1 << " (degree " << degree Icap << ")" << endl;
    C := saturate(Icap + Isg);
    << "   (P ∩ gP) ∩ A: dim " << dim C - 1 << " degree " << degree C << endl << flush;
    -- H3b at the points of (P ∩ gP) ∩ A: parametrize the line, find the two points (over kk or a quadratic extension)
    Mcap := matrix(kk, apply(flatten entries gens Icap, f -> apply(gens S9, v -> coefficient(v, f))));
    U := gens ker Mcap;                                   -- 9 x 2: the line
    T := kk[s];
    ptT := flatten entries (sub(U, T) * matrix{{T_0},{1_T}});
    gs := gcd apply(flatten entries gens Isg, f -> sub(f, apply(9, i -> S9_i => ptT#i)));
    << "   the line meets A where " << toString gs << " = 0 ; factors: " << toString factor gs << endl;
    fs := apply(toList factor gs, w -> w#0);
    fs = select(fs, w -> first degree w > 0);
    scan(fs, w -> (
        K := if first degree w == 1 then kk else toField(T/ideal w);
        s0 := if first degree w == 1 then - coefficient(1_T, w) / coefficient(T_0, w) else sub(T_0, K);
        pcoord := flatten entries (sub(U, K) * matrix{{s0},{1_K}});
        SK := K[z_0..z_2, p_0..p_2, q_0..q_2];
        FK := sub(F9, SK);
        ev9 := apply(9, i -> SK_i => pcoord#i);
        Hs := lift(sub(jacobian transpose jacobian matrix{{FK}}, ev9), K);
        JA := lift(sub(jacobian sub(Isg, SK), ev9), K);
        TA := gens ker transpose JA;
        rP := transpose sub(rowsP, K);
        lfg := apply(lfP, f -> g f);
        Mg := matrix(kk, apply(lfg, f -> apply(gens S9, v -> coefficient(v, f))));
        rG := sub(gens ker Mg, K);
        L1 := rP | TA; L2 := rG | TA;
        B1 := mingens image L1; B2 := mingens image L2;
        << "   H3b at a point of degree " << first degree w << ": rank Hess = " << rank Hs << " ; dim T_pA = " << rank TA
           << " ; dim span(P,TA) = " << rank L1 << " ; dim span(gP,TA) = " << rank L2
           << " ; isotropic for the tangent cone: " << (transpose B1 * Hs * B1 == 0) << " " << (transpose B2 * Hs * B2 == 0)
           << " ; affine dim of the intersection of the spans = " << rank L1 + rank L2 - rank(L1 | L2)
           << " (4 = same ruling, 5 = different)" << endl << flush;
        ));
    ));
