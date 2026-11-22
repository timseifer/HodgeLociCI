-- HodgeLociCI/Fermat.m2  (owner: agent PB)
-- Item 3: higher-order expansion of Hodge loci at the Fermat point by pole-order (Griffiths-Dwork) reduction.
--
-- STATUS. Written by an AI agent; not reviewed by a human. Nothing here is, or bears on, a proof or disproof
-- of the Hodge conjecture.
--
-- CONVENTIONS (identical to discovery/t3_window/export_c3/README.txt of the session, extended from d = 3 to any d).
--   X0 = {F0 = x_0^d + ... + x_(n+1)^d = 0} in P^(n+1), n even; z = a fixed primitive 2d-th root of unity.
--   A linear space is L = {{a,b,e},...}: x_a = z^e x_b on the pairs {a,b} of a perfect matching, e odd.
--   Period polynomial  P_L = sign(a_1,b_1,a_2,b_2,...) * prod_pairs d c (sum_{r=0}^{d-2} c^r x_a^(d-2-r) x_b^r),  c = z^e
--     (= det Jac(f_1,g_1,f_2,g_2,...) for F0 = sum f_i g_i, f_i = x_a - c x_b).
--   Period functional (closed form of the pole-order reduction at Fermat), for g_j = d m_j + r_j, 0 <= r_j <= d-1:
--     Psi_P(x^g) = prod_j ((1+r_j)/d)_(m_j) * [coefficient of x^((d-2,...,d-2) - r) in P]   if all r_j <= d-2, else 0.
--   Period functions along F0 - T:  Phi_Q(F0 - T) = int_delta Res(Q Omega/(F0 - T)^k) = ((n/2)!/(k-1)!) Psi_P(Q exp(T)),
--     k = (deg Q + n + 2)/d, up to ONE nonzero constant common to all Q and all classes delta.
-- All private names in this file start with `fm`.

export {
    "fermatRing", "fermatRoot", "fermatLinearSpaceIdeal", "fermatPeriodPolynomial", "fermatPeriod", "fermatPeriodGD",
    "fermatPeriodForms", "fermatDeformationMonomials", "fermatExpansion", "fermatFirstOrderMatrix",
    "fermatHodgeTangent", "fermatPersistenceTangent", "fermatTangentData", "fermatNextOrderSystem", "fermatExtendArc",
    "fermatVerifyArc", "fermatReadCertificate", "fermatWriteCertificate", "fermatVerifyCertificate",
    "Parameters", "Forms", "AllMonomials", "Prime"
    }

fmKey = "HodgeLociCIFermat"

-- ------------------------------------------------------------------------------------------------ utilities
fmCyclotomic = (m, x) -> (
    f := x^m - 1;
    for k from 1 to m-1 do if m % k == 0 then f = f // fmCyclotomic(k, x);
    f)

fmPermSign = s -> (
    sg := 1;
    for a from 0 to #s-1 do for b from a+1 to #s-1 do if s#a > s#b then sg = -sg;
    sg)

