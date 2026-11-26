# Blind check 12 — report

(Saved by the main session from the checker's hand-back, verbatim: the checker's own attempt to write this file
was refused by its tool, and it did not route around that.)

Checker's own code only. Not read: `mx4_pipeline.py`, `mx2_split.py`, `mx3_extend_arc.m2`, `PREREG_matrices.md`,
the logs, the registry. `B_own.py` was NOT used (not read); the period functional was derived from scratch (below).
Nothing in `/home/claude/hodgelocici` was written, committed or pushed (git status there already showed
`M leads/TENFOLD_TWODET_LEAD.md` and untracked `leads/tenfold_twodet/matrices/`; not from this check).
Nothing here is a proof or a disproof of the Hodge conjecture; all statements are computations with the labels given.

Scripts (all in this folder): `c1_own.py` (exact, own), `c1_pkg.m2` (package call), `c2_num.py` (multiprecision,
python-flint acb, 900 bits), `c3_extra.py`, `c4.m2` (Macaulay2, ZZ/32003 and QQ). Outputs: `c1_own.out`,
`c1_pkg.out`, `c2_eps{800,100,64,40}.out`, `c2_eps800_c5.out`, `c3_extra_{800,100}.out`, `c4.out`.
Compute used: about 10 minutes of CPU in total; longest single run 138 s.

## Verdicts

| claim | verdict | label | key numbers |
|---|---|---|---|
| C1(a) | CONFIRMED to order 19 | EXACT (assumes period formula + Griffiths pole order) | own code: all 8 x 19 Taylor coefficients are 0; package `fermatExpansion(P, arc, 19)`: 8 x 19 zero matrix |
| C1(b) | CONFIRMED | EXACT | T_1..T_7 identical; certificate T_8 = 0, arc T_8 = ((7193456/59049) z - 4309964/19683) x0 x6 x7; both coefficients of T_9 differ |
| C1(c) | CONFIRMED | EXACT | 9 distinct monomials in T_1..T_19, none with y5 |
| C2(a) | CONFIRMED (wording slightly loose) | NUMERICAL | 12 values 113..527; 6 values 13.94 eps^2 (x4), 75.6..77.2 eps^2 (x2); 17 truncation-level values + 1 exact zero |
| C2(b) | CONFIRMED | EXACT (y5^2) / NUMERICAL | 4th singular value 2.651e-8 at eps = 1/100; it is 0.0265 eps^3 |
| C2(c) | CONFIRMED for GA; for GB REFUTED at eps = 1/100, holds only at 1/800 | NUMERICAL | at eps = 1/100, 1/64, 1/40 GB shows 9 values at the noise level (9th/8th = 1.12, 1.15, 1.14) |
| C2(d) | numbers CONFIRMED; reading: fair for GA, weakly supported for GB | NUMERICAL | GA 9th 5.160e-28, GB 9th 1.804e-38 (ratio to 8th: 7.6e12 and 459) |
| C3 | numbers CONFIRMED; interpretation needs a correction | NUMERICAL | 8.118e-20, 5.170e-11, 1.192e-9, 4.740e-5; minors 4.927e-21; but \|det A - GA\| = 8.1 \|F_eps\| |
| C4 | CONFIRMED | EXACT over QQ, MOD p = 32003 | 8 / 9 / 12; general cubic 0; det A + det B 0 |
| C5 | argument sound; hypothesis NOT what C2(c) supports; for GB untested | ARG + EXACT example + NUMERICAL | cubics killed by the algebra: dimension 1; for GB my Killing-form test is inconclusive |

## C1

Own implementation (`c1_own.py`, python-flint `fmpq_mpoly`, exact over QQ(z), z^2 = z - 1).
- Functional of a linear space P (x_a = z^e x_b on the pairs): on squarefree quartics it kills every monomial
  containing both indices of a pair and satisfies lambda(y_a m) = z^e lambda(y_b m) (the apolar ideal contains the
  linear forms of P and the Jacobian ideal). Relative constant of P2 against P1 = z^2, from the automorphism of
  the Fermat cubic carrying P1 to P2 (permutation of sign +1 times a diagonal matrix of determinant z^4). One
  overall constant is left free; against the data file it is -81 z.
- Expansion: int y_i Omega/F_eps^3 = 9 Lam(y_i exp(S/3)), int Q Omega/F_eps^4 = Lam(Q exp(S/3)), with
  Griffiths-Dwork reduction on the Fermat cubic written out by hand. Same mathematics as the package, separate code.
- Result: the 8 periods vanish at orders 1..19 (EXACT). Negative controls: adding (1/1000) x0 x1 x3 to T_3, T_12,
  T_19 gives a first non-zero coefficient at exactly order 3, 12, 19.
- Bonus (EXACT): my code reproduces `periods_deg4_order19.txt` completely: 330 quartics x orders 0..19 = 6600
  entries, 0 mismatches, up to the single constant -81 z. So the input of C2/C3 is independently confirmed.
