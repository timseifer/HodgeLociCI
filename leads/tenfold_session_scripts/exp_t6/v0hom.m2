-- EXP-T6 (v-c): first-order deformations of V0 = J(Pi, Pi1' u Q2 u E) in the Fermat cubic tenfold (MOD 32029)
pr = s -> (stderr << s << endl << flush);
p = 32029; kk = ZZ/p; S = kk[x_0..x_11]; z = 31556_kk;
setRandomSeed(value scriptCommandLine#1);
F = sum(12, i -> x_i^3);
f = apply(3, k -> x_(6+2*k) - z*x_(7+2*k)); h = apply(3, k -> x_(6+2*k) + x_(7+2*k));
lin8 = ideal apply(3, k -> x_(2*k) - z*x_(2*k+1));
G = sum(6, i -> x_(6+i)^3);
Pi1 = ideal f; Pi2 = ideal h;
rc = () -> sum(3, k -> random(kk) * h#k);
P3 = ideal(rc(), rc());
Q2 = saturate(ideal(G) + P3, Pi2);
y = toList(x_6..x_11); rly = () -> sum(y, v -> random(kk) * v);
Ecs = ideal(G, rly(), rly());
IS = intersect(Pi1, Q2, Ecs);
I = trim(lin8 + IS);
pr("V0: dim " | toString(dim I - 1) | " degree " | toString(degree I) | "; F in I: " | toString(F % I == 0));
t0 = cpuTime();
Hm = Hom(module I, S^1/I);
B0 = basis(0, Hm);
pr("Hom_0 dim = " | toString numColumns B0 | "  time " | toString(cpuTime() - t0));
-- apply each phi to F: F = sum c_i g_i
g = gens I; c = F // g;  -- F = g * c
polys = flatten entries super basis(3, I);
nH = numColumns B0;
for j from 0 to nH-1 do (
   phi := homomorphism(B0_{j});
   im := lift((matrix phi) * c, S);   -- 1x1
   q := im_(0,0);
   q3 := sum(select(terms q, t -> first degree t == 3));
   if q3 =!= 0_S and q3 != 0 then polys = append(polys, q3));
pr("generators: " | toString(#polys));
mons = apply(lines get "mons.txt", l -> (e := apply(separate(" ", l), value); product(12, i -> x_i^(e#i))));
out = openOut ("TV0_" | scriptCommandLine#1 | ".txt");
for q in polys do (
   (M, C) := coefficients(q, Monomials => matrix{mons});
   out << demark(" ", apply(flatten entries lift(C, kk), a -> toString(lift(a, ZZ)))) << endl);
close out;
pr("written");
