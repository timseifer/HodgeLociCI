# Worked example 3: the second-order checker on cases where the excess directions die

> Status. This example and the package were written by AI agents and have not been reviewed by a human. The
> theorems of "paper 3" quoted in the output come from an AI-written manuscript that no human has refereed.
> Nothing here is, or bears on, a proof or disproof of the Hodge conjecture. The session below is a real captured
> Macaulay2 1.22 session (input `docs/sessions/03_second_order.m2`, output `docs/sessions/03_second_order.out`, pasted unchanged).

## What is computed

When the excess of lambda is positive, the Zariski tangent space of the Hodge locus NL(delta_lambda) is larger than
that of V_Z, and the question is whether the locus itself is larger or whether it is V_Z with a non-reduced
structure. `secondOrderObstruction(D, lambda)` evaluates the second-order term of the period equations on the excess
directions (paper 3, Theorems 9.1 and 9.4: a system of quadrics on the space E' of excess directions, multiplied by
(lambda - lambda0)/lambda) and reports one of four verdicts

- `NO EXCESS`: there are no excess directions for this lambda (tau < 0, or the annihilator of det M in A_tau is
  zero); nothing is computed at second order, and the label of the result says so;
- `ALL DIE`: the quadrics have no common zero, every excess direction is obstructed at second order;
- `SOME DIE`: the quadrics are not all zero but have common zeros (nothing is decided on those directions);
- `ALL SURVIVE`: the second-order term vanishes (always the case at lambda0; nothing is decided about higher order).

## Session

```

i1 : needsPackage("HodgeLociCI", FileName => "../../M2/HodgeLociCI.m2");

i2 : -- a cubic sixfold through two 3-planes meeting in a line: tau = 1, lambda0 = -1, two excess directions for every lambda
     D = randomCyclePair(3, {1,1}, {1,1}, {1,1}, Seed => 7)

o2 = CyclePair{d = 3, k = 3, c = 2, deg f = {1, 1}, deg h = {1, 1}, deg p = {1, 1}, tau = 1, lambda0 = -1, field = ZZ/32003, smooth = true}

o2 : CyclePair

i3 : apply({-1, 2, 5/3}, l -> (tangentExcess(D, l))#"excess")

o3 = {2, 2, 2}

o3 : List

i4 : -- second order at lambda = 2: do the two excess directions survive?
     so = secondOrderObstruction(D, 2);

i5 : so#"verdict", so#"excess", so#"dimK", so#"rankOfQuadrics", so#"commonZeroLocusDim"

o5 = (ALL DIE, 2, 2, 2, -1)

o5 : Sequence

i6 : so#"quadrics"

           2               2    2
o6 = {8811n  + 2n n , 5384n  + n }
           0     0 1       0    1

o6 : List

i7 : so#"statement"

o7 = the quadrics N -> Q_0(N,N)(Q), Q in K, have no common zero in P(E'): every excess direction is obstructed at
     second order; the reduction of NL(delta_lambda) is V_Z and NL(delta_lambda) is non-reduced along V_Z near X
     (PROVED in paper 3 (AI-written, unreviewed), Theorem 9.1(4))

i8 : so#"label"

o8 = second-order term: residues MOD p (computed over ZZ/32003 at one instance: evidence, not a proof); formulas:
     PROVED in paper 3 (AI-written, unreviewed), Theorem 9.1(3), Theorem 9.4(2), Proposition 9.4'

i9 : -- the same question answered by the pointwise residue formula as well
     (secondOrderObstruction(D, 5/3, Strategy => "Both"))#"strategiesAgree"

o9 = true

i10 : -- at lambda0 = -1 nothing is obstructed
      s0 = secondOrderObstruction(D, -1); s0#"verdict"

o11 = ALL SURVIVE

i12 : s0#"statement"

o12 = lambda = lambda0: the e_tau excess directions N det M are tangent to arcs F - t N det M inside
      NL(delta_lambda0), which is smooth of codimension codim V_Z - e_tau (PROVED in paper 3 (AI-written, unreviewed),
      Theorem 1 and Theorem 2(4)); the second-order term vanishes identically by the factor (lambda - lambda0)/lambda

i13 : -- Maclean's example, exactly over QQ: two coplanar lines on a quintic surface (k = 1, c = 1; the plane is shared)
      Dq = randomCyclePair(5, {1}, {1}, {1}, CoefficientRing => QQ, Seed => 7)

o13 = CyclePair{d = 5, k = 1, c = 1, deg f = {1}, deg h = {1}, deg p = {1}, tau = 2, lambda0 = 1, field = QQ, smooth = true}

o13 : CyclePair

i14 : (tangentExcess(Dq, 2))#"codimTVZ", (tangentExcess(Dq, 2))#"codimTNL"

o14 = (4, 3)

o14 : Sequence

i15 : sq = secondOrderObstruction(Dq, 2); sq#"verdict", sq#"values", sq#"arithmetic"

                     8181
o16 = (ALL DIE, {{- ------}}, EXACT (computed over QQ))
                    434281

o16 : Sequence

i17 : (secondOrderObstruction(Dq, 1))#"verdict"

o17 = ALL SURVIVE
```

## Reading the output

- Cubic sixfold through two 3-planes meeting in a line (Movasati's "cubic ruled cycle" configuration): two excess
  directions for every coefficient; at lambda = 2 the two quadrics (written in coordinates n_0, n_1 on E') have no
  common zero, so both directions die: the Hodge locus is V_Z with a non-reduced structure near this X. At
  lambda0 = -1 (the difference of the two classes) nothing is obstructed and the locus is smooth of codimension
  8 - 2 = 6. Labels: the residues are computed MOD p at one random instance; the formulas and the conclusion drawn
  from them are PROVED only in paper 3 (AI-written, unreviewed). The "formula" and "pointwise" strategies, which use
  different residue formulas, agree.
- Two coplanar lines on a quintic surface, EXACT over QQ: tangent codimension 3 against codim V_Z = 4, and the
  single excess direction dies for lambda = 2 (second-order value -8181/434281 != 0 at this instance) but
  survives at lambda = 1. This is the non-reduced component of the Noether-Lefschetz locus of quintic surfaces found
  by C. Maclean (Asian J. Math. 9 (2005); the article itself could not be opened: `tests/SOURCES.md`, entry D).
- What is NOT shown: `ALL DIE` at one random instance modulo a prime is evidence about a general hypersurface, not
  a proof; and at special points (for instance the Fermat hypersurface) the second-order term can vanish.

Regenerate, from the repository root: `python3 docs/build_docs.py --run` re-runs all five sessions and rebuilds
all five pages. For this session alone, also from the repository root:
`(cd docs/sessions && M2 --silent --no-readline --print-width 118 < 03_second_order.m2 > 03_second_order.out) && python3 docs/build_docs.py`.
