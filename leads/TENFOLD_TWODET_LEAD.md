# Cubic tenfolds l_1 Q_1 + l_2 Q_2 + det A + det B: the family, its fivefold and its class (26 Nov 2026)

AI-written, not reviewed by a mathematician. Labels: EXACT / MOD p / ARG / LIT / OPEN. Finite-field runs are
evidence, not proofs. Nothing here is a statement about the Hodge conjecture: every class below is the class of an
algebraic cycle. Pre-registration, scripts and logs: `leads/tenfold_twodet/`. Registry:
D-TENFOLD-TWO-DETERMINANT-FAMILY, D-TENFOLD-TWO-DET-CLASS, D-TENFOLD-TWO-DET-HODGE-LOCUS. Section 7 (evening):
D-TENFOLD-CONE-POINTS-TWO-DET, D-TENFOLD-ORDER4-MODEL-CONE, C-TENFOLD-ORDER4-RANK2.

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
  **Update, same evening: a conditional yes, at cone points; see section 7.**

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
- (Answered conditionally in section 7.) OPEN, and the one that bears on the main lead: does the closure of the
  family meet V_Z with the class [P1] - [P2]? Route used on sixfolds by T2: degenerate the pair (A, B) until the cubic acquires the two planes
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

## 7. Does the family meet V_Z with the class [P1] - [P2]? (26 Nov, evening; owner: "Yes begin")

Pre-registration, written before the runs: `leads/tenfold_twodet/PREREG_vz.md` (theory T1-T6, predictions P1-P6
with what each outcome would mean). Scripts vz1-vz5 and logs: `leads/tenfold_twodet/`, `logs/vz/`. Registry:
D-TENFOLD-CONE-POINTS-TWO-DET, D-TENFOLD-ORDER4-MODEL-CONE, C-TENFOLD-ORDER4-RANK2.

### 7.0 Answer

- **Conditionally yes (ARG on registry inputs).** The closure of the family contains every tenfold
  X_c = c(y0..y7) + l_1 Q_1 + l_2 Q_2 with c in the closure of the sixfold family det A + det B. If the sixfold
  statement D-W-MINUS1-IS-TWO-DET-CLOSURE holds (a paper chain of team T2, supported MOD p along one arc), then
  for c on the sixfold divisor D the tenfold X_c lies in V_Z and the class of the family there is
  +-([P1] - [P2]): the family is a second component of the Hodge locus of [P1] - [P2] at these "cone points"
  (a locus of codimension 73), exactly as on sixfolds along D and on eightfolds at X1. Nothing in this step is
  specific to tenfolds: it is T3's cone map (D-LAMBDA2-CONE-TYPE) applied twice.
- **What is checked, not argued.** (EXACT) On the Fermat tenfold with the pair of type [6T 2T 2F 2T], T3's
  exported cone arc keeps [P1] - [P2] a Hodge class to order 9 (all 221 period functions) and leaves V_Z at first
  order; rank L = 38 against 39. (MOD p, two instances) Honest cone members have tangent codimension 52, the
  Hilbert function 1,10,35,52,35,10,1, and a singular line of multiplicity 36 in the P^9-section.
- **Never at an honest member (ARG).** At a smooth member l_1 Q_1 + l_2 Q_2 + det A + det B the class has tangent
  codimension 52; a two-plane class has at most 40. So the meeting points are limits. The same argument on
  sixfolds sharpens the plane lemma of T2.
- **New at Movasati's point (MOD p).** The order-4 cone there is larger than recorded: nets of rank 2 with a
  common kernel and cokernel and pairwise orthogonal 2 x 2 blocks (a 13-dimensional piece of the model cone) pass
  order 4, as do the special rank-3 nets z_0 C'. T6's "rank 2 and 3 obstructed, so dim W <= dim Cone_T + 11" holds
  for generic nets only. If the order-4 forms are the 27 model quadrics (supported at eight directions, two
  primes, and by a rank 14 = 27 - 13), the order-4 bound for a component other than V_Z is codimension >= 52,
  not 54; 52 is the codimension of this family. At order 5 the obstruction along a direction of the
  13-dimensional piece is removable, for lambda = -1 and for lambda = 2 alike; order 6 is not decided.
