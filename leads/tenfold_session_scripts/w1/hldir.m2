-- W1 (b): the extra Hodge-tangent direction at X in F_T (nice coordinates: P^8 = {x9=x10=x11=0}, vertex x6,x7,x8, T in x0..x5)
pr = s -> (stderr << s << endl << flush);
p = 32003; kk = ZZ/p; S = kk[x_0..x_11];
setRandomSeed(value scriptCommandLine#1); typ = scriptCommandLine#2;
load "/home/claude/hodge/discovery/checks/w1/w1lib.m2";
I = trim w1cycle(typ);
B3 = super basis(3, I);
F = (B3 * random(kk^(numColumns B3), kk^1))_(0,0);
J = ideal jacobian matrix{{F}};
IJ = ideal gens gb (I + J);
pr("dim(I_V + J_F) (0 => X smooth along V) = " | toString dim IJ);
m3 = basis(3, S); cf = M -> lift(last coefficients(M, Monomials => m3), kk);
-- pairing matrix
A = S/IJ; bt = lift(basis(6, A), S); pr("m = " | toString numColumns bt);
B6 = basis(6, S); NF = B6 % IJ; C = lift(last coefficients(NF, Monomials => bt), kk);
idx = new MutableHashTable; mons = flatten entries B6; scan(#mons, i -> idx#(mons#i) = i);
L3 = flatten entries m3; v = flatten entries C^{0};
P = matrix table(#L3, #L3, (i,j) -> v_(idx#(L3#i * L3#j)));
KP = gens ker P; pr("dim T NL = " | toString numColumns KP | " codim " | toString(364 - numColumns KP));
-- tangent of the family
Hm = Hom(module I, S^1/I); B0 = basis(0, Hm);
g = gens I; c = F // g; polys = flatten entries B3;
for j from 0 to numColumns B0 - 1 do (
   phi := homomorphism(B0_{j}); q := (lift((matrix phi) * c, S))_(0,0);
   q3 := sum(select(terms q, t -> first degree t == 3)); if q3 != 0 then polys = append(polys, q3));
JS1 = flatten entries ((jacobian matrix{{F}}) * vars S);
TF = cf(matrix{polys | JS1});   -- 364 x N
rTF = rank TF; pr("rank T F_T = " | toString rTF | " codim " | toString(364 - rTF));
rBoth = rank(TF | KP); pr("rank(T F_T + T NL) = " | toString rBoth | "  (T F_T inside T NL iff = dim T NL)");
-- membership tests of the extra direction class: is T NL inside T F_T + Y for subspaces Y
w = {x_0,x_1,x_2,x_3,x_4,x_5}; y = {x_6,x_7,x_8}; u = {x_9,x_10,x_11};
monsOf = (Lsub, d) -> flatten entries basis(d, kk[Lsub]);
sub3 = L -> cf(matrix{L});
degIn = (mono, V) -> sum(V, x -> degree(x, mono));
Y0 = select(L3, mo -> degIn(mo, w) == 3);
Y1 = select(L3, mo -> degIn(mo, w) == 2 and degIn(mo, y) == 1);
Y2 = select(L3, mo -> degIn(mo, w) == 1 and degIn(mo, y) == 2);
Y3 = select(L3, mo -> degIn(mo, y) == 3);
for pair in {("w^3", Y0), ("y w^2", Y1), ("y^2 w", Y2), ("y^3", Y3)} do (
   M := TF | sub3(pair#1);
   pr("T NL in T F_T + <" | pair#0 | ">: " | toString(rank(M | KP) == rank M)));
-- the y-linear part: q_k such that sum y_k q_k is in T NL mod T F_T
"/home/claude/hodge/discovery/checks/w1/hldir_" | typ | "_" | scriptCommandLine#1 | ".txt" << toString {F, KP} << close;
