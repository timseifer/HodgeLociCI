# Pre-registration: the class on the tenfold two-determinant family (26 Nov 2026, about 12:05 UTC)

Owner: "Yes go ahead" to "compute its class next, and whether it is in the orbit of P1 - P2"
(D-TENFOLD-TWO-DETERMINANT-FAMILY, next_step (1)). Written before any run of the scripts in this folder.
Labels as in the repository. Not a statement about the Hodge conjecture: every class here is the class of an
algebraic cycle. AI-written, unreviewed.

Read first: D-EIGHTFOLD-FAMILY-TD (the eightfold family, its fourfold T4, T4.T4 = 51 by an exact count on the Fermat
eightfold: the same method is used here), D-EIGHTFOLD-BOUNDS-AT-MOVASATI-POINT, D-PAIR-TYPE-TABLE,
D-CUBIC-SIXFOLD-DETC (second components on sixfolds and eightfolds), C-TENFOLD-FERMAT-POINT-CLASS (at the Fermat
tenfold the Coble family carries a three-plane class, not Movasati's), O-TENFOLD-CONE-LEAD (at the Fermat tenfold
with Movasati's pair an extra component has codimension at least 54).

## 0. Setting

X: F = l_1 Q_1 + l_2 Q_2 + det A + det B in P^11.  T5 = {l_1 = l_2 = 0} n {rows 1, 2 of A proportional} n
{rows 1, 2 of B proportional}: a fivefold of degree 9 in X.  h = hyperplane class, H = H^10(X, Z), L = (h^5)^perp.
f(m) = (1 - (-2)^(m+1)) / 3 = intersection number of two 5-planes of a smooth cubic tenfold meeting in a P^m
(excess intersection: c_m of (1+h)^(m+1)/(1+3h); f(-1) = 0, f(5) = -21): 0, 1, -1, 3, -5, 11, -21.

## 1. Theory (ARG; worked out by hand before the runs)

T1. The Fermat tenfold is a member: x_i^3 + x_j^3 is a product of three linear forms, a sum of two such products is
    det [[a, b, 0], [0, c, d], [e, 0, f]], so with the pairs (01)(23) | (45)(67) | (89) | (10 11):
    Fermat = det A_0 + det B_0 + l_1 Q_1 + l_2 Q_2. There {rows 1, 2 of A_0 proportional} is three linear spaces
    {a = b = 0}, {a = d = 0}, {c = d = 0}, so T5 specialises to a sum of 9 Fermat 5-planes, with multiplicity 1.
T2. Write p(k_1, k_2, k_3, k_4) for the plane x_0 + w^k_1 x_1 = x_2 + w^k_2 x_3 = x_4 + w^k_3 x_5 = x_6 + w^k_4 x_7 = 0
    in the P^9 (w a cube root of 1). Fixing three indices and summing over the fourth gives h^5 (a P^6-section).
    With that, the sum over an L-shaped triple is h^5 + (one plane) - (another), and twice:
        [T5] = 3 h^5 + P_(++) - P_(+-) - P_(-+) + P_(--),      P_(st) = p(alpha_s, beta_t),
    alpha_+, alpha_- differing in both indices, likewise beta. Call delta_2 = [T5] - 3 h^5: a second difference of
    four planes; P_(++) meets P_(+-) and P_(-+) in a P^3 and P_(--) in a line.
T3. Numbers (by hand): T5.T5 = -189 + 264 - 140 + 48 - 4 = -21;  delta_2^2 = -84 + 36 = -48;  delta_2 . h^5 = 0.
    The same -21 comes from D-NODES-DISCRIMINANT-IDENTITY if it applies to T5 (3 T.T - 81 = -2 x 72): two
    independent routes.  (P1 - P2)^2 = -21 - 6 - 21 = -48 for planes meeting in a P^2: the same norm.
T4. Primitive and of divisibility 1. f(m) is odd for m >= 0 and f(-1) = 0, so delta_2 . P is odd exactly when an
    odd number of the four planes miss P; such P exist (by hand: a plane of the same pairing off the P^9 with
    delta_2 . P = -3). With delta_2 . P = 12 or 0 for planes in the P^9 the only possible divisor is 3, excluded by
    -48. If delta_2 had divisibility 3 in L then delta_2 = c h^5 + 3x with c != 0 mod 3, so delta_2 . P = c mod 3 for
    every plane; but delta_2 . P = 0 mod 3 for the planes above. So div = 1.
T5. L is even: the Wu class of X is the degree-10 part of the solution v of v(h + h^2) = (1 + h)^11 mod 2, which is
    h^5; so x.x = x.h^5 mod 2 on H. L is indefinite of large rank with discriminant group Z/3, so it contains two
    hyperbolic planes; by Eichler's criterion (LIT, recalled: Gritsenko-Hulek-Sankaran) primitive vectors of L with
    the same norm and the same class in L*/L are in one orbit of the stable orthogonal group, and the monodromy
    group of smooth cubic tenfolds is that group up to the spinor-norm condition (LIT, recalled: Beauville 1986).
    P1 - P2 is primitive of divisibility 1 and norm -48.  Hence: delta_2 is in the monodromy orbit of P1 - P2.
T6. A component of the Hodge locus. The ideal I = (l_1, l_2, Q_1, Q_2, I_2(A), I_2(B)) contains the Jacobian ideal;
    S/I is Gorenstein with socle in degree 6 (the cone over the curve D of the earlier run is arithmetically
    Gorenstein, then two quadrics); its degree-3 part I_3 is the tangent space of the family, along which T5 stays
    algebraic, so I lies in the annihilator of the class; a Gorenstein quotient of socle degree 6 has no proper
    Gorenstein quotient of the same socle degree, so I IS the annihilator and the first-order Hodge locus has
    codimension dim (S/I)_3 = 52 (computed, two primes). So the family is a reduced component, of codimension 52,
    of the Hodge locus of delta_2.

## 2. What is run, with predictions

R1 (general member, MOD p, two primes; td1_general_member.m2; uses the package's hodgeLocusTangentCodim if it
    finishes). T5 has dimension 5 and degree 9 and lies in X; the 72 nodes of a section through the P^9 lie on T5
    and T5 is smooth there (so the node identity applies); S/(I(T5) + J) has value 52 in degree 3 (as 26 on
    eightfolds), and the package gives tangent codimension 52.
R2 (Fermat, exact combinatorics; fermat_planes.py). Intersections of Fermat planes from the cycles of the union of
    two pairings (validated against the rank method on the 405 planes of the fourfold, and against T4.T4 = 51 of
    the registry on the eightfold). Predictions: [T5].[T5] = -21; [T5] - 3h^5 = the second difference of T2 (equal
    pairings with all 10395 x 729 planes); some pairing is odd; all pairings with planes are 0 mod 3; norm -48.
R3 (Fermat, exact; the same script). Is delta_2 equal to a two-plane class [P1] - [P2] (then P1, P2 meet in a P^2)?
    Scan: planes with delta_2 . P = -24, then compare pairings with all planes.
    Controls: the same question on the sixfold and the eightfold. Prediction for the controls: yes (the registry
    has the two-determinant family as the second component for lambda = -1 at suitable pairs). Prediction on the
    tenfold: not for Movasati's pair type (same pairing; by O-TENFOLD-CONE-LEAD an extra component there has
    codimension >= 54 > 52); for the other incidence types no prediction.

