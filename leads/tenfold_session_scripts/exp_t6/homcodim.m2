-- EXP-T6 (iii-b): family codim in moduli including moduli of V, via Hom(I_V, S/I_V)_0 (MOD p)
pr = s -> (stderr << s << endl << flush);
p = 32003; kk = ZZ/p; S = kk[x_0..x_11];
setRandomSeed(value scriptCommandLine#1); typ = scriptCommandLine#2;
I0 = (if typ == "J2T" then (
      R5 := kk[y_0..y_5]; f := {y_0,y_1,y_2}; hh := {y_3,y_4,y_5};
      qs := apply(3, k -> (Nk := random(kk^3, kk^3); sum flatten apply(3, i -> apply(3, j -> Nk_(i,j) * f#i * hh#j))));
      IT := saturate(ideal qs : intersect(ideal f, ideal hh));
      gg := map(R5, R5, random(R5^1, R5^{6:-1})); IT = gg IT;
      (map(S, R5, {x_0,x_1,x_2,x_3,x_4,x_5})) IT + ideal(x_9, x_10, x_11))
   else if typ == "J2Sp" then (
      T := kk[t_0..t_8]; I := minors(2, genericMatrix(T, t_0, 3, 3)) + ideal random(T^1, T^{2:-1});
      g := map(T, T, random(T^1, T^{9:-1})); J := eliminate(toList(T_6..T_8), g I);
      (map(S, T, {x_0,x_1,x_2,x_3,x_4,x_5,0,0,0})) J + ideal(x_9, x_10, x_11))
   else if typ == "P2P2" then minors(2, genericMatrix(S, x_0, 3, 3)) + ideal(x_10, x_11)
   else error "type");
I = trim (map(S, S, random(S^1, S^{12:-1}))) I0;
pr("type " | typ | ": dim " | toString(dim I - 1) | " degree " | toString(degree I));
B3 = super basis(3, I);
F = (B3 * random(kk^(numColumns B3), kk^1))_(0,0);
t0 = cpuTime();
Hm = Hom(module I, S^1/I); B0 = basis(0, Hm);
pr("Hom_0 dim = " | toString numColumns B0 | "  time " | toString(cpuTime() - t0));
g = gens I; c = F // g;
polys = flatten entries B3;
for j from 0 to numColumns B0 - 1 do (
   phi := homomorphism(B0_{j}); q := (lift((matrix phi) * c, S))_(0,0);
   q3 := sum(select(terms q, t -> first degree t == 3)); if q3 != 0 then polys = append(polys, q3));
JS1 = flatten entries ((jacobian matrix{{F}}) * vars S);
m3 = basis(3, S); cf = M -> lift(last coefficients(M, Monomials => m3), kk);
r0 = rank cf(matrix{flatten entries B3 | JS1}); r1 = rank cf(matrix{polys | JS1});
pr("codim without V-moduli = " | toString(364 - r0) | ";  WITH Hom_0 (true tangent of the family image) = " | toString(364 - r1));
