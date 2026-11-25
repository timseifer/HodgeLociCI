-- CS3-M1 AG-ideal analysis over k[t]/t^(N+1).  Expects S, kk, pr.
-- lams: list (over orders j = 0..N) of lists of values of lambda_j on the monomials of basis(sig, S) (in that order).
agIndex = sig -> (h := new MutableHashTable; ms := flatten entries basis(sig, S); scan(#ms, i -> h#(ms#i) = i); h);
-- C_j for degree k: rows basis(sig-k), cols basis(k)
agCat = (lam, k, sig, hx) -> (
    rk := flatten entries basis(k, S); ro := flatten entries basis(sig - k, S);
    pos := table(ro, rk, (a, b) -> hx#(a * b));
    matrix apply(pos, row -> apply(row, i -> lam#i)));
-- leading-term space L_N (columns, coordinates in basis(k)) from catalecticants Cs = {C_0..C_N}
agLead = (Cs, N) -> (
    nr := numRows Cs#0; nc := numColumns Cs#0;
    Z := map(kk^nr, kk^nc, 0);
    M := matrix table(N+1, N+1, (j, i) -> if i <= j then Cs#(j-i) else Z);
    K := matrix nullSpace mutableMatrix M;
    if numColumns K == 0 then return map(kk^nc, kk^0, 0);
    L := K^(toList(0..nc-1));
    if L == 0 then return map(kk^nc, kk^0, 0);
    mingens image L);
agPolys = (Lc, k) -> if numColumns Lc == 0 then {} else flatten entries (basis(k, S) * sub(Lc, S));
agCoef = (ps, k) -> if #ps == 0 then map(kk^(numColumns basis(k, S)), kk^0, 0) else lift(last coefficients(matrix{ps}, Monomials => basis(k, S)), kk);
rk = M -> if numColumns M == 0 then 0 else rank M;
-- report for one order: Ls#k = leading space in degree k (k = 1,2,3); Jk#k, IVJ#k coefficient matrices
agReport = (Ls, Jk, IVJ, tag) -> (
    out := {};
    for k from 1 to 3 do (
        L := Ls#k; dL := numColumns L;
        prev := if k == 1 then {} else flatten apply(agPolys(Ls#(k-1), k-1), u -> apply(numgens S, l -> S_l * u));
        low := agCoef(prev, k) | Jk#k;
        newg := rk(L | low) - rk low;
        capIV := dL + rk(IVJ#k) - rk(L | IVJ#k);
        capJ := dL + rk(Jk#k) - rk(L | Jk#k);
        out = append(out, (k, dL, newg, capJ, capIV, rk(IVJ#k)));
        pr(tag | " k=" | toString k | ": dim L " | toString dL | ", new gens " | toString newg | ", dim(L cap J) " | toString capJ | " (dim J_k " | toString rk(Jk#k) | "), dim(L cap (I_V+J)) " | toString capIV | " (dim (I_V+J)_k " | toString rk(IVJ#k) | ")"));
    out);