- **Not shown:** that a component of codimension 52 exists at Movasati's point (order 5 only, and lambda = 2
  behaves the same to that order); the sixfold statement itself; anything in characteristic 0 beyond the exact
  arc. All classes here are classes of algebraic cycles.

### 7.1 What this uses

T3: the cone map and the Thom-Sebastiani formula for the Jacobian ring (D-LAMBDA2-CONE-TYPE), the cone pairing
(cone a, cone b) = -2 (a, b) + deg a deg b, the cone-type arcs six_lam-1_arc.txt, the eightfold order-4 model
(D-EIGHTFOLD-BOUNDS-AT-MOVASATI-POINT), D-X1-COMPONENT-IS-TD-CLOSURE. T2: D-W-MINUS1-IS-TWO-DET-CLOSURE,
D-GENERAL-CUBIC-OF-D-IS-LIMIT, D-DEGENERATION-ALONG-ARC, D-RANK-INVARIANT, D-SIXFOLD-GERM-AT-MOVASATI-POINT.
T6: O-TENFOLD-CONE-LEAD. The first-order rule of paper 3. rStation papers #5 and #11 (cone families,
Thom-Sebastiani points). The package's Fermat engine for every period computation.

### 7.2 The argument (ARG; details in PREREG_vz.md, section 1)

Write a tenfold with two 5-planes meeting in Pi = P^2 as F = f^T M h + sum p_l s_l; Mbar = M|Pi is a net of
3 x 3 matrices, sbar_l = s_l|Pi.

