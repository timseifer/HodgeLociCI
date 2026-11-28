load "run18_q10_31981.m2";
nz = select(F, f -> f != 0);
<< "nonzero polynomials: " << #nz << " ; degrees: " << toString apply(nz, f -> first degree f) << endl;
lin = select(nz, f -> first degree f <= 1);
z0 = apply(gens R, v -> v => 0);
A = matrix apply(lin, f -> apply(gens R, v -> coefficient(v, f))); b = matrix apply(lin, f -> {sub(f, z0)});
<< "linear ones: " << #lin << " ; rank of linear parts " << rank A << " ; with constants " << rank (A | b) << endl;
I = ideal nz;
<< "RESULT unit ideal: " << (I == ideal 1_R) << endl;
if I != ideal 1_R then (<< "dim " << dim I << " ; degree " << degree I << endl; << "codim " << codim I << endl);
exit 0
