-- HodgeLociCI/Excess.m2  (owner: agent PA)
-- Item 1: the excess calculator (paper 3, Theorem 2, Corollary 4, Theorem 9.7), first-order tools,
-- Grothendieck residues.  "Paper 3" is night/paper3/paper3.tex of the research session: an AI-written
-- manuscript that no human has refereed.  Private helpers of this file are prefixed with `hl`.

export {
    "hodgeLevel", "primitiveHodgeNumbers", "ciHilbertFunction",
    "excessFromDegrees", "linearSubspaceCase",
    "CyclePair", "cyclePair", "randomCyclePair",
    "excessFromData", "tangentExcess", "verifyExcess",
    "periodPolynomial", "hodgeLocusTangentCodim",
    "grothendieckResidue", "residueFunctional", "isSmoothHypersurface",
    "reduceModPrime",
    "NotDetermined", "Seed", "CheckSmooth"
    }

------------------------------------------------------------------------------------------------------
-- small private helpers
------------------------------------------------------------------------------------------------------

hlProved = "PROVED in paper 3 (AI-written, unreviewed)";

hlIsPrimeField = kk -> kk === QQ or (instance(kk, QuotientRing) and ambient kk === ZZ and isPrime char kk);

hlLabel = kk -> (
    if kk === QQ then "EXACT (computed over QQ)"
    else if char kk == 0 then "EXACT (computed over the field " | toString describe kk | " of characteristic 0)"
    else "MOD p (computed over " | (if hlIsPrimeField kk then "ZZ/" | toString char kk else "a field of characteristic " | toString char kk)
        | " at one instance: evidence, not a proof)"
    );

hlDeg = u -> (
    if u == 0 then error "the zero polynomial has no degree";
    first degree u
    );

-- an integer, a rational number or a field element, as an element of the field kk
hlToField = (lam, kk) -> (
    if instance(lam, ZZ) then return lam_kk;
    if instance(lam, QQ) then (
        if kk === QQ then return lam;
        if char kk == 0 then return promote(lam, kk);
        if (denominator lam) % (char kk) == 0 then
            error("the denominator of " | toString lam | " is zero in the coefficient field");
        return (numerator lam)_kk / (denominator lam)_kk;
        );
    if instance(lam, RingElement) and ring lam === kk then return lam;
    error "expected an integer, a rational number or an element of the coefficient field"
    );

hlCheckRing = S -> (
    if not instance(S, PolynomialRing) then error "expected forms in a polynomial ring";
    if not isField coefficientRing S then error "expected a polynomial ring over a field (QQ or ZZ/p; other fields are accepted but untested)";
    if not all(degrees S, e -> e === {1}) then error "expected a standard graded polynomial ring";
    );

-- the ideal I with a Groebner basis attached; over ZZ/p the F4 engine is used (much faster on Jacobian ideals)
hlGBIdeal = I -> (
    if I.cache#?"hlGB" then return I.cache#"hlGB";
    S := ring I;
    kk := coefficientRing S;
    I2 := I;
    if hlIsPrimeField kk and char kk > 0 and char kk < 32768 and I != 0 and isHomogeneous I then (
        G := try groebnerBasis(I, Strategy => "F4") else null;
        if G =!= null then (
            I2 = ideal G;
            forceGB gens I2;
            );
        );
    I.cache#"hlGB" = I2;
    I2.cache#"hlGB" = I2;
    I2
    );

hlHF = (m, I) -> if m < 0 then 0 else hilbertFunction(m, (ring I)/(hlGBIdeal I));

hlPermSign = L -> (
    s := 1;
    for a from 0 to #L-1 do for b from a+1 to #L-1 do if L#a > L#b then s = -s;
    s
    );

-- determinant of the square matrix A over S modulo the ideal I (normal form in S).
-- Laplace expansion along columns with memoised minors, in S/I; constant columns are treated first.
hlDetMod = (A, I) -> (
    n := numRows A;
    if numColumns A != n then error "expected a square matrix";
    S := ring I;
    B := S/(hlGBIdeal I);
    AB := sub(A, B);
    isConst := j -> all(n, i -> (e := A_(i,j); e == 0 or first degree e == 0));
    cc := select(n, isConst);
    perm := cc | select(n, j -> not isConst j);
    sgn := hlPermSign perm;
    D := new MutableHashTable;
    D#{} = 1_B;
    for jj from 0 to n-1 do (
        j := perm#jj;
        col := apply(n, i -> AB_(i,j));
        Dn := new MutableHashTable;
        for T in subsets(n, jj+1) do (
            v := 0_B;
            for a from 0 to jj do (
                e := col#(T#a);
                if e != 0 then (
                    key := drop(T, {a,a});
                    if D#?key then v = v + (-1)^(a+jj) * e * D#key;
                    );
                );
            if v != 0 then Dn#T = v;
            );
        D = Dn;
        );
    full := toList(0..n-1);
    if D#?full then sgn * lift(D#full, S) else 0_S
    );

------------------------------------------------------------------------------------------------------
-- Hodge numbers and Hodge level of a hypersurface
------------------------------------------------------------------------------------------------------

