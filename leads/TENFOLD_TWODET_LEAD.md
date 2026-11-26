# Cubic tenfolds l_1 Q_1 + l_2 Q_2 + det A + det B: the family, its fivefold and its class (26 Nov 2026)

AI-written, not reviewed by a mathematician. Labels: EXACT / MOD p / ARG / LIT / OPEN. Finite-field runs are
evidence, not proofs. Nothing here is a statement about the Hodge conjecture: every class below is the class of an
algebraic cycle. Pre-registration, scripts and logs: `leads/tenfold_twodet/`. Registry:
D-TENFOLD-TWO-DETERMINANT-FAMILY, D-TENFOLD-TWO-DET-CLASS, D-TENFOLD-TWO-DET-HODGE-LOCUS.

Earlier work this continues: the families det A + det B on sixfolds and l Q + det A + det B on eightfolds of the
teams T2 and T3 (D-TWO-DET-FAMILY-NUMBERS, D-EIGHTFOLD-FAMILY-TD: the fourfold T4, its Hodge locus, and the exact
count T4.T4 = 51 on the Fermat eightfold, which is the method of section 2 here).

## 0. Answer to the owner's question

- **The class.** The family carries the fivefold T5 = {l_1 = l_2 = 0} n {rows 1, 2 of A proportional} n
  {rows 1, 2 of B proportional}, of degree 9, with **T5.T5 = -21** (EXACT on the Fermat tenfold; the same number
  from the 72 nodes by D-NODES-DISCRIMINANT-IDENTITY, MOD p). The class is delta_2 = [T5] - 3 h^5: orthogonal to
  h^5, of norm **-48**, primitive, of divisibility 1 (EXACT on the Fermat tenfold).
- **Orbit.** [P1] - [P2] for two 5-planes meeting in a P^2 has the same three invariants, so delta_2 is in its
  monodromy orbit (ARG, by Eichler's criterion; the two literature statements used were machine-read in secondary
  sources on 26 Nov, see section 3).
- **Hodge locus.** The family is a reduced component, of codimension 52, of the Hodge locus of delta_2 (ARG on
  MOD p numbers; the package's first-order routine gives 52 at two primes).
- **But at the Fermat point it is not a two-plane class** (EXACT): there delta_2 is a second difference of four
  planes, and no two Fermat planes have it as their difference. The same holds on the Fermat sixfold and eightfold
  for the earlier families, so this says nothing about V_Z elsewhere.
- **OPEN:** whether the closure of the family meets V_Z (two 5-planes meeting in a P^2) at a point where the class
  is [P1] - [P2], as the sixfold family does along the divisor D of D-CUBIC-SIXFOLD-DETC. If it does at a point
  whose Hodge lattice has rank 3, the class there is automatically +-([P1] - [P2]).

So on tenfolds there are now three different families for the same orbit of classes: V_Z (codimension 39), this
one (52) and the Coble family (54). At the Fermat point the class of the Coble family is the three-plane class
kappa of C-TENFOLD-FERMAT-POINT-CLASS; the same exact count gives kappa^2 = -48, primitive, divisibility 1 (values of
kappa . P: 0, +-1, +-2, +-4, +-8, +-16), so it is in the same orbit too (ARG as in section 3).

## 1. The general member (MOD 32003 and 31991)

`td1_general_member.m2`, and `pairing/pr16_tenfold_twodet.m2` of the Coble folder for the first three lines.

| | value |
|---|---|
| the two rank <= 1 loci in the P^9 | a curve of degree 36, genus 37 |
| hyperplane section through the P^9 | 72 ordinary double points, 71 conditions on quartics |
| tangent space of the family | codimension 52 |
| S / (l_1, l_2, Q_1, Q_2, I_2(A), I_2(B)) | 1, 10, 35, 52, 35, 10, 1 |
| T5 | dimension 5, degree 9, in X; contains the 72 nodes and is smooth at each |
| S / (I(T5) + J) | 1, 10, 37, 52, 35, 10, 1, 0 |
| package: hodgeLocusTangentCodim(F, I(T5)) | 52 |

Since T5 is smooth at the 72 nodes, D-NODES-DISCRIMINANT-IDENTITY gives 3 T5.T5 - 81 = -2 x 72, T5.T5 = -21.

Component (ARG). I = (l_1, l_2, Q_1, Q_2, I_2(A), I_2(B)) contains the Jacobian ideal; S/I is Gorenstein with
socle in degree 6; I_3 is the tangent space of the family, along which T5 stays algebraic, so I_3 is in the
annihilator of the class, and then I is (f lies in the annihilator in degree j iff f S_(3-j) does in degree 3);
a Gorenstein quotient of socle degree 6 has no proper quotient with the same socle degree, so I is the annihilator.
Hence the first-order Hodge locus of the class has codimension 52 and equals the tangent space of the family.

## 2. The Fermat tenfold (EXACT; `fermat_planes.py`)

The Fermat tenfold is a member: x_i^3 + x_j^3 is a product of three linear forms, and acf + bde =
det [[a, b, 0], [0, c, d], [e, 0, f]]; pairs (01)(23) for A, (45)(67) for B, l_1 = x_8 + x_9, l_2 = x_10 + x_11.
There T5 is a sum of 9 Fermat planes. Intersection numbers of Fermat planes are computed from the cycles of the
union of two pairings and f(m) = (1 - (-2)^(m+1))/3; the method was validated against ranks on the fourfold and
reproduces T4.T4 = 51 of the registry on the eightfold.

- [T5].[T5] = -21, [T5].h^5 = 9.
- [T5] - 3h^5 = P_(++) - P_(+-) - P_(-+) + P_(--) (equal intersection numbers with all 7 577 955 Fermat planes), where
  the four planes lie in the P^9, P_(++) meets P_(+-) and P_(-+) in a P^3 and P_(--) in a line. Reason: summing the
  planes p(k_1, k_2, k_3, k_4) over one index gives h^5, so an L-shaped triple is h^5 + (a plane) - (a plane).
- delta_2^2 = -48. The values of delta_2 . P over all Fermat planes are 0, +-1, +-2, +-3, +-4, +-6, +-8, +-12. A value
  1 occurs, so delta_2 is primitive, and with P - P' in L and delta_2 . (P - P') = 1 its divisibility in L is 1.
