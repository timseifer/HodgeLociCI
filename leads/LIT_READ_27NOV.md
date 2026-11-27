# Literature read of 27 Nov 2026 (web access approved by the owner, ~15:50 UTC)

Claude Opus 5.5. AI-written, unreviewed. Label LIT throughout, with one caveat that applies to every line: the
pages were read through a fetch tool that returns a small model's answer about the page, not the page text. Every
statement below is therefore "machine-read", the same standard as tests/SOURCES.md, and should be re-read against
the PDF by a person before it is cited in a paper.

Sources:
- [Mo3] H. Movasati, Leaf schemes and Hodge loci, arXiv:2502.19988v2 (HTML version of 14 Dec 2025).
- [Kl1] R. Kloosterman, On a conjecture on Hodge loci of linear combinations of linear subvarieties,
  arXiv:2312.12363 (HTML v1; the current version is v2, PDF only: not read).
- [PRRS] B. Piroddi, A. D. Rios Ortiz, A. Rojas, J. Song, Coble type hypersurfaces and hyperkaehler fourfolds,
  arXiv:2606.10884v1 (abstract page only).

## 1. Citation check for paper 1 and the sign dictionary (plan item A2, last part)

| cited as | what the source says (machine-read) | verdict |
|---|---|---|
| [Mo3, Prop. 5.6], tangent spaces at the Fermat point computed by Villaflor Loyola | Prop. 5.6 sits in §5.10, "Conjecture 5.1 for tangent spaces (by R. Villaflor)", and states dim T_0 V_[Z] = dim T_0 V_Z + 1 | CONSISTENT (number and attribution) |
| [Mo3] (Dec 2025) still states the conjecture for sixfolds and eightfolds | Conjecture 5.1: d = 3, n = 6, 8, m = n/2 - 3, all r and nonzero r-check: dim V_[Z] = dim V_Z + 1, and the Hodge conjecture for delta_t on V_[Z]; §5.2 adds that it is false for n >= 10, see §5.9 | CONSISTENT |
| §5.2 | title "The path to Conjecture 5.1": scheme structure on V_[Z] via periods; Prop. 5.1 (coefficients in Q(zeta_2d) for sums of linear cycles); Thm 5.1 (T V_[Z] = T V_Z for m < n/2 - d/(d-2), proved only in some ranges) | section exists, content as expected |
| §5.7 | title "Singular cubic hypersurfaces": lines through two singular points, cones vs rational, Borcea's count of k-planes | section exists; not cited for anything in our papers |
| §5.9 | title "Kloosterman's work": Conj. 5.1 fails for n >= 10 at a generic cubic; at the Fermat point the neighbourhoods agree to order 4 (n = 10) and 3 (n = 12) | CONSISTENT with how the registry uses Kloosterman for tenfolds |
| [Kl1, Thm 1.2] ranges and finite sets | d = 3, c in {2,3}, k >= 5 or d = 4, c = 2, k >= 3; S = {0, 1} for c = d = 3, S = {0, -1} for d = 4, c = 2 | CONSISTENT with paper 1, lines 130-131 |
| [Kl1, Thm 1.3] | d = 3, c in {2,3}, k in {2,3,4} or d = 4, c = 2, k in {1,2}; for d = c = 3 either Movasati's conjecture holds or NL is non-reduced | CONSISTENT |
| [Kl1, Prop. 6.4, Cor. 6.5] (lambda = 1 via cones over G(2,5)) | Prop. 6.4: k >= 2, cubic with two k-planes meeting in dimension k - 3, Y_t a linear section of an iterated cone over the Pluecker G(2,5), [Y_0] = [P1] + [P2] + h^k (the statement prints h^2; the proof gives h^k); Cor. 6.5: NL([P1],[P2]) has positive codimension in NL([P1]+[P2]) | CONSISTENT; "positive codimension" is a statement about NL([P1],[P2]) being a proper subscheme |
| [Kl1, Cor. 6.2] | d = 4, c = 2, k >= 1: NL([P1],[P2]) has positive codimension in NL([P1] - [P2]) | the source for the quartic lambda = -1; used in section 2 below |

Paper 1's \tbc on "machine summaries only" stays true: this read is also machine-read. Nothing found that needs a
correction. Papers were not edited.

