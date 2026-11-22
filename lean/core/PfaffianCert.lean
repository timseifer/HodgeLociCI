/-!
# Certificate: the Pfaffian identities behind the family F + t·det Λ  (night/pfaff/PFAFF.md)

Lean 4 core only: no Mathlib, no `native_decide`, no `sorry`.  Hand-written (not generated).

## What the Lean kernel checks

Polynomial identities over an arbitrary commutative ring `R` (`Lean.Grind.CommRing R`), in the 16 variables
`a0 a1 a2` (alpha), `b0 b1 b2` (beta), `l00 … l22` (the entries of Λ) and `t` (tau) resp. `s`:

* `pfaffian_identity` :  Pf [[A, τΛ], [-τΛᵀ, B]] = τ·(αᵀΛβ - τ²·det Λ),  A = [α]ₓ, B = [β]ₓ (cross-product matrices).
  The Pfaffian of a 6×6 skew matrix is written out as `pf6` (expansion along the first row, 15 terms).
* `containment` :  αᵀΛβ - s·det Λ = b0·f0 + b1·f1 + l02·e0 + l12·e1 + l22·e2,  where
  e_j = a_j·b2 - s·(λ₀ × λ₁)_j and f_c = α·λ_c (λ_c = column c of Λ).
* `sub_pfaffians` :  the five 4×4 Pfaffians of the 5×5 skew matrix N(s) = [[A, (λ₀, s·λ₁)], [.., b2·J]] are
  e0, -e1, e2, -s·f1, -f0.
* `f_redundant` :  b2·f_c = Σ_j λ_c[j]·e_j  (c = 0, 1).
* `m_parallel` :  α × (λ₀ × λ₁) = λ₀·f1 - λ₁·f0  (three components).

## What is NOT checked here

Everything geometric: that these identities make W_s = V(e0,e1,e2,f0,f1) ∩ {x_N = 0} a subscheme of the cubic
{F - s·det Λ = 0}, the Buchsbaum–Eisenbud structure theorem, the flat limit, the cycle class and the Hodge locus
statement.  Those are ordinary mathematics in night/pfaff/PFAFF.md.  That `pf6` is the Pfaffian (pf6² = det) is the
classical expansion formula and is not re-proved here (checked in sympy: night/pfaff/pf_identity.py).
-/
namespace PfaffianCert
open Lean.Grind

variable {R : Type} [CommRing R]

/-- Pfaffian of a 4×4 skew matrix with upper-triangular entries n01 n02 n03 n12 n13 n23. -/
def pf4 (n01 n02 n03 n12 n13 n23 : R) : R := n01 * n23 - n02 * n13 + n03 * n12

/-- Pfaffian of a 6×6 skew matrix, expanded along the first row. -/
def pf6 (m01 m02 m03 m04 m05 m12 m13 m14 m15 m23 m24 m25 m34 m35 m45 : R) : R :=
  m01 * pf4 m23 m24 m25 m34 m35 m45 - m02 * pf4 m13 m14 m15 m34 m35 m45 + m03 * pf4 m12 m14 m15 m24 m25 m45
    - m04 * pf4 m12 m13 m15 m23 m25 m35 + m05 * pf4 m12 m13 m14 m23 m24 m34

/-- αᵀ Λ β -/
def bil (a0 a1 a2 b0 b1 b2 l00 l01 l02 l10 l11 l12 l20 l21 l22 : R) : R :=
  a0 * (l00 * b0 + l01 * b1 + l02 * b2) + a1 * (l10 * b0 + l11 * b1 + l12 * b2) + a2 * (l20 * b0 + l21 * b1 + l22 * b2)

/-- det Λ -/
def det3 (l00 l01 l02 l10 l11 l12 l20 l21 l22 : R) : R :=
  l00 * (l11 * l22 - l12 * l21) - l01 * (l10 * l22 - l12 * l20) + l02 * (l10 * l21 - l11 * l20)

theorem pfaffian_identity (a0 a1 a2 b0 b1 b2 l00 l01 l02 l10 l11 l12 l20 l21 l22 t : R) :
    pf6 (-a2) a1 (t * l00) (t * l01) (t * l02) (-a0) (t * l10) (t * l11) (t * l12) (t * l20) (t * l21) (t * l22)
        (-b2) b1 (-b0)
      = t * (bil a0 a1 a2 b0 b1 b2 l00 l01 l02 l10 l11 l12 l20 l21 l22
              - t * t * det3 l00 l01 l02 l10 l11 l12 l20 l21 l22) := by
  unfold pf6 pf4 bil det3; grind

