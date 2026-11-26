-- T2: restriction of F_x (x = (3,15,18)) to {r_k = -7 y_k} and its singular locus.  EXACT over QQ.
S = QQ[r_0..r_2, y_0..y_2, p_0..p_2, q_0..q_2];
h0 = v -> v_0^3 + v_1^3 + v_2^3;
xx = {3, 15, 18};
Mx = sum(3, i -> sum(3, j -> xx#((i-j)%3) * y_((i+j)%3) * p_i * q_j));
F = h0({r_0,r_1,r_2}) + h0({y_0,y_1,y_2}) + h0({p_0,p_1,p_2}) + h0({q_0,q_1,q_2}) + Mx;
T = QQ[Y_0..Y_2, P_0..P_2, Q_0..Q_2];
phi = map(T, S, {-7*Y_0, -7*Y_1, -7*Y_2, Y_0, Y_1, Y_2, P_0, P_1, P_2, Q_0, Q_1, Q_2});
MT = sum(3, i -> sum(3, j -> xx#((i-j)%3) * Y_((i+j)%3) * P_i * Q_j));
G = -342*(Y_0^3+Y_1^3+Y_2^3) + (P_0^3+P_1^3+P_2^3) + (Q_0^3+Q_1^3+Q_2^3) + MT;
<< "(a) restriction == -342 h0(y) + h0(p) + h0(q) + M_x : " << (phi F == G) << endl;
<< "    h_0(3,15,18)/27 = " << (3^3+15^3+18^3)/27 << endl;
J = ideal jacobian ideal G;
t0 = cpuTime();
gbJ = gb J;
<< "(b) Groebner basis of the Jacobian ideal over QQ: " << cpuTime() - t0 << " s" << endl;
<< "    dim of singular locus (projective) = " << dim J - 1 << endl;
<< "    degree = " << degree J << endl;
hp = hilbertPolynomial(J, Projective => false);
<< "    Hilbert polynomial of T/J = " << toString hp << endl;
<< "    Hilbert function of T/J in degrees 0..8: " << toString apply(9, d -> hilbertFunction(d, J)) << endl;
<< "    betti numbers of the minimal generators of J: " << toString apply(flatten entries mingens J, f -> first degree f) << endl;
t0 = cpuTime();
Jsat = saturate(J, ideal vars T);
<< "    J saturated w.r.t. the irrelevant ideal equals J: " << (Jsat == J) << "  (" << cpuTime() - t0 << " s)" << endl;
-- smoothness of the singular locus as a scheme: the Jacobian criterion for the scheme V(J) (codim 6)
t0 = cpuTime();
<< "    codim J = " << codim J << endl;
