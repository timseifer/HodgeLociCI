# Blind check 17 -- quartic fourfold, hyperplane section containing a dP4

All code is my own, in this folder: `check.m2`, `lines.m2`, `control.m2`. I did not open the qf3 files.

## Setup
P^5 has coordinates x0..x5, H = {x5=0}. Q1 and Q2 are random quadrics in x0..x4. A and B are random quadrics and C a random cubic in x0..x5.
X = {F = Q1*A + Q2*B + x5*C}, V = X ∩ H = {Q1*A|_H + Q2*B|_H = 0} ⊂ P^4, Sigma = {Q1=Q2=0}.
I ran seeds 1, 2, 3 over each of ZZ/32003 and ZZ/10007, so 6 instances in total.

## check.m2 (runtime about 24 s)
For each instance it checks:
- X is smooth: the saturated Jacobian ideal plus (F) is irrelevant.
- Sigma is smooth: the 2x2 minors of the Jacobian plus (Q1,Q2) have dim 0.
- The singular scheme of V: saturate(f + Jacobian).

Output (the same on every instance):
```
Xsmooth true, SigmaSmooth true, dimSingCone 1, deg 16, reduced true (radical == ideal),
onSigma true, Sing(V) == saturate(Q1,Q2,A|_H,B|_H) true, HF(1..5) = {5,11,15,16,16}
```
Why this holds: on Sigma the gradient of V is A*dQ1 + B*dQ2, so Sing(V) = {Q1=Q2=A=B=0}. That is a complete intersection of 4 quadrics in P^4, with h-vector (1,4,6,4,1) and HF 1,5,11,15,16.

## lines.m2 (runtime about 3 min)
This is a bigraded incidence check. It asks whether some point y in Sing(V) and some q != y in P^4 span a line on Sigma. The conditions are Q_i(y)=Q_i(q)=0 and the polar terms Q_i(y,q)=0, saturated by the 2x2 minors and by both irrelevant ideals.
- Result: the unit ideal in all 6 instances, so no singular point lies on any of the 16 lines.
- Control (`control.m2`, with the A and B constraints dropped): the ideal is non-unit with dim 4, as expected for the union of the 16 lines. This shows the test can detect lines.

## (c) and (d) by exact arithmetic
S.S = P1^2 + P2^2 + h^4 - 2 P1.P2 + 2 h^2.P1 - 2 h^2.P2 = 7 + 7 + 4 - 2 + 2 - 2 = 16.
deg S = h^2.S = 1 - 1 + 4 = 4. Then 4*16 - 4^2 = 48 = 3*16.
(d): with d=4, k=2, m=4 the identity reads 48 = (+1)*3*N, so N = 16.

## Verdicts
- (a) CONFIRMED for the 6 instances: exactly 16 reduced singular points, all on Sigma.
- (b) CONFIRMED: HF in degrees 2, 3, 4 is 11, 15, 16. There is one linear relation among the 16 points on cubics, which is Cayley-Bacharach for a CI of 4 quadrics.
- (c) CONFIRMED: the arithmetic is correct.
- (d) CONFIRMED as arithmetic: the identity gives N = 16, which matches (a). I did not test whether the identity holds in general, or whether S is the right class for this geometric setup.
- Optional: in all 6 instances none of the 16 points lies on a line of Sigma. They are the complete intersection Sigma ∩ {A=B=0}, i.e. Sigma cut by two more quadrics, and nothing more special.