ciHilbertFunction = method()
ciHilbertFunction(List, ZZ, ZZ) := (degs, nv, m) -> (
    if nv < 0 then error "ciHilbertFunction: the number of variables must be nonnegative";
    if not all(degs, a -> instance(a, ZZ) and a >= 1) then error "ciHilbertFunction: the degrees must be positive integers";
    if #degs > nv then error "ciHilbertFunction: more equations than variables (not a complete intersection)";
    if m < 0 then return 0;
    -- coefficients of (1-T)^(-nv) up to degree m, then multiply by the factors (1 - T^a)
    cf := new MutableList from apply(m+1, j -> if nv == 0 then (if j == 0 then 1 else 0) else binomial(nv-1+j, j));
    for a in degs do for j from 0 to m do (
        i := m - j;                         -- descending, so that cf#(i-a) is still the old value
        if i - a >= 0 then cf#i = cf#i - cf#(i-a);
        );
    cf#m
    );

primitiveHodgeNumbers = method()
primitiveHodgeNumbers(ZZ, ZZ) := (n, d) -> (
    if n < 0 then error "primitiveHodgeNumbers: the dimension must be nonnegative";
    if d < 1 then error "primitiveHodgeNumbers: the degree must be positive";
    -- h^(n-q,q)_prim = dim of the Jacobian ring in degree (q+1)d-n-2 (Griffiths); the Jacobian ring of a smooth
    -- hypersurface is a complete intersection of n+2 forms of degree d-1 (for d = 1 it is zero)
    if d == 1 then return toList(n+1 : 0);
    apply(n+1, q -> ciHilbertFunction(toList(n+2 : d-1), n+2, (q+1)*d - n - 2))
    );

