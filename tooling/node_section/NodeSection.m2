-- tooling/node_section/NodeSection.m2  --  nodes of a hypersurface (section) and the relations among them.
-- [TOOLING] AI-written (Claude Fable 5.2, 26 Nov 2026), not reviewed by a human.  Load with:  load "NodeSection.m2"
--
-- WHAT IT COMPUTES (a count, nothing more)
--   nodalDefect G            G a homogeneous form of degree d in n+1 variables, n EVEN (a hypersurface Y of odd
--                            dimension n-1 in P^n) over ZZ/p or QQ
--   nodalSectionReport(F, L) F a form in n+2 variables (a hypersurface X of even dimension n in P^(n+1)), L a linear
--                            form: the same for Y = X n {L = 0}
-- It returns a HashTable with STRING keys:
--   "singularLocusDim"        projective dimension of Sing(Y); -1 if Y is smooth
--   "singularPoints"          length of the Jacobian scheme of Y (if the singular locus is finite)
--   "allOrdinaryDoublePoints" true if the Jacobian scheme is reduced (then "singularPoints" is the number of nodes
--                             and every singular point is an ordinary double point); false if it is not;
--                             "undetermined" if the test could not separate the points
--   "formDegree"              e = n d / 2 - n - 1
--   "conditions"              the number of conditions the singular points impose on forms of degree e
--   "defect"                  singularPoints - conditions  (0 if e < 0 and there are no nodes)
--   "hilbertFunctionOfNodes"  Hilbert function of the (saturated) Jacobian scheme in degrees 0 .. e + 2
--   "label"                   "MOD p (p = ...), this instance"  or  "EXACT (over QQ)"
--   "note"                    what the count does and does not mean (read it)
--
-- WHAT THE COUNT MEANS, AND WHAT IT DOES NOT
--   LIT (not re-read by us in full): for a NODAL hypersurface Y of odd dimension n-1 and degree d in P^n the defect is
--   b_n(Y) - 1, the number of independent extra classes in the middle homology (Dimca, Duke Math. J. 60 (1990);
--   stated as Thm 2.5 in Kloosterman, arXiv:1612.06726).  That such a class gives a non-zero Hodge class on the
--   smooth X rests on an argument by an AI that no mathematician has read (leads/TENFOLD_COBLE_LEAD.md, 10.3).
--   So: the output is a computed count.  It is NOT a proved statement about Hodge classes, says nothing about
--   whether a class is algebraic, and nothing about the Hodge conjecture.  If "allOrdinaryDoublePoints" is not
--   true the formula does not apply and "defect" is only the number printed.
--
-- METHOD
--   Random linear change of coordinates; Groebner basis of the Jacobian ideal in grevlex (the F4 engine when the
--   characteristic is a prime below 32768, the default engine otherwise: over QQ this is slow beyond about 9
--   variables).  In generic coordinates and grevlex, in(J : x_n^infinity) = in(J) : x_n^infinity (Bayer-Stillman), so
--   the Hilbert function of the saturated ideal is read off a monomial ideal.  Reducedness: the multiplication
--   matrix of a random linear form on the affine coordinate ring of the scheme has a squarefree characteristic
--   polynomial.  MOD p results are for the reduction mod p of the given form; a count mod p is evidence about
--   characteristic 0, not a proof (the tool does no specialization argument).

