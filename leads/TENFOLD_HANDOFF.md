# Handoff: the cubic tenfold lead (W), for the next agent or model

> **Update, 25 Nov 2026 (later the same day).** The lead was resumed by another model. A candidate explanation
> of W is recorded in `leads/TENFOLD_COBLE_LEAD.md` and registry entries D-TENFOLD-COBLE-FAMILY,
> D-TENFOLD-PRODUCT-POINTS, N-TENFOLD-THIRD-DETERMINANT: cubic tenfolds with a P^8-section that is a Coble cubic
> (singular along an abelian surface), codimension 54, first order MOD p and EXACT at two points, blind-checked;
> the statement that the class is carried by an algebraic cycle there is a paper argument (ARG), not checked.
> **Evening of 25 Nov 2026.** The class argument was replaced and orders 2 and 3 were tested along the explicit
> arc: section 10 of that note and entries D-TENFOLD-COBLE-CYCLE-CLASS (the 4-plane cycle has self-intersection
> -144, a multiple of h^5 would have 48; two paper arguments with MOD p inputs, inputs blind-checked) and
> D-TENFOLD-COBLE-ARC-ORDERS (orders 2 and 3 hold exactly, MOD p; order 2 blind-checked). What remains is a
> mathematician's reading of the two arguments, not computation.
> Later still: a control on the known coefficient +1 (section 11, D-TENFOLD-PFAFFIAN-K3): there the P^8-section is a
> Pfaffian cubic singular along a K3 surface, and the same node ladder reproduces the known lattice numbers.
> Night: one member is written down over QQ with a certificate for the 72 nodes and their one relation
> (section 12, D-TENFOLD-COBLE-EXACT-MEMBER, `leads/tenfold_coble/exact_member/`).
> 26 Nov 2026: at the Fermat tenfold the explicit arcs of the family carry a three-plane class, NOT Movasati's
> (C-TENFOLD-FERMAT-POINT-CLASS); for that class the family passes an explicit-arc test to orders 10-12
> (D-TENFOLD-COBLE-FERMAT-ARCS) and a symmetric subfamily has a proof (D-TENFOLD-FERMAT-THREE-PLANE-FAMILY);
> section 13. For Movasati's class nothing new. The node count is a tool: `tooling/node_section/`.
> Later on 26 Nov: the class of the 4-plane cycle is not a multiple of h^5 by an intersection count with a 5-plane
> (8 points against 4; MOD p; section 14, D-TENFOLD-COBLE-PLANE-COUNT). This replaces the two paper arguments as
> the basis of the class statement. Left: characteristic 0 by an exact run; a human reading.
> 26 Nov, owner's question on the K3 / abelian pairing (+1 / -1): section 15 of the lead note. Forced by the Euler
> characteristic of the surface (D-TENFOLD-K3-ABELIAN-PAIRING, D-NODES-DISCRIMINANT-IDENTITY); Enriques surfaces occur
> and give no relation (D-CUBIC-SEVENFOLD-ENRIQUES); rungs on sixfolds and eightfolds (D-COBLE-RUNGS-SIXFOLD-EIGHTFOLD).
> 26 Nov, later: section 16 of the lead note. The eightfold Coble rung is in the closure of l Q + det A + det B
> (D-EIGHTFOLD-COBLE-RUNG-IN-TWO-DET-CLOSURE); a Coble section is det(tau + A) - det(tau + B) with equal trace and second
> coefficient (D-COBLE-SECTION-TWO-DETERMINANTS); tangent cone at the rung (D-EIGHTFOLD-RUNG-TANGENT-CONE). New lead on
> tenfolds, codimension 52, class not computed: D-TENFOLD-TWO-DETERMINANT-FAMILY. Ask the owner before spending compute.
> 26 Nov, later still: the class is computed, see `leads/TENFOLD_TWODET_LEAD.md` (D-TENFOLD-TWO-DET-CLASS,
> D-TENFOLD-TWO-DET-HODGE-LOCUS): norm -48, in the orbit of [P1] - [P2] (argument), a four-plane class at the Fermat point.
> Open: does that family meet V_Z with the class [P1] - [P2]?
> 26 Nov, evening: a conditional yes, at cone points over the sixfold divisor D (section 7 of that note;
> D-TENFOLD-CONE-POINTS-TWO-DET; rests on the sixfold paper chain). At Movasati's point the order-4 statement of
> section 2 below is corrected: special nets of rank 2 and 3 pass order 4 (C-TENFOLD-ORDER4-RANK2,
> D-TENFOLD-ORDER4-MODEL-CONE); the bound is codimension 52, not 54, if the model of 27 quadrics holds.
> 26 Nov, later: the intersection count of section 14 of the Coble note is EXACT over QQ at a named member
> (section 17 there; D-TENFOLD-COBLE-PLANE-COUNT-EXACT). Order 6 at Movasati's point on the 13-dimensional piece:
> passes for lambda = -1, obstructed for 2 (D-TENFOLD-MOVASATI-ORDER6; one prime). Queued by the owner and not
> started: the matrices A(eps), B(eps) along T2's sixfold arc (O-RECOVER-MATRICES-AND-LIMIT-OF-T).
> 26 Nov, night: first batch on those matrices (section 8 of the two-determinant note): the arc exactly to order
> 19 (D-SIXFOLD-ARC-ORDER19); in floating point the splitting holds and ONE matrix was found
> (D-ARC-SPLITTING-NUMERICAL); the second was not (N-MATRIX-RECOVERY-FIRST-ATTEMPTS says what failed).
> 26 Nov, late night: past order 6 at Movasati's own point (section 9 of the two-determinant note,
> D-MOVASATI-POINT-ARC-ORDER8): lambda = -1 to order 9 MOD p on directions with C = 0, through the eightfold and the
> cone map; lambda = 2 obstructed at order 6. Next there: characteristic 0 in the symmetric direction.
> Read that note before sections 4-5 below; the rest of this file is unchanged.

