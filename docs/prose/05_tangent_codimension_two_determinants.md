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

{{SESSION}}

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
