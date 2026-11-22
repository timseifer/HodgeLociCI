-- HodgeLociCI/SecondOrderDoc.m2  (owner: agent PA)
-- Documentation nodes of item 2; loaded after beginDocumentation().

doc ///
  Key
    secondOrderObstruction
    (secondOrderObstruction, CyclePair, Thing)
    [secondOrderObstruction, Strategy]
  Headline
    the second-order checker: do the excess tangent directions survive at second order?
  Usage
    r = secondOrderObstruction(D, lambda)
  Inputs
    D:CyclePair
    lambda:Thing
      a nonzero integer, rational number or element of the coefficient field
    Strategy => String
      "Formula" (default), "Pointwise" or "Both"
  Outputs
    r:HashTable
      with string keys, described below
  Description
    Text
      Notation as in @TO "the setting of paper 3"@. For $\tau \ge 0$ and $\lambda$ different from 0 and $\lambda_0$ the
      excess tangent directions of $NL(\delta_\lambda)$ over $V_Z$ are parametrised by
      $E' = (0 :_A \det M)_\tau$ (see @TO excessFromData@), and the second-order term of the period functions on
      them is $(\lambda-\lambda_0)/\lambda$ times a system of quadrics on $E'$ indexed by
      $K = [(f)(h)+(g)+(q)+(p)+(s)]_{kd-2k-2}$ that does not depend on $\lambda$ ("the law"). The function computes
      these quadrics at the given point and reports a verdict.
    Text
      {\bf Keys of the result.} "verdict": one of "NO EXCESS", "ALL SURVIVE", "ALL DIE", "SOME DIE"; "statement": the
      verdict in words, with the theorem used; "excess": the number of excess directions for this coefficient;
      "excessDirections": forms $N$ of degree $\tau$ representing a basis of $E'$; "quadrics": a basis of the span of the
      quadrics, as polynomials in variables $n_0, n_1, \dots$ (coordinates on $E'$ in that basis); "quadricMatrices";
      "rankOfQuadrics"; "commonZeroLocusDim": the projective dimension of the common zero locus of the quadrics in
      $P(E')$ over the algebraic closure ($-1$ if it is empty); "generators": the generators $Q(\dot v)$ of $K$ used, each as
      (kind, index, monomial, form); "values": for each generator the values on the pairs $(N_a,N_b)$, $a \le b$;
      "conditionS"; "dimK"; "strategiesAgree" (for Strategy "Both"); "arithmetic" and "label": EXACT or MOD p, and the
      source of the formulas.
    Text
      {\bf The verdicts, and what is PROVED (paper 3; AI-written, unreviewed).}
      "NO EXCESS": $\tau < 0$ or $E' = 0$; then $NL(\delta_\lambda) = V_Z$ (Theorem 2(3), (5)). No second-order
      computation is made, and the "label" says so: it names the first-order data used ($\tau$ from the degrees, or
      the annihilator of $\det M$ in $A_\tau$) and their arithmetic, EXACT or MOD p.
      "ALL SURVIVE" at $\lambda = \lambda_0$: the locus is smooth with $e_\tau$ excess directions (Theorem 2(4)); no
      computation is made. "ALL SURVIVE" elsewhere: all quadrics vanish at this point, so there is no obstruction
      at second order; this decides nothing about higher order, except when $K = 0$ in the range, where the locus is
      smooth (Theorem 9.1(1)).
      "ALL DIE": the quadrics have no common zero in $P(E')$; if condition (S) holds (always in the range) the
      reduction of $NL(\delta_\lambda)$ is $V_Z$ and the locus is non-reduced (Theorem 9.1(4), Theorem 9.4(4)); if (S)
      fails, only "not smooth" is asserted (Theorem 9.4(3)).
      "SOME DIE": the quadrics are not all zero but have a common zero; the locus is not smooth (Theorem 9.4(3)) and its
      structure is not determined by this test.
    Text
      {\bf Strategies.} "Formula" evaluates the closed formula of Theorem 9.1(3), Theorem 9.4(2) and Proposition 9.4'
      (valid for every sign of $r$): for a virtual deformation $\dot v$ with one nonzero component,
      $\rho(N N' tr(\dot M adj M)) - D_{\dot v}(N N' \det M)$, a combination of residue symbols with respect to
      $(f,p;h,s)$ and the same sequence with one member squared. "Pointwise" evaluates the second-order term
      directly from Lemma 2.1(3) (see @TO secondOrderFunctional@) on explicit tangent vectors $G_\lambda(N)$, as in the
      proof of Theorem 9.4(1); it is slower. "Both" computes both and records under "strategiesAgree" whether all
      values coincide. Both strategies rest on Lemma 2.1 of paper 3; neither is an independent computation of
      periods. The values are normalised by a nonzero constant ($\kappa$ of Lemma 2.1(4)) whose value is not needed.
    Text
      {\bf Arithmetic.} Over the rational numbers all residues are EXACT; over a prime field they are MOD p (evidence
      at one instance). "No common zero" modulo a prime at a reduction of the data implies the same in
      characteristic zero only when the data are a reduction of data in characteristic zero with the same $E'$.
    Text
      Two coplanar lines on a quintic surface with random rational coefficients: the excess direction dies at
      second order for $\lambda = 2$ and survives at $\lambda_0 = 1$.
    Example
      D = randomCyclePair(5, {1}, {1}, {1}, CoefficientRing => QQ, Seed => 5);
      r = secondOrderObstruction(D, 2, Strategy => "Both");
      (r#"verdict", r#"excess", r#"strategiesAgree", r#"arithmetic")
      r#"statement"
      (secondOrderObstruction(D, 1))#"verdict"
    Text
      A special quintic: the residual cubic $M_{00}$ passes through the point where the two lines meet. By
      Corollary 9.2(2) of paper 3 the second-order term vanishes, and the function finds this exactly.
    Example
      S = QQ[x_0..x_3];
      M00 = x_0^3 + 2*x_1^3 - x_2^3 + x_0*x_3^2 + x_1*x_2*x_3 + x_2^2*x_3;
      s0 = x_3^4 + x_0^4 - x_1^4 + 3*x_2^4 + x_0*x_1*x_3^2 + x_2*x_3^3;
      Ds = cyclePair({x_0}, {x_1}, {x_2}, matrix{{M00}}, {s0});
      (secondOrderObstruction(Ds, 2))#"verdict"
    Text
      Two 3-planes meeting in a line on a cubic sixfold, modulo a prime: two excess directions, two quadrics
      without common zero (Corollary 9.3 of paper 3).
    Example
      D6 = randomCyclePair(3, {1,1}, {1,1}, {1,1}, Seed => 11);
      r6 = secondOrderObstruction(D6, 2);
      (r6#"verdict", r6#"excess", r6#"rankOfQuadrics", r6#"commonZeroLocusDim")
      r6#"arithmetic"
  SeeAlso
    secondOrderQuadrics
    secondOrderFunctional
    excessFromData
    linearSubspaceCase
///

doc ///
  Key
    secondOrderQuadrics
    (secondOrderQuadrics, CyclePair)
  Headline
    the quadrics on the excess directions that govern the second-order term for every coefficient
  Usage
    q = secondOrderQuadrics D
  Inputs
    D:CyclePair
  Outputs
    q:HashTable
      with keys "excessDirections", "dimEprime", "generators", "pairs", "values", "quadrics", "quadricMatrices",
      "rankOfQuadrics", "commonZeroLocusDim", "dimK", "conditionS", "eTau", "tau", "lambda0", "inRange", "sigmaPrime",
      "r", "normalisation", "label"
  Description
    Text
      Returns the values of $\rho(N N' tr(\dot M adj M)) - D_{\dot v}(N N' \det M)$, which by paper 3, Theorem 9.1(3),
      Theorem 9.4(2) and Proposition 9.4' (PROVED there; AI-written, unreviewed) equal
      $((k+1)/\kappa) Q_0(N,N')(Q(\dot v))$, for $N, N'$ in a basis of $E' = (0:_A \det M)_\tau$ and $\dot v$ running over
      virtual deformations with a single nonzero component: a monomial times a matrix unit ("M"), or a monomial in the
      place of one $f_i$, $h_j$, $p_l$, $s_l$ ("f", "h", "p", "s"). The corresponding forms $Q(\dot v)$ are
      $x^\alpha f_i h_j$, $x^\alpha g_i$, $x^\alpha q_j$, $x^\alpha s_l$, $x^\alpha p_l$; monomials are taken modulo the ideal on which the
      value depends, so the forms listed span $K$ modulo forms on which all quadrics vanish.
      The second-order term of $NL(\delta_\lambda)$ is $(\lambda-\lambda_0)/\lambda$ times these values, up to the
      constant stated under "normalisation".
      The residues are EXACT over the rational numbers and MOD p over a prime field.
    Example
      D = randomCyclePair(4, {1,1}, {1,1}, {1}, Seed => 3);
      q = secondOrderQuadrics D;
      (q#"tau", q#"dimEprime", q#"dimK", #(q#"generators"))
      q#"quadrics"
      q#"commonZeroLocusDim"
    Text
      Two planes meeting in a point on a quartic fourfold ($\tau = 0$, one excess direction): the single number $A$ of
      Theorem 8.1 of paper 3 is nonzero at this point.
  SeeAlso
    secondOrderObstruction
///

doc ///
  Key
    secondOrderFunctional
    (secondOrderFunctional, List, List)
  Headline
    the pointwise second-order period functional of a complete intersection (paper 3, Lemma 2.1(3))
  Usage
    L = secondOrderFunctional(phi, psi)
  Inputs
    phi:List
      of k+1 forms defining a complete intersection Y of dimension k
    psi:List
      of k+1 forms of positive degree with $F = \sum_i \phi_i \psi_i$ homogeneous of degree d
  Outputs
    L:Function
      which sends a form P of degree $(k+2)d-2k-2$ to
      $\sum_\nu Res[P/(\phi_0,\dots,\phi_\nu^2,\dots,\phi_k;\psi_0,\dots,\psi_\nu^2,\dots,\psi_k)]$
  Description
    Text
      By paper 3, Lemma 2.1(3) (PROVED there; AI-written, unreviewed) this sum equals
      $(k+1) \varphi_{[Y]}(P) / \kappa$, where $\varphi_{[Y]}(P) = \int_Y Res(P \Omega/F^{k+2})$ is the functional in the
      second-order term of the period functions and $\kappa$ is the nonzero constant with
      $\int_Y Res(P'\Omega/F^{k+1}) = \kappa Res[P'/(\phi;\psi)]$. Each symbol is normalised on its own sequence, see
      @TO grothendieckResidue@. Forms of other degrees are sent to 0. EXACT over the rational numbers, MOD p over
      a prime field.
    Text
      The values computed by hand in Remark 10.3(iii) of paper 3, for the line $x_0 = x_1$, $x_2 = x_3$ on the
      quartic surface $x_0^4 - x_1^4 + x_2^4 - x_3^4 = 0$:
    Example
      S = QQ[x_0..x_3];
      phi = {x_0 - x_1, x_2 - x_3};
      psi = {x_0^3 + x_0^2*x_1 + x_0*x_1^2 + x_1^3, x_2^3 + x_2^2*x_3 + x_2*x_3^2 + x_3^3};
      grothendieckResidue(x_0^2*x_2^2, phi | psi)
      L = secondOrderFunctional(phi, psi);
      L(x_0^6*x_2^2)
  SeeAlso
    secondOrderObstruction
    grothendieckResidue
///
