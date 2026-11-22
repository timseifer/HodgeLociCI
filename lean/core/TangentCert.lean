/-!
# Certificate: first-order Hodge locus of two rational 3-planes on the Fermat cubic sixfold

Lean 4 core only (no Mathlib, no `native_decide`).

Setting (classical, NOT formalized here): X = {x₀³+…+x₇³ = 0} ⊂ P⁷, with Jacobian ring
R = ℤ[x₀,…,x₇]/(xᵢ²).  The 3-planes
  P₁ = {x₀+x₁ = x₂+x₃ = x₄+x₅ = x₆+x₇ = 0},   P₂ = {x₀+x₇ = x₁+x₂ = x₃+x₄ = x₅+x₆ = 0}
lie on X and meet in the single point (1,-1,1,-1,1,-1,1,-1).  Up to the common factor 81 their
period polynomials are p₁ = ∏(xᵢ - xⱼ) over the pairs of P₁ and p₂ likewise (complete-intersection
period formula).  For a = p₁ + λ·p₂, the Zariski tangent space of the Hodge locus of [P₁] + λ[P₂]
has codimension  8 - dim {L ∈ R₁ : L·a = 0}  (Carlson–Griffiths + Macaulay duality).

What Lean checks:
  * (x₀+…+x₇)·p₁ = 0 and (x₀+…+x₇)·p₂ = 0 in R, so the hyperplane equation kills p₁ + λp₂ for all λ;
  * the 7×7 block of L ↦ L·pᵢ (rows L = x₀,…,x₆; seven fixed target monomials) is the matrix A, resp. B;
  * for EVERY integer λ:  (A + λB) · W(λ) = -λ⁴ · I  for an explicit integer matrix W(λ).
By bilinearity the block of L ↦ L·(p₁+λp₂) is A + λB, which is therefore invertible over ℚ for λ ≠ 0.
So the degree-1 annihilator is exactly one-dimensional and the tangent codimension is 7, one less
than the codimension 8 of the locus of cubics containing both planes.
-/
namespace HodgeCert

/-- An element of ℤ[x₀,…,x₇]/(xᵢ²): list of (squarefree monomial as a bitmask, coefficient). -/
abbrev Poly := List (Nat × Int)

/-- Coefficient of the monomial with bitmask `m`. -/
def coeff (p : Poly) (m : Nat) : Int :=
  p.foldl (fun acc t => if t.1 == m then acc + t.2 else acc) 0

/-- Product in ℤ[x]/(xᵢ²): two monomials sharing a variable multiply to zero. -/
def mul (p q : Poly) : Poly :=
  p.flatMap fun s => (q.filter fun t => (s.1 &&& t.1) == 0).map fun t => (s.1 ||| t.1, s.2 * t.2)

/-- the variable xᵢ -/
def x (i : Nat) : Poly := [(1 <<< i, 1)]
/-- xᵢ - xⱼ -/
def xdiff (i j : Nat) : Poly := [(1 <<< i, 1), (1 <<< j, -1)]

/-- `p = 0` in the quotient ring: all 256 coefficients vanish. -/
def isZero (p : Poly) : Bool := (List.range 256).all fun m => coeff p m == 0

def p1 : Poly := mul (mul (xdiff 0 1) (xdiff 2 3)) (mul (xdiff 4 5) (xdiff 6 7))
def p2 : Poly := mul (mul (xdiff 0 7) (xdiff 1 2)) (mul (xdiff 3 4) (xdiff 5 6))
/-- x₀ + … + x₇, the equation of the hyperplane spanned by P₁ ∪ P₂ -/
def hyperplane : Poly := (List.range 8).flatMap x

/-- seven degree-5 monomials (bitmasks) used as columns -/
def targets : List Nat := [87, 151, 61, 213, 185, 217, 244]
/-- rows: L = x₀,…,x₆; entries: coefficients of L·p at the target monomials -/
def rowsOf (p : Poly) : List (List Int) :=
  (List.range 7).map fun v => targets.map fun m => coeff (mul (x v) p) m

/-! ### Matrices as lists of rows -/
def dot (r c : List Int) : Int := (List.zipWith (· * ·) r c).foldl (· + ·) 0
/-- `M · W` where `WT` lists the COLUMNS of `W` -/
def matMul (M WT : List (List Int)) : List (List Int) := M.map fun r => WT.map fun c => dot r c
def matAdd (M N : List (List Int)) : List (List Int) := List.zipWith (List.zipWith (· + ·)) M N
def matSmul (c : Int) (M : List (List Int)) : List (List Int) := M.map fun r => r.map fun e => c * e
def scalar (s : Int) : List (List Int) :=
  (List.range 7).map fun i => (List.range 7).map fun j => if i == j then s else 0

