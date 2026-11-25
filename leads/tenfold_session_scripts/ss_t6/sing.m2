-- exploratory: Sing(X n L) at X in F_T (components and dims)
load "sslib.m2";
pr = value(scriptCommandLine#1); sd = value(scriptCommandLine#2);
D = setupX(pr, sd); S = D#"S"; kk = D#"kk"; F = D#"F";
R = kk[w_0..w_5, y_0..y_2]; toR = map(R, S, gens R | {0,0,0});
f = toR F; Js = ideal(f) + ideal jacobian ideal f;
pf("Sing(X n L): proj dim", dim Js - 1, "degree", degree Js);
mp = minimalPrimes Js;
for P in mp do pf("  component: proj dim", dim P - 1, "degree", degree P, "contains Pi (w=0)", isSubset(P, ideal take(gens R, 6)), "= Pi", P == ideal take(gens R,6));
pf "SING DONE";
