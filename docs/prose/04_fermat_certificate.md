# Worked example 4: verifying a Fermat certificate

> Status. This example and the package were written by AI agents and have not been reviewed by a human. The
> theorems of "paper 3" quoted in the output come from an AI-written manuscript that no human has refereed.
> Nothing here is, or bears on, a proof or disproof of the Hodge conjecture. The session below is a real captured
> Macaulay2 1.22 session (input `docs/sessions/04_fermat_certificate.m2`, output `docs/sessions/04_fermat_certificate.out`, pasted unchanged).

## What is computed

At the Fermat hypersurface the periods of linear cycles are known in closed form, and the Taylor expansion of the
equations of a Hodge locus along an arc F_0 - (eps T_1 + eps^2 T_2 + ...) can be computed exactly over Q(zeta_2d).
A *certificate* is a text file listing: two linear subspaces P1, P2 of the Fermat variety, a coefficient lambda, an
arc, the claim that all equations of the Hodge locus of [P1] + lambda [P2] vanish along the arc to some order N - 1,
the coefficients c_N of eps^N, and a functional K with K.L = 0 (L the first-order map) and K.c_N != 0: an
obstruction at order N. `fermatVerifyCertificate` recomputes every such claim.

The file used here, `tests/data/fermat/cert_n6_lam-1.txt`, was exported by the research session (Fermat cubic
sixfold, two 3-planes meeting in a point, lambda = -1; obstruction at order 5).

## Session

{{SESSION}}

## Reading the output

- All eleven checks hold, EXACTLY over Q(zeta_6): the arc is tangent to the Hodge locus and not to V_Z, the
  equations vanish to order 4, and the order-5 coefficient vector is not in the image of L (rank L = 7 against 8 for
  the pair of planes: Movasati's pair (H, K) = (7, 8)).
- `fermatNextOrderSystem` finds the same obstruction from the arc alone: the order-5 linear system is not solvable,
  and the obstruction value 9z - 18 is the value K.c_5 = (-18) + (9) z listed in the file.
- A file with one changed coefficient is rejected, with the first failing order reported.
- What the certificate does and does not show. It is a statement about ONE arc. The session's conclusion "the Hodge
  locus has no component of dimension dim V_Z + 1 through the Fermat point for this lambda" needs in addition
  Griffiths' description of the Hodge locus by these period functions, the period formula for linear cycles and
  the smoothness of V_Z (see the README shipped next to the data, and `tests/SOURCES.md`, entry E8). That conclusion
  is an unreviewed AI result which differs from the dimension claim of Movasati's Conjecture 1 (arXiv:2211.11405); it
  must not be presented as a refutation.

Regenerate: `cd docs/sessions && M2 --silent --no-readline --print-width 118 < 04_fermat_certificate.m2 > 04_fermat_certificate.out`, then
`python3 docs/build_docs.py` (or `python3 docs/build_docs.py --run` for all sessions at once).
