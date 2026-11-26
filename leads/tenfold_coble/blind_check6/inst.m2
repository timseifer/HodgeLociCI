-- inst.m2 : one random instance.  expects pp, sd, tag  defined.
load "common.m2"; load "fano.m2"; load "planes.m2"; load "inc.m2";
out = openOut("data_" | tag | ".txt");
wr = (key, val) -> (out << key << " = " << val << endl; );
wr("p", toString pp); wr("lam", toString lam); wr("x", m2py matrix{xx}); wr("acoef", toString aa);
print("== instance " | tag | ": p=" | toString pp | " seed=" | toString sd | " lam=" | toString lam | " x=" | toString xx | " a_coef=" | toString aa);
-- A. singular locus
print("A: affine dim of Jacobian ideal = " | toString dim J | ", degree = " | toString degree J);
pts = {};
while #pts < 4 do pts = pts | ratPointsA();
print("rational points of A found: " | toString(#pts));
a = pts#0; a2 = pts#1;
wr("a", m2py a); wr("a2", m2py a2);
print("grad F(a)=0: " | toString(sub(gradF, a) == 0) | ";  rank Hess_F(a) = " | toString rank hessAt a | ", rank Hess_F(a2) = " | toString rank hessAt a2);
Ka = transpose gens kernel hessAt a;
print("T_aA (kernel of Hessian) has affine dim " | toString numRows Ka | "; contained in Y: " | toString spanInY Ka);
-- B. explicit plane
print("iota preserves F: " | toString(sub(F, (vars R) * sub(iotaM,R)) == F) | "; (-1)-eigenspace P^3 in Y: " | toString spanInY Eminus);
(P0, inf0) = iotaPlane();
print("explicit plane: scheme of v has (affine dim, degree) = " | toString inf0 | "; plane in Y: " | toString spanInY P0 | "; a on it: " | toString(rank(P0 || a) == 5));
wr("P0", m2py P0);
-- C. planes through a
t0 = cpuTime();
planes = {}; nsplit = 0; nnons = 0; nother = 0;
while #planes < 110 do (
    tdir = random(kk^1, kk^3) * Ka;
    (pls, dgd, cinfo) = planesThroughTangent(a, tdir);
    if dgd != (0,2) then (nother = nother + 1; print("  unexpected Fano scheme: " | toString dgd | toString cinfo))
    else if #pls == 2 then (nsplit = nsplit + 1; planes = planes | pls)
    else nnons = nnons + 1;
    );
print("C: tangent directions tried " | toString(nsplit+nnons+nother) | ": Fano scheme (4-planes of Y through a containing the tangent line) is 0-dim of degree 2 in all but " | toString nother | " cases; 2 rational planes in " | toString nsplit | ", conjugate pair in " | toString nnons | "  [" | toString(cpuTime()-t0) | " s]");
print("   all sampled planes in Y, of rank 5, containing a: " | toString(all(planes, P -> spanInY P and rank P == 5 and rank(P || a) == 5)));
print("   number of distinct sampled planes: " | toString(#unique apply(planes, P -> gens gb image transpose P)));
wr("planes", "[" | demark(",", apply(planes, m2py)) | "]");
-- D. degree of Z_a via a random P^5 through a : curve Gamma in P^4
for trial from 1 to 2 do (
    Mm = a || random(kk^5, kk^9);
    gpts = apply(planes, P -> (
        Kl := gens kernel transpose (P || Mm);       -- 11 x 2
        cpart := transpose Kl^{6..10};                -- 2 x 5 (coordinates on m1..m5)
        transpose gens gb image transpose cpart ));   -- 1 x 5
    if not all(gpts, g -> numRows g == 1) then error "Gamma point not unique";
    G5 = fold((x,y) -> x || y, gpts);
    hf = apply(toList(1..7), d -> hilbRank(G5, d));
    print("D (trial " | toString trial | "): evaluation ranks of " | toString(#gpts) | " points of Gamma=Z_a/a cap P^4 in degrees 1..7: " | toString apply(hf, first) | "  (monomials: " | toString apply(hf, last) | ")");
    print("   successive differences: " | toString apply(6, i -> (hf#(i+1))#0 - (hf#i)#0));
    hf80 = apply(toList(1..6), d -> first hilbRank(G5^{0..89}, d));
    print("   same with only 90 of the points (degrees 1..6): " | toString hf80);
    );
-- E. second 4-plane, through a2
P1 = null;
Ka2 = transpose gens kernel hessAt a2;
while P1 === null do (
    (pls, dgd, cinfo) = planesThroughTangent(a2, random(kk^1,kk^3) * Ka2);
    if #pls == 2 then P1 = pls#0;);
print("E: plane P1 through a2: in Y " | toString spanInY P1 | ", contains a: " | toString(rank(P1 || a) == 5));
wr("P1", m2py P1);
rankDefCheck = (IG, Pm) -> (
    QI := (ring IG)/IG;
    mmQ := minors(5, sub(Pm, QI));
    (1_QI) % mmQ == 0 );
piMissesA = piM -> (
    R3 := kk[Variables => 3];
    piA := saturate(ideal sub(gradF, (vars R3) * sub(piM, R3)), ideal vars R3);
    piA == ideal(1_R3) );
-- F. incidence counts
cnt = 0;
for Pp in {P0, P1} do for rep from 1 to 2 do (
    cnt = cnt + 1;
    piM = random(kk^3, kk^5) * Pp;
    (ys, yinf, us) = conicParam(a, piM);
    (I, Pm, RT2) = incidenceIdeal(a, ys);
    t0 = cpuTime();
    IG = ideal groebnerBasis(I, Strategy => "F4");
    dI = (dim IG, degree IG);
    Ir = radical IG;
    spol = (flatten entries selectInSubring(1, gens gb IG));
    toA1 = map(A1, RT2, toList(12:0_A1) | {s});
    spolA = if #spol > 0 then toA1(spol#0) else 0_A1;
    fdeg = if spolA == 0 then {} else apply(toList factor spolA, f -> (first degree f#0, f#1));
    print("F (" | (if Pp === P0 then "explicit plane" else "plane P1") | ", pi #" | toString rep | "): incidence scheme {(y,P): y in pi, a,y in P, P 4-plane in Y}: (dim, degree) = " | toString dI | ", degree of radical = " | toString degree Ir | "; eliminant in s has degree " | toString(if spolA == 0 then -1 else first degree spolA) | " with factor (degree, multiplicity) pattern " | toString fdeg | " [" | toString(cpuTime()-t0) | " s]");
    rkdef = rankDefCheck(IG, Pm);
    piAempty = piMissesA(piM);
    print("     chart points with dependent spanning vectors: " | (if rkdef then "none" else "SOME") | ";  pi cap A empty: " | toString piAempty | ";  a on pi: " | toString(rank(piM || a) == 3));
    wr("pi_" | toString cnt, m2py piM);
    wr("ys_" | toString cnt, "[" | demark(",", apply(3, d -> m2py sub(matrix{apply(flatten entries ys, f -> coefficient(s^d, f))}, kk))) | "]");
    wr("yinf_" | toString cnt, m2py yinf);
    wr("spol_" | toString cnt, replace("\\}", "]", replace("\\{", "[", toString apply(toList(0..(first degree spolA)), d -> lift(coefficient(s^d, spolA), ZZ)))));
    wr("which_" | toString cnt, if Pp === P0 then "0" else "1");
    );
wr("ncases", toString cnt);
close out;
-- F2. the surface P' cap Z_a as a union of lines P' cap P_x : hyperplane section (a curve in P^3), Hilbert function from sampled points
for Pp in {P0, P1} do (
    hcov = random(kk^5, kk^1);
    spts = {};
    ldims = {};
    for P in planes do (
        Kl := gens kernel transpose (P || Pp);            -- 10 x r
        Lc := transpose Kl^{5..9};                        -- r x 5 : P cap P' in coordinates of P'
        Lc = transpose gens gb image transpose Lc;
        ldims = append(ldims, numRows Lc);
        if numRows Lc == 2 then (
            cc := transpose gens kernel transpose (Lc * hcov);     -- 1 x 2
            spts = append(spts, cc * Lc)));
    S5 = fold((x,y) -> x || y, spts);
    hfS = apply(toList(1..9), d -> first hilbRank(S5, d));
    print("F2 (" | (if Pp === P0 then "explicit plane" else "plane P1") | "): affine dims of P_x cap P' over the " | toString(#planes) | " sampled planes: " | toString tally ldims | "; hyperplane section of the union of these lines: evaluation ranks in degrees 1..9: " | toString hfS | ", differences " | toString apply(8, i -> hfS#(i+1) - hfS#i));
    );
-- F3. are there 4-planes of Y containing the whole tangent plane T_aA ?
(ITa, WTa, RTa) = fanoIdeal(Ka, map(kk^0, kk^9, 0));
GTa = ideal groebnerBasis(ITa, Strategy => "F4");
print("F3: scheme of 4-planes of Y containing the tangent plane T_aA (random chart): dim " | toString dim GTa | (if dim GTa == -1 then " (empty)" else " degree " | toString degree GTa));
-- F4. 4-planes through a and another point c of A
for cpt in drop(pts, 1) do (
    (pls, dgd, cinfo) = planesThroughTwo(a, cpt);
    print("F4: 4-planes of Y through a and another rational point c of A: (dim, degree) = " | toString dgd | ", components " | toString cinfo););
-- G. intersections of 4-planes
interInfo = (PA, PB) -> (
    Kl := gens kernel transpose (PA || PB);
    Lsp := transpose (transpose(PA) * Kl^{0..4});      -- rows span the intersection
    Lsp = transpose gens gb image transpose Lsp;
    d := numRows Lsp;
    res := "affine dim " | toString d;
    if d == 2 then (
        A2 := kk[u0, u1];
        ptl := matrix{{u0,u1}} * sub(Lsp, A2);
        gl := gcd flatten entries sub(gradF, ptl);
        res = res | " (a line); A cap line = zeros of a binary form of degree " | toString(first degree gl) | " with factors " | toString apply(toList factor gl, f -> (first degree f#0, f#1));
        );
    res );
print("G: P0 cap P1: " | interInfo(P0, P1));
for i from 0 to 3 do print("G: P_x#" | toString i | " cap P0: " | interInfo(planes#i, P0) | ";  cap P1: " | interInfo(planes#i, P1));
print("G: two planes through a with the same tangent direction: " | interInfo(planes#0, planes#1));
for i from 1 to 4 do print("G: two planes through a, different tangent directions: " | interInfo(planes#0, planes#(2*i)));
-- many random pairs
pairStats = tally apply(40, i -> (
    i1 := random(#planes); i2 := random(#planes);
    if i1 == i2 then "same" else (
      Kl := gens kernel transpose (planes#i1 || planes#i2);
      numColumns Kl)));
print("G: affine dim of P_x cap P_x' over 40 random pairs of sampled planes through a: " | toString pairStats);
pairStats2 = tally flatten apply(planes, P -> {numColumns gens kernel transpose (P || P0), numColumns gens kernel transpose (P || P1)});
print("G: affine dim of P_x cap P0 and P_x cap P1 over all sampled planes: " | toString pairStats2);
-- curve A cap P for a few planes : degree and genus
curveInfo = Pp -> (
    R5 := kk[g_0..g_4];
    Jp := ideal sub(gradF, (vars R5) * sub(Pp, R5));
    Js := saturate(Jp, ideal vars R5);
    (dim Js - 1, degree Js, hilbertPolynomial(Js, Projective => false), Js == radical Js) );
print("G: A cap P0 (proj dim, degree, Hilbert polynomial, reduced): " | toString curveInfo P0);
print("G: A cap P1: " | toString curveInfo P1);
print("G: A cap P_x#0: " | toString curveInfo(planes#0));
print("== done " | tag);
