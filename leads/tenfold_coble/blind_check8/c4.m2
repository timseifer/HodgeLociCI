-- C4 cross-check at the certificate point: tangent space of the Coble-section family (T) and of the family det M - det sM (S), versus (I_C)_3.
cert = value get "/home/claude/hodgelocici/leads/tenfold_coble/pairing/arcdata/certificate_32003_seed1.txt";
pr = cert#"p"; kk = ZZ/pr;
say = s -> (stdio << s << endl << flush;);
lam0 = cert#"lam"; xs0 = cert#"x";
hfun = (l, v) -> v#0^3 + v#1^3 + v#2^3 + 3*l*v#0*v#1*v#2;
cobleGen = (l, xx, aval, z, pp, q) -> aval*hfun(l,z) + hfun(l,pp) + hfun(l,q) + sum(3, i -> sum(3, j -> xx#((i-j)%3) * z#((i+j)%3) * pp#i * q#j));
-- ===== T: Coble sections
Re = kk[u_0..u_7, eps];
hyp = apply(cert#"hyperplane", value);
Geps = (dl, dx) -> (
   l := lam0 + dl*eps; xx := apply(3, i -> xs0#i + dx#i*eps);
   num := -hfun(l, xx); den := 27*(1+l^3);
   c0 := sub(sub(den, {eps => 0}), kk); c1 := sub(sub(contract(eps, den), {eps => 0}), kk);
   invden := (1/c0) - (c1/c0^2)*eps;      -- inverse of den modulo eps^2
   cobleGen(l, xx, num*invden, hyp_{0,1,2}, hyp_{3,4,5}, hyp_{6,7,8}));
G = sub(Geps(0,{0,0,0}), {eps => 0});
dpar = apply({(1,{0,0,0}), (0,{1,0,0}), (0,{0,1,0}), (0,{0,0,1})}, d -> sub(contract(eps, Geps d), {eps => 0}));
S9 = kk[w_0..w_8];
a0 = sub(-hfun(lam0, xs0), kk) / sub(27*(1+lam0^3), kk);
F9 = cobleGen(lam0, xs0, a0, {w_0,w_1,w_2},{w_3,w_4,w_5},{w_6,w_7,w_8});
phi = map(Re, S9, hyp);
say("G from two constructions agree: " | toString(phi F9 == G));
dF = apply(9, k -> phi diff(w_k, F9));
dhyp = flatten apply(9, k -> apply(8, j -> Re_j * dF#k));
uvars = apply(8, i -> Re_i);
mons3 = basis(3, Re, Variables => uvars);
cT1 = (coefficients(matrix{dhyp}, Monomials => mons3))#1;
cT2 = (coefficients(matrix{dpar}, Monomials => mons3))#1;
cT = sub(cT1 | cT2, kk);
say("T (Coble sections): rank of 72 hyperplane/coordinate derivatives = " | toString rank cT1 | ";  of 4 parameter derivatives = " | toString rank cT2 | ";  all 76 = " | toString rank cT);
-- x-scaling direction should already be in the coordinate span (3 moduli, not 4):
eulerx = sum(3, i -> xs0#i * dpar#(i+1));
say("   rank(72 + lam-derivative) = " | toString rank(cT1 | (coefficients(matrix{{dpar#0}}, Monomials => mons3))#1) | ";  x-scaling derivative in the span of the 72: " | toString(rank(cT1 | (coefficients(matrix{{eulerx}}, Monomials => mons3))#1) == rank cT1));
-- (I_C)_3
Rp = kk[u_0..u_7];
toRp = map(Rp, Re, (gens Rp) | {0});
Gp = toRp G;
JG = ideal jacobian ideal Gp;
ell = sum(8, i -> random(kk)*Rp_i);
IC = saturate(JG, ell);
say("C = Sing(G): HP = " | toString hilbertPolynomial(IC, Projective => false) | "; quadrics " | toString numcols basis(2, IC) | "; cubics " | toString numcols basis(3, IC));
mons3p = basis(3, Rp);
cI = sub((coefficients(super basis(3, IC), Monomials => mons3p))#1, kk);
-- same monomial order?  map monomials to compare
say("monomial bases agree: " | toString(toRp mons3 == mons3p));
say("T: rank(tangent | (I_C)_3) = " | toString rank(cT | cI) | "   (75 => tangent space of Coble sections at G equals (I_C)_3)");
-- ===== S: family det M - det sM at the certificate point (over F_(p^2))
T0 = (ZZ/pr)[aa];
K = toField(T0/ideal(value cert#"minpoly"));
RK = K[u_0..u_7];
use RK; aa = sub(aa_K, RK);
A = matrix apply(cert#"A", r -> apply(r, value));
B = matrix apply(cert#"B", r -> apply(r, value));
c = value cert#"c";
I3 = id_(RK^3);
inv3 = (1/3)_K;
A0 = A - inv3*trace(A)*I3; B0 = B - inv3*trace(A)*I3;
GK = (map(RK, Rp, gens RK)) Gp;
say("det A0 - det B0 == c G : " | toString(det A0 - det B0 == c*GK));
ents = {(0,0),(0,1),(0,2),(1,0),(1,1),(1,2),(2,0),(2,1)};
uu = vars RK;
PA = sub(transpose (coefficients(matrix{apply(ents, e -> A0_e)}, Monomials => uu))#1, K);  -- y = PA * u
PB = sub(transpose (coefficients(matrix{apply(ents, e -> B0_e)}, Monomials => uu))#1, K);  -- s y = PB * u
say("det PA != 0: " | toString(det PA != 0) | "  det PB != 0: " | toString(det PB != 0));
Sm = PB * inverse PA;
Ry = K[y_1..y_8];
yv = transpose vars Ry;
Mof = v -> matrix{{v_(0,0),v_(1,0),v_(2,0)},{v_(3,0),v_(4,0),v_(5,0)},{v_(6,0),v_(7,0),-v_(0,0)-v_(4,0)}};
My = Mof yv; qf = trace(My*My);
Qm = sub((1/2)_K * diff(vars Ry, diff(transpose vars Ry, qf)), K);
say("s := (B0-coordinates) o (A0-coordinates)^-1 is an isometry of tr(X^2): " | toString(transpose Sm * Qm * Sm == Qm) | "   det s = " | toString det Sm);
say("s == identity: " | toString(Sm == id_(K^8)) | "   s of finite small order? s^2==1: " | toString(Sm^2 == id_(K^8)));
-- eigen-structure of s: rank(s - 1), rank(s + 1)
say("rank(s - 1) = " | toString rank(Sm - id_(K^8)) | "   rank(s + 1) = " | toString rank(Sm + id_(K^8)));
Dy = det My;
sy = sub(Sm, Ry) * yv;
Gy = Dy - det Mof sy;
toU = map(RK, Ry, flatten entries (sub(PA, RK) * transpose vars RK));
say("G_s in u-coordinates == c G : " | toString(toU Gy == c*GK));
dG = flatten entries jacobian ideal Gy;
T1 = flatten apply(8, i -> apply(8, j -> Ry_i * dG#j));
gradD = flatten entries jacobian ideal Dy;
gradDs = apply(gradD, f -> sub(f, apply(8, i -> Ry_i => sy_(i,0))));
Qinv = inverse Qm;
T2 = flatten apply(8, a -> flatten apply(8, b -> if a < b then (
     Om := matrix table(8,8,(r,cc) -> if (r,cc) == (a,b) then 1_K else if (r,cc) == (b,a) then -1_K else 0_K);
     X := Qinv * Om;
     v := sub(Sm * X, Ry) * yv;
     {sum(8, i -> gradDs#i * v_(i,0))}) else {}));
mons3K = basis(3, RK);
cS1 = sub((coefficients(matrix{apply(T1, f -> toU f)}, Monomials => mons3K))#1, K);
cS2 = sub((coefficients(matrix{apply(T2, f -> toU f)}, Monomials => mons3K))#1, K);
say("S (det M - det sM): rank{u_i dG/du_j} = " | toString rank cS1 | ";  rank{28 variations of s} = " | toString rank cS2 | ";  both = " | toString rank(cS1 | cS2));
cIK = sub(cI, K);
cTK = sub(cT, K);
say("monomial bases agree (K): " | toString((map(RK, Rp, gens RK)) mons3p == mons3K));
say("S: rank(tangent | (I_C)_3) = " | toString rank(cS1 | cS2 | cIK) | ";   rank(S-tangent | T-tangent) = " | toString rank(cS1 | cS2 | cTK));
