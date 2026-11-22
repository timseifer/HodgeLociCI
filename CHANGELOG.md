# Changelog

All notable changes to this package are recorded here. Format: Keep a Changelog; versions follow semantic versioning.

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

### Known disagreement with a published table
- One entry of a side column (Hodge numbers of cubic 12-folds) differs by 1 from the published table as read by
  machine; see the README section "Validation" and `tests/SOURCES.md`.
