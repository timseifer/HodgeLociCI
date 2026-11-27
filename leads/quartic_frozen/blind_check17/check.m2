runInst = (p, seed) -> (
  setRandomSeed seed;
  kk := ZZ/p;
  R := kk[x_0..x_5];
  S := kk[y_0..y_4];
  Q1 := random(2, S); Q2 := random(2, S);
  toR := map(R, S, {x_0,x_1,x_2,x_3,x_4});
  A := random(2,R); B := random(2,R); C := random(3,R);
  F := toR(Q1)*A + toR(Q2)*B + x_5*C;
  -- smoothness of X
  JX := ideal jacobian ideal F;
  smX := (dim saturate(JX + ideal F) <= 0);  -- dim of affine cone <=0 means empty projectively
  smX = smX and (saturate(JX) == ideal 1_R or dim(JX)==0);
  -- Sigma smooth
  Isig := ideal(Q1,Q2);
  Jsig := minors(2, jacobian Isig) + Isig;
  smSig := (dim Jsig == 0);
  -- V
  toS := map(S, R, {y_0,y_1,y_2,y_3,y_4,0});
  f := toS F;
  Ising := saturate(ideal(f) + ideal jacobian ideal f);
  d := dim Ising; deg := degree Ising;
  rad := (radical Ising == Ising);
  onSig := isSubset(Isig, Ising);
  hf := apply({1,2,3,4,5}, i -> hilbertFunction(i, Ising));
  -- also compare with Isig + (A,B)|_H
  Ipts := saturate(Isig + ideal(toS A, toS B));
  same := (Ipts == Ising);
  -- lines: Fano scheme of Sigma, check incidence
  print(toString{p, seed, "Xsmooth", smX, "SigmaSmooth", smSig, "dimSingCone", d, "deg", deg, "reduced", rad, "onSigma", onSig, "equalsSigma.A.B", same, "HF1..5", hf});
  (S, Isig, Ising)
);
results = {};
for pr in {32003, 10007} do for sd in {1,2,3} do results = append(results, runInst(pr, sd));