1. Cone map. For a smooth sixfold Z = {c = 0} and X = {c + l_1 Q_1 + l_2 Q_2 = 0} smooth, the section
   l_1 = l_2 = 0 is the cone over Z with vertex a line; blowing up the vertex gives a P^2-bundle over Z mapping
   to X, and pull-back followed by push-forward is a morphism of Hodge structures H^6(Z) -> H^10(X) sending the
   class of V to the class of the cone over V. So Hodge loci go to Hodge loci (one direction only: the Hodge
   locus of the cone class can be larger). Pairing: one step is (cone a, cone b) = -2 (a, b) + deg a deg b (T3;
   proved for all classes by the blind check), two steps give 4 (a, b) - deg a deg b: norms -12 -> 24 -> -48 and
   T.T = 15 -> 51 -> -21; the last value is the one counted on the Fermat tenfold earlier today (section 2), by a
   method that does not use cones. A general c + l_1 Q_1 + l_2 Q_2 is not an iterated one-step cone (Q_1 involves
   both vertex coordinates); the two-step formula holds at the members that are, e.g. Fermat, and extends to all
   by flatness of the cone map over the connected parameter space (the checker's caveat).
2. Cone members. If A and B do not involve two of the ten variables of the P^9, the member is the double cone
   of a sixfold det A + det B, T5 is the cone over T, and the ideal (l, Q, I_2(A), I_2(B)) has Hilbert function
   (1,8,18,8,1) x (1,2,1). These members form a family of codimension 72 inside the closure of the family.
3. Honest members. At a smooth member the ideal I = (l_1, l_2, Q_1, Q_2, I_2(A), I_2(B)) is Gorenstein with
   Hilbert function 1,10,35,52,35,10,1 (smoothness forces the two rank <= 1 loci to meet the P^9 in a curve on
   which Q_1, Q_2 have no common zero). It is the annihilator of the class: I lies in the annihilator (a limit
   of the general member, or directly, since I(T) + J annihilates [T] for each row / column variant of T5 and
   these ideals sum to I), the class is not zero, and a proper quotient of an Artinian Gorenstein algebra kills
   the socle. (My first version said "same Hilbert function and continuity"; the checker pointed out that the
   Gorenstein property is what carries the step.) So the tangent codimension is 52; for two planes it is at most
   40. Shorter: two linear forms annihilate delta_2, three annihilate a two-plane class. This holds for cubics
   literally of the form l_1 Q_1 + l_2 Q_2 + det A + det B, not for limits of them. On sixfolds: an honest sum
   has no linear form annihilating its class, while the hyperplane spanned by two 3-planes meeting in a point
   annihilates [P1] - [P2] (Hilbert functions 1,8,18,8,1 against 1,7,12,7,1).
4. First order. A second branch through a point of V_Z needs det Mbar in (sbar_1, sbar_2, sbar_3): a divisor
   D_10 of V_Z (paper 3). Cone points over any sixfold of V_Z^(6) satisfy it: Mbar = z_0 C, sbar_3 = z_0^2.
5. Conclusion, given the sixfold statement (S): for c on D (D is closed, so including the points with C = 0),
   X_c is in V_Z, in the closure of the family, and the class is the double cone of +-([P1'] - [P2']). Examples
   on the Fermat tenfold: the pair [6T 2T 2F 2T] (double cone of T2's pair) and Movasati's pair (double cone of
   the sixfold Movasati pair). The tangent codimension along the cone-type family is 8 + 2 x 18 + 8 = 52
   (Thom-Sebastiani and D-RANK-INVARIANT).

### 7.3 The checks of the conditional statement

| | prediction (written first) | result | label |
|---|---|---|---|
| P1 | Fermat tenfold, pair [6T 2T 2F 2T], class P1 - P2: Hodge codimension 38, joint persistence 39 | 38, 39, excess 1 (P1 + P2: also 38) | EXACT |
| P2 | T3's cone arc, read on the tenfold: 221 period functions vanish to order 9; T_1 not tangent to V_Z | pass to order 9; T_1 in ker L, not in ker L_P1; control P1 + P2 fails at order 1 | EXACT |
| P3 | honest cone member: Hilbert function 1,10,35,52,35,10,1; tangent codimension 52; smooth | as predicted at 32003 (seed 1) and 31991 (seed 2); rank <= 1 loci meet the P^9 in the vertex line with multiplicity 36 | MOD p |

P2 is not independent of the eightfold statement: along such an arc the tenfold period functions are the
eightfold ones times constants (Thom-Sebastiani). It checks that the cone map does what step 1 says, with the
tenfold's own 221 equations.

### 7.4 Movasati's point: the order-4 cone (model: ARG by analogy with T3; tests: MOD p)

At Movasati's pair on the Fermat tenfold, Mbar = 0, sbar_l = z_l^2, and T V_Z maps onto the 27-dimensional space
of nets N = z_0 A + z_1 B + z_2 C. T3 found on eightfolds that the order-4 forms are y^2 times the y_1 y_2-
coefficients of the 2 x 2 minors of A y_1 + B y_2. The same model with one more variable: 27 quadrics, the
coefficients of z_i z_j (i < j) in the 2 x 2 minors of N. Its zero set V_4, by hand:
- one of A, B, C invertible: the other two vanish (three linear pieces of dimension 9);
- all of rank <= 1: the two Segre cones of dimension 11 (T6's "rank 1");
- one of rank 2: all three have its kernel and its cokernel, and the three 2 x 2 blocks are pairwise orthogonal
  for the polar form of det: dimension 2 + 2 + 9 = 13.
The blind check computed the decomposition: the 27 quadrics generate a radical ideal with exactly these six
components, of dimensions 13, 11, 11, 9, 9, 9 and degrees 540, 45, 45, 1, 1, 1 (ZZ/32003; the same Hilbert series
over QQ).
So dim V_4 = 13, not 11, and the cylinder over it with the excess line has codimension 39 + 14 - 1 = 52. The
same count on sixfolds (the cubic det C: 8 + 1 - 1 = 8) and on eightfolds (T3's cone of codimension 7:
20 + 7 - 1 = 26) gives the codimensions of det A + det B and of l Q + det A + det B.

| | what | result | label |
|---|---|---|---|
| P4 | Jacobian rank of the 27 quadrics at random points of each piece | 14 (13-dimensional piece), 16 (Segre), 18 (A,0,0) | MOD p, model only |
| P5 a, b | generic nets of rank 3 and of rank 2: obstructed at order 4 | obstructed at order 4 | MOD p |
| P5 c, C | Segre cones: pass order 4 | pass | MOD p |
| P5 d, D | 13-dimensional piece (rank 2): pass order 4 | pass (two samples per run) | MOD p |
| P5 e, E | z_0 C' with C' invertible, and of rank 2 (cone-type): pass order 4 | pass | MOD p |
| P6a | direction d, lambda = -1: the order-5 obstruction is removable by a change of T_2; image of rank 14 | removable; rank 14; random elements of ker L add nothing | MOD p |
| P6b | the same for lambda = 2 (no prediction) | removable as well; rank 14 | MOD p |

P5 was run at (32029, seed 1) and (31981, seed 2) for lambda = -1 and at (32029, seed 1) for lambda = 2, with
the same outcome; P6a at both, P6b at the first. Order 4 is the first non-zero order at this point, so P5 does not depend on the choice of
lower terms. With the corrected T_2 the next obstruction of the package's default continuation is at order 6
(both lambda); whether it is removable was not tested. The cone-type direction E passes order 5 without any
correction (lambda = -1), as the cone map predicts.

What this changes: the sentence "rank 2 and 3 obstructed at order 4 ... so dim W <= dim Cone_T + 11" of
O-TENFOLD-CONE-LEAD is true of generic nets of rank 2 and 3 and not of all of them (C-TENFOLD-ORDER4-RANK2). The
lead W of T6 (Segre directions, codimension 54) is not touched: the Segre cones are not in the closure of the
13-dimensional piece (their nets have no common kernel vector).

### 7.5 How the pieces fit, and what would decide it

- If (S) holds, the closure of the family passes through Movasati's point with Movasati's class, with
  codimension 52, i.e. slice dimension 168, and the class is algebraic on it (it is [T5] - 3h^5). The order-4
  cone found here has exactly the room for it, and no more. rStation paper #5 leaves open whether a component of
  slice dimension above 155 exists at that point; this would be one, with an algebraic class. It is a
  conditional statement and a finite-order consistency check, not a result.
- For lambda = 2 the directions of the 13-dimensional piece also pass order 5. On eightfolds the two values
  separate at order 5 by the factor (lambda + 1)^2 (D-X1-ORDER5-FORMULA); T6 saw a rank-1 direction at
  lambda = 2 fail at order 6. So the test that would separate them here is order 6 on direction d: the order-6
  vector modulo the image of rank 14 and modulo the first-order changes of T_2 along the 13 tangent directions
  of the piece (about 15 runs of 4 minutes per lambda and prime). Not run.
- The step that would replace (S) by a computation is the one T2 left as STUCK
  (O-RECOVER-MATRICES-AND-LIMIT-OF-T): the matrices A(eps), B(eps) along the sixfold arc. By the cone map the
  same matrices give explicit degenerations onto the eightfold point X1 and onto the tenfold cone points.

### 7.6 Not established

- (S), and with it every "yes" above. That the nets of quadrics along T2's arc are nets of minors is known by
  numbers only (D-DEGENERATION-ALONG-ARC).
- That the order-4 forms at Movasati's point are exactly the 27 model quadrics (tested on eight directions and
  one differential, not proved), hence the bound 52.
- Existence of a component of codimension 52 at Movasati's point: order 5 only; order 6 open; lambda = 2 not
  separated.
- Whether the family meets V_Z elsewhere (cone points over the eightfold locus, or points that are not cones).
- Characteristic 0 for P3-P6.

### 7.7 Blind check 10 (a separate agent; own Macaulay2, Singular and Python code; it read nothing under leads/ or discoveries/)

Report and scripts: `leads/tenfold_twodet/blind_check10/`. It was given five claims (the model cone, the exact
arc, the honest cone member, the argument of step 3, the cone map), not the runs at Movasati's point.

- Model cone: CONFIRMED and sharpened (six components exactly, degrees as above, radical; point counts over
  F_3, F_5, F_7; the rank <= 1 part is exactly the two Segre cones; characteristic 3 need not be excluded).
- Exact arc: CONFIRMED by the package and by its own exact implementation of the period formula (221 forms,
  orders 1..9; P1 + P2, P1, P2 fail at order 1; ranks 38, 39; sign convention checked against intersection
  numbers). Its judgement, which I share: the tenfold arc is a formal consequence of the eightfold one (it
  checked the constant-factor identity value by value), so it tests the implementation; only the ranks are new
  at the tenfold level. The Hilbert function of S/Ann([P1] - [P2]) there is 1,9,27,38,27,9,1.
- Honest cone member: CONFIRMED at two seeds, with the socle, the perfect pairing and smoothness by three
  Groebner routes; one member with A, B in all twelve variables as well.
- Step 3: sound in substance; the proof of "the ideal is the annihilator at every smooth member" was rewritten
  as above; the statement is about cubics literally of this form.
- Cone map: sound; the pairing formula proved in general; the caveat on "applied twice" is in step 1.
- Not checked by it: the period formula itself by another method; the order-4 and order-5 runs (these rest on
  repetition at a second prime and seed by the same scripts).

### 7.8 Order 6 at Movasati's point (26 Nov, later; owner: "queue this work up")

Predictions written first: PREREG_vz.md, section 6. Script `vz6_order6.m2`; registry D-TENFOLD-MOVASATI-ORDER6.
Same direction of the 13-dimensional piece as in 7.4, T_2 corrected so that order 5 holds. The order-6 vector
can be moved by T_3 (by the image Im D of rank 14) and by changes of T_2 inside ker D.

| | prediction | result (MOD 32029, seed 1) |
|---|---|---|
| P7a, lambda = -1 | order 6 is removable | the order-6 vector is not zero and lies in Im D: removed by a change of T_3; the corrected arc passes the package's check to order 6 (221 forms); its default continuation stops at order 7 (not analysed) |
| P7b, lambda = 2 | not removable | not in Im D; the changes under 13 tangent net directions, y_0 and 6 random D-free elements of ker L all lie in Im D, so it stays outside: obstructed modulo these corrections |

So the 13-dimensional piece separates lambda = -1 from lambda = 2 at order 6, the order at which T6 saw a rank-1
direction fail for lambda = 2. This is what the conditional statement of 7.0 needs at this point, one order
further than before; it is still finite order, one prime, one direction, and for lambda = 2 "obstructed" means
modulo the corrections that were tested. The first bullet of 7.5 ("order 6 on direction d ... Not run") is
superseded by this.

### 7.9 Queued by the owner, not started: the matrices along T2's sixfold arc (notes only; nothing below was run)

This is the step that would replace the sixfold paper chain (S) by a computation
(O-RECOVER-MATRICES-AND-LIMIT-OF-T, STUCK since team T2). Starting points, all unverified (ideas, ARG at best):
- Write a cubic of D as G = l s + C_3 with C_3 = z f^T C h + K(f, h) on the hyperplane l = 0. rank C = 2 means
  that the quadratic part f^T C h has rank 4, i.e. is a 2 x 2 determinant of four independent linear forms. A
  3 x 3 determinant whose z-part is a nilpotent matrix of rank 1 has exactly this shape (z times one 2 x 2 minor
  plus terms without z). This may be why the condition is det C = 0, and it suggests the leading matrices.
- Three kinds of boundary points of the sixfold family are now distinguished by how the pair (A, B) degenerates:
  B -> -A with A finite (the cubics containing a flag threefold V_6, a divisor; tangent type); both -> l times
  the identity isotropically (equal trace and second coefficient: the Coble rung, codimension 11,
  D-COBLE-SECTION-TWO-DETERMINANTS); both -> l times the identity anisotropically (D, by D-DEGENERATION-ALONG-ARC).
- A computational route: (1) the arc to high order modulo p (the exported arc is valid to order 9; T2 used 25 and
  found it too little); the exact Python implementation of the period formula written by blind check 10
  (`blind_check10/B_own.py`) is a base for a fast series engine; (2) the kernel of the catalecticant and its
  splitting into two nets (tools of `leads/tenfold_coble/pairing/pr13_arc_algebra.m2`, `pr14_arc_split.m2`);
  (3) each matrix from the linear syzygies of its net, or from the Lie algebra of its determinantal cubic
  (`detrep_lib.m2`), over the series field; (4) the flat limit of T and its class at the cubic of D. By the cone
  map the same matrices give explicit degenerations onto the eightfold point X1 and the tenfold cone points.
- Cost: several hours; the series engine is the bottleneck.
