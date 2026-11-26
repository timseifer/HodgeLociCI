-- A wrong ideal quotient of Macaulay2 1.22 over toField(QQ[w]/(w^2+w+1)): found by blind check 9 (its diag2.m2), reproduced here.
-- usage:  M2 --script leads/tenfold_twodet/tooling_tofield_colon.m2      (registry: N-M2-TOFIELD-IDEAL-QUOTIENT)
K = toField(QQ[w]/(w^2+w+1));
S = K[x_0..x_11];
Fer = sum(12, i -> x_i^3); J = ideal jacobian ideal Fer;
aPl = L -> (
    fs := apply(L, t -> x_(t#0) + w^(t#2)*x_(t#1));
    gs := apply(L, t -> (x_(t#0) + w^(t#2+1)*x_(t#1))*(x_(t#0) + w^(t#2+2)*x_(t#1)));
    det jacobian matrix{fs|gs});
a = aPl{{0,1,0},{2,3,0},{4,5,0},{6,7,0},{8,9,0},{10,11,0}} - aPl{{0,1,1},{2,3,0},{4,10,2},{5,11,2},{6,7,2},{8,9,0}};
C = J : ideal a;
<< "HF S/(J:a) over toField: " << toString apply(8, i -> hilbertFunction(i, S/C)) << endl << flush;
<< "every generator g of the computed colon satisfies g*a in J: " << ((a * gens C) % J == 0) << endl;
<< "degrees of generators of computed colon: " << toString tally flatten degrees source gens C << endl;
bad = select(flatten entries gens C, g -> (g*a) % J != 0);
<< "number of generators g with g*a NOT in J: " << #bad << endl;
M3 = (a * basis(3,S)) % J;
<< "honest linear algebra over the same field: rank of S_3 -> (S/J)_9 = " << rank (coefficients M3)#1 << endl << flush;
