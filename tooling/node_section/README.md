# tooling/node_section: nodes of a hyperplane section and the relations among them (Macaulay2)

**Status: [TOOLING], AI-generated (Claude Fable 5.2, 26 Nov 2026), not reviewed by a human.** It packages the
computation behind sections 10-12 of `leads/TENFOLD_COBLE_LEAD.md` (the "node mechanism") as two functions. It is
not part of the package `HodgeLociCI` and is not exported from it.

## What it computes

For a hypersurface `X = {F = 0}` of even dimension and a hyperplane `{L = 0}`, or directly for a hypersurface
`Y = {G = 0}` of odd dimension `n - 1` and degree `d` in `P^n`:

* the dimension of the singular locus, and if it is finite the length of the Jacobian scheme;
* whether every singular point is an ordinary double point (the Jacobian scheme is reduced);
* the number of conditions the singular points impose on forms of degree `e = n d / 2 - n - 1`, and the
  **defect** = (number of singular points) - (number of conditions).

```
load "tooling/node_section/NodeSection.m2"        -- from the repository root
kk = ZZ/32003; S = kk[x_0..x_5];
r = nodalSectionReport(sum(6, i -> x_i^3), sum(6, i -> x_i));    -- the Segre cubic threefold
r#"singularPoints", r#"allOrdinaryDoublePoints", r#"conditions", r#"defect", r#"label"
--  (10, true, 5, 5, MOD p (p = 32003), this instance)
```

`nodalDefect G` takes the odd-dimensional hypersurface itself. The result is a `HashTable` with string keys
(`"singularLocusDim"`, `"singularPoints"`, `"allOrdinaryDoublePoints"`, `"formDegree"`, `"conditions"`, `"defect"`,
`"hilbertFunctionOfNodes"`, `"label"`, `"note"`); the header of `NodeSection.m2` describes each.

## What the number means, and what it does not

* LIT (recalled and machine-read in part, not re-read in full): for a nodal hypersurface `Y` of odd dimension the
  defect equals `b_n(Y) - 1`, the number of independent extra classes in its middle homology (Dimca, Duke Math. J.
  60 (1990); stated as Theorem 2.5 in Kloosterman, arXiv:1612.06726).
* That such a class gives a non-zero Hodge class on a smooth `X` having `Y` as a hyperplane section rests on an
  argument written by an AI that no mathematician has read (`leads/TENFOLD_COBLE_LEAD.md`, 10.3).
* So the output is a **computed count**. It is not a proved statement about Hodge classes, it says nothing about
  whether a class is algebraic, and nothing about the Hodge conjecture. Quote the `"label"` with the number.
* MOD p output is about the reduction mod p of the form you gave. The tool makes no specialization argument; a
  count mod p is evidence about characteristic 0, not a proof (see `leads/tenfold_coble/exact_member/` for how
  one case was made exact).
* If `"allOrdinaryDoublePoints"` is not `true`, Dimca's formula does not apply and `"defect"` is only a number.

## Method

Random linear change of coordinates; Groebner basis of the Jacobian ideal in the graded reverse lexicographic
order, with Macaulay2's F4 engine when the characteristic is a prime below 32768 (about 5 s for a section of a
cubic tenfold, where the default engine needed about 3 minutes in an earlier run) and the default engine otherwise (over
QQ: fine up to about 9 variables). In generic coordinates the initial ideal of the saturation by the last
variable is the saturation of the initial ideal (Bayer-Stillman), so the Hilbert function of the points is read
off a monomial ideal. Reducedness: on the affine chart, the multiplication matrix of a random linear form has a
squarefree characteristic polynomial.

## Tests

    cd tooling/node_section && M2 --script test_node_section.m2 | diff - test_node_section.expected

Exit status 0, a last line `ALL PASS` and an empty diff mean success (15 s). Not in CI.

| case | expected | source of the expected value |
|---|---|---|
| Segre cubic threefold (Fermat fourfold cut by `sum x_i = 0`), mod p and over QQ | 10 nodes, 5 conditions on linear forms, defect 5 | classical (LIT, recalled) |
| general hyperplane section of a random cubic tenfold | smooth | - |
| cubic threefold with one A_2 point | length 2, not all ordinary double points | by construction |
| the named member of `leads/tenfold_coble/exact_member/`, cut by `w_2 = 0` | 72 nodes, 71 conditions on quartics, defect 1 | registry D-TENFOLD-COBLE-EXACT-MEMBER (exact, blind-checked) |
| tenfold with a Pfaffian P^8-section, cut by `t_3 = 0` | 56 nodes, 55 conditions, defect 1 | registry D-TENFOLD-PFAFFIAN-K3 (mod p, blind-checked) |
| the same without the higher terms in `t` | a singular line: "not finite" | by construction |

## Limits

`n` must be even. One random instance of the coordinate change per call (retried if a singular point lies on the
last coordinate hyperplane). No ladder of self-intersections (section 10.4 of the lead note) and no local classes
at the nodes: those are arguments, not computations, and are not in the tool.
