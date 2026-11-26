-- Structural explanation (my own): Sigma_A = {rank(tau + A) <= 1}, Sigma_B = {rank(tau + B) <= 1} in P^8 both lie on the
-- quadric s2(tau + A) = s2(tau + B) = 0, so they meet in a curve; the cone over G is singular there.  Test: the curve
-- Sigma_A cap Sigma_B has degree 18 and projects (forget tau) onto C = Sing(G).
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
sM = Mof sy;
G = det M - det sM;
JG = ideal jacobian ideal G;
ell = sum(8, i -> random(kk)*R_i);
IC = saturate(JG, ell);
R9 = kk[y_1..y_8, tau, MonomialOrder => Eliminate 8];   -- eliminate ... we want to eliminate tau: use explicit eliminate below
f = map(R9, R, apply(8, i -> R9_i));
I3 = id_(R9^3);
SA = minors(2, tau*I3 + f M); SB = minors(2, tau*I3 + f sM);
s2 = N -> N_(0,0)*N_(1,1)-N_(0,1)*N_(1,0) + N_(0,0)*N_(2,2)-N_(0,2)*N_(2,0) + N_(1,1)*N_(2,2)-N_(1,2)*N_(2,1);
say("s2(tau+M) == s2(tau+sM): " | toString(s2(tau*I3 + f M) == s2(tau*I3 + f sM)) | ";  this quadric lies in both ideals: " | toString(s2(tau*I3 + f M) % SA == 0 and s2(tau*I3 + f M) % SB == 0));
say("Sigma_A: dim(affine) " | toString dim SA | " degree " | toString degree SA);
IAB = SA + SB;
say("Sigma_A cap Sigma_B: dim(affine) " | toString dim IAB | "  degree " | toString degree IAB | "  HP " | toString hilbertPolynomial(IAB, Projective => false));
E = eliminate(tau, IAB);
g = map(R, R9, (gens R) | {0});
E0 = g E;
say("projection to P^7 (eliminate tau) contained in I_C: " | toString isSubset(E0, IC) | ";  saturated projection == I_C: " | toString(saturate(E0, ell) == IC));
-- the other half: Sigma_A cap Sigma_(-B) should give Sing(det M + det sM)
SBm = minors(2, tau*I3 - f sM);
IABm = SA + SBm;
say("Sigma_A cap {rank(tau - sM) <= 1}: dim(affine) " | toString dim IABm | "  degree " | toString degree IABm);
Gp = det M + det sM;
ICp = saturate(ideal jacobian ideal Gp, ell);
say("Sing(det M + det sM): HP " | toString hilbertPolynomial(ICp, Projective => false) | ";  equals projection of the second curve: " | toString(saturate(g eliminate(tau, IABm), ell) == ICp));
