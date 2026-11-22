# Discoveries registry

What this project has already found, ruled out or left open, so that a future agent or person does not repeat the
work. It organises existing results only. It contains no new mathematics.

> **Read this first.** Everything in this folder was produced by AI agents (Anthropic's Claude) and checked only by
> other AI agents. No human has reviewed it. Published papers were read by machine only (see `tests/SOURCES.md`).
> The three notes cited as "unreviewed note 1, 2, 3" are AI-written, not public and not in this repository.
> Nothing here is, or bears on, a proof or disproof of the Hodge conjecture. **This is not a list of established
> theorems.** Where an entry is at odds with a published conjecture, it is a conditional, AI-computed statement
> and must not be presented as a refutation.

## Files

| file | what it is |
|---|---|
| `registry.yaml` | The machine-readable list: one entry per result, negative result, dead end, correction or open problem. **The single source of truth.** |
| `check_registry.py` | Validates the registry and generates the pages below from it (Python 3, standard library only). |
| `NOTATION.md` | The setting and every symbol used in the statements. |
| `01_first_order.md` | The first-order rule (tau, lambda_0, excess), codimensions, the list for linear subspaces. |
| `02_second_order.md` | The second-order law and its exceptions. |
| `03_movasati_conjecture_and_fermat.md` | Certificates at the Movasati points, the germ, the pair X1, the rank invariant. |
| `04_explicit_cycles_on_cubics.md` | det A + det B, l*Q + Pfaffian, the eightfold family, the Segre fourfold, the degeneration. |
| `05_fake_linear_cycles.md` | Quartic sixfolds: the class, Sigma_4, explained loci, killed candidates, the polynomial w. |
| `06_ruled_out_and_dead_ends.md` | What failed, and why. Read before trying something similar. |
| `07_open_problems.md` | Open questions, each with one next step. |
| `08_corrections_and_lessons.md` | Errors caught by checks; methods worth reusing. |

Pages 01 to 08 are generated. Do not edit them by hand.

## How an agent should use it

1. **Search `registry.yaml` for your question before starting.** Search by object ("Segre", "pencil", "X1",
   "Pfaffian", "catalecticant"), by coefficient ("lambda = 2") or by id prefix. `python3
   discoveries/check_registry.py --list` prints one line per entry; `--json` prints the whole registry as JSON.
2. **If you redo something, cite the entry** (its `id`) and say what you changed: another prime, exact arithmetic,
   another point, another method.
3. **Read `not_established` and `conditions` before you rely on an entry.** A statement is exactly as strong as its
   `status`.
4. **Read `do_not_repeat` in the negative and dead-end entries** of your area before you choose a method.
5. **When you finish new work, add an entry with the same fields**, then run
   `python3 discoveries/check_registry.py --write-pages` and commit the registry together with the pages.
6. **Never raise a status without the computation or the proof that justifies it.** MOD_P becomes EXACT only by an
   exact computation; COMPUTED_ONLY or PAPER_ARGUMENT_AI never becomes "proved" by repetition. If you find an
   error, do not delete the entry: add a `correction` entry and adjust the old one.
7. Do not claim novelty. At most: "not found in the sources we read (machine-read, see tests/SOURCES.md); not
   checked further".

## Entry fields

All fields are required unless marked optional.

| field | content |
|---|---|
| `id` | Stable short id. Prefix `D-` result, `M-` method (a result of area `methods`), `N-` negative result or dead end, `O-` open problem, `C-` correction. |
| `kind` | `result`, `negative`, `dead_end`, `correction` or `open`. |
| `area` | `first_order`, `second_order`, `fermat_expansion`, `movasati_conjecture`, `explicit_cycles`, `fake_linear_cycles` or `methods`. |
| `title` | One line, plain language. |
| `statement` | The precise statement, self-contained (symbols: `NOTATION.md`). |
| `data` (optional) | Explicit data an outside reader needs: coordinates, formulas, tables, constants. |
| `status` | One word from the vocabulary below. |
| `conditions` | What the statement depends on; "none" if nothing. |
| `evidence` | What was actually computed or argued, by whom, with primes, orders, numbers of instances. |
| `independent_check` | Which blind check confirmed it (C-number) and what that check did NOT cover; "none" if none. |
| `not_established` | What a reader might wrongly infer and is not shown. |
| `known_before` | Relation to the literature as recorded in `tests/SOURCES.md`, or "n/a". |
| `reproduce` | How to re-verify inside this repository: a test file, a Macaulay2 snippet that runs, a certificate file; or the literal string "not reproducible from this repository" with one line on what would be needed. |
| `do_not_repeat` (optional) | For negatives and dead ends: exactly what was tried and why it failed. |
| `next_step` (optional) | For open items: the single most useful next computation or argument. |
| `session_refs` | Where the details are in the session files (ledger entry headers, file names). Those files are not public. |

## Status vocabulary

| status | meaning |
|---|---|
| `EXACT` | Computed in exact arithmetic (over Q, a cyclotomic field, or integers). Exact for the given input; says nothing about other inputs, and nothing about the conditions it rests on. |
| `MOD_P` | Computed modulo one or a few primes, usually at random instances. Evidence, not a proof, for the statement in characteristic 0. |
| `PROVED_AI_UNREVIEWED` | A theorem of one of the AI-written, unreviewed notes, read by AI referees only. Not an established result. |
| `COMPUTED_ONLY` | A record of what a computation or a procedure gives; no proof is claimed anywhere. |
| `PAPER_ARGUMENT_AI` | Argued on paper by an AI agent in the session ledger, usually on computed inputs, read at most once by another AI agent. Weaker than the previous class of written notes. |
| `CONJECTURE` | A statement the evidence supports, with known gaps. |
| `RULED_OUT` | Tested and found false, or a method shown not to work. |
| `OPEN` | Not decided; little or nothing attempted. |
| `STUCK` | Attempted and blocked, for the reason stated. |

Rules enforced by the checker: a `negative` or `dead_end` has status `RULED_OUT` or `STUCK`; an `open` item has
`OPEN`, `STUCK` or `CONJECTURE`; a `result` or `correction` has one of the other statuses. For a `correction` the
status is that of the statement which replaced the wrong one.

An entry can combine a statement with supporting parts of another strength. Then the status is that of the
statement as a whole, never that of its strongest part, and the fields `conditions` and `evidence` say which part
is which.

## Reproduce pointers

Paths are relative to the repository root, and commands are meant to be run from there with Macaulay2 1.22.

- A snippet (indented code) loads the package with `needsPackage("HodgeLociCI", FileName => "M2/HodgeLociCI.m2")`.
  Save it to a file outside the repository and run `M2 --script FILE` from the repository root.
- `tests/run_all.sh NAME` runs one validation test. To run a test file directly, give an absolute path:
  `M2 --script "$PWD/tests/validation/NAME.m2"`. With a relative path the test does not find its helper file.
- `lean/run_all.sh core` needs Lean 4.36.0.
- "not reproducible from this repository" means that the computation used session scripts that are not in the
  package. The entry says what would be needed. `O-PACKAGE-FEATURES-NEEDED` collects these.

Every snippet and every test pointer in the registry was run once when the registry was written (22 November
2026). The repository was being edited by other agents at the same time, so a pointer can go stale: the checker
verifies only that the paths exist, not that the outputs still agree.

## Validation

    python3 discoveries/check_registry.py

checks: the file parses; ids are unique and well formed; required fields are present; `kind`, `area`, `status`
are in the vocabularies and compatible; every repository path mentioned in a `reproduce` field exists; every
entry id mentioned in another entry exists; each entry appears on exactly one page; the pages are up to date. It
prints a table by kind and status and exits with a non-zero status on any violation.

The registry is stored in a small subset of YAML (described at the top of `registry.yaml`); the checker has its
own reader and needs no YAML library. A standard YAML parser reads the file too.

## Where the entries come from

In order of authority: the end-of-round report and the ledger of the "discovery round" (teams T1, T2, T3 and
blind checks C1 to C21, 22 November 2026); the ledger, checks and three notes of the earlier "night run"; the
published literature as recorded in `tests/SOURCES.md`; the package itself. Where two sources disagree, the entry
records both. Where a detail could not be determined, the entry says "not determined from the sources".

The session's ledgers record no established human review of any of this. Every entry keeps its AI-only status
until a review by a named person, of a named version, is on record.
