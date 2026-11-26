R = QQ[z0,z1,z2,p0,p1,p2,q0,q1,q2];
F = (29)*z0*z0*z0 + (-174)*z0*z1*z2 + (8)*z0*p0*q0 + (1)*z0*p1*q2 + (18)*z0*p2*q1 + (29)*z1*z1*z1 + (1)*z1*p0*q1 + (18)*z1*p1*q0 + (8)*z1*p2*q2 + (29)*z2*z2*z2 + (18)*z2*p0*q2 + (8)*z2*p1*q1 + (1)*z2*p2*q0 + (1)*p0*p0*p0 + (-6)*p0*p1*p2 + (1)*p1*p1*p1 + (1)*p2*p2*p2 + (1)*q0*q0*q0 + (-6)*q0*q1*q2 + (1)*q1*q1*q1 + (1)*q2*q2*q2;
J = ideal jacobian ideal F;
t0 = cpuTime();
print("Sing(Y) over QQ: projective dimension, degree, Hilbert polynomial:");
print(dim J - 1);
print(degree J);
print(toString hilbertPolynomial(J, Projective=>false));
print(cpuTime() - t0);
-- is the Jacobian ideal saturated / radical?  compare with its saturation
Js = saturate J;
print("Jacobian ideal saturated:"); print(Js == J);
print("number and degrees of generators of saturation:"); print(toString tally flatten degrees Js);
quit;
