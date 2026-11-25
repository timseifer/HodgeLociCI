p = value(commandLine#3); sd = value(commandLine#4);
load "/home/claude/blind_check3/setup.m2";
stdio << "=== C2(fast: no reducedness dets, no P^10) p=" << p << " seed=" << sd << endl << flush;
Psi1 = random(2,R); Psi2 = random(2,R);
la = random(1,R); lb = random(1,R); lc = random(1,R);
-- reducedness test for a projective zero-dimensional scheme V(I) in P^8: one random 8x8 compressed
-- Jacobian determinant that vanishes at no point  => Jacobian rank 8 at every point => reduced
redtest = (I) -> (
  Q := R/I; JQ := sub(jacobian I, Q); n := numgens I;
  A := sub(random(kk^8, kk^9), Q); B := sub(random(kk^n, kk^8), Q);
  d := det(A*JQ*B, Strategy => Cofactor);
  r := dim ideal d;
  use R; r);
I56 = IS + ideal(Psi1,Psi2);
stdio << "S cap Psi1 cap Psi2: affine dim " << dim I56 << " degree " << degree I56 << "  HF deg 1..7: " << toString apply(toList(1..7), d -> hilbertFunction(d, coker gens I56)) << endl << flush;
tick "56";
I28 = IS + ideal(la,Psi1);
stdio << "S cap lin cap quadric: affine dim " << dim I28 << " degree " << degree I28 << "  HF deg 1..6: " << toString apply(toList(1..6), d -> hilbertFunction(d, coker gens I28)) << endl;
I14 = IS + ideal(la,lb);
stdio << "S cap P^6: affine dim " << dim I14 << " degree " << degree I14 << "  HF deg 1..5: " << toString apply(toList(1..5), d -> hilbertFunction(d, coker gens I14)) << endl;
tick "28,14";
-- restriction of F to random P^6 and P^5 (parametrised)
P6 = kk[z_0..z_6]; r6 = map(P6, R, random(P6^1, P6^{9:-1}));
F6 = r6 F; J6 = ideal jacobian matrix{{F6}};
stdio << "F|P^6: Jacobian scheme affine dim " << dim J6 << " degree " << degree J6 << "   degree of saturation " << degree saturate J6 << endl << flush;
P5 = kk[x_0..x_5]; r5 = map(P5, R, random(P5^1, P5^{9:-1}));
F5 = r5 F; J5 = ideal jacobian matrix{{F5}};
stdio << "F|P^5: Jacobian ideal affine dim " << dim J5 << " (0 = smooth cubic fourfold), F5 nonzero: " << (F5 != 0) << endl << flush;
tick "P6,P5";
