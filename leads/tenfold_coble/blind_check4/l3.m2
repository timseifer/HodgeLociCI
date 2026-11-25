-- supporting computation for L3: critical scheme of f = F|_{w_2=1} on C^11 and its closure at infinity, mod p
pr = value scriptCommandLine#1;
kk = ZZ/pr;
load "common.m2";
use S;
Zid = ideal apply(11, i -> diff(S_i, F));      -- partials w.r.t. y, w_0, w_1 (not w_2)
G = groebnerBasis(Zid, Strategy => "F4");
L = ideal leadTerm G;
stdio << "prime " << pr << ": Z = {11 partials (y,w_0,w_1) = 0} in P^11: dim(affine cone) " << dim L << "  degree " << degree L << endl << flush;
G2 = groebnerBasis(Zid + ideal(w_2), Strategy => "F4");
L2 = ideal leadTerm G2;
stdio << "Z cap {w_2=0}: dim " << dim L2 << " degree " << degree L2 << endl << flush;
-- affine chart w_2 = 1
Saff = kk[z_0,z_1,z_2,p_0,p_1,p_2,q_0,q_1,q_2,w_0,w_1];
toAff = map(Saff, S, {z_0,z_1,z_2,p_0,p_1,p_2,q_0,q_1,q_2,w_0,w_1,1});
f = toAff F;
Cr = ideal jacobian matrix{{f}};
G3 = groebnerBasis(Cr, Strategy => "F4");
L3 = ideal leadTerm G3;
stdio << "affine critical scheme of f: dim " << dim L3 << "  length " << degree L3 << "   (2^11 - 72 = " << 2^11-72 << ")" << endl << flush;
G4 = groebnerBasis(Cr + ideal(f), Strategy => "F4");
stdio << "critical points on the fibre f=0: ideal is the unit ideal ? " << (ideal leadTerm G4 == ideal(1_Saff)) << endl << flush;
-- top form f_3 = F|_{w_2=0}, f_2 = Phi2: common zeros of grad f_3 and f_2 at infinity
S10 = kk[z_0,z_1,z_2,p_0,p_1,p_2,q_0,q_1,q_2,w_0,w_1];
to10 = map(S10, S, {z_0,z_1,z_2,p_0,p_1,p_2,q_0,q_1,q_2,w_0,w_1,0});
T = (ideal jacobian matrix{{to10 F}}) + ideal(to10 Phi2);
G5 = groebnerBasis(T, Strategy => "F4");
stdio << "{grad f_3 = 0, f_2 = 0} in P^10: dim(affine cone) " << dim ideal leadTerm G5 << "  (0 means empty)" << endl << flush;
