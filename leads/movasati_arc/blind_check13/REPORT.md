# Blind check 13 — report (arc at the eightfold Movasati point, lambda = -1 and lambda = 2)

(Saved by the main session from the checker's hand-back, verbatim: the checker cannot write this file itself.)

## Summary

All six items were checked with my own code and cross-checked with the package as a black box. Everything is MOD p (p = 32029 and 31981, two different random directions); nothing is exact.

- **C1 CONFIRMED (MOD p).** All 45 periods of [P1] - [P2] vanish to order 8 (p = 32029) and order 7 (p = 31981), in my code and in the package. T_1 is in the first-order kernel and is not tangent to the locus where P1 (or P2) persists. For [P1] + [P2] the arc fails at order 1.
- **C2 CONFIRMED (MOD p).** A and B are non-zero of rank 2, with a common kernel and a common cokernel; all nine y_1 y_2-coefficients vanish; A and B are not proportional. "Not a cone" is a first-order statement (ARG).
- **C3 CONFIRMED and strengthened (MOD p, both primes).** In the author's slice no jet passes order 6. In the full 120-dimensional space of cubics modulo squares, no choice of T_2..T_6 satisfies orders 2..6 with the given T_1. This rests on exact linear algebra plus random polynomial-identity tests.
- **C4 (ARG).** The reading is sound if "reduced" means the tangent cone is reduced as a scheme at T_1. For a component of dimension dim V - 6 that is automatic from the rank 7 I computed. The "same matrix" statement is right for the linear part but incomplete.
- **C5 CONFIRMED (MOD p).** Tenfold, 221 forms: my code to order 8 and 7, package to order 6. It is an automatic consequence of C1.
- **C6.** "Order 8" does not establish a component. The tenfold arc is itself a cone over the eightfold arc. C2 describes the chosen input, not an outcome. T_1 is special inside the 94-dimensional candidate cone. For lambda = 2, smaller components and arcs with fractional powers remain open.

Nothing here is, or bears on, a proof or disproof of the Hodge conjecture.

## Method

- **Own code.** Python with python-flint `nmod_mpoly` and numpy, in `/home/claude/blind_check13/lib13.py`. The period functional is adapted from `/home/claude/blind_check12/c1_own.py` (sixfold over QQ(z)) to 10 or 12 variables mod p.
  - lam_L(x^r) is non-zero iff r contains exactly one index of each pair, and then equals the product of z^e over the pairs with a in r.
  - The relative constant of P2 against P1 comes from the automorphism x_(2i+1) -> z^(-2) x_(2i+1), i < 3, which carries P1 to P2.
  - Pole-order reduction: x^(3q+r) -> prod_{s<=q} (3s+r-2)/3, zero for r = 2. Periods are c_n[Q] = Lam(Q E_n), E_n = [eps^n] exp(sum eps^j T_j).
- **Package** (`fermatExpansion`, `fermatVerifyArc`, `fermatNextOrderSystem`, `fermatFirstOrderMatrix`) used only as a black box.
- **Shared assumption.** My code and the package rest on the same closed formula and on the same assumption that the 45 pole-order-4 periods cut out the Hodge locus. Their agreement does not test that formula.
- **Root of unity.** z = 31556 = -473 (p = 32029), z = 12637 (p = 31981); same as `fermatRoot`.
- **Forbidden files.** I did not read `ma1_probe.m2`, `ma2_slice_arc.m2`, `ma3_cone_to_tenfold.m2`, `PREREG_arc.md` or anything in `logs/`. After all computations were finished I read `leads/movasati_arc/README.md` and one registry entry (D-CUBIC-EIGHTFOLD-INVARIANT).
- **Repository.** I wrote nothing in it. Files there changed during my run (README, logs, `arcs/arc9_...`), by someone else.
- **Time.** About 18 minutes of wall-clock with something of mine running. Longest single run: 5 min 29 s (package, order 8).

## C1 — CONFIRMED (MOD p)

| check | p = 32029 | p = 31981 |
| --- | --- | --- |
| own code, [P1] - [P2], non-zero entries among 45 per order | 0 at every order 1..8 | 0 at every order 1..7 |
| package `fermatExpansion` | 45 x 8 zero matrix (also 45 x 7 in a separate run) | 45 x 7 zero matrix |
| largest E_n handled | E_8, 3,306,626 terms | E_7, 1,220,271 terms |
| first-order matrix | 45 x 120, rank 19 (own and package) | rank 19 (own) |

- **T_1 in the first-order kernel:** L T_1 = 0 (MOD p).
- **Not tangent to the locus where P1 persists:**
  - T_1 is not in (I(P1) + J)_3, which has dimension 110 of 120; the same holds for P2.
  - The first-order periods of [P1] alone at T_1 have 4 non-zero entries of 45.
  - T_V has dimension 100 (codimension 20) and equals the kernel of the stacked first-order maps of [P1] and [P2] (rank 20). ker L = T_V + <T_1> (dimension 101).
- **Not an arc for [P1] + [P2]:** fails at order 1 (4 non-zero entries), own code and package. This is a trivial consequence of the previous point: (L_1 + L_2) T_1 = 2 L_1 T_1 is non-zero.
- **Controls:** T_k + x_0 x_3 x_9 fails first at order k (k = 2, 4, 6). This only tests that the code sees a change.
- **Side result (own, p = 32029):** in the 252-dimensional space of functionals x^r, the classes staying of type (4,4) along the arc have dimension 207, 162, 117, 72, 27, 1 for orders up to 1..6. From order 6 on, only [P1] - [P2] survives, so the arc is not inside a locus where further classes stay Hodge.
- **Bonus, outside the brief:** `arcs/arc9_32029_seed1_lam-1_d.txt` appeared during my run. In my code all 45 periods vanish at orders 1..9. Its T_1..T_5 equal the arc8 file; T_6, T_7, T_8 differ.

Not checked: any exact computation; a third prime; the same direction at two primes; the package at order 9.

## C2 — CONFIRMED (MOD p), all four files

- **Shape of T_1:** 50 monomials: 20 in x_0..x_5, 15 with x_7, 15 with x_9, none with x_6 or x_8.
- **Nets are well defined:**
  - T_V = "the rest" (dimension 82: (f_3, f_4) times quadrics, and f_i h_j x_m with m <= 5) plus the 18 nets.
  - Modulo squares, (f)_2 and (h)_2 in x_0..x_5 have dimension 12 each and sum 15, so their intersection is the span of the nine f_i h_j (rank 9).
  - The x_7- and x_9-parts of T_1 restricted to {f_3 = f_4 = 0} lie in that span.
- **Matrices**, index (i, j) for f_i h_j:
  - p = 32029: A = [[19984, 21672, 20255], [29896, 11372, 26150], [25067, 6961, 20312]], B = [[2583, 21125, 20263], [27136, 23910, 1294], [20143, 14760, 11105]].
  - p = 31981: A = [[4349, 8511, 13793], [141, 25937, 16732], [13657, 12871, 18180]], B = [[19051, 9912, 25123], [13184, 31420, 17955], [20702, 11118, 6303]].
- **Properties, both primes:**
  - rank A = rank B = 2; rank [A; B] = rank [A | B] = 2 (common kernel, common cokernel).
  - All nine y_1 y_2-coefficients of the 2 x 2 minors of A y_1 + B y_2 are 0.
  - A and B are not proportional; rank(A + tB) = 2 for t = 1, 2, 3.
- **Lambda = 2 files:** same A and B as the lambda = -1 file of the same prime ("same nets" holds).
- **"Not a cone over an arc of a sixfold" (ARG, first order):** T_1 modulo J is unchanged by eps-dependent coordinate changes, and it involves both x_7 and x_9. So it is not a cone direction for either coordinate splitting (x_8, x_9 untouched, or x_6, x_7 untouched).
- **Extra observation (MOD p):** minors(B) / minors(A) is one constant (31599, resp. 28322). So the pencil has exactly two members of rank at most 1, at (y_1/y_2)^2 = 430 (a square mod 32029) and 3659 (not a square mod 31981). The net is l_+ R_+ + l_- R_- with R of rank one and l two linear forms in x_7, x_9. These forms are not of the type x_7 + (root of unity) x_9. OPEN: whether this has a meaning; I did not compare with sixfold arcs.

## C3 — CONFIRMED in the slice, and in the full space (MOD p, both primes)

**The file jets (lambda = 2, T_1..T_5, T_6 = 0).**
- Orders 1..5: 0 non-zero entries. Order 6: 43 of 45 non-zero, not in im L; the projection e6 to coker L has 9 of 26 non-zero entries.
- Package (`fermatNextOrderSystem`, p = 32029): order 6, lowerOrdersVanish true, solvable false, obstruction with 9 of 26 non-zero entries, equal to 12322 times my e6.

**The author's slice** (19 monomials read from the last term; 7 nets with index 9k + 3i + j, recovered by fitting T_2, matching line 2 of the files).
- L has rank 19 on the 19 monomials and kills the nets.
- The file's D equals one scalar times my own response matrix (12322, resp. 30493): rank 7, 17 zero rows. My matrix is the total linear response of the order-5 obstruction to the 7 nets of T_2, with pivot parts re-solved.
- e6 is not in the column space of D.
- A complete elimination in the slice (my "linear closure", non-linear terms included) ends with an inconsistent linear system. Verdict: no jet in the slice passes order 6.

**Full space of squarefree cubics** (T_n = T_n^0 + k_n + pi_n, k_n in ker L of dimension 101, pi_n in the 19 monomials, eliminated exactly).
- A first attempt (linear closure without eliminating the pivot parts) stalled at dimension 435 and decided nothing.
- The reduced system decided it. Let ob_n in K^26 be the order-n cokernel equations, as polynomial maps of (k_2..k_(n-1)):
  1. Linear response of order n to the kernel part of T_(n-1), T_(n-2), T_(n-3): ranks 0, 0, 7 ("level 3"). Order 6 to T_2 ("level 4"): rank 11, and rank 7 on ker(level 3).
  2. ob_3 = 0 and ob_4 = 0 identically; ob_5 = level3 * k_2 exactly (no quadratic part; independent of k_3, k_4). Tested at 8 + 40 random dense points.
  3. So order 5 forces k_2 into ker(level 3), a 94-dimensional space containing T_1.
  4. For k_2 in ker(level 3) and k_3, k_4, k_5 arbitrary in ker L: ob_6 - e6 lies in im(level 3) at 10 of 10 random dense points, and is non-zero each time. The quadratic part in k_2 is non-zero but lies in im(level 3) (12 of 12); cubic part and k_2 x k_3 cross term are zero.
  5. e6 is not in im(level 3). Hence ob_6 is never 0.
- **Conclusion:** no T_2..T_6 in the full space satisfies orders 2..6 with this T_1. By normalising with coordinate changes (ARG), the same holds for arcs in all cubics with this T_1 modulo J.
- **End-to-end validation (p = 32029):**
  - The identity c(T^0 + Y) = c(T^0) + Lin Y + NL(Y) was checked against the direct definition at a sparse and a dense Y.
  - For two random dense admissible jets, direct computation gives 0 of 180 non-zero entries at orders 2..5, and an order-6 defect equal to ob_6, congruent to e6 modulo im(level 3).
- **Control (lambda = -1, p = 32029):** same ranks 0, 0, 7, 11; e6 = 0; ob_6 lies in im(level 3) at 10 of 10 random admissible points. So for lambda = -1 every admissible T_2 continues through order 6; the method does not always answer "obstructed".
- **Linearised version (exact linear algebra):** the 206 x 480 system for orders 2..6 has rank 90, and rank 91 with the defect.

**Status of the full-space statement:** MOD p, one direction per prime, integer powers of eps. Items 2 and 4 are polynomial identities tested at random points (error at most 3/p per point), not expanded symbolically.

Not checked: orders above 6; exact arithmetic; other directions.

## C4 — sound, with two clarifications (ARG)

1. **The slice argument.**
   - If the tangent cone of W, as a scheme, is reduced and smooth at T_1, the blow-up of W is smooth at [T_1] and transversal to the exceptional divisor. A slice Sigma with Sigma cap T_{T_1}C = <T_1> then cuts out a smooth curve, i.e. an arc eps T_1 + ... with integer powers.
   - The hypothesis must be read this way. If only the reduction of the cone is smooth at T_1 (a multiple structure), the branch can be ramified and the argument fails.
   - The slice need not be general. The needed transversality is exactly "level 3 is injective on the 7 nets and kills T_1", which holds (MOD p).
2. **For dimension dim V - 6 the hypothesis is automatic** (ARG on the MOD p data).
   - Items 1 and 2 of C3 say the reduced equations of the part of the Hodge locus outside V start with cubic forms chi_3, whose Jacobian at T_1 has rank 7.
   - A component of dimension at least 94 with T_1 in its tangent cone would then have tangent cone equal to the smooth 94-dimensional germ {chi_3 = 0} near T_1, hence reduced and smooth.
   - With the full-space result of C3, the slice is not needed: no component of dimension at least dim V - 6 of the Hodge locus of [P1] + 2[P2] has this T_1 in its tangent cone.
   - More generally, no component of any dimension has a tangent cone reduced and smooth at this T_1 (finite order, one direction, MOD p).
3. **I agree with the author on what is not excluded:** smaller components whose tangent cone contains T_1 non-reducedly, arcs eps^m T_1 + ... with m >= 2 (fractional powers), and components whose tangent cone does not contain this T_1.
4. **"Affine-linear in the free part of T_(n-3), same matrix for every n."**
   - The linear part is right and exact (ARG): the derivative of c_n with respect to T_m is Phi(E_(n-m) .) and depends only on n - m.
   - Affine-linearity is automatic for n >= 7. For n = 5, 6 it needs quadratic terms to vanish; I found that they do, in the full space (MOD p, random tests).
   - It is not a general fact: it holds here because levels 1 and 2 vanish identically. The matrix depends on T_1.
   - The description is incomplete: the order-n obstruction also depends on the free parts of T_(n-4), ..., T_2 (level 4 has rank 11, plus a non-zero quadratic term at n = 6). In the slice these are already pinned. In the full space I checked for n = 6 only that their contribution lies in im(level 3).

## C5 — CONFIRMED (MOD p); automatic from C1 (ARG)

- **Own code** (12 variables, 221 forms, 48 patterns): 0 non-zero entries among 221 at every order 1..8 (p = 32029) and 1..7 (p = 31981). Control: T_3 + x_0 x_3 x_10 fails at order 3.
- **Package** (`fermatRing(3, 10, 32029)`, `fermatVerifyArc`, order 6): pass, 221 forms; [P1] + [P2] fails at order 1.
- **Why it is automatic:** the functional factorises over the pairs and the arc does not involve x_10, x_11. Checked for [P1] alone at orders 1..3: the tenfold period of x_10 q is z times the eightfold period of q, that of x_11 q equals it, and the other 130 cubic forms and Q = 1 give 0. So C5 adds no evidence beyond C1.

Not checked: the package beyond order 6; the tenfold's own first-order structure.

## C6 — overstated points and other readings

1. **"Order 8" is a finite-order statement.**
   - From order 5 on, each order gives 26 conditions for 7 unknowns, so 19 hold without help. Order 5 also passes for lambda = 2, so what separates lambda = -1 is orders 6..8 (57 scalar conditions at p = 32029, 38 at p = 31981), plus order 9 from my bonus check.
   - This is strong evidence of structure, but equally consistent with an obstruction at order 10 or later. For lambda = 2 the obstruction also appears only after the earlier orders pass.
   - The free parts of T_6, T_7, T_8 in the arc8 files are untested placeholders.
   - "A component of dimension dim V - 6" is an inference from rank 7, not something the arc shows.
2. **The tenfold arc is a cone over the eightfold arc.** "A direction that is not a cone" applies to the eightfold only (not a cone over a sixfold arc).
3. **C2 describes the input.** By the registry entry, the direction was chosen in the known codimension-7 piece (common kernel, common cokernel, no y_1 y_2-term). My count agrees: level 3 has rank 7 on the 18 nets and vanishes on "the rest" and on the cubics in x_0..x_5.
4. **T_1 is special inside the 94-dimensional candidate cone.** Its component along the 64 directions of "the rest" outside x_0..x_5 is zero. For lambda = 2 this does not matter. For lambda = -1 the arcs are evidence at such special directions only; a generic direction of the cone was not tested.
5. **Two primes, two different directions.** No direction was tested at two primes and nothing is lifted to characteristic 0.
6. **The slice wording of C3 is weaker than what holds;** the full-space statement is true at these two instances.
7. **Open, not tested:** whether the two rank-one members of the pencil (C2) relate the arc to rank-one directions.

## Files (all in /home/claude/blind_check13)

- Library: `lib13.py`, `c3_lib.py`
- C1: `c1_own.py`, `c1_own_32029_o8.out`, `c1_own_31981_o7.out`, `c1_pkg.m2`, `c1_pkg_lean.m2`, `c1_pkg_32029_o7.out`, `c1_pkg_32029_o8.out`, `c1_pkg_31981_o7.out`
- C2: `c2_own.py`, `c2_own.out`
- C3: `c3_basic.py`, `c3_run.py` (slice and closure), `c3_red.py`, `c3_red2.py`, `c3_final.py`, `c3_e2e.py`, `extras.py`, `c3_pkg.m2`, with outputs `c3_slice_32029.out`, `c3_slice_31981.out`, `c3_full_32029.out`, `c3_red_32029.out`, `c3_red2_32029.out`, `c3_final.out`, `c3_e2e_32029.out`, `extras_32029.out`, `c3_pkg_32029.out`
- C5: `c5_own.py`, `c5_own_32029.out`, `c5_own_31981.out`, `c5_pkg.m2`, `c5_pkg_32029_o6.out`
- C6: `c6_classes.py`, `c6_classes_32029.out`, `bonus_arc9.py`, `bonus_arc9.out`

Nothing in this report comes from the user's memory store. One practical note: the python-flint implementation in `lib13.py` computes the order-8 eightfold expansion in about a minute, against about 5.5 minutes for the package.
