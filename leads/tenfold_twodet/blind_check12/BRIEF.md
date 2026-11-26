# Blind check 12: the extended sixfold arc and the splitting of the class along it

You are an independent checker. Do NOT read `leads/tenfold_twodet/matrices/mx4_pipeline.py`,
`mx2_split.py`, `mx3_extend_arc.m2`, `PREREG_matrices.md` or the logs in `leads/tenfold_twodet/matrices/logs/`
before you have your own results: write your own code. You may read the data files named below, the package
`M2/HodgeLociCI` (Macaulay2 1.22 is installed: `M2`), `/home/claude/blind_check10/B_own.py` (an earlier
checker's exact implementation of the Fermat period formula; say so if you use it), and the registry
`discoveries/registry.yaml` (entries D-DEGENERATION-ALONG-ARC, O-RECOVER-MATRICES-AND-LIMIT-OF-T,
D-TWO-DET-FAMILY-NUMBERS). Repository root: /home/claude/hodgelocici. Work in /home/claude/blind_check12.
Python 3 with mpmath, numpy, sympy, python-flint is available. Two cores, so keep each run under ~8 minutes;
total budget about 25 minutes of wall-clock. Do not commit, push or change anything in the repository.
Rules of the project: never call anything a proof or disproof of the Hodge conjecture, never use the word
"counterexample"; label every statement EXACT / MOD p / NUMERICAL / ARG / OPEN; "ruled out" means only what
you tested.

## Setting

Fermat cubic sixfold y0^3 + ... + y7^3, z = zeta_6 (z^2 = z - 1). Two 3-planes
P1: y0 = z y1, y2 = z y3, y4 = z y5, y6 = z y7;  P2: y1 = z^3 y2, y3 = z^3 y4, y0 = z^3 y5, y6 = z^3 y7
(package notation L1 = {{0,1,1},{2,3,1},{4,5,1},{6,7,1}}, L2 = {{1,2,3},{3,4,3},{0,5,3},{6,7,3}}).
Class [P1] - [P2]. Arc F_eps = sum y_i^3 - sum_{n>=1} eps^n T_n.
Data (in `leads/tenfold_twodet/matrices/`):
- `arc_true_order19.txt`: T_1..T_19, one per line, polynomials in x_0..x_7 (= y0..y7) and z.
- `periods_deg4_order19.txt`: for each of the 330 quartic monomials (exponent vector), the Taylor coefficients
  (orders 0..19) of the period of [P1] - [P2] along the arc; "a b" means a + b z.
- `results/mx4_eps800.json`, `mx4_eps100.json`, `mx4_eps64.json`, `mx4_eps40.json`: at eps = 1/800 etc.:
  "F", "GA", "GB": cubics as 120 coefficients [re, im] on the monomials y_i y_j y_k, i <= j <= k, in the order of
  itertools.combinations_with_replacement(range(8), 3); "A": a 3 x 3 matrix of linear forms, A[i][j][k] =
  coefficient of y_k; "lie_singular_values_A/B": the 20 smallest singular values (relative) of the map
  (8 x 8 matrices L) -> sum L_ij y_i dG/dy_j.
- the exported certificate `M2/HodgeLociCI/data/six_lam-1_arc.txt` (eightfold variables; x6 = x7 = 0 and
  x8, x9 -> y6, y7 give the sixfold arc).

## Claims to check (give for each: CONFIRMED / REFUTED / NOT CHECKED, with your numbers)

C1 (EXACT). (a) Along `arc_true_order19.txt` the Hodge-locus equations of [P1] - [P2] hold to order 19:
the matrix that the package function `fermatExpansion(P, arc, 19)` returns (8 rows, 19 columns: the Taylor
coefficients of the 8 period functions) is zero. Check to as high an order as your own means allow, and say
which implementation you used. (b) T_1..T_7 are the first seven terms of the certificate arc; T_8 and T_9
differ from the certificate's. (c) No monomial of the arc contains y5.
C2 (NUMERICAL, multiprecision). With lambda_eps = the functional on quartics given by the period series summed
at a rational eps (take eps = 1/100, and one more of your choice <= 1/40):
 (a) the 36 x 36 catalecticant (lambda(m_a m_b)) has 12 singular values of size 100..500, 6 of size about
     14 eps^2 .. 78 eps^2, and 18 at the truncation level (falling like eps^20);
 (b) y5^2 is in its kernel exactly; the space of cubics G all of whose 8 partial derivatives lie in the kernel
     (the 18 small singular vectors) is 3-dimensional at the truncation level and contains y5^3 and F_eps;
     the next singular value of that 144 x 120 system is a genuine small number (about 2.65e-8 at eps = 1/100);
 (c) "GA" and "GB" of the json lie in that space, GA + GB = F_eps, |GA| eps^6 = |GB| eps^6 = 1078.5 (Euclidean
     norm of the 120 coefficients); each has 8 linear vector fields killing it (8 singular values at the noise
     level) while a general member of the 3-dimensional space has none;
 (d) at eps = 1/800: for GB the 9th smallest singular value is 1.8e-38 (about eps^13), above the noise;
     for GA the 9th is 5.2e-28 (about eps^8). Is "both summands have exactly 8 vector fields" a fair reading?
     State what else the numbers would allow.
C3 (NUMERICAL). The json matrix "A": |det A - GA| / |GA| = 8.1e-20 at eps = 1/800 (5.2e-11 at 1/100, 1.2e-9
 at 1/64, 4.7e-5 at 1/40); its nine 2 x 2 minors lie in the kernel of the catalecticant (relative distance
 4.9e-21 at 1/800) and are linearly independent; its nine entries span the 8 linear forms.
C4 (ARG; check by exact computation on examples, e.g. over QQ or ZZ/32003 in Macaulay2). For a 3 x 3 matrix B
 of linear forms in 8 variables whose entries span all 8 forms, with the one relation tr(C B) = 0: the space of
 8 x 8 matrices L with sum L_ij y_i d(det B)/dy_j = 0 has dimension 8 if rank C = 3, 9 if rank C = 2, 12 if
 rank C = 1. Also: a general cubic in 8 variables has none, and a general sum det A + det B has none.
C5 (ARG). If the 8 vector fields of a cubic G in 8 variables form a Lie algebra isomorphic to sl_3 acting on
 the linear forms by the adjoint representation, then G is a constant multiple of a determinant of the kind in
 C4 with rank C = 3 (because the invariant cubics of the adjoint representation of sl_3 form a line). Is the
 argument sound? Is its hypothesis what C2(c) and C3 support?
C6. Anything in C1..C5 that is overstated, and anything the data are equally consistent with.

Write your report to /home/claude/blind_check12/REPORT.md (verdict per claim, numbers, your scripts' names,
what you did not check) and keep your scripts in that folder. Finish with a short summary as your final answer.
