-- C1 exact over Q(w), w primitive cube root of unity
K = toField(QQ[w]/(w^2+w+1));
S = K[x_0..x_11];
lf = (i,j,e) -> x_i + w^e*x_j;
a = lf(0,1,0); c = lf(0,1,1); f = lf(0,1,2);
b = lf(2,3,0); d = lf(2,3,1); e = lf(2,3,2);
a' = lf(4,5,0); c' = lf(4,5,1); f' = lf(4,5,2);
b' = lf(6,7,0); d' = lf(6,7,1); e' = lf(6,7,2);
A0 = matrix{{a,b,0},{0,c,d},{e,0,f}};
B0 = matrix{{a',b',0},{0,c',d'},{e',0,f'}};
l1 = x_8+x_9; Q1 = x_8^2-x_8*x_9+x_9^2;
l2 = x_10+x_11; Q2 = x_10^2-x_10*x_11+x_11^2;
Fer = sum(12, i -> x_i^3);
<< "product of 3 factors = x0^3+x1^3: " << (a*c*f == x_0^3+x_1^3) << endl;
<< "det[[a,b,0],[0,c,d],[e,0,f]] == acf+bde: " << (det A0 == a*c*f + b*d*e) << endl;
<< "Fermat == detA0+detB0+l1Q1+l2Q2: " << (Fer == det A0 + det B0 + l1*Q1 + l2*Q2) << endl;
IT = ideal(l1,l2) + minors(2, A0^{0,1}) + minors(2, B0^{0,1});
<< "minors rows 1,2 of A0: " << toString flatten entries gens minors(2, A0^{0,1}) << endl;
<< "dim (affine) " << dim IT << " degree " << degree IT << " codim " << codim IT << endl;
<< "Fermat in I(T5): " << (Fer % IT == 0) << endl;
pl = (k1,k2,k3,k4) -> ideal(lf(0,1,k1), lf(2,3,k2), lf(4,5,k3), lf(6,7,k4), l1, l2);
Lsh = {(0,0),(0,1),(1,1)};
planes = flatten apply(Lsh, u -> apply(Lsh, v -> pl(u#0,u#1,v#0,v#1)));
U = intersect planes;
<< "I(T5) == intersection of the 9 plane ideals p(k1,k2,k3,k4), (k1,k2),(k3,k4) in L-shape: " << (IT == U) << endl;
<< "hence radical (reduced, each plane multiplicity 1): " << (IT == U) << "; hilbert polynomial: " << toString hilbertPolynomial(IT, Projective=>false) << endl;
-- does some other L-shape or labelling match?  all 9 planes distinct:
<< "number of distinct planes: " << #unique apply(planes, p -> toString gens gb p) << endl;
-- all Fermat planes of this pairing contained in T5: brute force over 81
cnt = 0;
for k in (0,0,0,0)..(2,2,2,2) do if isSubset(IT, pl(k#0,k#1,k#2,k#3)) then cnt = cnt+1;
<< "planes p(k1..k4) (out of 81) contained in T5: " << cnt << endl;

-- C6 at the Fermat point, exact
IF = ideal(l1,l2,Q1,Q2) + minors(2,A0) + minors(2,B0);
J = ideal jacobian ideal Fer;
<< "Fermat: HF of S/I: " << toString apply(8, i -> hilbertFunction(i, S/IF)) << endl;
<< "Fermat: J subset I: " << isSubset(J, IF) << endl;
-- Jacobian-determinant representative of a plane {f_i=0}, Fermat = sum f_i g_i
aP = (ks) -> (
    prs := {(0,1),(2,3),(4,5),(6,7),(8,9),(10,11)};
    fs := apply(6, t -> lf(prs#t#0, prs#t#1, ks#t));
    gs := apply(6, t -> lf(prs#t#0, prs#t#1, ks#t+1)*lf(prs#t#0, prs#t#1, ks#t+2));
    assert(sum(6, t -> fs#t*gs#t) == Fer);
    det jacobian matrix{fs|gs});
ad = aP{1,1,1,1,0,0} - aP{1,1,0,2,0,0} - aP{0,2,1,1,0,0} + aP{0,2,0,2,0,0};
aT = sum flatten apply(Lsh, u -> apply(Lsh, v -> aP{u#0,u#1,v#0,v#1,0,0}));
<< "a_T5 - a_delta2 in J (i.e. [T5]_prim = delta_2 in the Jacobian ring): " << ((aT - ad) % J == 0) << endl;
Ann = J : ideal(ad);
<< "Fermat: (J : a_delta2) == I: " << (Ann == IF) << endl;
<< "Fermat: HF of S/(J:a_delta2): " << toString apply(8, i -> hilbertFunction(i, S/Ann)) << endl;
