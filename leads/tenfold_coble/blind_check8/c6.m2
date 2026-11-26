-- Structural check (my own, not among the claims): with <a,b> = tr(ab), q(X) = X^2 - tr(X^2)/3 = grad det on sl_3,
--   delta(X) = q(X) - s^-1 q(sX) = grad G_s,   beta(X) = q(X) + s^-1 q(sX).
-- Claims tested: <delta,beta> = 0 identically; the quadratic vector field beta preserves the Jacobian ideal of G_s
-- (D_beta(J_G) inside J_G), is tangent to C = Sing(G_s) and is not radial on C.
pr = value scriptCommandLine#1; sd = value scriptCommandLine#2; nrefl = 8;
say = s -> (stdio << s << endl << flush;);
kk = ZZ/pr; setRandomSeed sd;
R = kk[y_1..y_8];
yv = transpose vars R;
Mof = v -> matrix{{v_(0,0),v_(1,0),v_(2,0)},{v_(3,0),v_(4,0),v_(5,0)},{v_(6,0),v_(7,0),-v_(0,0)-v_(4,0)}};
M = Mof yv; qf = trace(M*M);
Qm = sub((1/2)_kk * diff(vars R, diff(transpose vars R, qf)), kk);
refl = k -> (n := (transpose k * Qm * k)_(0,0); id_(kk^8) - (2/n) * k * transpose k * Qm);
Smat = id_(kk^8);
scan(nrefl, i -> (k := random(kk^8, kk^1); Smat = Smat * refl k));
sy = sub(Smat, R) * yv;
D = det M;
G = D - det Mof sy;
Qi = sub(inverse Qm, R); QR = sub(Qm, R);
qv = Qi * jacobian ideal D;                       -- column: grad D w.r.t. the form
subs = apply(8, i -> R_i => sy_(i,0));
qvs = sub(inverse Smat, R) * sub(qv, subs);       -- s^-1 q(sX)
delta = qv - qvs; beta = qv + qvs;
say("delta == Q^-1 grad G : " | toString(delta == Qi * jacobian ideal G));
say("<delta, beta> == 0 identically : " | toString((transpose beta * QR * delta)_(0,0) == 0));
JG = ideal jacobian ideal G;
Dbeta = f -> sum(8, i -> beta_(i,0) * diff(R_i, f));
say("D_beta(J_G) inside J_G (all 8 partials) : " | toString all(JG_*, f -> (Dbeta f) % JG == 0));
ell = sum(8, i -> random(kk)*R_i);
IC = saturate(JG, ell);
say("C: HP " | toString hilbertPolynomial(IC, Projective => false));
say("D_beta(I_C) inside I_C (beta tangent to the cone over C) : " | toString all(IC_*, f -> (Dbeta f) % IC == 0));
A = R/IC;
W2 = minors(2, sub(yv | beta, A));
say("beta radial (parallel to X) at every point of C : " | toString(W2 == 0) | ";   locus on C where beta is radial: dim (0 = empty) " | toString dim W2);
say("beta == 0 somewhere on C: dim of C cap {beta = 0} (0 = empty): " | toString dim ideal sub(beta, A));