- No plane has delta_2 . P = -24, which [P1] - [P2] would have with P1: delta_2 is not a two-plane class there.
- The same on the Fermat sixfold (norm -12, values up to +-3, would need -6) and eightfold (norm 24, up to +-6,
  would need 12).

## 3. The orbit (ARG + LIT)

L = (h^5)^perp is even: the Wu class of X in degree 10 is h^5 (from w = (1+h)^11 mod 2), so x.x = x.h^5 mod 2.
L is indefinite of large rank with discriminant group Z/3, so it contains two hyperbolic planes, and by Eichler's
criterion primitive vectors with the same norm and the same class in L*/L form one orbit of the stable orthogonal
group, which is the monodromy group up to the spinor-norm condition (Beauville). [P1] - [P2] is primitive, of norm
-48 and divisibility 1. So delta_2 is in the monodromy orbit of [P1] - [P2]: the family lies in the Hodge locus of
Movasati's class in the global sense (some parallel transport of it), as a component of codimension 52.
Sources (machine-read on 26 Nov, secondary; the original papers were not opened): Huybrechts, The geometry of cubic
hypersurfaces (draft notes on his web page), Theorem 2.9 (Beauville: for n even the monodromy group is the group
of isometries fixing h^(n/2) with trivial spinor norm) and Corollary 2.14 (the primitive lattice is even, which
agrees with the Wu class computation above); Eichler's criterion in the form "the orbit of a primitive vector
under that group is determined by its norm and its class in the discriminant group, for an even lattice containing
two hyperbolic planes", as quoted from Gritsenko-Hulek-Sankaran, Prop. 3.3, in later papers.

## 4. What went differently from the pre-registration

- I predicted that on the sixfold and eightfold the Fermat scan would find a pair of planes (controls "yes"). It
  found none. The scan is right (it reproduces T4.T4 = 51); my reading of the registry was wrong: there the second
  component for lambda = -1 attaches to V_Z along a divisor D, which need not pass through the Fermat point, and
  the entry on the eightfold Movasati point does not identify its second component with this family. As
  registered, nothing about V_Z is concluded from the tenfold scan.
- I predicted that delta_2 . P is 0 mod 3 for every Fermat plane. False (true only for the planes of the same
  pairing); divisibility 1 follows more directly from a value 1.
- The first version of the general-member script hung in a symbolic 6 x 6 determinant.

## 5. Not established, and the next question

- Characteristic 0 for section 1; the orbit statement is an argument on recalled theorems; the component
  statement is first-order plus an argument.
- OPEN, and the one that bears on the main lead: does the closure of the family meet V_Z with the class
  [P1] - [P2]? Route used on sixfolds by T2: degenerate the pair (A, B) until the cubic acquires the two planes
  (D-GENERAL-CUBIC-OF-D-IS-LIMIT, D-DEGENERATION-ALONG-ARC). A first-order shortcut: at a point X of V_Z the family
  can only pass if the kernel of the pairing of [P1] - [P2] there is larger than T V_Z, so look where its rank
  drops below 39 for lambda = -1.
- Smoothness of the random member was checked at one prime (the package test); the Coble family and this family were not
  compared beyond the count (54 against 52).

## 6. Blind check 9 (26 Nov; a separate agent, own Python and Macaulay2 code; it read none of my files)

Report: `leads/tenfold_twodet/blind_check9/REPORT.txt`. Nothing refuted.

- Confirmed, exact: the formula f(m); section 2 in full (with the actual minors; the histogram of delta_2 . P; the
  identity in the stronger form [T5] = 3h^5 + delta_2 in H^10); divisibility 1 with explicit planes; for comparison
  each [P1] - [P2] has exactly one plane with -24 and one with +24.
- Sound: the Wu class (v = 1 + h + h^3 + h^4 + h^5), the hypotheses of Eichler's criterion (rank L = 1366, signature
  (440, 926), L = A2 + U^438 + E8(-1)^61), divisibility 1 of [P1] - [P2] for 7 incidence types of Fermat pairs; it
  notes that divisibility matters (-48 is also a norm of primitive vectors of divisibility 3).
- Stronger than section 1: at the Fermat point, exactly, every generator of I kills the class and the pairing has
  rank 52, so the annihilator is I there; codimension 52 and reducedness at the general member then follow by
  semicontinuity. The only real hypothesis of the argument of section 1 is that S/I has finite length.
- Caveats, accepted: (a) I has all nine minors of each matrix, the ideal of T5 only 3 + 3: two different ideals;
  (b) the orbit statement is about the lattice: the same orbit, different components (38 or 39 against 52 at the
  Fermat point); (c) columns instead of rows for A or for B change delta_2 into -delta_2.
- A tooling warning, reproduced here: Macaulay2 1.22 returned a wrong ideal quotient over
  toField(QQ[w]/(w^2+w+1)) (`leads/tenfold_twodet/tooling_tofield_colon.m2`; registry N-M2-TOFIELD-IDEAL-QUOTIENT).
- Not checked by it: the annihilator at a random member directly (too heavy); section 1's node statements; the
  count for kappa.
