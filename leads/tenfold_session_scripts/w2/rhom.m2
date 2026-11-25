-- W2: first-order deformations of V_R = J(Pi, R) in the Fermat cubic tenfold (MOD 32029); R = {rank[f;h]<=1, sum h^3 = 0}
-- (adapted from checks/exp_t6/v0hom.m2)
pr = s -> (stderr << s << endl << flush);
p = 32029; kk = ZZ/p; S = kk[x_0..x_11]; z = 31556_kk;
pr("z^2 - z + 1 = " | toString(z^2 - z + 1));
F = sum(12, i -> x_i^3);
f = apply(3, k -> x_(6+2*k) - z*x_(7+2*k)); h = apply(3, k -> x_(6+2*k) + x_(7+2*k));
lin8 = ideal apply(3, k -> x_(2*k) - z*x_(2*k+1));
IR = saturate(minors(2, matrix{f, h}) + ideal(sum(h, t -> t^3)), ideal(f) * ideal(h));
I = trim(lin8 + IR);
pr("V_R: dim " | toString(dim I - 1) | " degree " | toString(degree I) | "; F in I: " | toString(F % I == 0) | "; gens degrees " | toString flatten degrees gens I);
t0 = cpuTime();
Hm = Hom(module I, S^1/I);
B0 = basis(0, Hm);
pr("Hom_0 dim = " | toString numColumns B0 | "  time " | toString(cpuTime() - t0));
g = gens I; c = F // g;
polys = flatten entries super basis(3, I);
nH = numColumns B0;
for j from 0 to nH-1 do (
   phi := homomorphism(B0_{j});
   q := (lift((matrix phi) * c, S))_(0,0);
   q3 := sum(select(terms q, t -> first degree t == 3));
   if q3 != 0 then polys = append(polys, q3));
JS1 = flatten entries ((jacobian matrix{{F}}) * vars S);
m3 = basis(3, S); cf = M -> lift(last coefficients(M, Monomials => m3), kk);
r0 = rank cf(matrix{flatten entries super basis(3, I) | JS1}); r1 = rank cf(matrix{polys | JS1});
pr("codim of {X containing V_R} without V-moduli = " | toString(364 - r0) | ";  WITH Hom_0 = " | toString(364 - r1));
mons = apply(lines get "mons.txt", l -> (e := apply(separate(" ", l), value); product(12, i -> x_i^(e#i))));
out = openOut "TVR.txt";
for q in polys do (
   (M, C) := coefficients(q, Monomials => matrix{mons});
   out << demark(" ", apply(flatten entries lift(C, kk), a -> toString(lift(a, ZZ)))) << endl);
close out;
pr("written");
