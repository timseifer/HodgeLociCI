# Changelog

All notable changes to this package are recorded here. Format: Keep a Changelog; versions follow semantic versioning.

## [Unreleased]

### Discoveries registry (142 -> 178 entries)
- D-TENFOLD-COBLE-EXACT-MEMBER (certificate, AI, unreviewed; blind-checked): a named smooth cubic tenfold with
  rational coefficients in the Coble family. Over QQ its hyperplane section has exactly 72 ordinary double points
  with exactly one relation on quartics, and the first-order Hodge locus of the class has codimension 54. Three
  items computed directly over QQ, two modulo three primes with a specialization step. Equation and scripts in
  `leads/tenfold_coble/exact_member/`; `leads/TENFOLD_COBLE_LEAD.md`, section 12.
- C-TENFOLD-FERMAT-POINT-CLASS (correction): at the Fermat tenfold the explicit arc of the Coble family carries the
  three-plane class h^5 - P1 - P2 - P3, not Movasati's class P1 - P2; the planned check and one remark of section 5
  of the lead note are withdrawn. Nothing new is shown for Movasati's class.
- D-TENFOLD-FERMAT-THREE-PLANE-FAMILY (AI proof, unreviewed): on the 3-parameter family "Fermat plus a Heisenberg
  trilinear term", which lies in the Coble family, the three-plane class stays Hodge (two exact computations).
- D-TENFOLD-COBLE-FERMAT-ARCS (MOD p, finite order; blind-checked): explicit arcs of the Coble family through the
  Fermat tenfold with no symmetry and no free terms satisfy all period equations of the three-plane class to
  orders 10-12 at two primes; every change to the Coble relation fails at the pre-registered order.
  `leads/tenfold_coble/fermat_point/`; `leads/TENFOLD_COBLE_LEAD.md`, section 13.
- D-TENFOLD-COBLE-PLANE-COUNT (MOD p; blind-checked): in a tenfold of the Coble family that contains a 5-plane, the
  5-plane and the 4-plane cycle meet transversally in 8 points, where a multiple of h^5 would give 4. The class of
  the cycle is not a multiple of h^5 by a count, without the node argument or the ladder.
  `leads/tenfold_coble/plane_test/`; `leads/TENFOLD_COBLE_LEAD.md`, section 14.
- D-TENFOLD-K3-ABELIAN-PAIRING (paper argument by an AI, unreviewed; MOD p support; blind-checked): why the
  coefficient +1 goes with a K3 surface and -1 with an abelian surface. One relation among the nodes iff K_S = 0
  (residue theorem); discriminant = -8 deg(S) = -8 (18 - 2 chi(O_S)); 14 only for P1 + P2, 18 only for P1 - P2.
  What is forced is the discriminant, for a suitable cycle (known for the K3; an argument for the abelian surface).
  `leads/TENFOLD_COBLE_LEAD.md`, section 15; `leads/tenfold_coble/pairing/`.
- D-NODES-DISCRIMINANT-IDENTITY (proved by an AI, unreviewed): for a smooth k-fold Sigma in a hyperplane section of
  a cubic 2k-fold, disc <h^k, [Sigma]> = (-1)^k 2 (number of nodes of the section on Sigma). Five direct counts MOD p.
- D-CUBIC-SEVENFOLD-ENRIQUES (MOD p): the pencil det X + c det Y of symmetric determinants is singular along an
  Enriques surface of degree 16 in P^8; 64 nodes on tenfold sections, no relation.
- N-BIELLIPTIC-NOT-SINGULAR-LOCUS (MOD p; one family of embeddings): a bielliptic surface of degree 18 in P^8 with K
  of order 2 is not the singular locus of a cubic.
- D-COBLE-RUNGS-SIXFOLD-EIGHTFOLD (MOD p): node counts 14 / 28 (+1) and 18 / 36 (-1) on sixfolds and eightfolds; the
  class as a functional built from the relation among the nodes (five controls); tangent codimension 25 at the
  eightfold Coble rung, against 26 for l Q + det A + det B.
- D-COBLE-SECTION-TWO-DETERMINANTS (MOD p: an exact identity over a finite field at two random instances (two primes);
  the general statement is an argument): a hyperplane section G of a Coble cubic satisfies
  det(tau + A) - det(tau + B) = c G with tr A = tr B and equal second coefficient; equivalently G = det M - det sM on
  P(sl_3) for an isometry s of the trace form. Certificates and a checker in `leads/tenfold_coble/pairing/`.
