-- T1 + T2 (Coble mode)
pp = value(scriptCommandLine#1); sd = value(scriptCommandLine#2); mode = "coble";
load "/home/claude/blind_check2/lib.m2";
t0 = cpuTime();
Psi1 = random(2, R); Psi2 = random(2, R);
ISig = J + ideal(Psi1, Psi2);
<< "T1: Sigma: affine dim = " << dim ISig << ", degree = " << degree ISig << endl << flush;
-- T2
ell = random(1, R);
ISat = saturate(ISig, ell);
<< "T2: HF of Sigma (saturated ideal), degrees 0..8: " << apply(9, d -> hilbertFunction(d, R/ISat)) << endl << flush;
<< "T2: degree of saturated ideal = " << degree ISat << endl << flush;
-- squarefree projection test
S2 = kk[s,t];
l0 = random(1,R); l1 = random(1,R);
phi = map(R/ISat, S2, {sub(l0, R/ISat), sub(l1, R/ISat)});
G = (ker phi)_0;
<< "T1: projection of Sigma to a random line: binary form of degree " << first degree G << ", numgens ker = " << numgens ker phi << endl;
use S2;
<< "T1: gcd(G, dG/ds) degree = " << first degree gcd(G, diff(s, G)) << "  (0 => 72 distinct geometric points)" << endl << flush;
<< "T1: factor degrees of G over kk: " << sort apply(toList factor G, f -> first degree f#0) << endl << flush;
<< "   time " << cpuTime()-t0 << endl << flush;
-- comparison: linear form and quadric
use R;
L = random(1, R); Qd = random(2, R);
I36 = saturate(J + ideal(L, Qd), ell);
<< "T2 comparison: Sing ∩ {linear = quadric = 0}: degree " << degree I36 << " dim " << dim I36 << ", HF 0..6: " << apply(7, d -> hilbertFunction(d, R/I36)) << endl << flush;
<< "   time " << cpuTime()-t0 << endl << flush;
-- T1 part 2: ninefold in P^10
if #scriptCommandLine > 3 and scriptCommandLine#3 == "quick" then exit 0;
Rt = kk[z_0..z_2,p_0..p_2,q_0..q_2,t_1,t_2];
inc = map(Rt, R, {z_0,z_1,z_2,p_0,p_1,p_2,q_0,q_1,q_2});
lin = () -> inc random(1, R);
tcub = sum(4, k -> random(kk) * t_1^k * t_2^(3-k));
f = inc F + t_1*inc Psi1 + t_2*inc Psi2 + t_1^2*lin() + t_1*t_2*lin() + t_2^2*lin() + tcub;
Jf = ideal jacobian matrix{{f}};
<< "T1: ninefold f: Jacobian ideal affine dim = " << dim Jf << ", degree = " << degree Jf << endl << flush;
Jft = Jf + ideal(t_1, t_2);
<< "T1: Jacobian ideal + (t1,t2): affine dim = " << dim Jft << ", degree = " << degree Jft << endl << flush;
<< "   time " << cpuTime()-t0 << endl << flush;
