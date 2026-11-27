# HodgeLociCI

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.24455334.svg)](https://doi.org/10.5281/zenodo.24455334)

A Macaulay2 package for **Hodge loci** (higher-dimensional Noether–Lefschetz loci) of classes
`r[Y1] + s[Y2]`, where `Y1`, `Y2` are **linear or complete-intersection cycles** of half dimension in a smooth
hypersurface `X = {F = 0}` of even dimension in projective space.

Author: Timothy Seifert. Licence: MIT. Version 0.1.3 (25 November 2026). Version 0.1.1 is archived on Zenodo:
[doi:10.5281/zenodo.24455334](https://doi.org/10.5281/zenodo.24455334).
AI agents: start with [`AGENTS.md`](AGENTS.md) and [`docs/API.md`](docs/API.md); a smoke test with parseable output
is `M2 --script examples/quickstart.m2`, run from the repository root.

> **Status: AI-generated, not yet reviewed by a human.** The code, the tests, the documentation and the
> mathematical notes this package implements were produced by AI agents (Anthropic's Claude) under the direction of
> Timothy Seifert, in November 2026. Other AI agents checked them; no mathematician has. Treat every output as a
> computation to be verified, and read the section "What is proved, what is computed" before relying on a result.
> Nothing here is, or bears on, a proof or disproof of the Hodge conjecture.

## Top results so far, in brief

Short versions of the headline items of the [progress page](https://timseifer.github.io/HodgeLociCI/). They come
from the discovery work around the package (`leads/`, `discoveries/`), are AI-generated and unreviewed, and carry
the status label of their registry entries. None is a statement for or against the Hodge conjecture.

- **A 1917 cubic and a hidden Hodge locus on cubic tenfolds** (25 Nov 2026; key numbers EXACT over QQ at one named
  member since 26 Nov, other runs MOD p; a proposed explanation awaiting review). For Movasati's pair of 5-planes on cubic tenfolds the class with
  coefficient -1 appears to stay a Hodge class on a locus one dimension larger than the known families explain. The
  proposed explanation is an explicit family of codimension 54: tenfolds whose `P^8`-section is a Coble cubic, the
  cubic sevenfold singular along an abelian surface (Coble, 1917). Each member carries an algebraic fivefold that is
  expected to carry the class. Write-up: [`leads/TENFOLD_COBLE_LEAD.md`](leads/TENFOLD_COBLE_LEAD.md); registry
  `D-TENFOLD-COBLE-FAMILY`, `D-TENFOLD-COBLE-EXACT-MEMBER`, `D-TENFOLD-COBLE-PLANE-COUNT-EXACT`.
- **Why the special coefficients are +1 and -1: K3 and abelian surfaces** (26 Nov 2026; a short argument by an AI,
  most numbers MOD p). For two planes meeting in codimension 3 on cubic hypersurfaces only the coefficients +1 and
  -1 gain extra room. Proposed reason: the nodes of a hyperplane section carry one relation exactly when the
  surface they lie on has trivial canonical class, and the discriminant of the class is then twice the number of
  nodes: 14 for a K3 surface (the +1 class), 18 for an abelian surface (the -1 class). Registry
  `D-TENFOLD-K3-ABELIAN-PAIRING`, `D-NODES-DISCRIMINANT-IDENTITY`.

- **Two determinants on cubic tenfolds: a second explicit family for Movasati's class** (26 Nov 2026; a paper
  argument by an AI, conditional on an earlier unreviewed argument; finite-order evidence MOD p). The tenfolds
  `l1 Q1 + l2 Q2 + det A + det B` form a family of codimension 52 whose members carry an algebraic fivefold with
  the lattice invariants of `[P1] - [P2]`. By a cone construction it reaches the two-plane locus, conditionally
  with Movasati's class; at Movasati's point a 13-dimensional cone of directions passes order 4, which changes the
  recorded bound from 54 to 52, and along one kind of direction in it the class stays Hodge to order 9 (MOD p)
  for the coefficient -1 while the coefficient 2 is obstructed at order 6 (exact on one direction in general position). Write-up: [`leads/TENFOLD_TWODET_LEAD.md`](leads/TENFOLD_TWODET_LEAD.md); registry
  `D-TENFOLD-CONE-POINTS-TWO-DET`, `D-TENFOLD-ORDER4-MODEL-CONE`, `D-TENFOLD-TWO-DET-CLASS`.

What is not established is listed in each entry (`not_established`). The package's own main output, which is at
odds with a published conjecture and needs expert review, is described under "What is proved, what is computed".

## Run it in one command

With Docker (the image contains Macaulay2 1.22, the package and the MCP server; see
[`docker/README.md`](docker/README.md)):

    docker build -t hodgelocici .
    docker run --rm hodgelocici                     # runs examples/quickstart.m2 and compares with the expected output
    docker run --rm hodgelocici tests/run_all.sh    # the validation suite

As an MCP server for AI assistants (tools `excess_formula`, `second_order_check`, `fermat_expansion`,
`registry_search`; every output carries its status label; see [`mcp/README.md`](mcp/README.md) for Claude Desktop
and Claude Code configuration):

    pip install -e mcp/ && python -m hodgelocici_mcp              # needs M2 on the PATH
    docker run --rm -i hodgelocici python -m hodgelocici_mcp      # or inside the image

## What it does

Setting: `X` has degree `d` in `P^(2k+1)`; `Y1 = V(f, p)` and `Y2 = V(h, p)` are complete intersections of dimension
`k` in `X` with `c` own equations each (`f`, `h`) and `k + 1 - c` shared equations (`p`), so that
`F = f^T M h + sum p_l s_l` for a `c x c` matrix `M` of forms. `V_Z` is the locus of hypersurfaces in which both
cycles persist. The **excess** of a coefficient `lambda` is `dim T NL([Y1] + lambda [Y2]) - dim T V_Z`, where `T`
is the Zariski tangent space at `X`: the number of tangent directions of the Hodge locus beyond those in which both
cycles deform.

1. **Excess calculator** (`excessFromDegrees`, `excessFromData`, `tangentExcess`, `verifyExcess`,
   `linearSubspaceCase`). From the degrees alone: the integer `tau = d - deg det M` (the "level"), the dichotomy
   `tau < 0` (no excess for any `lambda != 0`) against `tau >= 0`, the special coefficient
   `lambda_0 = (-1)^(c-1)`, the Hilbert-function value `e_tau` (defined under "Terminology"), the codimensions of the
   loci, and the excess at `lambda_0` and elsewhere where the degrees determine it. From explicit or random data: the
   same numbers computed, plus an independent first-order computation in the Jacobian ring to compare with.
2. **Second-order checker** (`secondOrderObstruction`, `secondOrderQuadrics`, `secondOrderFunctional`). For given data
   and `lambda`, computes the second-order obstruction on the excess directions and reports one of five verdicts:
   `NO EXCESS` (there are no excess directions, so nothing is computed at second order), `ALL SURVIVE`, `ALL DIE`,
   `SOME DIE` (the partial verdict), or `NOT DETERMINED` (outside the range when condition (S) fails and the computed
   part vanishes). When they all die the Hodge locus is non-reduced along `V_Z` by
   Theorem 9.1(4) of the unreviewed note, under its condition (S), which always holds in the range; otherwise only
   "not smooth" is asserted. A verdict at one instance modulo a prime is evidence, not a proof.
3. **Fermat higher-order expansion** (`fermatExpansion`, `fermatNextOrderSystem`, `fermatExtendArc`,
   `fermatVerifyArc`, `fermatVerifyCertificate`, and the other `fermat*` functions). At the Fermat hypersurface,
   Taylor coefficients of the Hodge-locus equations along an arc, by pole-order (Griffiths–Dwork) reduction; the
   linear system for the next term; obstructions with dual certificates; reading, writing and re-verifying
   certificate files.

First-order utilities used by all three: Grothendieck residues (`grothendieckResidue`, `residueFunctional`), period
polynomials of complete-intersection cycles (`periodPolynomial`), the tangent codimension of the Hodge locus of the
class of any half-dimensional subvariety from its ideal (`hodgeLocusTangentCodim`), primitive Hodge numbers and the
Hodge level of a hypersurface (`primitiveHodgeNumbers`, `hodgeLevel`).

## What is proved, what is computed

Every result table (a `HashTable`) carries a `label` string saying which of these applies; a label can combine
the arithmetic and the status, for example `EXACT over QQ(zeta_6); COMPUTED ONLY (...)` in the Fermat part.
Functions that return a bare number, list, Boolean or matrix (for example `hodgeLevel`, `primitiveHodgeNumbers`,
`ciHilbertFunction`, `isSmoothHypersurface`, `grothendieckResidue`, `fermatExpansion`, `fermatHodgeTangent`) carry
no label; their status is stated in their help node.

| Kind | Meaning in this package |
| --- | --- |
| EXACT | Computed in exact arithmetic over `QQ` or a cyclotomic field. Exact for the given input; says nothing about other inputs. |
| MOD p | Computed over `ZZ/p` at one (often random) instance. Evidence, not a proof, for the corresponding statement in characteristic 0. |
| PROVED (AI-written, unreviewed) | The formula being evaluated is a theorem of the project's third note ("paper 3"), which was written by AI agents and has not been reviewed by a human. The note is in `papers/` (not part of the Macaulay2 package itself). |
| COMPUTED ONLY | No proof is claimed, in the notes or elsewhere; the function reports what a computation gives. |

**Where to read "paper 3".** The three AI-written notes cited as "paper 1", "paper 2" and "paper 3" are in
`papers/` (PDF and LaTeX source, unchanged as frozen on 21-22 November 2026; read `papers/README.md` first: they are
unreviewed, and later corrections and prior work are recorded there and in `discoveries/`). Their statements are also
paraphrased inside the package: in the help nodes "the setting of paper 3", `excessFromDegrees`,
`linearSubspaceCase` and `secondOrderObstruction`, and in `tests/SOURCES.md`, part E. Theorem numbers in the labels
refer to `papers/paper3.tex` (version 21).

In particular: the degree-level calculator is integer arithmetic on the degrees, and its *interpretation* as the
excess of a Hodge locus rests on Theorem 2 of that note. `tangentExcess` and `hodgeLocusTangentCodim` do not use
that theorem; they use the classical description of the tangent space of a Hodge locus in the Jacobian ring
(Carlson–Griffiths, Macaulay duality) and are the independent side of every comparison. The second-order formulas
are theorems of the same unreviewed note. The Fermat expansions use Griffiths' pole-order calculus and the known
periods of linear cycles on Fermat varieties; a result "an arc exists to order N" is exact for the listed terms and
is not a statement about the true Hodge locus beyond that order.

> **At odds with a published conjecture: this needs expert review.** For two linear spaces meeting in dimension
> `n/2 - 3` on cubic hypersurfaces of dimension `n = 6` and `n = 8` (two 3-planes meeting in a point on a cubic
> sixfold, as in the Quick start below; two 4-planes meeting in a line on a cubic eightfold), the outputs of this
> package say that for `lambda` different from `lambda_0` the excess directions die at second order, so that the
> Hodge locus would be `V_Z` with a non-reduced structure there. The outputs in question are:
> `linearSubspaceCase(3,3,3)` and `linearSubspaceCase(3,4,3)`, which quote the note; `secondOrderObstruction` at
> random cubic sixfolds modulo a prime (for cubic eightfolds that computation was not run); and the Fermat
> certificates in `tests/data/fermat/`. This is AT ODDS with the dimension statement of Movasati's Conjecture 1
> ([arXiv:2211.11405](https://arxiv.org/abs/2211.11405)), which, as that paper was read by machine, gives the Hodge
> locus the dimension `dim V_Z + 1` for all nonzero integer coefficients (at `lambda_0` the package says the same).
> The package's side rests on an unreviewed AI-written note and on AI computations (modulo a prime at random
> instances; exact at the Fermat point, but conditional on the assumptions named there). It must not be presented
> as a refutation of the conjecture: the note, the computations or the machine reading of the conjecture may be
> wrong. Of everything in this package, this is what most needs review by an expert. The same statement, with the
> same caveats, is in `docs/04_fermat_certificate.md` and in `tests/SOURCES.md` (entries A3 and E8).

## Requirements and installation

Macaulay2 (developed and tested with version 1.22 only). No other dependency. Macaulay2 is available from
<https://macaulay2.com/Downloads/>; on Debian and Ubuntu the package `macaulay2` provides it.

From the root of this repository, in Macaulay2:

    installPackage("HodgeLociCI", FileName => "M2/HodgeLociCI.m2")
    check "HodgeLociCI"

or, without installing:

    needsPackage("HodgeLociCI", FileName => "M2/HodgeLociCI.m2")

`installPackage` runs every documentation example; `check` runs the package's tests (40 of them). On a 2-core
machine the two commands together take about 2.5 minutes (no errors or warnings in the release run).
`installPackage` writes to the user's Macaulay2 directory (`~/.Macaulay2/local/` on Linux, about 1.6 MB), not into
the repository; `uninstallPackage "HodgeLociCI"` removes it again.

The same two steps as one shell command with a meaningful exit status, from the repository root:

    M2 --silent --stop -e 'installPackage("HodgeLociCI", FileName => "M2/HodgeLociCI.m2"); check "HodgeLociCI"; exit 0' < /dev/null

Success means all three of: exit status 0; 40 lines containing `check(` in the output, one per test (39 read
`capturing check`, and one reads `running check`, because that test writes a temporary file and Macaulay2 runs it in
a separate process); no line containing `error`. With `--stop` Macaulay2 exits with a non-zero status at the first
error; without it Macaulay2 enters its debugger instead and the command can end with status 0 although a test
failed.

After installation, in a new session, load the package first and then ask for help:

    needsPackage "HodgeLociCI"
    help excessFromDegrees

Without the `needsPackage` line, `help excessFromDegrees` only reports that the name is a symbol.
`viewHelp "HodgeLociCI"` opens the HTML pages in a browser (the pages are installed; the viewer was not tried in the
release check, which had no browser).

The validation suite is separate and is run from a shell:

    cd tests && ./run_all.sh

It needs only `M2` on the `PATH`, loads the package from `M2/` without installing it, prints a PASS/FAIL table
(15 tests, about 4.5 minutes on 2 cores; `./run_all.sh --slow` adds two long tests, about 3 minutes more) and exits
with status 0 only if every test passes.

## Quick start

Two 3-planes meeting in a point on a cubic sixfold (`c = 3` own linear equations each, one shared), and two 4-planes
meeting in a line on a cubic eightfold. The lines below are copied from a real session with Macaulay2 1.22, started
in the repository root (`M2 --silent --no-readline --print-width 118`): inputs, prompt numbers and values are
unchanged; the blank lines and the type lines that Macaulay2 prints (`o3 : Sequence`, `o15 : Matrix ...`,
`o18 : Ideal of S`) are removed. The tuples are `(tau, lambda_0, e_tau, codim V_Z, codim NL at lambda_0, ...)`.

    i1 : needsPackage("HodgeLociCI", FileName => "M2/HodgeLociCI.m2");
    i2 : r = excessFromDegrees(3, {1,1,1}, {1,1,1}, {1});
    i3 : (r#"tau", r#"lambda0", r#"eTau", r#"codimVZ", r#"codimNLAtLambda0", r#"excessElsewhere", r#"inRange")
    o3 = (0, 1, 1, 8, 7, 1, true)
    i4 : r8 = excessFromDegrees(3, {1,1,1}, {1,1,1}, {1,1});
    i5 : (r8#"tau", r8#"lambda0", r8#"eTau", r8#"codimVZ", r8#"codimNLAtLambda0")
    o5 = (0, 1, 1, 20, 19)

So the locus where both planes persist has codimension 8 (resp. 20), and the calculator reports codimension 7
(resp. 19) for the Hodge locus of `[Y1] + [Y2]`. That last statement is Theorem 2(4) of the unreviewed note, not an
established result: in the literature 7 and 19 are codimensions of the *tangent space* of the Hodge locus at the
Fermat point, for every nonzero coefficient, and 8 and 20 are the codimensions of the locus of cubics containing
both linear spaces (Movasati, arXiv:1602.06607, Table 1, as read by machine), and the
dimension of the Hodge locus itself is the subject of a conjecture of Movasati (arXiv:2211.11405). Result tables use
string keys; `peek r` shows all of them, including `label` and `notes`.

The level dichotomy, on the other side (two 4-planes meeting in a point on a cubic eightfold):

    i6 : t = excessFromDegrees(3, {1,1,1,1}, {1,1,1,1}, {1});
    i7 : (t#"tau", t#"codimVZ", t#"excessAtLambda0", t#"excessElsewhere")
    o7 = (-1, 20, 0, 0)
    i8 : t#"levelDichotomy"
    o8 = tau < 0: no excess; NL(delta_lambda) = V_Z for every lambda != 0 (Theorem 2(3))

Checking the theorem against an independent computation at a random point, then the second-order check:

    i9 : Y = randomCyclePair(3, {1,1,1}, {1,1,1}, {1}, Seed => 7);
    i10 : (verifyExcess Y)#"agrees"
    o10 = true
    i11 : (secondOrderObstruction(Y, 2))#"verdict"
    o11 = ALL DIE
    i12 : (secondOrderObstruction(Y, 1))#"verdict"
    o12 = ALL SURVIVE

At `lambda = 2` the one excess direction is obstructed at second order; at the special coefficient `lambda_0 = 1` it
survives. Both verdicts are computed at this one random instance modulo 32003 (evidence, not a proof). The result
of `secondOrderObstruction` also has the keys `statement` and `label`.

The first-order utility on a subvariety that is not a complete intersection: a cubic sixfold that is a sum of two
`3 x 3` determinants contains a threefold of degree 9, and the Hodge locus of its class has tangent codimension 8
at this one random instance modulo 32003 (evidence, not a proof), provided the primitive class is nonzero.

    i13 : setRandomSeed 11;
    i14 : S = ZZ/32003[x_0..x_7];
    i15 : A = random(S^3, S^{3:-1});
    i16 : B = random(S^3, S^{3:-1});
    i17 : F = det A + det B;
    i18 : I = minors(2, A^{0,1}) + minors(2, B^{0,1});
    i19 : h = hodgeLocusTangentCodim(F, I);
    i20 : (h#"codim", h#"codimIJ", h#"hypothesis")
    o20 = (8, 1, true)

More worked examples, each a captured session: `docs/`.

## How this differs from existing software

This list comes from a short search in November 2026; pages were read by machine only. "None found" means none
found in that search.

- **Movasati's Singular libraries `foliation.lib` / `brho.lib`** compute Taylor expansions of periods at the Fermat
  point and were used for the published computer-assisted results on Hodge loci of linear cycles
  ([arXiv:2211.11405](https://arxiv.org/abs/2211.11405) prints one such program;
  [arXiv:1602.06607](https://arxiv.org/abs/1602.06607)). **The Fermat part of this package overlaps with them in
  purpose.** What differs: it is in Macaulay2, works exactly over a cyclotomic field or modulo a prime, and writes
  and re-verifies small certificate files (an arc, or an obstruction with its dual functional) that a third party
  can check without rerunning the search. It has been exercised only on the cases listed in `tests/`.
- **PeriodSuite** (E. C. Sertöz, Magma and SageMath, <https://github.com/emresertoz/PeriodSuite>) computes numerical
  periods of a given smooth hypersurface and lattices of Hodge classes from them. This package computes no numerical
  periods.
- **SpecialFanoFourfolds** (G. Staglianò, Macaulay2, JSAG 14 (2024)) constructs Hodge-special cubic and
  Gushel–Mukai fourfolds and locates them in Noether–Lefschetz divisors. This package does not construct special
  fourfolds; `hodgeLocusTangentCodim` is a first-order tool only.
- **One complete-intersection cycle is known.** For a single complete intersection `Y = V(f)` of half dimension in a
  smooth hypersurface `F = sum f_i g_i` of degree `d`, the Hodge locus of `[Y]` is smooth and is the locus of
  hypersurfaces containing such a complete intersection, of codimension `dim (S/(f, g))_d`: R. Kloosterman,
  [arXiv:2104.14845](https://arxiv.org/abs/2104.14845) (Theorems 1.1 and 4.14, Propositions 3.2 and 4.13, as read by
  machine), after A. Dan ([arXiv:1404.7519](https://arxiv.org/abs/1404.7519)). `codimV1` and `codimV2` of this package
  are that number, and his Lemma 4.3 (exchange one equation for its cofactor) is one step of the residual argument of
  the unreviewed note. Not found there: two cycles, the coefficient `lambda`, the level `tau`, the excess. No software
  from that paper was found.
- **Movasati's code and tables for Fermat surfaces** (`movasati/NoetherLefschetz` on GitHub, Singular, for
  [arXiv:1908.04117](https://arxiv.org/abs/1908.04117); no licence, so not reused). In a one-off cross-check by an
  agent (not part of the test suite; this package's side MOD p), its 1758 stored records in this package's setting
  agree with this package on all first-order numbers, and its lists of coefficients show the special coefficient
  `lambda_0`. Outside the range there is one unresolved difference at second order, listed under Limitations.
- For the first-order and second-order tools at **arbitrary smooth points** (not only Fermat), with shared equations
  and complete intersections of any degrees, no existing package was found. The underlying first-order theory is in
  papers of Villaflor Loyola ([arXiv:1812.03964](https://arxiv.org/abs/1812.03964)) and Kloosterman
  ([arXiv:2312.12363](https://arxiv.org/abs/2312.12363)); no software from those papers was found.

## Validation

`tests/SOURCES.md` lists every source: Movasati's tables, Kloosterman's theorems, Villaflor Loyola's first-order
statements, Maclean's quintic example, and the project's own results, with the statement, the reference, and how
the statement was read. Each test in `tests/validation/` starts with a comment block giving its source, what is
computed, the label (EXACT or MOD p), and where the expected value comes from.

**How the published numbers were read.** Through a web-fetch tool that downloads a page and returns a small language
model's answers to questions about it. Nobody, neither a human nor the AI agent that wrote the tests, saw the raw
text of the PDFs. Tables were asked for at least twice, in separate fetches. A human should confirm every entry
against the paper before citing it; `tests/SOURCES.md` says this at its top. A passing test therefore means "the
package reproduces the number as the machine read it", nothing more.

State at version 0.1.1: all 15 tests pass (301 checks), and so do the two slow tests. Covered: Movasati's tables
for cubic hypersurfaces of dimension 4, 6 and 8 exactly at the Fermat point (including the pairs 7 against 8 and 19
against 20: 7 and 19 are the codimensions of the tangent space of the Hodge locus at the Fermat point, valid for
every nonzero coefficient; 8 and 20 are the codimensions of the locus of cubics containing both linear spaces), and
further rows by degrees; Kloosterman's Proposition 3.10 and Theorems 1.2 and 1.3 in the cases listed; first-order
statements of Villaflor Loyola and Movasati–Villaflor Loyola; Maclean's quintic example with two coplanar lines;
the project's own tables and the exported Fermat certificates.

Two caveats. Maclean's journal article could not be opened; that entry rests on his thesis and a secondary source
and is marked so. And one **recorded disagreement**, left unadjusted on both sides: in the table of Hodge numbers
of cubic hypersurfaces in Movasati's arXiv:1902.00831 (Table 5) and arXiv:2211.11405 (Table 1), the middle entry of
the row for dimension 12 reads 3432 as read by machine, while the rows for dimensions 4 to 10 include the class of
the linear section (21, 71, 253, 925) and the package gives 3432 + 1 = 3433 by the same rule. This concerns a side
column only, not any codimension; it may be a slip in the table or in the machine reading. The test prints it as a
`DISAGREE` line in every run.

## Discoveries registry

A readable live view of the registry and of current work is published at
<https://timseifer.github.io/HodgeLociCI/> (built by `site/build_site.py` from `discoveries/registry.yaml` and
`site/status.json`; it needs GitHub Pages to be enabled for the `gh-pages` branch).


`discoveries/` records what the project behind this package has already found, ruled out or left open, so that
nobody (person or agent) repeats the work: 174 entries in `discoveries/registry.yaml`, with readable pages by area
(`discoveries/01_...md` to `08_...md`). Each entry gives the precise statement, its status, what it is conditional
on, what was computed, which independent AI check confirmed it, what is *not* established, what was known before,
and how to re-verify it inside this repository (or says that it cannot be). Negative results and dead ends are
recorded with the same care as results. It is not a list of established theorems: everything in it is AI-produced
and unreviewed, and no entry claims novelty. Start with `discoveries/README.md`.

## Repository layout

    README.md, LICENSE, CITATION.cff, codemeta.json, CHANGELOG.md
    AGENTS.md, llms.txt          instructions and an index for AI agents
    M2/HodgeLociCI.m2            the package (loads the files in M2/HodgeLociCI/)
    M2/HodgeLociCI/              code, documentation and tests, one group of files per part; data/ has certificates
    tests/README.md              the validation suite: how to run it, what each test covers, the last run
    tests/SOURCES.md             the source of every expected value, and how it was read
    tests/run_all.sh             the runner
    tests/validation/, slow/     the tests (15 fast, 2 slow)
    tests/expected/              the expected RESULT lines of every test
    tests/data/                  the certificate files of the Fermat part, with their READMEs and checksums
    docs/README.md               index of the worked examples
    docs/01_...md to 05_...md    worked examples (captured sessions)
    docs/API.md                  one line per exported name, with options and defaults
    docs/build_docs.py           rebuilds the worked examples from docs/prose/ and docs/sessions/
    docs/sessions/               input and captured output of every session
    docs/prose/                  the text around the sessions
    examples/                    quickstart script with expected output
    site/                        generator and current-activity file for the progress page
    Dockerfile, docker/          the Docker image (Macaulay2 1.22 + package + MCP server) and its README
    mcp/                         MCP server (Python, official MCP SDK) wrapping four tools; tests in mcp/tests/
    .github/workflows/           CI (builds the image, runs quickstart and tests); a GHCR publish workflow, disabled
    discoveries/                 registry of results, dead ends and open problems; check_registry.py validates it
    lean/                        Lean certificates, with a README saying what each does and does not prove

## Terminology

- *Hodge locus* `NL(delta)`: the locus, near `X`, of hypersurfaces on which the class `delta` stays a Hodge class;
  for surfaces this is a component of the Noether–Lefschetz locus.
- *Level* `tau = d - deg det M`. Not to be confused with the *Hodge level* of the cohomology of `X`, which is
  `hodgeLevel(n, d)`.
- `e_tau`: the dimension `dim A_tau` of the degree-`tau` part of the ring `A = S/(f, h, p, s)`, where `S` is the
  polynomial ring and `s` are the forms in `F = f^T M h + sum p_l s_l`; it is zero if `tau < 0`. Key `eTau`.
- *The range*: the inequality `(k-1)d + tau < 2k + 2`, under which the degree-level statements are sharpest (in the
  range the excess is `e_tau` for every nonzero `lambda`, by Theorem 2(2) of the unreviewed note); `inRange` in the
  output.
- `T`: the Zariski tangent space at `X`, a subspace of the space `S_d` of forms of degree `d`. So `dim T NL` is the
  dimension of the tangent space of the Hodge locus, which can be larger than the dimension of the locus itself.
- *Excess directions*: tangent directions of `NL(delta_lambda)` not tangent to `V_Z`.

## Limitations

- Tested with Macaulay2 1.22 on Linux only.
- Random instances are over `ZZ/p` by default; over `QQ` the functions work but can be slow, and `reduceModPrime`
  is the explicit way to trade EXACT for MOD p.
- The second-order checker treats the excess directions of two complete-intersection cycles as in the note; it is
  not a general second-order calculus for arbitrary classes. Its two strategies ("Formula" and "Pointwise") agree in
  every instance tried, but both rest on the same lemma of the note, so their agreement checks the algebra and not
  the periods. The package has no second-order route that is independent of that lemma.
- Not implemented from the note: the residual cycle and the explicit family at the special coefficient.
- Outside the range with condition (S) false, the second-order checker does not compute all order-2 conditions and
  returns `NOT DETERMINED` when the part it computes vanishes. (Version 0.1.0 said `ALL SURVIVE` there, which was
  wrong: at Fermat surfaces of degree 7 and 8 the locus is not smooth at order 2, as Movasati's tables for
  arXiv:1908.04117 record.)
- `linearSubspaceCase` returns the value for a general hypersurface; at a special point use `excessFromData`.
- `hodgeLocusTangentCodim` assumes that the primitive class of the subvariety is nonzero and reports, but does not
  prove, the one-dimensionality it relies on (key `"hypothesis"`).
- The Fermat functions handle linear spaces of the standard type `x_a = zeta x_b`; the feasible order depends
  strongly on the sparsity of the arc: sparse arcs reach order 9 exactly in seconds, dense ones are practical only
  modulo a prime (timings in the documentation node "Fermat higher-order expansion"). Tested for cubic sixfolds and
  eightfolds, quartic sixfolds and two small cases. Everything in this part is COMPUTED ONLY.
- `fermatVerifyCertificate` re-verifies the numbers in a certificate, not the arguments drawn from them, and an
  obstruction found by `fermatExtendArc` is for the particular arc it built, not for every arc with the same
  first term.
- No function decides whether a Hodge class is algebraic.

## Citing and licence

See `CITATION.cff`. Licence: MIT (`LICENSE`). Repository: <https://github.com/timseifer/HodgeLociCI>.
