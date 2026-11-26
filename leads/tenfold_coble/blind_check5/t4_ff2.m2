-- T4 over a function field, with a degree-limited Groebner basis (only degree <= 6 is needed).
-- nparam = 1: a = (s, 5, -7)+... ; nparam = 3: all three parameters free
nparam = value (scriptCommandLine#1);
A = if nparam == 3 then frac(QQ[a_0..a_2]) else if nparam == 2 then frac(QQ[a_0,a_1]) else frac(QQ[a_0]);
av = if nparam == 3 then {a_0,a_1,a_2} else if nparam == 2 then {a_0, a_1, 11_A} else {a_0, 5_A, 11_A};
T = A[Y_0..Y_2, P_0..P_2, Q_0..Q_2];
md = d -> sum(3, i -> sum(3, j -> if (i-j)%3 == d then T_((i+j)%3) * T_(3+i) * T_(6+j) else 0));
M = av#0*md(0) + av#1*md(1) + av#2*md(2);
G = (T_0^3+T_1^3+T_2^3) + (T_3^3+T_4^3+T_5^3) + (T_6^3+T_7^3+T_8^3) + M;
J = ideal jacobian ideal G;
PP = P_0*P_1*P_2; QQQ = Q_0*Q_1*Q_2;
t0 = cpuTime();
g = gb(J, DegreeLimit => 6);
<< "nparam = " << nparam << ": GB up to degree 6: " << cpuTime()-t0 << " s, " << numcols gens g << " elements" << endl;
nf = f -> f % g;
for d from 0 to 2 do (
    << "(P-Q)*m_" << d << " in J: " << (nf((PP-QQQ)*md(d)) == 0) << "   (P+Q)*m_" << d << " in J: " << (nf((PP+QQQ)*md(d)) == 0) << endl;
    );
<< "P-Q in J: " << (nf(PP-QQQ) == 0) << ";  P+Q in J: " << (nf(PP+QQQ) == 0) << endl;
<< "P*m_0 in J: " << (nf(PP*md(0)) == 0) << endl;
<< "time total " << cpuTime()-t0 << endl;
