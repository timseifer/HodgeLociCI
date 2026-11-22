# Worked example 5: first-order tangent codimension of the Hodge locus of an explicit subvariety (a sum of two determinants)

> Status. This example and the package were written by AI agents and have not been reviewed by a human. The
> theorems of "paper 3" quoted in the output come from an AI-written manuscript that no human has refereed.
> Nothing here is, or bears on, a proof or disproof of the Hodge conjecture. The session below is a real captured
> Macaulay2 1.22 session (input `docs/sessions/05_tangent_codimension_two_determinants.m2`, output `docs/sessions/05_tangent_codimension_two_determinants.out`, pasted unchanged).

## What is computed

For a smooth hypersurface X = {F = 0} of degree d in P^(2k+1) and a subvariety Z of dimension k of X with ideal I,
`hodgeLocusTangentCodim(F, I)` computes the codimension in S_d of ((I + J) : m^e)_d, where J is the Jacobian ideal of
F and e = kd - 2k - 2. If (I + J) has codimension one in degree (k+1)(d-2) (key `"codimIJ"` equal to 1, reported as
`"hypothesis"`), the period functional of the class of Z spans the annihilator of that space, and the number
returned is the codimension of the Zariski tangent space of the Hodge locus of [Z], provided the primitive class of
Z is nonzero.

Here X is a cubic sixfold of the form F = det A + det B with A, B two 3x3 matrices of linear forms in 8 variables,
and Z = T is the threefold where the first two rows of A are proportional and the first two rows of B are
proportional. T lies on X because each determinant vanishes when two of its rows are proportional.

## Session

```

i1 : needsPackage("HodgeLociCI", FileName => "../../M2/HodgeLociCI.m2");

i2 : S = ZZ/32003[x_0..x_7];

i3 : setRandomSeed 2026;

i4 : -- a cubic sixfold F = det A + det B with A, B random 3x3 matrices of linear forms
     A = random(S^3, S^{3:-1}); B = random(S^3, S^{3:-1});

             3       3
o4 : Matrix S  <--- S

             3       3
o5 : Matrix S  <--- S

i6 : F = det A + det B;

i7 : isSmoothHypersurface F

o7 = true

i8 : -- the threefold T where rows 1, 2 of A are proportional and rows 1, 2 of B are proportional
     IT = minors(2, A^{0,1}) + minors(2, B^{0,1});

o8 : Ideal of S

i9 : dim IT - 1, degree IT, F % IT == 0

o9 = (3, 9, true)

o9 : Sequence

i10 : -- first-order tangent codimension of the Hodge locus of the class of T
      t = hodgeLocusTangentCodim(F, IT);

i11 : t#"codim", t#"codimIJ", t#"hypothesis", t#"exponent"

o11 = (8, 1, true, 1)

o11 : Sequence

i12 : t#"label"

o12 = codimension of ((I + J) : m^e)_d in S_d, MOD p (computed over ZZ/32003 at one instance: evidence, not a proof);
      it is the tangent codimension of the Hodge locus of the class PROVIDED the primitive class is nonzero (then the
      period functional spans the annihilator of (I+J)_t)

i13 : -- for comparison: the codimension of (I(T) + J)_3 (cubics containing T, up to first-order changes of coordinates),
      -- and the codimension of the tangent space of the family {det A + det B} (cubics in the ideal of all 2x2 minors)
      J = ideal jacobian matrix{{F}};

o13 : Ideal of S

i14 : hilbertFunction(3, IT + J), hilbertFunction(3, minors(2, A) + minors(2, B))

o14 = (13, 8)

o14 : Sequence

i15 : -- the Hodge number h^(4,2) of a cubic sixfold: no Hodge locus has more than 8 local equations
      primitiveHodgeNumbers(6, 3)

o15 = {0, 0, 8, 70, 8, 0, 0}

o15 : List

i16 : -- the same tool on a 3-plane in a cubic sixfold (a linear cycle): codimension binomial(6,3) - 16 = 4
      D = randomCyclePair(3, {1}, {1}, {1,1,1}, Seed => 2026);

i17 : (hodgeLocusTangentCodim(D#"F", ideal(D#"f" | D#"p")))#"codim"

o17 = 4
```

## Reading the output

- T has dimension 3 and degree 9 and lies on X; (I(T) + J) has codimension 1 in degree 4, so the hypothesis holds.
- The Hodge locus of [T] has tangent codimension 8 (MOD p, one random instance). The family of cubics
  det A + det B has a tangent space of the same codimension 8 (the cubics in the ideal of the 2x2 minors of A and
  of B). Since the family is contained in the Hodge locus and h^(4,2) = 8 bounds the number of local equations, this
  is consistent with the session's statement that near a general member the Hodge locus of [T] is the family of sums
  of two determinants (ledger entry [CHECK C13]; COMPUTED ONLY, modulo primes, unreviewed).
- The number 13 is the codimension of (I(T) + J)_3, the first-order deformations of X that still contain T up to a
  projective change of coordinates. It is larger than 8 because T also moves with A and B: every cubic
  det A + det B contains such a threefold.
- The last step applies the same function to a linear cycle: a 3-plane on a cubic sixfold gives
  binomial(6,3) - 16 = 4, the number of Movasati and Villaflor Loyola for linear cycles (`tests/SOURCES.md`, C2).

Regenerate: `cd docs/sessions && M2 --silent --no-readline --print-width 118 < 05_tangent_codimension_two_determinants.m2 > 05_tangent_codimension_two_determinants.out`, then
`python3 docs/build_docs.py` (or `python3 docs/build_docs.py --run` for all sessions at once).
