-- HodgeLociCI/ExcessDoc.m2  (owner: agent PA)
-- Documentation nodes of item 1; loaded after beginDocumentation().
-- "Paper 3" = night/paper3/paper3.tex of the research session (AI-written, not refereed by a human).

doc ///
  Key
    "the setting of paper 3"
  Headline
    two complete-intersection cycles with shared equations on a hypersurface: notation and conventions
  Description
    Text
      {\bf Source.} All statements quoted in this package under the name "paper 3" come from an AI-written
      manuscript of the research session (file night/paper3/paper3.tex, version 21) that no human has refereed.
      "PROVED" in this documentation always means "proved in that unreviewed manuscript".
    Text
      {\bf Setting.} $S$ is a polynomial ring in $2k+2$ variables over a field, $X = V(F)$ a smooth hypersurface
      of degree $d$ in projective space of dimension $2k+1$. Fix $c \ge 1$ and forms $f_0,\dots,f_{c-1}$,
      $h_0,\dots,h_{c-1}$ (the own equations) and $p_c,\dots,p_k$ (the shared equations), all of degree at
      least 1 and less than $d$, such that $Y_1 = V(f,p)$ and $Y_2 = V(h,p)$ are complete intersections of
      dimension $k$ contained in $X$ and $V(f,h,p)$ has dimension $k-c$. Then
      $F = f^T M h + \sum_l p_l s_l$ for a $c \times c$ matrix $M$ of forms and forms $s_l$; put
      $g = M h$ and $q = M^T f$.
    Text
      {\bf Numbers attached to the degrees.} The level is $\tau = \sum_i (\deg f_i + \deg h_i) - (c-1)d = d - \deg \det M$;
      the special coefficient is $\lambda_0 = (-1)^{c-1}$; the range is the inequality $(k-1)d + \tau < 2k+2$;
      $A = S/(f,h,p,s)$ is an Artinian complete intersection and $e_\tau = \dim A_\tau$ (zero if $\tau < 0$).
      Further $\sigma' = kd-2k-2$ is the degree of the forms $Q$ indexing the period functions, and $r = d - \sigma'$.
    Text
      {\bf Hodge loci.} For a coefficient $\lambda \ne 0$ let $\delta_\lambda = [Y_1] + \lambda [Y_2]$ and let
      $NL(\delta_\lambda)$ be its Hodge locus (a germ of analytic space at $X$ in the space of hypersurfaces of
      degree $d$); $V_i = NL([Y_i])$ and $V_Z = V_1 \cap V_2$. Tangent spaces are subspaces of $S_d$. The excess of
      $\lambda$ is $\dim T NL(\delta_\lambda) / T V_Z$.
    Text
      {\bf Residues.} For a regular sequence $G$ of $2k+2$ forms, $Res[P/G]$ is the linear form on the socle degree of
      $S/(G)$ that vanishes on $(G)$ and takes the value $\prod \deg G_i$ on $\det Jac(G)$; see @TO grothendieckResidue@.
      The sequences are ordered $(f,p;h,s)$, $\Phi^1 = (f,p;g,s)$, $\Phi^2 = (h,p;q,s)$.
    Text
      {\bf Labels.} EXACT: exact arithmetic over the rational numbers. MOD p: computed modulo a prime at one
      instance (evidence, not proof). PROVED: proved in paper 3 (AI-written, unreviewed); the theorem is cited.
      COMPUTED ONLY: observed in computations, no proof claimed. Functions that return tables put such a label
      under the key "label".
    Text
      {\bf Result tables} are hash tables with string keys, for instance @TT "r#\"tau\""@. A number that is not
      determined by the input is returned as the symbol @TO NotDetermined@, never as a guess.
  SeeAlso
    excessFromDegrees
    cyclePair
    secondOrderObstruction
///

doc ///
  Key
    hodgeLevel
    (hodgeLevel, ZZ, ZZ)
  Headline
    Hodge level of the middle cohomology of a smooth hypersurface
  Usage
    hodgeLevel(n, d)
  Inputs
    n:ZZ
      the dimension of the hypersurface (it lies in projective space of dimension n+1)
    d:ZZ
      its degree
  Outputs
    :ZZ
      the largest $|p-q|$ with $h^{p,q} \ne 0$ in the middle cohomology $H^n$; @TT "-infinity"@ if $H^n = 0$
  Description
    Text
      By Griffiths' description, the primitive part of $H^{n-q,q}$ of a smooth hypersurface of degree $d$ and
      dimension $n$ is the part of degree $(q+1)d - n - 2$ of the Jacobian ring, so the level is
      $n - 2(\lceil (n+2)/d \rceil - 1)$ whenever there is primitive cohomology. Status: classical (Griffiths);
      the function is integer arithmetic. If the primitive cohomology vanishes (hyperplanes, and quadrics of
      odd dimension) the function returns 0 for even $n$ (the middle cohomology is spanned by the class of a
      linear section) and @TT "-infinity"@ for odd $n$.
    Example
      hodgeLevel(4, 3)
      hodgeLevel(6, 3)
      hodgeLevel(2, 4)
      hodgeLevel(3, 2)
    Text
      This is not "the level" $\tau$ of paper 3: for that number see @TO excessFromDegrees@.
  SeeAlso
    primitiveHodgeNumbers