- Package (`c1_pkg.m2`): `fermatExpansion(P, arc, 19)` is the zero 8 x 19 matrix (138 s); perturbing T_19 makes
  only column 19 non-zero.
- Not checked: orders above 19 (no data); the two standing assumptions (period formula for linear spaces,
  pole-order description of the Hodge locus); convergence of the arc.

## C2 (eps = 1/100, 1/800, 1/64, 1/40; singular values via Gram-matrix eigenvalues at 900 bits)

(a) eps = 1/100: 12 largest 525.6 .. 113.9; next six 7.720e-3, 7.555e-3, 1.395e-3 (x4) = 77.2, 75.6, 13.94 eps^2;
last 18: 2.87e-30 .. 2.1e-37 and one exact zero (2.7e-134 = rounding, the y5^2 direction).
Across the four eps the 6 largest of the small ones are c eps^20 with c = 2.9e10, 2.9e10, 3.4e9, 3.4e9, 9.4e8,
1.1e8 (constant in eps); the other 11 fall like eps^22. Truncating the series after order 18 / 17 at eps = 1/800
moves the largest of them from 2.5e-48 to 1.1e-45 / 5.9e-44 while the 18 large values do not move: they are
truncation artifacts, as claimed. Wording: "18 falling like eps^20" is 6 like eps^20, 11 like eps^22, 1 exactly 0;
"100..500" is 113..527.

(b) All 36 quartics divisible by y5^2 have identically zero series in the file (EXACT; also forced by C1(c)).
144 x 120 system, smallest singular values at eps = 1/100: 2e-135 (y5^3, exact), 8.7e-33, 1.8e-29, then
2.651e-8, 8.3e-8 (largest 2.0). Fourth value at 1/40, 1/64, 1/100, 1/800: 4.14e-7, 1.011e-7, 2.651e-8, 5.178e-11
= 0.0265 eps^3, unchanged to 4 digits under truncation at 18 or 17. Genuine, but it tends to 0 with eps.
F_eps: relative distance from the 3-space 3.2e-23 (1/100), 1.1e-37 (1/800); y5^3: 0.

(c) GA, GB (json): relative distance from my 3-space 3.6e-27 (1/100), 3.4e-42 (1/800); GA + GB = F_eps to
4.6e-61 |GA| (json precision); |GA| eps^6 = |GB| eps^6 = 1078.447 (1/800), 1078.479 (1/100), 1078.528 (1/64),
1078.669 (1/40). Random member of the 3-space: smallest relative singular value of the Lie map 0.19..0.24 (none).
Lie map, 8th and 9th smallest relative singular values (relative = divided by the largest):

| eps | GA 8th | GA 9th | GB 8th | GB 9th | GB 10th |
|---|---|---|---|---|---|
| 1/40 | 4.5e-20 | 1.320e-17 | 1.85e-20 | 2.105e-20 | 2.3e-19 |
| 1/64 | 1.7e-23 | 3.075e-19 | 2.67e-24 | 3.083e-24 | 2.1e-21 |
| 1/100 | 1.9e-26 | 8.656e-21 | 6.53e-27 | 7.336e-27 | 2.4e-23 |
| 1/800 | 6.8e-41 | 5.160e-28 | 3.93e-41 | 1.804e-38 | 2.3e-32 |

My values agree with the json lists to all printed digits. GA: 8 at the noise level at every eps.
GB: at 1/100 (the eps named in the claim), 1/64 and 1/40 there are NINE values at the noise level; the json's own
`lie_dims` is [8, 9] there and [8, 8] only at 1/800. So "each has 8 (8 singular values at the noise level)" is
REFUTED as a statement about GB at eps = 1/100 and holds for GB only at eps = 1/800.

(d) Numbers confirmed (1.8044e-38, 5.1597e-28).
- GA: 9th = 8.7e-5 eps^8 at all four eps (fitted exponent 8.0 on each interval). "About eps^8" is right as a law;
  numerically 5.2e-28 = eps^9.4 at 1/800 because of the prefactor. "Exactly 8" is a fair reading for GA.
- GB: 9th = 0.99 eps^13 at 1/800, the only eps where it is resolved (factor 459). The law eps^13 rests on that
  one point (the other three are noise-limited, though compatible). My extra test: with the series truncated after
  order 18 / 17 and GB projected to the recomputed 3-space, the 9th stays 1.8044e-38 / 1.77e-38 while the
  truncation-sensitive values move by factors 40..7e4 (8th: 3.9e-41 -> 3.9e-41 -> 3.3e-39). So 1.8e-38 is not a
  truncation artifact; a perturbation of GB of relative size of order 1e-39 cannot remove it.
