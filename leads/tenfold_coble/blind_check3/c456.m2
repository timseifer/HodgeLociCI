p = value(commandLine#3); sd = value(commandLine#4);
load "/home/claude/blind_check3/setup.m2";
stdio << "=== C4-C6 p=" << p << " seed=" << sd << endl << flush;
-- ---------- C4 ----------
IZp = pfaffians(4, blk {0,1,2,3,4});
stdio << "Z': numgens " << numgens IZp << " affine dim " << dim IZp << " degree " << degree IZp << "  F in I_Z': " << (F % IZp == 0) << "  I_Z' subset I_S: " << isSubset(IZp, IS) << endl << flush;
CI = ideal(F, pf4 {0,1,2,3}, pf4 {0,1,2,4});
stdio << "CI (F,Pf0123,Pf0124): affine dim " << dim CI << " degree " << degree CI << "  codim " << codim CI << endl << flush;
IZ = CI : IZp;
stdio << "Z = CI : I_Z' : affine dim " << dim IZ << " degree " << degree IZ << "  degrees of min gens " << toString sort flatten degrees source mingens IZ << endl;
stdio << "   F in I_Z: " << (F % IZ == 0) << "  I_Z subset I_S: " << isSubset(IZ, IS) << "  I_Z cap I_Z' == CI: " << (intersect(IZ, IZp) == CI) << endl << flush;
tick "C4 link";
N = submatrix(M, {0,1,2,3,4,5}, {0,1,2});
mn = minors(3, N);
stdio << "3x3 minors of columns 0,1,2: affine dim " << dim mn << " degree " << degree mn << "  subset I_Z: " << isSubset(mn, IZ) << "  F in minors: " << (F % mn == 0) << endl << flush;
mnsat = saturate mn;
stdio << "   F in sat(minors): " << (F % mnsat == 0) << "   F^2 in sat(minors): " << (F^2 % mnsat == 0) << "   minors saturated already: " << (mnsat == mn) << endl;
stdio << "   I_Z subset sat(minors): " << isSubset(IZ, mnsat) << "   I_Z^2 subset sat(minors): " << isSubset(IZ^2, mnsat) << endl << flush;
-- explicit description: A = top 3x3 skew block, B = lower 3x3 block; kernel vector of A is v=(a12,-a02,a01)
v = matrix{{M_(1,2)},{-M_(0,2)},{M_(0,1)}};
Bv = ideal(submatrix(M,{3,4,5},{0,1,2}) * v);
stdio << "   I_Z == (B*pf(A), F): " << (IZ == Bv + ideal F) << "   (B*pf(A)) : (a01,a02,a12) + (F) == I_Z ? " << (IZ == ((Bv : ideal(M_(0,1),M_(0,2),M_(1,2))) + ideal F)) << endl << flush;
tick "C4 minors";
-- ---------- second pair ----------
IZp2 = pfaffians(4, blk {1,2,3,4,5});
CI2 = ideal(F, pf4 {0,3,4,5}, pf4 {1,3,4,5});
IZ2 = CI2 : pfaffians(4, blk {0,1,3,4,5});
mn2 = minors(3, submatrix(M, {0,1,2,3,4,5}, {3,4,5}));
stdio << "Z_2: affine dim " << dim IZ2 << " degree " << degree IZ2 << " gens " << toString sort flatten degrees source mingens IZ2 << "  minors(cols 3,4,5) subset I_Z2: " << isSubset(mn2, IZ2) << endl;
stdio << "Z'_2: affine dim " << dim IZp2 << " degree " << degree IZp2 << endl << flush;
tick "second pair";
-- ---------- C5 ----------
names = {"Z","Z_2","Z'","Z'_2"}; ids = {IZ, IZ2, IZp, IZp2};
Hs = jacobian ideal jacobian matrix{{F}};
P6 = kk[z_0..z_6];
npts = 0; attempt = 0;
while npts == 0 and attempt < 6 do (
  attempt = attempt + 1;
  par = random(P6^1, P6^{9:-1});
  r6 = map(P6, R, par);
  I14 = r6 IS;
  comps = decompose I14;
  stdio << "S cap random P^6 (attempt " << attempt << "): degree " << degree I14 << ", component degrees " << toString sort apply(comps, degree) << endl << flush;
  lin = select(comps, c -> degree c == 1);
  npts = #lin;
);
tick "points";
scan(lin, c -> (
  zc = sub(gens kernel transpose sub(jacobian c, kk), kk);     -- 7x1
  evz = map(kk, P6, flatten entries zc);
  yc = flatten entries evz par;
  ev = map(kk, R, yc);
  stdio << "--- rational point p = " << toString yc << endl;
  stdio << "   IS vanishes at p: " << (ev gens IS == 0) << "   rank M(p) = " << rank ev M << "   rank Hess F(p) = " << rank ev Hs << endl;
  Hp = ev Hs;
  TS = gens kernel transpose ev jacobian IS;
  stdio << "   affine dim T_pS = " << numcols TS << "   Hess(p) * T_pS == 0: " << (Hp*TS == 0) << endl;
  Jps = apply(ids, I -> ev jacobian I);
  Ts = apply(Jps, Jp -> gens kernel transpose Jp);
  scan(4, i -> stdio << "   " << names#i << ": affine dim T_p = " << numcols Ts#i << "  contains T_pS: " << ((transpose Jps#i)*TS == 0) << "  totally isotropic for Hess F(p): " << ((transpose Ts#i)*Hp*(Ts#i) == 0) << endl);
  scan({(0,1),(2,3),(0,2),(0,3),(1,2),(1,3)}, pr -> (
     d := 9 - rank(Jps#(pr#0) | Jps#(pr#1));
     stdio << "   T_p " << names#(pr#0) << " cap T_p " << names#(pr#1) << ": projective dim " << d-1 << "   (dim modulo T_pS: " << d-3 << ")" << endl));
  stdio << flush;
));
tick "C5";
-- ---------- C6 ----------
P5 = kk[x_0..x_5]; r5 = map(P5, R, random(P5^1, P5^{9:-1}));
F5 = r5 F;
stdio << "cubic fourfold smooth (affine dim of Jacobian ideal = " << dim ideal jacobian matrix{{F5}} << ")" << endl;
sg = r5 IZ; sg2 = r5 IZ2; D = r5 IZp; D2 = r5 IZp2;
scan({("sigma",sg),("sigma_2",sg2),("D",D),("D_2",D2)}, pr -> stdio << pr#0 << ": affine dim " << dim pr#1 << " degree " << degree pr#1 << " HilbPoly " << toString hilbertPolynomial(pr#1, Projective=>false) << "  saturated: " << (saturate pr#1 == pr#1) << "  F5 in ideal: " << (F5 % pr#1 == 0) << endl << flush);
scan({("D cap D_2",D+D2),("sigma cap sigma_2",sg+sg2),("sigma cap D_2",sg+D2),("sigma_2 cap D",sg2+D),("sigma cap D",sg+D),("sigma_2 cap D_2",sg2+D2)}, pr -> stdio << pr#0 << ": affine dim " << dim pr#1 << " degree " << degree pr#1 << endl << flush);
tick "C6";
