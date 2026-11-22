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
(lambda - lambda0)/lambda) and reports one of

- `ALL DIE`: the quadrics have no common zero, every excess direction is obstructed at second order;
- `SOME DIE`: the quadrics are not all zero but have common zeros (nothing is decided on those directions);
- `ALL SURVIVE`: the second-order term vanishes (always the case at lambda0; nothing is decided about higher order).

## Session

{{SESSION}}

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

Regenerate: `cd docs/sessions && M2 --silent --no-readline --print-width 118 < 03_second_order.m2 > 03_second_order.out`, then
`python3 docs/build_docs.py` (or `python3 docs/build_docs.py --run` for all sessions at once).
