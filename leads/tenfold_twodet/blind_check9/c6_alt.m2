-- what if I is read with only the 3+3 minors of rows 1,2 (the ideal of T5 plus Q1,Q2)?  MOD p
kk = ZZ/32003; setRandomSeed 5; S = kk[x_0..x_11];
l1 = random(1,S); l2 = random(1,S); Q1 = random(2,S); Q2 = random(2,S);
A = matrix apply(3, i -> apply(3, j -> random(1,S))); B = matrix apply(3, i -> apply(3, j -> random(1,S)));
F = l1*Q1 + l2*Q2 + det A + det B; J = ideal jacobian ideal F;
I' = ideal(l1,l2,Q1,Q2) + minors(2, A^{0,1}) + minors(2, B^{0,1});
<< "rows-1,2-only ideal: affine dim " << dim I' << ", J inside: " << isSubset(J, I') << ", HF " << toString apply(8, i -> hilbertFunction(i, S/I')) << endl;
