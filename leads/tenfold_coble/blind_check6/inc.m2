-- inc.m2 : incidence computation for Q2 (load after common, fano, planes)
-- conic parametrization of {Q_a = 0} in the plane pi (3x9 matrix);  returns (ys, A1) with ys a 1x9 matrix over A1 = kk[s]
A1 = kk[s];
conicParam = (a, piM) -> (
    Ha := hessAt a;
    Cq := piM * Ha * transpose piM;          -- 3x3 symmetric, conic in pi
    if det Cq == 0 then error "conic singular";
    e0 := null;
    while e0 === null do (
        r1 := random(kk^1, kk^3); r2 := random(kk^1, kk^3);
        qq0 := (r1 * Cq * transpose r1)_(0,0); qq1 := (r1 * Cq * transpose r2)_(0,0); qq2 := (r2 * Cq * transpose r2)_(0,0);
        pol := qq0 + 2*qq1*s + qq2*s^2;
        fl := select(toList factor pol, f -> first degree(f#0) == 1);
        if #fl > 0 then (
            lf := fl#0#0;   -- c1*s + c0
            rt := - coefficient(1_A1, lf) / coefficient(s, lf);
            e0 = r1 + sub(rt, kk) * r2;
            if (e0 * Cq * transpose e0)_(0,0) != 0 then error "root wrong";
            ));
    e1 := random(kk^1, kk^3); e2 := random(kk^1, kk^3);
    dS := sub(e1, A1) + s * sub(e2, A1);
    qd := (dS * sub(Cq, A1) * transpose dS)_(0,0);
    bd := (sub(e0, A1) * sub(Cq, A1) * transpose dS)_(0,0);
    us := -qd * sub(e0, A1) + 2 * bd * dS;         -- 1x3 over A1, quadratic
    ys := us * sub(piM, A1);
    -- point at infinity of the parametrization
    uinf := -(e2 * Cq * transpose e2)_(0,0) * e0 + 2 * (e0 * Cq * transpose e2)_(0,0) * e2;
    (ys, uinf * piM, us) );
-- incidence ideal { (s, P) : a, y(s) in P, P in Y }  in a chart
incidenceIdeal = (a, ys) -> (
    Cb := random(kk^7, kk^9);
    RT := kk[sv, tt_(0,0)..tt_(2,3), ss_0..ss_4];
    T := matrix apply(3, i -> apply(4, j -> tt_(i,j)_RT));
    W := (id_(RT^3) | T) * sub(Cb, RT);
    ysv := sub(ys, {s => sv_RT});
    Pm := sub(a, RT) || ysv || W;
    v := (matrix{apply(5, i -> ss_i_RT)}) * Pm;
    cf := (coefficients(sub(F, v), Variables => apply(5, i -> ss_i_RT)))#1;
    RT2 := kk[tt_(0,0)..tt_(2,3), sv, MonomialOrder => Eliminate 12];
    I := ideal sub(cf, RT2);
    (I, sub(Pm, RT2), RT2) );
