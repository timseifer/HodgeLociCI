-- HodgeLociCI/ExcessTests.m2  (owner: agent PA)
-- TEST blocks of item 1; loaded after beginDocumentation().  Every test is deterministic (fixed seeds).
-- Labels: EXACT / MOD p say how the numbers of the test are computed; the expected values are those PROVED in
-- paper 3 (AI-written, unreviewed) unless a test says COMPUTED ONLY.

TEST /// -- PA-E1. EXACT. Hodge numbers and level (classical, Griffiths); Hilbert functions; residue symbol (paper 3, section 2 (R))
assert(primitiveHodgeNumbers(4,3) == {0,1,20,1,0});
assert(primitiveHodgeNumbers(2,4) == {1,19,1});
assert(primitiveHodgeNumbers(3,5) == {1,101,101,1});
assert(primitiveHodgeNumbers(6,3) == {0,0,8,70,8,0,0});
assert(hodgeLevel(4,3) == 2 and hodgeLevel(3,3) == 1 and hodgeLevel(6,3) == 2 and hodgeLevel(8,3) == 2);
assert(hodgeLevel(10,3) == 4 and hodgeLevel(3,5) == 3 and hodgeLevel(2,4) == 2);
assert(hodgeLevel(3,2) === -infinity and hodgeLevel(4,2) == 0 and hodgeLevel(2,1) == 0);
S = QQ[a,b,c,d];
I = ideal(a^2, b^3, c*d + a*b);
assert(all(0..7, m -> ciHilbertFunction({2,3,2}, 4, m) == hilbertFunction(m, S/I)));
assert(ciHilbertFunction({2,2}, 2, -1) == 0);
R = QQ[x,y,z];
G = {x^2 + y*z, y^3 - x*z^2, z^2 + x*y};
assert(grothendieckResidue(det jacobian matrix{G}, G) == 12);
assert(grothendieckResidue(x*y*z, {x^2,y^2,z^2}) == 1);
assert(grothendieckResidue(x*y*z, {y^2,x^2,z^2}) == -1);            -- alternating
assert(grothendieckResidue(x^2*y, {x^2,y^2,z^2}) == 0);             -- vanishes on the ideal
assert(grothendieckResidue(x*y, {x^2,y^2,z^2}) == 0);               -- wrong degree
-- transformation law Res[m det A/(A G)] = Res[m/G], A unimodular and A of determinant a linear form
m = x^2*y*z + 3*y^2*z^2 - x*z^3;
L0 = residueFunctional G;
A1 = matrix{{1, 0, 0}, {x - 2*z, 1, 0}, {5, 0, 1}};
G1 = flatten entries (A1 * transpose matrix{G});
assert(grothendieckResidue(m, G1) == L0 m);
ell = x + 2*y - z;
A2 = matrix{{ell, 0, 0}, {z, 1, 0}, {0, 0, 1}};
G2 = flatten entries (A2 * transpose matrix{G});
assert(grothendieckResidue(m * ell, G2) == L0 m);
assert(L0 m != 0);
-- input validation
assert((try grothendieckResidue(x, {x^2, x*y, z^2}) else "error") === "error");     -- not a regular sequence
assert((try grothendieckResidue(x, {x^2, y^2}) else "error") === "error");          -- wrong number of forms
///

TEST /// -- PA-E2. EXACT (integer arithmetic). excessFromDegrees against Table 2 (tab:tau) of paper 3 and the codimensions quoted in its introduction
rows = {
    (6,{1},{1},{2},  2,true,2), (6,{1},{1},{3},  2,true,3), (5,{1},{1},{2},  2,true,2), (5,{1},{1},{3},  2,true,2),
    (5,{1},{1},{1},  2,true,1), (3,{1,1},{1,1},{1},  1,true,1), (3,{1},{1},{1,1},  2,true,1),
    (4,{1,1,1},{1,2,3},{},  1,true,2), (4,{1,1,2},{1,2,2},{},  1,true,3), (4,{1,1},{1,2},{1},  1,true,2),
    (4,{1},{1},{1,1},  2,false,3), (4,{1,1,1},{1,1,2},{},  -1,true,0)};
