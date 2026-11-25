-- E1: Jacobian ideal of F in 12 variables mod p, F4.  args: prime [seed for random coordinate change]
pr = value scriptCommandLine#1;
kk = ZZ/pr;
load "common.m2";
use S;
FF = F;
if #scriptCommandLine > 2 then (
  setRandomSeed (value scriptCommandLine#2);
  A12 = random(kk^12, kk^12);
  stdio << "random coordinate change, det " << det A12 << endl << flush;
  FF = (map(S, S, vars S * A12)) F;
  stdio << "number of terms of transformed F: " << #terms FF << endl << flush;
);
Jac = ideal jacobian matrix{{FF}};
stdio << "prime " << pr << "  generators " << numgens Jac << " degrees " << toString tally flatten degrees source gens Jac << endl << flush;
t = cpuTime(); tt = currentTime();
G = groebnerBasis(Jac, Strategy => "F4");
stdio << "F4 done: " << numColumns G << " elements, max degree " << max flatten degrees source G << "  cpu " << cpuTime()-t << " wall " << currentTime()-tt << endl << flush;
L = ideal leadTerm G;
Q = S/L;
stdio << "dim of S/in(J) (affine) " << dim L << "   degree (vector space dim) " << degree L << endl << flush;
hf = apply(toList(0..14), d -> hilbertFunction(d, Q));
stdio << "HF " << hf << endl;
stdio << "equals binomial(12,d) for d=0..14 ? " << (hf == apply(toList(0..14), d -> binomial(12,d))) << "   HF(13) = " << hf#13 << endl << flush;
