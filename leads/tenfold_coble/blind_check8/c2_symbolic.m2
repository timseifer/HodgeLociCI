-- C2 (ii): fully symbolic check over ZZ with generic 3x3 matrices (54 indeterminate entries), plus t and e.
R = ZZ[a_(0,0)..a_(2,2), b_(0,0)..b_(2,2), a1_(0,0)..a1_(2,2), b1_(0,0)..b1_(2,2), a2_(0,0)..a2_(2,2), b2_(0,0)..b2_(2,2), t, e];
gm = s -> matrix table(3,3,(i,j) -> s_(i,j));
A = gm a; B = gm b; A1 = gm a1; B1 = gm b1; A2 = gm a2; B2 = gm b2;
I3 = id_(R^3);
s2 = M -> M_(0,0)*M_(1,1)-M_(0,1)*M_(1,0) + M_(0,0)*M_(2,2)-M_(0,2)*M_(2,0) + M_(1,1)*M_(2,2)-M_(1,2)*M_(2,1);
Ae = A + e*A1 + e^2*A2; Be = B + e*B1 + e^2*B2;
P = det(t*I3 + e*Ae) - det(t*I3 + e*Be);
cf = k -> sub(contract(e^k, P), {e => 0});   -- coefficient of e^k
print("coefficient e^0 == 0 : " | toString(cf 0 == 0));
print("coefficient e^1 == t^2 (trA - trB) : " | toString(cf 1 == t^2*(trace A - trace B)));
print("coefficient e^2 == t^2 (trA1 - trB1) + t (s2A - s2B) : " | toString(cf 2 == t^2*(trace A1 - trace B1) + t*(s2 A - s2 B)));
c3 = cf 3;
expected = (det A - det B) + t*(trace A * trace A1 - trace(A*A1) - trace B * trace B1 + trace(B*B1)) + t^2*(trace A2 - trace B2);
print("coefficient e^3 == detA - detB + t(trA trA1 - tr(A A1) - trB trB1 + tr(B B1)) + t^2 (trA2 - trB2) : " | toString(c3 == expected));
-- under trA = trB and trA1 = trB1 the middle term is t (tr(B B1) - tr(A A1)):
claimed = (det A - det B) + t*(trace(B*B1) - trace(A*A1)) + t^2*(trace A2 - trace B2);
d = c3 - claimed;
J = ideal(trace A - trace B, trace A1 - trace B1);
print("difference to claimed formula lies in ideal(trA - trB, trA1 - trB1) : " | toString(d % J == 0));
print("difference = " | toString factor d);