for w in rows do (
    r = excessFromDegrees(w#0, w#1, w#2, w#3);
    assert(r#"tau" == w#4 and r#"inRange" == w#5 and r#"eTau" == w#6);
    assert(r#"lambda0" == (-1)^(#(w#1) - 1));
    assert(r#"excessAtLambda0" == (if w#4 >= 0 then w#6 else 0));
    );
-- outside the range the excess for other coefficients is not determined by the degrees
r = excessFromDegrees(4, {1}, {1}, {1,1});
assert(r#"excessElsewhere" === NotDetermined and r#"excessElsewhereBounds" == (2,3));
-- level dichotomy
assert((excessFromDegrees(4, {1,1,1}, {1,1,2}, {}))#"excessElsewhere" == 0);
assert(match("tau < 0", (excessFromDegrees(4, {1,1,1}, {1,1,2}, {}))#"levelDichotomy"));
assert(match("tau >= 0", (excessFromDegrees(4, {1,1}, {1,1}, {1}))#"levelDichotomy"));
-- two coplanar lines on a surface of degree d: codimensions d-3, 2d-6, 2d-7 (paper 3, section 1.1, "Dan's codimensions")
for d from 5 to 9 do (
    r = excessFromDegrees(d, {1}, {1}, {1});
    assert(r#"codimV1" == d-3 and r#"codimVZ" == 2*d-6 and r#"codimNLAtLambda0" == 2*d-7);
    );
-- cubics, two k-planes meeting in codimension two: codim NL at lambda0 = 2 binom(k+1,3) - binom(k-1,3) - (k-1) = 1,6,16,32,55
assert(apply(2..6, k -> (excessFromDegrees(3, {1,1}, {1,1}, toList(k-1 : 1)))#"codimNLAtLambda0") == (1,6,16,32,55));
assert(all(2..6, k -> (excessFromDegrees(3, {1,1}, {1,1}, toList(k-1 : 1)))#"codimNLAtLambda0"
        == 2*binomial(k+1,3) - binomial(k-1,3) - (k-1)));
-- twisted cubics on surfaces of degree d >= 6 (line and disjoint plane curve of degree d-2): codimension 3d-11
for d from 6 to 8 do assert((excessFromDegrees(d, {1,1}, {1,d-2}, {}))#"codimNLAtLambda0" == 3*d-11);
-- input validation: degrees must be < d; det M must not vanish for degree reasons (paper 3, section 10 (v))
assert((try excessFromDegrees(3, {1,1,1,1,1}, {1,1,1,1,3}, {}) else "error") === "error");
assert((try excessFromDegrees(5, {1,1,1}, {1,1,5}, {}) else "error") === "error");
assert((try excessFromDegrees(4, {3,3}, {3,3}, {}) else "error") === "error");
assert((try excessFromDegrees(4, {1,1}, {1}, {}) else "error") === "error");
///

TEST /// -- PA-E3. MOD p. Cubic sixfolds, two 3-planes meeting in dimension 3-c: degrees = data = direct computation (both strategies)
for c from 1 to 3 do (
    df = toList(c:1); dp = toList(4-c:1);
    r = excessFromDegrees(3, df, df, dp);
    D = randomCyclePair(3, df, df, dp, Seed => 100 + c);
    e = excessFromData D;
    assert(e#"tau" == r#"tau" and e#"eTau" == r#"eTau" and e#"inRange" == r#"inRange");
    assert((e#"codimV1", e#"codimV2", e#"codimVZ") == (r#"codimV1", r#"codimV2", r#"codimVZ"));
    assert(e#"excessAtLambda0" == r#"excessAtLambda0");
    if r#"excessElsewhere" =!= NotDetermined then assert(e#"excessElsewhere" == r#"excessElsewhere")
    else assert(e#"excessElsewhere" >= (r#"excessElsewhereBounds")#0 and e#"excessElsewhere" <= (r#"excessElsewhereBounds")#1);
    assert(e#"excessElsewhere" == (linearSubspaceCase(3, 3, c))#"genericExcessElsewhere");
    assert((verifyExcess D)#"agrees");
    assert((verifyExcess(D, Strategy => "Residue"))#"agrees");
    );
///

TEST /// -- PA-E4. MOD p. Cubic eightfolds, two 4-planes meeting in dimension 4-c (c = 1, 2 outside the range, c = 3 in the range)
for c from 1 to 3 do (
    df = toList(c:1); dp = toList(5-c:1);
    r = excessFromDegrees(3, df, df, dp);
    D = randomCyclePair(3, df, df, dp, Seed => 200 + c);
    e = excessFromData D;
    assert(e#"tau" == r#"tau" and e#"eTau" == r#"eTau");
    assert((e#"codimV1", e#"codimV2", e#"codimVZ") == (r#"codimV1", r#"codimV2", r#"codimVZ"));
    assert(e#"excessElsewhere" == (linearSubspaceCase(3, 4, c))#"genericExcessElsewhere");
    assert(e#"excessElsewhere" == {2, 2, 1}#(c-1));                                  -- Table 1 of paper 3
    v = verifyExcess(D, {1, -1, 2}, Strategy => "Residue");
    assert(v#"agrees");
    if c == 2 then assert((verifyExcess(D, {1, -1, 2}))#"agrees");                   -- Jacobian ring, 10 variables
    );
assert((excessFromDegrees(3, {1,1}, {1,1}, {1,1,1}))#"excessElsewhere" === NotDetermined);
///

TEST /// -- PA-E5. MOD p. Quartic and quintic fourfolds with two planes: (4,2,c), c = 1,2,3, and (5,2,1)
for w in {(4,1), (4,2), (4,3), (5,1)} do (
    (d, c) = w;
    df = toList(c:1); dp = toList(3-c:1);
    r = excessFromDegrees(d, df, df, dp);
    D = randomCyclePair(d, df, df, dp, Seed => 300 + 10*d + c);
    e = excessFromData D;
    assert(e#"tau" == r#"tau" and e#"eTau" == r#"eTau" and e#"dimAd" == r#"dimAd");
    assert((e#"codimV1", e#"codimV2", e#"codimVZ") == (r#"codimV1", r#"codimV2", r#"codimVZ"));
    assert(e#"excessElsewhere" == (linearSubspaceCase(d, 2, c))#"genericExcessElsewhere");
    assert((verifyExcess(D, Strategy => (if d == 5 then "Residue" else "Jacobian")))#"agrees");
    );
-- (4,2,3): tau = -2, no excess at all; (4,2,1): 3 directions at lambda0 = 1, 2 elsewhere; (5,2,1): 3 and 1
assert((excessFromDegrees(4, {1,1,1}, {1,1,1}, {}))#"tau" == -2);
///

TEST /// -- PA-E6. EXACT (over QQ). Quintic surfaces: coplanar lines (tau = 2), skew lines (tau = -1), two conics on a quadric (tau = 2)
D = randomCyclePair(5, {1}, {1}, {1}, CoefficientRing => QQ, Seed => 5);
assert(match("EXACT", D#"label"));
r = excessFromDegrees(5, {1}, {1}, {1});
e = excessFromData D;
assert((e#"tau", e#"eTau", e#"excessAtLambda0", e#"excessElsewhere") == (2, 1, 1, 1));
assert((e#"codimV1", e#"codimVZ", e#"codimNLAtLambda0") == (r#"codimV1", r#"codimVZ", r#"codimNLAtLambda0"));
assert((verifyExcess D)#"agrees");
assert((verifyExcess(D, Strategy => "Residue"))#"agrees");
D2 = randomCyclePair(5, {1,1}, {1,1}, {}, CoefficientRing => QQ, Seed => 6);
e2 = excessFromData D2;
assert(e2#"tau" == -1 and e2#"excessAtLambda0" == 0 and e2#"excessElsewhere" == 0);
assert(e2#"codimVZ" == (excessFromDegrees(5, {1,1}, {1,1}, {}))#"codimVZ");
assert((verifyExcess D2)#"agrees");
D3 = randomCyclePair(5, {1}, {1}, {2}, CoefficientRing => QQ, Seed => 7);
e3 = excessFromData D3;
assert((e3#"tau", e3#"eTau", e3#"excessElsewhere") == (2, 2, 2));
assert((verifyExcess(D3, {1, -1, 2}))#"agrees");
///

TEST /// -- PA-E7. MOD p. Theorem 9.7 and Table 1 of paper 3 (two linear subspaces): generic excess for lambda != 0, lambda0 at a random point
-- the nine sporadic triples and coplanar lines, with the value e of Table 1
tab = {(3,3,1,2), (3,3,2,2), (3,3,3,1), (3,4,1,2), (3,4,2,2), (3,4,3,1), (4,2,1,2), (4,2,2,1), (5,2,1,1), (5,1,1,1), (6,1,1,1), (7,1,1,1)};
for w in tab do (
    (d, k, c, e) = w;
    L = linearSubspaceCase(d, k, c);
    assert(L#"case" == "sporadic" and L#"genericExcessElsewhere" == e);
    D = randomCyclePair(d, toList(c:1), toList(c:1), toList(k+1-c:1), Seed => 1000*d + 10*k + c, CheckSmooth => (k < 4));
    assert((excessFromData D)#"excessElsewhere" == e);
    );
///

TEST /// -- PA-E7b. MOD p. Theorem 9.7 of paper 3, triples outside the list (those of Remark 10.2(c), (e)): no excess away from lambda0 at a random point
-- (smoothness of X is not tested for k >= 4 and for the sextic fourfolds: the rank condition tested is open in the data)
out = {(3,3,4), (3,4,4), (3,4,5), (4,2,3), (5,2,2), (5,2,3), (5,1,2), (6,1,2), (4,3,1), (4,3,2), (6,2,1), (6,2,2)};
for w in out do (
    (d, k, c) = w;
    L = linearSubspaceCase(d, k, c);
    assert(L#"case" == "tau < 0" or L#"case" == "generic");
    assert(L#"genericExcessElsewhere" == 0);
    D = randomCyclePair(d, toList(c:1), toList(c:1), toList(k+1-c:1), Seed => 1000*d + 10*k + c, CheckSmooth => (k < 4 and d*k < 12));
    assert((excessFromData D)#"excessElsewhere" == 0);
    assert((L#"tau" < 0) == (L#"case" == "tau < 0"));
    );
-- the excluded cases and the hypothesis kd-2k-2 >= 1
assert((linearSubspaceCase(3,1,1))#"case" == "excluded" and (linearSubspaceCase(3,2,3))#"case" == "excluded");
assert((linearSubspaceCase(4,1,2))#"case" == "excluded" and (linearSubspaceCase(4,1,2))#"genericExcessElsewhere" === NotDetermined);
assert((try linearSubspaceCase(2,2,1) else "error") === "error");
assert((try linearSubspaceCase(3,2,4) else "error") === "error");
///

TEST /// -- PA-E8. MOD p. Level dichotomy on both sides and non-linear degree types (rows of Table 2 of paper 3; one tau = 0 type on a sextic surface)
types = {(4,{1,1,1},{1,1,2},{}), (4,{1,1,1},{1,2,3},{}), (4,{1,1,2},{1,2,2},{}), (4,{1,1},{1,2},{1}), (6,{1,2},{1,2},{}), (6,{1},{1},{3})};
for i from 0 to #types - 1 do (
    (d, df, dh, dp) = types#i;
    r = excessFromDegrees(d, df, dh, dp);
    D = randomCyclePair(d, df, dh, dp, Seed => 400 + i);
    e = excessFromData D;
    assert(e#"tau" == r#"tau" and e#"eTau" == r#"eTau");
    assert((e#"codimV1", e#"codimV2", e#"codimVZ") == (r#"codimV1", r#"codimV2", r#"codimVZ"));
    assert(r#"inRange" and e#"excessElsewhere" == r#"excessElsewhere" and e#"excessAtLambda0" == r#"excessAtLambda0");
    v = verifyExcess D;
    assert(v#"agrees");
    if r#"tau" < 0 then assert(all(v#"table", t -> t#2 == 0))            -- tau < 0: no excess for any coefficient
    else assert(all(v#"table", t -> t#2 == r#"eTau"));                   -- tau >= 0 in the range: e_tau for every coefficient
    );
///

TEST /// -- PA-E9. MOD p. Negative controls: the special coefficient, special data, invalid input
-- (a) the sign of lambda0 matters: planes meeting in a line on a quartic fourfold have 3 excess directions at +1 and 2 at -1
D = randomCyclePair(4, {1}, {1}, {1,1}, Seed => 26);
assert((tangentExcess(D, 1))#"excess" == 3 and (tangentExcess(D, -1))#"excess" == 2);
assert((tangentExcess(D, 1, Strategy => "Residue"))#"excess" == 3 and (tangentExcess(D, -1, Strategy => "Residue"))#"excess" == 2);
-- two planes meeting in a point on a quartic fourfold (c = 2): outside... in the range, det M is tangent exactly at lambda0 = -1
D2 = randomCyclePair(4, {1,1}, {1,1}, {1}, Seed => 3);
S2 = D2#"ring";
J2 = ideal jacobian matrix{{D2#"F"}};
P1 = periodPolynomial(D2#"f" | D2#"p", D2#"g" | D2#"s");
P2 = periodPolynomial(D2#"h" | D2#"p", D2#"q" | D2#"s");
assert((D2#"detM" * (P1 - P2)) % J2 == 0);          -- det M lies in T NL(delta_{-1})
assert((D2#"detM" * (P1 + P2)) % J2 != 0);          -- and not in T NL(delta_{+1})
assert((D2#"detM" * P1) % J2 != 0);                 -- nor in T V_1
-- (b) the excess for lambda != lambda0 is not determined by the degrees: M_00 in (f,h,p,s) gives 3 instead of 2
kk = ZZ/32003; R = kk[y_0..y_5];
setRandomSeed 101;
D3 = null;
for a from 1 to 10 do (
    s = {random(3,R), random(3,R)};
    M = matrix{{y_0*random(1,R) + y_1*random(1,R) + y_2*random(1,R) + y_3*random(1,R)}};
    D3 = try cyclePair({y_0}, {y_1}, {y_2,y_3}, M, s) else null;
    if D3 =!= null then break;
    );
assert(D3 =!= null);
e3 = excessFromData D3;
assert(e3#"eTau" == 3 and e3#"excessElsewhere" == 3 and e3#"conditionS" == false);
assert((verifyExcess D3)#"agrees");
-- (c) invalid input is rejected with an error
S = QQ[x_0..x_3];
M = matrix{{x_2^2 + x_1*x_3, x_0^2 + x_3^2}, {x_1^2 - x_2^2 + x_0*x_3, x_3^2 + x_0*x_1}};
assert(instance(cyclePair({x_0, x_1}, {x_2, x_3}, {}, M, {}), CyclePair));
assert((try cyclePair({x_0, x_1}, {x_2}, {}, M, {}) else "error") === "error");                   -- lengths of f and h differ
assert((try cyclePair({x_0}, {x_2}, {}, matrix{{x_1^2}}, {}) else "error") === "error");           -- wrong number of variables
assert((try cyclePair({x_0, x_1}, {x_2, x_3}, {}, matrix{{x_0^2, x_1}, {x_2^2, x_3^2}}, {}) else "error") === "error");   -- F not homogeneous
assert((try cyclePair({x_0, x_1}, {x_0, x_3}, {}, M, {}) else "error") === "error");               -- (f,h) not a regular sequence
assert((try cyclePair({x_0, x_1}, {x_2, x_3}, {}, matrix{{x_0^2, 0}, {0, x_1^2}}, {}) else "error") === "error");         -- X singular
assert((try tangentExcess(D, 0) else "error") === "error");                                       -- lambda = 0
assert((try randomCyclePair(3, {1,3}, {1,1}, {}) else "error") === "error");                       -- degree not < d
///

TEST /// -- PA-E10. MOD p. hodgeLocusTangentCodim: complete intersections (paper 3, Lemma 3.2); a non-complete-intersection threefold (COMPUTED ONLY: session check C13); controls
D = randomCyclePair(3, {1,1}, {1,1}, {1,1}, Seed => 11);
r = hodgeLocusTangentCodim(D#"F", ideal(D#"f" | D#"p"));
assert(r#"hypothesis" and r#"codimIJ" == 1 and r#"exponent" == 1 and r#"socleHalfDegree" == 4);
assert(r#"codim" == (excessFromDegrees(3, {1,1}, {1,1}, {1,1}))#"codimV1");
D4 = randomCyclePair(4, {1,1}, {1,2}, {1}, Seed => 12);
r4 = hodgeLocusTangentCodim(D4#"F", ideal(D4#"h" | D4#"p"));
assert(r4#"codim" == (excessFromDegrees(4, {1,1}, {1,2}, {1}))#"codimV2" and r4#"exponent" == 2);
-- the union of the two cycles: the hypothesis fails and the function says so
ru = hodgeLocusTangentCodim(D#"F", intersect(ideal(D#"f" | D#"p"), ideal(D#"h" | D#"p")));
assert(ru#"codimIJ" == 2 and ru#"codim" === NotDetermined and ru#"upperBound" == (excessFromData D)#"codimVZ");
-- cubic sixfold F = det A + det B and the threefold T = {rows 1,2 of A dependent} cap {rows 1,2 of B dependent}:
-- codim (I_T + J)_4 = 1 and tangent codimension 8  (values found in the session, check C13, modulo three primes)
R = (ZZ/32003)[z_0..z_7];
setRandomSeed 1234;
rmat = () -> matrix(R, table(3, 3, (i,j) -> random(1, R)));
A = rmat(); B = rmat(); F = det A + det B;
IT = minors(2, A^{0,1}) + minors(2, B^{0,1});
t = hodgeLocusTangentCodim(F, IT);
assert(t#"codimIJ" == 1 and t#"hypothesis" and t#"codim" == 8);
-- controls: a subvariety not contained in X, a subvariety of the wrong dimension, a singular X
C = rmat();
assert((try hodgeLocusTangentCodim(F, minors(2, A^{0,1}) + minors(2, C^{0,1})) else "error") === "error");
assert((try hodgeLocusTangentCodim(D#"F", ideal(D#"f" | D#"p" | D#"h")) else "error") === "error");
assert((try hodgeLocusTangentCodim(z_0*z_1*z_2, ideal(z_0, z_1, z_2, z_3)) else "error") === "error");
///

TEST /// -- PA-E11. EXACT and MOD p on the same instance: reduction modulo primes of data over QQ; the quartic K3 and cubic surface edge cases
D = randomCyclePair(4, {1}, {1}, {1,1}, CoefficientRing => QQ, Seed => 41);
e = excessFromData D;
assert(match("EXACT", D#"label") and e#"eTau" == 3 and e#"excessElsewhere" == 2);
assert((verifyExcess(D, {1, -1, 2}, Strategy => "Residue"))#"agrees");
for pr in {32003, 30011} do (
    Dp = reduceModPrime(D, pr);
    assert(match("MOD p", Dp#"label") and char Dp#"field" == pr);
    ep = excessFromData Dp;
    assert((ep#"eTau", ep#"rankDetM", ep#"excessElsewhere", ep#"codimVZ") == (e#"eTau", e#"rankDetM", e#"excessElsewhere", e#"codimVZ"));
    assert((verifyExcess(Dp, {1, -1, 2}))#"agrees");
    );
assert((try reduceModPrime(D, 15) else "error") === "error");
assert((try reduceModPrime(reduceModPrime(D, 32003), 30011) else "error") === "error");
-- two skew lines on a quartic surface: tau = 0, in the range, one excess direction for every coefficient, K = 0, smooth locus
S = QQ[x_0..x_3];
M = matrix{{x_2^2 + x_1*x_3, x_0^2 + x_3^2}, {x_1^2 - x_2^2 + x_0*x_3, x_3^2 + x_0*x_1}};
Dk = cyclePair({x_0, x_1}, {x_2, x_3}, {}, M, {});
v = verifyExcess Dk;
assert(v#"agrees" and all(v#"table", t -> t#2 == 1));
assert((excessFromData Dk)#"codimVZ" == 2 and (excessFromData Dk)#"codimNLAtLambda0" == 1);
r = secondOrderObstruction(Dk, 2);
assert(r#"verdict" == "ALL SURVIVE" and r#"dimK" == 0 and match("K = 0", r#"statement"));
-- two skew lines on a cubic surface: no period conditions at all
Dc = randomCyclePair(3, {1,1}, {1,1}, {}, CoefficientRing => QQ, Seed => 43);
ec = excessFromData Dc;
assert(ec#"codimV1" == 0 and ec#"codimVZ" == 0 and ec#"excessElsewhere" == 0 and ec#"excessAtLambda0" == 0);
assert((verifyExcess Dc)#"agrees");
assert((hodgeLocusTangentCodim(Dc#"F", ideal Dc#"f"))#"codim" == 0);
///
