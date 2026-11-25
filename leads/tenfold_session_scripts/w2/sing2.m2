p = 1000037; kk = ZZ/p; R = kk[f_1..f_3, h_1..h_3];
Y0 = sum(1..3, i -> f_i*h_i*(f_i + h_i));
for a in {{0,1,5},{1,1,5},{3,7,-5}} do (
    Ha := a#0*f_1 + a#1*f_2 + a#2*f_3;
    J := saturate(ideal(Y0, Ha) + minors(2, jacobian matrix{{Y0, Ha}}));
    dec := decompose J;
    print(toString a | ": components of Sing (radical) " | toString(#dec) | "; degrees " | toString apply(dec, P -> degree P) | "; multiplicities (deg of primary) " | toString apply(primaryDecomposition J, Q -> degree Q) | "; on P1' " | toString apply(dec, P -> isSubset(P, ideal(f_1,f_2,f_3)) or (P + ideal(f_1,f_2,f_3) == P))));
