-- T4 over the function field QQ(a0,a1,a2)  (a = the parameters x of M_x).  EXACT.
A = frac(QQ[a_0..a_2]);
T = A[Y_0..Y_2, P_0..P_2, Q_0..Q_2];
md = d -> sum(3, i -> sum(3, j -> if (i-j)%3 == d then T_((i+j)%3) * T_(3+i) * T_(6+j) else 0));
M = a_0*md(0) + a_1*md(1) + a_2*md(2);
G = (T_0^3+T_1^3+T_2^3) + (T_3^3+T_4^3+T_5^3) + (T_6^3+T_7^3+T_8^3) + M;
J = ideal jacobian ideal G;
PP = P_0*P_1*P_2; QQQ = Q_0*Q_1*Q_2;
t0 = cpuTime();
gbJ = gb J;
<< "GB of Jac(G_x) over QQ(a0,a1,a2): " << cpuTime()-t0 << " s; dim = " << dim J << ", degree(length of Jacobian ring) = " << degree J << endl;
for d from 0 to 2 do (
    << "(P-Q)*m_" << d << " in J: " << (((PP-QQQ)*md(d)) % J == 0) << endl;
    << "(P+Q)*m_" << d << " in J: " << (((PP+QQQ)*md(d)) % J == 0) << endl;
    );
<< "P-Q in J: " << ((PP-QQQ) % J == 0) << endl;
<< "P+Q in J: " << ((PP+QQQ) % J == 0) << endl;
<< "P in J, Q in J: " << (PP % J == 0) << ", " << (QQQ % J == 0) << endl;
<< "P*m_0 in J: " << ((PP*md(0)) % J == 0) << endl;
<< "(P-Q)*M_x in J: " << (((PP-QQQ)*M) % J == 0) << endl;
<< "Hilbert function of the Jacobian ring, degrees 0..9: " << toString apply(10, d -> hilbertFunction(d, J)) << endl;