///

doc ///
  Key
    primitiveHodgeNumbers
    (primitiveHodgeNumbers, ZZ, ZZ)
  Headline
    primitive Hodge numbers of the middle cohomology of a smooth hypersurface
  Usage
    primitiveHodgeNumbers(n, d)
  Inputs
    n:ZZ
      the dimension of the hypersurface
    d:ZZ
      its degree
  Outputs
    :List
      the numbers $h^{n,0}, h^{n-1,1}, \dots, h^{0,n}$ of the primitive middle cohomology
  Description
    Text
      Computed as Hilbert function values of a complete intersection of $n+2$ forms of degree $d-1$ (the
      Jacobian ring). Status: classical (Griffiths); integer arithmetic.
    Example
      primitiveHodgeNumbers(4, 3)
      primitiveHodgeNumbers(2, 4)
      primitiveHodgeNumbers(6, 3)
  SeeAlso
    hodgeLevel
    ciHilbertFunction
///

doc ///
  Key
    ciHilbertFunction
    (ciHilbertFunction, List, ZZ, ZZ)
  Headline
    Hilbert function of a complete intersection, from the degrees
  Usage
    ciHilbertFunction(degs, nvars, m)
  Inputs
    degs:List
      the degrees (positive integers) of a regular sequence of forms
    nvars:ZZ
      the number of variables of the polynomial ring
    m:ZZ
      a degree
  Outputs
    :ZZ
      the dimension of the part of degree m of the quotient of the polynomial ring by the regular sequence
  Description
    Text
      The coefficient of $T^m$ in $\prod_i (1-T^{a_i}) / (1-T)^{nvars}$. Status: EXACT (integer arithmetic);
      the formula is standard.
    Example
      apply(0..4, m -> ciHilbertFunction({2,2,2}, 3, m))
      S = QQ[a,b,c];
      apply(0..4, m -> hilbertFunction(m, S/ideal(a^2, b^2, c^2)))
///

