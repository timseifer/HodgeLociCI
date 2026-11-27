# Predictor design note (plan item D13; design only, no code)

27 Nov 2026, Claude Opus 5.5. AI-written, unreviewed. Not to be built before item C10 is closed and the owner says so.

## Goal
Given (d, k) and a candidate geometry, predict which classes of the two-plane lattice (or other small lattices) get
special Hodge loci, their codimension, and flag the atypical ones; then verify in stages.

## Pipeline
1. **Candidate singular loci.** Input: a family of odd-dimensional hypersurfaces Y in P^n (hyperplane sections of
   the 2k-folds) singular along a smooth subvariety S (surfaces for the known rungs). Sources: Pfaffian (K3 of genus 8),
   Coble (abelian (3,3)), Enriques pencils, Segre / determinantal loci, and the list of arXiv:2606.10884 for
   K-trivial surfaces carrying such cubics (to be read; not read yet).
2. **Node count and relations.** For a general completion: N = number of nodes on S cut by the extra quadrics
   (4 deg S on tenfolds, ...), and the number of relations on forms of degree k(d - 2) - 1 (= p_g(S) by the residue
   argument when K_S = 0; 0 when K_S is torsion of order 2). Tool: tooling/node_section (exists).
3. **Discriminant.** disc <h^k, class> = (-1)^k (d - 1) N (generalised identity, leads/quartic_frozen; d = 3: the
   registry identity). Output: the discriminant of the predicted class.
4. **Predicted class / coefficient.** Solve disc <h^k, r P1 + s P2> = predicted value over coprime (r, s) (and over
   other lattices: three planes, kappa-type classes); return the coefficients that match.
5. **Codimension versus expected.** Expected codimension of a Hodge locus of a primitive class: h^(k+1, k-1). Compute
   the codimension of the family (parameter count) and flag atypical (codimension < h^(k+1,k-1)).
6. **Staged verification.** (a) first order at a member (hodgeLocusTangentCodim; MOD p); (b) the node count and
   defect at a member (MOD p, then exact); (c) at the Fermat point, arcs in the full space (blind-check code), with
   the order-6 test of D-MOVASATI-POINT-COEFFICIENT-SCAN as the discriminating step.

## Frozen calibration (must pass before any new prediction is read)
Must rediscover: +1 with G(2,5) / Pfaffian K3 (14, 28, 56 nodes), -1 with Coble / abelian (18, 36, 72), the two-
determinant family (codim 8 / 26 / 52), and the cubic-scroll locus for c = 2 (codim 1, 6, 16, ...). Must reject:
Enriques (64 nodes, no relation: no class), bielliptic (not a singular locus of a cubic). The calibration set and
expected outputs go into a frozen file before the first run; any failure stops the build.

## Not in scope
Anything about whether a class is algebraic: every class the predictor finds through a K-trivial S is algebraic by
construction (it is the class of a cycle through S); the predictor's use is to find where to look, and to flag loci
it cannot explain (those would be candidates, reported as such, never more).
