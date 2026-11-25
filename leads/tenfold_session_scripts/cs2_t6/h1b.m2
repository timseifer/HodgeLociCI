-- H1 partial: at X in A, compare T_f (image for V'), T F_T (image for the elliptic cone R'), T NL([V']). usage seed p H1
-- CS2-T6 type H (AMENDMENT 05:02Z). usage: M2 --script h1.m2 seed p typ
-- H3a: X random containing V' = J(Pi, S') (dP6 cone of type A); R' = residual of V' in X n P^8 n (q1, q2), q_i in I_S'(2): mirror of D-R22 at A points
-- H2b: Z = J(e_8, Y), Y = generic projection to P^7 (x0..x7) of the Segre P^2 x P^2 (non-cone over S'; degenerates to J(Pi,S')); Z in P^8
-- H0 : control, Z = V' itself (type A numbers: Hom_0 87, codim 55, Hodge tangent 50)
pr = s -> (stderr << s << endl << flush);
BR = 1500; sd = value scriptCommandLine#1; p = value scriptCommandLine#2; typ = scriptCommandLine#3;
kk = ZZ/p; S = kk[x_0..x_11]; setRandomSeed(sd);
load "/home/claude/hodge/discovery/checks/w1/w1lib.m2"; load "/home/claude/hodge/discovery/checks/cs2_t6/cslibS2p.m2";
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
   if false then IZ = IVp else (
      qS := select(flatten entries mingens IVp, g -> first degree g == 2 and g % w == g);
      pr("quadrics in I_S'(2): " | toString(#qS));
      qq := () -> sum(qS, g -> random(kk) * g);
      CI := ideal(F, qq(), qq()) + u;
      IZ = trim saturate(CI : IVp);
      pr("R': dim(R' n V') = " | toString(dim(IZ + IVp) - 1) | " deg " | toString degree(IZ + IVp));
      R5b := kk[z_0..z_5]; ));
J = ideal jacobian matrix{{F}};
m3 = basis(3, S); cf = M -> lift(last coefficients(M, Monomials => m3), kk);
csCodimPkS2(F, IVp, 8, BR); Tf = cf matrix{csLastPolys};
csCodimPkS2(F, IZ, 8, BR); TF = cf matrix{csLastPolys};
G6 = gb(IVp + J, DegreeLimit => 6); LT = ideal leadTerm gens G6; bt = lift(basis(6, S/LT), S);
B6 = basis(6, S); mons = flatten entries B6; idx = new MutableHashTable; scan(#mons, i -> idx#(mons#i) = i);
L3 = flatten entries m3; Cm = lift(last coefficients(B6 % G6, Monomials => bt), kk); v = flatten entries Cm^{0};
P = matrix table(#L3, #L3, (a,b) -> v_(idx#(L3#a * L3#b)));   -- pairing: G in T NL iff P * coeff(G) = 0
rk = M -> rank mutableMatrix M;
rf = rk Tf; rF = rk TF; rs = rk(Tf | TF);
pr("rank T_f = " | toString rf | ", rank T F_T = " | toString rF | ", rank sum = " | toString rs | ", rank T NL = " | toString(364 - rk P));
pr("P*T_f = 0: " | toString(rk(P * Tf) == 0) | "; P*T F_T = 0: " | toString(rk(P * TF) == 0));
pr("RESULT H1 seed " | toString sd | " p " | toString p | ": dim (T_f + T F_T)/T_f = " | toString(rs - rf) | " inside E = T NL/T_f of dim " | toString(364 - rk P - rf));
