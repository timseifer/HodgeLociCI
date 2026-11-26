-- The identity behind section 13.3 (AI-written, unreviewed).  G_x = h0(y) + h0(p) + h0(q) + M_x(y,p,q) over the
-- function field QQ(x_0,x_1,x_2) (written a,b,c).  With P = p_0 p_1 p_2, Q = q_0 q_1 q_2, Y = y_0 y_1 y_2 and
-- m_d = dM_x/dx_d:   (P - Q) m_d and (Y - P) m_d lie in the Jacobian ideal of G_x, for d = 0, 1, 2  (EXACT),
-- while P m_d, (P + Q) m_d do not, and P - Q itself is not in the Jacobian ideal.
K = frac(QQ[a,b,c]);
S = K[y_0..y_2, p_0..p_2, q_0..q_2];
h0 = (u,v,w) -> u^3 + v^3 + w^3;
xv = {a_K, b_K, c_K};
ys = {y_0,y_1,y_2}; ps = {p_0,p_1,p_2}; qs = {q_0,q_1,q_2};
md = d -> sum flatten apply(3, i -> apply(3, j -> if (i-j)%3 == d then ys#((i+j)%3)*ps#i*qs#j else 0_S));
G = h0(y_0,y_1,y_2) + h0(p_0,p_1,p_2) + h0(q_0,q_1,q_2) + sum(3, d -> xv#d * md d);
J = ideal jacobian ideal G;
elapsedTime gbJ = gb J;
P = p_0*p_1*p_2; Q = q_0*q_1*q_2; Y = y_0*y_1*y_2;
<< "Hilbert function of the Jacobian ring of G_x (generic x): " << apply(10, d -> hilbertFunction(d, S/J)) << endl;
<< "EXACT over QQ(x): (P - Q) m_d in J(G_x), d = 0,1,2: " << apply(3, d -> ((P - Q) * md d) % J == 0) << endl;
<< "EXACT over QQ(x): (Y - P) m_d in J(G_x), d = 0,1,2: " << apply(3, d -> ((Y - P) * md d) % J == 0) << endl;
<< "controls (must be false): P m_d: " << apply(3, d -> (P * md d) % J == 0)
   << ", (P + Q) m_d: " << apply(3, d -> ((P + Q) * md d) % J == 0)
   << ", P - Q in J: " << ((P - Q) % J == 0) << endl;
