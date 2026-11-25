-- H5: at a point of F_T, is every (5,5)-class supported on the P^8-section a multiple of [V]_prim ?   MOD p.
-- Pre-registration: PREREG_step1.md (H5).   usage: M2 --script h3_ft_limit.m2 p seed
-- B = k[z,p,q]/(Jac F_8, Phi) = S/((w) + J_F);  B' = k[z,p,q]/(I_V + Jac F_8 + Phi) (the ring used for [V] in n1, ft mode).
pp = value(scriptCommandLine#1); sd = value(scriptCommandLine#2);
setRandomSeed sd; kk = ZZ/pp;
R = kk[z_0..z_2, p_0..p_2, q_0..q_2];
zz = {z_0,z_1,z_2}; ps = {p_0,p_1,p_2}; qs = {q_0,q_1,q_2};
hes = (v, l) -> v#0^3+v#1^3+v#2^3 + 3*l*v#0*v#1*v#2;
x = apply(3, i -> random kk);
lam = -(x#0^3+x#1^3+x#2^3)/(3*x#0*x#1*x#2);
Mx = xx -> sum flatten flatten apply(3, i -> apply(3, j -> zz#((i+j)%3) * xx#((i-j)%3) * ps#i * qs#j));
F = hes(ps, lam) + hes(qs, lam) + Mx x;                         -- a = 0 on the curve h_lam(x) = 0
<< "h_lam(x) = " << hes(x, lam) << endl;
Phi = apply(3, k -> random(2, R));
I = ideal jacobian matrix{{F}} + ideal Phi;
IV = ideal(apply(zz, v -> diff(v, F)) | {hes(ps, lam), hes(qs, lam)});
I2 = IV + I;
G = gb(I, DegreeLimit => 9); G2 = gb(I2, DegreeLimit => 9);
<< "H5: HF of B  = S/((w)+J),      d=0..9: " << apply(toList(0..9), d -> hilbertFunction(d, R/I)) << endl << flush;
<< "    HF of B' = S/(I_V+(w)+J),  d=0..9: " << apply(toList(0..9), d -> hilbertFunction(d, R/I2)) << endl << flush;
<< "    degree-6 parts agree (I_6 = I2_6): " << (hilbertFunction(6, R/I) == hilbertFunction(6, R/I2)) << endl;