- D-EIGHTFOLD-COBLE-RUNG-IN-TWO-DET-CLOSURE (paper argument by an AI, unreviewed, on those identities; MOD p tests
  before it): the eightfold Coble rung lies in the closure of l Q + det A + det B, by the explicit degeneration
  [det(t + eA) - det(t + eB)] / e^3. `leads/TENFOLD_COBLE_LEAD.md`, section 16.
- D-EIGHTFOLD-RUNG-TANGENT-CONE (MOD p): at a rung member the first-order Hodge locus (codimension 25) is spanned by
  the node-keeping deformations of two members of the pencil; tangent cone = rung x cone over P^1 x P^1.
- D-TENFOLD-TWO-DETERMINANT-FAMILY (MOD p; a new lead): cubic tenfolds l_1 Q_1 + l_2 Q_2 + det A + det B have
  codimension 52 and a hyperplane section with 72 nodes and one relation; not the Coble family; class not computed.
- D-TENFOLD-TWO-DET-CLASS (EXACT on the Fermat tenfold; MOD p at a random member): the fivefold T5 of the family
  l_1 Q_1 + l_2 Q_2 + det A + det B has T5.T5 = -21; [T5] - 3h^5 is a second difference of four planes there, primitive of
  norm -48 and divisibility 1, and not a two-plane class at the Fermat point. `leads/tenfold_twodet/`.
- D-TENFOLD-TWO-DET-HODGE-LOCUS (paper argument by an AI, unreviewed): the family is a reduced component of codimension
  52 of the Hodge locus of that class, and the class is in the monodromy orbit of [P1] - [P2]. Open: whether it
  meets V_Z with that class. `leads/TENFOLD_TWODET_LEAD.md`.
- N-M2-TOFIELD-IDEAL-QUOTIENT (a caution): Macaulay2 1.22 returned a wrong ideal quotient over
  toField(QQ[w]/(w^2+w+1)); found by the blind checker, reproduced. Do not use such output as exact evidence.
