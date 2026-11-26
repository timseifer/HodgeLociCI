# Pre-registration: does the tenfold two-determinant family meet V_Z with the class [P1] - [P2]?

Written 26 Nov 2026 (about 15:00 UTC) by Claude Fable 5.2 for Timothy Seifert, BEFORE the computations of this
batch. AI-generated, unreviewed. Labels: EXACT / MOD p / PROVED (AI, unreviewed) / ARG / LIT / OPEN.
Finite-order arcs are evidence, not proof. "Ruled out" means only the cases tested.

Question (registry D-TENFOLD-TWO-DET-HODGE-LOCUS, item (4)): let T2S be the family of cubic tenfolds
F = l1 Q1 + l2 Q2 + det A + det B (codimension 52), delta_2 = [T5] - 3h^5 its class. Is there a smooth X_1 in the
closure of T2S containing two 5-planes P1, P2 with P1 n P2 = P^2 at which the transported class is +-([P1] - [P2])?
Then the closure of T2S is a second component of the Hodge locus of [P1] - [P2] there, as the sixfold family
det A + det B is along the divisor D (D-CUBIC-SIXFOLD-DETC, D-W-MINUS1-IS-TWO-DET-CLOSURE).

## 0. What was read first (and whose work this uses)

- Team T3: the cone map from a cubic sixfold to a cone-type eightfold, the Thom-Sebastiani formula for the
  Jacobian ring, the cone-type family CT_lambda (D-LAMBDA2-CONE-TYPE, D-CONE-DICTIONARY), the cone pairing
  (cone a, cone b) = -2 (a, b) + deg a deg b (D-LATTICE-type entry, "data"), the eightfold order-4 model at the
  Movasati point (D-EIGHTFOLD-BOUNDS-AT-MOVASATI-POINT: nine quadrics = y1 y2-coefficients of the 2 x 2 minors of
  A y1 + B y2), D-X1-COMPONENT-IS-TD-CLOSURE, D-GLOBAL-ARGUMENT, the exported arcs six_lam-1_arc.txt.
- Team T2: D-W-MINUS1-IS-TWO-DET-CLOSURE, D-GENERAL-CUBIC-OF-D-IS-LIMIT (plane lemma), D-DEGENERATION-ALONG-ARC,
  D-RANK-INVARIANT, O-RECOVER-MATRICES-AND-LIMIT-OF-T (STUCK), D-SIXFOLD-GERM-AT-MOVASATI-POINT.
