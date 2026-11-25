-- EXP-T6: P2xP2 projected from a general line to P^6; cubics through it, singular locus of the cubic (MOD p)
pr = s -> (stderr << s << endl << flush);
p = 32003; kk = ZZ/p; setRandomSeed(1);
T = kk[t_0..t_8]; I = minors(2, genericMatrix(T, t_0, 3, 3));
g = map(T, T, random(T^1, T^{9:-1})); J = eliminate({T_7, T_8}, g I);
R = kk[y_0..y_6]; J = trim (map(R, T, {y_0,y_1,y_2,y_3,y_4,y_5,y_6,0,0})) J;
pr("dim/deg piSigma: " | toString(dim J - 1) | " " | toString(degree J) | "; generators degrees " | toString(degrees gens J) );
pr("quadrics: " | toString(numColumns super basis(2, J)) | ", cubics: " | toString(numColumns super basis(3, J)));
G = (super basis(3, J))_(0,0);
sg = ideal(G) + ideal jacobian matrix{{G}};
pr("dim Sing(Z5) (projective) = " | toString(dim sg - 1) | ", degree " | toString(degree sg));
pr("dim Sing(piSigma) = " | toString(dim(J + minors(2, jacobian J)) - 1));