Written 25 Nov 2026 by the coordinating agent (Claude Opus 5.5) for Timothy Seifert, the repository owner, who is
handing this problem to another model. Everything below is AI-generated and unreviewed by any mathematician. Read
"Rules" before doing anything.

## 1. The problem in one paragraph

Let X be a smooth cubic tenfold in P^11. On the Fermat cubic X0 take Movasati's pair of 5-planes P1, P2 meeting in a
P^2, and the Hodge class delta_lambda = [P1] + lambda [P2]. Its Hodge locus NL(delta_lambda) contains V_Z (both planes
deform; codim 39 in moduli) and, for every lambda, the cone locus Cone_T (X n P^8 a cone with vertex P^2 over a cubic
fourfold; codim 65; Kloosterman). The computations suggest that for lambda = -1 ONLY there is a further component
W of codim 54 (slice dimension 166 of 220) through X0, containing Cone_T, whose tangent cone contains the rank-1
(Segre) normal directions to Cone_T, and containing the C_18 family F_T (codim 55) as a divisor. W is NOT
explained by any construction tried. If W exists and its general member carries a class not known to be algebraic,
that would be "a Hodge class not known to be algebraic" on a specific family; if W is explained by a cycle, the
Hodge conjecture holds there and the question is closed. Neither has been shown. The lead is an OPEN lead, NOT a
candidate, and it is PAUSED after the searches below.

The open question it addresses: rStation paper #5 (u/lelong_ridge, 18 Oct 2026,
https://rstation.ai/problems/hodge_conjecture/papers/5) proves V_Z is a component of the reduced Hodge locus at X0
for all 125 of Movasati's ratios (generic arcs obstructed at order 4; we agree), bounds its explained families by
slice dimension 155, and leaves open whether a component of dimension > 155 exists. W would be one (166), for
lambda = -1 only.

## 2. Notation and the key objects

- S = k[x0..x11], F the cubic, J the Jacobian ideal, R = S/J. Periods of a 5-cycle Z: pi(P) = int_Z Res(P Omega/F^6)
  on S_6 (sigma = 6); higher pole orders psi_m on S_(6+3m) appear in arc expansions.
- Movasati's pair at X0 (see discoveries/NOTATION.md): P1, P2 cut by x_(2i) - zeta x_(2i+1) type equations;
  P1 n P2 = Pi = P^2. lambda_0 = +1 here (general rule lambda_0 = (-1)^(c-1), c = 3; registry D-TENFOLD-LAMBDA0-CHECK).
