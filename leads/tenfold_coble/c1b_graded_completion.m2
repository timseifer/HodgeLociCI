-- C1b: same as C1 but with a sigma-graded completion: F8 = M(z,p,q) + e1(p) + e2(q), Phi_k = conics in z only.
-- Pre-registration: the 3-dim extra kernel splits into sigma-eigenspaces (weights: z 0, p 1, q 2 mod 3).
--   The two tensor-moduli directions have character 0.  Outcome A: G_e has character 0 (then it is a combination of
--   tensor directions and cubics in z, in p, in q).  Outcome B: character 1 or 2 (then G_e breaks the mu_3 symmetry).
sd = value(scriptCommandLine#2); pp = value(scriptCommandLine#1);
setRandomSeed sd;
kk = ZZ/pp;
R = kk[z_0..z_2, p_0..p_2, q_0..q_2];
zz = {z_0,z_1,z_2}; ps = {p_0,p_1,p_2}; qs = {q_0,q_1,q_2};
T = apply(3, k -> random(kk^3, kk^3));
Qk = apply(3, k -> (matrix{ps} * T#k * transpose matrix{qs})_(0,0));
Mtri = sum(3, k -> zz#k * Qk#k);
e1 = det matrix apply(3, k -> apply(3, j -> sum(3, i -> (T#k)_(i,j) * ps#i)));
e2 = det matrix apply(3, k -> apply(3, i -> sum(3, j -> (T#k)_(i,j) * qs#j)));
e0 = det matrix apply(3, i -> apply(3, j -> sum(3, k -> (T#k)_(i,j) * zz#k)));
IV = ideal(Qk | {e1, e2});
F8 = Mtri + random(kk)*e1 + random(kk)*e2;
Rz = kk[z_0..z_2]; Phi = apply(3, k -> sub(random(2, Rz), R)); use R;
dF = apply(gens R, v -> diff(v, F8));
I = IV + ideal(drop(dF, 3)) + ideal Phi;
G = gb(I, DegreeLimit => 7);
A = R/I;
<< "HF of A, d=0..7: " << apply(toList(0..7), d -> hilbertFunction(d, A)) << endl << flush;
b6 = basis(6, A); b3 = basis(3, A);
B6 = basis(6, R); NF = B6 % G; mons6 = flatten entries B6;
s6 = lift(b6_(0,0), R);
dl = flatten entries lift(last coefficients(NF, Monomials => matrix{{s6}}), kk);
idx = new MutableHashTable; scan(#mons6, i -> idx#(mons6#i) = i);
m3 = flatten entries basis(3, R);
PM = matrix(kk, apply(m3, a -> apply(m3, b -> dl#(idx#(a*b)))));
<< "pairing rank on S_3 = " << rank PM << endl << flush;
cf = f -> lift(last coefficients(matrix{{f}}, Monomials => matrix{m3}), kk);
inker = f -> (PM * cf f) == 0;
<< "e0(z) in kernel: " << inker e0 << endl;
K = gens ker PM; Kpol = (matrix{m3}) * K;
KC = lift(last coefficients(sub(Kpol, A), Monomials => b3), kk);
<< "dim kernel = " << numColumns K << " ; rank of kernel in A_3 = " << rank KC << endl << flush;
chr = m -> (e := first exponents m; (e#3+e#4+e#5 + 2*(e#6+e#7+e#8)) % 3);
scan(3, c -> (ms := select(m3, m -> chr m == c); BC := lift(last coefficients(sub(matrix{ms}, A), Monomials => b3), kk);
   << "character " << c << ": #mons " << #ms << " rank in A_3 " << rank BC << "  ∩ kernel/I3: " << rank KC + rank BC - rank(KC|BC) << endl << flush));
blocks = new MutableHashTable;
scan(m3, m -> (e := first exponents m; w := (e#0+e#1+e#2, e#3+e#4+e#5, e#6+e#7+e#8); if not blocks#?w then blocks#w = {}; blocks#w = append(blocks#w, m)));
bl = w -> lift(last coefficients(sub(matrix{blocks#w}, A), Monomials => b3), kk);
scan(sort keys blocks, w -> (BC := bl w; << "block " << w << ": rank in A_3 " << rank BC << "  ∩ kernel/I3: " << rank KC + rank BC - rank(KC|BC) << endl));
c0 = bl(1,1,1) | bl(3,0,0) | bl(0,3,0) | bl(0,0,3);
<< "char-0 pieces: tensors+z3 ∩ ker: " << rank KC + rank(bl(1,1,1)|bl(3,0,0)) - rank(KC|bl(1,1,1)|bl(3,0,0))
   << " ; tensors+p3+q3 ∩ ker: " << rank KC + rank(bl(1,1,1)|bl(0,3,0)|bl(0,0,3)) - rank(KC|bl(1,1,1)|bl(0,3,0)|bl(0,0,3))
   << " ; tensors only: " << rank KC + rank(bl(1,1,1)) - rank(KC|bl(1,1,1)) << endl;
c1 = bl(2,1,0) | bl(0,2,1) | bl(1,0,2);
scan({{(2,1,0),(0,2,1)},{(2,1,0),(1,0,2)},{(0,2,1),(1,0,2)},{(2,1,0)},{(0,2,1)},{(1,0,2)}}, L -> (BC := fold((a,b)->a|b, apply(L, bl)); << "  char-1 sub-blocks " << L << " ∩ ker: " << rank KC + rank BC - rank(KC|BC) << endl));
scan({{(2,0,1),(1,2,0)},{(2,0,1),(0,1,2)},{(1,2,0),(0,1,2)},{(2,0,1)},{(1,2,0)},{(0,1,2)}}, L -> (BC := fold((a,b)->a|b, apply(L, bl)); << "  char-2 sub-blocks " << L << " ∩ ker: " << rank KC + rank BC - rank(KC|BC) << endl));
