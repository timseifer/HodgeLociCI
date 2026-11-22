/-!
# Certificate: the criterion of Corollary 9.3 of night/paper3/paper3.tex (two 3-planes meeting in a line on a
# cubic sixfold), in the normal form s̄ = (y1², y2²)

Lean 4 core only: no Mathlib, no `native_decide`, no `sorry`. Written by hand (main thread), 2026-11-21.

## What the Lean kernel checks

Polynomial identities over an arbitrary commutative ring `R` (`Lean.Grind.CommRing R`).

Notation: m̄ = al·y1² + be·y1·y2 + ga·y2² (the restriction of det M to the line L), N̄ = a·y1 + b·y2,
    q1 a b = a·(a·be + 2·b·al),        q2 a b = b·(2·a·ga + b·be),        T = be·(be·be − 4·al·ga).

* `expand_N2m`: N̄²·m̄ = a²al·y1⁴ + q1·y1³y2 + (a²ga + 2ab·be + b²al)·y1²y2² + q2·y1y2³ + b²ga·y2⁴.
  So q1 and q2 are the coefficients of y1³y2 and y1y2³ of N̄²·m̄, i.e. (up to nonzero constants) the values on
  N̄²·m̄ of the socle functionals of C[y1,y2]/(y1⁴, y2²) and C[y1,y2]/(y1², y2⁴) in degree 4.
* `bezout_a`, `bezout_b`: T·a³ and T·b³ are explicit combinations of q1 and q2.
* `common_zero_a`, `common_zero_b`: if q1 = 0 and q2 = 0 then T·a³ = 0 and T·b³ = 0. Over a field: if T ≠ 0 the
  two binary quadrics have no common zero (a, b) ≠ (0, 0).
* `zero_of_be`: if be = 0 then (a, b) = (1, 0) is a common zero.
* `zero_of_disc`: if be·be = 4·al·ga then (a, b) = (2·al, −be) is a common zero (and if that pair is (0, 0),
  then al = be = 0 and `zero_of_be` applies).
* `fermat_instance`: for m̄ = 36·y1·y2 (al = ga = 0, be = 36), T = 36³ = 46656 (nonzero in characteristic 0).
* `fermat_M00`, `fermat_line`: the decomposition used in the proof of Corollary 9.3(2) at the Fermat cubic:
  x0³ + x1³ + x2³ + x3³ = f0·M00·h0 + p1·s1 with f0 = x0 + x1, h0 = x0 + x2, p1 = x0 + x1 + x2 + x3,
  M00 = x0 − 2x1 − 2x2 + x3, s1 = (x2² − x2x3 + x3²) + f0·(x1 + x2 − x3); and on the line (x1 = −x0, x2 = −x0,
  x3 = x0): M00 = 6·x0, s1 = 3·x0².

## What is NOT checked here

Everything else: that the two quadrics of Theorem 9.1(4) are these residues (the theorem itself, the period
formula, the reduction to the line), that the normal form s̄ = (y1², y2²) can be reached, the meaning of the
socle functionals, and every statement about Hodge loci. Those are ordinary mathematics in the paper, written by
an AI and refereed only by AI agents.
-/
namespace SixfoldCriterionCert
open Lean.Grind
set_option linter.unusedVariables false

variable {R : Type} [CommRing R]

def q1 (al be : R) (a b : R) : R := a * (a * be + 2 * b * al)
def q2 (be ga : R) (a b : R) : R := b * (2 * a * ga + b * be)
def T (al be ga : R) : R := be * (be * be - 4 * al * ga)

theorem expand_N2m (al be ga a b y1 y2 : R) :
    (a * y1 + b * y2) * (a * y1 + b * y2) * (al * (y1 * y1) + be * (y1 * y2) + ga * (y2 * y2))
      = a * a * al * (y1 * y1 * y1 * y1) + q1 al be a b * (y1 * y1 * y1 * y2)
        + (a * a * ga + 2 * a * b * be + b * b * al) * (y1 * y1 * y2 * y2)
        + q2 be ga a b * (y1 * y2 * y2 * y2) + b * b * ga * (y2 * y2 * y2 * y2) := by
  unfold q1 q2; grind

theorem bezout_a (al be ga a b : R) :
    ((be * be - 4 * al * ga) * a - 2 * al * be * b) * q1 al be a b + (4 * al * al * a) * q2 be ga a b
      = T al be ga * (a * a * a) := by
  unfold q1 q2 T; grind

theorem bezout_b (al be ga a b : R) :
    (4 * ga * ga * b) * q1 al be a b + ((be * be - 4 * al * ga) * b - 2 * be * ga * a) * q2 be ga a b
      = T al be ga * (b * b * b) := by
  unfold q1 q2 T; grind

theorem common_zero_a (al be ga a b : R) (h1 : q1 al be a b = 0) (h2 : q2 be ga a b = 0) :
    T al be ga * (a * a * a) = 0 := by
  have h := bezout_a al be ga a b
  rw [h1, h2] at h
  grind

theorem common_zero_b (al be ga a b : R) (h1 : q1 al be a b = 0) (h2 : q2 be ga a b = 0) :
    T al be ga * (b * b * b) = 0 := by
  have h := bezout_b al be ga a b
  rw [h1, h2] at h
  grind

theorem zero_of_be (al be ga : R) (hbe : be = 0) : q1 al be 1 0 = 0 ∧ q2 be ga 1 0 = 0 := by
  unfold q1 q2; subst hbe; constructor <;> grind

theorem zero_of_disc (al be ga : R) (hd : be * be = 4 * al * ga) :
    q1 al be (2 * al) (-be) = 0 ∧ q2 be ga (2 * al) (-be) = 0 := by
  unfold q1 q2; constructor <;> grind

theorem fermat_instance : T (0 : Int) 36 0 = 46656 := by
  unfold T; decide

theorem fermat_M00 (x0 x1 x2 x3 : R) :
    x0 * x0 * x0 + x1 * x1 * x1 + x2 * x2 * x2 + x3 * x3 * x3
      = (x0 + x1) * (x0 - 2 * x1 - 2 * x2 + x3) * (x0 + x2)
        + (x0 + x1 + x2 + x3) * ((x2 * x2 - x2 * x3 + x3 * x3) + (x0 + x1) * (x1 + x2 - x3)) := by
  grind

theorem fermat_line (x0 : R) :
    (x0 - 2 * (-x0) - 2 * (-x0) + x0 = 6 * x0)
    ∧ (((-x0) * (-x0) - (-x0) * x0 + x0 * x0) + (x0 + (-x0)) * ((-x0) + (-x0) - x0) = 3 * (x0 * x0)) := by
  constructor <;> grind

end SixfoldCriterionCert

#print axioms SixfoldCriterionCert.expand_N2m
#print axioms SixfoldCriterionCert.bezout_a
#print axioms SixfoldCriterionCert.bezout_b
#print axioms SixfoldCriterionCert.common_zero_a
#print axioms SixfoldCriterionCert.common_zero_b
#print axioms SixfoldCriterionCert.zero_of_be
#print axioms SixfoldCriterionCert.zero_of_disc
#print axioms SixfoldCriterionCert.fermat_instance
#print axioms SixfoldCriterionCert.fermat_M00
#print axioms SixfoldCriterionCert.fermat_line
