/-!
# Arithmetic behind the lattice filter (cubic sixfolds)

Lean 4 core only. Plain integer arithmetic, checked by the kernel. The geometric meaning of each
number is classical and NOT formalized here.

Intersection numbers on a cubic sixfold X ⊂ P⁷: h³·h³ = 3, h³·P = 1, P·P = -5 for a 3-plane P, and
P₁·P₂ = 1 for two 3-planes meeting in a point.  For a smooth threefold T ⊂ X with hyperplane class H:
  T·T = 17H³ - 13H²c₁ + 5(Hc₁² - Hc₂) - c₁³ + 2c₁c₂ - c₃.
-/
namespace HodgeCert

/-- self-intersection of a smooth threefold in a cubic sixfold from its Chern numbers -/
def selfInt (H3 H2c1 Hc1sq Hc2 c1cube c1c2 c3 : Int) : Int :=
  17 * H3 - 13 * H2c1 + 5 * (Hc1sq - Hc2) - c1cube + 2 * c1c2 - c3

/-- discriminant of the rank-2 lattice spanned by h³ and a class of degree `t`, self-intersection `s` -/
def disc (t s : Int) : Int := 3 * s - t * t

/-- discriminant of ⟨h³, rP₁ + sP₂⟩ for two 3-planes meeting in a point -/
def discPlanes (r s : Int) : Int := 3 * (-5 * r * r + 2 * r * s - 5 * s * s) - (r + s) * (r + s)

/-- sanity: a 3-plane has self-intersection -5, a cubic threefold section has 3 -/
theorem plane_and_section :
    selfInt 1 4 16 6 64 24 4 = -5 ∧ selfInt 3 6 12 12 24 24 (-6) = 3 := by decide

/-- quartic scroll S(1,1,2): degree 4, self-intersection -4, same lattice as P₁ + P₂ -/
theorem quartic_scroll :
    selfInt 4 10 24 10 54 24 6 = -4 ∧ disc 4 (-4) = discPlanes 1 1 := by decide

/-- quintic del Pezzo threefold V₅: degree 5, self-intersection -1, same lattice as P₁ + P₂ -/
theorem quintic_del_pezzo :
    selfInt 5 10 20 12 40 24 4 = -1 ∧ disc 5 (-1) = discPlanes 1 1 := by decide

/-- sextic del Pezzo threefold P(T_P²): degree 6, self-intersection 0, same lattice as P₁ - P₂ -/
theorem sextic_del_pezzo :
    selfInt 6 12 24 12 48 24 6 = 0 ∧ disc 6 0 = discPlanes 1 (-1) := by decide

/-- P¹×P¹×P¹ has discriminant -42, which is not `discPlanes r s` for any |r|,|s| ≤ 12
    (and cannot be for larger values, since -discPlanes r s ≥ 14·max(r²,s²)) -/
theorem segre_cube_no_match :
    selfInt 6 12 24 12 48 24 8 = -2 ∧
    ((List.range 25).all fun i => (List.range 25).all fun j =>
      discPlanes ((i : Int) - 12) ((j : Int) - 12) != disc 6 (-2)) = true := by decide

/-- A cubic fivefold containing the quartic scroll has 14 nodes:
    c₃(N^∨(3)) = -c₃(N) + 3·c₂(N)H - 9·c₁(N)H² + 27H³ with c₃(N)=16, c₂(N)H=28, c₁(N)H²=18, H³=4.
    A cubic fivefold containing a 3-plane has 8 (three quadrics in P³). -/
theorem node_counts : (-16 + 3 * 28 - 9 * 18 + 27 * 4 : Int) = 14 ∧ (2 * 2 * 2 : Int) = 8 := by decide

end HodgeCert