/-! ### Generated data -/
def p1nf : Poly := [(85, 1), (149, -1), (101, -1), (165, 1), (89, -1), (153, 1), (105, 1), (169, -1), (86, -1), (150, 1), (102, 1), (166, -1), (90, 1), (154, -1), (106, -1), (170, 1)]
def p2nf : Poly := [(43, 1), (75, -1), (51, -1), (83, 1), (45, -1), (77, 1), (53, 1), (85, -1), (170, -1), (202, 1), (178, 1), (210, -1), (172, 1), (204, -1), (180, -1), (212, 1)]
def prod1 : Poly := [(87, -1), (151, 1), (103, 1), (167, -1), (91, 1), (155, -1), (107, -1), (171, 1), (87, 1), (151, -1), (103, -1), (167, 1), (91, -1), (155, 1), (107, 1), (171, -1), (93, -1), (157, 1), (109, 1), (173, -1), (94, 1), (158, -1), (110, -1), (174, 1), (93, 1), (157, -1), (109, -1), (173, 1), (94, -1), (158, 1), (110, 1), (174, -1), (117, -1), (181, 1), (121, 1), (185, -1), (118, 1), (182, -1), (122, -1), (186, 1), (117, 1), (181, -1), (121, -1), (185, 1), (118, -1), (182, 1), (122, 1), (186, -1), (213, -1), (229, 1), (217, 1), (233, -1), (214, 1), (230, -1), (218, -1), (234, 1), (213, 1), (229, -1), (217, -1), (233, 1), (214, -1), (230, 1), (218, 1), (234, -1)]
def prod2 : Poly := [(171, -1), (203, 1), (179, 1), (211, -1), (173, 1), (205, -1), (181, -1), (213, 1), (47, -1), (79, 1), (55, 1), (87, -1), (174, 1), (206, -1), (182, -1), (214, 1), (47, 1), (79, -1), (55, -1), (87, 1), (174, -1), (206, 1), (182, 1), (214, -1), (59, -1), (91, 1), (61, 1), (93, -1), (186, 1), (218, -1), (188, -1), (220, 1), (59, 1), (91, -1), (61, -1), (93, 1), (186, -1), (218, 1), (188, 1), (220, -1), (107, -1), (115, 1), (109, 1), (117, -1), (234, 1), (242, -1), (236, -1), (244, 1), (107, 1), (115, -1), (109, -1), (117, 1), (234, -1), (242, 1), (236, 1), (244, -1), (171, 1), (203, -1), (179, -1), (211, 1), (173, -1), (205, 1), (181, 1), (213, -1)]
def A : List (List Int) :=
  [[-1, 1, 0, 0, 0, 0, 0],
   [1, -1, 0, 0, 0, 0, 0],
   [0, 0, 0, 0, 0, 0, 0],
   [0, 0, 0, 0, 0, 0, 0],
   [0, 0, 0, 0, -1, 0, 0],
   [0, 0, 0, 0, 1, 0, 0],
   [0, 0, 0, -1, 0, 1, 0]]
def B : List (List Int) :=
  [[0, 0, 0, 1, 0, 0, 0],
   [-1, 0, 0, 0, 0, 0, 0],
   [1, 0, 0, 0, 0, 0, 0],
   [0, 0, 1, 0, 0, 0, 0],
   [0, 0, -1, 0, 0, 0, 0],
   [0, 0, 0, 0, 0, 0, 1],
   [0, 0, 0, 0, 0, 0, -1]]
/-- columns of W(λ) (the adjugate of A + λB) -/
def WT (lam : Int) : List (List Int) :=
  [[(0), (0), (0), (-1) * lam ^ 3, (0), (-1) * lam ^ 3, (0)],
   [(0), (1) * lam ^ 4, (0), (-1) * lam ^ 3, (0), (-1) * lam ^ 3, (0)],
   [(-1) * lam ^ 3, (1) * lam ^ 4 + (-1) * lam ^ 3, (0), (-1) * lam ^ 3, (0), (-1) * lam ^ 3, (0)],
   [(0), (0), (-1) * lam ^ 3, (0), (1) * lam ^ 4, (-1) * lam ^ 4, (-1) * lam ^ 3],
   [(0), (0), (0), (0), (1) * lam ^ 4, (-1) * lam ^ 4, (-1) * lam ^ 3],
   [(0), (0), (0), (0), (0), (-1) * lam ^ 4, (-1) * lam ^ 3],
   [(0), (0), (0), (0), (0), (-1) * lam ^ 4, (0)]]

