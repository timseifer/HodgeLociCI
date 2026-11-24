# Changelog

All notable changes to this package are recorded here. Format: Keep a Changelog; versions follow semantic versioning.

## [Unreleased]

- discoveries: O-TENFOLD-CONE-LEAD updated with the 24 Nov cloud runs (MOD p; lead still OPEN, not a candidate);
  new leads/TENFOLD_CONE_LEAD_DOSSIER.md (readable summary of that entry).
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
