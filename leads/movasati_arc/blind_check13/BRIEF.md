# Blind check 13: an arc at the eightfold (and tenfold) Movasati point in a direction that is not a cone

You are an independent checker. Do NOT read `leads/movasati_arc/ma2_slice_arc.m2`, `ma1_probe.m2`,
`ma3_cone_to_tenfold.m2`, `PREREG_arc.md` or the logs in `leads/movasati_arc/logs/` before you have your own
results. You may read the data files named below, the package `M2/HodgeLociCI` (Macaulay2 1.22: `M2`; you may
call its functions as a black box for period expansions, but the logic of any test must be your own), and
`/home/claude/blind_check12/c1_own.py` (an earlier checker's own exact implementation of the Fermat period
formula for sixfolds; you may adapt it; say so). Repository root: /home/claude/hodgelocici. Work only in
/home/claude/blind_check13. Do not write, commit or push anything in the repository. Two cores, shared with other
jobs: keep each run under about 8 minutes (use `timeout`), about 25 minutes of wall-clock in total; if something
does not fit, do a smaller version and say so. Rules of the project: never call anything a proof or disproof of
the Hodge conjecture; never use the word "counterexample"; label every statement EXACT / MOD p / ARG / OPEN;
"ruled out" means only what you tested. Return your report as your final answer (you cannot write REPORT.md
yourself; the text you return will be saved).

## Setting

Fermat cubic eightfold x_0^3 + ... + x_9^3, z a primitive 6th root of unity (z^2 = z - 1). Movasati's pair of
4-planes: P1 = {x_(2i) = z x_(2i+1), i = 0..4}; P2 = {x_(2i) = z^3 x_(2i+1) for i = 0, 1, 2; x_(2i) = z x_(2i+1)
for i = 3, 4}. They meet in the line with coordinates x_7, x_9. Package notation:
L1 = apply(5, i -> {2*i, 2*i+1, 1}), L2 = apply(5, i -> {2*i, 2*i+1, if i < 3 then 3 else 1}),
P = fermatPeriodPolynomial(S, L1) + lam * fermatPeriodPolynomial(S, L2) with S = fermatRing(3, 8, p).
An arc is F_eps = sum x_i^3 - sum_{n >= 1} eps^n T_n, the T_n cubics modulo the squares x_i^2.
First order: 45 equations, rank 19; the locus V where both planes persist has codimension 20; the excess
direction is a cubic y_0 in x_0..x_5. Deformations tangent to V modulo the rest are "nets": sum N_ijk f_i h_j
x_(7+2k) with f_i = x_(2i) - z x_(2i+1), h_i = x_(2i) - z^3 x_(2i+1), i, j = 0, 1, 2, k = 0, 1, i.e. two 3 x 3
matrices A (k = 0, with x_7) and B (k = 1, with x_9).

Data, in `leads/movasati_arc/arcs/` (all MOD p; z is a number mod p, the one `fermatRoot S` returns):
- `arc8_32029_seed1_lam-1_d.txt`: p = 32029, lambda = -1. Line 1 comment, line 2 a list of indices, line 3 a
  26 x 7 matrix D, then T_1, ..., T_8, one per line (polynomials in x_0..x_9 with integer coefficients mod p).
- `arc8_31981_seed2_lam-1_d.txt`: p = 31981, another direction, lambda = -1, T_1..T_7.
- `arc8_32029_seed1_lam2_d.txt`, `arc8_31981_seed2_lam2_d.txt`: lambda = 2, T_1..T_5 (its own y_0, same nets).

## Claims

C1 (MOD p). Along the arcs for lambda = -1 the 45 Hodge-locus equations of [P1] - [P2] vanish to order 8
 (p = 32029) and 7 (p = 31981): `fermatExpansion(P, arc, N)` is the zero matrix. Check with code of your own if
 you can (to the order that fits; say which), and in any case with the package. T_1 is in the kernel of the
 first-order map of [P1] - [P2] and is not tangent to the locus where P1 persists. The same arc is not an arc
 for [P1] + [P2].
C2 (MOD p). The part of T_1 tangent to V has a net with both A and B non-zero, of rank 2 each, with a common
 kernel and a common cokernel, and the two 2 x 2 blocks are orthogonal for the polar form of the determinant
 (so the y_1 y_2-coefficients of all 2 x 2 minors of A y_1 + B y_2 vanish). So the direction is not of the
 form "x_7 times one matrix": the arc is not a cone over an arc of a sixfold.
C3 (MOD p). For lambda = 2 (files above, with T_1 of the same kind): no arc with that T_1 passes order 6 inside
 a slice of the following kind: T_n, n >= 2, in the span of 19 monomials on which the first-order map has rank
 19 plus 7 net directions on which the order-5 response map is injective. (My run: order 5 is repaired by the
 free part of T_2, then the order-6 obstruction is not in the image of the 26 x 7 response matrix.)
 Test this in your own way; a stronger and cleaner test, if it fits: with T_1 fixed, is there ANY choice of
 T_2, T_3, ... in the full space of cubics for which orders 2..6 hold? If you can only do part of it, say which.
C4 (ARG). My reading of C3: if a component W of the Hodge locus of [P1] + 2 [P2] of dimension dim V - 6 passed
 through the point with a reduced tangent cone containing T_1 as a smooth point, there would be an arc with
 tangent T_1 in a general linear slice of dimension codim W + 1 = 27 through T_1, with integer powers of eps;
 so the obstruction excludes such a component (finite order, one direction, MOD p), and does not exclude
 smaller components or arcs with fractional powers. Is that reading sound? Is "the order-n obstruction of the
 dependent equations is affine-linear in the free part of T_(n-3), with the same matrix for every n" sound?
C5 (MOD p). The eightfold arc for lambda = -1, read as an arc of the Fermat cubic TENFOLD (variables x_10, x_11
 untouched), satisfies the tenfold's own 221 equations for the pair of 5-planes
 L1 = apply(6, i -> {2*i, 2*i+1, 1}), L2 = apply(6, i -> {2*i, 2*i+1, if i < 3 then 3 else 1}), class
 [P1] - [P2], to the same order (at least check order 6 or 7; `fermatRing(3, 10, p)`).
C6. Anything overstated, and anything the data are equally consistent with.

For each claim: CONFIRMED / REFUTED / NOT CHECKED, your numbers, the label, what you did not check.
Final answer: the full report text (it will be saved as REPORT.md), starting with a summary of at most 300 words.
