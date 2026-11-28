load "run17_q10_31981.m2";
nz = select(F, f -> f != 0); lin = select(nz, f -> first degree f <= 1);
A = matrix apply(lin, f -> apply(gens R, v -> coefficient(v, f))); b = matrix apply(lin, f -> {sub(f, {u0=>0,u1=>0,a0=>0,a1=>0})});
<< "8 linear polynomials: rank of linear parts " << rank A << " ; rank with constants " << rank (A | b) << endl;
<< "linear ones alone generate the unit ideal: " << (ideal lin == ideal 1_R) << endl;
exit 0
