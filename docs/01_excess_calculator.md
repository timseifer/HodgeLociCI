# Worked example 1: the excess calculator on Movasati's cubic cases, and a case with shared equations of higher degree

> Status. This example and the package were written by AI agents and have not been reviewed by a human. The
> theorems of "paper 3" quoted in the output come from an AI-written manuscript that no human has refereed.
> Nothing here is, or bears on, a proof or disproof of the Hodge conjecture. The session below is a real captured
> Macaulay2 1.22 session (input `docs/sessions/01_excess_calculator.m2`, output `docs/sessions/01_excess_calculator.out`, pasted unchanged).

## What is computed

Let X = {F = 0} be a smooth hypersurface of degree d in P^(2k+1), and let Y1 = V(f, p), Y2 = V(h, p) be two
complete-intersection cycles of dimension k on X: c "own" equations f, resp. h, and k + 1 - c shared equations p, so
that Y1 and Y2 meet in dimension k - c. Write V_Z for the locus of hypersurfaces containing deformations of both
cycles, and NL(delta_lambda) for the Hodge locus of the class delta_lambda = [Y1] + lambda [Y2]. Always
V_Z is contained in NL(delta_lambda); the *excess* of lambda is dim T NL(delta_lambda) - dim T V_Z, a first-order
(Zariski tangent space) quantity.

`excessFromDegrees(d, deg f, deg h, deg p)` returns, from the degrees alone: the level
tau = sum(deg f_i + deg h_i) - (c-1)d, the special coefficient lambda0 = (-1)^(c-1), whether "the range"
(k-1)d + tau < 2k+2 holds, e_tau, the codimensions of V_1, V_2, V_Z (Hilbert functions of complete intersections), the
excess at lambda0 and, where the degrees determine it, at the other coefficients. `excessFromData` does the same
from explicit forms (f, h, p, M, s) with F = f^T M h + sum p_l s_l; `verifyExcess` compares with a direct
computation in the Jacobian ring; `fermatTangentData` computes the same first-order numbers at the Fermat point over
a cyclotomic field.

## Session

