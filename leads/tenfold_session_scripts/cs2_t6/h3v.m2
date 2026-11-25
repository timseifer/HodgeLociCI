-- vertex of a cone: {p in P^8 : D_p(g) in I for all generators g}. usage: M2 --script h3v.m2 seed p typ (same constructions as h1.m2)
-- CS2-T6 type H (AMENDMENT 05:02Z). usage: M2 --script h1.m2 seed p typ
-- H3a: X random containing V' = J(Pi, S') (dP6 cone of type A); R' = residual of V' in X n P^8 n (q1, q2), q_i in I_S'(2): mirror of D-R22 at A points
-- H2b: Z = J(e_8, Y), Y = generic projection to P^7 (x0..x7) of the Segre P^2 x P^2 (non-cone over S'; degenerates to J(Pi,S')); Z in P^8
-- H0 : control, Z = V' itself (type A numbers: Hom_0 87, codim 55, Hodge tangent 50)
pr = s -> (stderr << s << endl << flush);
BR = 1500; sd = value scriptCommandLine#1; p = value scriptCommandLine#2; typ = scriptCommandLine#3;
kk = ZZ/p; S = kk[x_0..x_11]; setRandomSeed(sd);
load "/home/claude/hodge/discovery/checks/w1/w1lib.m2"; load "/home/claude/hodge/discovery/checks/cs2_t6/cslibS2.m2";
u = ideal(x_9, x_10, x_11); w = ideal(x_6..x_11);
if typ == "H2b" then (
   R9 := kk[y_0..y_8]; Seg := minors(2, genericMatrix(R9, y_0, 3, 3));
   A := random(kk^8, kk^9); R8 := kk[z_0..z_7];
   IY := ker map(R9/Seg, R8, apply(8, k -> sum(9, j -> A_(k,j) * y_j)));
   IZ = trim((map(S, R8, {x_0,x_1,x_2,x_3,x_4,x_5,x_6,x_7})) IY + u);
   pr("Y: dim " | toString(dim IY - 1) | " degree " | toString degree IY | " HF 0..3 " | toString apply(4, i -> numColumns basis(i, R8/IY)));
   B3 := super basis(3, IZ); F = (B3 * random(kk^(numColumns B3), kk^1))_(0,0);
   ) else (
   (R5, IT0) := w1T(); IT := (map(S, R5, {x_0,x_1,x_2,x_3,x_4,x_5})) IT0;
   q2s := select(flatten entries mingens IT, g -> first degree g == 2); c3s := flatten entries super basis(3, IT);
   rq := () -> sum(q2s, g -> random(kk) * g); rc := () -> sum(c3s, g -> random(kk) * g);
   IS := trim ((ideal(rq(), rq(), rc()) + w) : (IT + w));
   IVp := trim(ideal((gens trim(IS + w)) % w) + u);
   pr("V': dim " | toString(dim IVp - 1) | " deg " | toString degree IVp);
   B3 := super basis(3, IVp); F = (B3 * random(kk^(numColumns B3), kk^1))_(0,0);
   if typ == "H0" then IZ = IVp else (
      qS := select(flatten entries mingens IVp, g -> first degree g == 2 and g % w == g);
      pr("quadrics in I_S'(2): " | toString(#qS));
      qq := () -> sum(qS, g -> random(kk) * g);
      CI := ideal(F, qq(), qq()) + u;
      IZ = trim saturate(CI : IVp);
      pr("R': dim(R' n V') = " | toString(dim(IZ + IVp) - 1) | " deg " | toString degree(IZ + IVp));
      R5b := kk[z_0..z_5]; ));
gs = select(flatten entries mingens IZ, g -> first degree g >= 2); G0 = gb IZ;
D = apply(9, i -> matrix{apply(gs, g -> diff(x_i, g) % G0)});
mons = matrix{sort unique flatten apply(9, i -> flatten entries monomials D#i)};
cols = apply(9, i -> (c := lift(last coefficients(D#i, Monomials => mons), kk); matrix{flatten entries c}));
Cm = transpose fold((a, b) -> a || b, cols);
pr("vertex (linear space of translation-invariance) projective dim: " | toString(9 - rank Cm - 1));
Kv = gens ker Cm; pr("vertex basis cols " | toString numColumns Kv);
-- change coordinates: send vertex to x6..x8, base surface T'' in a complementary P^5 = x0..x5
Bfull = Kv | random(kk^9, kk^6); Ainv = inverse Bfull;   -- new coords y = Ainv * x ; vertex = first 3 new coords
newx = flatten entries (Bfull * transpose matrix{{x_6,x_7,x_8,x_0,x_1,x_2,x_3,x_4,x_5}});
phi = map(S, S, newx | {x_9,x_10,x_11});
IZn = trim phi IZ;
pr("after change: generators involving x6..x8: " | toString(#select(flatten entries mingens IZn, g -> any({x_6,x_7,x_8}, v -> diff(v, g) != 0))));
P5 = kk[z_0..z_5]; ITn = trim (map(P5, S, {z_0,z_1,z_2,z_3,z_4,z_5,0,0,0,0,0,0})) IZn;
pr("T'': dim " | toString(dim ITn - 1) | " degree " | toString degree ITn | " HP " | toString hilbertPolynomial(ITn, Projective => false) | " genus-type: mingens " | toString tally apply(flatten entries mingens ITn, g -> first degree g));
sg = ITn + minors(3, jacobian ITn); pr("Sing T'': dim " | toString(dim sg - 1) | " degree " | toString degree sg);
pr("components of T'': " | toString apply(decompose ITn, P -> (dim P - 1, degree P)));
q3 = select(flatten entries mingens ITn, g -> first degree g == 2); resd = saturate(ideal q3 : ITn);
pr("residual of T'' in its 3 quadrics: dim " | toString(dim resd - 1) | " degree " | toString degree resd | " components " | toString apply(decompose resd, P -> (dim P - 1, degree P, numColumns super basis(1, P))));
pr("CHECK " | typ | " seed " | toString sd | " p " | toString p);
