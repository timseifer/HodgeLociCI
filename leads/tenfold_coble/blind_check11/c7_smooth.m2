-- bonus for C7: Sing(Y) is a smooth surface (mod 32003; emptiness mod p implies emptiness over QQ)
R = ZZ/32003[z0,z1,z2,p0,p1,p2,q0,q1,q2];
F = (29)*z0*z0*z0 + (-174)*z0*z1*z2 + (8)*z0*p0*q0 + (1)*z0*p1*q2 + (18)*z0*p2*q1 + (29)*z1*z1*z1 + (1)*z1*p0*q1 + (18)*z1*p1*q0 + (8)*z1*p2*q2 + (29)*z2*z2*z2 + (18)*z2*p0*q2 + (8)*z2*p1*q1 + (1)*z2*p2*q0 + (1)*p0*p0*p0 + (-6)*p0*p1*p2 + (1)*p1*p1*p1 + (1)*p2*p2*p2 + (1)*q0*q0*q0 + (-6)*q0*q1*q2 + (1)*q1*q1*q1 + (1)*q2*q2*q2;
J = ideal jacobian ideal F;
print("mod 32003: dim, degree of Sing(Y):"); print(dim J - 1); print(degree J);
H = jacobian J;   -- Hessian matrix
sets = {{0,1,2,3,4,5},{3,4,5,6,7,8},{0,1,2,6,7,8},{0,2,3,5,6,8},{1,2,4,5,7,8},{0,1,3,4,6,7},{0,3,4,5,7,8},{1,2,3,4,6,8}};
mins = apply(sets, s -> det submatrix(H, s, s));
K = J + ideal mins;
print("dim of the affine cone of {y in Sing(Y): the 8 chosen 6x6 principal minors of Hess vanish} (0 = empty):");
print(dim K);
quit;
