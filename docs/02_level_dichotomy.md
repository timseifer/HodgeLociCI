# Worked example 2: the level dichotomy, on both sides

> Status. This example and the package were written by AI agents and have not been reviewed by a human. The
> theorems of "paper 3" quoted in the output come from an AI-written manuscript that no human has refereed.
> Nothing here is, or bears on, a proof or disproof of the Hodge conjecture. The session below is a real captured
> Macaulay2 1.22 session (input `docs/sessions/02_level_dichotomy.m2`, output `docs/sessions/02_level_dichotomy.out`, pasted unchanged).

## What is computed

In the setting of worked example 1 the *level* is tau = sum(deg f_i + deg h_i) - (c-1)d = d - deg det M.
(It is not the Hodge level of X, which the separate helper `hodgeLevel` returns.) The dichotomy stated in paper 3,
Theorem 2 (AI-written, unreviewed), is:

- tau < 0: no excess; the Hodge locus of [Y1] + lambda [Y2] equals V_Z for every lambda != 0. For two linear cycles
  this is the condition m < n/2 - d/(d-2) of Villaflor Loyola (arXiv:1812.03964, Theorem 3) and the inequality of
  Kloosterman's Theorem 1.5 (arXiv:2312.12363).
- tau >= 0: at lambda0 = (-1)^(c-1) the Hodge locus is smooth of codimension codim V_Z - e_tau, strictly larger than
  V_Z (when e_tau > 0). At the other coefficients the excess is e_tau in "the range" (k-1)d + tau < 2k+2, and
  dim (0 :_A det M)_tau outside it, which depends on the hypersurface and not only on the degrees.

## Session

