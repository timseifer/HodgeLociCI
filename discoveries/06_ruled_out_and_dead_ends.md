# Ruled out, and dead ends

- What was tried and failed, with the reason, so that nobody tries the same thing again.
- Kind 'negative': a statement that was tested and is false. Kind 'dead_end': a method that does not work or a computation that did not finish.
- Read the 'Do not repeat' paragraph of an entry before starting anything similar.

> **Status of everything on this page:** produced by AI agents, checked only by other AI agents, reviewed by no human. Sources of published results were read by machine (see `tests/SOURCES.md`). The notes cited as "unreviewed note 1, 2, 3" are AI-written and not public. Nothing here is, or bears on, a proof or disproof of the Hodge conjecture. This is a registry of what was found, ruled out or left open, not a list of established theorems.

Generated from `discoveries/registry.yaml` by `discoveries/check_registry.py --write-pages`. Do not edit this page by hand: edit the registry. Notation: [`NOTATION.md`](NOTATION.md). Status vocabulary: [`README.md`](README.md).

## Entries on this page (29)

| id | status | title |
|---|---|---|
| [N-JOIN-HYPOTHESIS](#n-join-hypothesis) | `RULED_OUT` | The lambda = -1 component at X1 is not a join locus built from the special coefficient of the sixfold sub-pair |
| [N-BRIDGE-PLANES](#n-bridge-planes) | `RULED_OUT` | 'Bridge planes' do not explain lambda = -1 at X1: the two c = 2 loci meet only inside V |
| [N-OTHER-SPECIAL-COEFFICIENTS-AT-X1](#n-other-special-coefficients-at-x1) | `RULED_OUT` | No special coefficient other than 1 and -1 at X1: the order-5 obstruction has no further zero |
| [N-EIGHTFOLD-DIM-MINUS-6-ALL-LAMBDA](#n-eightfold-dim-minus-6-all-lambda) | `RULED_OUT` | 'The eightfold second component has dimension exactly dim V - 6 for every lambda not in {0,1}' is false for lambda != -1 |
| [N-SUMS-OF-SAME-SHAPE-OTHER-LAMBDA](#n-sums-of-same-shape-other-lambda) | `RULED_OUT` | lambda = 2, -2: no family 'G_A + G_B' of the two-determinant shape, no cycle in a hyperplane, no classical threefold |
| [N-PROJECTED-SCROLLS](#n-projected-scrolls) | `RULED_OUT` | Projected scrolls over P^1 x P^1 are not the cycle at a general point of W_2, W_(-2) |
| [N-NODAL-AND-DEGENERATE-DETERMINANTS](#n-nodal-and-degenerate-determinants) | `RULED_OUT` | The divisor D is not produced by a nodal flag threefold, a determinant singular along a P^4, or the tangent case |
| [N-TWO-TRACE-DESCRIPTION-OF-D](#n-two-trace-description-of-d) | `RULED_OUT` | D is not the family x_H*Q + det(S + E) - det(S - E) with tr E = 0 and tr(ES) = 0 on H |
| [N-SYMMETRY-AVERAGING](#n-symmetry-averaging) | `RULED_OUT` | Symmetry averaging does not reduce an obstruction computation at X1 to the invariant subfamily |
| [N-RANDOM-SAMPLING-OF-PARAMETERS](#n-random-sampling-of-parameters) | `RULED_OUT` | Random sampling of a parameter misses special values: the candidate nu_t was live at t^4 = -4 |
| [N-NUMERICAL-RANDOM-START-SEARCH](#n-numerical-random-start-search) | `RULED_OUT` | Random-start numerical search for solutions of the balanced system has no evidential value |
| [N-SYMMETRIC-DEGENERATION-PENCIL](#n-symmetric-degeneration-pencil) | `RULED_OUT` | Degenerating to a symmetric point can never show emptiness of the balanced regime at pencil-type points |
| [N-LOW-DEGREE-CERTIFICATES-PENCIL](#n-low-degree-certificates-pencil) | `STUCK` | No inconsistency certificate for the balanced system up to weighted degree 8; all exact runs timed out |
| [N-TWODET-FIT](#n-twodet-fit) | `STUCK` | Numerical least-squares fitting of a cubic by det A + det B does not converge even on an exact sum |
| [N-CODIM-IJ4-AT-FERMAT](#n-codim-ij4-at-fermat) | `RULED_OUT` | 'codim (I_T + J)_4 = 1' fails at the Fermat cubic sixfold: the value there is 16 |
| [N-T3-ARC-BEYOND-ORDER-7](#n-t3-arc-beyond-order-7) | `RULED_OUT` | The exported arc six_lam-1_arc.txt is a truncation of a true arc only modulo eps^8 |
| [N-REDUCED-LOCUS-IS-SIGMA4-AT-FERMAT](#n-reduced-locus-is-sigma4-at-fermat) | `RULED_OUT` | 'The reduced Hodge locus of the fake class is Sigma_4 near the Fermat point' is false; so is the third-order criterion |
| [N-DPRIME-PROXY](#n-dprime-proxy) | `RULED_OUT` | The auxiliary class D' at the Fermat point is a poor proxy for the general point of the cone locus E1 |
| [N-V6-DEGENERATIONS-AND-REDUCIBLE-CYCLES](#n-v6-degenerations-and-reducible-cycles) | `RULED_OUT` | Coordinate degenerations of V_6 do not reach the two-plane locus; visible reducible cycles at D do not leave V_Z |
| [N-NIGHT-RUN-DEAD-ENDS](#n-night-run-dead-ends) | `RULED_OUT` | Dead ends recorded in the night run (cubic sixfolds, lambda != 1) |
| [N-GROEBNER-RUNS-NOT-FINISHED](#n-groebner-runs-not-finished) | `STUCK` | Computations that did not finish (with engine and time limit), so nobody reruns them unchanged |
| [N-T5-CYCLE-SEARCH-CUBIC-SIXFOLDS](#n-t5-cycle-search-cubic-sixfolds) | `RULED_OUT` | Search for algebraic cycles of the lambda = 2, -2 two-plane classes and the triangle classes on cubic sixfolds: none found (closed) |
| [N-DELSARTE-UNSOLVED-FAMILIES](#n-delsarte-unsolved-families) | `RULED_OUT` | Smooth Delsarte sextic fourfolds, quartic sixfolds and cubic tenfolds: every Hodge character closed by published criteria |
| [N-THOM-SEBASTIANI-SEXTIC-FOURFOLDS](#n-thom-sebastiani-sextic-fourfolds) | `RULED_OUT` | Sextic fourfolds f(x) + g(y): no explicit member with a Hodge class outside the known algebraic cases |
| [N-SPECIAL-REGIONS-TARGET-FAMILIES](#n-special-regions-target-families) | `RULED_OUT` | Excess for lambda outside {0, lambda_0} in quartic sixfolds, cubic tenfolds, sextic fourfolds: none at general points; all die on the jump divisor J; leads only on deeper strata |
| [N-TENFOLD-CODIM54-SEARCH](#n-tenfold-codim54-search) | `RULED_OUT` | Tenfold lead: search for a codim-54 family containing the C_18 family F_T (six named construction types, none explains it) |
| [N-TENFOLD-CODIM54-SEARCH-2](#n-tenfold-codim54-search-2) | `RULED_OUT` | Tenfold lead: second search for a codim-54 family containing F_T (Thom-Sebastiani cycles, more degenerations, scrolls, unions, del Pezzo-guided): none explains it |
| [N-TENFOLD-DIRECT-METHODS](#n-tenfold-direct-methods) | `RULED_OUT` | Tenfold lead: direct methods (periods to equations along the arc; search by invariants) find no explaining cycle |
| [N-TENFOLD-SINGULAR-SECTIONS](#n-tenfold-singular-sections) | `RULED_OUT` | Tenfold lead: loci where a P^8-section is singular along a plane do not explain the extra direction |

---

## N-JOIN-HYPOTHESIS

**The lambda = -1 component at X1 is not a join locus built from the special coefficient of the sixfold sub-pair**

kind: `negative` | area: `movasati_conjecture` | status: **`RULED_OUT`**

**Statement.**

Hypothesis tested: X1 is a "join" of a sixfold pair meeting in a line (c = 2, special coefficient -1) with two
points of {x8^3 + x9^3 = 0}; so the lambda = -1 phenomenon at X1 (D-X1-ORDER5-FORMULA) would come from a join locus
inside split eightfolds F_6(x0..x7) + G(x8, x9). Ruled out by hand: on such split eightfolds the class is
P1' (x) e_1 + lambda P2' (x) e_3 with e_1, e_3 independent in the reduced H^0 of the three points, so it stays
Hodge only where BOTH P1' and P2' do: the locus is V n (split family) for every lambda != 0. Nothing special at -1.

**Conditions.** A hand argument on split eightfolds (Thom-Sebastiani type decomposition of the cohomology).

**Evidence.** Team T3, 05:41Z.

**Independent check.** none

**Not established.** n/a

**Known before.** n/a

**Reproduce.** not reproducible from this repository: a hand argument.

**Do not repeat.**

Do not look for the lambda = -1 component at X1 inside split eightfolds F_6(x0..x7) + G(x8,x9), or explain it by
the pairwise rule of a sub-pair: the class there is Hodge only on V. What does fit is the family l*Q + det A + det
B (D-X1-COMPONENT-IS-TD-CLOSURE).

**Session references (files not public).** LEDGER_DISCOVERY.md "[T3] 05:41Z" (first item).

---

## N-BRIDGE-PLANES

**'Bridge planes' do not explain lambda = -1 at X1: the two c = 2 loci meet only inside V**

kind: `negative` | area: `movasati_conjecture` | status: **`RULED_OUT`**

**Statement.**

X1 carries 9 Fermat 4-planes P3 meeting P1 and P2 in planes, and [P1] - [P2] = ([P1] - [P3]) + ([P3] - [P2]) is a
sum of two special c = 2 classes, for lambda = -1 only. Tested: the two smooth loci N(P1,P3), N(P3,P2)
(codimension 16 each) meet in tangent dimension 93 or 94; their common tangent space is not ker u (the span has
dimension 99); and the 94-dimensional ones are obstructed at order 2. The intersection stays in V. Also: only one
primitive Hodge class of the Fermat eightfold stays Hodge to first order along T W' = ker u, the class itself; so
W' is not a locus where a second class (a plane, a scroll) survives.

**Conditions.** Prime 268435399.

**Evidence.** Team T3 (bridge.py, bridge2.py, gamma_w.py).

**Independent check.** none

**Not established.** n/a

**Known before.** n/a

**Reproduce.** not reproducible from this repository: session scripts.

**Do not repeat.**

Do not decompose [P1] - [P2] through a third Fermat plane meeting both in planes and intersect the two c = 2 loci:
tried for the 9 such planes at X1; the intersection is inside V.

**Session references (files not public).** LEDGER_DISCOVERY.md "[T3] 05:41Z" (second and third items).

---

## N-OTHER-SPECIAL-COEFFICIENTS-AT-X1

**No special coefficient other than 1 and -1 at X1: the order-5 obstruction has no further zero**

kind: `negative` | area: `movasati_conjecture` | status: **`RULED_OUT`**

**Statement.**

At the pair X1 the order-5 obstruction is a nonzero constant times (lambda - 1)(lambda + 1)^2/lambda^3
(D-X1-ORDER5-FORMULA). It has no zero other than 1 and -1, real or complex. Direct runs: obstructed at order 5 for
lambda = 2, 5/3, 3, 1/2, -2, -1/2, -3, 5, 7 and at the sixth roots of unity z, 1 - z, z^2, z^4; the 24-value scan
of check C9 includes two non-real values. At the three order-2 pair types only lambda = 1 is special.

**Conditions.**

The formula is exact at 16 rational or cyclotomic values for one fixed T_1 and a modulo-p fit elsewhere; the
rational function of degree <= 3 through the sample points is unique (8 unknowns against 40 equations).

**Evidence.** Team T3 (lam_scan.py, lam_fit.py, cert_x1.py); checks C9, C11.

**Independent check.** C9 (24 values, two primes), C11 (seven values exactly).

**Not established.**

That no other coefficient is special at other pair types of order 3 or 4 (only lambda = 2 and -1 were run at [4T
4F 2T], [4T 2T 2F 2F]; nothing at [6F 2T 2T], [4F 2T 2T 2F]).

**Known before.** n/a

**Reproduce.** See D-X1-ORDER5-FORMULA (certificate file for lambda = 2: M2/HodgeLociCI/data/x1_lam2_obstruction.txt).

**Do not repeat.**

Do not scan further values of lambda at X1 with the same T_1: the dependence on lambda is the closed formula. A
new scan is useful only at another pair type or with exact arithmetic for other T_1.

**Session references (files not public).** LEDGER_DISCOVERY.md "[T3] 06:01Z", "[CHECK C9]", "[CHECK C11]".

---

## N-EIGHTFOLD-DIM-MINUS-6-ALL-LAMBDA

**'The eightfold second component has dimension exactly dim V - 6 for every lambda not in {0,1}' is false for lambda != -1**

kind: `negative` | area: `movasati_conjecture` | status: **`RULED_OUT`**

**Statement.**

Team T3's round-1 conjecture: at the eightfold Movasati point the second component has tangent cone
(main component of the order-4 cone) x (excess line), hence dimension exactly dim V - 6, for every lambda not in
{0, 1}. Ruled out by T3 itself for lambda = 2, 5/3, 3, 1/2, -2, -1/2, -3: at X1 the 26 equations do not all vanish
on the germ W', so every component other than V has dimension <= dim V - 7 there, and by D-GLOBAL-ARGUMENT(A) also
at the Movasati point. The supporting arc tests at the Movasati point (arcs passing orders 5 and 6, linear part)
passed for lambda = 2 as well: they were not sensitive.
Also ruled out earlier, to the orders and primes stated: "the eightfold second component is as large as V" and
"there is no second component at the eightfold Movasati point".

**Conditions.** MOD p at X1 (exact for lambda = 2 through check C11); D-GLOBAL-ARGUMENT for the transfer.

**Evidence.** Team T3, 04:14Z (conjecture), 05:05Z (withdrawal), 04:25Z.

**Independent check.** C9, C11 for the X1 input.

**Not established.** The exact dimension of the second component for lambda != +-1 (only bounds).

**Known before.** n/a

**Reproduce.** Input at X1: see D-X1-ORDER5-FORMULA.

**Do not repeat.**

Do not use 'arcs tangent to the order-4 cone survive orders 5 and 6 (linear part)' at the Movasati point as
evidence for a component of dimension dim V - 6: the test passes for lambda = 2 too. The sensitive test is at X1
(first obstruction at order 3) or the rank invariant along arcs.

**Session references (files not public).** LEDGER_DISCOVERY.md "[T3] 04:14Z", "[T3] 04:25Z", "[T3] 05:05Z", "[T3] 05:13Z".

---

## N-SUMS-OF-SAME-SHAPE-OTHER-LAMBDA

**lambda = 2, -2: no family 'G_A + G_B' of the two-determinant shape, no cycle in a hyperplane, no classical threefold**

kind: `negative` | area: `explicit_cycles` | status: **`RULED_OUT`**

**Statement.**

```text
Tried and excluded for the coefficients 2, -2 (and 1/2) on cubic sixfolds, by hand counts unless said:
(a) sums F = G_A + G_B with G_A, G_B vanishing on codimension-2 subvarieties: the only codimension-2 arithmetically
    Cohen-Macaulay subvarieties carrying cubics are P^5's and determinantal cubic scrolls; the pairs give planes
    (codimension 4), cubic scrolls S(1,1,1) (6) and T (8, lambda = -1). Nothing for other lambda;
(b) sums with a hyperplane or quadric and a codimension-3 subvariety put the cycle in a hyperplane or in the
    lattice of such a cycle; cycles in a hyperplane have tangent codimension at most 7: lambda = 1 only;
(c) joins of the listed varieties of singular cubics (reducible 43, determinantal 56, Pfaffian 85 affine
    dimensions) give codimension 8 only for det + det;
(d) the numbers of the classes of discriminant -72, (degree, self-intersection) = (3,-21), (6,-12), (9,3),
(12,24), are
    realised by no del Pezzo threefold (s = 3d - 12 - chi), no rational normal scroll (s = d - 8), no P^1-bundle over
    P^2 embedded by a rank-2 bundle; the cheapest cycle with those numbers is reducible (V_5 u P2);
(e) non-linearly-normal sextic threefolds in P^7 are projections of rational normal scrolls (self-intersection -2,
    discriminant -42): not in the lattice. Line-scrolls of degree 6 over a surface with self-intersection 0 and 8
    sections: only P(T_P2);
(f) by computation (D-RANK-INVARIANT): for lambda = 2, 1/2, -2, 3, 5/3 the second component is NOT in the closure
of the
    sums of two determinants (rank 28 against 18).
```

**Conditions.** Hand counts and lattice numerics; (f) modulo primes along arcs.

**Evidence.**

Team T2 (04:56Z, 05:45Z, 15:43Z); team T3 (16:30Z). Night run: lattice scan of about 45 families of threefolds:
for lambda != 1 the only low-degree lattice match is V_6.

**Independent check.** none for (a)-(e); C18 for the exported arcs behind (f) (rank at least 27).

**Not established.**

Not attempted: surfaces on the general cubic fourfold of C_36, C_44 and threefolds having them as projected
sections; other joins.

**Known before.** n/a

**Reproduce.** not reproducible from this repository: hand arguments; (f) see D-RANK-INVARIANT.

**Do not repeat.**

Do not search again among: sums of two cubics vanishing on codimension-2 ACM subvarieties; hyperplane or quadric
plus a codimension-3 piece; joins of reducible / determinantal / Pfaffian cubics; del Pezzo threefolds, rational
normal scrolls, P^1-bundles over P^2; degree-6 non-linearly-normal threefolds. Any cycle for these lambda spans
P^7 and lies on no quadric beyond the partials.

**Session references (files not public).**

LEDGER_DISCOVERY.md "[T2] 04:56Z", "[T2] 05:45Z" (last item), "[T2] 15:43Z" (general lambda), "[COORD] 16:39Z";
LEDGER.md "Round 2 facts".

---

## N-PROJECTED-SCROLLS

**Projected scrolls over P^1 x P^1 are not the cycle at a general point of W_2, W_(-2)**

kind: `negative` | area: `explicit_cycles` | status: **`RULED_OUT`**

**Statement.**

Numerical pattern: for integer r >= 1 the classes (r+1)h^3 + P1 + r P2 (degree 4r+4, square 12r) and
(r+2)h^3 - P1 + r P2 (degree 4r+5, square 12r+3) have the degree and self-intersection of a scroll in lines over
P^1 x P^1 with c_1 = (3,3) and c_2 = 14 - 4r, resp. 13 - 4r (d = 18 - c_2, s = 3d - 12). r = 1: c_2 = 10 lies in a
P^6 (lambda = 1) and c_2 = 9 is the threefold T (lambda = -1). r = 2: c_2 = 6 (degree 12, lambda = 2) and c_2 = 5
(degree 13, lambda = -2) span P^10 and P^11, so they could only appear projected; a projected P(O(1,2)+O(2,1)) or
P(O(0,2)+O(3,1)) imposes at least 20 conditions on a cubic (h^0(Sym^3 E) = 116, 106 against at most 96, 88
deformation parameters). So they are not the cycle at a general point of W_2, W_(-2), which has codimension 8. The
pattern stops at r = 3.

**Conditions.** A count by hand.

**Evidence.** Team T2, 15:43Z, item (c).

**Independent check.** none

**Not established.** n/a

**Known before.** n/a

**Reproduce.** not reproducible from this repository: a hand count.

**Do not repeat.**

Do not test projections of the scrolls P(E) over P^1 x P^1 with c_1 = (3,3), c_2 = 6 or 5 as cycles for lambda =
2, -2: at least 20 conditions against 8.

**Session references (files not public).** LEDGER_DISCOVERY.md "[T2] 15:43Z" (item (c)).

---

## N-NODAL-AND-DEGENERATE-DETERMINANTS

**The divisor D is not produced by a nodal flag threefold, a determinant singular along a P^4, or the tangent case**

kind: `negative` | area: `explicit_cycles` | status: **`RULED_OUT`**

**Statement.**

```text
Tried as the degeneration of the pair (A, B) that produces the cubics of D inside the closure of {det A + det B}:
(a) the divisor of sums in which one flag threefold {rank A <= 1} is nodal: X smooth, tangent codimension of the
    Hodge locus of [T] still 8, while it is 7 at every point of a two-plane locus. Not D;
(b) one determinant degenerating to a cubic singular along a P^4: always gives 6 singular points (by hand);
(c) the tangent case (det(N + tN') - det N)/t: that is the V_6 divisor, not D.
What the degeneration is, as far as computed: D-DEGENERATION-ALONG-ARC (both determinants blow up towards a triple
hyperplane).
```

**Conditions.** (a) modulo 32003, one seed; (b) by hand.

**Evidence.** Team T2 (nodal_det.m2), 15:42Z.

**Independent check.** none

**Not established.** n/a

**Known before.** n/a

**Reproduce.** not reproducible from this repository: session script nodal_det.m2.

**Do not repeat.**

Do not look for D among sums of two determinants with a mildly singular (nodal) determinantal part or with one
determinant singular along a P^4: checked. The matrices do not converge along D.

**Session references (files not public).** LEDGER_DISCOVERY.md "[T2] 15:42Z"; discovery/t2_w_cycle/NOTE_W_minus1.md (section 6 (D)).

---

## N-TWO-TRACE-DESCRIPTION-OF-D

**D is not the family x_H*Q + det(S + E) - det(S - E) with tr E = 0 and tr(ES) = 0 on H**

kind: `negative` | area: `explicit_cycles` | status: **`RULED_OUT`**

**Statement.**

Candidate description of the divisor D suggested by the degeneration (isotropic scaling N = eps^-2 (l + eps^2 M)):
F = x_H*Q + det M_A - det M_B with equal trace and equal second coefficient on the hyperplane H. Tested modulo
32003: for a given E the solutions S form a 35-dimensional space, a random member is a smooth cubic, but the
family has codimension 11 (tangent space of dimension 109 including coordinate changes), not 9; its section X n H
has 18 singular points and the Hessian at the rational one has rank 6. It is not D. T2's earlier count "110" for
this family was wrong (the parametrisation is not finite). The true scaling along the arc is anisotropic (weights 1
and 3/2, D-DEGENERATION-ALONG-ARC).

**Conditions.** One prime, one seed (d_family.m2).

**Evidence.** Team T2, 18:38Z, item (b).

**Independent check.** none (C20 checked the splitting, not this family)

**Not established.** A correct description of D as a family (O-RECOVER-MATRICES-AND-LIMIT-OF-T).

**Known before.** n/a

**Reproduce.** not reproducible from this repository: session script d_family.m2.

**Do not repeat.**

Do not use the isotropic two-trace ansatz for D: codimension 11 and an 18-nodal hyperplane section. Start from the
anisotropic normal form (tridiagonal determinant) instead.

**Session references (files not public).** LEDGER_DISCOVERY.md "[T2] 18:11Z" (last line), "[T2] 18:38Z" (item (b)).

---

## N-SYMMETRY-AVERAGING

**Symmetry averaging does not reduce an obstruction computation at X1 to the invariant subfamily**

kind: `dead_end` | area: `methods` | status: **`RULED_OUT`**

**Statement.**

Claimed step: "by equivariance (the conditions at orders 4 and 5 are affine-linear) the obstruction found inside
the 56-dimensional family FF of cubics fixed by the diagonal symmetries on x5 and x7 holds for arcs in the full
space of cubics". This is wrong as stated: the symmetries x5 -> w x5, x7 -> w x7 (w a cube root of unity) fix F_0
and T_1 but not the planes; neither P1, P2 nor the period polynomial is mapped to a multiple of itself; ker L is not
stable (the projection of ker L to FF has dimension 55 against 37 for ker L n FF); averaged solutions are not
solutions (explicit arcs with orders 1-4 zero whose group average has c_2 != 0). The 9 diagonal symmetries that do
fix both planes do not fix T_1.

**Conditions.** none

**Evidence.** Check C11 (exact, explicit counterexamples). T3 withdrew the sentence (16:03Z).

**Independent check.** C11

**Not established.** Whether some correct symmetry argument exists.

**Known before.** n/a

**Reproduce.** not reproducible from this repository: the counterexample arcs are in the session folder checks/c11.

**Do not repeat.**

Before averaging over a symmetry group, check that the group fixes the CLASS (the planes or the period polynomial
up to a scalar), not only the hypersurface and the first-order term. At X1 the honest symmetries are (x6,x7) ->
w(x6,x7), (x8,x9) -> w(x8,x9) and the rotation x0->x2->x4->x0, x1->x3->x5->x1. Otherwise compute over all cubic
monomials, as C11 did.

**Session references (files not public).** LEDGER_DISCOVERY.md "[T3] 06:12Z", "[CHECK C11] 14:55Z", "[COORD] 14:58Z", "[T3] 16:03Z".

---

## N-RANDOM-SAMPLING-OF-PARAMETERS

**Random sampling of a parameter misses special values: the candidate nu_t was live at t^4 = -4**

kind: `dead_end` | area: `methods` | status: **`RULED_OUT`**

**Statement.**

T1's scans of third-order directions used random coefficients inside each support pattern. For the family nu_t
they reported "obstructed at order 4" (three primes). A blind check found that the order-4 coefficient is
proportional to t^2 (4 + t^4): at the four values t^4 = -4 the direction passes order 4. More generally the scans
missed all positive-codimension strata; an exact decomposition of one stratum then found ten families
(D-TEN-FAMILIES-KILLED).

**Conditions.** none

**Evidence.** Check C10; T1 06:11Z, 15:14Z.

**Independent check.** C10

**Not established.** n/a

**Known before.** n/a

**Reproduce.**

not reproducible from this repository: see D-CANDIDATE-NU-T-KILLED for the closed formulas that show the special
values.

**Do not repeat.**

Do not conclude 'the family is obstructed' from random parameter values. Keep the parameter symbolic (or compute
the obstruction as a polynomial in it) and decompose the stratum exactly. Strata still covered only by random
samples: those with g, D_1, D_1' nonzero (O-FERMAT-LOOPHOLES).

**Session references (files not public).** LEDGER_DISCOVERY.md "[CHECK C10] 06:07Z", "[T1] 06:11Z", "[T1] 15:14Z".

---

## N-NUMERICAL-RANDOM-START-SEARCH

**Random-start numerical search for solutions of the balanced system has no evidential value**

kind: `dead_end` | area: `methods` | status: **`RULED_OUT`**

**Statement.**

Complex Levenberg-Marquardt on (gradient, chart) from random starts, for the balanced system at split pencil-type
points with rational w and random complex nets of cubics: 0 of 400 starts reach a zero (final residuals 3e-7 to
1e-4). But the control with a PLANTED isolated solution also gives 0 of 240. The search cannot see isolated
solutions, so its silence means nothing. Same picture in the two-variable analogue (0 of 400).
A similar search for critical points of the quartic form Psi_S at surfaces near the Fermat surface (E1 question)
found none down to 30 to 270 times the accuracy at eps = 0.005, 0.01; T1 itself labels it "not a proof" (local
minimisation can stall on the nearly flat former critical set).

**Conditions.** Double precision; scipy-type local minimisation.

**Evidence.** Team T1 (split_numeric.py; step36_numeric_psi.py).

**Independent check.** none (the planted-solution control is T1's own)

**Not established.** n/a

**Known before.** n/a

**Reproduce.** not reproducible from this repository: session scripts.

**Do not repeat.**

Do not use random-start local minimisation to argue that an over-determined polynomial system (18 equations, 17
unknowns) has no solution. Always run a planted-solution control first. Use an exact engine (F4: msolve, Magma) or
a dimension argument.

**Session references (files not public).** LEDGER_DISCOVERY.md "[T1] 19:20Z" (item 4), "[T1] 15:30Z", "[COORD] 19:33Z".

---

## N-SYMMETRIC-DEGENERATION-PENCIL

**Degenerating to a symmetric point can never show emptiness of the balanced regime at pencil-type points**

kind: `dead_end` | area: `fake_linear_cycles` | status: **`RULED_OUT`**

**Statement.**

Idea: decide the balanced regime at a symmetric special point and look only at fixed points. Shown on paper (T1):
a complete-intersection net of plane cubics invariant under a non-scalar one-parameter torus contains a pure cube;
none is invariant under a unipotent one-parameter group; and every sextic functional fixed up to scalar by a
one-parameter torus has some l with l^4 in its annihilator. By D-PENCIL-REDUCTION-TO-W(f) every such point HAS
balanced solutions. So every torus-symmetric special point has solutions, and emptiness has to be proved at a
point without continuous symmetry. This is the precise form of "symmetric points carry extra loci".

**Conditions.**

Paper argument, not machine-checked; a numerical control for the existence of solutions when l^4 lies in the ideal
(37 of 40 starts converge).

**Evidence.** Team T1, 19:20Z (item 3), 19:27Z (item C.2).

**Independent check.** none

**Not established.** n/a

**Known before.** n/a

**Reproduce.** not reproducible from this repository: a paper argument.

**Do not repeat.**

Do not try to prove emptiness of the balanced system by specialising the net of cubics to a torus-symmetric one
(monomial nets, Fermat-type nets): solutions exist there for a structural reason. Emptiness at ONE non-symmetric
pencil-type point suffices.

**Session references (files not public).** LEDGER_DISCOVERY.md "[T1] 19:20Z", "[T1] 19:27Z".

---

## N-LOW-DEGREE-CERTIFICATES-PENCIL

**No inconsistency certificate for the balanced system up to weighted degree 8; all exact runs timed out**

kind: `dead_end` | area: `fake_linear_cycles` | status: **`STUCK`**

**Statement.**

For the ideal I of the partial derivatives of W_lead at a general pencil-type point (weights tau: 1, nu: 2; 18
equations): weighted-degree-bounded standard bases were computed to bound 6 (150 generators, 1 s) and bound 8 (830
generators, 330 s); bound 10 did not finish in 1500 s. No power v_a^k (k <= 4) of a normal coordinate lies in I up
to weighted degree 8. This is not evidence of a solution: the expected degree of regularity is about 19.
Runs that did not finish: full standard basis with a chart (1500 s, Singular std); the rank-one sub-case at a split
point (16 unknowns: std 420 s, slimgb 1000 s); the two-variable analogue (10 unknowns, 10 equations: 200 s, two
trials).

**Conditions.** Singular, p = 30089, one point.

**Evidence.** Team T1 (pencil_nil.sing, pencil_a.sing, split_tests.py, split_T2s.sing).

**Independent check.** none

**Not established.** Whether the system has solutions.

**Known before.** n/a

**Reproduce.** not reproducible from this repository: the system depends on session data (strata_pencil pickle files).

**Do not repeat.**

Do not rerun Singular std or slimgb on the 18-variable weighted system, its rank-one sub-case or the two-variable
analogue with time limits below about half an hour, and do not look for nilpotency certificates below weighted
degree 10: all tried. See O-PENCIL-REGIME for what would unstick it.

**Session references (files not public).** LEDGER_DISCOVERY.md "[T1] 16:47Z", "[T1] 18:10Z", "[T1] 19:20Z" (item 4), "[T1] 19:32Z".

---

## N-TWODET-FIT

**Numerical least-squares fitting of a cubic by det A + det B does not converge even on an exact sum**

kind: `dead_end` | area: `methods` | status: **`STUCK`**

**Statement.**

twodet_fit.py: least-squares fit of a given cubic by det A + det B (144 complex unknowns, 240 sample points),
meant to decide whether a random two-plane cubic with det C = 0 is a sum of two determinants. The positive control
(an exact random sum of two determinants) did not converge: best residual 0.077 against data norm 15.5 over 30
random starts. The method cannot separate "is a sum" from "is not". No conclusion was drawn from it; it was
replaced by the exact arguments of D-GENERAL-CUBIC-OF-D-IS-LIMIT.

**Conditions.** scipy Levenberg-Marquardt, double precision.

**Evidence.** Team T2, 15:42Z (first item).

**Independent check.** none

**Not established.** n/a

**Known before.** n/a

**Reproduce.** not reproducible from this repository: session script.

**Do not repeat.**

Do not fit det A + det B numerically from random starts to test membership in the two-determinant family. Use
invariants instead: 18 quadrics annihilating the class and their splitting into two nets
(M-CATALECTICANT-ALONG-ARCS, M-ENDOMORPHISM-SPLITTING-TEST), or the tangent-codimension test.

**Session references (files not public).** LEDGER_DISCOVERY.md "[T2] 15:42Z".

---

## N-CODIM-IJ4-AT-FERMAT

**'codim (I_T + J)_4 = 1' fails at the Fermat cubic sixfold: the value there is 16**

kind: `negative` | area: `explicit_cycles` | status: **`RULED_OUT`**

**Statement.**

At a general sum of two determinants codim (I_T + J)_4 = 1, so the period polynomial of [T] is the generator of the
annihilator of (I_T + J)_4 in R_4 and the Jacobian-ring method for the class applies. At the Fermat cubic sixfold,
written as a sum of two determinants with matrices in disjoint variables (two Fermat cubic surfaces), the
annihilator of (I_T + J)_4 in R_4 has dimension 16, not 1. The method does not isolate the class there. The checker
used instead: T is the join of two twisted cubics, so [T] = (1/9) of the sum of the 36 planes Join(E_i, E_j').
The same failure occurs at split-type cubics x0*Q + c through a cone limit (codim (I + J)_4 = 4).

**Conditions.** Exact over Q(w), w^2 + w + 1 = 0.

**Evidence.** Check C16 (fermat2.m2); T2 05:07Z for the cone limit.

**Independent check.** C16

**Not established.** n/a

**Known before.** n/a

**Reproduce.**

not reproducible from this repository as stated (the Fermat determinantal representation is not in the package).
The package reports the relevant number as the key "codimIJ" of hodgeLocusTangentCodim and the key "hypothesis"
says whether it is 1.

**Do not repeat.**

Do not use the annihilator / hodgeLocusTangentCodim method for the class of T at the Fermat cubic or at other
cubics where the two matrices use disjoint variables: check that codimIJ = 1 first.

**Session references (files not public).** LEDGER_DISCOVERY.md "[CHECK C16]" (exact Fermat part), "[COORD] 16:19Z" (side fact), "[T2] 05:07Z".

---

## N-T3-ARC-BEYOND-ORDER-7

**The exported arc six_lam-1_arc.txt is a truncation of a true arc only modulo eps^8**

kind: `negative` | area: `fermat_expansion` | status: **`RULED_OUT`**

**Statement.**

The file six_lam-1_arc.txt (sixfold arc inside W_(-1), nine monomials) satisfies the period equations to order 9,
but it agrees with the true arc of the 9-parameter family (extended to order 25 by T2) only modulo eps^8: the true
coefficient of x0 x8 x9 at eps^8 is not 0, and both eps^9 coefficients differ. Moreover T3's terms T_1..T_8 cannot
be continued to order 10 at all: K.c_10 != 0 and K.B(T_1, v) = 0 for all v in ker L. So statements "to order
eps^10" about this file (D-RANK-CONTRAST-EXACT-ARCS) are statements about a truncated arc, valid for a true arc
only for factors of valuation below 8.

**Conditions.** Modulo the two primes 268435399, 268435291.

**Evidence.** Team T2, 18:38Z; check C20 (0). T3 and C18 had warned about truncation.

**Independent check.** C20

**Not established.** That the extended arc continues beyond eps^25, or anything in characteristic 0.

**Known before.** n/a

**Reproduce.**

The file is M2/HodgeLociCI/data/six_lam-1_arc.txt; the package confirms it to order 9 (snippet in
D-RANK-CONTRAST-EXACT-ARCS). The comparison with the extended arc is not reproducible from this repository
(session file round5/arc_extended_mod_p.txt).

**Do not repeat.**

Do not use six_lam-1_arc.txt (or six_lam2_arc.txt) beyond order 7 as an arc of the Hodge locus, and do not try to
extend T3's terms T_1..T_8: start from the 9-parameter family normalised by t(y2 y4 y6) = eps and solve by Newton
iteration.

**Session references (files not public).** LEDGER_DISCOVERY.md "[T2] 18:11Z", "[T2] 18:38Z" (for T3 and C18), "[CHECK C20]" (0), "[COORD] 18:57Z".

---

## N-REDUCED-LOCUS-IS-SIGMA4-AT-FERMAT

**'The reduced Hodge locus of the fake class is Sigma_4 near the Fermat point' is false; so is the third-order criterion**

kind: `negative` | area: `fake_linear_cycles` | status: **`RULED_OUT`**

**Statement.**

```text
(1) Near the Fermat quartic sixfold the reduced Hodge locus of delta = 3[P1] + [P2] - 3[P4] is strictly larger than
Sigma_4: it contains the cone loci E1(j) (D-EXPLAINED-LOCI-E0-E1-E2). On the surface slice the Hodge locus is a
smooth hypersurface of dimension 34 while T Sigma_4 meets the slice in dimension 32.
(2) The simple criterion "the third-order cubic on T / T Sigma_4 has empty base locus, hence reduced locus = Sigma_4
near Fermat" fails: the normal Hessian has rank 14, not 19, to first order, and the critical locus of the
third-order cubic is strictly bigger than T Sigma_4.
(3) The locus "three P^3 through a common plane spanning a P^5" (codimension 48) does not pass through the Fermat
point (first-order limit condition fails).
```

**Conditions.** Paper (product formula) + MOD p (p = 30089).

**Evidence.** Team T1, 04:06Z, 04:19Z, 04:29Z.

**Independent check.** C2 (the slice numbers)

**Not established.** n/a

**Known before.** n/a

**Reproduce.** not reproducible from this repository: session scripts.

**Do not repeat.**

Do not try to prove 'reduced locus = Sigma_4' at the Fermat point, and do not rely on a third-order criterion
there: explained cone loci pass through Fermat. Work at general points of the strata of Sigma_4 instead
(D-CORANK6-STRATA).

**Session references (files not public).** LEDGER_DISCOVERY.md "[T1] 04:06Z" (last items), "[T1] 04:19Z", "[T1] 04:29Z".

---

## N-DPRIME-PROXY

**The auxiliary class D' at the Fermat point is a poor proxy for the general point of the cone locus E1**

kind: `dead_end` | area: `fake_linear_cycles` | status: **`RULED_OUT`**

**Statement.**

To study whether the 24 extra tangent directions along E1 integrate, T1 used at the Fermat point an auxiliary
class D' with the numerics of D_a but of "general type" (rank 48 at Fermat already). Result: random dense extra
directions are obstructed at order 4, but all 12 non-cube vectors of the echelon basis survive order 4, and so do
5 of 10 random combinations of 2 or 3 basis vectors. Partial explanation: D' is a combination of 7 linear P^3 and
the locus "all seven persist" is an explained locus through this special point, not in the cone list. So "tangent
cone = T(E1)" is not established at that point, and the point does not decide the general point of E1. One script
of this plan (step26_quartic.py) used a wrong space and its output is void.

**Conditions.** p = 30089.

**Evidence.** Team T1, 05:23Z.

**Independent check.** none

**Not established.** Whether the 24 extra directions integrate at a general point of E1 (O-E1-GENERAL-POINT-AND-E2).

**Known before.** n/a

**Reproduce.** not reproducible from this repository: session scripts.

**Do not repeat.**

Do not use the class D' (or any class of the Fermat surface that is a combination of Fermat lines) at the Fermat
point as a stand-in for a general point of E1: extra explained loci pass through it.

**Session references (files not public).** LEDGER_DISCOVERY.md "[T1] 04:47Z", "[T1] 04:56Z", "[T1] 05:23Z".

---

## N-V6-DEGENERATIONS-AND-REDUCIBLE-CYCLES

**Coordinate degenerations of V_6 do not reach the two-plane locus; visible reducible cycles at D do not leave V_Z**

kind: `negative` | area: `explicit_cycles` | status: **`RULED_OUT`**

**Statement.**

```text
(a) Flat limits of the flag threefold V_6 under coordinate weight vectors (254 vectors with weights 0/1: 25 types;
    728 vectors in {0,1,2}^6: 14 types): none gives a cubic of the general two-plane type (exactly 2 independent
    primitive classes and joint tangent codimension 8). Limits found include: 3-plane + quintic; two cubic scrolls;
    three quadrics; three 3-planes + a cubic threefold; six 3-planes (only on singular cubics).
(b) A triangle of planes cannot specialise, on smooth cubics, to the Fermat configuration (P1, P2', P2''), and
    Pa + Pb + Pc - h^3 is never +-(P1 - P2) for planes P1, P2 meeting in a point (intersection numbers).
(c) At an explicit point of D (C = diag(1,1,0)) and at the Fermat point of D, first order, modulo p: the reducible
    cycles P1 u Q2, P1 u Q2 u K (K a cubic threefold cone), P2 u Q1 u K, P1 u P2, P2 u Q1, Q1 u Q2, P1 u (P2 n Q2), and the
    degree-6 candidate T0 = P1 u P2' u P2'' u (X n P^4) (Hilbert function of V_6, class 2h^3 + P1 - P2) all have
    first-order deformation space equal to T V_Z: none moves into cubics without planes. Positive control at
    lambda = 1: codimension 7, as expected.
(d) The reducible sextic "quartic del Pezzo CI(2,2) in a P^5 glued along a plane to a quadric threefold in a P^4"
    has self-intersection 2, not 0: not a limit of V_6.
(e) The degree-9 candidate V_6 + cubic threefold section (class h^3 + [V_6]) imposes 9 conditions, not 8.
(f) The shortcut "the cone limit of V_6 is of split type, a cone over a cubic fourfold" is false as stated: for
    smooth cubics through it the tangent hyperplane section at the vertex is a * x6 * q + c with a != 0.
```

**Conditions.**

Exact over Q for the limits; modulo 32003 or 32749 for the first-order tests; Hom(I, S/I)_0 sees deformations of
the saturated ideal only.

**Evidence.** Team T2, rounds 1 to 3 (degen_scan*.m2, dpoint_firstorder.m2, fermat_screen.m2, fermat_span.m2, split_check.m2).

**Independent check.** none for these negatives (C1, C4 checked the positive statements about V_6)

**Not established.** Only coordinate weights in one coordinate system were scanned: not exhaustive.

**Known before.** n/a

**Reproduce.** not reproducible from this repository: session scripts.

**Do not repeat.**

Do not rescan coordinate-weight flat limits of V_6, and do not test unions of the planes, their residual quadrics
and cubic threefold cones at a point of D for first-order motion off V_Z: all stay in V_Z. No cycle for lambda !=
1 lies in a hyperplane (D-CYCLE-CONSTRAINTS-OTHER-LAMBDA).

**Session references (files not public).**

LEDGER_DISCOVERY.md "[T2] 04:05Z", "[T2] 04:16Z", "[T2] 04:20Z", "[T2] 04:21Z", "[T2] 04:48Z", "[T2] 04:56Z",
"[T2] 05:07Z".

---

## N-NIGHT-RUN-DEAD-ENDS

**Dead ends recorded in the night run (cubic sixfolds, lambda != 1)**

kind: `dead_end` | area: `methods` | status: **`RULED_OUT`**

**Statement.**

```text
Recorded as dead ends or cautions in the night-run ledger:
(a) a K3-type sub-Hodge structure on the codimension-6 union of the tangent spaces with V^(2,4) = <w>: the
compatible
    (3,3) space is only <P1, P2>; and over the two-plane locus the second-order maps of the variation of Hodge
    structure span all of R_6 and have only scalar symmetrizers: no hidden sub-Hodge structure or extra endomorphism
    at this level;
(b) for lambda != 1 the class is not carried, to first order, by a nodal hyperplane section near span(P1, P2): a
    general member near the two-plane locus has no hyperplane section with more than 7 nodes;
(c) the second-order obstruction is not computable from (F, P_delta modulo J) alone: it depends on the next part of
    the class. (This was resolved later by D-POINTWISE-FORMULA.)
(d) non-degenerate candidate threefolds tested all had Hodge-locus tangent codimension 8, not 7; a lattice scan of
    about 45 families found for lambda != 1 only V_6 as a low-degree match, and V_6 has 9 conditions and codimension 8;
(e) "dim R_7 = 8 and dim R_8 = 1" does not certify smoothness of a cubic sixfold (sparse examples with coefficients
    in {-1,0,1}); use the pairing rank or the Jacobian colength;
(f) low-order smoothness of truncations at the Fermat point is not conclusive for the dimension of the locus (the
    published table reports smoothness to order 4 and 3 for n = 10, 12, where the conjecture is known to fail).
The ledger also lists, without detail: "semiregularity cannot be repaired by twisting, direct sums, or products
with P^k"; details not determined from the sources.
```

**Conditions.** Modulo p computations of the night run.

**Evidence.** LEDGER.md sections 'Round 3', 'Dead ends / cautions', and the note by agent D on smoothness.

**Independent check.** none

**Not established.** n/a

**Known before.**

```text
(f): Movasati arXiv:2211.11405, Theorem 8 and Sections 2, 9 (orders 4, 3 for n = 10, 12; conjecture false for n >=
10 by Kloosterman), as machine-read.
```

**Reproduce.** not reproducible from this repository: night-run scripts (tools/k3test.py, tools/nodes.py, tools/chern.py).

**Do not repeat.**

Do not look for cycles for lambda != 1 inside a hyperplane (scrolls, del Pezzo threefolds, nodal sections). Do not
certify smoothness by Hilbert function values of the Jacobian ring alone. Do not read finite-order smoothness on a
transversal slice at Fermat as evidence for the dimension of the locus.

**Session references (files not public).** LEDGER.md "Round 3 (night session)", "Dead ends / cautions", "AUDIT RESULT AND CLOSED FORMULA" ([NOTE, agent D]).

---

## N-GROEBNER-RUNS-NOT-FINISHED

**Computations that did not finish (with engine and time limit), so nobody reruns them unchanged**

kind: `dead_end` | area: `methods` | status: **`STUCK`**

**Statement.**

```text
(a) Critical locus of the third-order cubic in 26 variables (fake class at Fermat): Singular std, 4 minutes; on a
    chart, 240 s; a random codimension-8 linear section, 200 s. Only the degree-6 truncation finished (bound 12).
(b) Balanced system at pencil-type points: see N-LOW-DEGREE-CERTIFICATES-PENCIL.
(c) Critical locus of the reduced cubic (26 quadrics) at a general point of the Fermat-type pencil stratum: out of
    reach for Singular.
(d) Exact version of the E1 statement: 12 cubics in 12 variables over F_p((s)): no Groebner basis in reach.
(e) Second order for (3,4,2) with the full K AND the formula test: 600 s (done later without the formula test).
(f) tangentExcess with Strategy "Jacobian" for (d,k,c) = (3,5,3): 15 minutes (the package tests use "Residue").
(g) Projection + cone limit of V_6 over Q (radical of a non-reduced ideal): 200 s; done modulo p and, for one
    centre, exactly without the radical.
(h) Tangent codimension at a triangle point in a weighted ring: 500 s; the cause was the monomial order (finished
    in a plain ring).
(i) Decomposition of the stratum D_0 = 0 with g-part (affine dimension 7): timed out.
(j) Homogeneous Groebner basis of condition (A) in nine variables (check C19): 900 s; replaced by six charts.
```

**Conditions.** Machine: 2 cores, 7 GB, shared; Singular and Macaulay2 1.22.

**Evidence.** [STUCK] entries of the discovery ledger; tests/README.md for (f).

**Independent check.** n/a

**Not established.** n/a

**Known before.** n/a

**Reproduce.** not reproducible from this repository: session inputs.

**Do not repeat.**

Do not rerun these with the same engine and a similar time limit. What helped elsewhere: primes below 32768 with
F4 (M-F4-SMALL-PRIMES), charts instead of homogeneous bases, dropping radicals, plain monomial orders,
degree-bounded bases, restricting to random linear subspaces.

**Session references (files not public).**

LEDGER_DISCOVERY.md entries marked [STUCK]: "[T1] 04:19Z", "[T1] 04:24Z", "[T1] 16:26Z" (C), "[T1] 16:47Z", "[T2]
04:16Z", "[T2] 04:48Z", "[T3] 04:06Z"; tests/README.md ("Not covered").

---

## N-T5-CYCLE-SEARCH-CUBIC-SIXFOLDS

**Search for algebraic cycles of the lambda = 2, -2 two-plane classes and the triangle classes on cubic sixfolds: none found (closed)**

kind: `negative` | area: `movasati_conjecture` | status: **`RULED_OUT`**

**Statement.**

Target (A): a threefold whose class is h^3-combination plus Pa + 2Pb or Pa - 2Pb on the general member of the
two-plane Hodge loci; target (B): the triangle classes x Pa + y Pb + z Pc. Lattice discriminants of
<h^3, x Pa + y Pb + z Pc> are -16 sum x^2 + 4 sum xy [EXACT]: lambda = 2: -72; lambda = -2: -88; triangle
(1,1,-1): -52, (1,1,2): -76, (1,2,2): -112. Constructions tested and excluded: the genus-7 Fano-Enriques threefold
(P^1 x S_4)/iota of degree 12 (tangent codimension 6, s = 40, discriminant -24) [MOD p]; the sigma_3 family of a
4x4 linear matrix (degree-20 threefold {rank <= 2}: codimension 7, lambda = 1 type) [MOD p]; divisors of P^1 x P^3
and 2x5 maximal-minor threefolds with one quadric column (discriminants -24, -34, -28, -54, -16, -22); 3x6 maximal
minors (det + det again, by the normal form e123 + e456); 2x5 matrices with rows of degrees (1,2) (force a 3-plane
into X); projected rational normal scrolls (discriminant -d^2 + 3d - 24, never -72 or -88); projected index-1 Fano
threefolds (-28, -42, -58, -82, -108). Triangle: the projected degree-7 scroll has the numbers (7, -1) of
2h^3 + Pa + Pb - Pc but chi(N) = -12, so at best a sublocus [RULED OUT as the general cycle; its class STUCK];
the degree-11 scroll matching (1,2,2) lies on no cubic.

**Conditions.**

Mod p (Macaulay2 1.22) except the lattice discriminants (exact) and the hand arguments. The test chi(N) >= -8 is a
heuristic [CONJECTURE], not a theorem.

**Evidence.**

Team T5, session folder discovery/t5_cycles/ (not in this repository) (selfint.m2, chern3.py, annlib.m2, sigma3*.m2, fe12*.m2,
divP1P3.py, scroll.py, enum*.py). Controls: selfint gives det+det 15, V_6 0, plane -5; annlib gives 1,7,12,7,1
and 1,8,18,8,1.

**Independent check.** none (no candidate was found, so no claim was checked)

**Not established.**

That no cycle exists. About 100 numerical scroll matches over surfaces are unverified (no bundle constructed);
first-order deformations of degenerate cycles at the triangle cubic did not finish. Search stopped by the user's
direction ("solved territory: clean record, not more budget").

**Known before.** n/a

**Reproduce.** not reproducible from this repository: session scripts (selfint.m2 is a prototype, not packaged).

**Do not repeat.**

Fano-Enriques genus-7 model as the lambda = 2 cycle; cone-pairing numerics (s = d^2 - 2S^2) for singular T (holds
only for cones); sigma_3 of a 4x4 matrix; divisors of P^1 x P^3 and 2x5 mixed-degree minors; 3x6 minors;
numerical scroll scans without constructing the bundle; Macaulay2 Hom(I_Z, S/I_Z)_0 for reducible cycles at a
triangle cubic (did not finish in 15 min); `ker` of a degree-tripling map from a standard-graded ring in M2 1.22
(compute degree by degree).

**Next step.** None planned (closed by the user's direction). Prepared but not run: rns7.m2, c36cone.m2 (criteria in the ledger).

**Session references (files not public).** LEDGER_DISCOVERY.md "[T5] ... CLOSE" (04:56Z 23 Nov) and the erratum at 04:46Z.

---

## N-DELSARTE-UNSOLVED-FAMILIES

**Smooth Delsarte sextic fourfolds, quartic sixfolds and cubic tenfolds: every Hodge character closed by published criteria**

kind: `negative` | area: `explicit_cycles` | status: **`RULED_OUT`**

**Statement.**

Smooth Delsarte (invertible, n+2 monomials) members are exactly sums of chain and loop blocks; each type is one
variety up to torus scaling. Hodge characters were enumerated exactly (Jacobian-ring monomials graded by
G_W-characters; Fermat-cover part agrees with Shioda/Heijne arXiv:1212.5006) and closed by: Shioda decomposable /
quasi-decomposable, Ran, da Silva, reduction to own level, lift and descent, Aoki 1987 Thm 1-4(ii) pair
augmentation, Aoki 2000 Thm 0.1 (level rule) and Lemma 4.1(iii) (lattice S_m, exact HNF). Results: (6,4) 29 types,
(4,6) 75 types, (3,10) 413 types; no character left open. The level-33 classes of L5/L10 types reduce to da Silva's
m = 33 fourfold class through the level-66 descent (re-derived from published ingredients); the L12 cubic tenfold
(N = 4095) orbit reduces to level 105 and lies in Aoki's S_105.

**Conditions.**

Exact integer arithmetic; smoothness by an elementary argument plus Singular (vdim (d-1)^k per block). Aoki's
statements were read only as quoted in Jumagulov's tex (secondary, machine-read). The "extra part" (characters
with zero entries, present for chain blocks and even loops) was tested through its nonzero-support character,
assuming carry-over from the lower-dimensional piece by cone/Gysin correspondences: NOT proved.

**Evidence.** Team T6 step (b) B1, session folder discovery/t6_unsolved/b1/ (not in this repository) (TABLE.md, res2_*.jsonl, res3_3_10_ext.jsonl).

**Independent check.** none

**Not established.** The extra-part carry-over; a first-hand reading of Aoki 1987/2000.

**Known before.** Fermat members: Shioda, Ran, Aoki. Delsarte members in these dimensions: not found in a short search.

**Reproduce.** not reproducible from this repository: session scripts (candidate for packaging, user tooling item 3).

**Do not repeat.**

Do not search smooth Delsarte members of (6,4), (4,6), (3,10) for unexplained Hodge classes. Do not use "covering
degree not covered by a published theorem" as a proxy for "open": per-character checks closed everything. Do not
assume H^n_prim of a Delsarte member is the invariant Fermat characters (chain blocks and even loops add an extra
part).

**Session references (files not public).** LEDGER_DISCOVERY.md "[T6b]" entries 05:05Z-06:05Z and "[COORD] 06:20Z".

---

## N-THOM-SEBASTIANI-SEXTIC-FOURFOLDS

**Sextic fourfolds f(x) + g(y): no explicit member with a Hodge class outside the known algebraic cases**

kind: `negative` | area: `explicit_cycles` | status: **`RULED_OUT`**

**Statement.**

H^4_prim(X) = sum_j V_j(f) x V_{6-j}(g) + H^1(C_f) x H^1(C_g)(-1) (2205 + 400 = 2605), with V_j the zeta^j-parts
of H^2_prim of S_f = {f + z^6 = 0}; V3 is H^2_prim of the K3 double plane u^2 = -f. Algebraic classes correspond in
both directions through the degree-6 map S_f x S_g --> X (standard argument, not machine-read). Curve part always
algebraic. Searched for explicit smooth f, g with a Hodge morphism of an open kind (similarity that is not an
isometry, general RM, CM pairs without isometries): Elsenhans-Jahnel RM examples are six-line (singular branch);
van Geemen-Schuett Q(sqrt5) family has RM from graph cycles (algebraic); Klein sextic (PSL(2,7)): only pure piece
is CM by Q(sqrt-3, sqrt-7) with endomorphisms from the group algebra; F21 pencil, Heisenberg-invariant family and
61 diagonal-cyclic monomial families (17 generically smooth): no symmetry-forced piece with a (2,0) part beyond
Delsarte/CM-elliptic cases.

**Conditions.**

Exact arithmetic (Q(zeta_7), Singular) for smoothness and decompositions. The purity test is only sufficient: CM
points inside non-pure families were not examined (needs periods or point counts). Shioda-Katsura full text not
opened; Morrison's rho = 17, 18 criterion not read.

**Evidence.** Team T6 option B2, session folder discovery/t6_unsolved/b2/ (B2_NOTES.md and scripts; not in this repository).

**Independent check.** none

**Not established.**

That no explicit f, g exists: open kinds of Hodge morphisms (Varesco arXiv:2304.02519, intro) need rigidity to
certify with explicit equations, and the explicit rigid examples found are all covered by known theorems.

**Known before.** The open cases themselves are stated in Varesco arXiv:2304.02519 and van Geemen-Schuett arXiv:2310.05196 Rem. 4.9.

**Reproduce.** not reproducible from this repository: session scripts.

**Do not repeat.**

Elsenhans-Jahnel RM double planes (six-line, excluded); vGS Q(sqrt5) D5-cover family; Klein sextic Phi6(x) +
Phi6(y); F21 pencil; Heisenberg-invariant family; diagonal-cyclic monomial families (61 sets). Do not certify
Hodge morphisms between pieces of explicit non-rigid families by exact arithmetic alone.

**Session references (files not public).** LEDGER_DISCOVERY.md "[T6b2]" entries 06:14Z-06:18Z and 09:53Z-10:14Z.

---

## N-SPECIAL-REGIONS-TARGET-FAMILIES

**Excess for lambda outside {0, lambda_0} in quartic sixfolds, cubic tenfolds, sextic fourfolds: none at general points; all die on the jump divisor J; leads only on deeper strata**

kind: `negative` | area: `second_order` | status: **`RULED_OUT`**

**Statement.**

All 980 degree types with tau >= 0 in (d, k) = (4, 3), (3, 5), (6, 2) are outside the range; in all three
sigma' = kd - 2k - 2 = d, so det M : A_tau -> A_d is square and its determinant cuts a divisor J of V_Z where the
excess E' jumps to 1. MOD p: at a random point of V_Z, E' = 0 in 980/980 types; at smooth points of J (169 types),
E' = 1, (S) false, verdict ALL DIE. Second-order survival criterion (ARG): N survives iff N^2 adj(M)_ji in
I = (f,h,p,s) for all entries of degree >= 0 and N^2 det M in I^2. Leads (deeper strata, NOT dead ends):
Z_431 on (4;1;1;1,1,1) (a 5-plane through span(Y1,Y2) tangent to X along a line: one direction survives, MOD p);
Z_0 = {M = 0 mod (f,h,p)} for c >= 2 (all K-quadrics vanish: NOT DETERMINED), smooth for Kloosterman's quartic pair
(4;1,1;1,1;1,1), Movasati's tenfold pair (3;1,1,1;1,1,1;1,1,1) and (6;1,1;2,2;1). On the tenfold Z_0, X n P^8 is a
cone over a cubic fourfold with two disjoint planes, and cone loci Cone_d (Hassett C_d, d = 8r^2 - 2rs + 8s^2)
give an explained component through Z_0 (ARG); whether the component W there is strictly larger than Cone_d is
open (38 <= codim W <= 65 from tangent bounds, which are only lower bounds at cone points).

**Conditions.**

One random instance per type modulo 32003; the arguments marked ARG were written by one AI agent and not checked.
Not covered: 63 quartic and 22 tenfold types with no F_p-rational root on the random line; about 480 sextic types
for J.

**Evidence.**

Team T6 step (c), session folder discovery/t6_unsolved/c/ (NOTES.md; jump.m2, zq.m2, ansatz.m2, pencil.m2; not
in this repository).

**Independent check.** none

**Not established.** The leads on Z_431 and Z_0 (third order or a point of W off the cone locus needed); the uncovered types above.

**Known before.** Movasati arXiv:1902.00831 conjectures a component for the tenfold pair (machine-read).

**Reproduce.**

not reproducible from this repository: session scripts (candidates for packaging: jumpPoints, the survival
criterion, pencil ranks at cone points).

**Do not repeat.**

General points of V_Z in these families (no excess); general smooth points of J (all die); parametrising Z by a
general N (returns EMPTY, not evidence); the twisted-cubic cone limit Y1 + 2Y2 (forces X singular); tau = d types
(J among singular hypersurfaces); treating hodgeLocusTangentCodim or pencil ranks at cone points as the codimension
of W (lower bounds only; sixfold control 7 vs 8).

**Next step.**

Decide the tenfold Z_0 lead: Fermat arcs at Movasati's cubic tenfold point (lambda = -1, 2) with the Residue
strategy, or a point of W off the cone locus.

**Session references (files not public).** LEDGER_DISCOVERY.md "[T6c]" 10:16Z-11:57Z.

---

## N-TENFOLD-CODIM54-SEARCH

**Tenfold lead: search for a codim-54 family containing the C_18 family F_T (six named construction types, none explains it)**

kind: `negative` | area: `movasati_conjecture` | status: **`RULED_OUT`**

**Statement.**

```text
Pre-registered search (24 Nov 2026) for a family of smooth cubic tenfolds of codimension 54 containing F_T (cubic
tenfolds containing V = J(P^2, T), T an elliptic ruled sextic; codim 55) as a divisor, carrying a 5-cycle with a
nonzero [V]-component, which would explain the extra Hodge-tangent direction of O-TENFOLD-CONE-LEAD. Ruled out
among the named types, at the tested members and to first order MOD p (32003, 31991), with the ARG steps stated:
(F) two-class / lattice reading: at random X in F_T the first-order Hodge lattice along F_T is <h^5, [V]> (m = 1,
4/4 runs), so a codim-54 branch would be a Hodge locus of the single class [V] mod h^5 and needs a new cycle;
(A) joins J(P^2, S) with other C_18-type surfaces: integrality leaves only the sextic del Pezzo class 4h^2 - T; its
cone family lies inside F_T (CORRECTION by the second search: every such X also contains a V-type cone; the
first-order 'codim 55' was a tangent artefact); (D) linkage residuals of V: R22 (class 4h^5 - [V]) and R23 (6h^5 - [V]) give codim 55
(their deformations stay in F_T); R33 (9h^5 - [V]) and R222 (8h^5 - [V]) also codim 55 (streamed solver, 4/4 each);
(E) degenerations of T
(plane u quintic scroll, three planes u cubic scroll): codim 55; (B) cones with smaller vertex: line vertex codim
>= 64 (count); point vertex excluded because a random X in F_T has no Eckardt-type point; (C) small-degree
5-folds: J(line, v_3(P^2)) codim 34 (count), 3 x 4 rank <= 2 determinantal 5-fold codim 32; Pfaffian, Segre,
P^3-bundle and scroll cases excluded by integrality or done before.
```

**Conditions.**

Only the named types and the tested members; first order; MOD p at two primes; random points. This is NOT a proof
that no codim-54 family exists. Not covered: non-reduced or singular irreducible degenerations of T;
P^3-bundles over T other than V; projected degree-9 scrolls; unions beyond U9/U12.

**Evidence.**

Session agent CS-T6, files checks/cs_t6/ (session folder, not in this repository); pre-registration and verdicts
in the session ledger.

**Independent check.**

None (no type was explained, so no blind check was triggered by the pre-registration). RECHECK by the second
search with a sharper test (h0(N_{Z/X}) equal to the dimension of the explicit family, so the incidence is smooth
and nothing leaves F_T at any order): R22, R23, R33, R222 and the degenerations of T pass (verdicts stand and hold
beyond first order).

**Not established.**

Side observation: at sextic del Pezzo cone points J(Pi, S') the Hodge-tangent codim of [V'] is 50 against family
codim 55; a rank-4 quadric cone of those directions survives order 2 (DP-T6, see O-TENFOLD-CONE-LEAD).

**Known before.**

Construction types already excluded before this search: EXP-T6 and W1 lists in O-TENFOLD-CONE-LEAD; Kloosterman
arXiv:2312.12363 Thm 5.3 (cones = Cone_d); rStation #5 Sec. 11 (split family and cones over eightfolds, slice
dimension <= 155).

**Reproduce.** not reproducible from this repository: session scripts checks/cs_t6/ (cslib.m2, f1, a1, d1, d2, e1, b2, c1).

**Do not repeat.** The types above at first order; the del Pezzo class is the only other C_18 surface class allowed by integrality.

**Next step.** The del Pezzo observation (codim 50) as a separate pre-registered test (running); the types listed as not covered.

**Session references (files not public).** LEDGER_DISCOVERY.md "[CS-T6]" 17:40Z PRE (written ~17:10Z) to 23:31Z CLOSE (24 Nov).

---

## N-TENFOLD-CODIM54-SEARCH-2

**Tenfold lead: second search for a codim-54 family containing F_T (Thom-Sebastiani cycles, more degenerations, scrolls, unions, del Pezzo-guided): none explains it**

kind: `negative` | area: `movasati_conjecture` | status: **`RULED_OUT`**

**Statement.**

```text
Second pre-registered search (25 Nov 2026), same target and definitions as N-TENFOLD-CODIM54-SEARCH. Ruled out
among the named types, at the tested members, MOD p (32003, 31991), with the ARG steps stated:
(G) Thom-Sebastiani / Katsura-Shioda cycles (rStation #11): at the split points every class with a [P1]-[P2]
component is a combination of cone classes and h^5 (lambda = -1 is the C_18 class of the cubic fourfold factor);
non-planar product joins codim >= 64; off-split linkage residuals L1, L2, L3 codim 55 (L3 a lower bound);
(I) cones over elliptic sextics and P^3-bundles J(l, W') lie only on singular cubics; rational scroll with a
double line codim 55 (rigid); double structures on cubic scrolls codim >= 60; degree 9 and 12 scrolls codim >= 79;
unions of V with linear sections along a ruling P^4, along J(l, T), along two rulings: codim 55;
(H) del Pezzo-guided: every X containing a cone over a sextic del Pezzo residual also contains a V-type cone, so
that family lies inside F_T, and at its points the reference tangent space equals T F_T: the del Pezzo excess
of the dP6 order-2 test is the excess of NL([V]) over F_T jumping from 1 to 5 at special points of F_T (that its
vertex direction is the limit of the generic extra direction is ARG only, untested).
New check used (ARG): when the cycle Z moves inside X, compare h0(N_{Z/X}) with the dimension of the explicit
family; equality gives a smooth incidence and excludes deformations leaving F_T at all orders (L1, I1b, I4a, I4e;
first order only for L2, L3, I4b).
```

**Conditions.**

Only the named types and tested members; MOD p; random points. NOT a proof that no codim-54 family exists.
Not covered: other degrees or line bundles for the Thom-Sebastiani correspondences; other singular degenerations
of T; other P^3-bundles; unions through other 4-folds of V.

**Evidence.**

Session agent CS2-T6, files checks/cs2_t6/ (session folder, not in this repository); pre-registration,
amendment (type H) and verdicts in the session ledger.

**Independent check.** None (nothing explained).

**Not established.**

OPEN: cubic tenfolds containing a cone over a projected Segre P^2 x P^2 form a family of codim exactly 55 (smooth
incidence), not F_T, with Hodge-tangent codim 50 (a 5-dim first-order excess); order 2 there not tested.

**Known before.**

rStation paper #11 (u/lelong_ridge, 17 Oct 2026, https://rstation.ai/problems/hodge_conjecture/papers/11/v1;
agent-written, machine-read): Prop. 2.1, Remark 5.2, Cor. 2(a), used for the class list at split points.

**Reproduce.** not reproducible from this repository: session scripts checks/cs2_t6/.

**Do not repeat.** Treating a family codim from the tangent space alone as final when the cycle moves inside X (check h0(N_{Z/X})).

**Next step.** Direct methods (periods to equations along the arcs; search by invariants), pre-registered as CS3-T6.

**Session references (files not public).** LEDGER_DISCOVERY.md "[CS2-T6]" (25 Nov, 03:43Z to CLOSE ~06:12Z).

---

## N-TENFOLD-DIRECT-METHODS

**Tenfold lead: direct methods (periods to equations along the arc; search by invariants) find no explaining cycle**

kind: `negative` | area: `movasati_conjecture` | status: **`RULED_OUT`**

**Statement.**

Pre-registered (25 Nov 2026). (M1, periods to equations, Movasati's Artinian Gorenstein ideal) Along the formal arc
of the extra direction at a random point of F_T, the degree <= 3 part of the AG ideal of the class, computed order
by order to order 3 at two primes, stays equal to that of [V] (I_V + J plus the Hodge-tangent cubics): no new cycle
is visible in degree <= 3 (DEGENERATES). Weak test: a direction moving V gives the same table. The three linear
forms of I_V lift to order 3, so the class stays in a moving P^8 to that order (ARG). Controls: the AG ideal of a
Fermat linear 5-plane reproduces Movasati's complete intersection; the pipeline matches the package's Fermat periods
on a sixfold. (M2, search by invariants) An explaining 5-fold has class a h^5 + b[V], b != 0, degree 3a + 6b and
square d^2/3 - 48 b^2, spans P^7..P^11, and every hyperplane through its span is tangent to X (ARG, LIT Lefschetz
for singular hypersurfaces); Pfaffians and complete intersections are excluded. Seven constructions in the
admissible cells (degrees 3 to 21, two cells not reached before) give family codim 55 (or 32), none 54; for three
of them the incidence is smooth (all orders).

**Conditions.**

M1: degree <= 3, orders <= 3, one point, two primes. M2: only the tested constructions; MOD p; undecided for
memory: generic double structures on V, double structures in P^8, the degree-24 residual R25 (need ~8 GB or a
sparse solver). Not a proof that no codim-54 family exists.

**Evidence.** Session agents CS3-M1, CS3-M2; files checks/cs3_m1/, checks/cs3_m2/ (session folder, not in this repository).

**Independent check.** None (nothing explained).

**Not established.**

Higher degree / higher order AG ideals (order 4 needs a pole-10 functional); the three undecided M2 cases;
saturation of the lattice <h^5, [V]> (a, b assumed integral).

**Known before.**

The Artinian Gorenstein / periods-to-equations approach: Movasati (e.g. arXiv:1902.00831 and his computations of
linear cycles near the Fermat point; machine-read); Lefschetz for singular hypersurfaces: Kato, Dimca (machine-read).

**Reproduce.** not reproducible from this repository: session scripts checks/cs3_m1/, checks/cs3_m2/.

**Do not repeat.** The tested constructions; the degree <= 3 AG ideal to order 3 along G_e.

**Next step.** Lead paused (owner's stopping rule). Possible later: the three undecided cases with ~8 GB; AG ideal to order >= 4.

**Session references (files not public).** LEDGER_DISCOVERY.md "[CS3-T6]" PRE, "[CS3-M1]", "[CS3-M2]" (25 Nov).

---

## N-TENFOLD-SINGULAR-SECTIONS

**Tenfold lead: loci where a P^8-section is singular along a plane do not explain the extra direction**

kind: `negative` | area: `movasati_conjecture` | status: **`RULED_OUT`**

**Statement.**

Pre-registered (25 Nov 2026). Strata of Sigma = {X : X n P^8 singular along a plane Pi} (MOD 32003, 31991, 2 seeds,
4/4 identical; codim by count = codim by tangent): generic (rank-6 transversal quadric net) codim 1; net with a
common singular point 14; net inside I_{A u B}(2) (A, B the disjoint planes of T's net) 19; cones 64. F_T, V_Z
and Cone_T lie in the codim-1 and codim-19 strata (F_T and V_Z are cut out inside the codim-19 stratum by the
cubic C vanishing on T, resp. on A u B; containments EXACT by ideal inclusion). At points of F_T the tangent of
each stratum contains T F_T but NOT the extra direction G_e, and meets T NL exactly in T F_T. ARG: on these
strata the new 5-cycles are joins J(Pi, S_j) over 2-dim components of a fibre-jump locus; on the codim-19
stratum they are V (exactly on F_T), P1, P2 (V_Z).

**Conditions.**

Only P^8-sections singular along a PLANE, the branch through the given (P^8, Pi), first order, MOD p. Not tested:
sections singular along non-planar surfaces (at points of F_T, Sing(X n P^8) has dimension 2 and degree 19, so it
contains more than Pi; components not determined), other branches.

**Evidence.** Session agent SS-T6, files leads/tenfold_session_scripts/ss_t6/ (scripts) and the session ledger.

**Independent check.** None (nothing explained). Controls: V_Z codim 39, Cone_T 65, T NL 54 and T F_T 55 reproduced.

**Not established.**

The components of Sing(X n P^8) at points of F_T (a second 2-dim component birational to T is expected, ARG);
strata singular along such surfaces.

**Known before.**

The singularity constraint motivating the test: N-TENFOLD-DIRECT-METHODS (every hyperplane through the span of an
explaining cycle is tangent to X).

**Reproduce.** not reproducible from this repository as is: leads/tenfold_session_scripts/ss_t6/ (absolute paths to adjust).

**Do not repeat.** The plane-singular strata at first order.

**Next step.** Sections singular along a non-planar surface (e.g. of type T), if the lead is resumed.

**Session references (files not public).** LEDGER_DISCOVERY.md "[SS-T6]" (25 Nov, PRE to CLOSE 14:43Z).
