# AGENTS.md

Instructions for AI agents (and people) who want to **use** this package from a script or **change** this
repository. Human-oriented overview: `README.md`. Function index: `docs/API.md`.

## What this is

`HodgeLociCI` is a Macaulay2 package about Hodge loci (Noether–Lefschetz loci) of classes `r[Y1] + s[Y2]` of two
linear or complete-intersection cycles in a smooth hypersurface of even dimension. Three tools: a first-order
"excess" calculator, a second-order obstruction check, and higher-order expansions at the Fermat point.

Status you must carry into anything you write with it: **AI-generated, not reviewed by a human**. Every result
table has a `"label"` entry (EXACT / MOD p / PROVED in an AI-written, unreviewed note / COMPUTED ONLY; a label can
combine the arithmetic and the status). Quote the label with the number. Functions that return a bare number, list,
Boolean or matrix have no label: take their status from their help node. Never present an output as a proved
theorem, and never as evidence for or against the Hodge conjecture. For two linear spaces meeting in dimension
`n/2 - 3` on cubic sixfolds and eightfolds the outputs are at odds with a published conjecture (README, section
"What is proved, what is computed"): never present them as a refutation.

## Before you start new work: the discoveries registry

`discoveries/` records what this project has already found, ruled out or left open: 144 entries (results, negative
results, dead ends, corrections, open problems), each with its status, conditions, evidence, what is NOT
established, what was known before, and how to re-verify it inside this repository.

- **Search it first**: `python3 discoveries/check_registry.py --list` prints one line per entry; the full text is in
  `discoveries/registry.yaml` (also `--json`) and, by area, in `discoveries/01_...md` to `08_...md`.
- **Do not repeat a dead end**: read `do_not_repeat` in the entries of `discoveries/06_ruled_out_and_dead_ends.md`
  that touch your method.
- **If you redo something, cite the entry id** and say what you changed (another prime, exact arithmetic, another
  point, another method).
- **When you finish, add an entry** with the same fields to `registry.yaml`, then run
  `python3 discoveries/check_registry.py --write-pages` and `python3 discoveries/check_registry.py` (must print
  `RESULT: OK`). Never raise a status without the computation or proof that justifies it; a statement is exactly as
  strong as its `status`.

## Setup

- Requires Macaulay2. Tested with version 1.22 only (`M2 --version`). On Debian or Ubuntu the package `macaulay2`
  provides it; otherwise see <https://macaulay2.com/Downloads/>.
- No other dependency. Nothing to build.

## Commands

Run from the repository root.

| Task | Command | Time (2 cores) |
| --- | --- | --- |
| Smoke test with parseable output | `M2 --script examples/quickstart.m2` | about 2 s |
| Use without installing | in M2: `needsPackage("HodgeLociCI", FileName => "M2/HodgeLociCI.m2")` | about 1 s |
| Install and run the package tests | `M2 --silent --stop -e 'installPackage("HodgeLociCI", FileName => "M2/HodgeLociCI.m2"); check "HodgeLociCI"; exit 0' < /dev/null` | about 2.5 min |
| Validation suite against published numbers | `tests/run_all.sh` | about 4.5 min |
| The two slow validation tests | `tests/run_all.sh --slow slow` | about 3 min |
| One validation test | `tests/run_all.sh 02_kloosterman` (any substring of the file name; `kloosterman` alone runs three tests) | seconds |
| Validate the discoveries registry | `python3 discoveries/check_registry.py` (Python 3, standard library only) | 1 s |
| Everything in Docker (no local Macaulay2 needed) | `docker build -t hodgelocici . && docker run --rm hodgelocici` (quickstart check; `docker run --rm hodgelocici tests/run_all.sh` for the suite) | build: minutes; run: seconds |
| MCP server tests | `pip install -e "./mcp[test]" && python -m pytest mcp/tests -q` | about 20 s |

How to tell success:

- Install and check: exit status 0, AND 40 lines containing `check(` in the output (one per test: 39 read
  `capturing check`, one reads `running check`), AND no line containing `error`. `--stop` makes Macaulay2 exit with
  a non-zero status at the first error; without it Macaulay2 enters its debugger and the exit status says nothing.
  `installPackage` writes to `~/.Macaulay2/local/`; `uninstallPackage "HodgeLociCI"` removes it.
