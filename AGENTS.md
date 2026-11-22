# AGENTS.md

Instructions for AI agents (and people) who want to **use** this package from a script or **change** this
repository. Human-oriented overview: `README.md`. Function index: `docs/API.md`.

## What this is

`HodgeLociCI` is a Macaulay2 package about Hodge loci (Noether–Lefschetz loci) of classes `r[Y1] + s[Y2]` of two
linear or complete-intersection cycles in a smooth hypersurface of even dimension. Three tools: a first-order
"excess" calculator, a second-order obstruction check, and higher-order expansions at the Fermat point.

Status you must carry into anything you write with it: **AI-generated, not reviewed by a human**. Every result
table has a `"label"` entry (EXACT / MOD p / PROVED in an AI-written, unreviewed note / COMPUTED ONLY). Quote the
label with the number. Never present an output as a proved theorem, and never as evidence for or against the Hodge
conjecture.

## Setup

- Requires Macaulay2. Tested with version 1.22 only (`M2 --version`). On Debian or Ubuntu the package `macaulay2`
  provides it; otherwise see <https://macaulay2.com/Downloads/>.
- No other dependency. Nothing to build.

## Commands

Run from the repository root.

| Task | Command | Time (2 cores) |
| --- | --- | --- |
| Smoke test with parseable output | `M2 --script examples/quickstart.m2` | about 10 s |
| Use without installing | in M2: `needsPackage("HodgeLociCI", FileName => "M2/HodgeLociCI.m2")` | 2 s |
| Install and run the package tests | `M2 --silent -e 'installPackage("HodgeLociCI", FileName => "M2/HodgeLociCI.m2"); check "HodgeLociCI"; exit 0'` | about 3 min |
| Validation suite against published numbers | `tests/run_all.sh` (add `--slow` for two long tests) | about 4 min |
| One validation test | `tests/run_all.sh kloosterman` (any substring of the file name) | seconds |

`examples/quickstart.m2` prints lines of the form `RESULT <name> <value>`; `examples/quickstart.expected` holds the
expected lines. `tests/run_all.sh` prints a PASS/FAIL table and exits 0 only if everything passes.

## How to call it from a script

    needsPackage("HodgeLociCI", FileName => "M2/HodgeLociCI.m2");
    r = excessFromDegrees(3, {1,1,1}, {1,1,1}, {1});   -- d; degrees of own equations of Y1, of Y2; shared equations
    print("RESULT tau " | toString r#"tau");            -- result tables are HashTables with STRING keys
    print("RESULT label " | r#"label");

Things that trip agents up:

- **String keys.** `r#"tau"`, not `r.tau`. `peek r` or `sort keys r` shows what is there.
- **Input by degrees**: `(d, degF, degH, degP)` with `#degF = #degH = c` and `#degF + #degP = k + 1`, where the
  hypersurface has degree `d` in `P^(2k+1)`. All degrees are at least 1 and less than `d`.
- **Input by data**: `cyclePair(f, h, p, M, s)` takes ONE sequence of five arguments (lists `f`, `h`, `p`, `s` and a
  `c x c` matrix `M`) with `F = f^T M h + sum p_l s_l`. `randomCyclePair(d, degF, degH, degP, Seed => 7)` makes a
  random instance over `ZZ/32003`; use `CoefficientRing => QQ` for exact data.
- **`NotDetermined`** is returned where the input does not determine a number. It is not an error and not zero.
- **EXACT versus MOD p** is never switched silently. `reduceModPrime(D, p)` is the explicit way to go from `QQ` to
  `ZZ/p`. A MOD p result at one random instance is evidence, not a proof.
- `fermatRing(d, n)` puts its ring in use and assigns the variables `x_i` and `z`, like `QQ[x]` does.
- Macaulay2's fast Gröbner engine is used only for primes below 32768; larger primes are much slower.
- Documentation of any function: after `installPackage`, `help excessFromDegrees`; or read
  `M2/HodgeLociCI/*Doc.m2` directly (plain text, one `doc ///` block per function).

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
    lean/                             Lean certificates (independent of the Macaulay2 code)

## If you change this repository

- Every exported function needs a `doc ///` node with a runnable Example, at least one `TEST ///` block, and a
  `"label"` in its result. Tests must be deterministic (fixed seeds) and fast (under about a minute each).
- Run the install-and-check command and `tests/run_all.sh` before committing. Do not edit `tests/expected/` to make a
  test pass; if an expected value is wrong, say why in the commit message and in `tests/SOURCES.md`.
- A test that compares with a published number must name the source (paper, theorem or table, URL) and say whether
  the statement was read in the source. Do not fill in "published" numbers from memory.
- Keep the status notice in `README.md` and the labels. Do not strengthen a label (for example MOD p to EXACT, or
  COMPUTED ONLY to PROVED) without the computation or the proof that justifies it.
- The mathematical notes cited as "paper 3" are AI-written, unreviewed and not in this repository. Do not describe
  their theorems as established results.
- Author and copyright holder: Timothy Seifert (see `CITATION.cff`, `LICENSE`). Keep that attribution.