- D-TENFOLD-CONE-POINTS-TWO-DET (paper argument by an AI, conditional on D-W-MINUS1-IS-TWO-DET-CLOSURE): the closure of
  l_1 Q_1 + l_2 Q_2 + det A + det B meets V_Z with the class +-([P1] - [P2]) at cone points over the sixfold divisor D
  (T3's cone map applied twice). Exact: the cone arc on the Fermat tenfold to order 9. `leads/TENFOLD_TWODET_LEAD.md`,
  section 7.
- D-TENFOLD-ORDER4-MODEL-CONE (MOD p): at the tenfold Movasati point a 13-dimensional family of nets of rank 2 passes
  order 4, and order 5 after a change of T_2 (lambda = -1 and 2); a model cone of 27 quadrics.
- C-TENFOLD-ORDER4-RANK2 (correction to O-TENFOLD-CONE-LEAD): "rank 2 and 3 obstructed at order 4, so
  dim W <= dim Cone_T + 11" holds for generic nets only; with the model the bound is codimension 52, not 54.
- D-TENFOLD-COBLE-PLANE-COUNT-EXACT (EXACT over QQ at one named member): the 5-plane meets the 4-plane cycle of the
  Coble family transversally in 8 points and the cycle has degree 12, so its class is not a multiple of h^5.
  Blind-checked with independent exact arithmetic, which also supplied a missing step (the family of planes is
  one-dimensional). `leads/tenfold_coble/plane_test/exact/`, `leads/TENFOLD_COBLE_LEAD.md` section 17.
- D-TENFOLD-MOVASATI-ORDER6 (MOD p, one prime): on the 13-dimensional piece at Movasati's point, order 6 passes for
  lambda = -1 and is obstructed for lambda = 2 modulo the first-order corrections tested.
- D-SIXFOLD-ARC-ORDER19 (EXACT): the sixfold arc of T2 into the divisor D to order 19, unique in its nine-monomial
  slice; the exported certificate's last two terms are not on the continuing arc. `leads/tenfold_twodet/matrices/`.
- D-ARC-SPLITTING-NUMERICAL (floating point, four values of eps): along that arc the transported class splits F_eps
  into two cubics -+(2187/64) l^3 eps^-6 + ...; the first has the 8 vector fields of a determinant and an explicit
  matrix (agreement to 8e-20, its minors in the kernel of the catalecticant); no matrix for the second.
  Blind-checked with independent code (`leads/tenfold_twodet/blind_check12/`), which corrected three statements.
  N-MATRIX-RECOVERY-FIRST-ATTEMPTS: what failed. O-RECOVER-MATRICES-AND-LIMIT-OF-T stays open.
  `leads/TENFOLD_TWODET_LEAD.md` section 8.
- D-MOVASATI-POINT-ARC-ORDER8 (MOD p, two primes): at Movasati's own point, in a direction that is not a cone over a
  sixfold, [P1] - [P2] stays Hodge to order 9 along an arc that is unique in a transversal slice (eightfold; the
  tenfold's own 221 equations hold to order 8 by the cone map); lambda = 2 is obstructed at order 6 in the same
  slices. `leads/movasati_arc/`, `leads/TENFOLD_TWODET_LEAD.md` section 9. Blind-checked.
- D-MOVASATI-POINT-EXACT-SEPARATION (EXACT, one direction): at Movasati's point, -1 passes order 7 and 2 is obstructed
  at order 6 on a direction in general position; on coordinate-aligned directions 2 is not obstructed at order 6 (MOD p).
- D-ALIGNED-POCKET-LAMBDA2 (MOD p): at Movasati's point, lambda = 2 on the symmetric aligned direction passes order 7 in
  the full space; N-SLICE-FALSE-OBSTRUCTION-ORDER7: the slice solver's obstructions from order 7 on are not reliable.
- D-ALIGNED-POCKET-ORDER8 (MOD p, two primes): lambda = 2 on the symmetric aligned direction reaches order 8 in the full
  space, but pays 2 conditions per order from order 7 on, where lambda = -1 pays none.
- N-SECOND-MATRIX-THIRD-ROUTE: the second matrix as a small correction of the first fails (F_eps is 65 per cent outside the
  tangent space of the determinantal cubics at G_A); where everything stalls: leads/tenfold_twodet/matrices/STALL_NOTE.md.
- D-MOVASATI-POINT-COEFFICIENT-SCAN (MOD p, blind-checked in the full space): at Movasati's point only -1 and +1 pass
  order 6 among ten coefficients; they are the two the K3/abelian lattice rule singles out (a match, not a mechanism).
- D-TENFOLD-COBLE-VS-TWO-DET (argument): the two tenfold families cannot share their class at Coble points.
- D-RUNG-NODE-COUNTS-EXACT (EXACT over QQ, one instance each): 14 / 18 and 28 / 36 nodes with one relation.
- O-ALIGNED-POCKET-LAMBDA2-ORDER9 (open; MOD p, two primes): lambda = 2 on the symmetric aligned direction at the eightfold
  Movasati point reaches order 9 with 2 linear conditions per order; not the trace of CT_2. A direction worth
  examining, not a finding. leads/movasati_arc/pocket/.
- M-NODE-SECTION-TOOL: see "Tooling" below.

### Tooling
- `tooling/node_section/` (new, AI-written, unreviewed, not in CI): two Macaulay2 functions that count the nodes of a
  hyperplane section and the relations among them (the "defect"), with seven regression cases (Segre cubic, Coble
  member, Pfaffian / K3, controls). A computed count with a label; not exported from the package.

## [0.1.3] - 2026-11-25

No change to the Macaulay2 package code or to any earlier result. All new mathematical content is AI-generated and
unreviewed; most of it is modulo primes and finite order. Nothing here is a statement about the Hodge conjecture.

### Discoveries registry (133 at v0.1.2 -> 142 entries)
- Candidate explanation of the tenfold lead (O-TENFOLD-CONE-LEAD stays OPEN pending review by a mathematician):
  - D-TENFOLD-COBLE-FAMILY (MOD p; exact over QQ at two points; blind-checked): an explicit codimension-54 family of
    cubic tenfolds whose P^8-section is a Coble cubic (singular along an abelian surface), with boundary the C_18
    family F_T; its first-order Hodge locus equals the family's tangent space, and it leaves F_T in exactly the extra
    direction.
  - D-TENFOLD-PRODUCT-POINTS (paper argument, AI): the structure at product points that produced the family's
    equation.
  - D-TENFOLD-COBLE-CYCLE-CLASS (paper argument, AI; mod p inputs): hyperplane sections through the P^8 have 72 nodes
    with one relation; the 4-plane cycle over a theta curve has self-intersection -144 (a multiple of h^5 would give
    48), so it is not a multiple of h^5.
  - D-TENFOLD-COBLE-ARC-ORDERS (MOD p): orders 2 and 3 of the Hodge condition hold exactly along the explicit arc.
  - D-TENFOLD-PFAFFIAN-K3 (MOD p): on the known coefficient +1 the P^8-section is a Pfaffian cubic singular along a
    K3 surface (56 nodes, one relation); the same self-intersection ladder reproduces known lattice numbers. A
    positive control, not a new family.
- Negative results: N-TENFOLD-CODIM54-SEARCH-2, N-TENFOLD-DIRECT-METHODS, N-TENFOLD-SINGULAR-SECTIONS,
  N-TENFOLD-THIRD-DETERMINANT. They rule out only the cases tested.
- New readable write-up: leads/TENFOLD_COBLE_LEAD.md; handoff leads/TENFOLD_HANDOFF.md; scripts, pre-registrations,
  logs and three blind checkers' reports in leads/tenfold_coble/ and leads/tenfold_session_scripts/.

### Progress page
- "Headline results" section driven by `headlines` in site/status.json, with a schematic interactive figure.
- Interactive research map; the page is rebuilt by CI on every push to main that touches the registry or the site.

## [0.1.2] - 2026-11-25

No change to the Macaulay2 package code or to any earlier result. All new mathematical content is AI-generated and
unreviewed; most of it is modulo primes and finite order.

### Discoveries registry (126 at v0.1.1 -> 133 entries)
- O-TENFOLD-CONE-LEAD (cubic tenfold, two 5-planes meeting in a P^2): OPEN lead, NOT a candidate. Added: cloud runs
  (lambda = -1 generic directions extend, one to order 12 at two primes; lambda = 2 obstructed at order 6); a
  pre-registered symmetry test at Thom-Sebastiani split points (geometric, blind-checked); orders 2 (blind-checked)
  and 3 at points of the C_18 family F_T (unobstructed); prior work on rStation credited.
- New entries since v0.1.1 (7): O-TENFOLD-CONE-LEAD; D-TENFOLD-LAMBDA0-CHECK (lambda_0 = +1 for this configuration);
  N-TENFOLD-CODIM54-SEARCH (six named construction types do not explain the codim-54 branch; first order, mod p);
  N-DELSARTE-UNSOLVED-FAMILIES, N-THOM-SEBASTIANI-SEXTIC-FOURFOLDS, N-SPECIAL-REGIONS-TARGET-FAMILIES (dead ends in the
  search for a candidate in open families); M-FERMAT-SERIES-KERNEL (tooling). One existing entry made its citation
  explicit (O-OTHER-COEFFICIENTS: Steenbrink via Albano-Collino).
- Prior work credited in known_before (10 entries): rStation papers #5 (u/lelong_ridge, 18 Oct 2026; Movasati's
  Conjecture 1 fails for cubic sixfolds and eightfolds) and #11 (17 Oct 2026; Hodge conjecture for Thom-Sebastiani
  cubic tenfolds).