theorem containment (a0 a1 a2 b0 b1 b2 l00 l01 l02 l10 l11 l12 l20 l21 l22 s : R) :
    bil a0 a1 a2 b0 b1 b2 l00 l01 l02 l10 l11 l12 l20 l21 l22 - s * det3 l00 l01 l02 l10 l11 l12 l20 l21 l22
      = b0 * (a0 * l00 + a1 * l10 + a2 * l20) + b1 * (a0 * l01 + a1 * l11 + a2 * l21)
        + l02 * (a0 * b2 - s * (l10 * l21 - l20 * l11))
        + l12 * (a1 * b2 - s * (l20 * l01 - l00 * l21))
        + l22 * (a2 * b2 - s * (l00 * l11 - l10 * l01)) := by
  unfold bil det3; grind

theorem sub_pfaffians (a0 a1 a2 b2 l00 l01 l10 l11 l20 l21 s : R) :
    pf4 (-a0) l10 (s * l11) l20 (s * l21) (-b2) = a0 * b2 - s * (l10 * l21 - l20 * l11)
    ∧ pf4 a1 l00 (s * l01) l20 (s * l21) (-b2) = -(a1 * b2 - s * (l20 * l01 - l00 * l21))
    ∧ pf4 (-a2) l00 (s * l01) l10 (s * l11) (-b2) = a2 * b2 - s * (l00 * l11 - l10 * l01)
    ∧ pf4 (-a2) a1 (s * l01) (-a0) (s * l11) (s * l21) = -(s * (a0 * l01 + a1 * l11 + a2 * l21))
    ∧ pf4 (-a2) a1 l00 (-a0) l10 l20 = -(a0 * l00 + a1 * l10 + a2 * l20) := by
  unfold pf4; refine ⟨?_, ?_, ?_, ?_, ?_⟩ <;> grind

theorem f_redundant (a0 a1 a2 b2 l00 l01 l10 l11 l20 l21 s : R) :
    b2 * (a0 * l00 + a1 * l10 + a2 * l20)
        = l00 * (a0 * b2 - s * (l10 * l21 - l20 * l11)) + l10 * (a1 * b2 - s * (l20 * l01 - l00 * l21))
          + l20 * (a2 * b2 - s * (l00 * l11 - l10 * l01))
    ∧ b2 * (a0 * l01 + a1 * l11 + a2 * l21)
        = l01 * (a0 * b2 - s * (l10 * l21 - l20 * l11)) + l11 * (a1 * b2 - s * (l20 * l01 - l00 * l21))
          + l21 * (a2 * b2 - s * (l00 * l11 - l10 * l01)) := by
  refine ⟨?_, ?_⟩ <;> grind

theorem m_parallel (a0 a1 a2 l00 l01 l10 l11 l20 l21 : R) :
    a1 * (l00 * l11 - l10 * l01) - a2 * (l20 * l01 - l00 * l21)
        = l00 * (a0 * l01 + a1 * l11 + a2 * l21) - l01 * (a0 * l00 + a1 * l10 + a2 * l20)
    ∧ a2 * (l10 * l21 - l20 * l11) - a0 * (l00 * l11 - l10 * l01)
        = l10 * (a0 * l01 + a1 * l11 + a2 * l21) - l11 * (a0 * l00 + a1 * l10 + a2 * l20)
    ∧ a0 * (l20 * l01 - l00 * l21) - a1 * (l10 * l21 - l20 * l11)
        = l20 * (a0 * l01 + a1 * l11 + a2 * l21) - l21 * (a0 * l00 + a1 * l10 + a2 * l20) := by
  refine ⟨?_, ?_, ?_⟩ <;> grind

/-- The same identity for integers, as a sanity instance. -/
theorem pfaffian_identity_int (a0 a1 a2 b0 b1 b2 l00 l01 l02 l10 l11 l12 l20 l21 l22 t : Int) :
    pf6 (-a2) a1 (t * l00) (t * l01) (t * l02) (-a0) (t * l10) (t * l11) (t * l12) (t * l20) (t * l21) (t * l22)
        (-b2) b1 (-b0)
      = t * (bil a0 a1 a2 b0 b1 b2 l00 l01 l02 l10 l11 l12 l20 l21 l22
              - t * t * det3 l00 l01 l02 l10 l11 l12 l20 l21 l22) :=
  pfaffian_identity a0 a1 a2 b0 b1 b2 l00 l01 l02 l10 l11 l12 l20 l21 l22 t

end PfaffianCert
#print axioms PfaffianCert.pfaffian_identity
#print axioms PfaffianCert.containment
#print axioms PfaffianCert.sub_pfaffians
#print axioms PfaffianCert.f_redundant
#print axioms PfaffianCert.m_parallel
#print axioms PfaffianCert.pfaffian_identity_int