```

i1 : needsPackage("HodgeLociCI", FileName => "../../M2/HodgeLociCI.m2");

i2 : view = (t, ks) -> netList(apply(ks, k -> {k, t#k}), Alignment => Left);

i3 : ks = {"tau", "lambda0", "inRange", "eTau", "codimV1", "codimV2", "codimVZ", "excessAtLambda0", "codimNLAtLambda0", "excessElsewhere"};

i4 : -- (1) Movasati's cubic sixfold case: two 3-planes meeting in a point. Three own linear equations each, one shared.
     t6 = excessFromDegrees(3, {1,1,1}, {1,1,1}, {1});

i5 : view(t6, ks)

     +----------------+----+
o5 = |tau             |0   |
     +----------------+----+
     |lambda0         |1   |
     +----------------+----+
     |inRange         |true|
     +----------------+----+
     |eTau            |1   |
     +----------------+----+
     |codimV1         |4   |
     +----------------+----+
     |codimV2         |4   |
     +----------------+----+
     |codimVZ         |8   |
     +----------------+----+
     |excessAtLambda0 |1   |
     +----------------+----+
     |codimNLAtLambda0|7   |
     +----------------+----+
     |excessElsewhere |1   |
     +----------------+----+

i6 : t6#"levelDichotomy"

o6 = tau >= 0: NL(delta_lambda0) is smooth of codimension codim V_Z - e_tau, with e_tau excess tangent directions
     (Theorem 2(4))

i7 : t6#"label"

o7 = PROVED in paper 3 (AI-written, unreviewed), Theorem 2; integer arithmetic on the degrees only

i8 : -- (2) the cubic eightfold case: two 4-planes meeting in a line (two shared linear equations)
     t8 = excessFromDegrees(3, {1,1,1}, {1,1,1}, {1,1});

i9 : view(t8, ks)

     +----------------+----+
o9 = |tau             |0   |
     +----------------+----+
     |lambda0         |1   |
     +----------------+----+
     |inRange         |true|
     +----------------+----+
     |eTau            |1   |
     +----------------+----+
     |codimV1         |10  |
     +----------------+----+
     |codimV2         |10  |
     +----------------+----+
     |codimVZ         |20  |
     +----------------+----+
     |excessAtLambda0 |1   |
     +----------------+----+
     |codimNLAtLambda0|19  |
     +----------------+----+
     |excessElsewhere |1   |
     +----------------+----+

i10 : -- (3) the same numbers from data: a random smooth cubic sixfold through two such planes, modulo 32003
      D6 = randomCyclePair(3, {1,1,1}, {1,1,1}, {1}, Seed => 2026)

o10 = CyclePair{d = 3, k = 3, c = 3, deg f = {1, 1, 1}, deg h = {1, 1, 1}, deg p = {1}, tau = 0, lambda0 = 1, field = ZZ/32003, smooth = true}

o10 : CyclePair

i11 : e6 = excessFromData D6;

i12 : view(e6, {"eTau", "rankDetM", "dimAnnDetM", "codimVZ", "excessAtLambda0", "codimNLAtLambda0", "excessElsewhere"})

      +----------------+-+
o12 = |eTau            |1|
      +----------------+-+
      |rankDetM        |0|
      +----------------+-+
      |dimAnnDetM      |1|
      +----------------+-+
      |codimVZ         |8|
      +----------------+-+
      |excessAtLambda0 |1|
      +----------------+-+
      |codimNLAtLambda0|7|
      +----------------+-+
      |excessElsewhere |1|
      +----------------+-+

i13 : e6#"label"

o13 = Hilbert functions and the rank of .det M: MOD p (computed over ZZ/32003 at one instance: evidence, not a proof);
      their identification with the excess: PROVED in paper 3 (AI-written, unreviewed), Theorem 2 (needs X smooth)

i14 : -- Theorem 2 of paper 3 against a direct first-order computation in the Jacobian ring
      v6 = verifyExcess D6;

i15 : netList(prepend(v6#"tableColumns", v6#"table"), Alignment => Left)

      +------+-----------------------------+------------------------+
o15 = |lambda|excess predicted by Theorem 2|excess computed directly|
      +------+-----------------------------+------------------------+
      |1     |1                            |1                       |
      +------+-----------------------------+------------------------+
      |-1    |1                            |1                       |
      +------+-----------------------------+------------------------+
      |2     |1                            |1                       |
      +------+-----------------------------+------------------------+
      |3     |1                            |1                       |
      +------+-----------------------------+------------------------+
      |-2    |1                            |1                       |
      +------+-----------------------------+------------------------+
      |1     |                             |                        |
      |-     |1                            |1                       |
      |2     |                             |                        |
      +------+-----------------------------+------------------------+
      |5     |                             |                        |
      |-     |1                            |1                       |
      |3     |                             |                        |
      +------+-----------------------------+------------------------+

i16 : v6#"agrees"

o16 = true

i17 : -- (4) at the Fermat point, exactly over Q(zeta_6): Movasati's pairs (H,K) = (7,8) and (19,20)
      planes = (k, c) -> (apply(k+1, i -> {2*i, 2*i+1, 1}), apply(k+1, i -> {2*i, 2*i+1, if i < c then 3 else 1}));

i18 : S6 = fermatRing(3, 6); (P1, P2) = planes(3, 3);

i20 : f6 = fermatTangentData(S6, {P1, P2}, {1, 1});

i21 : view(f6, {"jointPersistenceCodimension", "hodgeCodimension", "excess"})

      +---------------------------+-+
o21 = |jointPersistenceCodimension|8|
      +---------------------------+-+
      |hodgeCodimension           |7|
      +---------------------------+-+
      |excess                     |1|
      +---------------------------+-+

i22 : f6#"label"

o22 = EXACT over QQ(zeta_6); COMPUTED ONLY (no proof claimed: assumes the period formula for linear spaces and
      Griffiths' pole-order description of the Hodge locus)

i23 : S8 = fermatRing(3, 8); (P1, P2) = planes(4, 3);

i25 : f8 = fermatTangentData(S8, {P1, P2}, {1, -1});

i26 : view(f8, {"jointPersistenceCodimension", "hodgeCodimension", "excess"})

      +---------------------------+--+
o26 = |jointPersistenceCodimension|20|
      +---------------------------+--+
      |hodgeCodimension           |19|
      +---------------------------+--+
      |excess                     |1 |
      +---------------------------+--+

i27 : f8#"label"

o27 = EXACT over QQ(zeta_6); COMPUTED ONLY (no proof claimed: assumes the period formula for linear spaces and
      Griffiths' pole-order description of the Hodge locus)

i28 : -- (5) shared equations of higher degree: two plane conics on a common quadric p = 0, on a sextic surface
      ts = excessFromDegrees(6, {1}, {1}, {2});

i29 : view(ts, ks)

      +----------------+----+
o29 = |tau             |2   |
      +----------------+----+
      |lambda0         |1   |
      +----------------+----+
      |inRange         |true|
      +----------------+----+
      |eTau            |2   |
      +----------------+----+
      |codimV1         |5   |
      +----------------+----+
      |codimV2         |5   |
      +----------------+----+
      |codimVZ         |10  |
      +----------------+----+
      |excessAtLambda0 |2   |
      +----------------+----+
      |codimNLAtLambda0|8   |
      +----------------+----+
      |excessElsewhere |2   |
      +----------------+----+

i30 : Ds = randomCyclePair(6, {1}, {1}, {2}, Seed => 2026)

o30 = CyclePair{d = 6, k = 1, c = 1, deg f = {1}, deg h = {1}, deg p = {2}, tau = 2, lambda0 = 1, field = ZZ/32003, smooth = true}

o30 : CyclePair

i31 : vs = verifyExcess Ds;

i32 : netList(prepend(vs#"tableColumns", vs#"table"), Alignment => Left)

      +------+-----------------------------+------------------------+
o32 = |lambda|excess predicted by Theorem 2|excess computed directly|
      +------+-----------------------------+------------------------+
      |1     |2                            |2                       |
      +------+-----------------------------+------------------------+
      |-1    |2                            |2                       |
      +------+-----------------------------+------------------------+
      |2     |2                            |2                       |
      +------+-----------------------------+------------------------+
      |3     |2                            |2                       |
      +------+-----------------------------+------------------------+
      |-2    |2                            |2                       |
      +------+-----------------------------+------------------------+
      |1     |                             |                        |
      |-     |2                            |2                       |
      |2     |                             |                        |
      +------+-----------------------------+------------------------+
      |5     |                             |                        |
      |-     |2                            |2                       |
      |3     |                             |                        |
      +------+-----------------------------+------------------------+

i33 : -- (6) a quartic fourfold, a plane and a quadric surface with one shared linear equation (c = 2)
      tq = excessFromDegrees(4, {1,1}, {1,2}, {1});

i34 : view(tq, ks)

      +----------------+----+
o34 = |tau             |1   |
      +----------------+----+
      |lambda0         |-1  |
      +----------------+----+
      |inRange         |true|
      +----------------+----+
      |eTau            |2   |
      +----------------+----+
      |codimV1         |6   |
      +----------------+----+
      |codimV2         |8   |
      +----------------+----+
      |codimVZ         |14  |
      +----------------+----+
      |excessAtLambda0 |2   |
      +----------------+----+
      |codimNLAtLambda0|12  |
      +----------------+----+
      |excessElsewhere |2   |
      +----------------+----+
```

