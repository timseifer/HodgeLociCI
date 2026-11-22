/-!
# Certificate: the ring identities behind the families at the special coefficient
# (night/octic/OCTIC.md §2.5(a), night/octic/PROOF_O2.md §6;  night/general_d/GENERAL.md §6, identity (6.1))

Lean 4 core only: no Mathlib, no `native_decide`, no `sorry`.  Hand-written (not generated).

## What the Lean kernel checks

Polynomial identities over an arbitrary commutative ring `R` (`Lean.Grind.CommRing R`).

### Part A: two complete-intersection curves on a surface (octic case, r = -1)

Symbols: `x0 x1` (the line L = {x0 = x1 = 0}), `c1 c2` (the curve C = {c1 = c2 = 0}), `a0 a1 m0 m1`
(the entries of the 2×2 matrix M = [[a0, m0], [a1, m1]]), `e` (the deformation parameter).

    F    = x0·(c1·a0 + c2·m0) + x1·(c1·a1 + c2·m1)      (= xᵀ M c)
    detM = a0·m1 - a1·m0
    q1   = x0·c1 + e·m1,   q2 = x1·c1 - e·m0             (two "quartics")
    Qt   = x0·m0 + x1·m1                                 (the "quintic")

* `hb_minors`     : the 2×2 minors of [[x0, x1, e], [-m1, m0, c1]] are Qt, q1, q2 (columns (1,2), (1,3), (2,3)).
* `hb_syzygies`   : x0·q2 - x1·q1 + e·Qt = 0  and  c1·Qt = m0·q1 + m1·q2   (the two Hilbert–Burch relations).
* `family`        : F + e·detM = a0·q1 + a1·q2 + c2·Qt.
* `family_in_ci`  : e·(F + e·detM) = (e·a0 + c2·x1)·q1 + (e·a1 - c2·x0)·q2.
  So for invertible e the surface {F + e·detM = 0} contains the complete intersection {q1 = q2 = 0}.
* `det_identity`  : det(e·adj M + c xᵀ) = e·(F + e·detM).
* `limit`         : F = a0·(x0·c1) + a1·(x1·c1) + c2·Qt   (F lies in the ideal of minors at e = 0).

### Part B: identity (6.1) of GENERAL.md for c = 2 and c = 3

    (w·y)·( xᵀ Λ y - s·det Λ ) = Eᵀ Λ y,      E = (w·y)·x - s·adj(Λ)ᵀ w.

* `ident61_c2` : Λ 2×2.     * `ident61_c3` : Λ 3×3.

## What is NOT checked here

Everything geometric: degrees, flatness of the family, the cycle classes, the codimension count, the statement
about Hodge / Noether–Lefschetz loci.  Those are ordinary mathematics in the files named above.
-/
namespace OcticDetCert
open Lean.Grind

variable {R : Type} [CommRing R]

/-! ### Part A -/

def F (x0 x1 c1 c2 a0 a1 m0 m1 : R) : R := x0 * (c1 * a0 + c2 * m0) + x1 * (c1 * a1 + c2 * m1)
def detM (a0 a1 m0 m1 : R) : R := a0 * m1 - a1 * m0
def q1 (x0 c1 m1 e : R) : R := x0 * c1 + e * m1
def q2 (x1 c1 m0 e : R) : R := x1 * c1 - e * m0
def Qt (x0 x1 m0 m1 : R) : R := x0 * m0 + x1 * m1

/-- 2×2 minor of a 2×3 matrix [[p0, p1, p2], [r0, r1, r2]] on columns i < j, written out. -/
def minor (pi pj ri rj : R) : R := pi * rj - pj * ri

theorem hb_minors (x0 x1 c1 m0 m1 e : R) :
    minor x0 x1 (-m1) m0 = Qt x0 x1 m0 m1
    ∧ minor x0 e (-m1) c1 = q1 x0 c1 m1 e
    ∧ minor x1 e m0 c1 = q2 x1 c1 m0 e := by
  unfold minor Qt q1 q2; refine ⟨?_, ?_, ?_⟩ <;> grind

theorem hb_syzygies (x0 x1 c1 m0 m1 e : R) :
    x0 * q2 x1 c1 m0 e - x1 * q1 x0 c1 m1 e + e * Qt x0 x1 m0 m1 = 0
    ∧ c1 * Qt x0 x1 m0 m1 = m0 * q1 x0 c1 m1 e + m1 * q2 x1 c1 m0 e := by
  unfold Qt q1 q2; refine ⟨?_, ?_⟩ <;> grind

theorem family (x0 x1 c1 c2 a0 a1 m0 m1 e : R) :
    F x0 x1 c1 c2 a0 a1 m0 m1 + e * detM a0 a1 m0 m1
      = a0 * q1 x0 c1 m1 e + a1 * q2 x1 c1 m0 e + c2 * Qt x0 x1 m0 m1 := by
  unfold F detM Qt q1 q2; grind

