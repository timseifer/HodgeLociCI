-- T2 extras: nature of the singular locus (smooth? connected? cohomology), and what happens off the special parameter.
doit = (kk, xx, a, label) -> (
    T := kk[Y_0..Y_2, P_0..P_2, Q_0..Q_2];
    MT := sum(3, i -> sum(3, j -> xx#((i-j)%3) * T_((i+j)%3) * T_(3+i) * T_(6+j)));
    G := a*(T_0^3+T_1^3+T_2^3) + (T_3^3+T_4^3+T_5^3) + (T_6^3+T_7^3+T_8^3) + MT;
    J := ideal jacobian ideal G;
    << label << ": dim Sing = " << dim J - 1 << ", degree = " << (if dim J > 0 then degree J else 0);
    if dim J > 0 then << ", Hilbert polynomial = " << toString hilbertPolynomial(J, Projective => false);
    << endl;
    (T, G, J));
(T, G, J) = doit(QQ, {3,15,18}, -342, "QQ, x=(3,15,18), a=-342");
doit(QQ, {3,15,18}, -341, "QQ, x=(3,15,18), a=-341 (control)");
doit(QQ, {3,15,19}, -342, "QQ, x=(3,15,19), a=-342 (control)");
doit(QQ, {3,15,18}, 1, "QQ, x=(3,15,18), a=1, i.e. G_x itself (control)");
-- saturation and its Hilbert function
Jsat = saturate(J, ideal vars T);
<< "saturation: generators in degrees " << toString apply(flatten entries mingens Jsat, f -> first degree f) << endl;
<< "Hilbert function of T/Jsat, degrees 0..6: " << toString apply(7, d -> hilbertFunction(d, Jsat)) << endl;
<< "Jsat radical-ness / smoothness is tested below mod p" << endl;
-- smoothness of the scheme V(J): at a point of V(J) the Zariski tangent space is the kernel of the Hessian of G.
p = 32003;
(Tp, Gp, Jp) = doit(ZZ/p, {3,15,18}, -342, "ZZ/32003, x=(3,15,18), a=-342");
H = jacobian ideal Gp;   -- Hessian matrix (9 x 9, linear forms)
H = jacobian matrix{flatten entries gens ideal jacobian ideal Gp};
t0 = cpuTime();
-- points where rank Hessian <= 5: add 6x6 minors (use a random sample of minors large enough to cut down, then all if needed)
M6 = minors(6, H);
<< "number of 6x6 minors generators: " << numgens M6 << "  (" << cpuTime()-t0 << " s)" << endl;
B = Jp + M6;
gB = groebnerBasis(B, Strategy => "F4");
Bd = dim ideal gB;
<< "MOD 32003: dim of {rank Hessian <= 5} inside Sing (affine cone dim; 0 means empty projectively) = " << Bd << endl;
-- cohomology of the structure sheaf of the singular locus (mod p)
X = Proj(Tp/Jp);
<< "MOD 32003: h^0(O), h^1(O), h^2(O) of the singular locus = " << rank HH^0(OO_X) << ", " << rank HH^1(OO_X) << ", " << rank HH^2(OO_X) << endl;
