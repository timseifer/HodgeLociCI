-- HodgeLociCI/SecondOrderTests.m2  (owner: agent PA)
-- TEST blocks of item 2; loaded after beginDocumentation().  Deterministic (fixed seeds).

TEST /// -- PA-S1. EXACT. Pointwise second-order formula: the values computed by hand in paper 3, Remark 10.3(iii)
S = QQ[x_0..x_3];
phi = {x_0 - x_1, x_2 - x_3};
psi = {x_0^3 + x_0^2*x_1 + x_0*x_1^2 + x_1^3, x_2^3 + x_2^2*x_3 + x_2*x_3^2 + x_3^3};
assert(sum(2, i -> phi#i * psi#i) == x_0^4 - x_1^4 + x_2^4 - x_3^4);
assert(grothendieckResidue(x_0^2*x_2^2, phi | psi) == -1/16);
L = secondOrderFunctional(phi, psi);
assert(L(x_0^6*x_2^2) == -3/64);
assert(L(x_0^2*x_2^2) == 0);                                   -- wrong degree
-- Griffiths-Dwork consistency on the Jacobian ideal (paper 3, Remark 10.3(iii)): for P = sum_j A_j dF/dx_j,
--   sum_nu Res[P/Phi_(nu)] = Res[sum_j dA_j/dx_j /(phi;psi)]       ((k+1) phi(P) = pi(div A), kappa cancels)
F = x_0^4 - x_1^4 + x_2^4 - x_3^4;
A = {x_0^3*x_2^2 + x_1*x_3^4, x_0*x_1^2*x_2*x_3 - 2*x_2^5, x_3^5 + x_0^2*x_1^3, x_0*x_1*x_2*x_3^2 + x_1^5};
P = sum(4, j -> A#j * diff(S_j, F));
assert(L P == grothendieckResidue(sum(4, j -> diff(S_j, A#j)), phi | psi));
assert(L P != 0);
assert((try secondOrderFunctional(phi, {x_0^3, x_2^2}) else "error") === "error");
///

TEST /// -- PA-S2. EXACT (over QQ). Coplanar lines on quintic surfaces: the excess direction DIES at a random point, SURVIVES at lambda0, and SURVIVES at second order when M_00(o) = 0 (paper 3, Corollary 9.2(2))
D = randomCyclePair(5, {1}, {1}, {1}, CoefficientRing => QQ, Seed => 5);
r = secondOrderObstruction(D, 2, Strategy => "Both");
assert(r#"verdict" == "ALL DIE" and r#"excess" == 1 and r#"strategiesAgree" === true);
assert(match("EXACT", r#"arithmetic") and match("EXACT", r#"label"));
assert(r#"commonZeroLocusDim" == -1 and r#"rankOfQuadrics" == 1);
r3 = secondOrderObstruction(D, -3/2, Strategy => "Both");
assert(r3#"verdict" == "ALL DIE" and r3#"strategiesAgree" === true);
r0 = secondOrderObstruction(D, 1);
assert(r0#"verdict" == "ALL SURVIVE" and r0#"excess" == 1);
-- the law: pointwise values at lambda are (lambda - lambda0)/lambda times the lambda-independent values
q = secondOrderQuadrics D;
p2 = secondOrderObstruction(D, 2, Strategy => "Pointwise");
p5 = secondOrderObstruction(D, 5, Strategy => "Pointwise");
assert(apply(p2#"values", v -> apply(v, a -> 2*a)) == q#"values");            -- (2-1)/2
assert(apply(p5#"values", v -> apply(v, a -> 5*a/4)) == q#"values");          -- (5-1)/5
-- special quintic: M_00 vanishes at the point o = (0:0:0:1) where the two lines meet
S = QQ[x_0..x_3];
M00 = x_0^3 + 2*x_1^3 - x_2^3 + x_0*x_3^2 + x_1*x_2*x_3 + x_2^2*x_3;
s0 = x_3^4 + x_0^4 - x_1^4 + 3*x_2^4 + x_0*x_1*x_3^2 + x_2*x_3^3;
Ds = cyclePair({x_0}, {x_1}, {x_2}, matrix{{M00}}, {s0});
rs = secondOrderObstruction(Ds, 2, Strategy => "Both");
assert(rs#"verdict" == "ALL SURVIVE" and rs#"excess" == 1 and rs#"rankOfQuadrics" == 0 and rs#"strategiesAgree" === true);
assert(rs#"dimK" == 1 and #(rs#"generators") >= 1);
-- the same with M_00(o) != 0: dies (Corollary 9.2(2): A != 0 iff det M(o) != 0)
Dt = cyclePair({x_0}, {x_1}, {x_2}, matrix{{M00 + x_3^3}}, {s0});
assert((secondOrderObstruction(Dt, 2))#"verdict" == "ALL DIE");
assert((try secondOrderObstruction(D, 0) else "error") === "error");
assert((try secondOrderObstruction(D, 2, Strategy => "Other") else "error") === "error");
///

TEST /// -- PA-S3. MOD p. Cubic sixfolds (Table 1 of paper 3, rows (3,3,c)): all excess directions die; formula = pointwise computation
expected = {(1, 2, 3), (2, 2, 2), (3, 1, 1)};          -- (c, e, number of independent quadrics): Cor. 9.5(2), Cor. 9.3, Cor. 8.2
for w in expected do (
    (c, e, nq) = w;
    D = randomCyclePair(3, toList(c:1), toList(c:1), toList(4-c:1), Seed => 500 + c);
    r = secondOrderObstruction(D, 2, Strategy => "Both");
    assert(r#"verdict" == "ALL DIE" and r#"excess" == e and r#"rankOfQuadrics" == nq and r#"strategiesAgree" === true);
    assert(r#"conditionS" and match("MOD p", r#"arithmetic"));
    r1 = secondOrderObstruction(D, 3, Strategy => "Both");
    assert(r1#"strategiesAgree" === true and r1#"verdict" == "ALL DIE");
    assert((secondOrderObstruction(D, (-1)^(c-1)))#"verdict" == "ALL SURVIVE");
    );
///

TEST /// -- PA-S4. MOD p. Cubic eightfolds, quartic and quintic fourfolds, coplanar lines (remaining rows of Table 1 of paper 3): e as in the table, condition (S), no common zero
rows = {(3,4,1,2), (3,4,2,2), (3,4,3,1), (4,2,1,2), (4,2,2,1), (5,2,1,1), (6,1,1,1), (7,1,1,1)};
for w in rows do (
    (d, k, c, e) = w;
    D = randomCyclePair(d, toList(c:1), toList(c:1), toList(k+1-c:1), Seed => 600 + 10*d + c, CheckSmooth => (k < 4));
    r = secondOrderObstruction(D, 2);
    assert(r#"verdict" == "ALL DIE" and r#"excess" == e and r#"conditionS" and r#"commonZeroLocusDim" == -1);
    if e == 2 then assert(r#"rankOfQuadrics" == 3);          -- the quadrics span all binary quadrics (Cor. 9.5, Remark (vii))
    );
-- one of them by both routes
D = randomCyclePair(4, {1}, {1}, {1,1}, Seed => 641);
assert((secondOrderObstruction(D, 3, Strategy => "Both"))#"strategiesAgree" === true);
///

TEST /// -- PA-S5. MOD p. Special points and controls: survive / some die / no excess
kk = ZZ/32003;
-- (a) all entries of M in (f,h,p,s) (two planes meeting in a point on a quartic fourfold): the second-order term vanishes (paper 3, section 8, check (iv))
R = kk[y_0..y_5];
setRandomSeed 101;
D = null;
for a from 1 to 10 do (
    s = {random(3,R)};
    M = matrix(R, table(2, 2, (i,j) -> sum({y_0,y_1,y_2,y_3,y_4}, u -> u*random(1,R))));
    D = try cyclePair({y_0,y_1}, {y_2,y_3}, {y_4}, M, s) else null;
    if D =!= null then break;
    );
assert(D =!= null);
r = secondOrderObstruction(D, 2, Strategy => "Both");
assert(r#"verdict" == "ALL SURVIVE" and r#"excess" == 1 and r#"dimK" > 0 and r#"strategiesAgree" === true);
-- a random instance of the same type: dies
Dg = randomCyclePair(4, {1,1}, {1,1}, {1}, Seed => 3);
assert((secondOrderObstruction(Dg, 2, Strategy => "Both"))#"verdict" == "ALL DIE");
-- (b) cubic sixfold, two 3-planes meeting in a line L, with det M restricted to L a square: the two quadrics have a common zero (Corollary 9.3(1))
R8 = kk[z_0..z_7];
setRandomSeed 202;
lin = () -> sum({z_0,z_1,z_2,z_3,z_4,z_5}, u -> random(kk)*u);
D3 = null;
for a from 1 to 10 do (
    s = {random(2,R8), random(2,R8)};
    M = matrix{{z_6 + lin(), lin()}, {lin(), z_6 + lin()}};
    D3 = try cyclePair({z_0,z_1}, {z_2,z_3}, {z_4,z_5}, M, s) else null;
    if D3 =!= null then break;
    );
assert(D3 =!= null);
r3 = secondOrderObstruction(D3, 2, Strategy => "Both");
assert(r3#"verdict" == "SOME DIE" and r3#"excess" == 2 and r3#"commonZeroLocusDim" == 0 and r3#"strategiesAgree" === true);
-- (c) tau < 0 and E' = 0: nothing to test
Dn = randomCyclePair(4, {1,1,1}, {1,1,2}, {}, Seed => 29);
assert((secondOrderObstruction(Dn, 2))#"verdict" == "NO EXCESS");
Dm = randomCyclePair(4, {1,1}, {1,1}, {1,1}, Seed => 31);       -- (d,k,c) = (4,3,2): tau = 0 outside the range, det M not in (f,h,p,s)
rm = secondOrderObstruction(Dm, 2);
assert(rm#"verdict" == "NO EXCESS" and rm#"excess" == 0 and rm#"eTau" == 1);
assert((secondOrderObstruction(Dm, -1))#"verdict" == "ALL SURVIVE");
///

TEST /// -- PA-S6. EXACT (over cyclotomic fields). Two coplanar lines on Fermat surfaces: the second-order term vanishes on the quintic and not on the sextic (paper 3, Corollary 9.2 and Remark (iv) of section 9; there confirmed modulo a prime only)
-- Fermat quintic: plane x_0 + x_1 = 0, lines x_2 + x_3 = 0 and x_2 - u x_3 = 0 with u^5 = -1 (u a primitive 10th root of unity)
K5 = toField(QQ[u]/(u^4 - u^3 + u^2 - u + 1));
S5 = K5[x_0..x_3];
p0 = x_0 + x_1; s0 = (x_0^5 + x_1^5) // p0;
f0 = x_2 + x_3; h0 = x_2 - u*x_3; M00 = (x_2^5 + x_3^5) // (f0*h0);
D5 = cyclePair({f0}, {h0}, {p0}, matrix{{M00}}, {s0});
assert(D5#"F" == x_0^5 + x_1^5 + x_2^5 + x_3^5);
r5 = secondOrderObstruction(D5, 2, Strategy => "Both");
assert(r5#"verdict" == "ALL SURVIVE" and r5#"excess" == 1 and r5#"strategiesAgree" === true and match("EXACT", r5#"arithmetic"));
assert((verifyExcess(D5, {1, -1, 2}))#"agrees");
-- Fermat sextic: plane x_0 = w x_1, lines x_2 = w x_3 and x_2 = w^3 x_3 with w^6 = -1 (w a primitive 12th root of unity)
K6 = toField(QQ[w]/(w^4 - w^2 + 1));
S6 = K6[x_0..x_3];
p0 = x_0 - w*x_1; s0 = (x_0^6 + x_1^6) // p0;
f0 = x_2 - w*x_3; h0 = x_2 - w^3*x_3; M00 = (x_2^6 + x_3^6) // (f0*h0);
D6 = cyclePair({f0}, {h0}, {p0}, matrix{{M00}}, {s0});
assert(D6#"F" == x_0^6 + x_1^6 + x_2^6 + x_3^6);
r6 = secondOrderObstruction(D6, 2, Strategy => "Both");
assert(r6#"verdict" == "ALL DIE" and r6#"excess" == 1 and r6#"strategiesAgree" === true and match("EXACT", r6#"arithmetic"));
assert((secondOrderObstruction(D6, 1))#"verdict" == "ALL SURVIVE");
///

TEST /// -- PA-S7. EXACT (over QQ). r < 0: the formula for every r (paper 3, Proposition 9.4') against the pointwise formula at the Fermat septic fourfold with two planes meeting in a line (the instance type (d,k,c) = (7,2,1) of the paper's Checks of Proposition 9.4'(a), there modulo 30059)
S = QQ[x_0..x_5];
F = sum(6, i -> x_i^7);
p0 = x_0 + x_1; p1 = x_2 + x_3 + x_4 + x_5;          -- Pi_1 = V(p0, x_2+x_3, x_4+x_5), Pi_2 = V(p0, x_2+x_4, x_3+x_5)
f0 = x_2 + x_3; h0 = x_2 + x_4;
s0 = (x_0^7 + x_1^7) // p0;
G = x_2^7 + x_3^7 + x_4^7 + x_5^7;
Gr = sub(G, {x_5 => -x_2-x_3-x_4});
M00 = Gr // (f0*h0);
assert(Gr == f0*h0*M00);
s1 = (G - f0*h0*M00) // p1;
D = cyclePair({f0}, {h0}, {p0, p1}, matrix{{M00}}, {s0, s1});
assert(D#"F" == F and D#"smooth" === true);
e = excessFromData D;
assert((e#"tau", e#"r", e#"inRange") == (2, -1, false));
assert((e#"eTau", e#"excessElsewhere", e#"conditionS") == (3, 2, false));      -- dim E' = 2 at this special point, (S) fails
r = secondOrderObstruction(D, 2, Strategy => "Both");
assert(r#"strategiesAgree" === true and r#"excess" == 2 and match("EXACT", r#"arithmetic"));
assert(any(flatten r#"values", a -> a != 0));
assert(r#"verdict" == "ALL DIE" and match("9.4\\(3\\)", r#"statement") and match("\\(S\\) fails", r#"statement"));
///

TEST /// -- PA-S8. MOD p. Non-linear degree types (rows of Tables 2 and 3 of paper 3): formula = pointwise computation on all five kinds of generators of K; A != 0 in the equality case tau = 0 (Corollary 8.2); a type with dim K < dim E'
types = {
    (4,{1,1},{1,1},{2},      1, "ALL DIE"),      -- tau = 0, generators of kinds M, p, s
    (4,{1,1,2},{1,1,2},{},   1, "ALL DIE"),      -- tau = 0, kinds M, f, h
    (3,{1,1,1,1},{1,1,1,2},{}, 1, "ALL DIE"),    -- tau = 0, c = 4 (a 3-plane and a disjoint quadric threefold in a cubic sixfold)
    (3,{1,1,1},{1,1,1},{2},  1, "ALL DIE"),      -- tau = 0, the shared equation a quadric
    (4,{1,1,2},{1,2,2},{},   3, "ALL DIE"),      -- tau = 1, three excess directions
    (6,{1},{1},{3},          3, "SOME DIE")};    -- tau = 2, dim K = 1 < 3: the quadrics must have common zeros (Remark (iii) of section 9)
allKinds = {};
for i from 0 to #types - 1 do (
    (d, df, dh, dp, e, vd) = types#i;
    D = randomCyclePair(d, df, dh, dp, Seed => 700 + i);
    assert((verifyExcess(D, {1, -1, 2}))#"agrees");
    r = secondOrderObstruction(D, 2, Strategy => "Both");
    assert(r#"strategiesAgree" === true and r#"excess" == e and r#"verdict" == vd);
    assert((secondOrderObstruction(D, D#"lambda0"))#"verdict" == "ALL SURVIVE");
    allKinds = unique(allKinds | apply(r#"generators", u -> u#0));
    );
assert(set allKinds === set {"M", "f", "h", "p", "s"});
///

TEST /// -- PA-S9. MOD p. Control at the special coefficient: along the pencil F - t N det M the second-order term of delta_lambda0 vanishes for ALL Q of degree kd-2k-2, and does not vanish with the opposite sign (paper 3, Theorem 1 and Remark 10.3(i))
types = {(3,{1,1},{1,1},{1,1}), (4,{1,1},{1,1},{1}), (4,{1,1,1},{1,2,3},{}), (5,{1},{1},{1})};
for i from 0 to #types - 1 do (
    (d, df, dh, dp) = types#i;
    D = randomCyclePair(d, df, dh, dp, Seed => 800 + i);
    S = D#"ring"; k = D#"k"; tau = D#"tau"; lam0 = D#"lambda0";
    L1 = secondOrderFunctional(D#"f" | D#"p", D#"g" | D#"s");
    L2 = secondOrderFunctional(D#"h" | D#"p", D#"q" | D#"s");
    nonzero = false;
    for j from 1 to 3 do (
        Q = random(k*d - 2*k - 2, S); N = random(tau, S); N' = random(tau, S);
        P = Q * N * N' * (D#"detM")^2;
        assert(L1 P + lam0 * L2 P == 0);
        if L1 P - lam0 * L2 P != 0 then nonzero = true;
        );
    assert nonzero;
    );
///
