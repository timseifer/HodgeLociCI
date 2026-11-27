# Blind check 16: coefficient scan at Movasati's point, the lattice tie, and a Coble / two-determinant argument

Independent checker. Repository /home/claude/hodgelocici (read-only for you; work in /home/claude/blind_check16).
Do NOT read leads/movasati_arc/logs/ma4_*_g_scan.log or sections 9.8 of leads/TENFOLD_TWODET_LEAD.md and 18 of
leads/TENFOLD_COBLE_LEAD.md before you have your own results. Previous checkers' code you may use:
leads/movasati_arc/blind_check14/own/ (python-flint full-space test at order 6: fs.py, run_fs.py) and
blind_check15/. Two shared cores; runs under ~9 minutes, ~35 minutes in total. Never call anything a proof or
disproof of the Hodge conjecture; never use the word "counterexample"; label EXACT / MOD p / ARG / OPEN. Return the
full report as your final answer (summary <= 250 words first).

C1 (MOD p). Eightfold Movasati point, net g (A = G F1 H, B = G F2 H, as in blind check 14's report), y_0 the excess
 direction for each lambda (for lambda other than -1 and 2 you must construct it: a cubic in x_0..x_5 in the kernel of
 the first-order map of [P1] + lambda [P2] and not in that of [P1]; say how you chose it). Claim: in the FULL space,
 no T_2..T_6 passes order 6 for lambda = 3 and lambda = 1/2 (test at least these two at p = 32029); for lambda = 1
 orders 2..6 are solvable. Test with your full-space method; report what you could do.
C2 (EXACT arithmetic + ARG). With f(m) = (1 - (-2)^(m+1))/3 as the intersection number of two 4-planes of a smooth
 cubic eightfold meeting in a P^m (so P.P = 11, P1.P2 = -1 for a line), h^4.P = 1, h^8 = 3, the lattice
 <h^4, r P1 + s P2> has determinant 2 (16 r^2 - 4 r s + 16 s^2); half of it takes the values 28 and 36 only at
 (r, s) = +-(1, 1), +-(1, -1) among coprime pairs with s != 0. Check the formula f(m) for m = 4 and m = 1 against an
 independent source of your own (e.g. the self-intersection of a linear space in a hypersurface via the normal
 bundle) and the arithmetic.
C3 (ARG). Read this argument and say whether it is sound: "Both the Coble tenfold family W# (codimension 54) and the
 two-determinant tenfold family Sigma (closure, codimension 52) carry primitive classes of norm -48. If W# is in
 Sigma and the two-determinant class specialises at a general point X of W# to the Coble class, whose first-order
 Hodge locus at X has codimension 54 (registry D-TENFOLD-COBLE-FAMILY, N3), then since Sigma lies in the Hodge locus
 of that class near X, the Zariski tangent space at X of that Hodge locus contains the tangent cone of Sigma at X,
 of dimension dim Sigma, so its codimension is at most 52: contradiction. Hence either W# is not in Sigma, or the
 class specialises to a different class (and a general Coble tenfold has two independent primitive Hodge classes of
 norm -48)." Look for gaps (e.g. what 'the Hodge locus' means as a scheme, specialisation of classes in a family
 whose general member is not a Coble tenfold, monodromy, sign).
C4. Anything overstated.
