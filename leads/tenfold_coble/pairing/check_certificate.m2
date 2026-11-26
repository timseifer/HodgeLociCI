-- Independent of the arcs: reads a certificate and checks the identity  det(tau + A) - det(tau + B) = c * (Coble cubic restricted to the hyperplane).
-- usage:  M2 --script check_certificate.m2 certfile        (exact over F_p)
dat = value get scriptCommandLine#1;
if dat#"minpoly" == "" then kk = ZZ/(dat#"p") else ( kk = GF((dat#"p")^2, Variable => aa);
    if toString (ideal ambient kk)_0 != dat#"minpoly" then error "this Macaulay2 presents the field F_(p^2) differently" );
hs = (v, l) -> v#0^3+v#1^3+v#2^3 + 3*l*v#0*v#1*v#2;
R9 = kk[z_0..z_2, p_0..p_2, q_0..q_2]; lam = (dat#"lam")_kk; xx = apply(dat#"x", c -> c_kk); a0 = - hs(xx, lam) / (27 * (1 + lam^3));
zz = {z_0,z_1,z_2}; ps = {p_0,p_1,p_2}; qs = {q_0,q_1,q_2};
FC = a0 * hs(zz, lam) + hs(ps, lam) + hs(qs, lam) + sum flatten apply(3, i -> apply(3, j -> zz#((i+j)%3) * xx#((i-j)%3) * ps#i * qs#j));
Tt = kk[u_0..u_7, tau];
par = map(Tt, R9, apply(dat#"hyperplane", value)); G = par FC;
A = matrix apply(dat#"A", r -> apply(r, value)); B = matrix apply(dat#"B", r -> apply(r, value));
lhs = det(tau * id_(Tt^3) + A) - det(tau * id_(Tt^3) + B);
J = saturate ideal jacobian matrix{{G}} ; J = saturate(J, ideal(u_0, u_1, u_2, u_3, u_4, u_5, u_6, u_7));
<< "Coble cubic: singular surface of degree " << degree saturate ideal jacobian matrix{{FC}} << " ; its hyperplane section G: singular locus of the cone, degree " << degree J << endl;
<< "CHECK det(tau + A) - det(tau + B) == c G: " << (lhs == value(dat#"c") * G and lhs != 0) << " ; the entries of A, B do not involve tau: " << (diff(tau, A) == 0 and diff(tau, B) == 0) << endl;
