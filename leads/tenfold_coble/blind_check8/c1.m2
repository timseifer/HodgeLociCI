-- C1: exact check of the certificate over F_(p^2)
cert = value get "/home/claude/hodgelocici/leads/tenfold_coble/pairing/arcdata/certificate_32003_seed1.txt";
p = cert#"p";
print("p = " | toString p | "  isPrime " | toString isPrime p);
print("minpoly string: " | cert#"minpoly");
-- irreducibility of minpoly over F_p
T0 = (ZZ/p)[aa];
mp = value cert#"minpoly";
print("minpoly factors: " | toString factor mp);
K = toField(T0/ideal(mp));
print("K order check: aa^(p^2-1) == 1 : " | toString((aa_K)^(p^2-1) == 1_K));
R = K[u_0..u_7, tau];
use R;
aa = sub(aa_K, R);
lam = cert#"lam"; xs = cert#"x";
print("lam = " | toString lam | " x = " | toString xs);
hyp = apply(cert#"hyperplane", value);
A = matrix apply(cert#"A", r -> apply(r, value));
B = matrix apply(cert#"B", r -> apply(r, value));
c = value cert#"c";
print("c = " | toString c | "   c != 0: " | toString(c != 0));
-- Coble cubic
h = (v) -> v#0^3 + v#1^3 + v#2^3 + 3*lam*v#0*v#1*v#2;
a = -(h(xs)) * (1/(27*(1+lam^3)))_K;
print("1+lam^3 mod p = " | toString((1+lam^3) % p) | "   a = " | toString a);
coble = (z,pp,q) -> a*h(z) + h(pp) + h(q) + sum(3, i -> sum(3, j -> xs#((i-j)%3) * z#((i+j)%3) * pp#i * q#j));
G = coble(hyp_{0,1,2}, hyp_{3,4,5}, hyp_{6,7,8});
print("G != 0: " | toString(G != 0) | "  #terms G = " | toString(#terms G));
I3 = id_(R^3);
L = det(tau*I3 + A) - det(tau*I3 + B);
print("IDENTITY det(tau+A)-det(tau+B) == c*G : " | toString(L == c*G));
print("tr A == tr B : " | toString(trace A == trace B));
s2 = M -> M_(0,0)*M_(1,1)-M_(0,1)*M_(1,0) + M_(0,0)*M_(2,2)-M_(0,2)*M_(2,0) + M_(1,1)*M_(2,2)-M_(1,2)*M_(2,1);
print("s2 A == s2 B : " | toString(s2 A == s2 B));
print("det A - det B == c*G : " | toString(det A - det B == c*G));
print("tr A = " | toString trace A);
print("tr A == 0 : " | toString(trace A == 0));
-- independence of nine entries of tau+A, tau+B
vars9 = vars R;
cA = (coefficients(flatten (tau*I3 + A), Monomials => vars9))#1;
cB = (coefficients(flatten (tau*I3 + B), Monomials => vars9))#1;
print("rank entries tau+A : " | toString rank cA | "   rank entries tau+B : " | toString rank cB);
-- entries of A alone (linear forms in u): span
cA0 = (coefficients(flatten A, Monomials => vars9))#1;
cB0 = (coefficients(flatten B, Monomials => vars9))#1;
print("rank span entries A : " | toString rank cA0 | "  B : " | toString rank cB0 | "  A and B together : " | toString rank(cA0 | cB0));
-- degeneracy checks
dA = det A; dB = det B;
print("det A != 0 : " | toString(dA != 0) | "   det B != 0 : " | toString(dB != 0));
cc = (coefficients(matrix{{dA, dB, G}}))#1;
print("rank span{det A, det B, G} : " | toString rank cc | "  rank span{detA,detB} : " | toString rank(cc_{0,1}));
-- G a cone?  partials linearly independent?
jG = diff(matrix{{u_0,u_1,u_2,u_3,u_4,u_5,u_6,u_7}}, G);
cj = (coefficients(jG))#1;
print("rank of the 8 partials of G (8 = not a cone) : " | toString rank cj);
-- A and B conjugate by constant matrices?  (would force G = 0).  Also B = A^T ?
print("B == transpose A : " | toString(B == transpose A));
-- traceless parts and the linear map s : A0 -> B0
trA = trace A;
inv3 = (1/3)_K;
A0 = A - inv3*trA*I3; B0 = B - inv3*trA*I3;
print("tr(A0^2) == tr(B0^2) : " | toString(trace(A0*A0) == trace(B0*B0)));
print("det A0 - det B0 == c*G : " | toString(det A0 - det B0 == c*G));
-- coordinates: 8 entries of A0 (drop (2,2)) should be independent linear forms in u
ents = {(0,0),(0,1),(0,2),(1,0),(1,1),(1,2),(2,0),(2,1)};
uu = matrix{{u_0,u_1,u_2,u_3,u_4,u_5,u_6,u_7}};
CA = (coefficients(matrix{apply(ents, e -> A0_e)}, Monomials => uu))#1;
CB = (coefficients(matrix{apply(ents, e -> B0_e)}, Monomials => uu))#1;
print("rank 8 entries of A0 : " | toString rank CA | "   of B0 : " | toString rank CB);
