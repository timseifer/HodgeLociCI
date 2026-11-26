-- fano.m2 : helper functions (load after common.m2)
-- points are 1x9 matrices over kk (row vectors)
toRow = v -> matrix{v};
gradAt = pt -> transpose sub(gradF, pt);          -- 1x9 : gradient of F at pt
hessAt = pt -> sub(hessF, pt);                    -- 9x9
onY = pt -> (sub(F, pt) == 0);
-- is the row space of the matrix Pm (r x 9) contained in Y ?
RC = kk[cc_0..cc_8];
spanInY = Pm -> (
    r := numRows Pm;
    v := (matrix{toList(cc_0..cc_(r-1))}) * sub(Pm, RC);
    sub(F, v) == 0 );
-- rational points of A from a random codim-2 linear section
ratPointsA = () -> (
    L := ideal(random(1,R), random(1,R));
    comps := decompose(J + L);
    pts := {};
    for c in comps do if degree c == 1 and dim c == 1 then (
        -- solve linear system
        M := transpose gens kernel transpose (coefficients(gens c, Monomials => vars R))#1;
        pts = append(pts, sub(M, kk)));
    pts );
-- Fano scheme of 4-planes P with  rowspace(S) subset P subset {rows of Ucon vanish},  P in Y.
-- S : s x 9 matrix (independent rows, span must lie in Y and in the constraint space)
-- Ucon : c x 9 matrix of linear constraints (may be 0 x 9)
-- returns (I, W, RT): ideal I in RT=kk[t..], W = k x 9 matrix over RT whose rows together with S span P.
fanoIdeal = (S, Ucon) -> (
    s := numRows S; k := 5 - s;
    Ksp := if numRows Ucon == 0 then id_(kk^9) else transpose gens kernel Ucon;  -- rows span constraint space
    -- complement of S inside Ksp : pick random rows combos, m = dim Ksp - s
    m := numRows Ksp - s;
    Cb := random(kk^m, kk^(numRows Ksp)) * Ksp;       -- m random vectors of the constraint space
    if rank(S || Cb) != s + m then error "bad random complement";
    n := m - k;
    RT := kk[tt_(0,0)..tt_(k-1,n-1), ss_0..ss_4, MonomialOrder => GRevLex];
    T := matrix apply(k, i -> apply(n, j -> tt_(i,j)_RT));
    W := (id_(RT^k) | T) * sub(Cb, RT);                -- k x 9
    Pm := sub(S, RT) || W;                              -- 5 x 9
    v := (matrix{apply(5, i -> ss_i_RT)}) * Pm;       -- generic point
    Fv := sub(F, v);
    cf := (coefficients(Fv, Variables => apply(5, i -> ss_i_RT)))#1;
    RT2 := kk[tt_(0,0)..tt_(k-1,n-1)];
    I := ideal sub(cf, RT2);
    (I, sub(W, RT2), RT2) );
-- rational solutions of a zero-dimensional ideal I in ring RT2 : list of 1 x nvars matrices over kk
ratSolutions = I -> (
    RT2 := ring I;
    comps := decompose I;
    sols := {};
    for c in comps do if dim c == 0 and degree c == 1 then (
        sols = append(sols, matrix{apply(gens RT2, g -> (g % c))}));
    sols = apply(sols, m -> sub(m, kk));
    (sols, apply(comps, c -> (dim c, degree c))) );