doc ///
  Key
    excessFromDegrees
    (excessFromDegrees, ZZ, List, List, List)
  Headline
    the excess calculator by degrees: level, special coefficient, range, excess (paper 3, Theorem 2)
  Usage
    r = excessFromDegrees(d, degF, degH, degP)
  Inputs
    d:ZZ
      the degree of the hypersurface
    degF:List
      the degrees of the c own equations f of the first cycle
    degH:List
      the degrees of the c own equations h of the second cycle
    degP:List
      the degrees of the shared equations p (possibly empty)
  Outputs
    r:HashTable
      with string keys, described below
  Description
    Text
      Notation as in @TO "the setting of paper 3"@; $k = c + \#p - 1$. The table contains
    Text
      "tau": the level $\tau$; "levelDichotomy": which side of the dichotomy $\tau < 0$ / $\tau \ge 0$ holds, in words;
      "lambda0": the special coefficient $(-1)^{c-1}$; "inRange": whether $(k-1)d+\tau < 2k+2$;
      "eTau": $e_\tau = \dim A_\tau$; "dimAd": $\dim A_d$, the codimension of $T V_1 + T V_2$ in $S_d$;
      "codimV1", "codimV2", "codimVZ": the codimensions of the smooth germs $V_1$, $V_2$, $V_Z$;
      "transversal": whether $V_1$ and $V_2$ are transversal (equivalent to the range);
      "excessAtLambda0": the excess at $\lambda_0$; "codimNLAtLambda0": the codimension of the smooth germ $NL(\delta_{\lambda_0})$;
      "excessElsewhere": the excess for $\lambda$ different from 0 and $\lambda_0$, or @TO NotDetermined@;
      "excessElsewhereBounds": a pair (lower bound, upper bound) for that excess;
      "sigma", "sigmaPrime", "r": the socle degree of $A$, the number $kd-2k-2$ and $d - (kd-2k-2)$;
      "notes": the hypotheses and the status of each number; "label".
    Text
      {\bf What is PROVED (paper 3, Theorem 2; AI-written, unreviewed).} Hypotheses: $X$ smooth and the setting above
      (in particular all degrees at least 1 and less than $d$). (1) $V_1$, $V_2$, $V_Z$ are smooth with the stated
      codimensions and $T V_Z = T V_1 \cap T V_2$; they are transversal iff the range holds. (2) For every nonzero
      $\lambda$ the excess is at most $e_\tau$, with equality in the range. (3) If $\tau < 0$ then
      $NL(\delta_\lambda) = V_Z$ for every nonzero $\lambda$. (4) If $\tau \ge 0$ then $NL(\delta_{\lambda_0})$ is smooth of
      codimension codim $V_Z - e_\tau$. (5) If $\tau \ge 0$ and $\lambda$ is neither 0 nor $\lambda_0$, the excess is
      $\dim (0 :_A \det M)_\tau = e_\tau - rank(\cdot \det M : A_\tau \to A_d)$.
    Text
      {\bf When the answer is not determined by the degrees.} Outside the range and for $\tau \ge 0$ the number in (5)
      depends on the hypersurface; the function then returns @TO NotDetermined@ together with the bounds
      $\max(0, e_\tau - \dim A_d) \le excess \le e_\tau$. Use @TO excessFromData@ at a point, or
      @TO linearSubspaceCase@ for the generic value when both cycles are linear subspaces.
    Text
      The function works on the degrees only (integer arithmetic) and checks only the necessary conditions on a
      degree type; it cannot check that a smooth hypersurface of the type exists, except that it rejects types
      for which $\det M$ vanishes for degree reasons.
    Example
      r = excessFromDegrees(3, {1,1}, {1,1}, {1,1});
      (r#"tau", r#"lambda0", r#"inRange", r#"eTau")
      (r#"codimV1", r#"codimV2", r#"codimVZ", r#"codimNLAtLambda0")
      (r#"excessAtLambda0", r#"excessElsewhere")
    Text
      Two 3-planes in a cubic sixfold meeting in a line: one finds $\tau = 1$, $\lambda_0 = -1$, two excess directions
      for every coefficient. Two planes meeting in a line on a quartic fourfold are outside the range:
    Example
      r = excessFromDegrees(4, {1}, {1}, {1,1});
      (r#"tau", r#"inRange", r#"excessAtLambda0", r#"excessElsewhere", r#"excessElsewhereBounds")
    Text
      A type with negative level (two planes meeting in a point on a quintic fourfold):
    Example
      r = excessFromDegrees(5, {1,1}, {1,1}, {1});
      (r#"tau", r#"levelDichotomy")
  SeeAlso
    "the setting of paper 3"
    excessFromData
    linearSubspaceCase
    verifyExcess
///

doc ///
  Key
    linearSubspaceCase
    (linearSubspaceCase, ZZ, ZZ, ZZ)
  Headline
    the list of cases for two linear subspaces (paper 3, Theorem 9.7 and Table 1)
  Usage
    r = linearSubspaceCase(d, k, c)
  Inputs
    d:ZZ
      the degree of the hypersurface, at least 3
    k:ZZ
      the dimension of the two linear subspaces (the hypersurface has dimension 2k)
    c:ZZ
      between 1 and k+1: the two subspaces meet in dimension k-c
  Outputs
    r:HashTable
      with keys "tau", "lambda0", "case", "genericExcessElsewhere", "atLambda0", "elsewhere", "statement",
      "hypothesis", "sigmaPrime", "label"
  Description
    Text
      Here all $f_i$, $h_j$, $p_l$ are linear, $\tau = 2c-(c-1)d$ and $\lambda_0 = (-1)^{c-1}$.
      {\bf PROVED (paper 3, Theorem 9.7; AI-written, unreviewed)}, under the hypothesis $kd-2k-2 \ge 1$:
      (1) if $\tau < 0$ then $NL([\Pi_1]+\lambda[\Pi_2]) = V_Z$ for every nonzero $\lambda$, at every smooth $X$;
      (2) if $\tau \ge 0$ then $NL([\Pi_1]+\lambda_0[\Pi_2])$ is smooth and strictly larger than $V_Z$, at every smooth $X$;
      (3) if $\tau \ge 0$, $\lambda$ is neither 0 nor $\lambda_0$ and $X$ is {\bf general} among the smooth hypersurfaces
      containing two such subspaces: the locus is $V_Z$ as a scheme unless $(d,k,c)$ is one of
      (3,3,1), (3,3,2), (3,3,3), (3,4,1), (3,4,2), (3,4,3), (4,2,1), (4,2,2), (5,2,1) or $(d,1,1)$ with $d \ge 5$;
      in these cases it is $V_Z$ with a non-reduced structure and the number of excess tangent directions given under
      "genericExcessElsewhere" (and it is non-reduced at every smooth $X$).
    Text
      The key "case" is one of "tau < 0", "sporadic", "generic", "excluded". The value "excluded" is returned when
      $kd-2k-2 < 1$ (cubic surfaces, cubic fourfolds, quartic surfaces), where the theorem does not apply; the
      "statement" then quotes what the paper says about these cases, and the other entries are @TO NotDetermined@.
      At special $X$ the excess can be larger than the generic value: use @TO excessFromData@.
    Example
      r = linearSubspaceCase(3, 3, 2);
      (r#"tau", r#"lambda0", r#"case", r#"genericExcessElsewhere")
      r#"statement"
      (linearSubspaceCase(3, 5, 2))#"case"
      (linearSubspaceCase(5, 2, 2))#"case"
      (linearSubspaceCase(3, 2, 1))#"case"
  SeeAlso
    excessFromDegrees
    secondOrderObstruction
///

doc ///
  Key
    CyclePair
    (net, CyclePair)
  Headline
    the type of validated data (f, h, p, M, s) of two complete-intersection cycles on a hypersurface
  Description
    Text
      An object of this type is a hash table created by @TO cyclePair@ or @TO randomCyclePair@. Its string keys
      include "ring", "field", "degree" (the degree $d$), "k", "c", the lists "f", "h", "p", "s", the matrix "M",
      the derived lists "g" ($= Mh$) and "q" ($= M^T f$), the polynomial "F" ($= f^T M h + \sum p_l s_l$), "detM",
      "degreesF", "degreesH", "degreesP", "tau", "lambda0", the sequences "Phi0" $= (f,p;h,s)$, "Phi1" $= (f,p;g,s)$,
      "Phi2" $= (h,p;q,s)$, "smooth" (true, or "not checked") and "label" (EXACT or MOD p, according to the field).
    Example
      D = randomCyclePair(4, {1,1}, {1,1}, {}, Seed => 1)
      D#"F" == (matrix{D#"f"} * D#"M" * transpose matrix{D#"h"})_(0,0)
      (D#"tau", D#"lambda0", D#"label")
  SeeAlso
    cyclePair
    randomCyclePair
///

doc ///
  Key
    cyclePair
    (cyclePair, Sequence)
    [cyclePair, CheckSmooth]
  Headline
    make and validate the data of two complete-intersection cycles on a hypersurface
  Usage
    D = cyclePair(f, h, p, M, s)
  Inputs
    :Sequence
      the five arguments (f, h, p, M, s): f and h are lists of c forms (own equations of the two cycles), p a list of
      k+1-c forms (shared equations), M a c x c matrix of forms, s a list of k+1-c forms
    CheckSmooth => Boolean
      whether to test that the hypersurface is smooth (an error is raised if it is singular)
  Outputs
    D:CyclePair
  Description
    Text
      The hypersurface is $F = f^T M h + \sum_l p_l s_l$; see @TO "the setting of paper 3"@. The constructor checks:
      the ring is a standard graded polynomial ring over a field with $2k+2$ variables, where $k+1 = \#f + \#p$;
      the numbers of forms; homogeneity of $F$; that the degrees of $f$, $h$, $p$ are at least 1 and less than $d$;
      that $(f,h,p,s)$ is a regular sequence (necessary for $X$ to be smooth); and, unless
      @TT "CheckSmooth => false"@, that $X$ is smooth. Each failure gives an error message naming the condition.
      The coefficient field should be the rational numbers (results are then EXACT) or a prime field (results are
      MOD p). Number fields made with @TO toField@, for instance cyclotomic fields for Fermat hypersurfaces, are
      accepted as well (results EXACT; covered by one test only); other fields are not covered by the tests.
    Example
      S = QQ[x_0..x_3];
      M = matrix{{x_2^2 + x_1*x_3, x_0^2 + x_3^2}, {x_1^2 - x_2^2 + x_0*x_3, x_3^2 + x_0*x_1}};
      D = cyclePair({x_0, x_1}, {x_2, x_3}, {}, M, {})
      D#"F"
    Text
      Two skew lines on a quartic surface: $c = 2$, $\tau = 0$, $\lambda_0 = -1$.
  SeeAlso
    randomCyclePair
    CyclePair
    excessFromData
///

doc ///
  Key
    randomCyclePair
    (randomCyclePair, ZZ, List, List, List)
    [randomCyclePair, CoefficientRing]
    [randomCyclePair, Seed]
    [randomCyclePair, Height]
    [randomCyclePair, CheckSmooth]
  Headline
    random data of a given degree type over ZZ/p or QQ
  Usage
    D = randomCyclePair(d, degF, degH, degP)
  Inputs
    d:ZZ
      the degree of the hypersurface
    degF:List
      the degrees of the own equations of the first cycle
    degH:List
      the degrees of the own equations of the second cycle
    degP:List
      the degrees of the shared equations
    CoefficientRing => Ring
      the rational numbers or a prime field ZZ/p
    Seed => ZZ
      if an integer is given, @TO setRandomSeed@ is called with it first, so that the result is reproducible
    Height => ZZ
      over the rational numbers the coefficients are random integers of absolute value at most this number
    CheckSmooth => Boolean
      whether to insist that the hypersurface is smooth
  Outputs
    D:CyclePair
  Description
    Text
      Random forms $f$, $h$, $p$, $s$ and a random matrix $M$ of the degrees forced by the type (entries of negative
      degree are zero) in the ring with variables $x_0,\dots,x_{2k+1}$. Instances that are not in the setting
      (singular $X$, or $(f,h,p,s)$ not regular) are discarded; after 25 failures an error is raised.
      Over the rational numbers smoothness is certified by a smooth reduction modulo a prime where possible.
    Example
      D = randomCyclePair(3, {1,1}, {1,1}, {1,1}, Seed => 11)
      D5 = randomCyclePair(5, {1}, {1}, {1}, CoefficientRing => QQ, Seed => 5)
      D5#"F"
  SeeAlso
    cyclePair
    Seed
    CheckSmooth
///

doc ///
  Key
    excessFromData
    (excessFromData, CyclePair)
  Headline
    the excess calculator by data: the numbers of Theorem 2 of paper 3 computed at one point
  Usage
    r = excessFromData D
  Inputs
    D:CyclePair
  Outputs
    r:HashTable
      with string keys, described below
  Description
    Text
      Computes, in the ring of the data: "eTau" $= \dim A_\tau$ and "dimAd" $= \dim A_d$ for $A = S/(f,h,p,s)$;
      "rankDetM", the rank of multiplication by $\det M$ from $A_\tau$ to $A_d$; "dimAnnDetM" $= \dim (0 :_A \det M)_\tau$
      $= e_\tau - $ rank; "conditionS", whether that multiplication is surjective (condition (S) of paper 3, section 9.1;
      @TO NotDetermined@ if $\tau < 0$); "codimV1", "codimV2", "codimVZ" as Hilbert function values of $S/\Phi^1$, $S/\Phi^2$ and
      $S/((p,s)+(g)+(q)+(f)(h))$ in degree $d$; "excessAtLambda0"; "excessElsewhere" (the excess for $\lambda$ different from 0
      and $\lambda_0$); "excessDirections", a list of forms $N$ of degree $\tau$ whose classes are a basis of
      $E' = (0 :_A \det M)_\tau$; and "tau", "lambda0", "inRange", "sigmaPrime", "r", "codimNLAtLambda0", "smooth", "label".
    Text
      {\bf Status.} The Hilbert functions and ranks are EXACT over the rational numbers and MOD p over a prime field.
      Their identification with codimensions and excesses of Hodge loci is PROVED in paper 3 (AI-written, unreviewed),
      Theorem 2 and Lemmas 3.2, 3.3, for smooth $X$. An independent computation at the same point is provided by
      @TO tangentExcess@; @TO verifyExcess@ compares the two.
    Example
      D = randomCyclePair(4, {1}, {1}, {1,1}, Seed => 26);
      r = excessFromData D;
      (r#"tau", r#"inRange", r#"eTau", r#"rankDetM", r#"dimAd")
      (r#"excessAtLambda0", r#"excessElsewhere", r#"conditionS")
      r#"excessDirections"
    Text
      Two planes meeting in a line on a quartic fourfold: outside the range, three excess directions at
      $\lambda_0 = 1$ and two for the other coefficients, as in Table 1 of paper 3.
  SeeAlso
    excessFromDegrees
    tangentExcess
    verifyExcess
///

doc ///
  Key
    tangentExcess
    (tangentExcess, CyclePair, Thing)
    [tangentExcess, Strategy]
  Headline
    direct first-order computation of the excess of a coefficient at one point
  Usage
    r = tangentExcess(D, lambda)
  Inputs
    D:CyclePair
    lambda:Thing
      a nonzero integer, rational number or element of the coefficient field
    Strategy => String
      "Jacobian" (default) or "Residue"
  Outputs
    r:HashTable
      with keys "excess", "codimTNL", "codimTVZ", "codimTV1", "codimTV2", "lambda", "strategy", "label"
  Description
    Text
      Computes $\dim T NL(\delta_\lambda) / T V_Z$ by linear algebra, without using Theorem 2 of paper 3, so that the
      theorem can be checked at a point.
    Text
      Strategy "Jacobian": the period polynomials $P_i = \det Jac(\phi_0,\psi_0,\dots,\phi_k,\psi_k)$ of the two cycles
      (see @TO periodPolynomial@) are multiplied with a basis of $S_{kd-2k-2}$ in the Jacobian ring $R$ of $F$; by
      Gorenstein duality the codimension of $T NL(\delta_\lambda) = (Jac F : (P_1 + \lambda P_2))_d$ is the dimension of
      $(P_1 + \lambda P_2) R_{kd-2k-2}$, and that of $T V_Z$ is the dimension of $P_1 R_{kd-2k-2} + P_2 R_{kd-2k-2}$.
      Input from the literature: the period formula for complete intersections (the period functional of $[Y]$ on the
      Jacobian ring is a universal constant times multiplication by this determinant followed by the residue).
    Text
      Strategy "Residue": the functionals $u_i(G)(Q) = Res[QG/\Phi^i]$ of paper 3, Lemma 2.1(1) and Lemma 3.5 (same
      constant for both cycles when $\tau \ge 0$); faster in many variables.
    Text
      {\bf Status.} The linear algebra is EXACT over the rational numbers and MOD p over a prime field. A rank
      computed modulo a prime is a lower bound for the rank in characteristic zero at a lift of the instance.
      The relative sign of the two period functionals for $\tau < 0$ is COMPUTED ONLY in paper 3 (Remark 10.2(a));
      for $\tau < 0$ the excess does not depend on it.
    Example
      D = randomCyclePair(4, {1}, {1}, {1,1}, Seed => 26);
      r = tangentExcess(D, 1);
      (r#"excess", r#"codimTNL", r#"codimTVZ")
      (tangentExcess(D, -1))#"excess"
      (tangentExcess(D, 5/3, Strategy => "Residue"))#"excess"
  SeeAlso
    excessFromData
    verifyExcess
    periodPolynomial
///

doc ///
  Key
    verifyExcess
    (verifyExcess, CyclePair)
    (verifyExcess, CyclePair, List)
    [verifyExcess, Strategy]
  Headline
    compare Theorem 2 of paper 3 with the direct first-order computation at one point
  Usage
    v = verifyExcess D
    v = verifyExcess(D, lambdas)
  Inputs
    D:CyclePair
    lambdas:List
      of nonzero coefficients; default: $\lambda_0$, $-\lambda_0$, 2, 3, -2, 1/2, 5/3
    Strategy => String
      passed to @TO tangentExcess@
  Outputs
    v:HashTable
      with keys "agrees" (Boolean), "excessAgrees", "codimensionsAgree", "table", "tableColumns", "predicted",
      "strategy", "label"
  Description
    Text
      For each coefficient the excess predicted by @TO excessFromData@ ($e_\tau$ at $\lambda_0$, $\dim (0:_A \det M)_\tau$
      elsewhere, 0 if $\tau < 0$) is compared with @TO tangentExcess@; the codimensions of $V_1$, $V_2$, $V_Z$ are
      compared as well. Each row of "table" is (coefficient, predicted excess, computed excess).
      Status: a comparison at one instance, EXACT over the rational numbers and MOD p over a prime field; it is
      evidence for, not a proof of, the theorem.
    Example
      D = randomCyclePair(3, {1}, {1}, {1,1,1}, Seed => 24);
      v = verifyExcess D;
      v#"agrees"
      v#"table"
  SeeAlso
    excessFromData
    tangentExcess
///

doc ///
  Key
    periodPolynomial
    (periodPolynomial, List, List)
  Headline
    the period polynomial det Jac of a complete intersection in a hypersurface, modulo the Jacobian ideal
  Usage
    P = periodPolynomial(phi, psi)
  Inputs
    phi:List
      of k+1 forms defining a complete intersection Y of dimension k
    psi:List
      of k+1 forms with $F = \sum_i \phi_i \psi_i$ homogeneous
  Outputs
    P:RingElement
      the normal form of $\det Jac(\phi_0,\psi_0,\dots,\phi_k,\psi_k)$ modulo the Jacobian ideal of $F$
  Description
    Text
      The ring must have $2k+2$ variables. Up to a nonzero constant depending only on $k$ and $d$, the functional
      $P' \mapsto \int_Y Res(P' \Omega / F^{k+1})$ on forms of degree $(k+1)(d-2)$ is $P' \mapsto Res[P' P / Jac(F)]$
      (period formula for complete intersections: paper 3 quotes it from Villaflor Loyola, as machine-extracted, and
      its Lemma 2.1(5) relates it to the residue symbols used elsewhere in this package). The polynomial returned is EXACT
      or MOD p according to the field. It does not change when the pairs $(\phi_i,\psi_i)$ are permuted.
    Example
      S = QQ[x_0..x_3];
      phi = {x_0 - x_1, x_2 - x_3};
      psi = {x_0^3 + x_0^2*x_1 + x_0*x_1^2 + x_1^3, x_2^3 + x_2^2*x_3 + x_2*x_3^2 + x_3^3};
      sum(2, i -> phi#i * psi#i)
      periodPolynomial(phi, psi)
  SeeAlso
    tangentExcess
    hodgeLocusTangentCodim
///

doc ///
  Key
    hodgeLocusTangentCodim
    (hodgeLocusTangentCodim, RingElement, Ideal)
    [hodgeLocusTangentCodim, CheckSmooth]
  Headline
    tangent codimension of the Hodge locus of the class of a half-dimensional subvariety
  Usage
    r = hodgeLocusTangentCodim(F, I)
  Inputs
    F:RingElement
      a homogeneous polynomial of degree d in 2k+2 variables defining a smooth hypersurface X
    I:Ideal
      the homogeneous ideal of a subvariety Z of dimension k contained in X
    CheckSmooth => Boolean
      whether to test smoothness of X (an error is raised if it is singular)
  Outputs
    r:HashTable
      with keys "codim", "upperBound", "codimIJ", "hypothesis", "socleHalfDegree", "exponent", "degree", "k",
      "smooth", "label"
  Description
    Text
      {\bf Degree bookkeeping.} Let $J$ be the Jacobian ideal of $F$, $t = (k+1)(d-2)$ (half of the socle degree
      $(2k+2)(d-2)$ of the Jacobian ring) and $e = t - d = kd-2k-2$. The period functional
      $\pi(P) = \int_Z Res(P \Omega / F^{k+1})$ on $S_t$ vanishes on $J_t$ and on $I_t$ (a standard fact, used here
      without proof; for complete intersections it is paper 3, Lemma 2.1(1)), and the tangent space of the
      Hodge locus of $[Z]$ is the set of $G$ in $S_d$ with $\pi(QG) = 0$ for all $Q$ in $S_e$.
    Text
      {\bf Hypothesis.} If $(I+J)_t$ has codimension exactly 1 in $S_t$ (key "codimIJ" equal to 1; key "hypothesis") and the
      primitive class of $Z$ is nonzero, then $\pi$ spans the annihilator of $(I+J)_t$ and the tangent space is
      $((I+J) : m^e)_d$, with $m$ the irrelevant ideal. The function returns under "codim" the codimension of
      $((I+J):m^e)_d$ in $S_d$. That the primitive class is nonzero is NOT checked. If "codimIJ" is 0 the period
      functional vanishes and "codim" is 0. If "codimIJ" is larger than 1 the functional is not determined by this
      method: "codim" is @TO NotDetermined@ and "upperBound" is an upper bound for the tangent codimension.
      If $e < 0$ there are no period conditions and "codim" is 0.
    Text
      {\bf Status.} The number is linear algebra, EXACT over the rational numbers and MOD p over a prime field. Its
      interpretation rests on the classical description of the tangent space of a Hodge locus (Griffiths; Carlson, Green,
      Griffiths and Harris) and on the two hypotheses above; this utility was used throughout the research session
      (for instance in its checks C12 and C13 for cubic eightfolds and sixfolds). For complete intersections it agrees
      with paper 3, Lemma 3.2: the tangent space is $(\phi,\psi)_d$.
    Example
      D = randomCyclePair(3, {1,1}, {1,1}, {1,1}, Seed => 11);
      r = hodgeLocusTangentCodim(D#"F", ideal(D#"f" | D#"p"));
      (r#"codim", r#"codimIJ", r#"exponent")
      (excessFromDegrees(3, {1,1}, {1,1}, {1,1}))#"codimV1"
    Text
      The union of the two 3-planes: the hypothesis fails (two independent period functionals vanish on the ideal),
      and the function says so.
    Example
      r = hodgeLocusTangentCodim(D#"F", intersect(ideal(D#"f" | D#"p"), ideal(D#"h" | D#"p")));
      (r#"codim", r#"upperBound", r#"codimIJ")
  SeeAlso
    tangentExcess
    periodPolynomial
///

doc ///
  Key
    grothendieckResidue
    (grothendieckResidue, RingElement, List)
    (grothendieckResidue, RingElement, Matrix)
    (grothendieckResidue, ZZ, List)
    (grothendieckResidue, QQ, List)
  Headline
    Grothendieck residue of a form with respect to a regular sequence of forms
  Usage
    grothendieckResidue(P, G)
  Inputs
    P:RingElement
      a polynomial (only its component in the socle degree matters)
    G:List
      a regular sequence of N forms of positive degree in a polynomial ring with N variables (or a one-row matrix)
  Outputs
    :RingElement
      the residue symbol $Res[P/G]$, an element of the coefficient field
  Description
    Text
      $Res[\cdot/G]$ is the linear form on the part of degree $\sigma = \sum \deg G_i - N$ of the polynomial ring that
      vanishes on the ideal $(G)$ and is normalised by $Res[\det Jac(G) / G] = \prod_i \deg G_i$ (rows of the Jacobian
      matrix in the order of the sequence, so the symbol is alternating in $G$). Forms of other degrees have residue 0.
      It satisfies the transformation law $Res[m \det A / (A G)] = Res[m / G]$.
      Status: EXACT over the rational numbers, MOD p over a prime field. An error is raised if the forms are not a
      regular sequence, or if the normalisation is impossible (in positive characteristic $\det Jac(G)$ can lie in
      the ideal).
    Example
      S = QQ[a,b,c];
      G = {a^2 + b*c, b^3 - a*c^2, c^2 + a*b};
      grothendieckResidue(det jacobian matrix{G}, G)
      grothendieckResidue(a*b*c, {a^2, b^2, c^2})
      grothendieckResidue(a*b*c, {b^2, a^2, c^2})
    Text
      The transformation law, for a diagonal matrix:
    Example
      grothendieckResidue(a*b*c * (a+b), {a^2*(a+b), b^2, c^2})
  SeeAlso
    residueFunctional
    secondOrderFunctional
///

doc ///
  Key
    residueFunctional
    (residueFunctional, List)
    (residueFunctional, Matrix)
  Headline
    the residue symbol of a regular sequence as a function, with the Groebner basis computed once
  Usage
    L = residueFunctional G
  Inputs
    G:List
      a regular sequence of N forms in N variables (or a one-row matrix)
  Outputs
    L:Function
      which sends a polynomial P to $Res[P/G]$
  Description
    Text
      Same normalisation and status as @TO grothendieckResidue@; use this function when many residues with respect to
      the same sequence are needed.
    Example
      S = QQ[a,b,c];
      L = residueFunctional {a^2, b^3, c^2};
      apply({a*b^2*c, a*b*c^2, 5*a*b^2*c + a^4}, L)
  SeeAlso
    grothendieckResidue
///

doc ///
  Key
    isSmoothHypersurface
    (isSmoothHypersurface, RingElement)
  Headline
    whether a homogeneous polynomial defines a smooth projective hypersurface
  Usage
    isSmoothHypersurface F
  Inputs
    F:RingElement
      a nonzero homogeneous polynomial over a field
  Outputs
    :Boolean
  Description
    Text
      Tests whether the partial derivatives of $F$ and $F$ itself have only the origin as common zero. Over a prime
      field the Groebner basis is computed with the F4 engine. Over the rational numbers the polynomial is first
      reduced modulo the primes 32003, 30011, 10007: a smooth reduction proves smoothness over the rational numbers;
      if all three reductions are singular the computation is done over the rational numbers. The answer is EXACT in
      both cases.
    Example
      S = QQ[x_0..x_3];
      isSmoothHypersurface(x_0^3 + x_1^3 + x_2^3 + x_3^3)
      isSmoothHypersurface(x_0^3 + x_1^3 + x_2^2*x_3)
///

doc ///
  Key
    NotDetermined
  Headline
    the value returned for a number that is not determined by the input
  Description
    Text
      Functions of this package never fall back silently on a guess. Where a number depends on more than the
      input, the symbol @TT "NotDetermined"@ is returned in its place, usually together with bounds.
    Example
      r = excessFromDegrees(4, {1}, {1}, {1,1});
      r#"excessElsewhere"
      r#"excessElsewhere" === NotDetermined
      r#"excessElsewhereBounds"
  SeeAlso
    excessFromDegrees
    hodgeLocusTangentCodim
///

doc ///
  Key
    Seed
  Headline
    option: the seed of the random number generator
  Description
    Text
      With @TT "Seed => n"@ a function calls @TO setRandomSeed@ with the integer n before drawing random data, so that
      the result is reproducible; with the default @TT "Seed => null"@ the current state of the generator is used.
    Example
      D1 = randomCyclePair(4, {1,1}, {1,1}, {}, Seed => 7);
      D2 = randomCyclePair(4, {1,1}, {1,1}, {}, Seed => 7);
      toString D1#"F" == toString D2#"F"
  SeeAlso
    randomCyclePair
///

doc ///
  Key
    CheckSmooth
  Headline
    option: whether to test that the hypersurface is smooth
  Description
    Text
      The statements implemented in this package are about smooth hypersurfaces. With the default
      @TT "CheckSmooth => true"@ the constructors raise an error on a singular hypersurface; with
      @TT "CheckSmooth => false"@ the test is skipped and the entry "smooth" of the result is "not checked".
    Example
      S = QQ[x_0..x_3];
      M = matrix{{x_2^2 + x_1*x_3, x_0^2 + x_3^2}, {x_1^2 - x_2^2 + x_0*x_3, x_3^2 + x_0*x_1}};
      D = cyclePair({x_0, x_1}, {x_2, x_3}, {}, M, {}, CheckSmooth => false);
      D#"smooth"
  SeeAlso
    cyclePair
    randomCyclePair
    hodgeLocusTangentCodim
///

doc ///
  Key
    reduceModPrime
    (reduceModPrime, CyclePair, ZZ)
    [reduceModPrime, CheckSmooth]
  Headline
    reduce data over the rational numbers modulo a prime
  Usage
    Dp = reduceModPrime(D, p)
  Inputs
    D:CyclePair
      over the rational numbers
    p:ZZ
      a prime number not dividing any denominator
    CheckSmooth => Boolean
      whether to insist that the reduced hypersurface is smooth
  Outputs
    Dp:CyclePair
      the same data over ZZ/p
  Description
    Text
      The functions of this package compute over the field of the data: EXACT over the rational numbers, MOD p over a
      prime field. There is no silent fallback from one to the other. When an exact computation is too slow, reduce
      the data explicitly with this function; the results then carry the label MOD p. An error is raised if a
      denominator is divisible by p, if a form vanishes modulo p, or if the reduced data are not in the setting
      (singular reduction, or $(f,h,p,s)$ not regular modulo p).
    Text
      Ranks can only drop under reduction, so for data with good reduction the excess computed modulo p is at least
      the excess over the rational numbers; equality is not guaranteed.
    Example
      D = randomCyclePair(5, {1}, {1}, {1}, CoefficientRing => QQ, Seed => 5);
      Dp = reduceModPrime(D, 32003)
      (secondOrderObstruction(D, 2))#"arithmetic"
      (secondOrderObstruction(Dp, 2))#"arithmetic"
      ((secondOrderObstruction(D, 2))#"verdict", (secondOrderObstruction(Dp, 2))#"verdict")
  SeeAlso
    cyclePair
    randomCyclePair
///