fmInfo = S -> (
    if not instance(S, PolynomialRing) or not S#?fmKey then
        error "expected a ring created by fermatRing (or an element of such a ring)";
    S#fmKey)

fmRootModP = (d, p) -> (
    K := ZZ/p;
    qs := select(toList(2..2*d), q -> (2*d) % q == 0 and isPrime q);
    for g from 2 to p-1 do (
        a := (g_K)^((p-1)//(2*d));
        if all(qs, q -> a^((2*d)//q) != 1_K) then return a);
    error "fermatRing: no primitive 2d-th root of unity found")

fmMakeRing = (d, n, p, opts) -> (
    if d < 2 then error "fermatRing: the degree d must be at least 2";
    if n < 0 or odd n then error "fermatRing: the dimension n must be even and non-negative";
    params := opts.Parameters;
    if not instance(params, List) then error "fermatRing: Parameters must be a list of symbols";
    K := null; z := null; A := null;
    if p == 0 then (
        A = QQ(monoid [getSymbol "z"]);
        K = toField(A/ideal fmCyclotomic(2*d, A_0));
        z = K_0)
    else (
        if p < 2 or not isPrime p then error("fermatRing: " | toString p | " is not a prime");
        if p % (2*d) != 1 then error("fermatRing: the prime must be 1 mod 2d = " | toString(2*d) | " (so that ZZ/p contains the 2d-th roots of unity)");
        K = ZZ/p;
        z = fmRootModP(d, p));
    xs := if instance(opts.Variable, Symbol) then opts.Variable else getSymbol toString opts.Variable;
    m := n + 2;
    varlist := apply(m, i -> xs_i);
    S := if #params == 0 then K[varlist]
         else K[varlist | params, Degrees => toList(m:1) | toList(#params:0)];
    S#fmKey = new HashTable from {
        "d" => d, "n" => n, "nv" => m, "np" => #params, "p" => p, "K" => K, "z" => z, "A" => A,
        "cache" => new MutableHashTable};
    S)

fermatRing = method(Options => {Parameters => {}, Variable => "x"})
fermatRing(ZZ, ZZ) := opts -> (d, n) -> fmMakeRing(d, n, 0, opts)
fermatRing(ZZ, ZZ, ZZ) := opts -> (d, n, p) -> (
    if p == 0 then error "fermatRing: the prime must be positive (omit it for exact arithmetic)";
    fmMakeRing(d, n, p, opts))

fermatRoot = method()
fermatRoot(Ring) := S -> (fmInfo S)#"z"

fmLabel = info -> if info#"p" == 0 then "EXACT over QQ(zeta_" | toString(2*info#"d") | ")" else "MOD p = " | toString(info#"p")

-- rational number (ZZ or QQ) -> element of the coefficient field
fmToK = (a, info) -> (
    K := info#"K";
    if info#"p" == 0 then return promote(a, K);
    a = a/1;
    den := (denominator a)_K;
    if den == 0 then error("a denominator is divisible by the prime " | toString(info#"p"));
    (numerator a)_K / den)

-- ------------------------------------------------------------------------------------------------ linear spaces
fmCheckSpace = (S, L) -> (
    info := fmInfo S; m := info#"nv";
    if not instance(L, List) or #L != m//2 or not all(L, t -> instance(t, List) and #t == 3 and all(t, e -> instance(e, ZZ))) then
        error("a linear space must be a list of " | toString(m//2) | " triples {a,b,e} of integers, meaning x_a = z^e x_b");
    idx := flatten apply(L, t -> {t#0, t#1});
    if sort idx != toList(0..m-1) then
        error("the pairs {a,b} of a linear space must form a perfect matching of the indices 0.." | toString(m-1));
    if not all(L, t -> odd(t#2)) then
        error("in x_a = z^e x_b the exponent e must be odd (z^e must be a d-th root of -1, z a primitive 2d-th root of unity)");
    info)

fermatLinearSpaceIdeal = method()
fermatLinearSpaceIdeal(Ring, List) := (S, L) -> (
    info := fmCheckSpace(S, L);
    z := info#"z";
    ideal apply(L, t -> S_(t#0) - z^(t#2 % (2*info#"d")) * S_(t#1)))

fermatPeriodPolynomial = method()
fermatPeriodPolynomial(Ring, List) := (S, L) -> (
    info := fmCheckSpace(S, L);
    z := info#"z"; d := info#"d";
    sgn := fmPermSign flatten apply(L, t -> {t#0, t#1});
    P := sgn * 1_S;
    scan(L, t -> (
        c := z^(t#2 % (2*d));
        xa := S_(t#0); xb := S_(t#1);
        P = P * (d * c * sum(d-1, r -> c^r * xa^(d-2-r) * xb^r))));
    P)

-- ------------------------------------------------------------------------------------------------ the functional
fmPoch = (info, r, mm) -> (
    c := info#"cache";
    if c#?(r, mm) then return c#(r, mm);
    K := info#"K";
    v := 1_K;
    if mm > 0 then (
        fac := fmToK((1 + r + (info#"d")*(mm-1))/(info#"d"), info);
        v = fmPoch(info, r, mm-1) * fac);
    c#(r, mm) = v;
    v)

-- data attached to a period polynomial P: residue pattern r -> coefficient of x^((d-2,..,d-2)-r) in P
fmPdata = P -> (
    if not instance(P, RingElement) then error "expected a period polynomial (an element of a fermatRing)";
    S := ring P; info := fmInfo S;
    d := info#"d"; n := info#"n"; m := info#"nv"; np := info#"np";
    D := (d-2)*(n//2+1);
    V := if np == 0 then info#"K" else S;
    tab := new MutableHashTable; mon := new MutableHashTable;
    fast := true;
    if P != 0 then (
        (M, C) := coefficients(P, Variables => apply(m, i -> S_i));
        for i from 0 to numcols M - 1 do (
            e := take(first exponents M_(0,i), m);
            if sum e != D or max e > d-2 then
                error("the period polynomial must be homogeneous of degree (d-2)(n/2+1) = " | toString D | " in the x-variables with all exponents at most d-2 = " | toString(d-2));
            r := apply(e, a -> d-2-a);
            c := C_(i,0);
            if np > 0 and #(support c) > 0 then fast = false;
            tab#r = if np == 0 then lift(c, info#"K") else c;
            mon#r = product(m, j -> (S_j)^(r#j))));
    Pc := 0_S;
    scan(keys tab, r -> Pc = Pc + promote(tab#r, S) * mon#r);
    new HashTable from {"S" => S, "info" => info, "D" => D, "V" => V, "table" => new HashTable from tab,
        "mon" => new HashTable from mon, "Pc" => Pc, "fast" => fast})

-- closed form on one exponent vector (length nv)
fmPsiExp = (pd, g) -> (
    info := pd#"info"; d := info#"d";
    r := apply(g, a -> a % d);
    tab := pd#"table";
    if not tab#?r then return 0_(pd#"V");
    w := 1_(info#"K");
    for i from 0 to #g-1 do if g#i >= d then w = w * fmPoch(info, r#i, g#i // d);
    w * tab#r)

-- multiply f by x_j^q and reduce the pole order in the variable x_j:  x_j^(d m + r) -> ((1+r)/d)_m x_j^r  (0 if r = d-1)
fmReduceVar = (S, info, f, j, q) -> (
    if f == 0 then return f;
    d := info#"d"; xj := S_j;
    (M, C) := coefficients(f, Variables => {xj});
    out := 0_S;
    for i from 0 to numcols M - 1 do (
        g := degree(xj, M_(0,i)) + q;
        r := g % d;
        if r != d-1 then out = out + (fmPoch(info, r, g // d) * xj^r) * C_(i,0));
    out)

-- pairing of a fully reduced polynomial with P
fmPair = (pd, f) -> (
    S := pd#"S"; V := pd#"V";
    if f == 0 then return 0_V;
    fD := part(pd#"D", f);
    if fD == 0 then return 0_V;
    v := if pd#"fast" then contract(pd#"Pc", fD)
         else sum(keys pd#"table", r -> pd#"table"#r * contract(pd#"mon"#r, fD));
    if V === S then v else lift(v, V))

-- Psi_P(Q f) for all Q in a list of exponent vectors, sharing the reductions (tree over the variables)
fmEvalForms = (pd, f, fexps) -> (
    S := pd#"S"; info := pd#"info"; m := info#"nv"; V := pd#"V";
    res := new MutableList from toList(#fexps : 0_V);
    if #fexps == 0 then return {};
    go := null;
    go = (h, j, idxs) -> (
        if h == 0 then return;
        if j == m then (v := fmPair(pd, h); scan(idxs, i -> res#i = v); return);
        gr := partition(i -> (fexps#i)#j, idxs);
        scan(keys gr, q -> go(fmReduceVar(S, info, h, j, q), j+1, gr#q)));
    go(f, 0, toList(0..#fexps-1));
    toList res)

fermatPeriod = method()
fermatPeriod(RingElement, RingElement) := (P, f) -> (
    pd := fmPdata P;
    if ring f =!= pd#"S" then error "fermatPeriod: the two arguments must lie in the same fermatRing";
    first fmEvalForms(pd, f, {toList(pd#"info"#"nv" : 0)}))
fermatPeriod(RingElement, ZZ) := (P, a) -> fermatPeriod(P, a_(ring P))

-- literal Griffiths-Dwork reduction of x^beta Omega / F0^k  (rules (2), (3) of export_c3/README.txt for d = 3)
fmGD = (pd, beta, k, useLast) -> (
    info := pd#"info"; d := info#"d"; n := info#"n"; V := pd#"V";
    js := positions(beta, b -> b >= d-1);
    if #js == 0 then (
        if k != n//2 + 1 then return 0_V;
        return if pd#"table"#?beta then pd#"table"#beta else 0_V);
    j := if useLast then last js else first js;
    num := beta#j - (d-1);
    if num == 0 or k <= 1 then return 0_V;
    b2 := apply(#beta, i -> if i == j then beta#i - d else beta#i);
    fmToK(num/(d*(k-1)), info) * fmGD(pd, b2, k-1, useLast))

fermatPeriodGD = method(Options => {Strategy => "First"})
fermatPeriodGD(RingElement, RingElement, ZZ) := opts -> (P, f, k) -> (
    pd := fmPdata P; S := pd#"S"; info := pd#"info"; m := info#"nv";
    if ring f =!= S then error "fermatPeriodGD: the two polynomials must lie in the same fermatRing";
    if opts.Strategy =!= "First" and opts.Strategy =!= "Last" then error "fermatPeriodGD: Strategy must be \"First\" or \"Last\"";
    V := pd#"V"; out := 0_V;
    if f == 0 then return out;
    (M, C) := coefficients(f, Variables => apply(m, i -> S_i));
    for i from 0 to numcols M - 1 do (
        beta := take(first exponents M_(0,i), m);
        if sum beta != (info#"d")*k - m then
            error("fermatPeriodGD: for pole order k = " | toString k | " the numerator must be homogeneous of degree d*k - (n+2) = " | toString((info#"d")*k - m));
        c := C_(i,0);
        out = out + (if V === S then c else lift(c, V)) * fmGD(pd, beta, k, opts.Strategy === "Last"));
    out)

-- ------------------------------------------------------------------------------------------------ monomial lists
-- exponent vectors of length m, entries <= maxE, sum deg; decreasing lexicographic order
fmBoundedExps = (m, deg, maxE) -> (
    if deg < 0 or deg > m*maxE then return {};
    if m == 0 then return {{}};
    flatten apply(reverse toList(0..min(deg, maxE)), a -> apply(fmBoundedExps(m-1, deg-a, maxE), e -> prepend(a, e))))

fmExpToMon = (S, e) -> product(#e, i -> (S_i)^(e#i))

fermatPeriodForms = method(Options => {AllMonomials => false})
fermatPeriodForms(Ring) := opts -> S -> (
    info := fmInfo S; d := info#"d"; n := info#"n"; m := info#"nv";
    exps := if opts.AllMonomials then fmBoundedExps(m, d*(n//2) - m, d*(n//2))
            else flatten apply(toList(1..n//2), k -> fmBoundedExps(m, d*k - m, d-2));
    apply(exps, e -> fmExpToMon(S, e)))

fermatDeformationMonomials = method(Options => {AllMonomials => false})
fermatDeformationMonomials(Ring) := opts -> S -> (
    info := fmInfo S; d := info#"d"; m := info#"nv";
    apply(fmBoundedExps(m, d, if opts.AllMonomials then d else d-2), e -> fmExpToMon(S, e)))

-- exponent vector of a monomial in the x-variables (error otherwise)
fmMonExp = (S, info, Q, what) -> (
    if not instance(Q, RingElement) or ring Q =!= S or Q == 0 or #(terms Q) != 1 or leadCoefficient Q != 1 then
        error(what | ": expected a list of monomials (coefficient 1) of the fermatRing");
    e := first exponents Q;
    if any(drop(e, info#"nv"), a -> a != 0) then error(what | ": the monomials must not involve the parameters");
    take(e, info#"nv"))

-- forms: exponent vectors and normalising constants (n/2)!/(k-1)!
fmFormData = (S, info, forms) -> (
    d := info#"d"; n := info#"n"; m := info#"nv";
    fexps := apply(forms, Q -> fmMonExp(S, info, Q, "Forms"));
    consts := apply(fexps, e -> (
        if (sum e + m) % d != 0 then
            error("Forms: the degree of a numerator Q must be d*k - (n+2) for an integer pole order k >= 1; got degree " | toString(sum e));
        k := (sum e + m)//d;
        fmToK(((n//2)!)/((k-1)!), info)));
    (fexps, consts))

fmGetForms = (S, opts) -> if opts.Forms === null then fermatPeriodForms S else (
    if not instance(opts.Forms, List) then error "Forms: expected a list of monomials";
    opts.Forms)

fmCheckArc = (S, info, Ts, what) -> (
    if not instance(Ts, List) then error(what | ": the arc must be a list {T_1, T_2, ...} of forms of degree d");
    apply(Ts, T -> (
        if instance(T, ZZ) and T == 0 then return 0_S;
        if not instance(T, RingElement) or ring T =!= S then error(what | ": the terms of the arc must lie in the fermatRing of the period polynomial");
        if T != 0 and (not isHomogeneous T or first degree T != info#"d") then
            error(what | ": every term T_j of the arc must be homogeneous of degree d = " | toString(info#"d") | " in the x-variables");
        T)))

-- ------------------------------------------------------------------------------------------------ the expansion
-- E_n = [eps^n] exp(eps T_1 + eps^2 T_2 + ...):   n E_n = sum_j j T_j E_(n-j)
fmNextE = (S, info, E, Ts, nn) -> (
    acc := 0_S;
    for j from 1 to min(nn, #Ts) do if Ts#(j-1) != 0 then acc = acc + (j * Ts#(j-1)) * E#(nn-j);
    fmToK(1/nn, info) * acc)

-- list over n = 1..N of the lists (over the forms) of c_n[Q]
fmSeries = (pd, Ts, N, fexps, consts) -> (
    S := pd#"S"; info := pd#"info";
    if info#"p" > 0 and N >= info#"p" then error "the order must be smaller than the prime";
    E := new MutableList from {1_S};
    for nn from 1 to N list (
        E#nn = fmNextE(S, info, E, Ts, nn);
        vals := fmEvalForms(pd, E#nn, fexps);
        apply(#fexps, i -> consts#i * vals#i)))

fmColsToMatrix = (V, cols, nrows) -> (
    if nrows == 0 then return map(V^0, V^(#cols), 0);
    matrix(V, apply(nrows, i -> apply(cols, c -> c#i))))

fermatExpansion = method(Options => {Forms => null})
fermatExpansion(RingElement, List, ZZ) := opts -> (P, Ts, N) -> (
    pd := fmPdata P; S := pd#"S"; info := pd#"info";
    if N < 1 then error "fermatExpansion: the order N must be at least 1";
    Ts = fmCheckArc(S, info, Ts, "fermatExpansion");
    forms := fmGetForms(S, opts);
    (fexps, consts) := fmFormData(S, info, forms);
    fmColsToMatrix(pd#"V", fmSeries(pd, Ts, N, fexps, consts), #forms))

-- ------------------------------------------------------------------------------------------------ linear algebra
-- Reduced row echelon form over the coefficient field by rank-one updates (each update is one engine operation).
-- Written out because `kernel` over a field made by toField may return a non-minimal generating set.
fmRref = A -> (
    K := ring A; nr := numrows A; nc := numcols A;
    piv := {}; r := 0;
    if nr == 0 or nc == 0 then return (map(K^0, K^nc, 0), {});
    idn := id_(K^nr);
    for c from 0 to nc-1 do (
        if r == nr then break;
        colc := flatten entries A_{c};
        pr := null;
        for i from r to nr-1 do if colc#i != 0 then (pr = i; break);
        if pr === null then continue;
        if pr != r then A = A^(toList(0..r-1) | {pr} | toList(r+1..pr-1) | {r} | toList(pr+1..nr-1));
        prow := (1/A_(r,c)) * A^{r};
        A = A - (A_{c} - idn_{r}) * prow;
        piv = append(piv, c); r = r + 1);
    (if r == 0 then map(K^0, K^nc, 0) else A^(toList(0..r-1)), piv))

fmRank = A -> #(last fmRref A)

-- basis of the kernel, as the columns of a matrix
fmKernel = A -> (
    K := ring A; nc := numcols A;
    (R, piv) := fmRref A;
    free := select(toList(0..nc-1), c -> not member(c, piv));
    if #free == 0 then return map(K^nc, K^0, 0);
    pivpos := new HashTable from apply(#piv, i -> piv#i => i);
    Rfree := if #piv == 0 then null else entries R_free;
    transpose matrix(K, apply(#free, a -> apply(nc, c ->
        if c == free#a then 1_K else if pivpos#?c then -(Rfree#(pivpos#c))#a else 0_K))))

-- left kernel (rows)
fmLeftKernel = L -> transpose fmKernel transpose L

-- one solution x of L x = b (b a column), or null
fmSolve = (L, b) -> (
    K := ring L; nc := numcols L;
    if nc == 0 then return if b == 0 then map(K^0, K^1, 0) else null;
    (R, piv) := fmRref(L | b);
    if #piv > 0 and last piv == nc then return null;
    x := new MutableList from toList(nc : 0_K);
    scan(#piv, i -> x#(piv#i) = R_(i, nc));
    matrix(K, apply(toList x, a -> {a})))

-- ------------------------------------------------------------------------------------------------ first order
fmLmatrix = (pd, fexps, consts, mexps) -> (
    V := pd#"V";
    if #fexps == 0 then return map(V^0, V^(#mexps), 0);
    matrix(V, apply(#fexps, i -> apply(mexps, a -> consts#i * fmPsiExp(pd, fexps#i + a)))))

fmGetMons = (S, info, opts) -> (
    if opts.Monomials === null then return fermatDeformationMonomials S;
    if not instance(opts.Monomials, List) then error "Monomials: expected a list of monomials of degree d";
    scan(opts.Monomials, a -> if sum fmMonExp(S, info, a, "Monomials") != info#"d" then error "Monomials: expected monomials of degree d");
    opts.Monomials)

fermatFirstOrderMatrix = method(Options => {Forms => null, Monomials => null})
fermatFirstOrderMatrix(RingElement) := opts -> P -> (
    pd := fmPdata P; S := pd#"S"; info := pd#"info";
    forms := fmGetForms(S, opts);
    (fexps, consts) := fmFormData(S, info, forms);
    mons := fmGetMons(S, info, opts);
    fmLmatrix(pd, fexps, consts, apply(mons, a -> fmMonExp(S, info, a, "Monomials"))))

fmNeedField = (pd, what) -> if pd#"V" =!= pd#"info"#"K" then
    error(what | ": not available in a fermatRing with Parameters (linear algebra needs a field)")

fermatHodgeTangent = method()
fermatHodgeTangent(RingElement) := P -> (
    pd := fmPdata P; S := pd#"S";
    fmNeedField(pd, "fermatHodgeTangent");
    mons := fermatDeformationMonomials(S, AllMonomials => true);
    L := fermatFirstOrderMatrix(P, Monomials => mons);
    matrix{mons} * promote(fmKernel L, S))

fmJacobian = S -> (info := fmInfo S; ideal apply(info#"nv", i -> (S_i)^(info#"d" - 1)))

fermatPersistenceTangent = method()
fermatPersistenceTangent(Ring, List) := (S, spaces) -> (
    info := fmInfo S;
    if info#"np" > 0 then error "fermatPersistenceTangent: not available in a fermatRing with Parameters";
    if #spaces == 0 then error "fermatPersistenceTangent: expected a non-empty list of linear spaces";
    J := fmJacobian S;
    I := intersect apply(spaces, L -> fermatLinearSpaceIdeal(S, L) + J);
    super basis(info#"d", I))

fermatTangentData = method()
fermatTangentData(Ring, List, List) := (S, spaces, cs) -> (
    info := fmInfo S; d := info#"d";
    if info#"np" > 0 then error "fermatTangentData: not available in a fermatRing with Parameters";
    if #spaces == 0 or #spaces != #cs then error "fermatTangentData: expected a list of linear spaces and a list of as many coefficients";
    K := info#"K";
    cs = apply(cs, c -> if instance(c, ZZ) or instance(c, QQ) then fmToK(c, info) else (
        if not instance(c, RingElement) then error "fermatTangentData: the coefficients must be numbers";
        if ring c === K then c else lift(c, K)));
    Ps := apply(spaces, L -> fermatPeriodPolynomial(S, L));
    Pdelta := sum(#Ps, i -> cs#i * Ps#i);
    mons := fermatDeformationMonomials(S, AllMonomials => true);
    Ls := apply(Ps, P -> fermatFirstOrderMatrix(P, Monomials => mons));
    Ld := fermatFirstOrderMatrix(Pdelta, Monomials => mons);
    J := fmJacobian S;
    Is := apply(spaces, L -> fermatLinearSpaceIdeal(S, L) + J);
    amb := #mons;
    cod := I -> amb - numcols super basis(d, I);
    jointIdeal := cod intersect Is;
    hodge := fmRank Ld;
    new HashTable from {
        "label" => fmLabel info,
        "ambientDimension" => amb,
        "hodgeCodimension" => hodge,
        "singleHodgeCodimensions" => apply(Ls, fmRank),
        "persistenceCodimensions" => apply(Is, cod),
        "jointPeriodCodimension" => fmRank fold((a, b) -> a || b, Ls),
        "jointPersistenceCodimension" => jointIdeal,
        "excess" => jointIdeal - hodge})

-- ------------------------------------------------------------------------------------------------ order by order
fmFirstNonzero = cols -> (
    for i from 0 to #cols-1 do if any(cols#i, c -> c != 0) then return i+1;
    null)

fermatVerifyArc = method(Options => {Forms => null})
fermatVerifyArc(RingElement, List, ZZ) := opts -> (P, Ts, N) -> (
    pd := fmPdata P; S := pd#"S"; info := pd#"info";
    if N < 1 then error "fermatVerifyArc: the order N must be at least 1";
    Ts = fmCheckArc(S, info, Ts, "fermatVerifyArc");
    forms := fmGetForms(S, opts);
    (fexps, consts) := fmFormData(S, info, forms);
    -- stop at the first failing order
    E := new MutableList from {1_S}; bad := null;
    for nn from 1 to N do (
        E#nn = fmNextE(S, info, E, Ts, nn);
        vals := fmEvalForms(pd, E#nn, fexps);
        if any(vals, v -> v != 0) then (bad = nn; break));
    new HashTable from {"pass" => bad === null, "firstFailingOrder" => bad, "order" => N, "numberOfForms" => #forms,
        "label" => fmLabel info})
fermatVerifyArc(RingElement, List) := opts -> (P, Ts) -> fermatVerifyArc(P, Ts, #Ts, opts)

-- the first-order matrix over the coefficient field (also in a ring with parameters, where it must not involve them)
fmLfield = (pd, fexps, consts, mexps, what) -> (
    K := pd#"info"#"K";
    L := fmLmatrix(pd, fexps, consts, mexps);
    if pd#"V" === K then return L;
    if not all(flatten entries L, c -> #(support c) == 0) then
        error(what | ": the first-order matrix depends on the parameters; this is not supported");
    lift(L, K))

-- coefficients (list, in V) of a solution T of L T = -c, or null; with parameters the system is solved for the
-- coefficient of every monomial in the parameters, so the solution is polynomial in the parameters
fmSolveV = (pd, L, cvals) -> (
    S := pd#"S"; K := pd#"info"#"K"; V := pd#"V";
    if V === K then (
        sol := fmSolve(L, -matrix(K, apply(cvals, c -> {c})));
        return if sol === null then null else flatten entries sol);
    pms := unique flatten apply(cvals, c -> if c == 0 then {} else flatten entries monomials c);
    out := toList(numcols L : 0_S);
    for pm in pms do (
        solp := fmSolve(L, -matrix(K, apply(cvals, c -> {coefficient(pm, c)})));
        if solp === null then return null;
        out = apply(#out, i -> out#i + pm * promote(solp_(i,0), S)));
    out)

fmColumnV = (pd, cvals) -> if #cvals == 0 then map((pd#"V")^0, (pd#"V")^1, 0) else matrix(pd#"V", apply(cvals, c -> {c}))

fermatNextOrderSystem = method(Options => {Forms => null, Monomials => null})
fermatNextOrderSystem(RingElement, List) := opts -> (P, Ts) -> (
    pd := fmPdata P; S := pd#"S"; info := pd#"info"; K := info#"K"; V := pd#"V";
    Ts = fmCheckArc(S, info, Ts, "fermatNextOrderSystem");
    forms := fmGetForms(S, opts);
    (fexps, consts) := fmFormData(S, info, forms);
    mons := fmGetMons(S, info, opts);
    N := #Ts + 1;
    cols := fmSeries(pd, Ts, N, fexps, consts);
    bad := fmFirstNonzero drop(cols, -1);
    L := fmLfield(pd, fexps, consts, apply(mons, a -> fmMonExp(S, info, a, "Monomials")), "fermatNextOrderSystem");
    cN := fmColumnV(pd, last cols);
    Kl := fmLeftKernel L;
    obs := (if V === K then Kl else promote(Kl, S)) * cN;
    sol := fmSolveV(pd, L, last cols);
    new HashTable from {
        "label" => fmLabel info,
        "order" => N,
        "lowerOrdersVanish" => bad === null,
        "firstFailingOrder" => bad,
        "forms" => forms, "monomials" => mons,
        "matrix" => L,
        "coefficient" => cN,
        "cokernel" => Kl,
        "obstruction" => obs,
        "solvable" => sol =!= null,
        "solution" => if sol === null then null else sum(#mons, i -> sol#i * mons#i)})

fermatExtendArc = method(Options => {Forms => null, Monomials => null})
fermatExtendArc(RingElement, List, ZZ) := opts -> (P, Ts, N) -> (
    pd := fmPdata P; S := pd#"S"; info := pd#"info"; K := info#"K"; V := pd#"V";
    Ts = fmCheckArc(S, info, Ts, "fermatExtendArc");
    forms := fmGetForms(S, opts);
    (fexps, consts) := fmFormData(S, info, forms);
    mons := fmGetMons(S, info, opts);
    L := fmLfield(pd, fexps, consts, apply(mons, a -> fmMonExp(S, info, a, "Monomials")), "fermatExtendArc");
    E := new MutableList from {1_S};
    arc := new MutableList from Ts;
    obstructed := null; obs := null;
    for nn from 1 to N do (
        E#nn = fmNextE(S, info, E, toList arc, nn);
        vals := fmEvalForms(pd, E#nn, fexps);
        cn := apply(#fexps, i -> consts#i * vals#i);
        if nn <= #Ts then (
            if any(cn, c -> c != 0) then error("fermatExtendArc: the given arc does not satisfy the equations at order " | toString nn))
        else (
            sol := fmSolveV(pd, L, cn);
            if sol === null then (
                obstructed = nn;
                Kl := fmLeftKernel L;
                obs = (if V === K then Kl else promote(Kl, S)) * fmColumnV(pd, cn);
                break);
            Tn := sum(#mons, i -> sol#i * mons#i) + 0_S;
            arc#(nn-1) = Tn;
            E#nn = E#nn + Tn));
    new HashTable from {"label" => fmLabel info, "arc" => toList arc, "order" => #arc,
        "obstructedAtOrder" => obstructed, "obstruction" => obs})

-- ------------------------------------------------------------------------------------------------ certificate files
fmStrip = s -> replace("^[ \t\r]+|[ \t\r]+$", "", s)

-- split s at the character ch outside parentheses and brackets
fmSplitTop = (s, ch) -> (
    depth := 0; start := 0; pieces := {};
    for i from 0 to #s-1 do (
        c := s#i;
        if c == "(" or c == "[" then depth = depth + 1
        else if c == ")" or c == "]" then depth = depth - 1
        else if c == ch and depth == 0 then (pieces = append(pieces, substring(start, i-start, s)); start = i+1));
    append(pieces, substring(start, #s-start, s)))

fmParseRational = s -> (
    if not match("^-?[0-9]+(/[0-9]+)?$", s) then error("fermatReadCertificate: cannot read the number '" | s | "'");
    value s)

-- numbers are written  a  |  (a)*z  |  (a)+(b)*z  |  (a0)+(a1)*z+(a2)*z^2+...   with rational a_i
fmParseNumber = (s, info) -> (
    s = replace("[ \t]", "", s);
    if #s == 0 then error "fermatReadCertificate: empty number";
    z := info#"z"; K := info#"K";
    out := 0_K;
    scan(fmSplitTop(s, "+"), t -> (
        e := 0; cpart := t;
        pos := regex("\\*?z(\\^[0-9]+)?$", t);
        if pos =!= null then (
            cpart = substring(0, pos#0#0, t);
            zp := substring(pos#0, t);
            e = if match("\\^", zp) then value last fmSplitTop(zp, "^") else 1);
        cpart = replace("[()]", "", cpart);
        a := if cpart == "" then 1 else if cpart == "-" then -1 else fmParseRational cpart;
        out = out + fmToK(a, info) * z^e));
    out)

fmParseMonomial = (s, S, info) -> (
    s = replace("[ \t]", "", s);
    if s == "1" then return 1_S;
    product(fmSplitTop(s, "*"), f -> (
        if not match("^x[0-9]+(\\^[0-9]+)?$", f) then error("fermatReadCertificate: cannot read the monomial '" | s | "'");
        parts := fmSplitTop(substring(1, f), "^");
        i := value parts#0;
        if i >= info#"nv" then error("fermatReadCertificate: variable x" | toString i | " out of range");
        (S_i)^(if #parts > 1 then value parts#1 else 1))))

-- "[c]*mono + [c]*mono + ..."  or "0"
fmParsePoly = (s, S, info) -> (
    s = fmStrip s;
    if s == "0" then return 0_S;
    sum(fmSplitTop(s, "+"), t -> (
        t = fmStrip t;
        pos := regex("\\]", t);
        if #t == 0 or t#0 != "[" or pos === null then error("fermatReadCertificate: cannot read the term '" | t | "'");
        c := fmParseNumber(substring(1, pos#0#0 - 1, t), info);
        rest := substring(pos#0#0 + 1, t);
        if rest == "" then c * 1_S else (
            if rest#0 != "*" then error("fermatReadCertificate: cannot read the term '" | t | "'");
            c * fmParseMonomial(substring(1, rest), S, info)))))

-- "[c]*(mono)^dual + ..."  -> list of {monomial, coefficient}
fmParseFunctional = (s, S, info) -> apply(fmSplitTop(fmStrip s, "+"), t -> (
    t = fmStrip t;
    pos := regex("\\]\\*\\(", t); pos2 := regex("\\)\\^dual$", t);
    if #t == 0 or t#0 != "[" or pos === null or pos2 === null then error("fermatReadCertificate: cannot read the functional term '" | t | "'");
    {fmParseMonomial(substring(pos#0#0 + 3, pos2#0#0 - pos#0#0 - 3, t), S, info), fmParseNumber(substring(1, pos#0#0 - 1, t), info)}))

fmIntAfter = (pat, s) -> (pos := regex(pat, s); if pos === null then null else value substring(pos#1, s))

fermatReadCertificate = method(Options => {Prime => 0})
fermatReadCertificate(String) := opts -> file -> (
    if not fileExists file then error("fermatReadCertificate: file not found: " | file);
    d := 3; NV := null; p := opts.Prime; S := null; info := null;
    need := () -> (
        if S === null then (
            if NV === null then error "fermatReadCertificate: the line 'NV = ...' must come before the data";
            if odd NV then error "fermatReadCertificate: NV must be even";
            S = if p == 0 then fermatRing(d, NV-2) else fermatRing(d, NV-2, p);
            info = fmInfo S));
    spaces := new MutableHashTable; arc := new MutableHashTable;
    lam := null; delta := null; forms := null; vanish := null; obsOrder := null;
    claimedC := new MutableHashTable; functionals := {}; pendingFunctional := null;
    listedP := null; ranks := new MutableHashTable; extra := new MutableHashTable; ignored := {};
    mode := "";
    scan(lines get file, raw -> (
        s := fmStrip raw;
        if s == "" or s#0 == "#" then return;
        if match("^NV *=", s) then (NV = value fmStrip last fmSplitTop(s, "="); return);
        if match("^d *=", s) then (d = value fmStrip last fmSplitTop(s, "="); return);
        if match("^prime *=", s) then (
            pf := value fmStrip last fmSplitTop(s, "=");
            if S =!= null then error "fermatReadCertificate: the line 'prime = ...' must come before the data";
            if p == 0 then p = pf
            else if p != pf then error("fermatReadCertificate: the file contains residues modulo " | toString pf | "; it cannot be read modulo " | toString p);
            return);
        if match("^lambda *=", s) then (need(); lam = fmParseNumber(substring(1 + (regex("=", s))#0#0, s), info); return);
        if match("^P[0-9]+:", s) then (
            need();
            i := fmIntAfter("^P([0-9]+):", s);
            spaces#i = apply(fmSplitTop(substring(1 + (regex(":", s))#0#0, s), ","), t -> (
                t = replace("[ \t]", "", t);
                if not match("^x[0-9]+=z\\^-?[0-9]+\\*x[0-9]+$", t) then error("fermatReadCertificate: cannot read the equation '" | t | "'");
                {fmIntAfter("^x([0-9]+)=", t), fmIntAfter("\\*x([0-9]+)$", t), fmIntAfter("z\\^(-?[0-9]+)\\*", t)}));
            return);
        if match("^delta *=", s) then (
            need();
            delta = apply(fmSplitTop(substring(1 + (regex("=", s))#0#0, s), "+"), t -> (
                t = fmStrip t; pos := regex("\\]\\*P([0-9]+)$", t);
                if pos === null or t#0 != "[" then error("fermatReadCertificate: cannot read the class term '" | t | "'");
                {value substring(pos#1, t), fmParseNumber(substring(1, pos#0#0 - 1, t), info)}));
            return);
        if match("^forms Q", s) then (
            need();
            forms = apply(fmSplitTop(substring(1 + (regex(":", s))#0#0, s), ","), t -> fmParseMonomial(t, S, info));
            return);
        if match("^arc", s) then return;
        if match("^T_[0-9]+ *=", s) then (
            need();
            arc#(fmIntAfter("^T_([0-9]+)", s)) = fmParsePoly(substring(1 + (regex("=", s))#0#0, s), S, info);
            return);
        if match("^excess part", s) or match("^T V part", s) then (
            need();
            extra#(if match("^excess", s) then "excessPart" else "tangentPart") = fmParsePoly(substring(1 + (regex(":", s))#0#0, s), S, info);
            return);
        if match("^period polynomial", s) then (need(); mode = "P"; listedP = 0_S; return);
        if match("^claim", s) then (
            mode = "";
            if match("k = 1\\.\\.[0-9]+", s) then vanish = fmIntAfter("k = 1\\.\\.([0-9]+)", s);
            if match("^claim[ 0-9]*: the coefficients of eps\\^[0-9]+", s) then (obsOrder = fmIntAfter("the coefficients of eps\\^([0-9]+)", s); mode = "c");
            if match("rank L = [0-9]+", s) then (ranks#"L" = fmIntAfter("rank L = ([0-9]+)", s); mode = "K");
            if match("rank \\[L_P1; L_P2\\] = [0-9]+", s) then ranks#"L12" = fmIntAfter("rank \\[L_P1; L_P2\\] = ([0-9]+)", s);
            if match("Lambda = ", s) then (
                need();
                pendingFunctional = fmParseFunctional(substring((regex("Lambda = ", s))#0#0 + 9, s), S, info);
                mode = "Lambda");
            return);
        if mode == "c" and match("^c_[0-9]+\\[", s) then (
            need();
            pos := regex("^c_([0-9]+)\\[(.*)\\] *= *(.*)$", s);
            if value substring(pos#1, s) != obsOrder then error "fermatReadCertificate: inconsistent order in a line c_N[Q] = ...";
            claimedC#(fmParseMonomial(substring(pos#2, s), S, info)) = fmParseNumber(substring(pos#3, s), info);
            return);
        if mode == "c" and match("^\\(all other", s) then return;
        if mode == "K" and match("^K *=", s) then (
            need();
            two := fmSplitTop(s, ";");
            if #two != 2 then error("fermatReadCertificate: cannot read the line '" | s | "'");
            functionals = append(functionals, {
                fmParseFunctional(substring(1 + (regex("=", two#0))#0#0, two#0), S, info),
                fmParseNumber(substring(1 + (regex("=", two#1))#0#0, two#1), info)});
            return);
        if mode == "Lambda" and match("Lambda\\.c_[0-9]+ *=", s) then (
            pos2 := regex("Lambda\\.c_[0-9]+ *= *([^ ]*)", s);
            functionals = append(functionals, {pendingFunctional, fmParseNumber(substring(pos2#1, s), info)});
            pendingFunctional = null; mode = "";
            return);
        if mode == "P" and match(" : ", s) then (
            two2 := fmSplitTop(s, ":");
            listedP = listedP + fmParseNumber(two2#1, info) * fmParseMonomial(two2#0, S, info);
            return);
        ignored = append(ignored, s)));
    need();
    nsp := #(keys spaces);
    if nsp == 0 then error "fermatReadCertificate: no linear space (line 'P1: ...') found";
    if sort keys spaces != toList(1..nsp) then error "fermatReadCertificate: the linear spaces must be numbered P1, P2, ...";
    spaceList := apply(toList(1..nsp), i -> spaces#i);
    K := info#"K";
    coeffs := if delta =!= null then apply(toList(1..nsp), i -> sum(select(delta, t -> t#0 == i), t -> t#1) + 0_K)
              else if nsp == 2 and lam =!= null then {1_K, lam}
              else if nsp == 1 then {1_K}
              else error "fermatReadCertificate: the class is not specified (need 'lambda = ...' with two spaces, or 'delta = [c1]*P1 + ...')";
    Ps := apply(spaceList, L -> fermatPeriodPolynomial(S, L));
    P := sum(nsp, i -> coeffs#i * Ps#i);
    nT := if #(keys arc) == 0 then 0 else max keys arc;
    new HashTable from {
        "file" => file, "label" => fmLabel info, "ring" => S, "degree" => d, "dimension" => NV - 2,
        "spaces" => spaceList, "coefficients" => coeffs, "lambda" => lam,
        "periodPolynomial" => P, "listedPeriodPolynomial" => listedP,
        "arc" => apply(toList(1..nT), j -> if arc#?j then arc#j else 0_S),
        "forms" => forms, "vanishingOrder" => vanish,
        "obstructionOrder" => obsOrder,
        "obstructionCoefficients" => if obsOrder === null then null else new HashTable from claimedC,
        "functionals" => functionals,
        "claimedRanks" => new HashTable from ranks,
        "extra" => new HashTable from extra,
        "ignoredLines" => ignored})

-- writing
fmNumStr = (c, info) -> (
    K := info#"K";
    if info#"p" > 0 then return toString lift(c, ZZ);
    A := info#"A";
    f := lift(c, A);
    if f == 0 then return "0";
    cs := apply(toList(0..first degree f), e -> coefficient((A_0)^e, f));
    if all(drop(cs, 1), a -> a == 0) then return toString(cs#0);
    pieces := {};
    for e from 0 to #cs-1 do if cs#e != 0 then
        pieces = append(pieces, "(" | toString(cs#e) | ")" | (if e == 0 then "" else if e == 1 then "*z" else "*z^" | toString e));
    demark("+", pieces))

fmMonStr = (e) -> (
    fs := select(apply(#e, i -> if e#i == 0 then null else if e#i == 1 then "x" | toString i else "x" | toString i | "^" | toString(e#i)), a -> a =!= null);
    if #fs == 0 then "1" else demark("*", fs))

fmPolyStr = (f, S, info) -> (
    if f == 0 then return "0";
    m := info#"nv";
    (M, C) := coefficients f;
    tab := new HashTable from apply(numcols M, i -> take(first exponents M_(0,i), m) => lift(C_(i,0), info#"K"));
    demark(" + ", apply(rsort keys tab, e -> "[" | fmNumStr(tab#e, info) | "]*" | fmMonStr e)))

fermatWriteCertificate = method()
fermatWriteCertificate(String, HashTable) := (file, D) -> (
    scan({"ring", "spaces", "coefficients", "arc"}, k -> if not D#?k then error("fermatWriteCertificate: the key \"" | k | "\" is missing"));
    S := D#"ring"; info := fmInfo S;
    if info#"np" > 0 then error "fermatWriteCertificate: not available in a fermatRing with Parameters";
    d := info#"d"; m := info#"nv"; K := info#"K";
    spaces := D#"spaces"; scan(spaces, L -> fmCheckSpace(S, L));
    cs := apply(D#"coefficients", c -> if instance(c, ZZ) or instance(c, QQ) then fmToK(c, info) else if ring c === K then c else lift(c, K));
    if #cs != #spaces then error "fermatWriteCertificate: as many coefficients as linear spaces are needed";
    arc := fmCheckArc(S, info, D#"arc", "fermatWriteCertificate");
    forms := if D#?"forms" and D#"forms" =!= null then D#"forms" else fermatPeriodForms S;
    fexps := apply(forms, Q -> fmMonExp(S, info, Q, "forms"));
    out := "# HodgeLociCI certificate; Fermat hypersurface of degree d in P^(NV-1); z = zeta_" | toString(2*d)
        | " (a primitive " | toString(2*d) | "-th root of unity); coefficients written (a0)+(a1)*z+(a2)*z^2+... with rational a_i\n";
    if info#"p" > 0 then out = out | "# MOD p: coefficients are residues modulo the prime below; z = " | toString lift(info#"z", ZZ) | "\n";
    out = out | "d = " | toString d | "\nNV = " | toString m | "\n";
    if info#"p" > 0 then out = out | "prime = " | toString(info#"p") | "\n";
    scan(#spaces, i -> out = out | "P" | toString(i+1) | ": " | demark(", ", apply(spaces#i, t ->
        "x" | toString(t#0) | " = z^" | toString(t#2) | "*x" | toString(t#1))) | "\n");
    out = out | "delta = " | demark(" + ", apply(#cs, i -> "[" | fmNumStr(cs#i, info) | "]*P" | toString(i+1))) | "\n";
    out = out | "forms Q (in this order): " | demark(", ", apply(fexps, fmMonStr)) | "\n";
    out = out | "arc: F_eps = F0 - (" | demark(" + ", apply(#arc, j -> "eps^" | toString(j+1) | "*T_" | toString(j+1))) | ")\n";
    scan(#arc, j -> out = out | "T_" | toString(j+1) | " = " | fmPolyStr(arc#j, S, info) | "\n");
    M := if D#?"vanishingOrder" and D#"vanishingOrder" =!= null then D#"vanishingOrder" else #arc;
    out = out | "claim 1: the coefficient of eps^k in Phi_Q(F_eps) is 0 for every Q and k = 1.." | toString M | "\n";
    if D#?"obstructionOrder" and D#"obstructionOrder" =!= null then (
        N := D#"obstructionOrder";
        out = out | "claim 2: the coefficients of eps^" | toString N | " are\n";
        cN := D#"obstructionCoefficients";
        scan(#forms, i -> if cN#?(forms#i) then out = out | "  c_" | toString N | "[" | fmMonStr(fexps#i) | "] = " | fmNumStr(cN#(forms#i), info) | "\n");
        out = out | "  (all other c_" | toString N | "[Q] are 0)\n";
        if D#?"functionals" and #(D#"functionals") > 0 then (
            out = out | "claim 3: this vector is NOT in the image of the first-order map L (rank L = " | toString fmRank fermatFirstOrderMatrix(sum(#cs, i -> cs#i * fermatPeriodPolynomial(S, spaces#i)), Forms => forms)
                | "); left-kernel vectors K of L (K.L = 0) and the values K.c_" | toString N | ":\n";
            scan(D#"functionals", fn -> out = out | "  K = " | demark(" + ", apply(fn#0, t ->
                "[" | fmNumStr(t#1, info) | "]*(" | fmMonStr(fmMonExp(S, info, t#0, "functionals")) | ")^dual")) | "   ;   K.c_" | toString N | " = " | fmNumStr(fn#1, info) | "\n")));
    file << out << close;
    file)

-- verification of every checkable claim
fermatVerifyCertificate = method(Options => {Prime => 0})
fermatVerifyCertificate(String) := opts -> file -> fermatVerifyCertificate(fermatReadCertificate(file, Prime => opts.Prime))
fermatVerifyCertificate(HashTable) := opts -> D -> (
    scan({"ring", "periodPolynomial", "arc"}, k -> if not D#?k then error("fermatVerifyCertificate: the key \"" | k | "\" is missing"));
    S := D#"ring"; info := fmInfo S; K := info#"K";
    P := D#"periodPolynomial"; pd := fmPdata P;
    fmNeedField(pd, "fermatVerifyCertificate");
    arc := fmCheckArc(S, info, D#"arc", "fermatVerifyCertificate");
    get := k -> if D#?k then D#k else null;
    checks := {}; firstBad := null;
    add := (name, ok) -> checks = append(checks, {name, ok});
    if get "listedPeriodPolynomial" =!= null then add("the listed period polynomial equals sum c_i P_(L_i)", D#"listedPeriodPolynomial" == P);
    std := fermatPeriodForms S;
    forms := if get "forms" =!= null then D#"forms" else std;
    if get "forms" =!= null then add("the listed forms Q are the standard forms (as a set)", set forms === set std);
    (fexps, consts) := fmFormData(S, info, forms);
    M := if get "vanishingOrder" =!= null then D#"vanishingOrder" else #arc;
    N := get "obstructionOrder";
    if N =!= null and N != M + 1 then error "fermatVerifyCertificate: the obstruction order must be the vanishing order plus one";
    if #arc > M then add("no term T_j with j beyond the claimed vanishing order " | toString M, all(drop(arc, M), T -> T == 0));
    top := if N === null then M else N;
    cols := fmSeries(pd, arc, top, fexps, consts);
    bad := fmFirstNonzero take(cols, M);
    add("the coefficients of eps^1..eps^" | toString M | " vanish for all " | toString(#forms) | " forms", bad === null);
    if bad =!= null then firstBad = bad;
    mons := fermatDeformationMonomials S;
    mexps := apply(mons, a -> fmMonExp(S, info, a, "Monomials"));
    L := fmLmatrix(pd, fexps, consts, mexps);
    vecOf := T -> matrix(K, apply(mons, a -> {lift(coefficient(a, T), K)}));
    if #arc > 0 and arc#0 != 0 then (
        inSpan := arc#0 == (matrix{mons} * promote(vecOf(arc#0), S))_(0,0);
        if inSpan then (
            add("T_1 is in the kernel of the first-order map L (tangent to the Hodge locus)", L * vecOf(arc#0) == 0);
            if D#?"spaces" and #(D#"spaces") >= 2 then (
                L1 := fmLmatrix(fmPdata fermatPeriodPolynomial(S, D#"spaces"#0), fexps, consts, mexps);
                add("T_1 is not in the kernel of L_P1 (not tangent to the locus where the first space persists)", L1 * vecOf(arc#0) != 0))));
    cr := get "claimedRanks";
    if cr =!= null and cr#?"L" then add("rank L = " | toString(cr#"L"), fmRank L == cr#"L");
    if cr =!= null and cr#?"L12" and D#?"spaces" and #(D#"spaces") == 2 then (
        La := fmLmatrix(fmPdata fermatPeriodPolynomial(S, D#"spaces"#0), fexps, consts, mexps);
        Lb := fmLmatrix(fmPdata fermatPeriodPolynomial(S, D#"spaces"#1), fexps, consts, mexps);
        add("rank [L_P1; L_P2] = " | toString(cr#"L12"), fmRank(La || Lb) == cr#"L12"));
    if N =!= null then (
        cN := last cols;
        claimed := D#"obstructionCoefficients";
        okc := all(#forms, i -> cN#i == (if claimed#?(forms#i) then claimed#(forms#i) else 0_K))
               and isSubset(keys claimed, forms);
        add("the coefficients of eps^" | toString N | " are as listed", okc);
        cNm := matrix(K, apply(cN, c -> {c}));
        add("the vector of coefficients of eps^" | toString N | " is not in the image of L", fmRank(L | cNm) > fmRank L);
        pos := new HashTable from apply(#forms, i -> forms#i => i);
        scan(#(get "functionals"), a -> (
            fn := (D#"functionals")#a;
            row := new MutableList from toList(#forms : 0_K);
            scan(fn#0, t -> (
                if not pos#?(t#0) then error "fermatVerifyCertificate: a functional uses a form that is not in the list of forms";
                row#(pos#(t#0)) = row#(pos#(t#0)) + t#1));
            Kr := matrix(K, {toList row});
            val := (Kr * cNm)_(0,0);
            add("functional " | toString(a+1) | ": K.L = 0", Kr * L == 0);
            add("functional " | toString(a+1) | ": K.c_" | toString N | " is as listed and nonzero", val == fn#1 and val != 0)));
        if firstBad === null and not all(select(checks, c -> match("eps\\^" | toString N, c#0) or match("^functional", c#0)), c -> c#1) then firstBad = N);
    new HashTable from {
        "pass" => all(checks, c -> c#1),
        "firstFailingOrder" => firstBad,
        "checks" => checks,
        "label" => fmLabel info,
        "vanishingOrder" => M, "obstructionOrder" => N,
        "ignoredLines" => if D#?"ignoredLines" then #(D#"ignoredLines") else 0})
