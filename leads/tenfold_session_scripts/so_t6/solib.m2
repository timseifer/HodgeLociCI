-- SO-T6 library: higher-pole-order period psi of a cycle V in a cubic X = V(F) of even dimension n = 2k.
-- pi(P) = int_V Res(P Omega/F^(k+1)), P in S_t, t = 3(k+1) - (n+2);  psi(P) = int_V Res(P Omega/F^(k+2)), P in S_(t+3).
-- Characterisation (ARG, see ledger [SO-T6] PRE): psi = 0 on I_3 * I_t (= (I^2)_(t+3) if I is generated in degree <= 3)
-- and psi(sum_i A_i dF/dx_i) = 1/(k+1) pi(sum_i dA_i/dx_i).  Implementation: lift P along gens(I^2) | J (M2 change-matrix
-- Groebner basis, cached on the matrix), take the J-part B, psi(P) = pi(div B)/(k+1).  Expects S, kk, pr.
soNF = (F, I) -> (
    -- pi as normal form functional (determined up to scale when (I+J)_t has codim 1)
    J := ideal jacobian matrix{{F}};
    IJ := ideal gens gb (I + J);
    t := 3 * ((numgens S - 2)//2 + 1) - numgens S;
    A := S/IJ; bt := lift(basis(t, A), S);
    if numColumns bt != 1 then error("(I+J)_t has codim " | toString numColumns bt);
    m0 := bt_(0,0);
    (Pm -> flatten entries lift(last coefficients(Pm % IJ, Monomials => matrix{{m0}}), kk), IJ, m0));
soPsi = (F, I, piRow, k, opts) -> (
    -- opts: "order" => "IJ" or "JI" (generator order for the lift; c4), "I2" => explicit generators of the vanishing ideal
    N := numgens S;
    Jr := jacobian matrix{{F}};                 -- N x 1
    I2 := if opts#?"I2" then opts#"I2" else gens trim(I^2);
    nI := numColumns I2;
    GI := if opts#"order" == "IJ" then matrix{flatten entries I2 | flatten entries Jr} else matrix{flatten entries Jr | flatten entries I2};
    off := if opts#"order" == "IJ" then nI else 0;
    psiRow := Pm -> (
        if numColumns Pm == 0 then return {};
        if Pm % GI != 0 then error "psi: P not in (I^2 + J)";
        cof := Pm // GI;
        dv := sum(N, i -> diff(S_i, cof^{off + i}));
        apply(piRow dv, a -> a / (k+1)));
    psiRow);
-- matrix of coefficient vectors (columns) -> row of polynomials in the basis Bd
soPolys = (Bd, Cm) -> Bd * sub(Cm, S);
soCoef = (Bd, Pm) -> lift(last coefficients(Pm, Monomials => Bd), kk);
-- first-order pairing matrix pi(Q G), rows Q in BQ, cols G in B3
soPairing = (piRow, BQ, B3) -> matrix apply(numColumns BQ, a -> piRow(BQ_{a} * B3));
-- Option B evaluator (tenfold; cheap Groebner basis of I + J only, plus a degree-7 lift along gens(I^2)|J for the
-- cubic generators).  P = sum_a g_a r_a + sum_i B_i dF_i  (lift along mingens I | J), r_a = sum_b g_b s_ab + sum_i C_ai dF_i
-- + c_a m0  =>  psi(P) = pi(div B)/6 + sum_a [ pi(sum_i C_ai d_i g_a)/6 + c_a psi(g_a m0) ]   (psi = 0 on I^2, pi = 0 on I).
-- psi(g_a m0): m0 = m1 m2 (deg m2 = 2), g_a m1 = A + sum B'_i dF_i (A in I^2, degree 7)  =>  psi(g_a m0) = pi(div(m2 B'))/6.
soPsiB = (F, I, piRow, IJ, m0, splitIndex) -> (
    N := numgens S;
    Jr := flatten entries jacobian matrix{{F}};
    g := flatten entries mingens I; r := #g; dg := apply(g, u -> first degree u);
    GIJ := matrix{g | Jr};
    I2 := gens trim(I^2); GI2 := matrix{flatten entries I2 | Jr}; n2 := numColumns I2;
    -- psi(g_a m0) for cubic generators
    sup := select(N, i -> degree(S_i, m0) > 0);
    m2 := (if splitIndex == 0 then S_(first sup) * S_(last sup) else S_(sup#1) * S_(sup#(#sup - 2)));
    if m0 % m2 != 0 then m2 = S_(first sup)^2;
    m1 := m0 // m2;
    psiCub := apply(r, a -> if dg#a != 3 then 0_kk else (
        w := matrix{{g#a * m1}}; if w % GI2 != 0 then error "degree 7 not in I^2 + J";
        cf := w // GI2; Bp := apply(N, i -> cf_(n2 + i, 0));
        (first piRow matrix{{sum(N, i -> diff(S_i, m2 * Bp#i))}}) / 6));
    dgj := apply(g, u -> jacobian matrix{{u}});   -- N x 1 each
    psiRow := Pm -> (
        n := numColumns Pm; if n == 0 then return {};
        if Pm % IJ != 0 then error "psiB: P not in I + J";
        cof := Pm // GIJ;
        vals := apply(piRow(sum(N, i -> diff(S_i, cof^{r + i}))), x -> x / 6);
        for a from 0 to r - 1 do (
            ra := matrix{flatten entries cof^{a}};
            if ra == 0 then continue;
            cof2 := ra // GIJ;
            cc := if dg#a == 3 then flatten entries lift(last coefficients(ra % IJ, Monomials => matrix{{m0}}), kk) else (
                if ra % IJ != 0 then error "unexpected remainder"; toList(n:0_kk));
            Cm := cof2^{r .. r + N - 1};                 -- N x n
            w := (transpose dgj#a) * Cm;                   -- 1 x n: sum_i C_ai d_i g_a
            v2 := piRow w;
            vals = apply(n, j -> vals#j + v2#j / 6 + cc#j * psiCub#a));
        vals);
    (psiRow, psiCub));
-- Option B with the values x_a = psi(g_a m0) (cubic generators) left symbolic: returns for each P the pair
-- (known part, coefficients of x_a).  Used (i) to determine x_a from P with independently known psi (P in J_9: pi(div)/6;
-- P in (I^2)_9: 0) and (ii) as the generic evaluator once x_a is known (soPsiBx).
soPsiBlin = (F, I, piRow, IJ, m0) -> (
    N := numgens S;
    Jr := flatten entries jacobian matrix{{F}};
    g := flatten entries mingens I; r := #g; dg := apply(g, u -> first degree u);
    GIJ := matrix{g | Jr};
    cub := select(r, a -> dg#a == 3);
    dgj := apply(g, u -> jacobian matrix{{u}});
    Pm -> (
        n := numColumns Pm;
        if Pm % IJ != 0 then error "psiBlin: P not in I + J";
        cof := Pm // GIJ;
        vals := apply(piRow(sum(N, i -> diff(S_i, cof^{r + i}))), x -> x / 6);
        coefs := apply(n, j -> apply(cub, a -> 0_kk));
        for a from 0 to r - 1 do (
            ra := matrix{flatten entries cof^{a}};
            if ra == 0 then continue;
            cof2 := ra // GIJ;
            cc := if dg#a == 3 then flatten entries lift(last coefficients(ra % IJ, Monomials => matrix{{m0}}), kk) else (
                if ra % IJ != 0 then error "unexpected remainder"; toList(n:0_kk));
            Cm := matrix apply(N, i -> flatten entries cof2^{r + i});
            w := (transpose dgj#a) * Cm;
            v2 := piRow w;
            vals = apply(n, j -> vals#j + v2#j / 6);
            if dg#a == 3 then (pos := position(cub, b -> b == a); coefs = apply(n, j -> apply(#cub, t -> coefs#j#t + (if t == pos then cc#j else 0_kk)))));
        apply(n, j -> (vals#j, coefs#j))));
soPsiBx = (lin, xs) -> (Pm -> apply(lin Pm, vc -> vc#0 + sum(#xs, t -> vc#1#t * xs#t)));
