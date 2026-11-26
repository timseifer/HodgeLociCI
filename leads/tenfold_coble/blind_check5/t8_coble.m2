-- T8 probe: the P^8-section a*h_lam(y)+h_lam(p)+h_lam(q)+M_x of the T7 arc, for a = -h_lam(x)/(27(1+lam^3)),
-- at rational (lam, x): singular locus (EXACT over QQ), and the same with the variants of the formula for a.
sing = (lam, xx, a, label) -> (
    T := QQ[Y_0..Y_2, P_0..P_2, Q_0..Q_2];
    hl := (v) -> v#0^3+v#1^3+v#2^3 + 3*lam*v#0*v#1*v#2;
    MT := sum(3, i -> sum(3, j -> xx#((i-j)%3) * T_((i+j)%3) * T_(3+i) * T_(6+j)));
    G := a*hl({T_0,T_1,T_2}) + hl({T_3,T_4,T_5}) + hl({T_6,T_7,T_8}) + MT;
    J := ideal jacobian ideal G;
    << label << ": lam=" << lam << " x=" << toString xx << " a=" << a << ": dim Sing = " << dim J - 1;
    if dim J > 0 then << ", degree " << degree J << ", Hilbert polynomial " << toString hilbertPolynomial(J, Projective => false);
    << endl;);
hlx = (lam, xx) -> xx#0^3+xx#1^3+xx#2^3 + 3*lam*xx#0*xx#1*xx#2;
scan({(2, {1,4,-3}), (-1/3, {5,2,7}), (3/2, {-2,1/2,5}), (5, {7,-11,13})}, t -> (
    (lam, xx) := t;
    sing(lam, xx, -hlx(lam,xx)/(27*(1+lam^3)), "formula of T7      ");
    sing(lam, xx, -hlx(0,xx)/(27*(1+lam^3)), "variant (ii)  h_0(x)");
    sing(lam, xx, -hlx(lam,xx)/27, "variant (iii) no 1+lam^3");
    ));