## 3. What each outcome would mean

- R1 or R2 off: the hand computations of section 1 are wrong somewhere; nothing is recorded until found.
- R3 on the tenfold "yes, for a pair of type X": the family is a second component, of codimension 52 = codim V_Z + 13,
  of the Hodge locus of [P1] - [P2] at the Fermat point for pairs of that type: the tenfold line of the registry's
  table of second components. It is smaller than V_Z, so it is not the "larger component" asked about in
  rStation #5 and #11, and its classes are algebraic.
- R3 on the tenfold "no": at the Fermat point the class of this family is a four-plane class, in the monodromy orbit
  of P1 - P2 (T5, an argument) but not a two-plane class there. Whether the closure of the family meets V_Z with the
  class P1 - P2 somewhere else stays open. In both cases the family and the Coble family (codimension 54, class
  kappa at the Fermat point) are different components.
- If the controls say "no" on the eightfold or sixfold, my reading of the registry or the scan is wrong: say so,
  and conclude nothing from the tenfold scan.
Not tested: T5 and T6 are arguments; the two literature statements are recalled, not re-read.

## 4. Outcomes (26 Nov, about 12:30 UTC; not a pre-registration)

R1 (32003 seed 1, 31991 seed 2): T5 of dimension 5 and degree 9 in X; 72 nodes, all on T5, T5 smooth at each;
S/(I(T5) + J): 1, 10, 37, 52, 35, 10, 1, 0; S/I: 1, 10, 35, 52, 35, 10, 1; package: codimension 52; the member at
32003 is smooth. As predicted.
R2 (exact): T5.T5 = -21; [T5] - 3h^5 = the second difference of four planes; norm -48; an odd value occurs. As
predicted, EXCEPT "all pairings are 0 mod 3": false (values +-1, +-2, +-4, +-8 occur for planes of other pairings).
Divisibility 1 then follows directly from a value 1, so T4 of section 1 is right for a simpler reason.
R3: no two-plane form on the tenfold, and none on the sixfold and the eightfold: BOTH CONTROL PREDICTIONS FAILED.
The scan itself is validated (ranks on the fourfold; T4.T4 = 51 of the registry). The error was my reading of the
registry: its second component for lambda = -1 on sixfolds attaches to V_Z along a divisor D that need not contain
the Fermat point, and D-EIGHTFOLD-BOUNDS-AT-MOVASATI-POINT does not identify its second component with this
family. As registered in section 3: nothing about V_Z is concluded from the tenfold scan; it only describes the
class at the Fermat point.

## 5. Added 26 Nov, about 12:42 UTC, before the run "fermat_planes.py kappa"

R4 (exact; the Coble class at the Fermat point). kappa = h^5 - [P_1] - [P_2] - [P_3], the three planes of
C-TENFOLD-FERMAT-POINT-CLASS (same pairing, exponents (0,0,0,e,e,e), e = 0, 1, 2; pairwise meeting in one P^2).
By hand: kappa . h^5 = 0, kappa^2 = 3 - 6 - 63 + 18 = -48. Prediction: kappa is primitive of divisibility 1 (a value
+-1 among its pairings with Fermat planes), so by T5 it is in the same monodromy orbit as [P1] - [P2] and delta_2.
If instead all pairings were divisible by 3 in the way of T4 (kappa = c h^5 mod 3), the Coble class would be in a
different orbit and the Coble family would not belong to the Hodge locus of Movasati's class in the global sense.

R4 outcome (12:44 UTC): kappa^2 = -48; values 0, +-1, +-2, +-4, +-8, +-16; gcd 1: primitive, divisibility 1. As predicted.

After the runs (about 12:55 UTC): the two theorems of T5 were machine-read in secondary sources (Huybrechts' notes on
cubic hypersurfaces, Theorem 2.9 and Corollary 2.14; Eichler's criterion as quoted from Gritsenko-Hulek-Sankaran in
later papers). Blind check 9: nothing refuted; see the lead note, section 6.