- New readable summary: leads/TENFOLD_CONE_LEAD_DOSSIER.md. New script: examples/checks/tenfold_lambda0.m2.

### Tooling
- tooling/fermat_series: compiled kernel for the Fermat cubic tenfold period expansion, with a test against the
  reference engines (CI job `fermat-series-kernel`). AI-generated, unreviewed tooling; no mathematical claim.

### Added
- Docker image definition (`Dockerfile`, `docker/`): Ubuntu 24.04 with Macaulay2 1.22 (`1.22+ds-6build2`, pinned),
  the package and the MCP server; the default command runs the quickstart and compares it with
  `examples/quickstart.expected`. Not yet built or published by the project (see `docker/README.md`).
- MCP server (`mcp/`, Python, official MCP SDK) with the tools `excess_formula`, `second_order_check`,
  `fermat_expansion` and `registry_search`; timeouts, a memory cap and strict input validation; tests in `mcp/tests/`.
- GitHub Actions: `ci.yml` builds the image and runs the quickstart, the MCP tests, the validation suite, the
  registry check and the site build on every push and pull request; `publish-ghcr.yml` (push to
  `ghcr.io/timseifer/hodgelocici` on a published release) is disabled until the owner enables it.
- README section "Run it in one command"; Docker and MCP in `AGENTS.md`, `llms.txt`, `codemeta.json` (with the DOI as
  `identifier`) and a "Run it" box on the progress page. No change to the Macaulay2 code or to any result.

