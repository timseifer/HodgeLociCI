-- probe of the discriminant of the family G_x (which x give a singular cubic): small integer points, EXACT over QQ
T = QQ[Y_0..Y_2, P_0..P_2, Q_0..Q_2];
md = d -> sum(3, i -> sum(3, j -> if (i-j)%3 == d then T_((i+j)%3) * T_(3+i) * T_(6+j) else 0));
sing = av -> (G := (T_0^3+T_1^3+T_2^3) + (T_3^3+T_4^3+T_5^3) + (T_6^3+T_7^3+T_8^3) + av#0*md(0) + av#1*md(1) + av#2*md(2); J := ideal jacobian ideal G; (dim J - 1, if dim J > 0 then degree J else 0));
bad = {};
for a from -4 to 4 do for b from -4 to 4 do for c from -4 to 4 do (s := sing {a,b,c}; if s#0 >= 0 then bad = append(bad, ({a,b,c}, s)));
<< "integer points in [-4,4]^3 with singular G_x: " << #bad << " of 729" << endl;
<< toString bad << endl;
<< "x=(3,15,18): " << toString sing {3,15,18} << endl;
-- decompose the singular locus at x=(1,2,3)
G = (T_0^3+T_1^3+T_2^3) + (T_3^3+T_4^3+T_5^3) + (T_6^3+T_7^3+T_8^3) + 1*md(0) + 2*md(1) + 3*md(2);
<< "x=(1,2,3): minimal primes of the singular locus: " << toString (minimalPrimes ideal jacobian ideal G) << endl;
