-- Q4-Q6: two explicit 5-folds in the Pfaffian cubic sevenfold, their rulings at a point of S, and intersection numbers
-- on the cubic fourfold Y ∩ P^5.  MOD p.  Pre-registration: PREREG_k3.md.   usage: M2 --script pf2_cycles.m2 p seed
pp = value(scriptCommandLine#1); sd = value(scriptCommandLine#2);
setRandomSeed sd; kk = ZZ/pp;
R = kk[y_0..y_8];
L = new MutableHashTable; scan(6, i -> scan(6, j -> if i < j then L#(i,j) = random(1, R)));
M = matrix table(6, 6, (i,j) -> if i < j then L#(i,j) else if i > j then -L#(j,i) else 0_R);
F = (gens pfaffians(6, M))_(0,0);
IS = pfaffians(4, M);
-- Z'(V_5): rank of M restricted to the coordinate 5-space omitting index k is <= 2
dP = k -> ( idx := select(6, i -> i != k); trim pfaffians(4, submatrix(M, idx, idx)));
-- Z(K_3): the kernel of M meets the coordinate 3-space spanned by the columns cols
-- as a scheme, the 3x3 minors of the 6x3 block of columns (its top 3x3 block is skew, so the matrix is not generic) ; and as a variety,
-- by linkage: {kernel meets <e_a,e_b,e_c>} ∪ {kernel inside <e_a,e_b,e_c,e_d,e_e>} = Y ∩ {Pf_abcd = Pf_abce = 0}
-- (the 4x4 Pfaffians are the Pluecker coordinates of the kernel), so Z = (F, Pf_abcd, Pf_abce) : I_Z'(omit f).
pf4 = idx -> (gens pfaffians(4, submatrix(M, idx, idx)))_(0,0);
scMinors = cols -> saturate minors(3, submatrix(M, toList(0..5), cols));
sc = (cols, d, e, f) -> saturate(ideal(F, pf4 sort(cols | {d}), pf4 sort(cols | {e})) : dP f);
ZP = dP 5; ZP2 = dP 0; Z1 = sc({0,1,2}, 3, 4, 5); Z2 = sc({3,4,5}, 0, 1, 2);
Zm = scMinors {0,1,2};
<< "scheme of 3x3 minors of the 6x3 block: dim " << dim Zm - 1 << " degree " << degree Zm << " ; contains F: " << (F % Zm == 0)
   << " ; contained in the linked ideal: " << isSubset(Zm, Z1) << " ; equal: " << (Zm == Z1) << " ; radical of the minors scheme contains F (F^2 in it): " << (F^2 % Zm == 0) << endl << flush;
desc = (nm, Iz) -> (stdio << nm << ": dim " << dim Iz - 1 << " degree " << degree Iz << " ; generators by degree " << toString tally apply(flatten entries mingens Iz, f -> first degree f)
   << " ; F in ideal: " << (F % Iz == 0) << " ; contains S: " << (isSubset(Iz, IS)) << endl << flush;);
<< "Q4:" << endl; desc("  Z' (omit 5)", ZP); desc("  Z'_2 (omit 0)", ZP2); desc("  Z (cols 0,1,2)", Z1); desc("  Z_2 (cols 3,4,5)", Z2);
U = intersect(Z1, ZP);
CI = ideal(F, pf4 {0,1,2,3}, pf4 {0,1,2,4});
<< "  Z ∪ Z': degree " << degree U << " ; generators by degree " << toString tally apply(flatten entries mingens U, f -> first degree f)
   << " ; equals the complete intersection (F, Pf_0123, Pf_0124): " << (U == CI) << " (its degree " << degree CI << ", dim " << dim CI - 1 << ")" << endl << flush;
-- Q5: a rational point of S
found = false; cnt = 0;
while not found and cnt < 80 do ( cnt = cnt + 1;
    cps := decompose(IS + ideal(random(1, R), random(1, R)));
    r1 := select(cps, c -> degree c == 1);
    if #r1 > 0 then (found = true; cpt = first r1));
if not found then (<< "Q5: no rational point of S found in " << cnt << " sections" << endl) else (
    lin := select(flatten entries gens gb cpt, f -> first degree f == 1);
    pt := flatten entries gens ker matrix(kk, apply(lin, f -> apply(gens R, v -> coefficient(v, f))));
    ev := apply(9, i -> R_i => pt#i);
    Hp := lift(sub(jacobian transpose jacobian matrix{{F}}, ev), kk);
    tg := Iz -> gens ker transpose lift(sub(jacobian Iz, ev), kk);
    TS := tg IS;
    << "Q5: rational point of S after " << cnt << " sections ; rank M(p) = " << rank lift(sub(M, ev), kk) << " ; rank Hess F(p) = " << rank Hp << " ; dim T_pS (affine) = " << rank TS << endl;
    nm := {"Z", "Z_2", "Z'", "Z'_2"}; ids := {Z1, Z2, ZP, ZP2};
    Ts := apply(ids, tg);
    scan(4, i -> << "   T_p " << nm#i << ": affine dim " << rank Ts#i << " (6 = smooth 5-fold germ) ; contains T_pS: " << (rank(Ts#i | TS) == rank Ts#i)
        << " ; isotropic for Hess F(p): " << (transpose Ts#i * Hp * Ts#i == 0) << endl);
    scan({(0,1), (2,3), (0,2), (0,3), (1,2), (1,3)}, ij -> ( a := Ts#(ij#0); b := Ts#(ij#1);
        << "   " << nm#(ij#0) << " and " << nm#(ij#1) << ": projective dimension of the intersection of the tangent spaces = " << rank a + rank b - rank(a | b) - 1
           << " (3 or 5: same ruling ; 2 or 4: different rulings)" << endl << flush)));
-- Q6: intersection numbers on the cubic fourfold Y ∩ P^5
T = kk[t_0..t_5]; ph = map(T, R, apply(9, i -> random(1, T)));
F5 = ph F;
<< "Q6: Y ∩ P^5 smooth: " << (dim ideal jacobian matrix{{F5}} == 0) << endl;
s1 = ph Z1; s2 = ph Z2; d1 = ph ZP; d2 = ph ZP2;
scan({("sigma", s1), ("sigma_2", s2), ("D", d1), ("D_2", d2)}, x -> (stdio << "   " << x#0 << ": dim " << dim x#1 - 1 << " degree " << degree x#1
     << " ; Hilbert polynomial " << toString hilbertPolynomial(saturate x#1, Projective => false) << endl << flush;));
num = (a, b) -> ( Iab := saturate(a + b); (dim Iab - 1, degree Iab));
<< "   D.D_2 (dim, length) = " << num(d1, d2) << "   [13 predicted]" << endl << flush;
<< "   sigma.sigma_2 = " << num(s1, s2) << "   [21 predicted]" << endl << flush;
<< "   sigma.D = " << num(s1, d1) << " ; sigma.D_2 = " << num(s1, d2) << " ; sigma_2.D = " << num(s2, d1) << "   [7 predicted]" << endl << flush;
