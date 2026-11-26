-- From a determinantal cubic in 8 variables (det of a 3 x 3 matrix of linear forms spanning the 8 variables) to such a
-- matrix, by the Lie algebra of linear vector fields killing the cubic (sl_3, acting on the linear forms by the
-- adjoint representation): the eigenforms of a split regular element are the off-diagonal entries.  AI-written.
detRep = D -> ( Rh := ring D; kk := coefficientRing Rh; n := numgens Rh; if n != 8 then error "8 variables expected";
    B3 := basis(3, Rh);
    S := lift(last coefficients(matrix{flatten apply(n, i -> apply(n, j -> Rh_i * diff(Rh_j, D)))}, Monomials => B3), kk);
    K := gens ker S;
    if numColumns K != 8 then return ("Lie algebra of dimension " | toString numColumns K);
    Pc := kk(monoid[getSymbol "lam"]); lam := Pc_0;
    found := null; tries := 0;
    while found === null and tries < 400 do ( tries = tries + 1;
        v := K * random(kk^8, kk^1);
        Xt := matrix(kk, apply(n, i -> apply(n, j -> v_(n*i+j, 0))));
        fac := toList factor det(lam * id_(Pc^n) - sub(Xt, Pc));
        lf := select(fac, t -> first degree t#0 == 1);
        rt := apply(select(lf, t -> t#1 == 1), t -> - sub(t#0, lam => 0_Pc) / leadCoefficient(t#0));
        zr := select(lf, t -> t#1 == 2 and sub(t#0, lam => 0_Pc) == 0);
        if #rt == 6 and #zr == 1 then found = (Xt, apply(rt, r -> lift(r, kk))) );
    if found === null then return "no split regular element found";
    X := found#0; rts := found#1;
    al := rts#0; be := (select(rts, b -> b != al and b != -al and member(al + b, rts)))#0; ga := al + be;
    ef := a -> ( w := gens ker(X - a * id_(kk^n)); if numColumns w != 1 then error "eigenspace"; w );
    Z := gens ker X; if numColumns Z != 2 then error "zero weight space";
    Cm := ef(al) | ef(be) | ef(ga) | ef(-al) | ef(-be) | ef(-ga) | Z;              -- columns: f12 f23 f13 f21 f32 f31 z1 z2
    if det Cm == 0 then error "the eigenforms are dependent";
    Rn := kk(monoid[getSymbol "F12", getSymbol "F23", getSymbol "F13", getSymbol "F21", getSymbol "F32", getSymbol "F31", getSymbol "Z1", getSymbol "Z2"]);
    toN := map(Rn, Rh, (vars Rn) * sub(inverse Cm, Rn));
    Dn := toN D;
    (F12, F23, F13, F21, F32, F31) := (Rn_0, Rn_1, Rn_2, Rn_3, Rn_4, Rn_5);
    zsub := map(Rn, Rn, {0,0,0,0,0,0,Rn_6,Rn_7});
    co := (m) -> ( q := diff(m, Dn); zsub q );
    A := lift(co(F12*F23*F31), kk); B := lift(co(F13*F21*F32), kk);
    if A == 0 or B == 0 then return "a triple product is missing";
    l1 := - co(F23*F32); l2 := - co(F13*F31); l3 := - co(F12*F21);
    P := zsub Dn;
    if Dn != P + A*F12*F23*F31 + B*F13*F21*F32 - l1*F23*F32 - l2*F13*F31 - l3*F12*F21 then return "the cubic does not have the weight structure of a determinant for this choice of roots";
    pr := l1 * l2 * l3; if pr == 0 or P % ideal(pr) != 0 then return "the diagonal part is not a product";
    rho := lift(P // pr, kk);
    Mn := matrix{{l1, F12, (1/A) * F13}, {(1/rho) * F21, l2, F23}, {A * F31, F32, rho * l3}};
    back := map(Rh, Rn, (vars Rh) * sub(Cm, Rh));
    M := back Mn;
    if det M != D then return "the reconstructed determinant differs from the cubic";
    M );
-- Given 3 x 3 matrices MA, MB of linear forms (8 variables), find constant matrices mA, mB with
-- tr(MA mA) = tr(MB mB), s_2(MA mA) = s_2(MB mB), det mA = det mB != 0.  Returns (MA mA, MB mB) or a string.
s2of = M -> sum flatten apply(3, i -> apply(3, j -> if i < j then M_(i,i) * M_(j,j) - M_(i,j) * M_(j,i) else 0));
solvePair = (MA, MB) -> ( Rh := ring MA; kk := coefficientRing Rh; n := numgens Rh;
    -- the linear conditions: tr(MA mA) - tr(MB mB) = 0, unknowns (mA, mB) in k^18
    E := (i, j) -> matrix(kk, apply(3, a -> apply(3, b -> if (a, b) == (i, j) then 1 else 0)));
    unk := flatten apply(3, i -> apply(3, j -> (i, j)));
    lf := (apply(unk, ij -> trace(MA * sub(E ij, Rh)))) | (apply(unk, ij -> - trace(MB * sub(E ij, Rh))));
    Lm := lift(last coefficients(matrix{lf}, Monomials => vars Rh), kk);                 -- 8 x 18
    Nk := gens ker Lm; d := numColumns Nk;
    Sw := kk(monoid[Variables => d]);
    T := Sw(monoid Rh);
    vec := sub(Nk, Sw) * transpose vars Sw;                                              -- 18 x 1 over Sw
    mA := matrix apply(3, i -> apply(3, j -> vec_(3*i+j, 0))); mB := matrix apply(3, i -> apply(3, j -> vec_(9+3*i+j, 0)));
    At := sub(MA, T) * sub(mA, T); Bt := sub(MB, T) * sub(mB, T);
    if trace At != trace Bt then error "the linear step is wrong";
    e2 := s2of At - s2of Bt;
    I := ideal sub(last coefficients(matrix{{e2}}), Sw) + ideal(det mA - det mB);
    I = saturate(I, ideal(det mA));
    if dim I != 1 or degree I != 1 then return ("solution set: dimension " | toString dim I | ", degree " | toString degree I | " (a single line expected)");
    pt := gens ker transpose lift(last coefficients(super basis(1, I), Monomials => vars Sw), kk);
    if numColumns pt != 1 then return "the linear part of the ideal does not cut a line";
    ev := map(kk, Sw, flatten entries transpose pt);
    (MA * sub(ev mA, Rh), MB * sub(ev mB, Rh), ev mA, ev mB) );
