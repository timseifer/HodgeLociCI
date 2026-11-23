# hodgelocici-mcp: an MCP server for HodgeLociCI

A small [Model Context Protocol](https://modelcontextprotocol.io) server that lets an AI assistant call four tools of
the HodgeLociCI Macaulay2 package. It uses the official MCP Python SDK (`mcp` 2.x, class
`mcp.server.mcpserver.MCPServer`) and runs Macaulay2 as a subprocess.

**AI-generated, not reviewed by a human mathematician.** Every tool output carries a status label (EXACT, MOD p,
PROVED in an AI-written unreviewed note, COMPUTED ONLY) and that sentence. Quote the label with any number you
report, and read "What is proved, what is computed" in the repository README before relying on a result.

## Tools

| Tool | Package functions | What it returns |
| --- | --- | --- |
| `excess_formula` | `excessFromDegrees` | from the degrees `(d; own equations of Y1; of Y2; shared equations)`: tau, lambda_0, e_tau, range flag, excess at lambda_0 and for generic lambda (or `NotDetermined` outside the range, with bounds), codimensions of V1, V2, V_Z and of the Hodge locus at lambda_0, the dichotomy verdict |
| `second_order_check` | `cyclePair` / `randomCyclePair`, `secondOrderObstruction` | the verdict NO EXCESS / ALL SURVIVE / ALL DIE / SOME DIE / NOT DETERMINED (version 0.1.1 semantics) with the package's statement and label; explicit polynomial data or a random instance by degrees; over `QQ` or a prime below 32768 |
| `fermat_expansion` | `fermatPeriodPolynomial`, `fermatHodgeTangent`, `fermatExtendArc`, `fermatWriteCertificate`, `fermatVerifyCertificate` | extends an arc at the Fermat point to a given order or to the first obstruction, writes the arc as a certificate file, re-verifies the file and lists the checks |
| `registry_search` | none (pure Python; `discoveries/check_registry.py --json`) | entries of `discoveries/registry.yaml` matching all words of a query, optionally filtered by kind, status and area; id, title, status and status label |

The excess calculator works from the degrees alone, so `excess_formula` builds no explicit instance.

## Install

Needs Python 3.10 or later and Macaulay2 (tested with 1.22; on Ubuntu 24.04 `apt install macaulay2`). From the
repository root:

    python3 -m venv .venv
    .venv/bin/pip install -e "./mcp[test]"   # or simply: pip install -e mcp/
    .venv/bin/python -m pytest mcp/tests -q        # 22 tests, about 20 s
    .venv/bin/python -m hodgelocici_mcp            # the server, on stdin/stdout (MCP stdio transport)

The console script `hodgelocici-mcp` does the same as `python -m hodgelocici_mcp`.

### Configuration (environment variables)

| Variable | Default | Meaning |
| --- | --- | --- |
| `HODGELOCICI_ROOT` | the first ancestor directory of the installed module, or of the working directory, that contains `M2/HodgeLociCI.m2` | the repository root; set it whenever the package is not installed with `-e` from a clone |
| `HODGELOCICI_M2` | `M2` | the Macaulay2 executable (a name on the `PATH` or a path) |
| `HODGELOCICI_TIMEOUT` | `300` | wall-clock limit per call, in seconds (1 to 3600); each tool also takes `timeout_seconds` |
| `HODGELOCICI_MEM_MB` | `4096` | address-space cap of the Macaulay2 process (`RLIMIT_AS`), in MB |
| `HODGELOCICI_OUTPUT_DIR` | `<temp dir>/hodgelocici-mcp` | where `fermat_expansion` writes certificate files |

### Limits and input handling

- Every call runs `M2 --script` on a generated file, with an argument list (no shell), in a fresh temporary
  directory, in its own process group, with the timeout above (the whole group is killed when it expires), the
  memory cap, a CPU-time cap and no core dumps.
- Inputs are validated in Python before anything reaches Macaulay2: integers are range-checked (for example
  `2 <= d <= 60` and at most 20 variables for `excess_formula`; at most 14 variables for `second_order_check`;
  `3 <= d <= 6`, even `n <= 8`, order at most 12 for `fermat_expansion`); primes must be below 32768 (the range of
  Macaulay2's F4 engine) and, for the Fermat tool, congruent to 1 modulo 2d; coefficients are integers or strings
  `a/b`; polynomials must consist only of integers, `x_i` (index checked against the ring), `z` (Fermat tool only),
  `+ - * / ^ ( )` and spaces, with balanced parentheses, explicit `*` for products and at most 20000 characters each.
  Such a string cannot name any Macaulay2 function.
- Errors come back as MCP tool errors with a readable message: `InputError` for invalid input, `ComputationError`
  for a Macaulay2 error (for example "the hypersurface X = {F = 0} is singular"), a timeout or the memory cap.

## Docker

The image built from the repository's `Dockerfile` (see `docker/README.md`) contains Macaulay2, the package and this
server, with `HODGELOCICI_ROOT` set:

    docker build -t hodgelocici .
    docker run --rm -i hodgelocici python -m hodgelocici_mcp

`-i` is required (the protocol runs over stdin/stdout); do not use `-t`.

## Client configuration

Replace `/path/to/HodgeLociCI` with the path of your clone (and `.venv` with your virtual environment).

### Claude Desktop (`claude_desktop_config.json`)

Local install:

```json
{
  "mcpServers": {
    "hodgelocici": {
      "command": "/path/to/HodgeLociCI/.venv/bin/python",
      "args": ["-m", "hodgelocici_mcp"],
      "env": {
        "HODGELOCICI_ROOT": "/path/to/HodgeLociCI",
        "HODGELOCICI_M2": "M2"
      }
    }
  }
}
```

Docker:

```json
{
  "mcpServers": {
    "hodgelocici": {
      "command": "docker",
      "args": ["run", "-i", "--rm", "hodgelocici", "python", "-m", "hodgelocici_mcp"]
    }
  }
}
```

If Claude Desktop cannot find `M2` (it may start with a short `PATH`), set `HODGELOCICI_M2` to the full path, for
example `/usr/bin/M2`.

### Claude Code

    claude mcp add hodgelocici --env HODGELOCICI_ROOT=/path/to/HodgeLociCI -- /path/to/HodgeLociCI/.venv/bin/python -m hodgelocici_mcp

or, with the image:

    claude mcp add hodgelocici -- docker run -i --rm hodgelocici python -m hodgelocici_mcp

Add `--scope project` to store the server in `.mcp.json` at the project root, to share it with collaborators. The
same as a file (`.mcp.json`):

```json
{
  "mcpServers": {
    "hodgelocici": {
      "command": "docker",
      "args": ["run", "-i", "--rm", "hodgelocici", "python", "-m", "hodgelocici_mcp"],
      "env": {}
    }
  }
}
```

(These snippets follow the documented formats of the two clients but were not tried with them when this file was
written; the server itself was exercised over stdio by the official SDK's client, `mcp/tests/test_mcp_protocol.py`.)

## Example calls

Outputs below are copied from real runs (Macaulay2 1.22, `mcp` 2.3.0); long fields are shortened with `...`.

**`excess_formula`**: two 3-planes meeting in a point on a cubic sixfold.

```json
{"degree": 3, "own_degrees_y1": [1, 1, 1], "own_degrees_y2": [1, 1, 1], "shared_degrees": [1]}
```

```json
{
  "tool": "excess_formula",
  "status_label": "EXACT (integer arithmetic on the degrees); its reading as the excess of a Hodge locus is PROVED in an AI-written, unreviewed note (paper 3, Theorem 2)",
  "package_label": "PROVED in paper 3 (AI-written, unreviewed), Theorem 2; integer arithmetic on the degrees only",
  "computed_with": "excessFromDegrees (by degrees alone; no explicit instance is built)",
  "tau": 0,
  "lambda0": 1,
  "in_range": true,
  "e_tau": 1,
  "excess_at_lambda0": 1,
  "excess_generic_lambda": 1,
  "excess_generic_lambda_bounds": [1, 1],
  "codim_V1": 4,
  "codim_V2": 4,
  "codim_VZ": 8,
  "codim_NL_at_lambda0": 7,
  "dichotomy": "tau >= 0: NL(delta_lambda0) is smooth of codimension codim V_Z - e_tau, with e_tau excess tangent directions (Theorem 2(4))",
  "verdict": "tau >= 0: excess e_tau = 1 at lambda_0 = 1; elsewhere 1 (in the range)",
  "disclaimer": "AI-generated, not reviewed by a human mathematician."
}
```

The 7 and the 8 are, in the literature, the codimension of the *tangent space* of the Hodge locus at the Fermat point
and of the locus of cubics containing both planes (Movasati); that 7 is the codimension of the Hodge locus at
lambda_0 is Theorem 2(4) of the unreviewed note.

**`second_order_check`**, random instance (the quickstart's), `lam` = 2:

```json
{"lam": 2, "mode": "random", "degree": 3, "own_degrees_y1": [1, 1, 1], "own_degrees_y2": [1, 1, 1],
 "shared_degrees": [1], "seed": 7, "field": 32003}
```

```json
{
  "tool": "second_order_check",
  "status_label": "MOD p (over ZZ/32003 at this one instance: evidence, not a proof); the second-order formulas are PROVED in an AI-written, unreviewed note (paper 3)",
  "package_label": "second-order term: residues MOD p (computed over ZZ/32003 at one instance: evidence, not a proof); formulas: PROVED in paper 3 (AI-written, unreviewed), Theorem 9.1(3), Theorem 9.4(2), Proposition 9.4'",
  "hypersurface_F": "-13755*x_0^3-863*x_0^2*x_1-...",
  "degree": 3,
  "verdict": "ALL DIE",
  "statement": "the quadrics N -> Q_0(N,N)(Q), Q in K, have no common zero in P(E'): every excess direction is obstructed at second order; the reduction of NL(delta_lambda) is V_Z and NL(delta_lambda) is non-reduced along V_Z near X (PROVED in paper 3 (AI-written, unreviewed), Theorem 9.1(4))",
  "lambda0": 1, "tau": 0, "in_range": true, "condition_S": true, "e_tau": 1, "excess": 1, "dim_K": 1,
  "disclaimer": "AI-generated, not reviewed by a human mathematician."
}
```

With `"lam": 1` the verdict is `ALL SURVIVE`. Explicit data, for example instance R1 of test PA-S10 (Fermat surface
of degree 7 modulo 31991; the polynomials are in `mcp/tests/test_second_order_check.py`), give `NOT DETERMINED` at
`lam` = 2 (outside the range, condition (S) false) and `ALL SURVIVE` at `lam` = 1:

```json
{"lam": 2, "mode": "explicit", "field": 31991, "nvars": 4,
 "f": ["x_0-7598*x_1"], "h": ["x_0^3-284*x_0^2*x_1-7883*x_0*x_1^2-7598*x_1^3"], "p": ["x_2-7598*x_3"],
 "M": [["x_0^3+7882*x_0^2*x_1-7150*x_0*x_1^2+2168*x_1^3"]],
 "s": ["x_2^6+7598*x_2^5*x_3-14151*x_2^4*x_3^2+2453*x_2^3*x_3^3-12859*x_2^2*x_3^4-2168*x_2*x_3^5+2901*x_3^6"]}
```

**`fermat_expansion`**: cubic sixfold, class `[P1] + 2 [P2]`, the first-order term of the shipped certificate
`cert_n6_lam2.txt`.

```json
{"degree": 3, "dimension": 6, "order": 6, "prime": 0, "coefficients": [1, 2],
 "spaces": [[[0,1,1],[2,3,1],[4,5,1],[6,7,1]], [[0,1,3],[2,3,3],[4,5,3],[6,7,1]]],
 "t1": "x_0*x_1*x_7 + (1/3+(1/3)*z)*x_0*x_2*x_4 + x_0*x_2*x_5 + x_2*x_3*x_7 + x_4*x_5*x_7"}
```

```json
{
  "tool": "fermat_expansion",
  "status_label": "EXACT over QQ(zeta_6); COMPUTED ONLY (no proof claimed: assumes the period formula for linear spaces and Griffiths' pole-order description of the Hodge locus)",
  "field": "QQ(zeta_6) (EXACT)",
  "T1": "((1/3)*z+1/3)*x_0*x_2*x_4+x_0*x_2*x_5+x_0*x_1*x_7+x_2*x_3*x_7+x_4*x_5*x_7",
  "order_reached": 4,
  "obstructed_at_order": 5,
  "obstruction": "matrix {{6*z-3}}",
  "summary": "the arc was extended to order 4; it is obstructed at order 5 (obstruction K.c_5 = matrix {{6*z-3}})",
  "certificate_file": "/tmp/hodgelocici-mcp/fermat_d3_n6_exact_84c4bf6b5e37.txt",
  "certificate_contents": "the arc T_1..T_4 and the claim that the expansion vanishes to that order (claim 1); an obstruction, if any, is reported here but not written to the file",
  "certificate_verified": true,
  "certificate_vanishing_order": 4,
  "certificate_checks": [
    "the listed forms Q are the standard forms (as a set) => true",
    "the coefficients of eps^1..eps^4 vanish for all 8 forms => true",
    "T_1 is in the kernel of the first-order map L (tangent to the Hodge locus) => true",
    "T_1 is not in the kernel of L_P1 (not tangent to the locus where the first space persists) => true"
  ],
  "caveat": "an obstruction found here is an obstruction for the particular arc constructed (deterministic particular solutions at each order), not for every arc with the same first term; 'an arc exists to order N' says nothing about the Hodge locus beyond order N",
  "disclaimer": "AI-generated, not reviewed by a human mathematician."
}
```

`"t1": "auto"` takes the first basis element of the tangent space of the Hodge locus that is not tangent to the locus
where the first space persists.

**`registry_search`**:

```json
{"query": "level dichotomy", "limit": 2}
```

```json
{
  "tool": "registry_search",
  "matches": 2,
  "entries": [
    {"id": "D-LEVEL-DICHOTOMY", "kind": "result", "area": "first_order",
     "title": "Level dichotomy: tau < 0 gives no excess for any nonzero coefficient, at every smooth X",
     "status": "PROVED_AI_UNREVIEWED", "status_label": "PROVED (AI-written, unreviewed)",
     "statement_excerpt": "In the setting of D-FIRST-ORDER-RULE: if tau < 0, then NL([Y_1] + lambda [Y_2]) = V_Z for every lambda != 0, ..."},
    {"id": "D-MOVASATI-TABLES-REPRODUCED", "kind": "result", "area": "first_order",
     "title": "Movasati's (H, K) tables at the Fermat cubic reproduced exactly for dimensions 4, 6, 8",
     "status": "EXACT", "status_label": "EXACT", "statement_excerpt": "..."}
  ],
  "disclaimer": "AI-generated, not reviewed by a human mathematician."
}
```

## Tests

`mcp/tests/` (pytest): one file per tool with values from the package's own tests (quickstart, `SecondOrderTests.m2`
test PA-S10, `FermatDoc.m2` / test F7, the registry), input-validation cases, the limits (timeout and memory cap,
with a stand-in for `M2`), and the MCP protocol both in-process and over stdio. Tests that need Macaulay2 are skipped
when `M2` is not on the `PATH`. CI runs them inside the Docker image (`.github/workflows/ci.yml`).