- Team T6: O-TENFOLD-CONE-LEAD (first order at the tenfold Movasati point; order 4: "rank 2 and 3 obstructed,
  rank 1 survive, so dim W <= dim Cone_T + 11").
- Note 1 / paper 3 of the repository (first-order rule; excess = dim (0 : det M)_tau).
- rStation papers #5 and #11 (u/lelong_ridge): the cone families and Thom-Sebastiani points; #5 leaves open
  whether a component of slice dimension > 155 exists at the tenfold Movasati point.
- Code searched before writing new code: package (fermatTangentData, fermatVerifyArc, fermatExtendArc,
  hodgeLocusTangentCodim, cyclePair, tangentExcess), leads/tenfold_twodet/td1_general_member.m2,
  leads/tenfold_coble/pairing/ (arc tools), tooling/.

## 1. Theory (all ARG unless marked)

Notation. A smooth tenfold with two 5-planes meeting in Pi = P^2 is F = f^T M h + sum_l p_l s_l (f, h, p triples
of linear forms, M a 3 x 3 matrix of linear forms, s_l quadrics, z coordinates on Pi). Mbar = M|Pi is a net of
3 x 3 matrices, sbar_l = s_l|Pi three conics without common zero (X smooth along Pi).

T1 (cone map, twice; one step is T3's). For a smooth cubic sixfold Z = {c(y0..y7) = 0} and
X = {c + l1 Q1 + l2 Q2 = 0} smooth (l_i linear, Q_i quadrics in 12 variables), X n {l1 = l2 = 0} is the cone over
Z with vertex a line nu. Blowing up the vertex gives a P^2-bundle pi over Z and a map j to X; cone = j_* pi^* is
a morphism of Hodge structures H^6(Z) -> H^10(X) with cone(h^3) = h^5, cone([V]) = [cone over V]. Hence: if c
moves in the Hodge locus of gamma, then c + l1 Q1 + l2 Q2 moves in the Hodge locus of cone(gamma).
Pairing (T3's formula applied twice): norms -12 -> 24 -> -48; T.T = 15 -> 51 -> -21. The last number was computed
independently yesterday (D-TENFOLD-TWO-DET-CLASS, T5.T5 = -21): a first consistency check, already passed.

T2 (cone-type subfamily). CT = {c + l1 Q1 + l2 Q2 : c = det A + det B in y0..y7} lies in T2S (A, B not involving
two of the ten variables). Its closure has codimension 72 (count: 20 + 16 + 112 + 144 = 292 of 364). At such a
member the singular curve of the P^9-section is the vertex line with a multiple structure, the ideal
I = (l1, l2, Q1, Q2) + I_2(A) + I_2(B) has Hilbert function (1,8,18,8,1) x (1,2,1) = (1,10,35,52,35,10,1), and
delta_2 = cone([T] - 3h^3) because T5 is the cone over T.

T3 (honest members never carry a two-plane class). At a smooth member F = l1 Q1 + l2 Q2 + det A + det B the
ideal I is Gorenstein with Hilbert function (1,10,35,52,35,10,1) (smoothness forces the rank <= 1 loci to meet
{l = 0} in a curve and Q1, Q2 to be a regular sequence on it), so Ann(delta_2) = I and the Hodge locus of delta_2
has tangent codimension 52. For any two 5-planes meeting in a P^2 the Hodge locus of [P1] - [P2] contains V_Z,
so its tangent codimension is at most 40. Hence delta_2 != +-([P1] - [P2]) at every smooth honest member: any
point asked for is a limit, not an honest sum on that branch. Same argument on sixfolds: Ann_1 = 0 for an honest
sum, while the hyperplane spanned by two 3-planes meeting in a point annihilates [P1] - [P2]; this sharpens the
"special cubics of D may be honest sums" clause of D-GENERAL-CUBIC-OF-D-IS-LIMIT (they may be honest sums, but
not with this class on that branch).

T4 (necessary first-order condition). If the closure of T2S passes through a point X_1 of V_Z with this class and
is not contained in V_Z, the Zariski tangent space of the Hodge locus there is larger than T V_Z, so by the
first-order rule (paper 3, excess = dim (0 : det Mbar)_0 in A = k[z]/(sbar)) det Mbar lies in (sbar_1, sbar_2,
sbar_3): one condition, a divisor D_10 of V_Z. Cone points over ANY sixfold of V_Z^(6) are in D_10:
Mbar = z_0 C, sbar_3 = z_0^2 up to a constant, det Mbar = z_0^3 det C.

T5 (conditional answer). Assume (S): near a general point of the sixfold divisor D, the second component W_(-1)
is an open piece of the closure of {det A + det B}, with transported class +-([P1'] - [P2'])
(D-W-MINUS1-IS-TWO-DET-CLOSURE, PAPER_ARGUMENT_AI, supported MOD p by D-DEGENERATION-ALONG-ARC and
D-RANK-INVARIANT). Then for every c in D (D is closed, so also the points with C = 0) the tenfold
X_c = c + l1 Q1 + l2 Q2 lies in V_Z and in the closure of T2S, and delta_2 = cone(+-([P1'] - [P2'])) =
+-([P1] - [P2]) there. So: YES, at cone points over D (codimension 73), CONDITIONAL on (S). Examples: the Fermat
tenfold with a pair of type [6T 2F 2T 2T] (cone over T2's sixfold pair) and with Movasati's pair
[2F 2F 2F 2T 2T 2T] (cone over the sixfold Movasati pair, where C = 0). Along the cone-type family the Hodge
locus has tangent codimension 8 + 2*18 + 8 = 52 (Thom-Sebastiani and D-RANK-INVARIANT), the codimension of T2S.

T6 (order-4 model at the tenfold Movasati point X0; a conjecture by analogy with T3's eightfold result). At X0,
sbar_l = z_l^2 and Mbar = 0; the first-order deformations in V_Z map onto the 27-dimensional space of nets
N = z_0 A + z_1 B + z_2 C. Conjecture: the order-4 leading forms of the dependent equations on ker L are
y^2 times the 27 coefficients of z_i z_j (i < j) in the 2 x 2 minors of N (the eightfold statement with one more
variable). Their zero set V_4 is computed by hand: if some A_i is invertible the others vanish (three linear
9-dimensional pieces); if all have rank <= 1 one gets the two Segre cones (dimension 11; T6's "rank 1"); and if
some A_i has rank 2 then all three share its kernel and cokernel and the three 2 x 2 blocks are pairwise
orthogonal for the polar form of det: dimension 2 + 2 + 9 = 13. T6's sampling by rank could not see the last
piece (it consists of special nets of rank 2). If the model is right, every component of the Hodge locus at X0
other than V_Z has dimension <= dim V_Z - 14 + 1, i.e. codimension >= 52 (not 54), and 52 is the codimension of
T2S: the same match as 0 for sixfolds (cubic det C) and 6 for eightfolds (cone of codimension 7).

## 2. Predictions and what each outcome means

Written before running. Scripts: vz1 .. vz4 in this folder.

P1 (EXACT or MOD p; package fermatTangentData). Fermat tenfold, pair
P1 = {x0 = z x1, x2 = z x3, x4 = z x5, x6 = z x7, x8 = z x9, x10 = z x11},
P2 = {x1 = -x2, x3 = -x4, x0 = -x5, x6 = z x7, x8 = -x9, x10 = z x11} (type [6T 2T 2F 2T]; z = zeta_6),
coefficients (1, -1): Hodge codimension 38, joint persistence codimension 39, excess 1.
- 38/39: consistent with T4 (cone points lie in D_10).
- anything else: my reading of the pair or T4 is wrong; stop and find out which.

P2 (EXACT; package fermatVerifyArc). The nine-term arc of M2/HodgeLociCI/data/six_lam-1_arc.txt (an eightfold arc
at X1 in the variables x0..x5, x8, x9 only; T3's export, valid to order 9), read as a tenfold arc at the pair of
P1: all 221 period functions of [P1] - [P2] vanish at orders 1..9; T_1 is not tangent to V_Z.
- pass: T1 holds on this arc to order 9; the Hodge locus of [P1] - [P2] at this point of V_Z contains an arc
  leaving V_Z (finite order: evidence).
- fail at order k: the cone map does not carry over to tenfolds as stated; T5 falls.

P3 (MOD p, two instances; M2). Honest cone member F = x10 Q1 + x11 Q2 + det A + det B, A, B random in x0..x7:
smooth; Hilbert function of S/I is 1,10,35,52,35,10,1; hodgeLocusTangentCodim(F, I(T5)) = 52.
- as predicted: cone members are points of T2S with the same first-order behaviour (hypothesis of T3 at them).
- tangent codimension < 52: T2S is not a component there; T3 fails at cone members and T5 needs another route.

P4 (MOD p; M2; a statement about the model cone only). Jacobian rank of the 27 quadrics of T6 at random points:
14 on the common-kernel piece (so that piece has dimension 13 and the scheme is reduced there), 16 on a Segre
cone (dimension 11; T6 recorded rank 16 for DG4), 18 on a piece (A, 0, 0).
- as predicted: the hand computation of V_4 stands.
- otherwise: the hand computation is wrong; T6 of this file is withdrawn.

P5 (MOD p; package fermatExtendArc on the tenfold; order 4 is the first non-zero order at X0, so the outcome
does not depend on the choice of T_2, T_3; O-TENFOLD-CONE-LEAD). At X0 with Movasati's pair, lambda = -1, and
lambda = 2 as a control that order 4 does not see lambda. T_1 = y_0 + sum N_ijk f_i h_j z_k with y_0 a cubic in
x0..x5 in ker L and not in T V_Z:
(a) N generic of rank 3: obstructed at order 4 (reproduces T6 and paper #5).
(b) N generic of rank 2 (not in V_4): obstructed at order 4.
(c) N in a Segre cone: order 4 passes (reproduces T6).
(d) N generic in the 13-dimensional piece: order 4 passes. NEW.
(e) N = z_0 C' with det C' != 0: order 4 passes (the sixfold obstruction is at order 5).
Meaning:
- (a)-(e) as predicted: the order-4 model of T6 is supported at five directions; T6's bound "dim Cone_T + 11"
  is incomplete and the order-4 bound at X0 becomes codimension >= 52. It does NOT show that a component of
  codimension 52 exists at X0 (order 4 only).
- (d) obstructed: the model is wrong; T6's bound 54 stands; then T5 applied at X0 contradicts it, so either (S)
  fails at the points C = 0 or the cone argument has a gap. Record as an open contradiction.
- (a) or (c) not reproduced: my T_1 construction (y_0, the map to nets) is wrong; fix before reading (d).

P6 (only if P5 passes and time allows; MOD p). The direction (d) at orders 5 and 6 for lambda = -1 and 2, with
the removability caveat of O-TENFOLD-CONE-LEAD ("do not read an obstruction above the first non-zero order as
final"). Prediction: no obstruction for lambda = -1 that survives a change of lower terms. Not decisive either
way at this depth.

## 3. Not planned in this batch

Recovering A(eps), B(eps) along T2's arc (O-RECOVER-MATRICES-AND-LIMIT-OF-T): this is what would replace (S) by a
computation; several hours; held for the owner's decision.

## 4. Added at 15:13 UTC, after P1-P5 and BEFORE the order-5 runs (script vz5)

Seen so far: P1-P5 all as predicted (logs/vz/). First look at order 5 on direction (d), lambda = -1, with the
package's own choice of T_2, T_3, T_4: obstructed at order 5. By O-TENFOLD-CONE-LEAD this is not final: on the
smooth germ Sigma (tangent space ker L) the dependent equations are Psi_4 + Psi_5 + ..., and along an arc
tau_1 eps + tau_2 eps^2 + ... the order-5 condition is Psi_5(tau_1) + DPsi_4(tau_1)[tau_2] = 0, affine in tau_2.

P6a (MOD p; vz5; lambda = -1, direction (d)). The order-5 obstruction vector o_0 lies in the image of
k -> o(tau_2 + k) - o(tau_2), k running over the 27 net directions f_i h_j z_k (expected rank 14 = Jacobian rank of
the model quadrics on the 13-dimensional piece): the obstruction is removable.
- removable: an arc with this T_1 exists to order 5 for [P1] - [P2]; consistent with a component whose tangent
  cone contains the cylinder over the 13-dimensional piece. Evidence at order 5 only.
- not removable: no arc with leading term T_1 in integer powers of eps passes order 5. Then the conditional
  statement T5 at the Movasati point is in tension with the computation: either the closure of T2S is not there,
  or its tangent cone is not this cylinder, or arcs need fractional powers. To be recorded as such, not explained
  away.
- rank of the image different from 14: the order-4 forms are not exactly the model quadrics (or the 27 directions
  do not span the image); report the rank.
P6b (same, lambda = 2). No prediction from T5 (it concerns lambda = -1 only). If removable for -1 and not for 2:
the directions (d) single out lambda = -1 at order 5, as the factor (lambda + 1)^2 does on eightfolds
(D-X1-ORDER5-FORMULA). If removable for both: order 5 does not separate them (T6 found the same for a rank-1
direction at lambda = 2, with an obstruction at order 6).
Control inside vz5: three random elements k of ker L must give vectors in the span of the 27 (cylinder structure).

## 5. Outcomes (written after the runs, 26 Nov, about 17:30 UTC)

| prediction | outcome |
|---|---|
| P1 | as predicted: 38, 39, excess 1 (EXACT) |
| P2 | as predicted: pass to order 9, 221 forms; T_1 not tangent to V_Z; control P1 + P2 fails at order 1 (EXACT) |
| P3 | as predicted at (32003, 1) and (31991, 2) |
| P4 | as predicted: 14, 16, 18. The blind check added the full decomposition (six components, degree 540 for the 13-dimensional one) |
| P5 (a)-(e) | all as predicted, at (32029, 1) and (31981, 2) for lambda = -1 and (32029, 1) for lambda = 2 |
| P6a | removable; rank 14; controls in the span; at (32029, 1) and (31981, 2) |
| P6b | removable as well (32029, 1): order 5 does not separate lambda = -1 from 2 |

No prediction failed in this batch. Corrections from blind check 10, taken into the lead note: the proof of
"Ann(delta_2) = I at every smooth member" in T3 (the Gorenstein property carries it, not the Hilbert function);
T3 is about cubics literally of the form, not limits; the two-step pairing formula is 4 (a, b) - deg a deg b and
a general member is not an iterated one-step cone (flatness is needed); P2 is a formal consequence of the
eightfold statement. Deviation: the wall-clock times first written in this file were wrong by about half an hour
and were corrected from the file times.