- What else the numbers allow: (i) the 9th..14th values of GB are 1.8e-38, 2.3e-32, 9.6e-30, 1.2e-29, 6.0e-25,
  9.8e-25, so the Lie map is that close to a kernel of dimension 9..14; all 20 listed values tend to 0 with eps
  for both summands, which suggests that GA eps^6 and -GB eps^6 tend to one common cubic with at least 20 fields.
  "Exactly 8" is a statement for fixed eps != 0 and is numerically fragile for GB. (ii) Eight fields do not make
  GB a determinant: no matrix B exists in any of the four json files ("B": null), and the sl_3 structure of GB's
  fields is untested (see C5). (iii) Uniqueness of the pair (GA, GB) inside the 3-space was not examined.

## C3

|det A - GA| / |GA| = 8.118e-20 (1/800), 5.170e-11 (1/100), 1.192e-9 (1/64), 4.740e-5 (1/40): CONFIRMED.
Minors: relative distance from the kernel max 4.927e-21 at 1/800 (2.2e-12, 8.6e-11, 8.3e-7 at the others);
independent but ill-conditioned (smallest normalised singular value 7.5e-8 at 1/800, 4.8e-6 at 1/100).
Entries: the 9 x 8 coefficient matrix has rank 8, but singular values from 5.3e-12 to 6.6e21 at 1/800 (A is very
badly scaled); the relation matrix C has singular values (2.2e-3, 3.9e-3, 1): rank 3. det A itself has 8 exact
fields (1e-136) and the same 9th value 5.160e-28 as GA.

Correction to the interpretation (`c3_extra.py`): in absolute terms |det A - GA| = 22.95 at eps = 1/800 while
|F_eps| = 2.83 (ratio 8.1; at 1/100 the ratio is 2.0e4). Hence |det A + GB| / |GB| = 8.2e-20 as well: the quoted
figure does not distinguish GA from -GB = GA - F_eps. What does distinguish them: the part of det A - GA outside
the tangent space of the GL_8-orbit of GA is 1.4e-40 |GA| at 1/800 (3.7e-26 |GA| at 1/100), i.e. at the noise
level, with an 8 x 8 matrix X of norm 2.5e-11; for F_eps the same quantity is 1.83 out of 2.83. So the supported
statement is "det A is, to first order and within noise, a linear change of coordinates of GA", not "det A = GA
to 20 digits". This is a linearised test only; no non-linear fit was done.

## C4 (`c4.m2`)

Random examples with entries spanning the 8 forms and one relation tr(C B) = 0: rank C = 3, 2, 1 gives 8, 9, 12
(6 examples each MOD 32003; 2 each and the three normal forms EXACT over QQ). Since every such B is the generic
3 x 3 matrix restricted to the hyperplane tr(C X) = 0, and C can be brought to normal form, the QQ runs settle each
rank class. General cubic: 0 (5 MOD p, 2 over QQ). det A + det B: 0 for ranks (3,3), (3,2), (2,2), (1,1), (3,1).
By semicontinuity one example with 0 gives "general has none". Extra: det A + (linear form)^3 has 2 fields.

## C5

Argument: sound. Exact check over QQ: the 8 fields of det on traceless matrices have Killing form of rank 8 and
kill exactly one cubic, one quadric, no linear form; same for a random rank-3 example. (Rank 2: 9 fields, Killing
rank 5; rank 1: 12 fields, Killing rank 8; each still kills only one cubic.) A semisimple algebra of dimension 8
is sl_3 and its only irreducible 8-dimensional representation is the adjoint one.
Hypothesis versus data: C2(c) gives only the number 8. Needed in addition: semisimple, and irreducible on the forms.
- det A (exact determinant of the json A), eps = 1/800: brackets close to 1e-220, Killing singular values
  2.8e-20 .. 1 (non-degenerate), commutant of dimension 1 (next value 1.7e-10): sl_3, adjoint. For GA this comes
  from C3 and C4 directly, so C5 adds nothing for GA.
- GB, eps = 1/800: brackets close only to 1.1e-7, Killing singular values 3.1e-30 .. 1.1e-14; the two smallest are
  below the error level, so non-degeneracy is NOT established. INCONCLUSIVE. The hypothesis of C5 is not supported
  by the data for GB.

## C6: overstated, or open to another reading

1. C2(c): "each has 8" fails for GB at eps = 1/100, 1/64, 1/40 (nine at the noise level).
2. C2(d): GB's eps^13 is one resolved point; GA's "eps^8" is a law with prefactor 8.7e-5.
3. C3: the quoted relative error is larger than |F_eps| / |GA| (1.0e-20 at 1/800); see the correction above.
4. "F_eps = det A + det B": only the first summand has a matrix. For GB the data show 8 fields at one eps and
   nothing about determinantal form.
5. Everything in C2, C3 is finite-precision evidence at four values of eps from a series truncated at order 19;
   none of it is an identity in eps. As eps -> 0 the two summands look like +-1078.4 eps^-6 times one common cubic.

## Not checked

Orders beyond 19; uniqueness of (GA, GB) in the 3-space; a non-linear fit of A; any construction of B; whether the
exact (untruncated) catalecticant has rank exactly 18; values of eps other than the four above for GA, GB (they
come from the json); the registry entries.
