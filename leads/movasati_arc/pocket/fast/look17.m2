load "run17_q10_31981.m2";
nz = select(F, f -> f != 0);
<< "nonzero polynomials: " << #nz << " ; degrees: " << toString apply(nz, f -> first degree f) << endl;
lin = select(nz, f -> first degree f <= 1);
<< "linear ones: " << #lin << endl;
J = ideal apply(nz, f -> f - sub(f, {u0=>0,u1=>0,a0=>0,a1=>0}));
<< "constant terms: " << toString apply(nz, f -> sub(f, {u0=>0,u1=>0,a0=>0,a1=>0})) << endl;
L1 = matrix apply(nz, f -> apply(gens R, v -> coefficient(v, f)));
<< "rank of the linear-term matrix (" << numrows L1 << " x 4): " << rank L1 << endl;
-- the same ideal without the a-variables (a0 = a1 = 0): the plane of the 9-jet piece alone
Ia = ideal apply(nz, f -> sub(f, {a0=>0, a1=>0}));
<< "with a0 = a1 = 0: unit ideal " << (Ia == ideal 1_R) << endl;
Iu = ideal apply(nz, f -> sub(f, {u0=>0, u1=>0}));
<< "with u0 = u1 = 0: unit ideal " << (Iu == ideal 1_R) << endl;
exit 0