- `examples/quickstart.m2` prints lines of the form `RESULT <name> <value>`; `examples/quickstart.expected` holds the
  expected lines (19 of them), so `M2 --script examples/quickstart.m2 | diff - examples/quickstart.expected` must
  print nothing.
- `tests/run_all.sh` prints a PASS/FAIL table and exits 0 only if everything passes; it exits 2 if Macaulay2 is not
  found or if no test matches the pattern.

## Docker and the MCP server

- `Dockerfile` (root) builds an image with Macaulay2 1.22 (Ubuntu 24.04 package, pinned), the package at
  `/opt/HodgeLociCI` and the MCP server; the default command is `docker/quickstart-check.sh` (quickstart compared
  with `examples/quickstart.expected`). Details and test commands: `docker/README.md`.
- `mcp/` is an MCP server (official MCP Python SDK) with four tools: `excess_formula` (by degrees),
  `second_order_check` (explicit polynomial data or a random instance; verdicts as in 0.1.1), `fermat_expansion`
  (arc, certificate file, re-verification) and `registry_search` (pure Python). Every output carries a
  `status_label` and the line "AI-generated, not reviewed by a human mathematician."; keep both when you quote a
  result. Configuration and example outputs: `mcp/README.md`. If you change an exported function used by a tool,
  run `python -m pytest mcp/tests -q` as well.
- CI (`.github/workflows/ci.yml`) builds the image and runs the quickstart, the MCP tests, `tests/run_all.sh`, the
  registry check and the site build. `.github/workflows/publish-ghcr.yml` would push the image to GHCR on a
  release but is disabled (`if: false`); do not enable it, push images or publish anything without the owner.