## [0.1.1] - 2026-11-23

### Fixed
- `secondOrderObstruction`: outside the range with condition (S) false, a vanishing of the quadrics from K was
  reported as `ALL SURVIVE`; the order-2 condition there also involves forms not computed, and at Fermat surfaces of
  degree 7 and 8 the locus is not smooth at order 2 (as Movasati's tables for arXiv:1908.04117 record). The verdict is
  now `NOT DETERMINED`. New test PA-S10.

## [0.1.0] - 2026-11-22

First version. Produced by AI agents under the direction of Timothy Seifert; not yet reviewed by a human.

### Added
- Macaulay2 package `HodgeLociCI` (`M2/HodgeLociCI.m2` with auxiliary files).
- Excess calculator for two complete-intersection cycles in a hypersurface, by degrees and by data, with the
  special coefficient, the level tau and the level dichotomy.
- First-order utilities: Grothendieck residues, tangent codimension of the Hodge locus of a subvariety class.
- Second-order checker for the excess directions, exact over QQ or modulo a prime, with the result labelled.
- Fermat higher-order expansion by pole-order reduction, with verification of arc and obstruction certificates.
- Validation suite (`tests/`) with the source of every expected value (`tests/SOURCES.md`).
- Worked examples (`docs/`).
- Lean certificates (`lean/`) with a statement of what each file does and does not prove.
- For AI agents: `AGENTS.md`, `llms.txt`, `docs/API.md`, `examples/quickstart.m2` with expected output;
  `codemeta.json` for machine-readable metadata.

### Fixed after a blind install check
A second AI agent installed the package from a fresh clone, following only the README, and reported 28 findings
(none blocking). Fixed, with no change to the mathematics:
- Labels. The result tables of the Fermat functions now state the arithmetic and the status ("EXACT over ...;
  COMPUTED ONLY (...)"); the label of `linearSubspaceCase` carries the caveat recorded for Theorem 9.7 in
  `tests/SOURCES.md`; a `NO EXCESS` result of `secondOrderObstruction` no longer claims a second-order computation.
- Documentation of `fermatRing` corrected: it assigns the variables `x_i`, not `z` (use `z = fermatRoot S`).
- README: the Quick start is a transcript again; results of the unreviewed note and of single instances modulo a
  prime carry their status; a marked paragraph says where the outputs are at odds with a published conjecture and
  that this must not be presented as a refutation; how the published numbers were read; where the installation goes
  and how to remove it; all four verdicts of the second-order checker; definitions of `e_tau`, the range and `T`.
- The install-and-check command now has a meaningful exit status (`M2 --silent --stop ... < /dev/null`), and the
  success criterion is stated.
- `docs/API.md` regenerated: every signature lists the options with their defaults, taken from Macaulay2.
- `tests/run_all.sh` exits with status 2 if no test matches the pattern. `lean/run_all.sh` exits with status 2 if
  `lean` or `lake` is missing, and counts a negative test as rejected only if Lean ran and reported an error.
- A `TEST` block for `isSmoothHypersurface` (the package now has 40 tests).
- References to files that are not in the repository rephrased; timings measured again; `tests/README.md` ends
  with the table of the last run.

- Discoveries registry (`discoveries/`): 123 entries on what the project has found, ruled out or left open, with a
  validating script, so that work is not repeated.

- README: related work on one complete-intersection cycle (Kloosterman arXiv:2104.14845, after Dan
  arXiv:1404.7519) and Movasati's 2019 Fermat-surface tables; a known second-order limitation outside the range.

### Known disagreement with a published table
- One entry of a side column (Hodge numbers of cubic 12-folds) differs by 1 from the published table as read by
  machine; see the README section "Validation" and `tests/SOURCES.md`.