- First order at X0: the map L (rank 38) on cubics; ker L / T Cone_T is 27-dimensional = 3 x 3 matrices of linear
  forms on Pi; rank-1 matrices form two Segre cones (types "a x l" and "l x a"). These are the directions W uses.
- Cone_T: X n P^8 = cone with vertex Pi over a cubic fourfold Y; the class corresponds to a class on Y in Hassett's
  C_d with d = 8r^2 - 2rs + 8s^2; lambda = -1 gives d = 18, lambda = 2 gives 36. lambda = -1 is BOTH the unique
  value fixed by the swap tau (P1 <-> P2, lambda -> 1/lambda) AND the unique C_18 value.
- F_T: cubic tenfolds containing V = J(P^2, T), T an AHTV elliptic ruled sextic scroll in a complementary P^5
  (Addington-Hassett-Tschinkel-Varilly-Alvarado C_18 surfaces). codim F_T = 55; codim T NL([V]) = 54 at a random X
  in F_T: one extra Hodge-tangent direction G_e. The first-order Hodge lattice along F_T is <h^5, [V]> (h^5.h^5 = 3,
  h^5.[V] = 6, [V]^2 = -36).

## 3. Evidence (all labels as in the registry; MOD p = computed modulo primes; finite order = formal arcs only)

| # | Finding | Label | Checked by |
|---|---|---|---|
| 1 | At X0, lambda = -1 generic rank-1 directions extend as formal arcs: one to order 12 at two primes (67108837, 67108819) with identical correction histories; ~70 more to orders 9-10; sparse arcs to 15; none obstructed | MOD p, finite order | cloud runs, checker re-run |
| 2 | lambda = 2 obstructed at order 6 (120/120 generic directions); exact certificate y.c6 = 480(1+z) over Q(zeta_6) for three directions; 26 other ratios obstructed at order 6; only -1 and lambda_0 = 1 extend | MOD p + EXACT (3 dirs) | blind check BC-T6 |
| 3 | Symmetry test: at two Thom-Sebastiani split points Fermat4(x) + G(y) (G a cubic fourfold with two disjoint planes; no automorphism swaps the planes, exact) the same dichotomy holds (lambda = -1 to orders 6 and 8; lambda = 2 obstructed at 6) | MOD p, pre-registered | blind check BC-TS (agree) |
| 4 | At random X in F_T, G_e is unobstructed at order 2 (all-zero order-2 matrix) | MOD p | blind check BC-SO (agree) |
| 5 | G_e unobstructed at order 3: the deciding number 6 psi(G^2 g2) - 7 psi3(G^4) = 0 with both terms nonzero | MOD p | partly blind check BC-SO3 (agree) |
| 6 | V is not lci (depth 5); Buchweitz-Flenner semiregularity map for O_V has a 1-dim kernel = G_e: NOT semiregular (neutral); V rigid in X | MOD p + ARG + LIT | none |
| 7 | At del Pezzo cone points (special points of F_T) the excess over F_T jumps 1 -> 5; a rank-4 quadric cone of those survives order 2 | MOD p | none |
| 8 | lambda_0 = +1; at a general V_Z point excess is 1 at lambda = 1 only; at X0 it is 1 for every lambda | MOD p | D-TENFOLD-LAMBDA0-CHECK |

Consequence used everywhere: an explaining cycle Z must have class a h^5 + b[V] with b != 0 (V itself does not
deform along G_e), degree 3a + 6b, square d^2/3 - 48 b^2, span P^7..P^11, and every hyperplane through its span is
tangent to X (dim Sing(X n span) = 10 - k).

## 4. What has been tried and failed to explain W (do not repeat; details in the registry)

All pre-registered; "ruled out" means only the listed types, at tested members, MOD p.
- First search (N-TENFOLD-CODIM54-SEARCH): lattice/two-class reading (single class [V] mod h^5); joins with the
  only other C_18 surface class (sextic del Pezzo; that family lies inside F_T); all four linkage residuals of V
  (R22, R23, R33, R222: codim 55, smooth incidence, so at all orders); degenerations of T; cones with point or
  line vertex (no Eckardt-type point on F_T); small-degree 5-folds (3 x 4 determinantal, J(line, v3(P^2))).
- Earlier (in O-TENFOLD-CONE-LEAD): Kloosterman cones (= Cone_d), 13 cone/join/scroll families (codims 32-60),
  Segre-type sections (integrality: degree divisible by 3), unions U9/U12 (codim 55).
