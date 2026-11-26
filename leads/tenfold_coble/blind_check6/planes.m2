-- planes.m2 : more helpers (load after common.m2, fano.m2)

iotaM = matrix apply(9, i -> apply(9, j -> (
   blk := j // 3; k := j % 3;
   tgt := if blk == 0 then ((-k) % 3) else if blk == 1 then (6 + ((-k)%3)) else (3 + ((-k)%3));
   if i == tgt then 1_kk else 0_kk)));
Eminus = transpose gens kernel (iotaM + id_(kk^9));
Eplus = transpose gens kernel (iotaM - id_(kk^9));
-- the explicit plane : returns 5x9 matrix
iotaPlane = () -> (
    RV := kk[vv_0..vv_4, ss_0..ss_4];
    vgen := (matrix{{vv_0,vv_1,vv_2,vv_3,vv_4}}) * sub(Eplus, RV);
    Pm := sub(Eminus, RV) || vgen;
    pt := (matrix{{ss_0,ss_1,ss_2,ss_3,ss_4}}) * Pm;
    cf := (coefficients(sub(F, pt), Variables => {ss_0,ss_1,ss_2,ss_3,ss_4}))#1;
    RV2 := kk[vv_0..vv_4];
    Iv := saturate(ideal sub(cf, RV2), ideal vars RV2);
    if not (dim Iv == 1 and degree Iv == 1) then error "iota plane: v not unique";
    vsol := transpose gens kernel transpose (coefficients(gens Iv, Monomials => vars RV2))#1;
    vsol = sub(vsol, kk);
    (Eminus || (vsol * Eplus), (dim Iv, degree Iv)) );
-- 4-planes of Y through the point a with tangent direction tdir (tdir in T_aA) :
-- returns (list of rational planes as 5x9 matrices, (dim, degree) of the Fano scheme, component degrees)
planesThroughTangent = (a, tdir) -> (
    S := a || tdir;
    (I, W, RT2) := fanoIdeal(S, gradAt tdir);
    G := ideal groebnerBasis(I, Strategy => "F4");
    dgd := (dim G, degree G);
    if dgd#0 != 0 then return ({}, dgd, {});
    (sols, cinfo) := ratSolutions G;
    pls := apply(sols, sl -> (S || sub(W, sl)));
    (pls, dgd, cinfo) );
-- 4-planes of Y through two points (a, y) ; constraints = common tangent hyperplanes along the line
planesThroughTwo = (a, y) -> (
    S := a || y;
    Ucon := (a * hessAt(y)) || gradAt(y);
    Ucon = transpose gens trim image transpose Ucon;      -- independent rows
    (I, W, RT2) := fanoIdeal(S, Ucon);
    G := ideal groebnerBasis(I, Strategy => "F4");
    dgd := (dim G, degree G);
    if dgd#0 != 0 then return ({}, dgd, {});
    (sols, cinfo) := ratSolutions G;
    pls := apply(sols, sl -> (S || sub(W, sl)));
    (pls, dgd, cinfo) );
-- evaluation-rank Hilbert function of a finite set of points (rows of Pts, n columns) in degree d
RH5 = kk[Variables => 5];
hilbRank = (Pts, d) -> (
    n := numColumns Pts;
    Rn := if n == 5 then RH5 else kk[Variables => n];
    mons := basis(d, Rn);
    Mev := matrix apply(numRows Pts, i -> flatten entries sub(mons, Pts^{i}));
    (rank Mev, numColumns mons) );
m2py = M -> replace("\\}", "]", replace("\\{", "[", toString entries M));
