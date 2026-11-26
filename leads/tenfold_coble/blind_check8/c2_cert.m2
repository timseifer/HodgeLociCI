-- C2 (ii) with certificate data + random A1,B1,A2,B2, and (iii) the rank.
cert = value get "/home/claude/hodgelocici/leads/tenfold_coble/pairing/arcdata/certificate_32003_seed1.txt";
p = cert#"p";
T0 = (ZZ/p)[aa];
K = toField(T0/ideal(value cert#"minpoly"));
R = K[u_0..u_7, tau, t, e];
use R;
aa = sub(aa_K, R);
lam = cert#"lam"; xs = cert#"x";
hyp = apply(cert#"hyperplane", value);
A = matrix apply(cert#"A", r -> apply(r, value));
B = matrix apply(cert#"B", r -> apply(r, value));
c = value cert#"c";
h = (v) -> v#0^3 + v#1^3 + v#2^3 + 3*lam*v#0*v#1*v#2;
a = -(h(xs)) * (1/(27*(1+lam^3)))_K;
coble = (z,pp,q) -> a*h(z) + h(pp) + h(q) + sum(3, i -> sum(3, j -> xs#((i-j)%3) * z#((i+j)%3) * pp#i * q#j));
G = coble(hyp_{0,1,2}, hyp_{3,4,5}, hyp_{6,7,8});
I3 = id_(R^3);
setRandomSeed 20261126;
ut = {u_0,u_1,u_2,u_3,u_4,u_5,u_6,u_7,t};
rk = () -> (random(p))_K + (random(p))_K * aa;
rlin = () -> sum(ut, v -> rk()*v);
rmat = () -> matrix table(3,3,(i,j) -> rlin());
A1 = rmat(); B1 = rmat(); A2 = rmat(); B2 = rmat();
-- impose tr A1 = tr B1
B1 = B1 + matrix{{trace A1 - trace B1,0,0},{0,0,0},{0,0,0}};
print("tr A1 == tr B1 : " | toString(trace A1 == trace B1));
Ae = A + e*A1 + e^2*A2; Be = B + e*B1 + e^2*B2;
P = det(t*I3 + e*Ae) - det(t*I3 + e*Be);
print("(i) det(t+A) - det(t+B) == c*G : " | toString(det(t*I3 + A) - det(t*I3 + B) == c*G));
print("P divisible by e^3 : " | toString(P % e^3 == 0));
Q = P // e^3;
lim = sub(Q, {e => 0});
print("limit == c*G + t (tr(B B1) - tr(A A1)) + t^2 (trA2 - trB2) : " | toString(lim == c*G + t*(trace(B*B1) - trace(A*A1)) + t^2*(trace A2 - trace B2)));
print("limit ==   G + t (tr(B B1) - tr(A A1)) + t^2 (trA2 - trB2)  [as literally claimed, without c] : " | toString(lim == G + t*(trace(B*B1) - trace(A*A1)) + t^2*(trace A2 - trace B2)));
-- for e = e0 != 0 the member P/e0^3 = det((t + e0 A(e0))/e0') ... is a sum of two determinants: check numerically at e0
e0 = rk();
Ae0 = sub(Ae, {e => e0}); Be0 = sub(Be, {e => e0});
Pe0 = sub(Q, {e => e0});
print("member at e0: Q(e0)*e0^3 == det(t + e0 A(e0)) + det(-(t + e0 B(e0))) : " | toString(Pe0*e0^3 == det(t*I3 + e0*Ae0) + det(-(t*I3 + e0*Be0))));
-- (iii) rank of (A1,B1) -> tr(B B1) - tr(A A1) on {trA1 = trB1}
E = (i,j) -> matrix table(3,3,(r,s) -> if (r,s) == (i,j) then 1_R else 0_R);
Z = matrix table(3,3,(r,s) -> 0_R);
dom = {};
for m in ut do (
  for i from 0 to 2 do for j from 0 to 2 do if i != j then (dom = append(dom, (m*E(i,j), Z)); dom = append(dom, (Z, m*E(i,j))););
  dom = append(dom, (m*(E(0,0)-E(2,2)), Z)); dom = append(dom, (m*(E(1,1)-E(2,2)), Z));
  dom = append(dom, (Z, m*(E(0,0)-E(2,2)))); dom = append(dom, (Z, m*(E(1,1)-E(2,2))));
  dom = append(dom, (m*E(2,2), m*E(2,2)));
);
print("dimension of domain {trA1 = trB1} : " | toString(#dom));
imgs = apply(dom, ab -> trace(B*ab#1) - trace(A*ab#0));
mons2 = basis(2, R, Variables => ut);
cm = (coefficients(matrix{imgs}, Monomials => mons2))#1;
print("number of quadrics in (u,t): " | toString numcols mons2 | "   rank of image: " | toString rank cm);
-- is t^2 in the image? and is the image exactly the quadrics without t^2
monsNoT2 = submatrix'(mons2, , positions(flatten entries mons2, mm -> mm == t^2));
print("all images have zero t^2-coefficient : " | toString(all(imgs, q -> sub(contract(t^2, q), {t=>0}) == 0)) | "   #quadrics without t^2 = " | toString numcols monsNoT2);
-- the unconstrained map (no trace condition) and the map with B1 = 0, A1 traceless:
imgsU = flatten apply(ut, m -> flatten flatten table(3,3,(i,j) -> {trace(A*(m*E(i,j))), trace(B*(m*E(i,j)))}));
print("rank without the trace condition: " | toString rank (coefficients(matrix{imgsU}, Monomials => mons2))#1);
imgsA = apply(select(dom, ab -> ab#1 == Z), ab -> trace(A*ab#0));
print("rank using only traceless A1 (B1 = 0): " | toString rank (coefficients(matrix{imgsA}, Monomials => mons2))#1);
