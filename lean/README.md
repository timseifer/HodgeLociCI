# Lean certificates

These files are separate from the Macaulay2 package: nothing in `M2/` depends on them. They were written by AI
agents during the same project and have not been reviewed by a human.

**What a "certificate" is here.** Each file is checked by the Lean 4 kernel. It certifies the statements listed in
its header and nothing else. In every file the geometry (periods, residues, Jacobian rings, Hodge loci) is
described in a comment and is *not* formalized: Lean checks identities between explicit polynomials or integers, or
deductions from hypotheses that are stated as hypotheses. No file proves any statement about a Hodge locus, and
none bears on the Hodge conjecture.

The headers refer to the project's working notes (`night/...`, `paper3.tex`, `PROOF_A.md` and so on). Those notes
are AI-written, unreviewed and not part of this package.

## Re-run status (22 November 2026, Lean 4.36.0, copies in this folder)

- `core/`: 13 files, each accepted with no error, no warning and no `sorryAx` (1 s to 130 s per file, about 6
  minutes in total on a 2-core machine).
- `mathlib/`: 5 files, each accepted with no error, no warning and no `sorryAx`, against Mathlib `v4.36.0`.
- `mathlib/negative_tests/`: 12 files with a deliberate mistake; each is rejected, as it must be.

## `core/`: Lean 4 core only (no Mathlib, no `native_decide`, no `sorry`)

| File | What the kernel checks | What it does not prove |
| --- | --- | --- |
| `TangentCert.lean` | In Z[x0..x7]/(xi^2): the hyperplane class kills two explicit polynomials p1, p2, and for every integer λ an explicit matrix identity (A + λB)·W(λ) = −λ^4·I for a 7×7 block. | That p1, p2 are the period polynomials of two 3-planes on the Fermat cubic sixfold, and that the identity means "tangent codimension 7" (Carlson–Griffiths, Macaulay duality). |
| `NormalisationCert.lean` | Three integer values of a pairing (16, −2, 16), four annihilation identities per plane, and that a 69×69 minor of an explicit 224×70 matrix is unit lower triangular. | The linear-algebra step from the minor to "the solution space is one-dimensional", and the geometric meaning (period polynomials, intersection numbers). |
| `ObstructionCert.lean` | Sparse integer polynomial computations giving the first-order directions and the second-order quantity `ob3 λ` for [P1] + λ[P2] at the Fermat cubic sixfold, as listed under T1 and following in its header. | That `ob3` is the second-order obstruction of the Hodge locus (Griffiths–Dwork theory); independence of the choices made. |
| `ObstructionCert8.lean` | The same for the Fermat cubic eightfold (45 squarefree coefficients). | The same. |
| `ClosedFormulaCert.lean` | For three explicit non-Fermat cubic sixfolds and each of their two planes: tables of two functionals satisfy the listed defining equations, and the listed evaluations hold; the "transformation law" instance is verified, not assumed. | That the tables are the residues (uniqueness is checked in Python, not in Lean); that the obstruction is c2·λ^2 + c1·λ; smoothness of the cubics. |
| `SexticCert.lean` | At one explicit sextic surface with two disjoint conics: degrees, F = f·g = h·k, the Jacobian determinants a1, a2 (computed by the kernel), and the membership identities T2 to T4 of its header. | Smoothness, disjointness, uniqueness of the socle functional, and that the computed number is the second-order invariant of the Hodge locus. |
| `GenFamilyCert.lean` | Polynomial identities I1 to I5 and 5B for a 4×4 matrix M over an arbitrary commutative ring. | Any use of them in a proof about Hodge loci. |
| `OcticDetCert.lean` | Ring identities for 2×2 matrices behind the families at the special coefficient, over an arbitrary commutative ring. | The same. |
| `PfaffianCert.lean` | Pf [[A, τΛ], [−τΛᵀ, B]] = τ·(αᵀΛβ − τ^2·det Λ) and a containment identity, over an arbitrary commutative ring. | That the Pfaffian family is a component of a Hodge locus. |
| `SixfoldCriterionCert.lean` | Expansions and implications for the binary forms in Corollary 9.3 of the third note, over an arbitrary commutative ring. | The corollary itself. |
| `LinearListCert.lean` | For five explicit instances with monomial relations: full expansions and "mod-ideal" forms of products, and the implications between polynomial equations listed in its header. | That the two functionals are coefficient extractions; the theorems of the note that use these instances. |
| `LatticeFacts.lean` | Integer arithmetic for intersection numbers on a cubic sixfold. | The geometric meaning of each number. |
| `SecondOrderLaw.lean` | An abstract deduction for an arbitrary commutative ring, symmetric bilinear forms and predicates: the "second-order law" follows from the hypotheses named in the file. | Every hypothesis (the key lemma, the pencil identity, the period-formula evaluations). |

## `mathlib/`: needs Mathlib

| File | Hypotheses (assumed, not proved) | Conclusions (proved from them) |
| --- | --- | --- |
| `SpecialCoefficient.lean` | The transformation law for residue symbols. | For a square matrix M of any size c over a commutative ring: Cramer's inclusions, F = fᵀMh written two ways, the determinants of the two transition matrices, and Res[m·det M/Φ¹] + (−1)^(c+1)·Res[m·det M/Φ²] = 0. |
| `SecondOrderLawModule.lean` | The key lemma, the pencil identity, the period-formula evaluations. | The abstract second-order law for modules, bilinear maps and submodules. |
| `PointwiseFormula.lean` | The ε^2-coefficient identity; π = κ·ρ; four properties of the symbols with one pair squared; the derivative relation; that the products span. | The pointwise second-order formula on Q·G^2, its polarisation and additive closure; κ̇·ρ(P) = 0. A model over Z[X][X] shows the hypotheses are consistent. |
| `EveryR.lean` | Vanishing of the squared-pair symbols on multiples of the other pairs' members, and one normalisation identity. | The two matrix-entry identities used in the proof of the formula "for every r". |
| `SecondProof.lean` | The derivative relation and ρ = 0 on the ideal. | The pointwise formula on the additive span of the products P·G with P in the ideal; κ'·ρ(P) = 0 when P·G lies in that span. |

What the Mathlib files certify: the deductions from the stated hypotheses, for arbitrary data. What they do not
certify: any hypothesis, and any statement about Hodge loci.

`negative_tests/` holds twelve variants with a wrong sign, determinant, constant or matrix index, or a missing
hypothesis (`Neg0` is for `core/SecondOrderLaw.lean`; `Neg1` to `Neg4` for the first two Mathlib files; `Neg5` to
`Neg8` for `PointwiseFormula.lean`; `Neg9`, `Neg10` for `EveryR.lean`; `Neg11` for `SecondProof.lean`).

## How to re-run

Lean 4.36.0. For the core files only `lean` is needed:

    ./run_all.sh core

For the Mathlib files, a built Mathlib at tag `v4.36.0` (its `lean-toolchain` is `leanprover/lean4:v4.36.0`):

    git clone --depth 1 --branch v4.36.0 https://github.com/leanprover-community/mathlib4
    cd mathlib4
    lake exe cache get        # prebuilt Mathlib; if unavailable, the next line builds what is needed from source
    lake build Mathlib.LinearAlgebra.Matrix.Adjugate Mathlib.Tactic.LinearCombination
    cd -
    ./run_all.sh mathlib /path/to/mathlib4

Expected: `PASS` for every file, and for every `#print axioms` line at most
`[propext, Classical.choice, Quot.sound]`. Building the needed part of Mathlib from source took about 21 minutes
on 2 cores in the project's own run.
