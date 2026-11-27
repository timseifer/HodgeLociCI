# Pre-registration: companion classes along the lambda = 2 pocket (owner: "can we maybe find an explanation for it")

Written 27 Nov 2026, late, before computing. Claude Opus 5.5. AI-written, unreviewed. MOD p (31981, then 32029).

Idea (from O-TENFOLD-CONE-LEAD / D-TENFOLD-COBLE-...: an arc kept to order 12 for Movasati's class turned out to be
carried by a DIFFERENT class, the three-plane class of the Coble family). Here: which Hodge classes of the Fermat
eightfold stay Hodge along the pocket jet?
The period functional Psi_P is linear in the period polynomial P (degree 5, square-free: 252 monomials), and the
conditions c_n[Q] = Psi_P(Q E_n) are linear in P. So Lambda_n = {P in H : c_m(P) = 0 for all Q, m <= n}, with
H = span of the period polynomials of the 229635 linear P^4's, is computed by linear algebra along the saved jet
(arcs/jet8_*_s_lam2.txt), n = 1..8 (order 9 for the saved T_1..T_8 is not complete; not used).

Outcomes:
- dim Lambda_8 = 1 (only c = P1 + 2 P2): no companion class along this jet; the generic Hodge lattice along the
  pocket is consistent with rank 2 (h^4 and c) -- the assumption of the lattice filter holds as far as tested.
- dim Lambda_8 >= 2: other classes stay Hodge along the jet to order 8. Then: identify them (as combinations of
  linear cycles; supports on torus eigenclasses), test whether c lies in a span with a class of a known family
  (lattice filter for rank 3), and look at which geometry carries them. This is the route by which the tenfold arc
  was explained.
- Lambda_1 is the first-order version (T_1 only) and is reported too; Lambda_1 > Lambda_8 is expected.
Caveat fixed in advance: the jet is a generic point of the 8-jet space of NL(c) with this T_1, so a companion class
of a component W would show up only if that jet lies on W's jets.
