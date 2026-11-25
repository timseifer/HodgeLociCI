-- SO-T6: psi(c m0) for the cubic generators c of I_V by linear algebra in degree 7 (the change-matrix GB ran out of memory).
-- c m1 = A + sum_i B_i dF_i (A in I^2, B_i in S_5), m0 = m1 m2  =>  psi(c m0) = pi(div(m2 B))/6.
-- Columns: m5 * dF_i for a random subset of (m5, i), reduced modulo gb(I^2); solve for c m1 in their span.
cubPsi = (F, I, piRow, m0, splitIndex, ncols) -> (
    N := numgens S;
    Jr := flatten entries jacobian matrix{{F}};
    g := flatten entries mingens I; cs := select(g, u -> first degree u == 3);
    G2 := gb ideal gens trim(I^2);
    sup := select(N, i -> degree(S_i, m0) > 0);
    m2 := if splitIndex == 0 then S_(first sup) * S_(last sup) else S_(sup#1) * S_(sup#(#sup - 2));
    if m0 % m2 != 0 then m2 = S_(first sup)^2;
    m1 := m0 // m2;
    A2 := S/(ideal gens trim(I^2)); std := lift(basis(7, A2), S); ns := numColumns std;
    m5 := flatten entries basis(5, S);
    pairs := take(random(flatten table(N, #m5, (i, a) -> (i, a))), ncols);
    colP := matrix{apply(pairs, ia -> m5#(ia#1) * Jr#(ia#0))};
    Cm := lift(last coefficients(colP % G2, Monomials => std), kk);
    rhs := lift(last coefficients(matrix{apply(cs, c -> c * m1)} % G2, Monomials => std), kk);
    rC := rank Cm;
    sol := solve(mutableMatrix Cm, mutableMatrix rhs);
    if sol === null then error "not in span: increase ncols";
    sol = matrix sol;
    if Cm * sol != rhs then error "solve failed";
    vals := apply(#cs, a -> (
        Bi := apply(N, i -> sum(#pairs, t -> if pairs#t#0 == i and sol_(t, a) != 0 then sol_(t, a) * m5#(pairs#t#1) else 0_S));
        (first piRow matrix{{sum(N, i -> diff(S_i, m2 * Bi#i))}}) / 6));
    (vals, ns, rC, m2));
