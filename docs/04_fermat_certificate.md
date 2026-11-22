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

```

i1 : needsPackage("HodgeLociCI", FileName => "../../M2/HodgeLociCI.m2");

i2 : file = "../../tests/data/fermat/cert_n6_lam-1.txt";

i3 : C = fermatReadCertificate file;

i4 : C#"degree", C#"dimension", C#"lambda", C#"label"

o4 = (3, 6, -1, EXACT over QQ(zeta_6))

o4 : Sequence

i5 : netList C#"spaces"

     +---------+---------+---------+---------+
o5 = |{0, 1, 1}|{2, 3, 1}|{4, 5, 1}|{6, 7, 1}|
     +---------+---------+---------+---------+
     |{0, 1, 3}|{2, 3, 3}|{4, 5, 3}|{6, 7, 1}|
     +---------+---------+---------+---------+

i6 : netList C#"arc"

     +--------------------------------------------------------------------------------+
o6 = |x x x  + x x x  + x x x  + x x x                                                |
     | 0 2 4    0 1 7    2 3 7    4 5 7                                               |
     +--------------------------------------------------------------------------------+
     |  1          1    1          1         1          1    1           1    1       |
     |- -x x x  + (-z - -)x x x  - -x x x  - -x x x  + (-z - -)x x x  + (-z - -)x x x |
     |  3 0 2 6    3    3  0 3 6   3 0 4 6   3 2 4 6    3    3  0 5 6    3    3  2 5 6|
     +--------------------------------------------------------------------------------+
     |0                                                                               |
     +--------------------------------------------------------------------------------+
     |0                                                                               |
     +--------------------------------------------------------------------------------+

i7 : -- every checkable claim of the file is recomputed over Q(zeta_6)
     v = fermatVerifyCertificate C;

i8 : v#"pass", v#"vanishingOrder", v#"obstructionOrder"

o8 = (true, 4, 5)

o8 : Sequence

i9 : netList(v#"checks", Alignment => Left)

     +------------------------------------------------------------------------------------------+----+
o9 = |the listed period polynomial equals sum c_i P_(L_i)                                       |true|
     +------------------------------------------------------------------------------------------+----+
     |the listed forms Q are the standard forms (as a set)                                      |true|
     +------------------------------------------------------------------------------------------+----+
     |the coefficients of eps^1..eps^4 vanish for all 8 forms                                   |true|
     +------------------------------------------------------------------------------------------+----+
     |T_1 is in the kernel of the first-order map L (tangent to the Hodge locus)                |true|
     +------------------------------------------------------------------------------------------+----+
     |T_1 is not in the kernel of L_P1 (not tangent to the locus where the first space persists)|true|
     +------------------------------------------------------------------------------------------+----+
     |rank L = 7                                                                                |true|
     +------------------------------------------------------------------------------------------+----+
     |rank [L_P1; L_P2] = 8                                                                     |true|
     +------------------------------------------------------------------------------------------+----+
     |the coefficients of eps^5 are as listed                                                   |true|
     +------------------------------------------------------------------------------------------+----+
     |the vector of coefficients of eps^5 is not in the image of L                              |true|
     +------------------------------------------------------------------------------------------+----+
     |functional 1: K.L = 0                                                                     |true|
     +------------------------------------------------------------------------------------------+----+
     |functional 1: K.c_5 is as listed and nonzero                                              |true|
     +------------------------------------------------------------------------------------------+----+

i10 : -- the same obstruction, recomputed from the arc alone: the order-5 system has no solution
      r = fermatNextOrderSystem(C#"periodPolynomial", C#"arc");

i11 : r#"order", r#"lowerOrdersVanish", r#"solvable", rank r#"matrix"

o11 = (5, true, false, 7)

o11 : Sequence

i12 : r#"obstruction"

o12 = | 9z-18 |

             /   QQ[z]    \1      /   QQ[z]    \1
o12 : Matrix |----------[]|  <--- |----------[]|
             | 2          |       | 2          |
             \z  - z + 1  /       \z  - z + 1  /

i13 : -- first-order numbers at this pair of planes (Movasati's pair (H,K) = (7,8))
      t = fermatTangentData(C#"ring", C#"spaces", C#"coefficients");

i14 : t#"jointPersistenceCodimension", t#"hodgeCodimension"

o14 = (8, 7)

o14 : Sequence

i15 : -- a corrupted certificate is rejected: one coefficient of T_2 changed from -1/3 to -1/2
      bad = temporaryFileName() | ".txt";

i16 : bad << replace("T_2 = \\[-1/3\\]", "T_2 = [-1/2]", get file) << close;

i17 : w = fermatVerifyCertificate bad; w#"pass", w#"firstFailingOrder"

o18 = (false, 2)

o18 : Sequence
```

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
