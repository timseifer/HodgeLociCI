-- SS-T6 step (1)+(2): strata codims at random points; controls; tests at X in F_T.  Usage: M2 --script ss1.m2 p seed
load "sslib.m2";
pr = value(scriptCommandLine#1); sd = value(scriptCommandLine#2);
pf("SS-T6 ss1 p", pr, "seed", sd);
-- (A) random points of the strata (own ring, seed sd)
kk = ZZ/pr; S = kk[w_0..w_5, y_0..y_2, z_0..z_2];
setRandomSeed(1000 + sd);
for nm in {"S2","S2v","S2AB","S3","VZ"} do (
  K := stratumIdeal(nm, S); F := randomIn K;
  pf("(A) random point of", nm, "codim T(str) =", tanCodim(F, K), "X smooth along L:", smoothAlongL F));
-- (B) X in F_T (bc_so construction, seed sd)
D = setupX(pr, sd); S = D#"S"; kk = D#"kk"; F = D#"F"; IV = D#"IV"; IT = D#"IT";
w = take(gens S, 6); z = take(gens S, {9,11});
pf("(B) T: degree", degree IT, "F in I_V", F % IV == 0, "X smooth along V", dim(IV + D#"J") == 0, "X smooth along L", smoothAlongL F);
ITS = sub(IT, S);
pf("    I_T(2) inside I_{AuB}(2):", all(flatten entries super basis(2, ITS), q -> q % (ideal(w_0,w_1,w_2)*ideal(w_3,w_4,w_5)) == 0), "dim I_T(2)", numcols super basis(2, ITS));
-- control Cone_T (codim 65): F' = C + z.(quadrics), C random in I_T(3) (w only); tangent = (z)_3 + I_T(3)_w + Hom(I_T,Sw/I_T)_0(C) + J_3
W = ring IT; IT3 = super basis(3, IT); C = (IT3 * random(kk^(numcols IT3), kk^1))_(0,0);
Fc = sub(C, S) + sum(z, zz -> zz * random(2, S));
Hm = Hom(module IT, W^1/IT); b0 = basis(0, Hm); cfC = (matrix{{C}}) // (gens IT);
homC = apply(numcols b0, i -> (phi := matrix{apply(numgens IT, j -> lift((matrix homomorphism(b0_{i}))_(0,j), W))}; sub((phi * cfC)_(0,0), S)));
TC = K3mat(ideal z) | coefM(S, 3, sub(IT3, S)) | coefM(S, 3, matrix{homC}) | jac3 Fc;
pf("(B) control Cone_T: Hom_0(I_T) =", numcols b0, "codim T Cone_T =", 364 - rk TC);
-- T NL and T F_T at X (as bc_so/main2)
H = hsData F; N = nuSetup(H, IV); (TNL, K0) = tangentData(H, N#"nuv");
I3 = flatten entries D#"I3";
Hv = Hom(module IV, S^1/IV); bv = basis(0, Hv); cf = (matrix{{F}}) // (gens IV);
homD = apply(numcols bv, i -> (phi := matrix{apply(numgens IV, j -> lift((matrix homomorphism(bv_{i}))_(0,j), S))}; (phi * cf)_(0,0)));
famC = coefM(S, 3, matrix{I3 | homD}) | jac3 F;
rNL = rk TNL; rFT = rk famC;
pf("(B) controls: codim T NL =", 364 - rNL, "codim T F_T =", 364 - rFT, "T F_T in T NL", rk(TNL | famC) == rNL);
for nm in {"S2","S2AB","S2v","S3","VZ"} do (
  K := stratumIdeal(nm, S); inK := F % K == 0;
  Ts := K3mat K | jac3 F; rs := rk Ts;
  pf("(B) X in F_T vs", nm, "F in K:", inK, "codim T_X(str) =", 364 - rs,
     "T F_T in T(str):", rk(Ts | famC) == rs, "G_e in T(str) [T NL in T(str)]:", rk(Ts | TNL) == rs,
     "T(str) in T NL:", rk(Ts | TNL) == rNL, "codim (T(str) n T NL):", 364 - (rs + rNL - rk(Ts | TNL))));
pf "SS1 DONE";