## 2. Kloosterman's lambda = -1 mechanism for quartics, and the frozen prediction P2

[Kl1, Prop. 6.1] (machine-read): in coordinates P1 = V(x0, x1, x_{k+3..2k+1}), P2 = V(x2, x3, x_{k+3..2k+1}), the
deformation f_t = f_0 + t (Q13 Q02 - Q12 Q03) contains Y_t = V(x0 x2 + t Q13, x1 x2 - t Q03, x_{k+3}, ..., x_{2k+1}),
a complete intersection of type (1^(k-1), 2, 2) and degree 4; Y_0 = P1 + (a k-fold of class h^k - [P2]). So
[Y_t]_prim = [P1]_prim - [P2]_prim. No nodes, 16 points or Kummer surfaces are mentioned.

Comparison with leads/quartic_frozen/FROZEN_PREDICTION.md, P2 (frozen before this read):
- Node count: S = P1 - P2 + h^k. k = 2: S.S = 7 + 7 - 2 + 4 = 16, 4 * 16 - 4^2 = 48 = 3 N, N = 16. k = 3: S.S = -20 - 20
  + 4 + 4 = -32, 4 * (-32) - 16 = -144 = -3 N, N = 48. EXACT arithmetic; it agrees with P2's 16 / 48 (it follows from
  the identity, so it is a consistency check, not new evidence).
- Instances (MOD 32003, three seeds, leads/quartic_frozen/qf3_delpezzo_nodes.m2, qf3.log): a hyperplane section of a
  smooth quartic fourfold containing a smooth (2,2) del Pezzo surface has exactly 16 singular points, all on the
  surface, reduced; they impose 11, 15, 16 conditions on forms of degree 2, 3, 4 in P^4 -- one relation on cubics, the
  predicted degree k(d-2) - 1 = 3. MOD p.
- The "Kummer type" guess in P2 is NOT supported: the cycle is a quartic del Pezzo surface (a (2,2) complete
  intersection), not a 16-node Kummer configuration. P2's failure criterion was the node count and the relation
  degree; both hold. Verdict: P2 HOLDS for k = 2 (counts and relation degree), the Kummer guess FAILS. k = 3 not run.
- Blind check 17 (own code, 6 instances, two primes) confirms this and explains it: the 16 points are Q1 = Q2 = A = B = 0
  for F = Q1 A + Q2 B + x5 C, a complete intersection of four quadrics in P^4, so 16 and the cubic relation
  (Cayley-Bacharach) are automatic for this construction. None of the points lies on a line of Sigma.

## 3. Families through the Fermat cubic eightfold ([Mo3, Table 1, §5.5])

Codimensions in the space of cubic eightfolds (dim T = 120 at the Fermat point, as machine-read):
L (linear cycles P^4) 10, CS (generalised cubic scroll) 16, M (the Hodge locus of Conj. 5.1) 19, QS (generalised
quartic scroll) 23, V (generalised Veronese) 25. Also: Conj. 5.2-5.4 (non-smoothness for m = n/2 - 1 and for
(d, m) = (3, n/2 - 2) with (r, r-check) != (1, -1); Thm 5.2: (1,1) gives a complete intersection of type
(1, ..., 1, 2); Conj. 5.4: (1, -1) parameterises generalised cubic scrolls); Thm 5.3: infinitesimal smoothness for
(n, M) = (8, 6) among others.

For the lambda = 2 pocket (leads/movasati_arc/pocket/): the would-be component has codimension 28. None of the
listed families has codimension 28, and none is a family for the class [P1] + 2[P2] as listed; but a component of
the Hodge locus of [P1] + 2[P2] could lie inside the intersection of V_Z (codimension 20) with one of these loci (for
instance cubics containing both planes and another cycle whose class combines with them), and that has not been
computed. So the list does not explain the pocket, and it does not rule out an explanation. NOT DONE: the tangent
space comparison (92-dimensional space of admissible T_2 against T(V_Z n CS), T(V_Z n QS), ...).

[PRRS]: about Coble type hypersurfaces for K3^[2]-type fourfolds of square 4 or 6 and divisibility 1; it does not
concern Fermat cubics or these Hodge loci (abstract page). No input for the pocket.