/-! ### Kernel-checked computations -/
theorem p1_nf : p1 = p1nf := by decide +kernel
theorem p2_nf : p2 = p2nf := by decide +kernel
theorem prod1_eq : mul hyperplane p1nf = prod1 := by decide +kernel
theorem prod2_eq : mul hyperplane p2nf = prod2 := by decide +kernel
theorem prod1_zero : isZero prod1 = true := by decide +kernel
theorem prod2_zero : isZero prod2 = true := by decide +kernel
theorem rows1 : rowsOf p1nf = A := by decide +kernel
theorem rows2 : rowsOf p2nf = B := by decide +kernel

/-- The hyperplane equation kills p₁. -/
theorem kills_p1 : isZero (mul hyperplane p1) = true := by rw [p1_nf, prod1_eq]; exact prod1_zero
/-- The hyperplane equation kills p₂. -/
theorem kills_p2 : isZero (mul hyperplane p2) = true := by rw [p2_nf, prod2_eq]; exact prod2_zero
/-- The block of L ↦ L·p₁ is A. -/
theorem block_p1 : rowsOf p1 = A := by rw [p1_nf]; exact rows1
/-- The block of L ↦ L·p₂ is B. -/
theorem block_p2 : rowsOf p2 = B := by rw [p2_nf]; exact rows2

/-- **Polynomial identity, every integer λ:** (A + λB) · W(λ) = -λ⁴ · I. -/
theorem block_invertible (lam : Int) :
    matMul (matAdd A (matSmul lam B)) (WT lam) = scalar (-(lam ^ 4)) := by
  simp [matMul, matAdd, matSmul, dot, scalar, A, B, WT, List.range, List.range.loop]
  <;> grind

def lams : List Int :=
  [-10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
/-- (A + λB) · W(λ) = -λ⁴ · I for 1 ≤ |λ| ≤ 10. -/
theorem block_invertible_finite : ∀ lam ∈ lams,
    matMul (matAdd A (matSmul lam B)) (WT lam) = scalar (-(lam ^ 4)) := by decide +kernel

/-- The scalar in the identity is nonzero whenever λ ≠ 0, so A + λB is invertible over ℚ. -/
theorem scalar_ne_zero (lam : Int) (h : lam ≠ 0) : -(lam ^ 4) ≠ 0 := by
  have h4 : lam ^ 4 ≠ 0 := Int.pow_ne_zero h
  omega

/-! ## Lattice numerics (plain arithmetic)

Intersection numbers on a cubic sixfold: h³·h³ = 3, h³·P = 1, P·P = -5, P₁·P₂ = 1 (planes meeting
in a point).  For a = P₁ + P₂: h³·a = 2, a·a = -8.  A rational normal quartic scroll threefold
T = S(1,1,2) (a P²-bundle over P¹) has Chern numbers H³=4, H²c₁=10, Hc₁²=24, Hc₂=10, c₁³=54,
c₁c₂=24, c₃=6, and for a smooth threefold in a cubic sixfold
T·T = 17H³ - 13H²c₁ + 5(Hc₁² - Hc₂) - c₁³ + 2c₁c₂ - c₃. -/

/-- self-intersection of the quartic scroll in a cubic sixfold -/
theorem scroll_self_intersection :
    (17 * 4 - 13 * 10 + 5 * (24 - 10) - 54 + 2 * 24 - 6 : Int) = -4 := by decide

/-- 2h³ - (P₁+P₂) has degree 4 and self-intersection -4, the numbers of the scroll -/
theorem class_match :
    (2 * 3 - 2 : Int) = 4 ∧ (4 * 3 - 4 * 2 + (-8) : Int) = -4 := by decide

/-- the rank-2 lattices ⟨h³, P₁+P₂⟩ and ⟨h³, T⟩ have the same discriminant -28 -/
theorem discriminant_match :
    (3 * (-8) - 2 * 2 : Int) = -28 ∧ (3 * (-4) - 4 * 4 : Int) = -28 := by decide

end HodgeCert
