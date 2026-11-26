# Fake linear cycles on quartic sixfolds

- The class 3[P1] + [P2] - 3[P4] on the Fermat quartic sixfold; its Hodge locus contains Sigma_4 (codimension 38, a reduced component) and explained cone loci E1, E2.
- No unexplained piece of the Hodge locus was found: every candidate direction at the Fermat point was killed by an explicit certificate, and at general points of the corank-6 strata the reduced locus is Sigma_4.
- It is not a theorem: the balanced regime at pencil-type points is undecided (one explicit polynomial w), and three loopholes remain at the Fermat point.

> **Status of everything on this page:** produced by AI agents, checked only by other AI agents, reviewed by no human. Sources of published results were read by machine (see `tests/SOURCES.md`). The notes cited as "unreviewed note 1, 2, 3" are AI-written and unreviewed (in papers/). Nothing here is, or bears on, a proof or disproof of the Hodge conjecture. This is a registry of what was found, ruled out or left open, not a list of established theorems.

Generated from `discoveries/registry.yaml` by `discoveries/check_registry.py --write-pages`. Do not edit this page by hand: edit the registry. Notation: [`NOTATION.md`](NOTATION.md). Status vocabulary: [`README.md`](README.md).

## Entries on this page (12)

| id | status | title |
|---|---|---|
| [D-FAKE-CLASS-EXPLICIT](#d-fake-class-explicit) | `PAPER_ARGUMENT_AI` | The smallest fake linear cycle on the Fermat quartic sixfold is 3[P1] + [P2] - 3[P4], a join of 0-cycles |
| [D-SIGMA4-COMPONENT](#d-sigma4-component) | `MOD_P` | Sigma_4 (a P^4-section splits into four hyperplanes), codimension 38, is a reduced component for the fake class |
| [D-EXPLAINED-LOCI-E0-E1-E2](#d-explained-loci-e0-e1-e2) | `MOD_P` | Explained loci through the Fermat point: E0 inside Sigma_4, cone loci E1 (codim 72) and E2; none is a new reduced component |
| [D-CONIC-DIVISOR-EMBEDDED](#d-conic-divisor-embedded) | `PAPER_ARGUMENT_AI` | At general points of the conic divisor of Sigma_4: embedded structure only, no new reduced branch |
| [D-FAKE-CODIM-BOUND-33](#d-fake-codim-bound-33) | `MOD_P` | Every component of the Hodge locus of the fake class through the Fermat point has codimension at least 33 |
| [D-CANDIDATE-NU-T-KILLED](#d-candidate-nu-t-killed) | `EXACT` | The one candidate direction nu_t is not the velocity of any arc: universal certificate q = x0 x6 (x2 - z x3)^2 |
| [D-TEN-FAMILIES-KILLED](#d-ten-families-killed) | `MOD_P` | Fourth-order cone on the stratum y = w D_0: ten families of directions, each killed by universal certificates |
| [D-CORANK6-STRATA](#d-corank6-strata) | `PAPER_ARGUMENT_AI` | At general 'three hyperplanes through a common plane' points of Sigma_4 the reduced Hodge locus is Sigma_4 |
| [D-PENCIL-TYPE-CLOSED-PART](#d-pencil-type-closed-part) | `MOD_P` | Pencil-type points of Sigma_4 (corank 12): no branch transversal to Sigma_4; two of three regimes excluded |
| [D-PENCIL-REDUCTION-TO-W](#d-pencil-reduction-to-w) | `PAPER_ARGUMENT_AI` | At split pencil-type points the leading problem is Res_h of one polynomial w(t1,t2,n1,n2) independent of the cubics |
| [D-PENCIL-W-ALGEBRA](#d-pencil-w-algebra) | `EXACT` | Algebraic properties of the polynomial w: no critical point with n != 0; (n1,n2)^4 in the Jacobian ideal |
| [D-FAKE-TYPE-FIRST-RANKS-OTHER-DEGREES](#d-fake-type-first-ranks-other-degrees) | `MOD_P` | First-order ranks for combinations of the linear spaces of one P^(k+1)-section in other degrees |

## Related entries on other pages

| id | kind | status | page | title |
|---|---|---|---|---|
| [N-SYMMETRIC-DEGENERATION-PENCIL](06_ruled_out_and_dead_ends.md#n-symmetric-degeneration-pencil) | dead_end | `RULED_OUT` | 06 | Degenerating to a symmetric point can never show emptiness of the balanced regime at pencil-type points |
| [N-LOW-DEGREE-CERTIFICATES-PENCIL](06_ruled_out_and_dead_ends.md#n-low-degree-certificates-pencil) | dead_end | `STUCK` | 06 | No inconsistency certificate for the balanced system up to weighted degree 8; all exact runs timed out |
| [N-REDUCED-LOCUS-IS-SIGMA4-AT-FERMAT](06_ruled_out_and_dead_ends.md#n-reduced-locus-is-sigma4-at-fermat) | negative | `RULED_OUT` | 06 | 'The reduced Hodge locus of the fake class is Sigma_4 near the Fermat point' is false; so is the third-order criterion |
| [N-DPRIME-PROXY](06_ruled_out_and_dead_ends.md#n-dprime-proxy) | dead_end | `RULED_OUT` | 06 | The auxiliary class D' at the Fermat point is a poor proxy for the general point of the cone locus E1 |
| [O-PENCIL-REGIME](07_open_problems.md#o-pencil-regime) | open | `STUCK` | 07 | Pencil-type points of Sigma_4: does the balanced system (nu ~ tau^2) have a solution at a general point? |
| [O-SEXTIC-FOURFOLDS-CUBIC-TENFOLDS](07_open_problems.md#o-sextic-fourfolds-cubic-tenfolds) | open | `OPEN` | 07 | Fake linear cycles on sextic fourfolds and cubic tenfolds: not started beyond first-order ranks |
| [O-FERMAT-LOOPHOLES](07_open_problems.md#o-fermat-loopholes) | open | `CONJECTURE` | 07 | Three loopholes at the Fermat quartic sixfold, and the statement with gaps for fake linear cycles |
| [O-E1-GENERAL-POINT-AND-E2](07_open_problems.md#o-e1-general-point-and-e2) | open | `STUCK` | 07 | Is the cone locus E1 a component of the reduced locus at its general point? What does E2 contain? |
| [C-RANDOM-SAMPLING-MISSED-VALUES](08_corrections_and_lessons.md#c-random-sampling-missed-values) | correction | `MOD_P` | 08 | T1's random sampling missed special parameter values; those strata were redone exactly |
| [C-CUBIC-LIFT-DEPENDENCE](08_corrections_and_lessons.md#c-cubic-lift-dependence) | correction | `PAPER_ARGUMENT_AI` | 08 | 'The cubic c is non-degenerate' at triple points depends on a choice of lift; condition (A) replaced it |

---

## D-FAKE-CLASS-EXPLICIT

**The smallest fake linear cycle on the Fermat quartic sixfold is 3[P1] + [P2] - 3[P4], a join of 0-cycles**

kind: `result` | area: `fake_linear_cycles` | status: **`PAPER_ARGUMENT_AI`**

**Statement.**

```text
Setting: the Fermat quartic sixfold X in P^7, pairs (x0,x1), (x2,x3), (x4,x5), (x6,x7), z = zeta_8, i = z^2.
"Fake linear cycles" (Duque Franco and Villaflor Loyola) are Hodge classes on Fermat varieties whose Hodge locus
has the same Zariski tangent space dimension as that of a linear subspace without being the class of one.
(1) They are joins of 0-cycles: the period polynomial is a product over the pairs, P = prod_j q_j(pair j), and
    the class is a_1 * a_2 * a_3 * a_4 with a_j a rational 0-cycle of degree 0 on the 4 points {x^4 + y^4 = 0} of the
    j-th line. For d = 4, with pt_m = [z^(2m-1) : 1] and u = a_1 - a_3, v = a_2 - a_4, w = a_1 - a_2 + a_3 - a_4, a factor is of
    "linear type" iff u^2 + v^2 = w^2, with constant c = z w/(u + i v).
(2) The smallest fake one: a = (3, 1, 0, -3), c = z (3 - 4i)/5, that is
        delta = 3[P1] + [P2] - 3[P4],  P_m = {x0 = z^(2m-1) x1, x2 = z x3, x4 = z x5, x6 = z x7},
    the P_m being the four P^3 in which the P^4 {x2 = z x3, x4 = z x5, x6 = z x7} meets X (their sum is h^3).
(3) All Taylor coefficients of the period functions at the Fermat point are in closed form, and the Hodge locus is
    the critical locus of ONE function W(G) = Phi(exp(-G)) (the period of Omega/F^2; h^(5,1) = 1):
    f_Q(G) = 3 Phi(Q exp(-G)) for all quartics Q.
(4) The Hessian of W at the Fermat point has rank 19 for a true linear cycle and for delta; its kernel is
    T = (w, y_2, y_3, y_4)_4 + J_4, of dimension 311, with w = x0 - c x1 and y_j = x_(2j-2) - z x_(2j-1).
```

**Data.**

Closed form: Phi(x^b) = prod_i ((r_i + 1)/4)_(q_i) * pi(x^r), b_i = 4 q_i + r_i, zero unless all r_i <= 2 and each
pair has r + r' = 2; pi = prod_j c_j^(r_(2j-2)); (a)_q is the Pochhammer symbol.
Other decompositions (exact, integer arithmetic on the intersection form; paper for mixed pairings): on the
Fermat quartic surface (48 lines) the class 3L1 + L2 - 3L4 is, modulo h, a combination of at most 4 lines only
through the four coplanar concurrent lines. Among the 256 linear P^3 of the standard pairing the only
expressions of delta modulo h^3 with at most 3 of them are the four triples of the P_m. For at most 3 linear P^3
from any of the 105 pairings (26880 spaces): none besides those. Numerics: delta.h^3 = 1, delta^2 = -506.
Not examined: expressions with 4 or more spaces from mixed pairings.

**Conditions.**

Griffiths-Dwork reduction at the Fermat point (Pochhammer weights) and the period of a linear cycle; the published
definition of fake linear cycles, read through a summariser only.

**Evidence.**

Team T1, round 1 (flc.py, step1_validate.py at p = 30089: for a true linear cycle and G random in the ideal of its
P^3, Phi(Q G^m) = 0 for all 330 Q, m = 1, 2, 3; a wrong Pochhammer factor would give non-zeros). Rank 19 and dim
311: step2_cubic.py. Decompositions: step28_lines.py, step29_std_triples.py (exact).

**Independent check.**

C2 (MOD p = 32611): P_1 + P_2 + P_3 + P_4 lies in the Jacobian ideal; the codimensions 19 (one P_m) and 38 (delta
at a random point of Sigma_4). Not covered: the closed form itself; the join description; the paper's definition.

**Not established.**

That the explicit description agrees with the published paper beyond what a summariser returned (the paper never
writes a fake linear cycle as a combination of linear spaces, as far as read).

**Known before.**

published: Duque Franco, Villaflor Loyola, arXiv:2112.14818 (fake linear cycles exist only for d = 3, 4, 6;
non-reducedness of the Hodge locus at the Fermat point through a second-order form). That paper is not in
tests/SOURCES.md; it was machine-read twice in the session. The explicit combination, the join description and the
component Sigma_4: not found in the sources we read (machine-read, see tests/SOURCES.md); not checked further.

**Reproduce.**

Run from the repository root (Macaulay2 1.22). First-order numbers at the Fermat point, exact over Q(zeta_8) (a
list {a,b,e} means x_a = z^e x_b):

```
needsPackage("HodgeLociCI", FileName => "M2/HodgeLociCI.m2");
S = fermatRing(4, 6);
P = m -> {{0,1,2*m-1},{2,3,1},{4,5,1},{6,7,1}};
u = fermatTangentData(S, {P 1}, {1}); print(u#"hodgeCodimension");
v = fermatTangentData(S, {P 1, P 2, P 4}, {3, 1, -3}); print(v#"hodgeCodimension", v#"jointPersistenceCodimension");
```

Expected: 19 and (19, 38), exact over QQ(zeta_8) according to the key "label": tangent codimension 19 for the fake
class as for a linear cycle, and codimension 38 for "all three P_m persist". Higher order: the package's Fermat
functions take linear spaces of the standard type and were tested for quartic sixfolds, but no fake-cycle run is
in the test suite.

**Session references (files not public).**

LEDGER_DISCOVERY.md "[T1] 04:06Z", "[T1] 04:24Z", "[T1] 05:55Z" (item A), "[CHECK C2]";
discovery/t1_fake_linear/flc.py.

---

## D-SIGMA4-COMPONENT

**Sigma_4 (a P^4-section splits into four hyperplanes), codimension 38, is a reduced component for the fake class**

kind: `result` | area: `fake_linear_cycles` | status: **`MOD_P`**

**Statement.**

Sigma_4 := {quartic sixfolds X such that some P^4 meets X in four hyperplanes (four P^3)}. Its codimension is 38 by
a parameter count; at the Fermat point its tangent space is (y_2, y_3, y_4)_4 + (x0, x1)^3 S_1 + J_4, of
codimension 38 (dimension 292), inside the kernel T of D-FAKE-CLASS-EXPLICIT.
At a random point of Sigma_4 (F = l_1 l_2 l_3 l_4 + x5 h_2 + x6 h_3 + x7 h_4, l_m random linear forms in x0..x4)
the Hessian of the period of 3[P1] + [P2] - 3[P4] (all 24 orderings of the weights) has rank 38 = codim Sigma_4.
So Sigma_4 is a component of the Hodge locus of this class and the locus is reduced at its general point.

**Data.**

Controls at the same random points: weights a = (1,1,1,1) give rank 0 (the sum is h^3); a = e_m gives 19 (one P^3);
a = (1,1,0,0) gives 26 (= codimension of "contains a quadric threefold"); a = (1,-1,0,0) gives 32. Sign variants
3P1 + P2 + 3P4 and 3P1 - P2 + 3P4 give 32 (checker).
Degenerate strata of Sigma_4 (rank of the Hessian for the fake class): four hyperplanes through a common line:
38 (not degenerate); three through a common plane: 32 (corank 6); all four through a common plane, "pencil type":
26 (corank 12); pencil type with the Fermat cross-ratio (the stratum of the Fermat point, codimension 7 in
Sigma_4): 19 (corank 19), system of quadrics of dimension 7 with general member of rank 14, as at Fermat.
Conic: at a random point X of Sigma_4 the determinant of the 38 x 38 normal Hessian of sum a_m [P_m] is
const * prod_(i<j) (a_i - a_j)^6 * q_X(a), with q_X = b_1 b_2 + mu b_1 b_3 + nu b_2 b_3, 1 + mu + nu = 0, b_i =
a_i - a_4: a conic through the four coordinate points; mu depends on X; on the conic the rank is 37. At Fermat the
conic is the Pythagorean one (mu = -2, nu = 1) and carries the fake linear cycles.

**Conditions.** Random points: p = 30089 seeds 1, 2; p = 32009 seed 3. The passage to characteristic 0 by semicontinuity.

**Evidence.** Team T1 (step3_generic.py, step6_disc.py, step7_conic.py; strata_general.py for the strata).

**Independent check.**

C2 (blind, own code, p = 32611, two random instances): 19, 38, 26, 32. Caveat of the checker: the direct rank
computation did not finish; the values come from an equivalent bilinear-form computation tied to brute-force
normal forms by spot tests, so 'at most' is brute force and equality rests on a duality argument.

**Not established.**

An exact (characteristic 0) rank. Irreducibility of Sigma_4 is asserted, not checked. Other branches of Sigma_4
through a given point were not examined.

**Known before.** not found in the sources we read (machine-read, see tests/SOURCES.md); not checked further

**Reproduce.**

not reproducible from this repository at a random point of Sigma_4: the residue pipeline for four hyperplanes is a
session script. At the Fermat point the package gives the codimensions 19 and 38 (snippet in
D-FAKE-CLASS-EXPLICIT).

**Session references (files not public).** LEDGER_DISCOVERY.md "[T1] 04:06Z", "[T1] 04:19Z", "[CHECK C2] 04:52Z", "[T1] 16:14Z", "[T1] 16:26Z".

---

## D-EXPLAINED-LOCI-E0-E1-E2

**Explained loci through the Fermat point: E0 inside Sigma_4, cone loci E1 (codim 72) and E2; none is a new reduced component**

kind: `result` | area: `fake_linear_cycles` | status: **`MOD_P`**

**Statement.**

```text
For delta = a * pt_2 * pt_3 * pt_4 (a = 3pt_1 + pt_2 - 3pt_4) the "explained" loci through the Fermat point,
indexed by the block B of pairs containing the fake pair, are:
E0 (B = {1}): pencil-type points (the P^4-section is a cone over 4 points with vertex a plane; codimension 44),
   inside Sigma_4 (codimension 38). The class is a combination of linear spaces.
E1(j), j = 2, 3, 4 (B = {1,j}): a P^5-section is a cone, with vertex a line, over a quartic surface carrying the
divisor
   class D_a = 3L1 + L2 - 3L4 (D.h = 1, D^2 = -56). Codimension 72. The class is algebraic by Lefschetz (1,1).
E2(j,j') (three choices; B = {1,j,j'}): a P^6-section is a cone, with vertex a point, over a quartic fourfold in the
   Hodge locus of a * pt_j * pt_j'. Codimension 71 + c with 6 <= c <= 14. Algebraic through the Hodge conjecture for
   quartic fourfolds (recalled from memory, not re-read); no explicit cycle.
Status: (i) the reduced Hodge locus near Fermat is strictly larger than Sigma_4: it contains the E1(j) (slice
argument on paper; inclusion checked to 5th order along a generic curve). (ii) E1 is not a reduced component:
along it the tangent space of the Hodge locus has codimension 48, not 72 (24 extra directions). (iii) The sum
of the tangent spaces of E0, E1, E2 at Fermat is 310 of the 311 dimensions of T; the one missing direction is
w x3 x5 x7.
```

**Data.**

Tangent spaces at Fermat (dimensions, p = 30089): E0: (y_2,y_3,y_4)_4 + (x0,x1)^3 S_1 + J_4, 292. E1(j): 258. E2
(Zariski, an over-estimate): 253 (codimension 77). E0 + E1's: 298; with the E2's: 310.
Slice: on the 35-dimensional slice G = G_A(x0..x3) all 330 period functions are multiples of one function with
nonzero linear part: the Hodge locus meets the slice in a smooth hypersurface (dimension 34), the
Noether-Lefschetz locus of D_a on the quartic surface, while T Sigma_4 meets the slice in dimension 32.
Series of elementary divisors of the Hessian along curves (valuations in s): inside Sigma_4: [19, 14, 5] (total 38);
inside E1(2), dense curve: [19, 13, 4, 6, 3, 0] (45 through s^5); surface part only (split points):
[19, 13, 4, 6, 3, 0, 0, 3] (48 = 18 + 3*10 through s^7). Split-point count: with h^B = (1,2,3,2,1), codim T at a
split point is sum_i h^A_i h^B_(4-i): line 19, conic 26, D_a at a general point of its Noether-Lefschetz locus
(1,4,10,4,1) -> 48.
Auxiliary class D' on the Fermat surface with the same numerics (D'.h = 1, D'^2 = -56;
n = [[-2,0,1,-2],[1,-1,0,2],[0,2,0,0],[0,0,0,0]]): rank 48 at Fermat already; its cone locus has codimension 72.
Normal quartic of E1 at X: lambda_X(Psi_S(u K_3 + v K_4)), Psi_S a quartic form on a 12-dimensional space attached
to the surface and its class; E1 is a component of the reduced locus as soon as Psi_S has no nonzero critical
point for the general surface (numerical evidence only, for the auxiliary class).
The fourfold level: at a random point of the four-planes locus of quartic fourfolds (codimension 14) the tangent
rank is 10 < 14, so that locus is not a reduced component there; what else the fourfold locus contains is unknown.

**Conditions.**

Primes 30089, 32009, 30097; the Fermat point and curves through it; for E1 partly the auxiliary class D' (same
lattice; that it lies on the same irreducible family was not checked).

**Evidence.**

Team T1, rounds 1 to 4 (step5_cone.py, step8_slice.py, step11_list.py, step12_curves.py, step13_dprime.py,
step31-33).

**Independent check.**

C2 (the slice: rank 1 and dimension 32; the checker notes this part does not depend on the constant c). C6 (two
primes, six roots of unity, own code + Macaulay2): for the class D', tangent codimension 48, cone-locus tangent
space of codimension 72 inside it, second-order form vanishing on the kernel; control 19 for the fake column.

**Not established.**

Whether E1 is a component of the reduced locus at its general point (numerical evidence only; see
O-E1-GENERAL-POINT-AND-E2). What E2 contains. Whether the 24 extra directions integrate.

**Known before.** not found in the sources we read (machine-read, see tests/SOURCES.md); not checked further

**Reproduce.**

not reproducible from this repository: needs the session's series code (Hessian along curves over F_p[[s]]). At
Fermat the kernel dimension 311 = 330 - 19 is the first number of the snippet in D-FAKE-CLASS-EXPLICIT.

**Session references (files not public).**

LEDGER_DISCOVERY.md "[T1] 04:19Z", "[T1] 04:29Z", "[T1] 04:47Z", "[T1] 04:56Z", "[T1] 05:03Z", "[T1] 05:23Z",
"[T1] 05:55Z" (item C), "[CHECK C6]".

---

## D-CONIC-DIVISOR-EMBEDDED

**At general points of the conic divisor of Sigma_4: embedded structure only, no new reduced branch**

kind: `result` | area: `fake_linear_cycles` | status: **`PAPER_ARGUMENT_AI`**

**Statement.**

For a rational weight vector a, let D_a = {X in Sigma_4 : a lies on the conic q_X of D-SIGMA4-COMPONENT}; there the
normal Hessian of the class sum a_m [P_m] has corank 1. At a general point of D_a the reduced potential is
(1/2) h(sigma) nu^2 + c nu^3 + ..., with h the conic factor as a function on Sigma_4 and nu the kernel coordinate.
dh != 0 at a general point because the conic parameter mu(X) is not constant (two different values at two random
points) and b_3 (b_1 - b_2) = 6 != 0 for a = (3,1,0,-3). The derivative along Sigma_4 gives nu^2 * unit = 0. So the
Hodge locus is Sigma_4 with an embedded non-reduced structure along D_a, and there is no new reduced branch
through general points of D_a.

**Conditions.** The round-1 MOD p data (mu = 16915 and 11834 at two points, p = 30089); mu was not computed exactly.

**Evidence.** Team T1, 15:25Z (one-line argument from the round-1 computations).

**Independent check.** none

**Not established.** Special points of D_a. No point of D_delta away from pencil-type points was produced.

**Known before.** not found in the sources we read (machine-read, see tests/SOURCES.md); not checked further

**Reproduce.** not reproducible from this repository: see D-SIGMA4-COMPONENT.

**Session references (files not public).** LEDGER_DISCOVERY.md "[T1] 04:19Z", "[T1] 15:25Z".

---

## D-FAKE-CODIM-BOUND-33

**Every component of the Hodge locus of the fake class through the Fermat point has codimension at least 33**

kind: `result` | area: `fake_linear_cycles` | status: **`MOD_P`**

**Statement.**

At the Fermat point the third-order term of the potential reduces to a cubic in 26 variables (58 monomials) on
T / K_Sigma, where K_Sigma (dimension 285) is the radical of the cubic form on T. A Groebner basis truncated in
degree 6 gives dim Crit(cubic) <= 12, so the third-order cone has dimension at most 285 + 12 = 297 and every
component of the Hodge locus through the Fermat point has codimension >= 33. The expected value is 38.

**Conditions.** p = 30089; truncated Groebner basis (an upper bound for the dimension); characteristic 0 by semicontinuity.

**Evidence.** Team T1, round 2 (crit_db.sing).

**Independent check.** none

**Not established.** Codimension >= 38. The full critical locus was never computed (see N-GROEBNER-RUNS-NOT-FINISHED).

**Known before.** not found in the sources we read (machine-read, see tests/SOURCES.md); not checked further

**Reproduce.** not reproducible from this repository: the 26-variable cubic is a session file (crit_30089.sing).

**Session references (files not public).** LEDGER_DISCOVERY.md "[T1] 04:56Z", "[T1] 05:25Z".

---

## D-CANDIDATE-NU-T-KILLED

**The one candidate direction nu_t is not the velocity of any arc: universal certificate q = x0 x6 (x2 - z x3)^2**

kind: `result` | area: `fake_linear_cycles` | status: **`EXACT`**

**Statement.**

```text
Candidate. For t != 0 let nu_t = (x0 - c_1 x1) x7 (x3^2 + t x3 x5 - (t^2/2) x5^2) on the Fermat quartic sixfold
(z = zeta_8, c_1 = z (3 - 4i)/5 the fake constant). It lies in T, is tangent to none of E0, E1, E2, is not in the
sum of their tangent spaces, and the pure arc s nu_t satisfies the period equations to order 3 (to order 4 exactly
when t^4 = -4).
Certificate. Let q = x0 x6 (x2 - z x3)^2 (q lies in T). For EVERY formal arc G(s) = s nu_t + s^2 G_2 + s^3 G_3 + ...
with arbitrary quartics G_j, the period function f_q = Phi(q exp(-G(s))) has zero coefficients of s^1, ..., s^4 and
    [s^5] f_q = - Phi(q nu_t^5)/120 = - (3/1024) c_1^2 z^3 (1 + c_1^4) t^2,
which is nonzero for every t != 0 because c_1^4 != -1. Since f_q is a linear combination of the equations of the
Hodge locus, no formal arc through the Fermat point with velocity proportional to nu_t lies in the Hodge locus.
This holds in characteristic 0, as an identity in t.
```

**Data.**

General form of the family: nu = w z_k U_0(z_i, z_j), {i,j,k} = {2,3,4}, U_0 = a z_i^2 + c z_i z_j + b z_j^2 with
c^2 + 2ab = 0 (equivalently U_0^2 = 0 modulo (z_i^3, z_j^3)); here w = x0 - c_1 x1 and the z_j are the second
coordinates of the pairs modulo (y_2, y_3, y_4).
Factors of the constant: Phi(q nu_t^5) = (45/128) c_1^2 z^3 (1 + c_1^4) t^2, product of the pair factors
Phi_1(x0 w^5) = (3/4) c_1^2 (1 + c_1^4), Phi_23((x2 - z x3)^2 U_0^5) = (15/16) z^2 t^2, Phi_4(x6 x7^5) = z/2.
Exact value of the coefficient of t^2 in [s^5] f_q over Q(z): -(189/62500) z - (4743/1000000) z^3.
Why only q nu^5 survives (three rules): (R0) Phi vanishes unless every pair degree is 2 modulo 4; (R2) the pair-2
functional kills (x2 - z x3)^2 times anything of degree 0 or 4; (R1) the pair-1 functional kills x0 w in degree 2.
Earlier certificate at order 4 (check C10), q_e = x0^2 x6 (x6 - z x7): the s^4 coefficient is
Phi(q_e nu^4)/24 = - c_1^2 z^2 (1 + c_1^4) t^2 (4 + t^4)/512; it vanishes exactly at the four values t^4 = -4,
which is why random-t scans reported the candidate dead one order too early.
At t^4 = -4 independently: the complete order-5 system with all corrections free has no solution (MOD p, four
(prime, t) pairs). nu_t is tangent to "Lambda persists" for none of the 26880 linear P^3 of the Fermat quartic
sixfold (MOD p).

**Conditions.** The closed form of the periods at the Fermat point (D-FAKE-CLASS-EXPLICIT(3)).

**Evidence.** Team T1 (step43_order5_full.py, step46_universal_cert.py, step44_all_linear_spaces.py).

**Independent check.**

C14 (blind, own code): q in T exactly over Q(z); the closed form as an identity in t; vanishing of the lower
coefficients for arbitrary G_j by evaluating every multilinear form that can occur, with t symbolic, and on 30
arcs with dense random G_2..G_6 at two primes; the structural argument with the third rule added. C10: the order-4
statement at random t and the four live values. Not covered: anything about Sigma_4; other test forms.

**Not established.**

Not excluded by this certificate: (a) arcs of zero velocity whose leading term is nu_t (nu_t lies in the tangent
cone of the single hypersurface f_q = 0); (b) velocities nu_t + k with k in K_Sigma, inside T Sigma_4; (c)
components whose whole tangent cone lies in T Sigma_4; (d) the two limit directions w x7 x3^2 and w x7 x5^2 (t = 0
and t = infinity), which lie in the Zariski tangent spaces of E2 loci and get no information from q.

**Known before.** not found in the sources we read (machine-read, see tests/SOURCES.md); not checked further

**Reproduce.**

not reproducible from this repository: the identity uses the closed form Phi of the session (flc.py). It is
hand-checkable from the three pair factors above. Needed in the package: a function evaluating Phi(q G^m) for
arbitrary quartics at the Fermat quartic sixfold (fermatPeriod covers single monomials).

**Session references (files not public).**

LEDGER_DISCOVERY.md "[T1] 05:12Z", "[T1] 05:19Z", "[CHECK C10] 06:07Z", "[T1] 06:11Z", "[T1] 15:08Z", "[CHECK C14]
15:37Z", "[COORD] 15:40Z".

---

## D-TEN-FAMILIES-KILLED

**Fourth-order cone on the stratum y = w D_0: ten families of directions, each killed by universal certificates**

kind: `result` | area: `fake_linear_cycles` | status: **`MOD_P`**

**Statement.**

```text
On the stratum of directions y = w D_0(z_2, z_3, z_4) at the Fermat point (D_0 a cubic with 7 coefficients d_abc; no
other part), the fourth-order conditions {rho(D_0^2) = 0, psi_Q(w D_0) = 0 for all Q in K_Sigma} (88 independent
cubics) define a cone of affine dimension 3 with 10 irreducible components, each the closure of an orbit of the
torus scaling z_2, z_3, z_4:
 - 2 with all seven coefficients nonzero (d210 d012 = d201 d021 = d120 d102 = -d111^2/6); conjugate over Q(sqrt 42);
 - 2 with d111 = 0;
 - 6 of the form D_0 = z_k U_0(z_i, z_j) + mu z_k^2 (2 kappa a z_i + c z_j), U_0 = a z_i^2 + c z_i z_j + b z_j^2, c^2 + 2ab = 0,
   kappa = 1 +- sqrt(3/2) (these need sqrt 6). The family nu_t of D-CANDIDATE-NU-T-KILLED is their boundary mu = 0.
What killed them: at a general point of each component there are forms q (11 or 21 independent ones) with
Phi(q y^a P) = 0 for all P of degree 4r with a + 2r <= 4 and a < 4, and Phi(q y^4) != 0. For every arc s y + s^2
G_2 + ... with arbitrary G_j this gives [s^4] Phi(q exp(-G)) = Phi(q y^4)/24 != 0: the direction is the velocity
of no arc in the Hodge locus. The points where all order-4 certificates valid on a whole component vanish are
exactly: (a) the three two-variable strata D_0 = a z_j^2 z_j' + b z_j z_j'^2, which lie in the Zariski tangent
space of the cone-over-fourfold locus E2(j,j') (explained level); (b) on the six components of the third kind, the
family mu = 0, which has the order-5 certificate of D-CANDIDATE-NU-T-KILLED.
Result: no direction y = w D_0 outside the two-variable strata is the velocity of an arc in the Hodge locus.
```

**Data.**

Component list identical at primes 30097 and 30241 with two algorithms (Singular minAssGTZ; reversed variables with
minAssChar); at 30169 (where 42 is not a square) the two conjugate components appear as one over F_p. Stable spaces
of order-4 certificate forms per component: dimension 175 or 185, giving 6 or 8 independent quartic polynomials in
the coefficients of D_0. Eight of the ten components do not lie in the sum of the explained tangent spaces (the two
with d111 = 0 do).
Other strata, sampled only (random coefficients, p = 30097): every sampled third-order direction not tangent to
E0, E1, E2 is obstructed at order s^3: D_0 = 0 with the two quadrics in different coordinate planes; D_0 != 0 with
D_1 = D_1' = 0 for 58 of the 64 three-variable support patterns; the 3 patterns with nonzero g-part; 75 third-order
points over 39 patterns. Slice g = D_0 = 0: 9 components of affine dimension 4; stratum D_0 = 0 with g: affine
dimension 7, decomposition timed out.

**Conditions.** One stratum only (g = D_1 = D_1' = 0). Modulo three primes. Velocities exactly y = w D_0 (no K_Sigma part).

**Evidence.** Team T1, rounds 4 and 5 (step47_C4.py, step48_components.py, step50_peel_stable.py, step52_second_prime.py).

**Independent check.** none (the end-of-round report: 'three primes, two algorithms; not independently checked')

**Not established.**

Velocities y + k with k in K_Sigma; arcs tangent to Sigma_4 and singular branches; strata with g, D_1, D_1'
nonzero beyond samples (O-FERMAT-LOOPHOLES). The two-variable strata belong to the E2 level, which was set aside.

**Known before.** not found in the sources we read (machine-read, see tests/SOURCES.md); not checked further

**Reproduce.**

not reproducible from this repository: the tensor of cubic initial forms and the Singular decompositions are
session files.

**Session references (files not public).** LEDGER_DISCOVERY.md "[T1] 15:14Z", "[T1] 15:25Z", "[T1] 16:14Z" (item A), "[T1] 16:26Z" (item A).

---

## D-CORANK6-STRATA

**At general 'three hyperplanes through a common plane' points of Sigma_4 the reduced Hodge locus is Sigma_4**

kind: `result` | area: `fake_linear_cycles` | status: **`PAPER_ARGUMENT_AI`**

**Statement.**

```text
Let X be a general point of the stratum of Sigma_4 where three of the four hyperplanes of the P^4-section pass
through a common plane (no Fermat structure), and delta = sum a_m [P_m] with a = (3,1,0,-3) in any order. Then the
reduced germ of the Hodge locus of delta at X equals (this branch of) Sigma_4.
Inputs, computed modulo p at random points: (i) the Hessian has rank 32; kernel modulo T Sigma_4 of dimension 6;
Sigma_4 smooth there; (ii) the first-order variation of the normal Hessian along Sigma_4 is a net of quadrics
q_1, q_2, q_3 on the 6-dimensional kernel (3 = codimension of the stratum in Sigma_4), general member of rank 6;
(iii) with c the cubic on the kernel: (A) the reduced cubic c + 3 sum tau_i q_i has no critical point with nu !=
0; (B) there is no (tau, nu), both nonzero, with nu singular on the quadric of tau and in the base locus of the net.
Arc argument: for an arc nu = s^b nu_0 + ..., tau = s^a tau_0 + ... in the Hodge locus leaving Sigma_4: b < a or
tau = 0 gives a critical point (0, nu_0) of the reduced cubic; b = a gives a critical point (tau_0, nu_0); b > a
gives a solution of (B). All three are excluded.
```

**Data.**

Equivalent form in nu only (checker): (B) iff the base locus {q_1 = q_2 = q_3 = 0} in P^5 is a smooth complete
intersection surface of degree 8; (A) and (B) together iff the curve cut on it by c (degree 24) is a smooth
complete intersection.
The cubic c is defined on the kernel only up to c -> c + 3 sum L_i(nu) q_i(nu) (change of lift): its
non-degeneracy is lift-dependent (the checker built a lift with singular c); condition (A) is lift-invariant and
is what the argument uses.
The Zariski tangent space at such points has dimension 298 against 292 for Sigma_4: the Hodge locus is non-reduced
there.

**Conditions.**

Lemma 2.1(1),(3),(4) of the unreviewed note 3 (tested by three independent routes, not re-proved); rank 32 at
every nearby point of the stratum (sampled only); passage from characteristic p to 0; 'Sigma_4' means the branch
through the given four planes.

**Evidence.**

Team T1, round 5 (strata_general.py, strata_padic.py; p = 30089 seed 1 and p = 30097 seed 2; second-order data
cross-checked by a p-adic derivative).

**Independent check.**

C19 (blind, 62 minutes, own code, two NEW random points at p = 30089 and 32003): (i)-(iii) confirmed for all four
orders of the weights; the second-order functional re-derived by three routes independent of the squared-pair
formula; the arc argument read adversarially and found correct in all three cases under the listed assumptions.

**Not established.**

No characteristic-0 or exact computation. Special points of the stratum. Other branches of Sigma_4 through the
point. Nothing global.

**Known before.** not found in the sources we read (machine-read, see tests/SOURCES.md); not checked further

**Reproduce.**

not reproducible from this repository: the residue pipeline at random points of Sigma_4 is a session script. The
second-order functional itself is the package's secondOrderFunctional (see D-POINTWISE-FORMULA).

**Session references (files not public).** LEDGER_DISCOVERY.md "[T1] 16:14Z" (item C), "[T1] 16:26Z" (item B.2), "[CHECK C19] 17:49Z", "[COORD] 17:48Z".

---

## D-PENCIL-TYPE-CLOSED-PART

**Pencil-type points of Sigma_4 (corank 12): no branch transversal to Sigma_4; two of three regimes excluded**

kind: `result` | area: `fake_linear_cycles` | status: **`MOD_P`**

**Statement.**

```text
At a general pencil-type point of Sigma_4 (all four hyperplanes through a common plane, general cross-ratio), for
a = (3,1,0,-3), with tau the 6 normal directions of the stratum inside Sigma_4 and nu the 12 kernel directions:
(1) Hessian rank 26; kernel modulo T Sigma_4 of dimension 12; Sigma_4 smooth there; no first-order variation of
    the normal Hessian on the kernel (r = 0), so the cubic c on the kernel and the second-order form Q_(tau tau)
    are canonical;
(2) c is non-degenerate (critical locus = origin). Hence every tangent direction of the Hodge locus lies in
    T Sigma_4, and for every arc leaving Sigma_4 the leading direction nu_0 satisfies c(nu_0) = 0 (paper);
(3) the second-order normal Hessian Q_(tau tau) is a quadratic map of rank 12 at a general tau; D = {det Q_(tau
tau) = 0}
    is a hypersurface of degree 24, reduced and irreducible (a random plane section is a smooth curve);
(4) regime nu >> tau^2: excluded by (2). Regime nu << tau^2: excluded for tau_0 outside D by (3); at 6 random points
    of D (corank 1: c(nu_0) != 0 and M(nu_0) tau_0 != 0); and along the four planes of triple directions (rank 6;
    limiting conditions (A), (B) have no solutions).
Open: the balanced regime nu ~ tau^2 and special points of D (O-PENCIL-REGIME).
```

**Conditions.**

Two (prime, seed) pairs: (30089, 1) and (30097, 2); 5 or 6 sampled points for each exclusion; one plane section of
D.

**Evidence.** Team T1, rounds 5 and 6 (strata_general.py, strata_padic.py, pencil_limits.py, pencil_singD.py).

**Independent check.**

```text
C21 confirmed (i) rank 26 and the 12-dimensional kernel at split pencil-type points, two primes. The exclusions
(4) were not independently checked.
```

**Not established.**

The reduced locus at pencil-type points (the balanced regime is undecided). Constant rank 26 along the stratum
(sampled).

**Known before.** not found in the sources we read (machine-read, see tests/SOURCES.md); not checked further

**Reproduce.**

not reproducible from this repository: session scripts (residues at random hyperplane arrangements, Hessian modulo
p^3).

**Session references (files not public).** LEDGER_DISCOVERY.md "[T1] 16:14Z", "[T1] 16:26Z" (B.3), "[T1] 16:28Z", "[T1] 18:10Z", "[T1] 19:27Z" (item D).

---

## D-PENCIL-REDUCTION-TO-W

**At split pencil-type points the leading problem is Res_h of one polynomial w(t1,t2,n1,n2) independent of the cubics**

kind: `result` | area: `fake_linear_cycles` | status: **`PAPER_ARGUMENT_AI`**

**Statement.**

```text
Split pencil-type point: F = f(x,y) + x5 h_0 + x6 h_1 + x7 h_2, f = l_0 l_1 l_2 l_3 a binary quartic in (x,y) =
(x3,x4), the cubics h_j free of x, y. Let Pi = {x = y = x5 = x6 = x7 = 0} with coordinates v = (v_0,v_1,v_2),
hbar_j = h_j restricted to Pi, R_h = C[v]/(hbar_0, hbar_1, hbar_2) (Hilbert function 1, 3, 6, 7, 6, 3, 1) and
Res_h its socle functional. Then:
(a) product rule: Phi(A(x,y) B(v)) = Phi_f(A) Res_h(B);
(b) the kernel modulo T Sigma_4 is K_f (x) S^2 V^*, K_f = kernel of Phi_f on binary quadrics (dimension 2): 12 = 2
* 6.
    The normal directions of the stratum are tau in U (x) V^*, U = binary cubics modulo (f_x, f_y): 6 = 2 * 3;
(c) there is a polynomial w(t_1,t_2,n_1,n_2) = (1/2) sum s_ab^ij t_i t_j n_a n_b - eps(n)/6 with 13 coefficients,
weighted
    homogeneous of degree 6 for weights (1,1,2,2), depending only on (f, a) and not on the cubics h, with
        W_lead(tau, nu) = lambda * Res_h[ w(tau_1, tau_2, q_1, q_2) ],  tau_i linear forms, q_a quadrics on Pi;
(d) so a balanced-regime solution at a split point is a graded ring homomorphism C[t,n]/J_w -> R_h (t_i -> tau_i,
    n_a -> q_a) that does not kill n, J_w the ideal of the four partial derivatives of w;
(e) emptiness at ONE pencil-type point (split or not) implies emptiness at the general one (semicontinuity; W_lead
    is canonical because r = 0);
(f) special split points do have solutions: if some linear form l has l^4 in (hbar), then tau_i = alpha_i l,
    q_a = c_a l^2 is a solution for all (alpha, c). Such nets of cubics form a codimension-4 family. Conjecturally these
    are the points where the cone locus E1 leaves Sigma_4.
```

**Data.**

```text
Explicit instance (lines x3 - z_m x4 with z = (1, 2, 4, -1), a = (3, 1, 0, -3)):
w = -(12298/675) t1^2 n1^2 - (1411/75) t1 t2 n1^2 - (3278/675) t2^2 n1^2 + (9761/135) t1^2 n1 n2 + (2309/30) t1 t2
n1 n2
    + (2761/135) t2^2 n1 n2 - (387497/5400) t1^2 n2^2 - (31431/400) t1 t2 n2^2 - (116047/5400) t2^2 n2^2
    + (41/27) n1^3 - (155/18) n1^2 n2 + (2453/144) n1 n2^2 - (5005/432) n2^3.
Coordinates of this instance: phi(A) proportional to A(1,1)/2 - A(2,1)/6 + A(-1,1)/10 on binary quadrics;
kappa_1 = x^2 + x y, kappa_2 = y^2 - (13/2) x y (basis of K_f); classes of the complementary cubics lhat_m in the
basis (x^2 y, x y^2) modulo (f_x, f_y): m = 0: (-96/23, 219/23), m = 1: (-21/23, -6/23), m = 2: (51/23, -84/23),
m = 3: (66/23, -129/23); tau_i = sum_m (i-th coordinate of lhat_m) * (gamma_m restricted to Pi) for the displacement
l_m -> l_m + gamma_m.
Second instance, z = (0, 1, 3, -2), a = (3, 1, 0, -3) (used for the numerical search only):
w = -(36/275) t1^2 n1^2 - (694/3025) t1 t2 n1^2 - (304/3025) t2^2 n1^2 - (244/825) t1^2 n1 n2 - (4166/9075) t1 t2
n1 n2
    - (532/3025) t2^2 n1 n2 - (422/2475) t1^2 n2^2 - (25507/108900) t1 t2 n2^2 - (1457/18150) t2^2 n2^2
    + (10/121) n1^3 + (18/121) n1^2 n2 + (211/1452) n1 n2^2 + (455/6534) n2^3.
On rank-one directions tau = alpha (x) l: N(tau) = sigma(alpha) (x) (q, q' -> Res_h[l^2 q q']), so
det N = det(sigma(alpha))^6 * det(l^2 : R_2 -> R_4)^2, of bidegree (24, 24).
```

**Conditions.**

T1's derivation of w (unfolding of the binary quartic, elimination, re-centring on the exact Sigma_4 point) was
not read as a proof by anyone. Machine parts modulo p at one split point per prime.

**Evidence.**

Team T1, round 6 (split_universal.py): against the residue pipeline, Q_(tau tau) agrees with Res_h[2 w_2] in all
144 entries for six directions and three sums and the cubic agrees at five points, with one common ratio, at
(30089, seed 3) and (30097, seed 5).

**Independent check.**

C21 (blind, own residue code, own random split points at p = 30089 and 32003): the kernel is the stated
12-dimensional space; the cubic equals lambda * Res_h[eps] (112 identities, one ratio; eps reproduced exactly over
Q); the Schur-reduced second-order Hessian equals lambda * Res_h[S(tau) q q'] in all 144 entries with the SAME
lambda = -1 (in the checker's normalisation), for 8 choices of displacement per prime. Not covered: whether the
balanced system has solutions; non-split points; other slopes or weights; the derivation of w.

**Not established.**

Whether the balanced system has solutions at a general net of cubics. (e) and (f) are paper statements, not
machine-checked, except a numerical control for (f).

**Known before.** not found in the sources we read (machine-read, see tests/SOURCES.md); not checked further

**Reproduce.**

not reproducible from this repository: the comparison with residues is a session script. The algebraic properties
of w are in D-PENCIL-W-ALGEBRA.

**Session references (files not public).** LEDGER_DISCOVERY.md "[T1] 19:20Z", "[T1] 19:27Z", "[T1] 19:32Z", "[CHECK C21] 19:42Z", "[COORD] 19:33Z".

---

## D-PENCIL-W-ALGEBRA

**Algebraic properties of the polynomial w: no critical point with n != 0; (n1,n2)^4 in the Jacobian ideal**

kind: `result` | area: `fake_linear_cycles` | status: **`EXACT`**

**Statement.**

```text
For the explicit polynomials w of D-PENCIL-REDUCTION-TO-W, exactly over Q:
(1) the ideal J_w of the four partial derivatives of w contains all five monomials of degree 4 in n_1, n_2 and
none of
    the four of degree 3; so Crit(w) = {n = 0} (dimension 2). Hence there is no balanced solution of the form
    tau_i = alpha_i l, q_a = c_a l^2 valid for every net of cubics;
(2) with S_ab(t) = d^2 w/dn_a dn_b at n = 0: for z = (1,2,4,-1),
        det S(t) = (1/101250) (2 t1 - 7 t2)(28 t1 + 17 t2)(43 t1 + 22 t2)(73 t1 + 32 t2),
    and for z = (0,1,3,-2), det S(t) = (2/680625) (t1 + 2 t2)(4 t1 + 3 t2)(7 t1 + 4 t2)(22 t1 + 19 t2): four rational lines, the four
    triple directions (the classes of the lhat_m);
(3) 6 w(0, n) = -eps(n), and for z = (1,2,4,-1): eps = -(82/9) n1^3 + (155/3) n1^2 n2 - (2453/24) n1 n2^2 +
(5005/72) n2^3, a binary
    cubic with nonzero discriminant.
```

**Conditions.** none beyond the definition of w

**Evidence.**

Team T1 (split_wQ.sing, Singular over Q, instance z = (0,1,3,-2); MOD p for the other). Coordinator
(checks/c21/w_algebra.sing, over Q, instance z = (1,2,4,-1)): (1), (2), (3).

**Independent check.**

Coordinator's exact check for z = (1,2,4,-1); C21 reproduced the four coefficients of eps exactly by another
route. One void output line of T1's script ('critical points with n != 0: dim 4') came from a reserved-name bug
and means nothing (C-VOID-OUTPUTS-AND-CHECKER-BUGS).

**Not established.** Anything about solutions of the balanced system for a general net (that needs R_h, not only w).

**Known before.** n/a

**Reproduce.**

Run from the repository root (Macaulay2 1.22). The package is not needed; plain Macaulay2:

```
R = QQ[t1,t2,n1,n2];
w = -(12298/675)*t1^2*n1^2 - (1411/75)*t1*t2*n1^2 - (3278/675)*t2^2*n1^2 + (9761/135)*t1^2*n1*n2 + (2309/30)*t1*t2*n1*n2 + (2761/135)*t2^2*n1*n2 - (387497/5400)*t1^2*n2^2 - (31431/400)*t1*t2*n2^2 - (116047/5400)*t2^2*n2^2 + (41/27)*n1^3 - (155/18)*n1^2*n2 + (2453/144)*n1*n2^2 - (5005/432)*n2^3;
J = ideal jacobian matrix{{w}};
print(all(5, i -> (n1^i * n2^(4-i)) % J == 0), any(4, i -> (n1^i * n2^(3-i)) % J == 0));
Sm = sub(diff(matrix{{n1,n2}}, diff(transpose matrix{{n1,n2}}, w)), {n1 => 0, n2 => 0});
print(101250 * det Sm == (2*t1 - 7*t2)*(28*t1 + 17*t2)*(43*t1 + 22*t2)*(73*t1 + 32*t2));
```

Expected: (true, false) and true. The same two tests hold for the second instance z = (0,1,3,-2).

**Session references (files not public).** LEDGER_DISCOVERY.md "[T1] 19:20Z" (item 2), "[T1] 19:27Z" (item A), "[COORD] 19:33Z" (coordinator's exact check).

---

## D-FAKE-TYPE-FIRST-RANKS-OTHER-DEGREES

**First-order ranks for combinations of the linear spaces of one P^(k+1)-section in other degrees**

kind: `result` | area: `fake_linear_cycles` | status: **`MOD_P`**

**Statement.**

Let Sigma_d be the locus of hypersurfaces of degree d and dimension 2k having a P^(k+1)-section that splits into d
hyperplanes, and let a be a general combination of the d linear spaces. At a random point of Sigma_d the Hessian
rank of the period (= codimension of the tangent space of the Hodge locus of the class) is:
sextic fourfold: 57 = codim Sigma_6 (so Sigma_6 is a reduced component for general a);
cubic tenfold: 30 = codim Sigma_3 for a = (1,-1,0), (2,-1,0), (1,2,0);
cubic sixfold: 5 < 7 = codim Sigma_3; quartic fourfold: 10 < 14 = codim Sigma_4.
In the last two cases Sigma_d cannot be a reduced component of the Hodge locus of a general combination.
The discriminant in a is 15 walls^3 times a residual of degree 12 (sextic fourfold) and 3 walls^10 with no
residual (cubic tenfold). The quartic sixfold case is D-SIGMA4-COMPONENT.

**Conditions.** Random points modulo p = 30089 (seed 1) and p = 32009 (seed 2).

**Evidence.** Team T1, round 1 (step9_general.py, step10_disc_general.py).

**Independent check.** none

**Not established.**

Nothing beyond these first-order ranks: sextic fourfolds and cubic tenfolds were not studied further (see
O-SEXTIC-FOURFOLDS-CUBIC-TENFOLDS).

**Known before.**

not found in the sources we read (machine-read, see tests/SOURCES.md); not checked further (fake linear cycles
exist only for d = 3, 4, 6 according to Duque Franco-Villaflor Loyola arXiv:2112.14818, machine-read in the
session; that paper is not in tests/SOURCES.md).

**Reproduce.**

not reproducible from this repository: the residue pipeline of team T1 for hyperplane arrangements is not in the
package. Needed: the period functionals of the d linear spaces at a random point of Sigma_d (a first-order
computation; hodgeLocusTangentCodim could be adapted).

**Session references (files not public).** LEDGER_DISCOVERY.md "[T1] 04:19Z"; discovery/t1_fake_linear/step9_general.py.
