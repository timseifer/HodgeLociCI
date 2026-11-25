load "sslib.m2";
pr = value(scriptCommandLine#1); sd = value(scriptCommandLine#2);
kk = ZZ/pr; S = kk[w_0..w_5, y_0..y_2, z_0..z_2];
setRandomSeed sd;
for nm in {"S2","S2AB","S2v","S3","VZ"} do (
  K := stratumIdeal(nm, S); F := randomIn K; t := cpuTime();
  pf(nm, "dim K_3", numcols super basis(3,K), "codim T", tanCodim(F, K), "t", cpuTime()-t);
);
