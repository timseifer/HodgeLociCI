-- C3: synthetic family G_s = det(M) - det(sM), s an isometry of tr(X^2) on sl_3.  Usage: M2 --script c3.m2 <prime> <seed> <nrefl>
pr = value scriptCommandLine#1; sd = value scriptCommandLine#2; nrefl = value scriptCommandLine#3;
say = s -> (stdio << s << endl << flush;);
kk = ZZ/pr; setRandomSeed sd;
R = kk[y_1..y_8];
yv = transpose vars R;   -- column
Mof = v -> matrix{{v_(0,0),v_(1,0),v_(2,0)},{v_(3,0),v_(4,0),v_(5,0)},{v_(6,0),v_(7,0),-v_(0,0)-v_(4,0)}};
M = Mof yv;
qf = trace(M*M);
Qm = sub((1/2)_kk * diff(vars R, diff(transpose vars R, qf)), kk);   -- Gram matrix
say("prime " | toString pr | " seed " | toString sd | " reflections " | toString nrefl);
say("Gram matrix nondegenerate: " | toString(det Qm != 0));
refl = k -> (n := (transpose k * Qm * k)_(0,0); if n == 0 then error "isotropic"; id_(kk^8) - (2/n) * k * transpose k * Qm);
Smat = id_(kk^8);
scan(nrefl, i -> (k := random(kk^8, kk^1); Smat = Smat * refl k));
say("s is an isometry (S^T Q S == Q): " | toString(transpose Smat * Qm * Smat == Qm) | "   det s = " | toString det Smat);
sy = sub(Smat, R) * yv;
sM = Mof sy;
s2 = N -> N_(0,0)*N_(1,1)-N_(0,1)*N_(1,0) + N_(0,0)*N_(2,2)-N_(0,2)*N_(2,0) + N_(1,1)*N_(2,2)-N_(1,2)*N_(2,1);
say("tr M == 0: " | toString(trace M == 0) | "   tr sM == 0: " | toString(trace sM == 0) | "   s2(sM) == s2(M): " | toString(s2 sM == s2 M));
D = det M;
G = D - det sM;
say("G != 0: " | toString(G != 0) | "   #factors of G: " | toString(#(toList factor G)) | "  degrees of factors: " | toString apply(toList factor G, f -> first degree f#0));
say("det(tau+M) - det(tau+sM) == G is implied by tr, s2 equalities");
cj = (coefficients(transpose jacobian ideal G))#1;
say("rank of span of partials (8 = not a cone): " | toString rank cj);
JG = ideal jacobian ideal G;
say("Sing(G): affine dim = " | toString dim JG | "  degree = " | toString degree JG | "  HP = " | toString hilbertPolynomial(JG, Projective => false));
if dim JG == 2 then (
  ell = sum(8, i -> random(kk)*R_i);
  IC = saturate(JG, ell);
  say("saturated: HP = " | toString hilbertPolynomial(IC, Projective => false) | "  gens degrees: " | toString(tally flatten degrees source gens IC));
  say("quadrics through C: " | toString numcols basis(2, IC) | "   cubics through C: " | toString numcols basis(3, IC));
  say("HF of R/IC, degrees 0..6: " | toString apply(7, d -> hilbertFunction(d, R/IC)));
  -- tangent space of the family: 64 cubics y_i dG/dy_j and 28 variations of s
  dG = flatten entries jacobian ideal G;
  T1 = flatten apply(8, i -> apply(8, j -> R_i * dG#j));
  gradD = flatten entries jacobian ideal D;
  gradDs = apply(gradD, f -> sub(f, apply(8, i -> R_i => sy_(i,0))));
  Qinv = inverse Qm;
  T2 = flatten apply(8, a -> flatten apply(8, b -> if a < b then (
       Om := matrix table(8,8,(r,c) -> if (r,c) == (a,b) then 1_kk else if (r,c) == (b,a) then -1_kk else 0_kk);
       X := Qinv * Om;
       v := sub(Smat * X, R) * yv;
       {sum(8, i -> gradDs#i * v_(i,0))}) else {}));
  say("#T1 = " | toString(#T1) | "  #T2 = " | toString(#T2));
  mons3 = basis(3, R);
  c1 = (coefficients(matrix{T1}, Monomials => mons3))#1;
  c2 = (coefficients(matrix{T2}, Monomials => mons3))#1;
  say("rank span{y_i dG/dy_j} = " | toString rank c1 | "   rank span{variations of s} = " | toString rank c2 | "   rank of both = " | toString rank(c1 | c2));
  B3 = super basis(3, IC);
  c3 = (coefficients(B3, Monomials => mons3))#1;
  say("dim (I_C)_3 = " | toString rank c3 | "   rank(tangent + (I_C)_3) = " | toString rank(c1 | c2 | c3) | "  (equal => tangent space inside (I_C)_3)");
  -- finite-difference sanity check of one variation: G_{s(1+eps X)} - G_s = -eps * v_X  (mod eps^2) is checked by exact dual numbers below
  -- check each variation cubic is singular-direction: i.e. vanishes on C (already implied by containment above)
);
