-- expects kk to be defined before loading
S = kk[z_0,z_1,z_2,p_0,p_1,p_2,q_0,q_1,q_2,w_0,w_1,w_2];
hcub = (a,b,c) -> a^3+b^3+c^3+9*a*b*c;
xs = {4,3,3};
zs = {z_0,z_1,z_2}; ps = {p_0,p_1,p_2}; qs = {q_0,q_1,q_2};
Mtri = sum(3, i -> sum(3, j -> xs#((i-j+3)%3) * zs#((i+j)%3) * ps#i * qs#j));
F8 = -221*hcub(z_0,z_1,z_2) + 378*hcub(p_0,p_1,p_2) + 378*hcub(q_0,q_1,q_2) + 378*Mtri;
Phi0 = 2*z_0*p_0 + z_1*p_1 + 2*z_0*p_2 - p_2^2 - 2*p_0^2 - 2*z_1*z_2;
Phi1 = -p_1*p_2 - 2*q_0*q_2 - 2*q_0^2 + 2*z_1*p_1 - p_1*q_0 - 2*q_1^2;
Phi2 = 2*z_1*q_2 - 2*p_0*q_0 + p_2*q_1 + z_0*p_1 - p_1*q_2 + 2*p_2^2;
F = F8 + w_0*Phi0 + w_1*Phi1 + w_2*Phi2 + w_0^3 + w_1^3 + w_2^3;
-- the P^8 ring
R = kk[z_0,z_1,z_2,p_0,p_1,p_2,q_0,q_1,q_2];
toR = map(R, S, {z_0,z_1,z_2,p_0,p_1,p_2,q_0,q_1,q_2,0,0,0});
G8 = toR F8; P0 = toR Phi0; P1 = toR Phi1; P2 = toR Phi2;
J8 = ideal jacobian matrix{{G8}};
ISig = J8 + ideal(P0,P1);
l1 = z_0 + 2*z_1 - z_2 + 3*p_0 - 2*p_1 + p_2 + 2*q_0 - q_1 + 3*q_2;
l2 = 2*z_0 - z_1 + 3*z_2 + p_0 + p_1 - 2*p_2 - q_0 + 2*q_1 + q_2;
hfl = (d,I) -> apply(toList(0..d), i -> hilbertFunction(i, I));
