-- (P - Q) m_d in the Jacobian ideal of G_x at single rational points x, EXACT over QQ (a direct complement to
-- t_ks_grid.py, which proves it for generic x).  AI-written, unreviewed.
S = QQ[y_0..y_2, p_0..p_2, q_0..q_2];
h0 = (u,v,w) -> u^3 + v^3 + w^3;
ys = {y_0,y_1,y_2}; ps = {p_0,p_1,p_2}; qs = {q_0,q_1,q_2};
md = d -> sum flatten apply(3, i -> apply(3, j -> if (i-j)%3 == d then ys#((i+j)%3)*ps#i*qs#j else 0_S));
P = p_0*p_1*p_2; Q = q_0*q_1*q_2;
scan({{1,2,3}, {2,-1,5}, {3,15,18}}, xv -> (
    G := h0(y_0,y_1,y_2) + h0(p_0,p_1,p_2) + h0(q_0,q_1,q_2) + sum(3, d -> xv#d * md d);
    J := ideal jacobian matrix{{G}};
    << "x = " << xv << ": G_x smooth: " << (dim J == 0) << " ; (P - Q) m_d in J: " << apply(3, d -> ((P - Q) * md d) % J == 0)
       << " ; (P + Q) m_d in J: " << apply(3, d -> ((P + Q) * md d) % J == 0) << " ; P - Q in J: " << ((P - Q) % J == 0) << endl << flush));
