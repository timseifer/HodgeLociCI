loadPackage "Schubert2"
-- Z = zero locus in ambient A of a section of a split bundle with total Chern class cE and top class zc.
-- c(N_{Z/X}) = (1+h)^10 (1+3h)^{-1} / c(TZ),  c(TZ) = c(TA)/cE.
inv = (s,n) -> (t := 1 - s; sum(0..n, i -> t^i));
compute = (name, A, h, cE, zc) -> (
  n := dim A;
  cTA := chern tangentBundle A;
  cN := (1+h)^10 * inv(1+3*h, n) * cE * inv(cTA, n);
  deg := integral(h^4 * zc);
  zz := integral(part(4, cN) * zc);
  << name << ": dimA=" << n << " deg=" << deg << " Z.Z=" << zz << " disc=" << 3*zz - deg^2 << endl;
)
-- 1-4: complete intersections in P^n
for L in {{"1 P^4",4,{}},{"2 quadric 4-fold (1,1,1,1,2)",5,{2}},{"3 CI(1,1,1,2,2)",6,{2,2}},{"4 CI(1,1,2,2,2)",7,{2,2,2}}} do (
  A := abstractProjectiveSpace(L#1); h := chern(1, OO_A(1));
  compute(L#0, A, h, product(L#2, d -> 1 + d*h) + 0*h, product(L#2, d -> d*h) + 0*h));
-- products as trivial projective bundles
prodBundle = (B, r) -> (Y := projectiveBundle'(OO_B^(r+1)); (Y, chern(1, (Y.Bundles)#1), (Y.StructureMap)^* chern(1, OO_B(1))));
(Y,h2,h1) = prodBundle(abstractProjectiveSpace 1, 3); compute("5 P1xP3 Segre", Y, h1+h2, 1+0*h1, 1+0*h1);
(Y,h2,h1) = prodBundle(abstractProjectiveSpace 2, 2); compute("6 P2xP2 Segre", Y, h1+h2, 1+0*h1, 1+0*h1);
-- P1 x Q3: inside P4-base x P1-fibre, Q3 = zero locus of O(2) pulled back from P4
(Y,h1,h4) = prodBundle(abstractProjectiveSpace 4, 1); compute("7 P1xQ3 O(1,1)", Y, h1+h4, 1+2*h4, 2*h4);
-- G(2,5) cut by two Pluecker hyperplanes
G = flagBundle({2,3}); hG = chern(1, last G.Bundles);
<< "  check deg G(2,5) = " << integral(hG^6) << endl;
compute("8 dP5 4-fold = G(2,5) n H^2", G, hG, (1+hG)^2, hG^2);
-- scrolls P(O(a1)+..+O(a4)) over P1, H = tautological quotient
P1 = abstractProjectiveSpace 1;
for e in {{1,1,1,2},{1,1,2,2},{1,1,1,3}} do (
  S := projectiveBundle' sum(e, i -> OO_P1(i)); h := chern(1, (S.Bundles)#1);
  compute("9 scroll S" | toString e, S, h, 1+0*h, 1+0*h));
-- sanity: integral c4(T_P4) etc