nodalDefect = method(Options => {Strategy => null, Tries => 6, Verbose => false})
nodalDefect RingElement := opts -> G0 -> (
    R0 := ring G0; kk := coefficientRing R0; n := numgens R0 - 1; p := char kk;
    if not isHomogeneous G0 then error "nodalDefect: expected a homogeneous form";
    if n % 2 != 0 then error "nodalDefect: expected an even number n (a hypersurface of odd dimension n - 1 in P^n)";
    d := first degree G0; e := (n * d) // 2 - n - 1;
    label := if p > 0 then "MOD p (p = " | toString p | "), this instance" else "EXACT (over QQ)";
    note := "A computed count. By Dimca (1990; LIT, not re-read in full) the defect of a nodal hypersurface is b_n - 1. "
          | "That it gives Hodge classes on a smooth hypersurface containing it as a hyperplane section is an unreviewed AI argument. "
          | "Not a statement about algebraic cycles or about the Hodge conjecture.";
    useF4 := if opts.Strategy === null then (p > 0 and p < 32768) else (opts.Strategy === "F4");
    R := kk(monoid[Variables => n + 1, MonomialOrder => GRevLex]);        -- fresh ring, variables x_0..x_n anonymous
    result := null; tries := 0;
    while result === null and tries < opts.Tries do (
        tries = tries + 1;
        A := if p > 0 then random(kk^(n+1), kk^(n+1)) else matrix table(n+1, n+1, (i,j) -> (random 7 - 3)_kk);
        if det A == 0 then continue;
        G := (map(R, R0, (vars R) * A)) G0;
        J := ideal(G) + ideal jacobian matrix{{G}};
        gbm := if useF4 then groebnerBasis(J, Strategy => "F4") else gens gb J;
        LT := ideal leadTerm gbm;
        ds := dim LT - 1;
        if ds == -1 then (
            result = new HashTable from {"singularLocusDim" => -1, "singularPoints" => 0, "allOrdinaryDoublePoints" => true,
                "formDegree" => e, "conditions" => 0, "defect" => 0, "hilbertFunctionOfNodes" => {}, "label" => label, "note" => note};
            break);
        if ds > 0 then (
            result = new HashTable from {"singularLocusDim" => ds, "singularPoints" => "not finite", "allOrdinaryDoublePoints" => false,
                "formDegree" => e, "conditions" => "not determined", "defect" => "not determined",
                "hilbertFunctionOfNodes" => {}, "label" => label, "note" => note};
            break);
        ell := degree LT;
        xn := R_n;
        LTs := saturate(LT, xn);                                         -- monomial ideal
        if degree LTs != ell then continue;                              -- a singular point on x_n = 0: change coordinates
        hZ := j -> if j < 0 then 0 else hilbertFunction(j, R/LTs);
        cond := if e < 0 then 0 else hZ e;
        -- reducedness on the affine chart x_n = 1
        Ra := kk(monoid[Variables => n, MonomialOrder => GRevLex]);
        deh := map(Ra, R, (vars Ra) | matrix{{1_Ra}});
        ga := deh gbm;                                                   -- a Groebner basis of the dehomogenised ideal
        Gb := forceGB ga;
        LTa := ideal leadTerm ga;
        B := lift(basis(Ra/LTa), Ra);                                    -- the standard monomials
        if numColumns B != ell then continue;
        reduced := "undetermined"; T := kk(monoid[Variables => 1]); tt := T_0;
        for s from 1 to 3 do (
            lf := (random(kk^1, kk^n) * transpose vars Ra)_(0,0);
            if p == 0 then lf = sum(n, i -> (random 19 - 9) * Ra_i);
            Mm := lift(last coefficients((lf * B) % Gb, Monomials => B), kk);
            cp := det(tt * id_(T^ell) - sub(Mm, T));
            if first degree gcd(cp, diff(tt, cp)) == 0 then (reduced = true; break);
            );
        if reduced === "undetermined" then (
            -- the scheme is non-reduced if its radical has smaller degree; decide with a direct computation when small
            if ell <= 200 then reduced = (degree radical ideal ga == ell););
        result = new HashTable from {"singularLocusDim" => 0, "singularPoints" => ell, "allOrdinaryDoublePoints" => reduced,
            "formDegree" => e, "conditions" => cond, "defect" => ell - cond,
            "hilbertFunctionOfNodes" => apply(toList(0 .. max(e, 0) + 2), hZ), "label" => label, "note" => note};
        );
    if result === null then error "nodalDefect: no admissible random coordinates found; raise Tries";
    if opts.Verbose then print result;
    result)

nodalSectionReport = method(Options => options nodalDefect)
nodalSectionReport(RingElement, RingElement) := opts -> (F, L) -> (
    S := ring F; kk := coefficientRing S; N := numgens S;
    if ring L =!= S or not isHomogeneous L or first degree L != 1 then error "nodalSectionReport: expected a linear form of the same ring";
    cs := apply(N, i -> lift(coefficient(S_i, L), kk));
    i0 := position(cs, c -> c != 0);
    R := kk(monoid[Variables => N - 1]);
    others := select(N, j -> j != i0);
    img := new MutableList from toList(N : 0_R);
    scan(#others, t -> img#(others#t) = R_t);
    img#i0 = -(1 / cs#i0) * sum(#others, t -> cs#(others#t) * R_t);
    nodalDefect((map(R, S, toList img)) F, opts))