theorem family_in_ci (x0 x1 c1 c2 a0 a1 m0 m1 e : R) :
    e * (F x0 x1 c1 c2 a0 a1 m0 m1 + e * detM a0 a1 m0 m1)
      = (e * a0 + c2 * x1) * q1 x0 c1 m1 e + (e * a1 - c2 * x0) * q2 x1 c1 m0 e := by
  unfold F detM q1 q2; grind

/-- det(e·adj M + c xᵀ) = e·(F + e·det M), with M = [[a0, m0], [a1, m1]]:
    the matrix is [[e·m1 + c1·x0, -(e·m0) + c1·x1], [-(e·a1) + c2·x0, e·a0 + c2·x1]]. -/
theorem det_identity (x0 x1 c1 c2 a0 a1 m0 m1 e : R) :
    (e * m1 + c1 * x0) * (e * a0 + c2 * x1) - (-(e * m0) + c1 * x1) * (-(e * a1) + c2 * x0)
      = e * (F x0 x1 c1 c2 a0 a1 m0 m1 + e * detM a0 a1 m0 m1) := by
  unfold F detM; grind

theorem limit (x0 x1 c1 c2 a0 a1 m0 m1 : R) :
    F x0 x1 c1 c2 a0 a1 m0 m1 = a0 * (x0 * c1) + a1 * (x1 * c1) + c2 * Qt x0 x1 m0 m1 := by
  unfold F Qt; grind

/-! ### Part B -/

theorem ident61_c2 (x0 x1 y0 y1 w0 w1 l00 l01 l10 l11 s : R) :
    (w0 * y0 + w1 * y1)
        * (x0 * (l00 * y0 + l01 * y1) + x1 * (l10 * y0 + l11 * y1) - s * (l00 * l11 - l01 * l10))
      = ((w0 * y0 + w1 * y1) * x0 - s * (l11 * w0 - l10 * w1)) * (l00 * y0 + l01 * y1)
        + ((w0 * y0 + w1 * y1) * x1 - s * (-(l01 * w0) + l00 * w1)) * (l10 * y0 + l11 * y1) := by
  grind

/-- det Λ, 3×3 -/
def det3 (l00 l01 l02 l10 l11 l12 l20 l21 l22 : R) : R :=
  l00 * (l11 * l22 - l12 * l21) - l01 * (l10 * l22 - l12 * l20) + l02 * (l10 * l21 - l11 * l20)

/-- row i of adj(Λ)ᵀ applied to w, i.e. Σ_j cof_{ij} w_j with cof the cofactor matrix of Λ -/
def cofw0 (l10 l11 l12 l20 l21 l22 w0 w1 w2 : R) : R :=
  (l11 * l22 - l12 * l21) * w0 - (l10 * l22 - l12 * l20) * w1 + (l10 * l21 - l11 * l20) * w2
def cofw1 (l00 l01 l02 l20 l21 l22 w0 w1 w2 : R) : R :=
  -((l01 * l22 - l02 * l21) * w0) + (l00 * l22 - l02 * l20) * w1 - (l00 * l21 - l01 * l20) * w2
def cofw2 (l00 l01 l02 l10 l11 l12 w0 w1 w2 : R) : R :=
  (l01 * l12 - l02 * l11) * w0 - (l00 * l12 - l02 * l10) * w1 + (l00 * l11 - l01 * l10) * w2

theorem ident61_c3 (x0 x1 x2 y0 y1 y2 w0 w1 w2 l00 l01 l02 l10 l11 l12 l20 l21 l22 s : R) :
    (w0 * y0 + w1 * y1 + w2 * y2)
        * (x0 * (l00 * y0 + l01 * y1 + l02 * y2) + x1 * (l10 * y0 + l11 * y1 + l12 * y2)
            + x2 * (l20 * y0 + l21 * y1 + l22 * y2) - s * det3 l00 l01 l02 l10 l11 l12 l20 l21 l22)
      = ((w0 * y0 + w1 * y1 + w2 * y2) * x0 - s * cofw0 l10 l11 l12 l20 l21 l22 w0 w1 w2)
            * (l00 * y0 + l01 * y1 + l02 * y2)
        + ((w0 * y0 + w1 * y1 + w2 * y2) * x1 - s * cofw1 l00 l01 l02 l20 l21 l22 w0 w1 w2)
            * (l10 * y0 + l11 * y1 + l12 * y2)
        + ((w0 * y0 + w1 * y1 + w2 * y2) * x2 - s * cofw2 l00 l01 l02 l10 l11 l12 w0 w1 w2)
            * (l20 * y0 + l21 * y1 + l22 * y2) := by
  unfold det3 cofw0 cofw1 cofw2; grind

end OcticDetCert