- Second search (N-TENFOLD-CODIM54-SEARCH-2): Thom-Sebastiani / Katsura-Shioda cycles (rStation #11), further
  degenerations, P^3-bundles, scrolls of degree 9 and 12, unions with V, del Pezzo-guided families.
- Direct methods (N-TENFOLD-DIRECT-METHODS): (M1) Movasati's Artinian Gorenstein ideal of the class along the arc
  of G_e, degree <= 3, to order 3: stays that of [V] (weak test). (M2) search over admissible invariants: seven
  constructions in cells of degree 3-21, none codim 54. Undecided (memory, ~8 GB): generic double structures on V,
  double structures in P^8, residual R25 (degree 24).
- Singular-section loci (N-TENFOLD-SINGULAR-SECTIONS): tenfolds with a P^8-section singular along a plane: strata
  of codim 1, 14, 19, 64 (cones); F_T, V_Z, Cone_T lie in the codim-1 and codim-19 strata, but at points of F_T their
  tangents contain T F_T and NOT G_e. NOT EXPLAINED. Side finding: at points of F_T, Sing(X n P^8) is 2-dimensional
  of degree 19, so it contains more than the plane (a component birational to T is expected; OPEN); sections singular
  along such non-planar surfaces are untested.
- Not a symmetry artefact (finding 3), not semiregularity-forced (6).

## 5. Open threads, ranked by our estimate of value

1. Theory: a reason W must exist (e.g. a deformation-theoretic argument at points of F_T that the Hodge locus of
   [V] has codim <= 54, or an obstruction-theory computation of the full tangent cone) or must not (an obstruction
   at some order along G_e; a global invariant). Finite-order computation cannot settle existence: there is no
   effective Artin bound for this problem.
2. A construction outside sections 4: the cycle Z must satisfy the invariants in section 3. Candidates not yet
   covered: double structures on V (generic), non-cone 5-folds spanning P^9-P^11 not built from V, other
   correspondences, P^8-sections singular along a NON-planar surface (e.g. of type T; see the SS-T6 side finding).
3. The Segre P^2 x P^2 cone family: codim 55, Hodge-tangent codim 50 (5-dim first-order excess), not F_T; order 2
   there untested. Possibly another view of the same phenomenon.
4. Order >= 4 at F_T points (needs psi_4 / psi_5 on S_15, S_18; several CPU-hours per run), and the AG ideal to
   order >= 4 / degree > 3.
5. Exact (characteristic 0) certificates at split points; a specific smooth member of W off the cone locus with an
   exact proof that the class is Hodge there (only after W is found or proved to exist).
6. Expert input (a draft one-page summary exists; the owner decides whether to send it).

## 6. How to work with the repository

- Repository: https://github.com/timseifer/HodgeLociCI (public). Release v0.1.2 (Zenodo; v0.1.1 DOI
  10.5281/zenodo.24455334). Default branch main. Branch cloud-job-1: cloud job code and results (not on main).
