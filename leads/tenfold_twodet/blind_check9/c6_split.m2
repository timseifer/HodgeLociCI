-- non-Fermat member of (D4) with T5 = 9 planes, of "split" type F = F1(x0..x5) + F2(x6..x11)
-- (so that the Groebner basis of the Jacobian ideal is cheap).  MOD p.
p = 32003; setRandomSeed 77;
kk = ZZ/p; S = kk[x_0..x_11];
S1 = kk[x_0..x_5]; S2 = kk[x_6..x_11];
i1 = map(S,S1); i2 = map(S,S2);
r1 = () -> i1 random(1,S1); r2 = () -> i2 random(1,S2);
(a,b,c,d,e,f) = (r1(),r1(),r1(),r1(),r1(),r1());
(a',b',c',d',e',f') = (r2(),r2(),r2(),r2(),r2(),r2());
l1 = r1(); l2 = r2(); Q1 = i1 random(2,S1); Q2 = i2 random(2,S2);
A = matrix{{a,b,0},{0,c,d},{e,0,f}}; B = matrix{{a',b',0},{0,c',d'},{e',0,f'}};
F = l1*Q1 + l2*Q2 + det A + det B;
I = ideal(l1,l2,Q1,Q2) + minors(2,A) + minors(2,B);
<< "HF(S/I) = " << toString apply(8, i -> hilbertFunction(i, S/I)) << endl << flush;
IT = ideal(l1,l2) + minors(2, A^{0,1}) + minors(2, B^{0,1});
compsA = {((a,b),(c*f,d*e)), ((a,d),(c*f,b*e)), ((c,d),(a*f,b*e))};
compsB = {((a',b'),(c'*f',d'*e')), ((a',d'),(c'*f',b'*e')), ((c',d'),(a'*f',b'*e'))};
aT = 0_S; pls = {};
for u in compsA do for v in compsB do (
    fs := {l1,l2,u#0#0,u#0#1,v#0#0,v#0#1}; gs := {Q1,Q2,u#1#0,u#1#1,v#1#0,v#1#1};
    assert(sum(6, t -> fs#t*gs#t) == F);
    aT = aT + det jacobian matrix{fs|gs};
    pls = append(pls, ideal fs));
<< "each of the 9 planes lies in T5: " << all(pls, q -> isSubset(IT, q)) << "; distinct: " << (#unique apply(pls, q -> toString gens gb q)) << "; T5 affine dim " << dim IT << " degree " << degree IT << endl << flush;
J = ideal jacobian ideal F;
t0 = cpuTime();
G = gb J;
<< "gb of J: " << cpuTime() - t0 << " s;  dim S/J = " << dim J << " (0 = smooth), length " << degree J << endl << flush;
<< "a_T in J ? " << (aT % J == 0) << endl << flush;
<< "a_T * (generators of I) in J ? " << ((aT * gens I) % J == 0) << endl << flush;
Rq = S/J;
aq = sub(aT, Rq);
<< "terms of normal form of a_T: " << #terms aq << endl << flush;
t0 = cpuTime();
B3 = basis(3,Rq); B9 = basis(9,Rq);
Mq = aq * B3;
cf = (coefficients(Mq, Monomials => B9))#1;
rk = rank cf;
<< "rank of multiplication by a_T, (S/J)_3 -> (S/J)_9 : " << rk << " of " << numcols B3 << " -> codim of first-order Hodge locus; dim (S/I)_3 = " << hilbertFunction(3, S/I) << "   [" << cpuTime() - t0 << " s]" << endl << flush;
-- is this member projectively different from Fermat?  crude invariant: rank of the Hessian-type data is not needed;
-- just report that F1 is a general cubic fourfold of the form l1 Q1 + acf + bde
-- alternate (literal D4) reading of the ideal with only the row-1,2 minors:
I' = ideal(l1,l2,Q1,Q2) + minors(2, A^{0,1}) + minors(2, B^{0,1});
<< "ideal with only the 3+3 minors of rows 1,2: J inside it? " << isSubset(J, I') << ", dim " << dim I' << endl;