hodgeLevel = method()
hodgeLevel(ZZ, ZZ) := (n, d) -> (
    h := primitiveHodgeNumbers(n, d);
    qs := select(n+1, q -> h#q != 0);
    if #qs == 0 then return (if n % 2 == 0 then 0 else -infinity);   -- only the class of a linear section, or nothing
    n - 2 * (min qs)
    );

------------------------------------------------------------------------------------------------------
-- the excess calculator by degrees (paper 3, Theorem 2)
------------------------------------------------------------------------------------------------------

-- validation of a degree type; returns (c, k)
hlValidateType = (d, df, dh, dp) -> (
    if not instance(d, ZZ) or d < 2 then error "expected the degree d of the hypersurface to be an integer >= 2";
    if #df == 0 then error "expected at least one own equation for each cycle (c >= 1)";
    if #df != #dh then error("the two cycles must have the same number c of own equations; got " | toString(#df) | " and " | toString(#dh));
    if not all(df | dh | dp, a -> instance(a, ZZ) and a >= 1 and a < d) then
        error("all degrees of f, h and p must be integers >= 1 and < d = " | toString d | " (setting of paper 3)");
    -- det M must not vanish for degree reasons: a permutation pi with deg f_i + deg h_pi(i) <= d for all i
    a := sort df; b := rsort dh;
    if not all(#a, i -> a#i + b#i <= d) then
        error "no smooth hypersurface of this degree type exists: det M vanishes identically (paper 3, section 10, check (v))";
    (#df, #df + #dp - 1)
    );

excessFromDegrees = method()
excessFromDegrees(ZZ, List, List, List) := (d, df, dh, dp) -> (
    (c, k) := hlValidateType(d, df, dh, dp);
    nv := 2*k + 2;
    tau := sum df + sum dh - (c-1)*d;
    lam0 := (-1)^(c-1);
    degA := df | dh | dp | apply(dp, a -> d - a);
    sigma := sum degA - nv;
    sigmaP := k*d - 2*k - 2;
    inRange := (k-1)*d + tau < 2*k + 2;
    eTau := ciHilbertFunction(degA, nv, tau);
    dimAd := ciHilbertFunction(degA, nv, d);
    cV1 := ciHilbertFunction(df | dp | apply(df, a -> d - a) | apply(dp, a -> d - a), nv, d);
    cV2 := ciHilbertFunction(dh | dp | apply(dh, a -> d - a) | apply(dp, a -> d - a), nv, d);
    cVZ := cV1 + cV2 - dimAd;
    ex0 := if tau >= 0 then eTau else 0;
    exE := if tau < 0 then 0 else if inRange then eTau else NotDetermined;
    bnd := if tau < 0 then (0, 0) else if inRange then (eTau, eTau) else (max(0, eTau - dimAd), eTau);
    dich := if tau < 0 then "tau < 0: no excess; NL(delta_lambda) = V_Z for every lambda != 0 (Theorem 2(3))"
        else "tau >= 0: NL(delta_lambda0) is smooth of codimension codim V_Z - e_tau, with e_tau excess tangent directions (Theorem 2(4))";
    notes := {
        "setting: smooth X of degree d in P^(2k+1); Y_1 = V(f,p), Y_2 = V(h,p) of dimension k in X; V(f,h,p) of dimension k-c; all degrees >= 1 and < d",
        "tau, lambda0, range, e_tau, codimensions of V_1, V_2, V_Z: " | hlProved | ", Theorem 2(1) and Lemmas 3.2, 3.3",
        "excess at lambda0: " | hlProved | ", Theorem 2(3), (4)",
        if tau < 0 then "excess at every lambda != 0 is 0: " | hlProved | ", Theorem 2(3)"
        else if inRange then "in the range the excess is e_tau for every lambda != 0: " | hlProved | ", Theorem 2(2)"
        else "outside the range the excess at lambda not in {0, lambda0} is dim (0 :_A det M)_tau = e_tau - rank(.det M : A_tau -> A_d) ("
            | hlProved | ", Theorem 2(5)); this is NOT determined by the degrees: use excessFromData"
            | (if tau == 0 then "; for tau = 0 it is 1 if det M lies in (f,h,p,s) and 0 otherwise" else "")
        };
    new HashTable from {
        "degree" => d, "k" => k, "c" => c,
        "degreesF" => df, "degreesH" => dh, "degreesP" => dp,
        "tau" => tau,
        "levelDichotomy" => dich,
        "lambda0" => lam0,
        "inRange" => inRange,
        "sigma" => sigma, "sigmaPrime" => sigmaP, "r" => d - sigmaP,
        "eTau" => eTau,
        "dimAd" => dimAd,
        "codimV1" => cV1, "codimV2" => cV2, "codimVZ" => cVZ,
        "transversal" => inRange,
        "excessAtLambda0" => ex0,
        "codimNLAtLambda0" => cVZ - ex0,
        "excessElsewhere" => exE,
        "excessElsewhereBounds" => bnd,
        "notes" => notes,
        "label" => hlProved | ", Theorem 2; integer arithmetic on the degrees only"
        }
    );

-- paper 3, Theorem 9.7 and Table 1
hlLinTable = new HashTable from {
    (3,3,1) => (2, "Corollary 9.5(2)"), (3,3,2) => (2, "Corollary 9.3"), (3,3,3) => (1, "Corollary 8.2"),
    (3,4,1) => (2, "Corollary 9.5(3)"), (3,4,2) => (2, "Corollary 9.5(1)"), (3,4,3) => (1, "Corollary 8.2"),
    (4,2,1) => (2, "Remark (vii) of section 9.1"), (4,2,2) => (1, "Corollary 8.2"), (5,2,1) => (1, "Remark (vii) of section 9.1")
    };

linearSubspaceCase = method()
linearSubspaceCase(ZZ, ZZ, ZZ) := (d, k, c) -> (
    if d < 3 then error "linearSubspaceCase: Theorem 9.7 of paper 3 assumes d >= 3";
    if k < 1 then error "linearSubspaceCase: expected k >= 1";
    if c < 1 or c > k+1 then error "linearSubspaceCase: expected 1 <= c <= k+1 (two k-planes meeting in dimension k-c)";
    tau := 2*c - (c-1)*d;
    lam0 := (-1)^(c-1);
    sigmaP := k*d - 2*k - 2;
    src := hlProved | ", Theorem 9.7";
    base := {"degree" => d, "k" => k, "c" => c, "tau" => tau, "lambda0" => lam0, "sigmaPrime" => sigmaP};
    if sigmaP < 1 then return new HashTable from (base | {
        "hypothesis" => false,
        "case" => "excluded",
        "genericExcessElsewhere" => NotDetermined,
        "atLambda0" => NotDetermined,
        "elsewhere" => NotDetermined,
        "statement" => (if sigmaP < 0
            then "cubic surface (kd-2k-2 < 0): there are no period conditions, every NL(delta) is the whole space"
            else "cubic fourfold or quartic surface (kd-2k-2 = 0): V_1, V_2 are transversal smooth divisors, K = 0, and NL(delta_lambda) is a smooth divisor strictly containing V_Z for every lambda != 0")
            | " (text before Theorem 9.7; the theorem itself assumes kd-2k-2 >= 1)",
        "label" => hlProved | ", section 9.2 (text before Theorem 9.7)"
        });
    if tau < 0 then return new HashTable from (base | {
        "hypothesis" => true,
        "case" => "tau < 0",
        "genericExcessElsewhere" => 0,
        "atLambda0" => "NL = V_Z",
        "elsewhere" => "NL = V_Z",
        "statement" => "NL([Pi_1] + lambda [Pi_2]) = V_Z for every lambda != 0, at every smooth X (Theorem 9.7(1))",
        "label" => src | "(1)"
        });
    at0 := "NL([Pi_1] + lambda0 [Pi_2]) is smooth and strictly larger than V_Z, at every smooth X (Theorem 9.7(2))";
    key := (d,k,c);
    inList := hlLinTable#?key or (k == 1 and c == 1 and d >= 5);
    if inList then (
        (e, where) := if hlLinTable#?key then hlLinTable#key else (1, "Corollary 9.2");
        return new HashTable from (base | {
            "hypothesis" => true,
            "case" => "sporadic",
            "genericExcessElsewhere" => e,
            "atLambda0" => at0,
            "elsewhere" => "V_Z with a non-reduced structure",
            "statement" => "for lambda not in {0, lambda0}: at a general X the locus is V_Z with a non-reduced structure and " | toString e
                | " excess tangent direction(s); it is non-reduced at every smooth X (Theorem 9.7(3), Table 1; second-order statement: " | where | ")",
            "label" => src | "(2), (3)"
            });
        );
    new HashTable from (base | {
        "hypothesis" => true,
        "case" => "generic",
        "genericExcessElsewhere" => 0,
        "atLambda0" => at0,
        "elsewhere" => "NL = V_Z as schemes at a general X",
        "statement" => "for lambda not in {0, lambda0} and X general among the smooth hypersurfaces containing two such planes: NL([Pi_1] + lambda [Pi_2]) = V_Z as schemes (Theorem 9.7(3)); at special X the excess can be larger",
        "label" => src | "(2), (3)"
        })
    );

------------------------------------------------------------------------------------------------------
-- smoothness
------------------------------------------------------------------------------------------------------

hlSingDim0 = F -> (
    -- true iff the singular locus of {F = 0} is empty
    S := ring F;
    J := ideal jacobian matrix{{F}} + ideal F;
    dim hlGBIdeal J == 0
    );

isSmoothHypersurface = method()
isSmoothHypersurface RingElement := F -> (
    S := ring F;
    hlCheckRing S;
    if F == 0 or not isHomogeneous F then error "isSmoothHypersurface: expected a nonzero homogeneous polynomial";
    kk := coefficientRing S;
    if kk =!= QQ then return hlSingDim0 F;
    -- over QQ: a smooth reduction modulo a prime certifies smoothness over QQ (the discriminant is nonzero)
    cfs := apply(flatten entries (coefficients F)#1, a -> lift(a, QQ));
    den := lcm apply(cfs, denominator);
    Fz := den * F;
    for pr in {32003, 30011, 10007} do (
        Sp := (ZZ/pr)(monoid S);
        Fp := (map(Sp, S, gens Sp)) Fz;
        if Fp != 0 and hlSingDim0 Fp then return true;
        );
    hlSingDim0 F
    );

------------------------------------------------------------------------------------------------------
-- Grothendieck residues
------------------------------------------------------------------------------------------------------

-- data of the symbol Res[ . /G]: Groebner basis, socle degree, socle monomial and normalising scalar
hlResidueData = G -> (
    if not instance(G, List) or #G == 0 then error "residue: expected a nonempty list of forms";
    if not all(G, u -> instance(u, RingElement)) then error "residue: expected a list of polynomials";
    S := ring first G;
    hlCheckRing S;
    if not all(G, u -> ring u === S) then error "residue: the forms must lie in one ring";
    n := numgens S;
    if #G != n then error("residue: expected as many forms as variables (" | toString n | "), got " | toString(#G));
    if not all(G, u -> u != 0 and isHomogeneous u and hlDeg u >= 1) then error "residue: expected nonzero homogeneous forms of positive degree";
    kk := coefficientRing S;
    I := hlGBIdeal ideal G;
    if dim I != 0 then error "residue: the forms do not form a regular sequence (they have a common zero)";
    sigma := sum(G, hlDeg) - n;
    pd := product(G, hlDeg);
    nj := hlDetMod(jacobian matrix{G}, I);      -- det Jac modulo (G); transposing does not change it
    if nj == 0 then error "residue: det Jac lies in the ideal, so the symbol cannot be normalised (does the characteristic divide the multiplicity?)";
    m0 := leadMonomial nj;
    cj := leadCoefficient nj;
    if nj != cj * m0 then error "residue: internal error (the socle is not spanned by one monomial)";
    new HashTable from {"ring" => S, "field" => kk, "ideal" => I, "sigma" => sigma, "m0" => m0, "scale" => pd_kk / cj}
    );

-- residues of the entries of a one-row matrix W (each entry zero or homogeneous of the socle degree)
hlResRow = (rd, W) -> (
    if numColumns W == 0 then return {};
    NF := W % rd#"ideal";
    v := lift(contract(matrix{{rd#"m0"}}, NF), rd#"field");
    apply(flatten entries v, a -> a * rd#"scale")
    );

residueFunctional = method()
residueFunctional List := G -> (
    rd := hlResidueData G;
    S := rd#"ring"; kk := rd#"field"; sigma := rd#"sigma"; m0 := rd#"m0"; I := rd#"ideal"; sc := rd#"scale";
    P -> (
        if instance(P, ZZ) or instance(P, QQ) then P = P_S;
        if not instance(P, RingElement) or ring P =!= S then error "residue: the numerator must lie in the ring of the sequence";
        Ps := part(sigma, P);
        if Ps == 0 then return 0_kk;
        nf := Ps % I;
        if nf == 0 then return 0_kk;
        if nf != (leadCoefficient nf) * m0 then error "residue: internal error (normal form is not a multiple of the socle monomial)";
        (leadCoefficient nf) * sc
        )
    );
residueFunctional Matrix := G -> residueFunctional flatten entries G

grothendieckResidue = method()
grothendieckResidue(RingElement, List) := (P, G) -> (residueFunctional G) P
grothendieckResidue(RingElement, Matrix) := (P, G) -> (residueFunctional G) P
grothendieckResidue(ZZ, List) := (P, G) -> (residueFunctional G) P
grothendieckResidue(QQ, List) := (P, G) -> (residueFunctional G) P

------------------------------------------------------------------------------------------------------
-- data: two complete-intersection cycles on a hypersurface
------------------------------------------------------------------------------------------------------

CyclePair = new Type of HashTable

net CyclePair := D -> (
    "CyclePair{d = " | toString D#"degree" | ", k = " | toString D#"k" | ", c = " | toString D#"c"
    | ", deg f = " | toString D#"degreesF" | ", deg h = " | toString D#"degreesH" | ", deg p = " | toString D#"degreesP"
    | ", tau = " | toString D#"tau" | ", lambda0 = " | toString D#"lambda0"
    | ", field = " | toString D#"field" | ", smooth = " | toString D#"smooth" | "}"
    );

-- returns a CyclePair, or a String explaining why the data are not in the setting of paper 3
hlMakePair = (f, h, p, M, s, checkSmooth) -> (
    if not (instance(f, List) and instance(h, List) and instance(p, List) and instance(s, List)) then
        error "cyclePair: expected f, h, p, s to be lists of forms";
    if not instance(M, Matrix) then error "cyclePair: expected M to be a matrix of forms";
    c := #f;
    if c == 0 then error "cyclePair: expected at least one own equation f_i (c >= 1)";
    if #h != c then error("cyclePair: f and h must have the same length c; got " | toString c | " and " | toString(#h));
    if #s != #p then error("cyclePair: p and s must have the same length; got " | toString(#p) | " and " | toString(#s));
    if numRows M != c or numColumns M != c then error("cyclePair: M must be a " | toString c | " x " | toString c | " matrix");
    S := ring M;
    hlCheckRing S;
    if not all(f | h | p | s, u -> instance(u, RingElement) and ring u === S) then
        error "cyclePair: all forms must lie in the ring of the matrix M";
    k := c + #p - 1;
    nv := numgens S;
    if nv != 2*k + 2 then error("cyclePair: the ring must have 2k+2 = " | toString(2*k+2) | " variables, where k+1 = #f + #p = "
        | toString(k+1) | "; it has " | toString nv);
    if not all(f | h | p | s, u -> u != 0 and isHomogeneous u and hlDeg u >= 1) then
        error "cyclePair: f, h, p, s must be nonzero homogeneous forms of positive degree";
    if not all(flatten entries M, isHomogeneous) then error "cyclePair: the entries of M must be homogeneous";
    df := apply(f, hlDeg); dh := apply(h, hlDeg); dp := apply(p, hlDeg); ds := apply(s, hlDeg);
    cand := unique (apply(#p, l -> dp#l + ds#l)
        | flatten apply(c, i -> apply(select(c, j -> M_(i,j) != 0), j -> (
            if not isHomogeneous M_(i,j) then error "cyclePair: the entries of M must be homogeneous";
            df#i + dh#j + hlDeg M_(i,j)))));
    if #cand == 0 then error "cyclePair: M is zero and there is no shared equation, so F = 0";
    if #cand > 1 then error("cyclePair: F = f^T M h + sum p_l s_l is not homogeneous: the products have degrees " | toString sort cand);
    d := first cand;
    if not all(df | dh | dp, a -> a < d) then error("cyclePair: the degrees of f, h, p must be < d = " | toString d);
    hv := transpose matrix{h}; fv := transpose matrix{f};
    g := flatten entries (M * hv);
    q := flatten entries (transpose M * fv);
    F := sum(c, i -> f#i * g#i) + sum(#p, l -> p#l * s#l);
    if F == 0 then error "cyclePair: F = f^T M h + sum p_l s_l is zero";
    IA := hlGBIdeal ideal(f | h | p | s);
    if dim IA != 0 then return "(f, h, p, s) is not a regular sequence, so X is singular or V(f,h,p) has the wrong dimension (paper 3, Lemma 3.1)";
    sm := "not checked";
    if checkSmooth then (
        if not isSmoothHypersurface F then return "the hypersurface X = {F = 0} is singular";
        sm = true;
        );
    kk := coefficientRing S;
    new CyclePair from {
        "ring" => S, "field" => kk,
        "degree" => d, "k" => k, "c" => c,
        "f" => f, "h" => h, "p" => p, "s" => s, "M" => M,
        "g" => g, "q" => q, "F" => F, "detM" => det(M, Strategy => Cofactor),
        "degreesF" => df, "degreesH" => dh, "degreesP" => dp,
        "tau" => sum df + sum dh - (c-1)*d,
        "lambda0" => (-1)^(c-1),
        "Phi1" => f | p | g | s,
        "Phi2" => h | p | q | s,
        "Phi0" => f | p | h | s,
        "smooth" => sm,
        "label" => hlLabel kk,
        symbol cache => new CacheTable from {"IA" => IA}
        }
    );

cyclePair = method(Options => {CheckSmooth => true}, Dispatch => Thing)
cyclePair Sequence := opts -> args -> (
    if #args != 5 then error "cyclePair: expected five arguments (f, h, p, M, s)";
    (f, h, p, M, s) := args;
    D := hlMakePair(f, h, p, M, s, opts.CheckSmooth);
    if instance(D, String) then error("cyclePair: " | D);
    D
    );

hlRandomForm = (S, dg, H) -> (
    if dg < 0 then return 0_S;
    kk := coefficientRing S;
    if char kk > 0 then return random(dg, S);
    B := flatten entries basis(dg, S);
    sum(B, m -> random(-H, H) * m)
    );

randomCyclePair = method(Options => {CoefficientRing => ZZ/32003, Seed => null, Height => 3, CheckSmooth => true})
randomCyclePair(ZZ, List, List, List) := opts -> (d, df, dh, dp) -> (
    (c, k) := hlValidateType(d, df, dh, dp);
    kk := opts.CoefficientRing;
    if not hlIsPrimeField kk then error "randomCyclePair: CoefficientRing must be QQ or a prime field ZZ/p";
    if opts.Seed =!= null then (
        if not instance(opts.Seed, ZZ) then error "randomCyclePair: Seed must be an integer or null";
        setRandomSeed opts.Seed;
        );
    H := opts.Height;
    if not instance(H, ZZ) or H < 1 then error "randomCyclePair: Height must be a positive integer";
    x := getSymbol "x";
    S := kk(monoid[x_0..x_(2*k+1)]);
    rf := dg -> hlRandomForm(S, dg, H);
    nz := dg -> (u := rf dg; while u == 0 do u = rf dg; u);
    D := null;
    for attempt from 1 to 25 do (
        f := apply(df, nz); h := apply(dh, nz); p := apply(dp, nz);
        s := apply(dp, a -> nz(d - a));
        M := matrix(S, table(c, c, (i,j) -> rf(d - df#i - dh#j)));
        D = hlMakePair(f, h, p, M, s, opts.CheckSmooth);
        if instance(D, CyclePair) then return D;
        );
    error("randomCyclePair: no admissible instance found in 25 attempts; last reason: " | D)
    );

-- reduction modulo a prime of data over QQ: the explicit way from EXACT to MOD p
reduceModPrime = method(Options => {CheckSmooth => true})
reduceModPrime(CyclePair, ZZ) := opts -> (D, pr) -> (
    if D#"field" =!= QQ then error "reduceModPrime: expected data over QQ";
    if pr < 2 or not isPrime pr then error "reduceModPrime: expected a prime number";
    S := D#"ring";
    Sp := (ZZ/pr)(monoid S);
    phi := map(Sp, S, gens Sp);
    red := u -> (
        if u == 0 then return 0_Sp;
        cfs := apply(flatten entries (coefficients u)#1, a -> lift(a, QQ));
        if any(cfs, a -> (denominator a) % pr == 0) then
            error("reduceModPrime: a coefficient has a denominator divisible by " | toString pr);
        v := phi u;
        if v == 0 or hlDeg v != hlDeg u then error("reduceModPrime: bad reduction modulo " | toString pr | " (a form vanishes)");
        v
        );
    M2 := matrix(Sp, applyTable(entries D#"M", red));
    D2 := hlMakePair(apply(D#"f", red), apply(D#"h", red), apply(D#"p", red), M2, apply(D#"s", red), opts.CheckSmooth);
    if instance(D2, String) then error("reduceModPrime: the reduction modulo " | toString pr | " is not in the setting: " | D2);
    D2
    );

------------------------------------------------------------------------------------------------------
-- the excess calculator by data
------------------------------------------------------------------------------------------------------

-- multiplication by the form w : (S/I)_a -> (S/I)_(a + deg w); returns (dim source, dim target, rank, kernel basis in S)
hlMultRank = (I, w, a) -> (
    S := ring I;
    kk := coefficientRing S;
    I2 := hlGBIdeal I;
    A := S/I2;
    if a < 0 then return (0, 0, 0, {});
    ba := lift(basis(a, A), S);
    if w == 0 then return (numColumns ba, 0, 0, flatten entries ba);
    bb := lift(basis(a + hlDeg w, A), S);
    if numColumns ba == 0 then return (0, numColumns bb, 0, {});
    if numColumns bb == 0 then return (numColumns ba, 0, 0, flatten entries ba);
    pr := (w * ba) % I2;
    cf := lift((coefficients(pr, Monomials => bb))#1, kk);
    kr := gens ker cf;
    (numColumns ba, numColumns bb, rank cf, flatten entries (ba * sub(kr, S)))
    );

hlExcessData = D -> (
    if D.cache#?"excessData" then return D.cache#"excessData";
    S := D#"ring"; d := D#"degree"; k := D#"k"; c := D#"c"; tau := D#"tau";
    IA := D.cache#"IA";
    (na, nb, rk, kr) := hlMultRank(IA, D#"detM", tau);
    dimAd := hlHF(d, IA);
    cV1 := hlHF(d, ideal D#"Phi1");
    cV2 := hlHF(d, ideal D#"Phi2");
    IZ := ideal(D#"p" | D#"s" | D#"g" | D#"q") + (ideal D#"f") * (ideal D#"h");
    cVZ := hlHF(d, IZ);
    r := new HashTable from {"eTau" => na, "dimAd" => dimAd, "rank" => (if tau < 0 then 0 else rk), "Eprime" => kr,
        "codimV1" => cV1, "codimV2" => cV2, "codimVZ" => cVZ, "IZ" => IZ};
    D.cache#"excessData" = r;
    r
    );

excessFromData = method()
excessFromData CyclePair := D -> (
    d := D#"degree"; k := D#"k"; c := D#"c"; tau := D#"tau";
    r := hlExcessData D;
    eTau := r#"eTau";
    inRange := (k-1)*d + tau < 2*k + 2;
    ann := if tau < 0 then 0 else eTau - r#"rank";
    new HashTable from {
        "degree" => d, "k" => k, "c" => c,
        "degreesF" => D#"degreesF", "degreesH" => D#"degreesH", "degreesP" => D#"degreesP",
        "tau" => tau,
        "lambda0" => D#"lambda0",
        "inRange" => inRange,
        "sigmaPrime" => k*d - 2*k - 2, "r" => d - (k*d - 2*k - 2),
        "eTau" => eTau,
        "dimAd" => r#"dimAd",
        "rankDetM" => r#"rank",
        "dimAnnDetM" => ann,
        "conditionS" => (if tau < 0 then NotDetermined else r#"rank" == r#"dimAd"),
        "codimV1" => r#"codimV1", "codimV2" => r#"codimV2", "codimVZ" => r#"codimVZ",
        "excessAtLambda0" => (if tau >= 0 then eTau else 0),
        "codimNLAtLambda0" => r#"codimVZ" - (if tau >= 0 then eTau else 0),
        "excessElsewhere" => ann,
        "excessDirections" => r#"Eprime",
        "smooth" => D#"smooth",
        "label" => "Hilbert functions and the rank of .det M: " | D#"label" | "; their identification with the excess: "
            | hlProved | ", Theorem 2 (needs X smooth)"
        }
    );

------------------------------------------------------------------------------------------------------
-- direct first-order computation
------------------------------------------------------------------------------------------------------

hlJacIdeal = D -> (
    if not D.cache#?"JacF" then D.cache#"JacF" = hlGBIdeal ideal jacobian matrix{{D#"F"}};
    D.cache#"JacF"
    );

hlInterleave = (phi, psi) -> flatten apply(#phi, i -> {phi#i, psi#i});

periodPolynomial = method()
periodPolynomial(List, List) := (phi, psi) -> (
    if #phi == 0 or #phi != #psi then error "periodPolynomial: expected two lists of forms of the same positive length";
    S := ring first phi;
    hlCheckRing S;
    if not all(phi | psi, u -> instance(u, RingElement) and ring u === S and u != 0 and isHomogeneous u) then
        error "periodPolynomial: expected nonzero homogeneous forms in one ring";
    if numgens S != 2 * #phi then error("periodPolynomial: expected k+1 = " | toString(numgens S // 2) | " pairs (the ring has "
        | toString numgens S | " variables)");
    dd := unique apply(#phi, i -> hlDeg(phi#i) + hlDeg(psi#i));
    if #dd != 1 then error "periodPolynomial: F = sum phi_i psi_i is not homogeneous";
    F := sum(#phi, i -> phi#i * psi#i);
    if F == 0 then error "periodPolynomial: F = sum phi_i psi_i is zero";
    J := hlGBIdeal ideal jacobian matrix{{F}};
    hlDetMod(jacobian matrix{hlInterleave(phi, psi)}, J)
    );

-- period polynomials of Y_1, Y_2 modulo the Jacobian ideal: pairs (f_i,g_i),(p_l,s_l) and (h_j,q_j),(p_l,s_l)
hlPeriodPolys = D -> (
    if not D.cache#?"periodPolys" then (
        J := hlJacIdeal D;
        P1 := hlDetMod(jacobian matrix{hlInterleave(D#"f" | D#"p", D#"g" | D#"s")}, J);
        P2 := hlDetMod(jacobian matrix{hlInterleave(D#"h" | D#"p", D#"q" | D#"s")}, J);
        D.cache#"periodPolys" = (P1, P2);
        );
    D.cache#"periodPolys"
    );

-- the matrix (L(x^b x^c))_(c,b) for a linear form L on S_(a+b) given by its dual polynomial R = sum L(x^m) x^m
hlPairingMatrix = (R, Brow, Bcol, kk) -> lift(contract(transpose Brow, contract(Bcol, matrix{{R}})), kk);

-- dual polynomial of P -> Res[P/G] in degree sigma: sum over monomials m of Res[m/G] m
hlResidueDual = G -> (
    rd := hlResidueData G;
    S := rd#"ring";
    B := basis(rd#"sigma", S);
    vals := matrix{hlResRow(rd, B)};
    (B * transpose sub(vals, S))_(0,0)
    );

-- first-order matrices; columns are indexed by a basis of S_sigma' (Jacobian strategy) or of S_d (residue strategy)
hlFirstOrder = (D, strat) -> (
    key := "firstOrder" | strat;
    if D.cache#?key then return D.cache#key;
    S := D#"ring"; kk := D#"field"; d := D#"degree"; k := D#"k";
    sp := k*d - 2*k - 2;
    C1 := null; C2 := null;
    if sp < 0 then (
        C1 = map(kk^0, kk^0, 0); C2 = C1;
        )
    else if strat == "Jacobian" then (
        -- codim T NL(delta) = dim (P_delta * R_sigma') in the Jacobian ring R (Gorenstein duality), P_delta the period polynomial
        J := hlJacIdeal D;
        (P1, P2) := hlPeriodPolys D;
        Bs := basis(sp, S);
        W1 := (P1 * Bs) % J;
        W2 := (P2 * Bs) % J;
        mons := monomials(W1 | W2);
        if numColumns mons == 0 then ( C1 = map(kk^0, kk^(numColumns Bs), 0); C2 = C1; )
        else (
            C1 = lift((coefficients(W1, Monomials => mons))#1, kk);
            C2 = lift((coefficients(W2, Monomials => mons))#1, kk);
            );
        )
    else (
        -- u_i(G)(Q) = Res[Q G / Phi^i]  (paper 3, Lemma 2.1(1) and Lemma 3.5: the same constant kappa for both cycles)
        Bd := basis(d, S); Bq := basis(sp, S);
        C1 = hlPairingMatrix(hlResidueDual D#"Phi1", Bq, Bd, kk);
        C2 = hlPairingMatrix(hlResidueDual D#"Phi2", Bq, Bd, kk);
        );
    D.cache#key = (C1, C2);
    (C1, C2)
    );

tangentExcess = method(Options => {Strategy => "Jacobian"})
tangentExcess(CyclePair, Thing) := opts -> (D, lambda) -> (
    kk := D#"field";
    lam := hlToField(lambda, kk);
    if lam == 0 then error "tangentExcess: lambda must be nonzero";
    strat := opts.Strategy;
    if strat =!= "Jacobian" and strat =!= "Residue" then error "tangentExcess: Strategy must be \"Jacobian\" or \"Residue\"";
    (C1, C2) := hlFirstOrder(D, strat);
    both := if strat == "Jacobian" then C1 | C2 else C1 || C2;
    rZ := rank both;
    rL := rank(C1 + lam * C2);
    new HashTable from {
        "lambda" => lambda,
        "excess" => rZ - rL,
        "codimTNL" => rL,
        "codimTVZ" => rZ,
        "codimTV1" => rank C1,
        "codimTV2" => rank C2,
        "strategy" => strat,
        "label" => "linear algebra " | D#"label" | "; input: "
            | (if strat == "Jacobian"
                then "the period polynomials det Jac(phi_0,psi_0,...) in the Jacobian ring (period formula for complete intersections; Theorem 2 of paper 3 is not used)"
                else "the residue functionals Res[./Phi^i] (paper 3, Lemma 2.1(1), Lemma 3.5; Theorem 2 is not used)")
        }
    );

verifyExcess = method(Options => {Strategy => "Jacobian"})
verifyExcess(CyclePair, List) := opts -> (D, lams) -> (
    kk := D#"field";
    th := excessFromData D;
    lam0 := (D#"lambda0")_kk;
    rows := apply(lams, l -> (
        lam := hlToField(l, kk);
        pred := if lam == lam0 then th#"excessAtLambda0" else th#"excessElsewhere";
        te := tangentExcess(D, l, Strategy => opts.Strategy);
        {l, pred, te#"excess", te#"codimTVZ", te#"codimTV1", te#"codimTV2"}
        ));
    okEx := all(rows, r -> r#1 == r#2);
    okCod := all(rows, r -> r#3 == th#"codimVZ" and r#4 == th#"codimV1" and r#5 == th#"codimV2");
    new HashTable from {
        "agrees" => okEx and okCod,
        "excessAgrees" => okEx,
        "codimensionsAgree" => okCod,
        "table" => apply(rows, r -> {r#0, r#1, r#2}),
        "tableColumns" => {"lambda", "excess predicted by Theorem 2", "excess computed directly"},
        "predicted" => th,
        "strategy" => opts.Strategy,
        "label" => "comparison " | D#"label" | " of Theorem 2 of paper 3 (" | hlProved | ") with a direct first-order computation"
        }
    );
verifyExcess CyclePair := opts -> D -> (
    l0 := D#"lambda0";
    verifyExcess(D, {l0, -l0, 2, 3, -2, 1/2, 5/3}, opts)
    );

------------------------------------------------------------------------------------------------------
-- general first-order utility: tangent codimension of the Hodge locus of the class of a subvariety
------------------------------------------------------------------------------------------------------

hodgeLocusTangentCodim = method(Options => {CheckSmooth => true})
hodgeLocusTangentCodim(RingElement, Ideal) := opts -> (F, I) -> (
    S := ring F;
    hlCheckRing S;
    if ring I =!= S then error "hodgeLocusTangentCodim: the ideal must lie in the ring of F";
    if F == 0 or not isHomogeneous F then error "hodgeLocusTangentCodim: expected a nonzero homogeneous polynomial F";
    if not isHomogeneous I then error "hodgeLocusTangentCodim: expected a homogeneous ideal";
    nv := numgens S;
    if nv % 2 != 0 then error "hodgeLocusTangentCodim: expected an even number 2k+2 of variables (X of even dimension 2k)";
    k := nv // 2 - 1;
    d := hlDeg F;
    kk := coefficientRing S;
    Ig := hlGBIdeal I;
    if F % Ig != 0 then error "hodgeLocusTangentCodim: F does not lie in the ideal (the subvariety is not contained in X)";
    if dim Ig != k + 1 then error("hodgeLocusTangentCodim: expected a subvariety of dimension k = " | toString k
        | " (half the dimension of X); the ideal defines one of dimension " | toString(dim Ig - 1));
    sm := "not checked";
    if opts.CheckSmooth then (
        if not isSmoothHypersurface F then error "hodgeLocusTangentCodim: the hypersurface is singular";
        sm = true;
        );
    t := (k+1)*(d-2);
    e := t - d;                     -- = kd - 2k - 2
    base := {"degree" => d, "k" => k, "socleHalfDegree" => t, "exponent" => e, "smooth" => sm};
    if e < 0 then return new HashTable from (base | {
        "codim" => 0, "upperBound" => 0, "codimIJ" => NotDetermined, "hypothesis" => true,
        "label" => "kd-2k-2 < 0: there are no period conditions (H^(k+1,k-1) = 0), the Hodge locus is the whole space"
        });
    IJ := hlGBIdeal(I + ideal jacobian matrix{{F}});
    A := S/IJ;
    bt := lift(basis(t, A), S);
    m := numColumns bt;
    if m == 0 then return new HashTable from (base | {
        "codim" => 0, "upperBound" => 0, "codimIJ" => 0, "hypothesis" => false,
        "label" => "(I + J)_t = S_t: the period functional of the class vanishes, so the tangent space is S_d; " | hlLabel kk
        });
    Bt := basis(t, S);
    NF := Bt % IJ;
    Bd := basis(d, S); Be := basis(e, S);
    U := null;
    for j from 0 to m-1 do (
        vals := contract(matrix{{bt_(0,j)}}, NF);
        vals = lift(vals, kk);                                  -- coefficient of the j-th standard monomial
        R := (Bt * transpose sub(vals, S))_(0,0);
        Uj := hlPairingMatrix(R, Be, Bd, kk);
        U = if U === null then Uj else U || Uj;
        );
    rk := rank U;
    new HashTable from (base | {
        "codim" => (if m == 1 then rk else NotDetermined),
        "upperBound" => rk,
        "codimIJ" => m,
        "hypothesis" => (m == 1),
        "label" => "codimension of ((I + J) : m^e)_d in S_d, " | hlLabel kk | "; "
            | (if m == 1 then "it is the tangent codimension of the Hodge locus of the class PROVIDED the primitive class is nonzero (then the period functional spans the annihilator of (I+J)_t)"
               else "(I + J)_t has codimension " | toString m | " > 1 in S_t: the period functional is not determined by this method; only an upper bound is returned")
        })
    );