- Package: M2/HodgeLociCI.m2 (Macaulay2 1.22). Load with
  `needsPackage("HodgeLociCI", FileName => "M2/HodgeLociCI.m2")`. Key functions: excessFromDegrees,
  linearSubspaceCase, tangentExcess (slow on tenfolds), excessFromData, randomCyclePair (use CheckSmooth => false
  for k >= 4), fermatRing, fermatPeriodPolynomial, fermatPeriodGD, fermatExtendArc, fermatPersistenceTangent,
  fermatLinearSpaceIdeal, secondOrderFunctional, secondOrderObstruction. Docs: docs/API.md, docs/*.md;
  tests/validation/common.m2 has linearPair and fermatPairModP (p must be 1 mod 6).
- Read AGENTS.md first (commands, pitfalls: string keys, NotDetermined, MOD p vs EXACT, Strategy => "Residue" for
  large cases, the fast GB engine only below p = 32768). Smoke test `M2 --script examples/quickstart.m2`; suite
  `tests/run_all.sh`; package tests via installPackage + check (AGENTS.md). CI: .github/workflows/ci.yml. Docker:
  Dockerfile (Ubuntu 24.04, ~405 MB); MCP server in mcp/.
- Registry: discoveries/registry.yaml (169 entries) is the source of truth; pages discoveries/0*.md are generated:
  run `python3 discoveries/check_registry.py --write-pages` then `python3 discoveries/check_registry.py` (must say
  OK). Statuses: PROVED_AI_UNREVIEWED, EXACT, MOD_P, RULED_OUT, OPEN, etc. Every entry needs statement, status,
  conditions, evidence, independent_check, not_established, known_before, reproduce, session_refs. Update the
  entry count in README.md, AGENTS.md and llms.txt when adding entries.
- Progress page: site/build_site.py + site/status.json; GitHub Actions (.github/workflows/pages.yml) rebuilds
  gh-pages on every push to main that touches the registry or site.
- Tenfold entries: O-TENFOLD-CONE-LEAD (main record), N-TENFOLD-CODIM54-SEARCH, N-TENFOLD-CODIM54-SEARCH-2,
  N-TENFOLD-DIRECT-METHODS, N-TENFOLD-SINGULAR-SECTIONS, D-TENFOLD-LAMBDA0-CHECK; readable summary leads/TENFOLD_CONE_LEAD_DOSSIER.md.
- Engines:
  - tooling/fermat_series/ (fsc.cpp compiled kernel + fsc.py, w3eng.py, fe_ref.py reference): the Fermat tenfold
    arc expansion; test_fermat_series.py reproduces stored order-8 and order-11 results exactly.
  - Branch cloud-job-1, jobs/cloud-job-1/hodge_job.py, run_tasks.py, check_results.py: the batch arc runner used on
    a 30-core / 200 GB instance (order 12 generic ~130 GB; order 13 would need ~244 GB). Queue protocol:
    jobs/queue/README.md.
  - leads/tenfold_session_scripts/: the session scripts behind sections 3-4 (Macaulay2/Python/C++), copied as-is
    with absolute paths from the original machine (/home/claude/...): adjust paths before running. Directory names
    match the ledger tags (so_t6 = order 2 at F_T, so3_t6 = order 3, bc_* = blind checks, ts_t6 = split points,
    dp_t6 = del Pezzo, sr_t6 = semiregularity, cs_t6, cs_t6d, cs2_t6, cs3_m1, cs3_m2 = searches, ss_t6 = singular
    sections, w1-w4 / ex_t6 / exp_t6 / bc_t6 = Fermat-point work). Useful libraries: bc_so/famlib.m2 (order-2
    functional via family derivatives), so3_t6/o3lib.m2 (psi, psi3), bc_so3/o3np.py (numpy order 3),
    cs2_t6/cslibS2.m2 (family codim WITH Hom_0 + h0(N_{Z/X})), cs_t6d/cslibS.m2 (streamed mod-p kernel).
- Practical notes: M2 ChangeMatrix Groebner bases for the tenfold Jacobian to degree 6 do not finish; Singular
  liftstd does it in ~100 s. Tenfold M2 runs take 20-40 CPU-min and 1-2 GB each. Random smoothness checks of
  tenfolds are too slow; check smoothness along the cycle instead.

## 7. Rules that applied to this work (keep them)

- Never present anything as a proof or disproof of the Hodge conjecture. The target wording is "a Hodge class not
  known to be algebraic"; never "counterexample".
- Label every claim: EXACT / MOD p / PROVED on paper (AI) / ARG / COMPUTED ONLY / RULED OUT / OPEN / LIT. Exact
  arithmetic for anything claimed; mod p for scouting. Finite-order arcs are evidence only.
- Pre-register (write down what each outcome would mean) before running; one blind check per new claim; a devil's
  advocate for any candidate. "Ruled out" means only the named types.
- Search existing code before writing new code. Credit prior work (rStation #5 and #11 precede several entries).
- The three AI-written papers (cited as "paper 3" etc.) are frozen and are not in this repository; do not treat
  their theorems as established. Releases and tags are the owner's.

## 8. If you only have an hour

Read O-TENFOLD-CONE-LEAD in discoveries/registry.yaml, then this file's sections 3-5, then decide between a
theoretical attack on thread 1 and a new construction class for thread 2. The single most useful outcome would be
either an explicit 5-cycle of class a h^5 + b[V], b != 0, on a codim-54 family containing F_T, or an argument that
the Hodge locus of [V] near a general point of F_T is F_T itself (which would make G_e obstructed at some order).