## How to call it from a script

    needsPackage("HodgeLociCI", FileName => "M2/HodgeLociCI.m2");
    r = excessFromDegrees(3, {1,1,1}, {1,1,1}, {1});   -- d; degrees of own equations of Y1, of Y2; shared equations
    print("RESULT tau " | toString r#"tau");            -- result tables are HashTables with STRING keys
    print("RESULT label " | r#"label");

Things that trip agents up:

- **String keys.** `r#"tau"`, not `r.tau`. For a result table, `peek r` or `sort keys r` shows what is there. For a
  `CyclePair` (`Y = randomCyclePair(...)`), print the object or use `peek Y`; `sort keys Y` fails there, because one
  of its keys is not a string.
- **Input by degrees**: `(d, degF, degH, degP)` with `#degF = #degH = c` and `#degF + #degP = k + 1`, where the
  hypersurface has degree `d` in `P^(2k+1)`. All degrees are at least 1 and less than `d`.
- **Input by data**: `cyclePair(f, h, p, M, s)` takes ONE sequence of five arguments (lists `f`, `h`, `p`, `s` and a
  `c x c` matrix `M`) with `F = f^T M h + sum p_l s_l`. `randomCyclePair(d, degF, degH, degP, Seed => 7)` makes a
  random instance over `ZZ/32003`; use `CoefficientRing => QQ` for exact data.
- **`NotDetermined`** is returned where the input does not determine a number. It is not an error and not zero.
- **EXACT versus MOD p** is never switched silently. `reduceModPrime(D, p)` is the explicit way to go from `QQ` to
  `ZZ/p`. A MOD p result at one random instance is evidence, not a proof.
- `fermatRing(d, n)` puts its ring in use and assigns the variables `x_i`, like `QQ[x]` does. It does NOT assign
  `z`: get the root of unity with `z = fermatRoot S` (over `ZZ/p`, that is with `fermatRing(d, n, p)`, it is a
  number, not a variable).
- **Large cases.** `tangentExcess` and `verifyExcess` have the option `Strategy => "Jacobian"` (the default) or
  `"Residue"`. Use `Strategy => "Residue"` for large cases: `tests/README.md` records that the Jacobian strategy did
  not finish in 15 minutes for `(d,k,c) = (3,5,3)`. All options and their defaults are in `docs/API.md`.
- Macaulay2's fast Gröbner engine is used only for primes below 32768; larger primes are much slower.
- Documentation of any function: after `installPackage`, in a new session, first `needsPackage "HodgeLociCI"` and
  then `help excessFromDegrees` (without the first line `help` only says that the name is a symbol); or read
  `M2/HodgeLociCI/*Doc.m2` directly (plain text, one `doc ///` block per function). Note that `M2 --script` implies
  `-q` and does not see packages installed in the home directory: in a script, load the package with
  `FileName => "M2/HodgeLociCI.m2"` as above.

## Which function for which question

| Question | Function |
| --- | --- |
| Does the Hodge locus of `[Y1] + lambda [Y2]` have more tangent directions than the locus where both cycles persist? For which `lambda`? | `excessFromDegrees`, then `excessFromData` / `verifyExcess` at a point |
| Two linear subspaces meeting in dimension `k - c` on a degree-`d` hypersurface | `linearSubspaceCase(d, k, c)` |
| Do those extra directions survive at second order? | `secondOrderObstruction(D, lambda)` |
| Tangent codimension of the Hodge locus of the class of any half-dimensional subvariety with ideal `I` in `{F = 0}` | `hodgeLocusTangentCodim(F, I)` |
| Residue of a form with respect to a regular sequence | `grothendieckResidue`, `residueFunctional` |
| At the Fermat hypersurface: is there an arc in the Hodge locus to order `N` with given first terms? | `fermatExtendArc`, `fermatNextOrderSystem` |
| Re-verify an arc or obstruction certificate file | `fermatVerifyCertificate(file)` |
| Hodge numbers and Hodge level of a hypersurface | `primitiveHodgeNumbers(n, d)`, `hodgeLevel(n, d)` |

Full list with signatures: `docs/API.md`. Worked sessions with real output: `docs/01_...md` to `docs/05_...md`.

## Repository map

    M2/HodgeLociCI.m2                 package entry point (newPackage, loads the files below)
    M2/HodgeLociCI/Excess*.m2         first-order tools: code, documentation, tests
    M2/HodgeLociCI/SecondOrder*.m2    second-order checker: code, documentation, tests
    M2/HodgeLociCI/Fermat*.m2         Fermat expansion: code, documentation, tests
    M2/HodgeLociCI/ValidationTests.m2 short versions of the validation tests, run by `check`
    M2/HodgeLociCI/data/              certificate files used by tests and examples
    tests/                            validation suite; SOURCES.md gives the source of every expected value
    docs/                             worked examples and API.md
    examples/                         quickstart script with expected output
    discoveries/                      registry of what has been found, ruled out or left open (read before new work)
    lean/                             Lean certificates (independent of the Macaulay2 code)
    Dockerfile, docker/               Docker image and its README
    mcp/                              MCP server (Python) and its tests

## If you change this repository

- Every exported function needs a `doc ///` node with a runnable Example and at least one `TEST ///` block; if it
  returns a table, the table needs a `"label"`. Tests must be deterministic (fixed seeds) and fast (under about a
  minute each).
- Run the install-and-check command and `tests/run_all.sh` before committing. Do not edit `tests/expected/` to make a
  test pass; if an expected value is wrong, say why in the commit message and in `tests/SOURCES.md`.
- A test that compares with a published number must name the source (paper, theorem or table, URL) and say whether
  the statement was read in the source. Do not fill in "published" numbers from memory.
- Keep the status notice in `README.md` and the labels. Do not strengthen a label (for example MOD p to EXACT, or
  COMPUTED ONLY to PROVED) without the computation or the proof that justifies it.
- The mathematical notes cited as "paper 3" are AI-written, unreviewed, not public and not in this repository
  (their statements are paraphrased in the help nodes and in `tests/SOURCES.md`, part E). Do not describe their
  theorems as established results.
- New findings, negative results and dead ends go into `discoveries/registry.yaml` (see the section above), with
  the same care about status as the labels.
- Author and copyright holder: Timothy Seifert (see `CITATION.cff`, `LICENSE`). Keep that attribution.