```

i1 : needsPackage("HodgeLociCI", FileName => "../../M2/HodgeLociCI.m2");

i2 : ones = n -> toList(n : 1);

i3 : -- the Hodge level of a cubic sixfold (a separate helper; it is not the level tau below)
     primitiveHodgeNumbers(6, 3), hodgeLevel(6, 3)

o3 = ({0, 0, 8, 70, 8, 0, 0}, 2)

o3 : Sequence

i4 : -- two 3-planes on a cubic sixfold meeting in dimension 3 - c, for c = 1, 2, 3, 4: the level tau = 2c - (c-1)d
     rows = for c from 1 to 4 list (
         t := excessFromDegrees(3, ones c, ones c, ones(4-c));
         {c, t#"tau", t#"lambda0", t#"eTau", t#"codimVZ", t#"codimNLAtLambda0", t#"excessElsewhere"});

i5 : netList(prepend({"c", "tau", "lambda0", "e_tau", "codim V_Z", "codim NL at lambda0", "excess elsewhere"}, rows), Alignment => Left)

     +-+---+-------+-----+---------+-------------------+----------------+
o5 = |c|tau|lambda0|e_tau|codim V_Z|codim NL at lambda0|excess elsewhere|
     +-+---+-------+-----+---------+-------------------+----------------+
     |1|2  |1      |3    |7        |4                  |NotDetermined   |
     +-+---+-------+-----+---------+-------------------+----------------+
     |2|1  |-1     |2    |8        |6                  |2               |
     +-+---+-------+-----+---------+-------------------+----------------+
     |3|0  |1      |1    |8        |7                  |1               |
     +-+---+-------+-----+---------+-------------------+----------------+
     |4|-1 |-1     |0    |8        |8                  |0               |
     +-+---+-------+-----+---------+-------------------+----------------+

i6 : -- the two sides of the dichotomy, as the package states them
     (excessFromDegrees(3, ones 4, ones 4, {}))#"levelDichotomy"

o6 = tau < 0: no excess; NL(delta_lambda) = V_Z for every lambda != 0 (Theorem 2(3))

i7 : (excessFromDegrees(3, ones 3, ones 3, ones 1))#"levelDichotomy"

o7 = tau >= 0: NL(delta_lambda0) is smooth of codimension codim V_Z - e_tau, with e_tau excess tangent directions
     (Theorem 2(4))

i8 : -- side tau < 0, checked directly: two disjoint 3-planes on a random cubic sixfold (mod 32003)
     Dneg = randomCyclePair(3, ones 4, ones 4, {}, Seed => 5)

o8 = CyclePair{d = 3, k = 3, c = 4, deg f = {1, 1, 1, 1}, deg h = {1, 1, 1, 1}, deg p = {}, tau = -1, lambda0 = -1, field = ZZ/32003, smooth = true}

o8 : CyclePair

i9 : apply({1, -1, 2, 5/3}, l -> (tangentExcess(Dneg, l))#"excess")

o9 = {0, 0, 0, 0}

o9 : List

i10 : -- side tau >= 0, checked directly: two 3-planes meeting in a point
      Dpos = randomCyclePair(3, ones 3, ones 3, ones 1, Seed => 5)

o10 = CyclePair{d = 3, k = 3, c = 3, deg f = {1, 1, 1}, deg h = {1, 1, 1}, deg p = {1}, tau = 0, lambda0 = 1, field = ZZ/32003, smooth = true}

o10 : CyclePair

i11 : apply({1, -1, 2, 5/3}, l -> (tangentExcess(Dpos, l))#"excess")

o11 = {1, 1, 1, 1}

o11 : List

i12 : (tangentExcess(Dpos, 2))#"label"

o12 = linear algebra MOD p (computed over ZZ/32003 at one instance: evidence, not a proof); input: the period
      polynomials det Jac(phi_0,psi_0,...) in the Jacobian ring (period formula for complete intersections; Theorem 2
      of paper 3 is not used)

i13 : -- outside "the range" the degrees do not determine the excess away from lambda0: cubic tenfolds, two 5-planes
      -- meeting in a plane (the case of Kloosterman's Theorem 1.2)
      t10 = excessFromDegrees(3, ones 3, ones 3, ones 3);

i14 : t10#"tau", t10#"inRange", t10#"excessAtLambda0", t10#"excessElsewhere", t10#"excessElsewhereBounds"

o14 = (0, false, 1, NotDetermined, (0, 1))

o14 : Sequence

i15 : -- at a random point the excess away from lambda0 = 1 is 0 ...
      D10 = randomCyclePair(3, ones 3, ones 3, ones 3, Seed => 5)

o15 = CyclePair{d = 3, k = 5, c = 3, deg f = {1, 1, 1}, deg h = {1, 1, 1}, deg p = {1, 1, 1}, tau = 0, lambda0 = 1, field = ZZ/32003, smooth = true}

o15 : CyclePair

i16 : e10 = excessFromData D10; e10#"eTau", e10#"rankDetM", e10#"excessAtLambda0", e10#"excessElsewhere"

o17 = (1, 1, 1, 0)

o17 : Sequence

i18 : -- ... and at the Fermat point it is 1 for every coefficient (Movasati's pair (38,39)), exactly:
      S10 = fermatRing(3, 10);

i19 : P1 = apply(6, i -> {2*i, 2*i+1, 1}); P2 = apply(6, i -> {2*i, 2*i+1, if i < 3 then 3 else 1});

i21 : f10 = fermatTangentData(S10, {P1, P2}, {1, 2}); f10#"jointPersistenceCodimension", f10#"hodgeCodimension", f10#"label"

o22 = (39, 38, EXACT over QQ(zeta_6))

o22 : Sequence

i23 : -- the classification for two linear subspaces at a general point (paper 3, Theorem 9.7)
      (linearSubspaceCase(3, 3, 4))#"statement"

o23 = NL([Pi_1] + lambda [Pi_2]) = V_Z for every lambda != 0, at every smooth X (Theorem 9.7(1))

i24 : (linearSubspaceCase(3, 3, 3))#"statement"

o24 = for lambda not in {0, lambda0}: at a general X the locus is V_Z with a non-reduced structure and 1 excess
      tangent direction(s); it is non-reduced at every smooth X (Theorem 9.7(3), Table 1; second-order statement:
      Corollary 8.2)

i25 : (linearSubspaceCase(3, 5, 3))#"statement"

o25 = for lambda not in {0, lambda0} and X general among the smooth hypersurfaces containing two such planes:
      NL([Pi_1] + lambda [Pi_2]) = V_Z as schemes (Theorem 9.7(3)); at special X the excess can be larger
```

## Reading the output

- The table (step 5) runs through the four ways two 3-planes can meet on a cubic sixfold: in a plane (c = 1,
  tau = 2), a line (c = 2, tau = 1), a point (c = 3, tau = 0), or not at all (c = 4, tau = -1). Labels: EXACT
  (integers); `NotDetermined` is returned instead of a guess where the degrees do not determine the answer.
- tau < 0 side: at a random cubic sixfold through two disjoint 3-planes the excess is 0 for all four coefficients
  tried (MOD p, one instance; direct linear algebra in the Jacobian ring, Theorem 2 not used).
- tau >= 0 side: with the planes meeting in a point the excess is 1 for all four coefficients (MOD p).
- Outside the range (steps 13 to 22): for two 5-planes meeting in a plane on a cubic tenfold, the excess away from
  lambda0 is 0 at a random point (MOD p; by Hilbert functions and the rank of multiplication by det M, PROVED only in
  paper 3) and 1 at the Fermat point (EXACT over Q(zeta_6): codimensions 39 and 38, Movasati's pair (38, 39)).
  This is the phenomenon of Kloosterman's Theorem 1.2; validation test 04 checks the random-point statement by a
  direct first-order computation.
- `linearSubspaceCase` quotes the classification of paper 3, Theorem 9.7, which is a statement about a GENERAL
  hypersurface containing the two planes.

Regenerate: `cd docs/sessions && M2 --silent --no-readline --print-width 118 < 02_level_dichotomy.m2 > 02_level_dichotomy.out`, then
`python3 docs/build_docs.py` (or `python3 docs/build_docs.py --run` for all sessions at once).
