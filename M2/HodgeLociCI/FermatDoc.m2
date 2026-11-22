-- HodgeLociCI/FermatDoc.m2  (owner: agent PB)
-- Documentation nodes of item 3 (Fermat-point higher-order expansion); loaded after beginDocumentation().

doc ///
  Key
    "Fermat higher-order expansion"
  Headline
    conventions, status labels, scope and measured performance of the Fermat-point functions
  Description
    Text
      {\bf Status.} Written by an AI agent; not reviewed by a human. Nothing here is, or bears on, a proof
      or disproof of the Hodge conjecture. The functions re-implement, in Macaulay2, the method used in the
      session's order-5, order-7 and order-9 computations at Fermat cubics (Python scripts
      {\tt cert.py}, {\tt certlib.py}, {\tt fo.py}, {\tt fog.py}, {\tt flc.py}); no new mathematics.
    Text
      {\bf Setting.} The Fermat variety of degree d and even dimension n is given by
      F0 = x_0^d + ... + x_{n+1}^d. The ring is made by @TO fermatRing@; z denotes the fixed primitive
      2d-th root of unity (@TO fermatRoot@). A linear space of dimension n/2 in the Fermat variety is
      written as a list of triples, one for each pair of a perfect matching of the indices:
    Pre
      L = {{a_1,b_1,e_1}, ..., {a_m,b_m,e_m}}     means     x_(a_j) = z^(e_j) x_(b_j),   e_j odd,   m = n/2 + 1.
    Text
      A class delta = sum c_i [L_i] is represented by its {\bf period polynomial}
      P_delta = sum c_i P_(L_i) (@TO fermatPeriodPolynomial@), an element of the ring, so that
      combinations are formed with ordinary ring arithmetic.
    Pre
      P_L = sign(a_1,b_1,...,a_m,b_m) * prod_j  d c_j ( sum_{r=0}^{d-2} c_j^r x_(a_j)^(d-2-r) x_(b_j)^r ),     c_j = z^(e_j).
    Text
      {\bf The period functional} (@TO fermatPeriod@), for an exponent vector g with g_j = d m_j + r_j,
      0 <= r_j <= d-1:
    Pre
      Psi_P(x^g) = prod_j ((1+r_j)/d)_(m_j) * [coefficient of x^((d-2,...,d-2) - r) in P]    if all r_j <= d-2,
      Psi_P(x^g) = 0                                                                         otherwise,
    Text
      where (a)_m = a(a+1)...(a+m-1). This is the closed form of the pole-order (Griffiths-Dwork) reduction
      at the Fermat point (@TO fermatPeriodGD@ performs the reduction literally). The period functions whose
      vanishing defines the Hodge locus of delta are, for a monomial Q of degree dk - (n+2) and a form T of
      degree d,
    Pre
      Phi_Q(F0 - T) = int_delta Res( Q Omega / (F0 - T)^k ) = sum_{m >= 0} binomial(k-1+m, m) I(Q T^m, k+m)
                    = ((n/2)! / (k-1)!) * Psi_P( Q exp(T) ),
    Text
      up to one nonzero constant that is the same for all Q and all classes. Along an arc
      T = eps T_1 + eps^2 T_2 + ... the coefficient of eps^n is called c_n[Q] (@TO fermatExpansion@).
      For d = 3 these are exactly the rules (1)-(5) of the session's README for its exported certificates,
      which is shipped in the repository as {\tt tests/data/fermat/README_export_c3.txt}.
      For the quartic sixfold the session's {\tt flc.py} writes the deformation as F0 + G (so T = -G here)
      and uses the period polynomial of a linear space without the constant factor prod d c_j; the values of
      the functional on monomials are the same (test F3).
    Text
      {\bf Status labels.}
      {\bf EXACT}: computed in exact arithmetic over QQ(zeta_2d) (rings made by {\tt fermatRing(d,n)}).
      {\bf MOD p}: computed in ZZ/p for one prime p = 1 mod 2d (rings made by {\tt fermatRing(d,n,p)});
      a nonzero value mod p proves that the exact value is nonzero, a zero value mod p is evidence only.
      Every result table carries the key {\tt "label"}. It states the arithmetic first ("EXACT over
      QQ(zeta_2d)" or "MOD p = ...", the latter marked as evidence, not a proof) and then the status
      COMPUTED ONLY, with the two assumptions named below (the period formula for linear spaces and
      Griffiths' pole-order description of the Hodge locus).
      {\bf ASSUMED from the literature, not re-derived here}: Griffiths' description of the Hodge locus by
      the period functions; the Griffiths-Dwork reduction; the formula for the periods of a linear space in a
      Fermat variety (Movasati and Villaflor Loyola, arXiv:1705.00084) in the normalisation P_L = det Jac
      (Villaflor Loyola, arXiv:1812.03964). The papers were not re-read for this package; the formulas are
      those recorded in the session's READMEs.
      {\bf COMPUTED ONLY}: every statement about a particular arc, obstruction or dimension that these
      functions return. {\bf PROVED} is not claimed for anything in this part of the package.
    Text
      {\bf Scope.} The code is written for any d >= 2 and even n, but the session used, and the tests cover,
      only cubic sixfolds (d,n) = (3,6), cubic eightfolds (3,8) and the quartic sixfold (4,6), plus the
      small cases (3,4) and (4,2) for dimension counts.
      Not implemented: the dense mod-p engine of the session for generic (non-sparse) arcs
      ({\tt night/fermat_order/fo.py}, {\tt fog.py}, numpy), elementary-divisor (Smith) computations over
      power series (round 4 of the session), and symbolic lambda.
    Text
      {\bf Measured performance} (Macaulay2 1.22, one core of a shared 2-core machine, 22 Nov 2026; wall
      clock; exact = over QQ(zeta_2d)). The cost is governed by the number of monomials of
      exp(eps T_1 + eps^2 T_2 + ...) modulo eps^(N+1), hence by the sparsity of the arc.
    Pre
      cubic sixfold  (8 forms),  certificates export_c3 cert_n6_* (order 5):          0.2 s exact
      cubic eightfold (45 forms), certificates export_c3 cert_n8_* (order 4):         0.5 s exact
      cubic eightfold, export_x1 x1_lam2_obstruction (order 5):                       1.2 s exact
      cubic eightfold, export_x1 x1_lam-1_arc (7 terms, order 7):                     6 s exact,   1.2 s mod p
      cubic eightfold, export_x1 six_lam*_arc (9 sparse terms, order 9):              2.2 s exact, 1.4 s mod p
      cubic eightfold, the arc x1_lam-1 expanded further (orders 8, 9, 10):           16-20 s, 32-41 s, 63 s exact;
                                                                                      order 9: 3-4 s, order 12: 16 s mod p
      cubic sixfold, lambda = 1, a 7-term T_1 extended to order 9 (fermatExtendArc):  4.3 s exact
      cubic sixfold, DENSE T_1 (all 56 squarefree cubics), expansion mod p:           order 4: 2.4 s, 5: 10 s, 6: 27 s
      quartic sixfold (267 forms, 266 monomials): first-order matrix and kernel:      2-3 s
      quartic sixfold, an 8-term T_1 extended to order 5:                             8 s mod p, 23 s exact over QQ(zeta_8)
    Text
      So orders 7 to 9 are practical in Macaulay2 for the sparse arcs of the session, in exact arithmetic,
      and no Python backend is needed for them. Dense generic directions are practical only to order 5 or 6
      (cubic sixfold, mod p) and were not attempted on eightfolds; for those the session used its numpy
      engine, which is not part of this package. In exact arithmetic a dense direction is out of reach: the
      extension of a combination of all 49 kernel vectors on the cubic sixfold was stopped after about 2.5
      minutes (0.77 GB) without having completed order 5.
      Memory: the TEST blocks, which include the order-7 and order-9 arcs above, run within the 400 MB heap
      limit that Macaulay2's check imposes; the larger runs of the table were not measured individually.
    Text
      {\bf Caveats.} (1) In characteristic p the Pochhammer factors are reduced mod p; results agree with the
      reduction of the exact ones as long as p does not divide a denominator of the input and p exceeds
      d times (the order N plus the pole order); the functions refuse N >= p. (2) Solutions chosen by
      @TO fermatExtendArc@ are particular solutions; whether an arc is obstructed at a later order can depend
      on these choices. (3) Linear algebra over QQ(zeta_2d) is done by the package's own row reduction,
      because {\tt kernel} over a field made by {\tt toField} can return a non-minimal generating set.
  Subnodes
    :Rings, linear spaces, periods
    fermatRing
    fermatRoot
    fermatLinearSpaceIdeal
    fermatPeriodPolynomial
    fermatPeriod
    fermatPeriodGD
    :The Hodge-locus equations and their expansion along an arc
    fermatPeriodForms
    fermatDeformationMonomials
    fermatExpansion
    fermatVerifyArc
    fermatNextOrderSystem
    fermatExtendArc
    :First order at the Fermat point
    fermatFirstOrderMatrix
    fermatHodgeTangent
    fermatPersistenceTangent
    fermatTangentData
    :Certificate files
    fermatReadCertificate
    fermatWriteCertificate
    fermatVerifyCertificate
    :Options
    Parameters
    Forms
    AllMonomials
    Prime
///

doc ///
  Key
    fermatRing
    (fermatRing, ZZ, ZZ)
    (fermatRing, ZZ, ZZ, ZZ)
    [fermatRing, Parameters]
    [fermatRing, Variable]
  Headline
    polynomial ring of the Fermat variety of degree d and even dimension n, over QQ(zeta_2d) or ZZ/p
  Usage
    S = fermatRing(d, n)
    S = fermatRing(d, n, p)
  Inputs
    d:ZZ
      the degree, at least 2
    n:ZZ
      the dimension of the Fermat variety, even
    p:ZZ
      optional: a prime with p = 1 mod 2d; then the computations are MOD p
    Parameters=>List
      symbols of extra variables of degree 0, used as undetermined coefficients of an arc
    Variable=>Symbol
      the name of the variables x_0, ..., x_(n+1) (a symbol or a string)
  Outputs
    S:PolynomialRing
      K[x_0..x_(n+1)] with K = QQ(zeta_2d) (EXACT) or K = ZZ/p (MOD p), remembering d, n and the root z
  Description
    Text
      Over QQ the coefficient field is QQ[z]/(the 2d-th cyclotomic polynomial); for d = 3 this is
      z^2 - z + 1, the convention of the session's certificate files. Over ZZ/p the root is
      z = g^((p-1)/2d) for the smallest g >= 2 for which this is a primitive 2d-th root of unity (the rule
      of the session's Python engines).
    Example
      S = fermatRing(3, 6)
      z = fermatRoot S
      z^2 - z + 1
      Sp = fermatRing(3, 6, 32749);
      fermatRoot Sp
      St = fermatRing(3, 6, Parameters => {symbol s, symbol t});
      numgens St
    Text
      {\bf Labels.} EXACT for {\tt fermatRing(d,n)}; MOD p for {\tt fermatRing(d,n,p)}.
    Text
      As for any polynomial ring created in Macaulay2, the ring is put in use: the symbols x_0, ..., x_(n+1)
      and the parameters get these ring elements as values. The root of unity is {\bf not} assigned to a
      symbol: obtain it with {\tt z = fermatRoot S}, as in the example (over ZZ/p it is a number, an element
      of ZZ/p, and there is no variable z).
  Caveat
    With Parameters the functions @TO fermatHodgeTangent@, @TO fermatPersistenceTangent@,
    @TO fermatTangentData@, @TO fermatVerifyCertificate@ and @TO fermatWriteCertificate@ are not available.
  SeeAlso
    "Fermat higher-order expansion"
    fermatRoot
///

doc ///
  Key
    fermatRoot
    (fermatRoot, Ring)
  Headline
    the fixed primitive 2d-th root of unity of a fermatRing
  Usage
    z = fermatRoot S
  Inputs
    S:Ring
      made by @TO fermatRing@
  Outputs
    z:RingElement
      an element of the coefficient field of S, a primitive 2d-th root of unity
  Description
    Example
      S = fermatRing(4, 6);
      z = fermatRoot S
      z^4
      fermatRoot fermatRing(4, 6, 30089)
    Text
      {\bf Labels.} EXACT over QQ(zeta_2d); MOD p in characteristic p (there the value 14004 for p = 30089,
      d = 4 is the root used by the session's {\tt flc.py}).
  SeeAlso
    fermatRing
///

doc ///
  Key
    fermatLinearSpaceIdeal
    (fermatLinearSpaceIdeal, Ring, List)
  Headline
    ideal of a linear space contained in the Fermat variety
  Usage
    I = fermatLinearSpaceIdeal(S, L)
  Inputs
    S:Ring
      made by @TO fermatRing@
    L:List
      of n/2+1 triples of integers {a,b,e}, meaning x_a = z^e x_b; the pairs {a,b} must form a perfect
      matching of 0..n+1 and every e must be odd
  Outputs
    I:Ideal
      generated by the linear forms x_a - z^e x_b
  Description
    Text
      Since z^e is a d-th root of -1, the linear space lies in the Fermat variety: the example checks it.
    Example
      S = fermatRing(3, 6);
      L = {{0,1,1},{2,3,1},{4,5,3},{6,7,5}};
      I = fermatLinearSpaceIdeal(S, L)
      F0 = sum(8, i -> S_i^3);
      F0 % I == 0
    Text
      {\bf Labels.} EXACT (or MOD p, according to the ring). The inclusion in the Fermat variety is elementary.
  SeeAlso
    fermatPeriodPolynomial
    fermatPersistenceTangent
///

doc ///
  Key
    fermatPeriodPolynomial
    (fermatPeriodPolynomial, Ring, List)
  Headline
    period polynomial of a linear space in the Fermat variety
  Usage
    P = fermatPeriodPolynomial(S, L)
  Inputs
    S:Ring
      made by @TO fermatRing@
    L:List
      a linear space, as in @TO fermatLinearSpaceIdeal@
  Outputs
    P:RingElement
      homogeneous of degree (d-2)(n/2+1) with all exponents at most d-2
  Description
    Text
      The polynomial is
    Pre
      P_L = sign(a_1,b_1,...,a_m,b_m) * prod_j  d c_j ( sum_{r=0}^{d-2} c_j^r x_(a_j)^(d-2-r) x_(b_j)^r ),   c_j = z^(e_j),
    Text
      which equals the determinant of the Jacobian matrix of (f_1,g_1,...,f_m,g_m), where F0 = sum f_j g_j
      and f_j = x_(a_j) - c_j x_(b_j). The period of the class [L] on the form
      x^R Omega / F0^(n/2+1) is the coefficient of the complementary monomial in P_L, up to one constant
      that does not depend on L; classes are added by adding their period polynomials. For d = 3 this is
      rule (1) of the session's README, shipped as {\tt tests/data/fermat/README_export_c3.txt}.
    Example
      S = fermatRing(3, 6); z = fermatRoot S;
      L1 = {{0,1,1},{2,3,1},{4,5,1},{6,7,1}};
      P1 = fermatPeriodPolynomial(S, L1);
      fg = flatten apply(L1, t -> (f := S_(t#0) - z^(t#2)*S_(t#1); {f, (S_(t#0)^3 + S_(t#1)^3) // f}));
      P1 == det jacobian matrix {fg}
    Text
      The d linear spaces of a pencil (only the first root varies) add up to a complete intersection with
      the Fermat variety, whose primitive periods vanish; accordingly the period polynomials add up to 0.
      This tests the relative normalisation of different spaces.
    Example
      sum({1,3,5}, e -> fermatPeriodPolynomial(S, {{0,1,e},{2,3,1},{4,5,1},{6,7,1}})) == 0
    Text
      {\bf Labels.} The polynomial is EXACT (or MOD p). That its coefficients are the periods is ASSUMED from
      the literature (Movasati and Villaflor Loyola, arXiv:1705.00084; Villaflor Loyola, arXiv:1812.03964),
      not re-derived here. The two identities of the examples are COMPUTED (tests: d = 3, 4).
  SeeAlso
    fermatPeriod
    "Fermat higher-order expansion"
///

doc ///
  Key
    fermatPeriod
    (fermatPeriod, RingElement, RingElement)
    (fermatPeriod, RingElement, ZZ)
  Headline
    the period functional of a class at the Fermat point, in closed form, on a polynomial
  Usage
    v = fermatPeriod(P, f)
  Inputs
    P:RingElement
      a period polynomial (see @TO fermatPeriodPolynomial@), or a linear combination of such
    f:RingElement
      any polynomial of the same ring
  Outputs
    v:RingElement
      Psi_P(f), in the coefficient field (in the ring itself if it has Parameters)
  Description
    Text
      Psi_P is linear, and on a monomial with exponents g_j = d m_j + r_j it is
      prod_j ((1+r_j)/d)_(m_j) times the coefficient of x^((d-2,..,d-2)-r) in P (zero if some r_j = d-1).
      It is computed by reducing one variable at a time, so large polynomials f are handled at engine speed.
      The literal pole-order reduction @TO fermatPeriodGD@ gives the same numbers up to the factor
      (n/2)!/(k-1)! of the pole order k.
    Example
      S = fermatRing(3, 6); z = fermatRoot S; use S;
      P = fermatPeriodPolynomial(S, {{0,1,1},{2,3,1},{4,5,1},{6,7,1}}) + 2*fermatPeriodPolynomial(S, {{0,1,3},{2,3,3},{4,5,3},{6,7,1}});
      m = x_1^4*x_2*x_5*x_6*x_7^3;
      fermatPeriod(P, m)
      fermatPeriodGD(P, m, 6)
      fermatPeriod(P, m) == (5!/3!) * fermatPeriodGD(P, m, 6)
    Text
      The value -18+36z is the one obtained by the blind checker's independent code
      ({\tt discovery/checks/c3/lib.py}) for this monomial.
    Text
      {\bf Labels.} EXACT (or MOD p). That Psi_P computes periods is ASSUMED (see
      @TO "Fermat higher-order expansion"@); the agreement of the closed form with the literal reduction is
      COMPUTED in the tests (it follows from (a)_m = (a+m-1)(a)_(m-1)).
  SeeAlso
    fermatPeriodGD
    fermatExpansion
///

doc ///
  Key
    fermatPeriodGD
    (fermatPeriodGD, RingElement, RingElement, ZZ)
    [fermatPeriodGD, Strategy]
  Headline
    literal Griffiths-Dwork (pole-order) reduction at the Fermat point, monomial by monomial
  Usage
    v = fermatPeriodGD(P, f, k)
  Inputs
    P:RingElement
      a period polynomial
    f:RingElement
      homogeneous of degree d*k - (n+2)
    k:ZZ
      the pole order
    Strategy=>String
      "First" or "Last": which exponent >= d-1 is reduced first (the result must not depend on it)
  Outputs
    v:RingElement
      I(f, k), the period of f Omega / F0^k on the class with period polynomial P
  Description
    Text
      Reference implementation of rules (2) and (3) of {\tt tests/data/fermat/README_export_c3.txt}, for any d:
    Pre
      I(x^b, k) = ((b_j - (d-1)) / (d (k-1))) * I(x^(b - d e_j), k-1)       if b_j >= d-1,
      I(x^b, k) = coefficient of x^((d-2,..,d-2) - b) in P                   if all b_j <= d-2 and k = n/2+1,
      I(x^b, k) = 0                                                          if all b_j <= d-2 and k != n/2+1.
    Text
      It is slow and meant for cross-checking @TO fermatPeriod@, which satisfies
      fermatPeriod(P,f) = ((k-1)!/(n/2)!) * fermatPeriodGD(P,f,k) for k >= n/2+1.
    Example
      S = fermatRing(3, 6); z = fermatRoot S; use S;
      P = fermatPeriodPolynomial(S, {{0,1,1},{2,3,1},{4,5,1},{6,7,1}}) + 2*fermatPeriodPolynomial(S, {{0,1,3},{2,3,3},{4,5,3},{6,7,1}});
      m = x_1*x_3*x_5^4*x_7;
      fermatPeriodGD(P, m, 5)
      fermatPeriodGD(P, m, 5, Strategy => "Last")
    Text
      The value -(81/2)z is the one obtained by the blind checker's independent code
      ({\tt discovery/checks/c3/lib.py}, {\tt Periods.I}).
    Text
      {\bf Labels.} EXACT (or MOD p); the reduction rule itself is ASSUMED (Griffiths-Dwork).
  SeeAlso
    fermatPeriod
///

doc ///
  Key
    fermatPeriodForms
    (fermatPeriodForms, Ring)
    [fermatPeriodForms, AllMonomials]
  Headline
    numerators Q of the differential forms whose periods define the Hodge locus
  Usage
    forms = fermatPeriodForms S
  Inputs
    S:Ring
      made by @TO fermatRing@
    AllMonomials=>Boolean
      if true: all monomials of degree d*(n/2) - (n+2) (pole order n/2 only)
  Outputs
    forms:List
      of monomials
  Description
    Text
      By default: for every pole order k = 1..n/2 the monomials of degree dk - (n+2) with all exponents at
      most d-2 (a monomial basis of the Jacobian ring of F0 in that degree), by increasing k and in
      decreasing lexicographic order. For cubic sixfolds these are x_0..x_7, for cubic eightfolds the 45
      squarefree quadrics, as in the session. With AllMonomials => true the list consists of all monomials
      of the top pole order (the convention of the session's {\tt flc.py} for the quartic sixfold); both
      lists span the same Hodge filtration piece near the Fermat point, so the vanishing order of the
      period functions along an arc is the same for both (COMPUTED in the tests for the quartic sixfold).
    Example
      fermatPeriodForms fermatRing(3, 6)
      #fermatPeriodForms fermatRing(3, 8)
      S = fermatRing(4, 6);
      #fermatPeriodForms S
      #fermatPeriodForms(S, AllMonomials => true)
    Text
      {\bf Labels.} Combinatorial, EXACT. That these forms cut out the Hodge locus is ASSUMED (Griffiths).
  SeeAlso
    fermatDeformationMonomials
    fermatExpansion
///

doc ///
  Key
    fermatDeformationMonomials
    (fermatDeformationMonomials, Ring)
    [fermatDeformationMonomials, AllMonomials]
  Headline
    monomials of degree d spanning the deformations F0 - T
  Usage
    mons = fermatDeformationMonomials S
  Inputs
    S:Ring
      made by @TO fermatRing@
    AllMonomials=>Boolean
      if true: all monomials of degree d
  Outputs
    mons:List
      by default the monomials of degree d with all exponents at most d-2, in decreasing lexicographic order
  Description
    Text
      The default list is a monomial basis of the degree-d part of the Jacobian ring of F0; the remaining
      monomials of degree d lie in the Jacobian ideal and in the kernel of the first-order map
      (@TO fermatFirstOrderMatrix@). For d = 3 the default list consists of the squarefree cubics, in the
      order of the session's files.
    Example
      S = fermatRing(3, 6);
      #fermatDeformationMonomials S
      #fermatDeformationMonomials(S, AllMonomials => true)
      take(fermatDeformationMonomials S, 3)
    Text
      {\bf Labels.} Combinatorial, EXACT.
  SeeAlso
    fermatPeriodForms
    fermatFirstOrderMatrix
///

doc ///
  Key
    fermatExpansion
    (fermatExpansion, RingElement, List, ZZ)
    [fermatExpansion, Forms]
  Headline
    Taylor coefficients of the Hodge-locus equations along an arc through the Fermat point
  Usage
    C = fermatExpansion(P, Ts, N)
  Inputs
    P:RingElement
      the period polynomial of the class
    Ts:List
      the arc {T_1, T_2, ...}: forms of degree d (0 allowed); F_eps = F0 - (eps T_1 + eps^2 T_2 + ...)
    N:ZZ
      the order, at least 1
    Forms=>List
      numerators Q (monomials of degree d*k - (n+2) for an integer k >= 1); default @TO fermatPeriodForms@
  Outputs
    C:Matrix
      with one row for each form Q and N columns: the entry (Q, n) is c_n[Q], the coefficient of eps^n in
      Phi_Q(F_eps) = ((n/2)!/(k-1)!) Psi_P(Q exp(eps T_1 + eps^2 T_2 + ...))
  Description
    Text
      The exponential series is built by the recursion n E_n = sum_j j T_j E_(n-j), and Psi_P(Q E_n) is
      evaluated for all Q together by reducing the pole order one variable at a time. The arc is tangent to
      the Hodge locus to order N exactly when the first N columns vanish.
      The example is the arc of the session certificate {\tt export_c3/cert_n6_lam2.txt} (cubic sixfold,
      delta = [P1] + 2[P2]): the coefficients of eps^1..eps^4 vanish and those of eps^5 do not.
    Example
      S = fermatRing(3, 6); z = fermatRoot S; use S;
      P = fermatPeriodPolynomial(S, {{0,1,1},{2,3,1},{4,5,1},{6,7,1}}) + 2*fermatPeriodPolynomial(S, {{0,1,3},{2,3,3},{4,5,3},{6,7,1}});
      T1 = x_0*x_1*x_7 + (1/3+(1/3)*z)*x_0*x_2*x_4 + x_0*x_2*x_5 + x_2*x_3*x_7 + x_4*x_5*x_7;
      T2 = (-1/9-(1/9)*z)*x_0*x_2*x_6 + (-5/9+(1/9)*z)*x_0*x_3*x_6 + (-1/9+(2/9)*z)*x_0*x_4*x_6 + (-2/9+(1/9)*z)*x_0*x_5*x_6 + (-1/9+(2/9)*z)*x_2*x_4*x_6 + (-2/9+(1/9)*z)*x_2*x_5*x_6;
      T4 = (-4/729-(2/729)*z)*x_0*x_2*x_4;
      C = fermatExpansion(P, {T1, T2, 0, T4}, 5)
    Text
      Forms of higher pole order are allowed; for instance the numerators of degree d(n/2+1) - (n+2) give
      the series called pi_eps in round 4 of the session.
    Example
      fermatExpansion(P, {T1, T2}, 2, Forms => {x_0*x_1*x_2*x_7, x_1*x_3*x_5*x_7})
    Text
      {\bf Labels.} EXACT over QQ(zeta_2d), or MOD p, according to the ring of P. The numbers are COMPUTED;
      their interpretation as Taylor coefficients of period functions is ASSUMED (see
      @TO "Fermat higher-order expansion"@). The last column of the first example reproduces claim 2 of the
      certificate file, which was also recomputed by the blind check C3 of the session.
  Caveat
    The cost grows with the number of monomials of the truncated exponential series: sparse arcs reach
    orders 9-10, dense ones only 5-6 (see the performance table in @TO "Fermat higher-order expansion"@).
  SeeAlso
    fermatVerifyArc
    fermatNextOrderSystem
    fermatFirstOrderMatrix
///

doc ///
  Key
    fermatFirstOrderMatrix
    (fermatFirstOrderMatrix, RingElement)
    [fermatFirstOrderMatrix, Forms]
    [fermatFirstOrderMatrix, Monomials]
  Headline
    the first-order map L of the Hodge-locus equations at the Fermat point
  Usage
    L = fermatFirstOrderMatrix P
  Inputs
    P:RingElement
      the period polynomial of the class
    Forms=>List
      the rows: numerators Q; default @TO fermatPeriodForms@
    Monomials=>List
      the columns: monomials of degree d; default @TO fermatDeformationMonomials@
  Outputs
    L:Matrix
      L_(Q,a) = c_1[Q] for the arc T_1 = x^a, i.e. ((n/2)!/(k-1)!) Psi_P(Q x^a)
  Description
    Text
      The kernel of L is the tangent space at the Fermat point of the Hodge locus of the class (rule (5) of
      {\tt tests/data/fermat/README_export_c3.txt} for d = 3). The example is Movasati's pair of 3-planes
      meeting in a point on the Fermat cubic sixfold: rank 7 for the combination against rank 8 for the
      locus where both planes persist.
    Example
      S = fermatRing(3, 6);
      P1 = fermatPeriodPolynomial(S, {{0,1,1},{2,3,1},{4,5,1},{6,7,1}});
      P2 = fermatPeriodPolynomial(S, {{0,1,3},{2,3,3},{4,5,3},{6,7,1}});
      L = fermatFirstOrderMatrix(P1 + 2*P2);
      (numrows L, numcols L, rank L)
      rank(fermatFirstOrderMatrix P1 || fermatFirstOrderMatrix P2)
    Text
      {\bf Labels.} EXACT (or MOD p). The ranks 7 and 8 are COMPUTED; they are the numbers of the session's
      certificate files and of Table 1 of Movasati's arXiv:1602.06607 as recorded in {\tt tests/SOURCES.md}.
  SeeAlso
    fermatHodgeTangent
    fermatTangentData
///

doc ///
  Key
    fermatHodgeTangent
    (fermatHodgeTangent, RingElement)
  Headline
    tangent space at the Fermat point of the Hodge locus of a class
  Usage
    B = fermatHodgeTangent P
  Inputs
    P:RingElement
      the period polynomial of the class
  Outputs
    B:Matrix
      with one row, whose entries are forms T of degree d forming a basis of the kernel of the first-order
      map on all forms of degree d
  Description
    Text
      The space contains the degree-d part of the Jacobian ideal of F0 (the tangent space of the orbit of
      F0); its codimension in the space of all forms of degree d is the rank of
      @TO fermatFirstOrderMatrix@. For a single linear space it coincides with the first-order
      deformations in which the space persists (@TO fermatPersistenceTangent@): the example checks it.
    Example
      S = fermatRing(3, 6);
      L1 = {{0,1,1},{2,3,1},{4,5,1},{6,7,1}};
      B = fermatHodgeTangent fermatPeriodPolynomial(S, L1);
      numcols B
      image B == image fermatPersistenceTangent(S, {L1})
    Text
      {\bf Labels.} EXACT (or MOD p); COMPUTED. Codimension 4 = 20 - 16 is the classical count for cubic
      sixfolds containing a 3-plane (cubic forms on the plane minus the dimension of the Grassmannian).
  SeeAlso
    fermatFirstOrderMatrix
    fermatPersistenceTangent
    fermatTangentData
///

doc ///
  Key
    fermatPersistenceTangent
    (fermatPersistenceTangent, Ring, List)
  Headline
    first-order deformations of the Fermat variety in which given linear spaces persist
  Usage
    B = fermatPersistenceTangent(S, spaces)
  Inputs
    S:Ring
      made by @TO fermatRing@ (without Parameters)
    spaces:List
      of linear spaces L_1, L_2, ... (see @TO fermatLinearSpaceIdeal@)
  Outputs
    B:Matrix
      with one row: a basis of the intersection over i of the degree-d parts of I(L_i) + Jac(F0)
  Description
    Text
      (I(L) + Jac(F0))_d is the image in the space of forms of degree d of the tangent space of the
      variety of pairs (hypersurface, linear space contained in it) at (F0, L). The function intersects
      these spaces by Groebner bases, without using periods, so it is an independent check of
      @TO fermatHodgeTangent@ and @TO fermatFirstOrderMatrix@.
    Example
      S = fermatRing(3, 6);
      L1 = {{0,1,1},{2,3,1},{4,5,1},{6,7,1}}; L2 = {{0,1,3},{2,3,3},{4,5,3},{6,7,1}};
      numcols fermatPersistenceTangent(S, {L1})
      numcols fermatPersistenceTangent(S, {L1, L2})
    Text
      {\bf Labels.} EXACT (or MOD p); COMPUTED. That the locus where both spaces persist is smooth at F0
      with this tangent space is ASSUMED in the session, not checked here.
  SeeAlso
    fermatHodgeTangent
    fermatTangentData
///

doc ///
  Key
    fermatTangentData
    (fermatTangentData, Ring, List, List)
  Headline
    first-order data at the Fermat point for a combination of linear spaces
  Usage
    H = fermatTangentData(S, spaces, coefficients)
  Inputs
    S:Ring
      made by @TO fermatRing@ (without Parameters)
    spaces:List
      of linear spaces L_1, ..., L_s
    coefficients:List
      of s numbers c_i (integers, rationals or elements of the coefficient field): delta = sum c_i [L_i]
  Outputs
    H:HashTable
      with string keys: "hodgeCodimension" (rank of the first-order map of delta),
      "singleHodgeCodimensions" (the same for each [L_i]), "persistenceCodimensions" (codimension of
      (I(L_i)+Jac F0)_d, by ideals), "jointPeriodCodimension" (rank of the stacked first-order maps),
      "jointPersistenceCodimension" (codimension of the intersection, by ideals), "excess" (their
      difference to "hodgeCodimension"), "ambientDimension", "label"
  Description
    Text
      All codimensions are taken in the space of all forms of degree d. The table is meant for
      cross-checks of the first-order functions of this package (item 1) at the Fermat point: the period
      computation and the ideal computation are independent. The examples are the two Movasati points of
      the session: two 3-planes meeting in a point on the cubic sixfold, and two 4-planes meeting in a
      line on the cubic eightfold.
    Example
      S = fermatRing(3, 6);
      H = fermatTangentData(S, {{{0,1,1},{2,3,1},{4,5,1},{6,7,1}}, {{0,1,3},{2,3,3},{4,5,3},{6,7,1}}}, {1, 2});
      (H#"hodgeCodimension", H#"jointPersistenceCodimension", H#"excess", H#"label")
      H#"singleHodgeCodimensions" == H#"persistenceCodimensions"
      S8 = fermatRing(3, 8);
      H8 = fermatTangentData(S8, {{{0,1,1},{2,3,1},{4,5,1},{6,7,1},{8,9,1}}, {{0,1,1},{2,3,1},{4,5,3},{6,7,3},{8,9,3}}}, {1, 2});
      (H8#"hodgeCodimension", H8#"jointPersistenceCodimension", H8#"excess")
    Text
      {\bf Labels.} EXACT (or MOD p); COMPUTED. Source of the numbers 7, 8 and 19, 20: the session's
      README, shipped as {\tt tests/data/fermat/README_export_c3.txt} ("rank L = 7 against rank [L_P1; L_P2] = 8 for NV = 8; 19 against 20 for
      NV = 10") and the pairs (H,K) of Table 1 of arXiv:1602.06607 as recorded in {\tt tests/SOURCES.md}.
  SeeAlso
    fermatFirstOrderMatrix
    fermatPersistenceTangent
///

doc ///
  Key
    fermatVerifyArc
    (fermatVerifyArc, RingElement, List)
    (fermatVerifyArc, RingElement, List, ZZ)
    [fermatVerifyArc, Forms]
  Headline
    check that the Hodge-locus equations vanish to a given order along an arc
  Usage
    H = fermatVerifyArc(P, Ts)
    H = fermatVerifyArc(P, Ts, N)
  Inputs
    P:RingElement
      the period polynomial of the class
    Ts:List
      the arc {T_1, T_2, ...}
    N:ZZ
      the order to check; default the number of terms of the arc
    Forms=>List
      numerators Q; default @TO fermatPeriodForms@
  Outputs
    H:HashTable
      with string keys "pass" (true if c_1 = ... = c_N = 0), "firstFailingOrder" (the smallest n with
      c_n != 0, or null), "order", "numberOfForms", "label"
  Description
    Text
      The computation stops at the first failing order.
    Example
      S = fermatRing(3, 6); z = fermatRoot S; use S;
      P = fermatPeriodPolynomial(S, {{0,1,1},{2,3,1},{4,5,1},{6,7,1}}) + 2*fermatPeriodPolynomial(S, {{0,1,3},{2,3,3},{4,5,3},{6,7,1}});
      T1 = x_0*x_1*x_7 + (1/3+(1/3)*z)*x_0*x_2*x_4 + x_0*x_2*x_5 + x_2*x_3*x_7 + x_4*x_5*x_7;
      T2 = (-1/9-(1/9)*z)*x_0*x_2*x_6 + (-5/9+(1/9)*z)*x_0*x_3*x_6 + (-1/9+(2/9)*z)*x_0*x_4*x_6 + (-2/9+(1/9)*z)*x_0*x_5*x_6 + (-1/9+(2/9)*z)*x_2*x_4*x_6 + (-2/9+(1/9)*z)*x_2*x_5*x_6;
      H = fermatVerifyArc(P, {T1, T2});
      (H#"pass", H#"firstFailingOrder", H#"label")
      H' = fermatVerifyArc(P, {T1, T2 + x_0*x_2*x_6});
      (H'#"pass", H'#"firstFailingOrder")
    Text
      {\bf Labels.} EXACT (or MOD p: then a failure is conclusive and a pass is evidence only); COMPUTED.
  SeeAlso
    fermatExpansion
    fermatVerifyCertificate
///

doc ///
  Key
    fermatNextOrderSystem
    (fermatNextOrderSystem, RingElement, List)
    [fermatNextOrderSystem, Forms]
    [fermatNextOrderSystem, Monomials]
  Headline
    the linear system for the next term of an arc, with its obstruction
  Usage
    H = fermatNextOrderSystem(P, Ts)
  Inputs
    P:RingElement
      the period polynomial of the class
    Ts:List
      the arc {T_1, ..., T_(N-1)}
    Forms=>List
      numerators Q; default @TO fermatPeriodForms@
    Monomials=>List
      the monomials allowed in T_N; default @TO fermatDeformationMonomials@
  Outputs
    H:HashTable
      with string keys "order" (N), "matrix" (L), "coefficient" (the column c_N computed with T_N = 0),
      "cokernel" (a matrix K whose rows form a basis of the left kernel of L), "obstruction" (K c_N),
      "solvable", "solution" (a form T_N with c_N + L T_N = 0, or null), "lowerOrdersVanish",
      "firstFailingOrder", "forms", "monomials", "label"
  Description
    Text
      The coefficient of eps^N along the arc extended by T_N is c_N + L T_N, so the arc extends to order N
      exactly when c_N lies in the image of L, i.e. when K c_N = 0. The example is the arc of
      {\tt export_c3/cert_n6_lam2.txt}: it cannot be extended to order 5.
    Example
      S = fermatRing(3, 6); z = fermatRoot S; use S;
      P = fermatPeriodPolynomial(S, {{0,1,1},{2,3,1},{4,5,1},{6,7,1}}) + 2*fermatPeriodPolynomial(S, {{0,1,3},{2,3,3},{4,5,3},{6,7,1}});
      T1 = x_0*x_1*x_7 + (1/3+(1/3)*z)*x_0*x_2*x_4 + x_0*x_2*x_5 + x_2*x_3*x_7 + x_4*x_5*x_7;
      T2 = (-1/9-(1/9)*z)*x_0*x_2*x_6 + (-5/9+(1/9)*z)*x_0*x_3*x_6 + (-1/9+(2/9)*z)*x_0*x_4*x_6 + (-2/9+(1/9)*z)*x_0*x_5*x_6 + (-1/9+(2/9)*z)*x_2*x_4*x_6 + (-2/9+(1/9)*z)*x_2*x_5*x_6;
      T4 = (-4/729-(2/729)*z)*x_0*x_2*x_4;
      H = fermatNextOrderSystem(P, {T1, T2, 0, T4});
      (H#"order", H#"lowerOrdersVanish", H#"solvable")
      H#"cokernel"
      H#"obstruction"
    Text
      {\bf Higher-order systems.} In a ring with Parameters the earlier terms may carry undetermined
      coefficients; then "coefficient" and "obstruction" are matrices of polynomials in the parameters, and
      the system L T_N = - c_N is solved for the coefficient of every monomial in the parameters, so that
      "solution" is polynomial in them ("solvable" means: the obstruction vanishes identically).
      The vanishing of the obstruction is the system for the choices made at lower orders.
      Here the term T_2 of the certificate is moved by s times w, where w is in the kernel of L;
      order 3 is solvable for every s, by a term that is linear in s.
    Example
      St = fermatRing(3, 6, Parameters => {symbol s}); zt = fermatRoot St;
      Pt = fermatPeriodPolynomial(St, {{0,1,1},{2,3,1},{4,5,1},{6,7,1}}) + 2*fermatPeriodPolynomial(St, {{0,1,3},{2,3,3},{4,5,3},{6,7,1}});
      wt = x_0*x_1*x_7 + x_2*x_3*x_7 + x_4*x_5*x_7;
      U1 = wt + (1/3+(1/3)*zt)*x_0*x_2*x_4 + x_0*x_2*x_5;
      U2 = (-1/9-(1/9)*zt)*x_0*x_2*x_6 + (-5/9+(1/9)*zt)*x_0*x_3*x_6 + (-1/9+(2/9)*zt)*x_0*x_4*x_6 + (-2/9+(1/9)*zt)*x_0*x_5*x_6 + (-1/9+(2/9)*zt)*x_2*x_4*x_6 + (-2/9+(1/9)*zt)*x_2*x_5*x_6 + s*wt;
      H3 = fermatNextOrderSystem(Pt, {U1, U2});
      (H3#"order", H3#"lowerOrdersVanish", H3#"solvable")
      H3#"solution"
    Text
      {\bf Labels.} EXACT (or MOD p); COMPUTED.
  Caveat
    The obstruction at order N depends on the earlier terms T_2, ..., T_(N-1), which are determined only up
    to the kernel of L and the constraints of the intermediate orders. A nonzero K c_N for one arc does not
    by itself show that no arc with the same T_1 exists; the session's certificates add an argument for that.
  SeeAlso
    fermatExtendArc
    fermatExpansion
///

doc ///
  Key
    fermatExtendArc
    (fermatExtendArc, RingElement, List, ZZ)
    [fermatExtendArc, Forms]
    [fermatExtendArc, Monomials]
  Headline
    extend an arc order by order until a given order or the first obstruction
  Usage
    H = fermatExtendArc(P, Ts, N)
  Inputs
    P:RingElement
      the period polynomial of the class
    Ts:List
      the given terms {T_1, ..., T_r}, which must satisfy the equations to order r
    N:ZZ
      the order to reach
    Forms=>List
      numerators Q; default @TO fermatPeriodForms@
    Monomials=>List
      the monomials allowed in the new terms; default @TO fermatDeformationMonomials@
  Outputs
    H:HashTable
      with string keys "arc" (the extended list), "order" (its length), "obstructedAtOrder" (null if order N
      was reached), "obstruction" (K c_n at the obstructed order), "label"
  Description
    Text
      At each order n > r the function solves L T_n = - c_n by row reduction and takes the solution with
      zero coordinates on the non-pivot monomials (a deterministic particular solution).
      The example starts from the first-order term of {\tt export_c3/cert_n6_lam2.txt}; it reproduces the
      obstruction at order 5 of that certificate, although the intermediate terms need not be those of the
      file.
    Example
      S = fermatRing(3, 6); z = fermatRoot S; use S;
      P = fermatPeriodPolynomial(S, {{0,1,1},{2,3,1},{4,5,1},{6,7,1}}) + 2*fermatPeriodPolynomial(S, {{0,1,3},{2,3,3},{4,5,3},{6,7,1}});
      T1 = x_0*x_1*x_7 + (1/3+(1/3)*z)*x_0*x_2*x_4 + x_0*x_2*x_5 + x_2*x_3*x_7 + x_4*x_5*x_7;
      H = fermatExtendArc(P, {T1}, 6);
      (H#"order", H#"obstructedAtOrder")
      H#"obstruction"
    Text
      In a ring with Parameters the arc is extended as long as the obstruction vanishes identically in the
      parameters; otherwise the function stops and returns the obstruction as a matrix of polynomials in the
      parameters (the system for the free choices made earlier). In the example, T_2 of the certificate is
      moved by s times an element w of the kernel of L: orders 3 and 4 are solved by terms polynomial in s,
      and the obstruction at order 5 turns out to be the constant 6z - 3, the value K.c_5 of the
      certificate; it does not depend on s.
    Example
      St = fermatRing(3, 6, Parameters => {symbol s}); zt = fermatRoot St;
      Pt = fermatPeriodPolynomial(St, {{0,1,1},{2,3,1},{4,5,1},{6,7,1}}) + 2*fermatPeriodPolynomial(St, {{0,1,3},{2,3,3},{4,5,3},{6,7,1}});
      wt = x_0*x_1*x_7 + x_2*x_3*x_7 + x_4*x_5*x_7;
      U1 = wt + (1/3+(1/3)*zt)*x_0*x_2*x_4 + x_0*x_2*x_5;
      U2 = (-1/9-(1/9)*zt)*x_0*x_2*x_6 + (-5/9+(1/9)*zt)*x_0*x_3*x_6 + (-1/9+(2/9)*zt)*x_0*x_4*x_6 + (-2/9+(1/9)*zt)*x_0*x_5*x_6 + (-1/9+(2/9)*zt)*x_2*x_4*x_6 + (-2/9+(1/9)*zt)*x_2*x_5*x_6 + s*wt;
      Et = fermatExtendArc(Pt, {U1, U2}, 6);
      (Et#"order", Et#"obstructedAtOrder")
      Et#"obstruction"
      Et#"arc"#2
    Text
      {\bf Labels.} EXACT (or MOD p); COMPUTED.
  Caveat
    Other choices of the intermediate terms can lead to a different outcome at later orders; an obstruction
    found here is an obstruction for the arc constructed, not for all arcs with the same T_1. In the same way
    the independence of s in the example is a statement about this one-parameter family of arcs only.
  SeeAlso
    fermatNextOrderSystem
    fermatVerifyArc
///

doc ///
  Key
    fermatReadCertificate
    (fermatReadCertificate, String)
    [fermatReadCertificate, Prime]
  Headline
    read an arc or obstruction certificate file of the session
  Usage
    D = fermatReadCertificate file
  Inputs
    file:String
      the name of a text file in the format of the session's exports ({\tt export_c3/cert_*.txt},
      {\tt export_x1/*.txt}) or written by @TO fermatWriteCertificate@
    Prime=>ZZ
      if positive: read the data modulo this prime (MOD p) instead of exactly
  Outputs
    D:HashTable
      with string keys "ring", "degree", "dimension", "spaces", "coefficients", "lambda",
      "periodPolynomial" (computed from the spaces and coefficients), "listedPeriodPolynomial" (as listed in
      the file, or null), "arc", "forms", "vanishingOrder", "obstructionOrder", "obstructionCoefficients",
      "functionals", "claimedRanks", "extra", "ignoredLines", "label", "file"
  Description
    Text
      Lines recognised: {\tt NV = }, {\tt d = } (default 3), {\tt prime = }, {\tt lambda = },
      {\tt P1: x0 = z^1*x1, ...}, {\tt delta = [c1]*P1 + [c2]*P2 + ...}, {\tt forms Q (in this order): ...},
      {\tt T_j = [c]*x0*x1*x7 + ...}, the claim lines with {\tt k = 1..M} (vanishing order) and
      {\tt the coefficients of eps^N} (obstruction order) followed by lines {\tt c_N[Q] = value}, functionals
      {\tt K = [c]*(Q)^dual + ... ; K.c_N = value} or {\tt Lambda = ...}, and the listing of the period
      polynomial. Numbers are written a, (a)*z, (a)+(b)*z, or (a0)+(a1)*z+(a2)*z^2+... with rational a_i.
      Lines that are not recognised are returned under "ignoredLines" and are not used.
      Copies of the session's files are installed with the package.
    Example
      file = HodgeLociCI#"auxiliary files" | "data/cert_n6_lam2.txt";
      D = fermatReadCertificate file;
      (D#"dimension", D#"lambda", #(D#"arc"), D#"vanishingOrder", D#"obstructionOrder")
      D#"spaces"
      D#"arc"#3
      D#"listedPeriodPolynomial" == D#"periodPolynomial"
    Text
      {\bf Labels.} EXACT, or MOD p with the option Prime. Reading makes no claim; see
      @TO fermatVerifyCertificate@.
  SeeAlso
    fermatVerifyCertificate
    fermatWriteCertificate
///

doc ///
  Key
    fermatWriteCertificate
    (fermatWriteCertificate, String, HashTable)
  Headline
    write an arc or obstruction certificate in the text format of the session
  Usage
    fermatWriteCertificate(file, D)
  Inputs
    file:String
      the name of the file to write
    D:HashTable
      with string keys "ring", "spaces", "coefficients", "arc" and optionally "forms", "vanishingOrder",
      "obstructionOrder", "obstructionCoefficients", "functionals" (as returned by
      @TO fermatReadCertificate@)
  Outputs
    :String
      the file name
  Description
    Text
      The file can be read back by @TO fermatReadCertificate@ and re-verified by
      @TO fermatVerifyCertificate@ by a third party. The example extends an arc at the control value
      lambda = 1 on the cubic sixfold, writes it, and verifies the file.
    Example
      S = fermatRing(3, 6); use S;
      spaces = {{{0,1,1},{2,3,1},{4,5,1},{6,7,1}}, {{0,1,3},{2,3,3},{4,5,3},{6,7,1}}};
      P = fermatPeriodPolynomial(S, spaces#0) + fermatPeriodPolynomial(S, spaces#1);
      T1 = x_0*x_1*x_7 + x_2*x_3*x_7 + x_4*x_5*x_7;
      H = fermatExtendArc(P, {T1}, 3);
      file = temporaryFileName() | ".txt";
      fermatWriteCertificate(file, hashTable {"ring" => S, "spaces" => spaces, "coefficients" => {1, 1}, "arc" => H#"arc"});
      V = fermatVerifyCertificate file;
      (V#"pass", V#"vanishingOrder", V#"label")
    Text
      {\bf Labels.} EXACT rings write rational coordinates in the power basis of z; rings MOD p write
      residues and a line {\tt prime = p}.
  SeeAlso
    fermatReadCertificate
    fermatVerifyCertificate
///

doc ///
  Key
    fermatVerifyCertificate
    (fermatVerifyCertificate, String)
    (fermatVerifyCertificate, HashTable)
    [fermatVerifyCertificate, Prime]
  Headline
    re-verify every checkable claim of an arc or obstruction certificate
  Usage
    V = fermatVerifyCertificate file
    V = fermatVerifyCertificate D
  Inputs
    file:String
      a certificate file (see @TO fermatReadCertificate@)
    D:HashTable
      the data of a certificate, as returned by @TO fermatReadCertificate@
    Prime=>ZZ
      if positive (and a file name is given): verify MOD p instead of exactly
  Outputs
    V:HashTable
      with string keys "pass", "firstFailingOrder" (the first order at which a claim fails, or null),
      "checks" (a list of pairs {description, Boolean}), "vanishingOrder", "obstructionOrder",
      "ignoredLines" (number of lines of the file that were not used), "label"
  Description
    Text
      The checks are: the listed period polynomial; the list of forms; the vanishing of the coefficients of
      eps^1..eps^M for all forms; that T_1 is in the kernel of L and not in the kernel of L_P1; the claimed
      ranks; and, for an obstruction certificate of order N = M+1: the listed coefficients of eps^N, that
      this vector is not in the image of L, and for every listed functional K that K.L = 0 and that K.c_N
      has the listed nonzero value.
    Example
      dir = HodgeLociCI#"auxiliary files" | "data/";
      V = fermatVerifyCertificate(dir | "cert_n6_lam2.txt");
      (V#"pass", V#"firstFailingOrder", V#"label")
      netList V#"checks"
    Text
      A perturbed certificate fails, and the first failing order is reported.
    Example
      D = fermatReadCertificate(dir | "cert_n6_lam2.txt");
      S = D#"ring"; arc = D#"arc";
      bad = new HashTable from (pairs D | {("arc", {arc#0, arc#1, arc#2 + (1/1000)*S_0*S_2*S_6, arc#3})});
      Vbad = fermatVerifyCertificate bad;
      (Vbad#"pass", Vbad#"firstFailingOrder")
    Text
      {\bf Labels.} EXACT, or MOD p with the option Prime. A pass means that the listed numbers were
      reproduced (COMPUTED). It does not check the argument by which a certificate draws geometric
      conclusions (for instance "why one arc suffices" in {\tt tests/data/fermat/README_export_c3.txt}, or claim 4 of
      {\tt tests/data/fermat/x1_lam2_obstruction.txt}); that argument and the period formulas are ASSUMED.
  SeeAlso
    fermatReadCertificate
    fermatVerifyArc
    "Fermat higher-order expansion"
///

doc ///
  Key
    Parameters
  Headline
    option of fermatRing: extra variables of degree 0
  Description
    Text
      A list of symbols. The ring made by @TO fermatRing@ then has these additional variables, of degree 0,
      which can be used as undetermined coefficients in the terms of an arc; @TO fermatExpansion@ and
      @TO fermatNextOrderSystem@ return polynomials in them.
    Example
      S = fermatRing(3, 6, Parameters => {symbol s});
      degrees S
  SeeAlso
    fermatRing
    fermatNextOrderSystem
///

doc ///
  Key
    Forms
  Headline
    option: the list of numerators Q of the period functions
  Description
    Text
      A list of monomials Q of degree d*k - (n+2) for integers k >= 1 (the pole order). The default is
      @TO fermatPeriodForms@. Used by @TO fermatExpansion@, @TO fermatFirstOrderMatrix@,
      @TO fermatVerifyArc@, @TO fermatNextOrderSystem@ and @TO fermatExtendArc@.
    Example
      S = fermatRing(3, 6); use S;
      P = fermatPeriodPolynomial(S, {{0,1,1},{2,3,1},{4,5,1},{6,7,1}});
      fermatFirstOrderMatrix(P, Forms => {x_0, x_1}, Monomials => {x_1*x_2*x_4, x_0*x_2*x_4, x_0*x_3*x_5})
  SeeAlso
    fermatPeriodForms
///

doc ///
  Key
    AllMonomials
  Headline
    option: use all monomials instead of the monomial basis of the Jacobian ring
  Description
    Text
      Boolean option of @TO fermatPeriodForms@ and @TO fermatDeformationMonomials@.
    Example
      S = fermatRing(3, 6);
      (#fermatDeformationMonomials S, #fermatDeformationMonomials(S, AllMonomials => true))
  SeeAlso
    fermatPeriodForms
    fermatDeformationMonomials
///

doc ///
  Key
    Prime
  Headline
    option: a prime p = 1 mod 2d, to read or verify a certificate MOD p
  Description
    Text
      Option of @TO fermatReadCertificate@ and @TO fermatVerifyCertificate@. The default 0 means exact
      arithmetic over QQ(zeta_2d).
    Example
      dir = HodgeLociCI#"auxiliary files" | "data/";
      V = fermatVerifyCertificate(dir | "cert_n6_lam-1.txt", Prime => 32749);
      (V#"pass", V#"label")
  SeeAlso
    fermatReadCertificate
    fermatVerifyCertificate
///
