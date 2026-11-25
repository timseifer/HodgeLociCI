-- T0: re-confirm Sing(Y): dimension, degree, Hilbert polynomial, smoothness via Hessian rank
pp = value(scriptCommandLine#1); sd = value(scriptCommandLine#2); mode = scriptCommandLine#3;
load "/home/claude/blind_check2/lib.m2";
t0 = cpuTime();
<< "dim J (affine) = " << dim J << "  degree J = " << degree J << endl << flush;
<< "hilbertPolynomial R/J = " << hilbertPolynomial(R/J, Projective=>false) << endl << flush;
use R;
Hs = jacobian J;  -- 9x9 Hessian
-- random 6x6 compressed determinants
dets = apply(4, k -> (B := random(R^9, R^6); C := random(R^9, R^6); det(transpose(B)*Hs*C)));
K = J + ideal dets;
<< "dim (J + 4 random compressed 6x6 minors of Hessian) (affine) = " << dim K << endl << flush;
<< "(0 means Hessian has rank>=6 everywhere on Sing, so Sing scheme is smooth of dim 2)" << endl;
-- 7x7 compressed minors must vanish on Sing if rank <= 6
d7 = det(transpose(random(R^9,R^7))*Hs*random(R^9,R^7));
Jsat = saturate(J, ideal(z_0+3*p_1-5*q_2));
<< "Jsat numgens by degree: " << tally apply(flatten entries mingens Jsat, f -> first degree f) << endl;
<< "Jsat == J ? " << (Jsat == J) << endl;
<< "random compressed 7x7 minor in Jsat? " << (d7 % Jsat == 0) << endl;
<< "HF(R/Jsat, 0..6) = " << apply(7, d -> hilbertFunction(d, R/Jsat)) << endl;
<< "time " << cpuTime()-t0 << endl;
