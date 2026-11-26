-- T4 at specific rational points (EXACT over QQ) and at random points mod p.
test = (kk, av, label) -> (
    T := kk[Y_0..Y_2, P_0..P_2, Q_0..Q_2];
    md := d -> sum(3, i -> sum(3, j -> if (i-j)%3 == d then T_((i+j)%3) * T_(3+i) * T_(6+j) else 0));
    M := av#0*md(0) + av#1*md(1) + av#2*md(2);
    G := (T_0^3+T_1^3+T_2^3) + (T_3^3+T_4^3+T_5^3) + (T_6^3+T_7^3+T_8^3) + M;
    J := ideal jacobian ideal G;
    PP := T_3*T_4*T_5; QQQ := T_6*T_7*T_8; YY := T_0*T_1*T_2;
    sm := (dim J == 0);
    r1 := apply(3, d -> ((PP-QQQ)*md(d)) % J == 0);
    r2 := apply(3, d -> ((PP+QQQ)*md(d)) % J == 0);
    r3 := (PP-QQQ) % J == 0;
    -- my hand reduction: (P-Q) m_d = -(a_d/3) sum_{i-j=d} y_(i+j)^2 ( p_(i+1)p_(i+2) q_j^2 - p_i^2 q_(j+1) q_(j+2) )  mod J
    r4 := apply(3, d -> ((PP-QQQ)*md(d) + (av#d/3) * sum(3, i -> (j := (i-d)%3; T_((i+j)%3)^2 * (T_(3+(i+1)%3)*T_(3+(i+2)%3)*T_(6+j)^2 - T_(3+i)^2*T_(6+(j+1)%3)*T_(6+(j+2)%3))))) % J == 0);
    r5 := apply(3, d -> ((PP-YY)*md(d)) % J == 0);
    << label << " a=" << toString av << ": G smooth " << sm << "; (P-Q)m_d in J " << toString r1 << "; (P+Q)m_d in J " << toString r2
       << "; P-Q in J " << r3 << "; hand reduction ok " << toString r4 << "; (P-Y)m_d in J " << toString r5 << endl;
    );
test(QQ, {3,15,18}, "QQ");
test(QQ, {1,2,3}, "QQ");
test(QQ, {-7/3, 5/2, 11}, "QQ");
test(QQ, {2, 0, 0}, "QQ");
test(QQ, {0, 1, -1}, "QQ");
test(QQ, {1/7, -3/5, 4/9}, "QQ");
test(QQ, {17, 29/3, -41/7}, "QQ");
setRandomSeed 20261126;
scan({32003, 1000003, 2147483629}, p -> (kk := ZZ/p; scan(4, t -> test(kk, {random kk, random kk, random kk}, "MOD " | toString p))));