## Reading the output

| quantity | cubic sixfold, 3-planes meeting in a point | cubic eightfold, 4-planes meeting in a line | label |
|---|---|---|---|
| codim V_Z (`codimVZ`) | 8 | 20 | EXACT (integer arithmetic on the degrees) |
| excess, every lambda != 0 | 1 | 1 | PROVED in paper 3, Theorem 2(2) (AI-written, unreviewed); checked MOD p at one random sixfold (`verifyExcess`) |
| tangent codimension of the Hodge locus at the Fermat point (`hodgeCodimension`) | 7 | 19 | EXACT over Q(zeta_6); COMPUTED ONLY (assumes the period formula for linear spaces and Griffiths' description of the Hodge locus) |

- The pairs (7, 8) and (19, 20) are the entries (H, K) of Table 1 of H. Movasati, "Why should one compute periods of
  algebraic cycles?" (arXiv:1602.06607) for n = 6, m = 0 and n = 8, m = 1, and the rows dim(S), codim(V^1) of Table 2
  of his "Hodge cycles for cubic hypersurfaces" (arXiv:1902.00831). Those papers were read by machine only; see
  `tests/SOURCES.md`, entries A1 and A2, and validation tests 01, 03, 15.
- These are FIRST-ORDER numbers. `codimNLAtLambda0 = 7` (resp. 19) is, by Theorem 2(4) of paper 3, the codimension of
  the Hodge locus itself at the coefficient lambda0 = +1 (the sum of the two classes). For the other coefficients
  the tangent space is equally large, but whether the locus is larger than V_Z is a second-order question: see
  worked example 3. The package does not decide Movasati's Conjecture 1 (arXiv:2211.11405); what the session's
  unreviewed work says about it is recorded in `tests/SOURCES.md`, entry E8.
- Shared equations of higher degree (step 5): two plane conics Y1 = V(f, p), Y2 = V(h, p) on the same quadric p = 0,
  lying on a sextic surface. Here tau = 2, e_tau = 2: codim V_Z = 10 and the Hodge locus of [Y1] + [Y2] has
  codimension 8; in the range the excess is 2 for every coefficient, and the direct computation agrees (MOD p).
- Step 6 shows a mixed type (a plane and a quadric surface on a quartic fourfold): lambda0 = -1 because c = 2.

Regenerate, from the repository root: `python3 docs/build_docs.py --run` re-runs all five sessions and rebuilds
all five pages. For this session alone, also from the repository root:
`(cd docs/sessions && M2 --silent --no-readline --print-width 118 < 01_excess_calculator.m2 > 01_excess_calculator.out) && python3 docs/build_docs.py`.
