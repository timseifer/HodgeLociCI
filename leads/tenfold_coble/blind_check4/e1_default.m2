-- E1 (which=1) or E3 (which=3) with the DEFAULT Groebner engine (no F4), mod p
pr = value scriptCommandLine#1; which = value scriptCommandLine#2;
kk = ZZ/pr;
load "common.m2";
use S;
t = cpuTime();
if which == 1 then (
  Jac = ideal jacobian matrix{{F}};
  stdio << "E1 default engine, prime " << pr << endl << flush;
  gJ = gb Jac;
  stdio << "gb done cpu " << cpuTime()-t << "  elements " << numColumns gens gJ << endl << flush;
  stdio << "dim " << dim Jac << " degree " << degree Jac << endl << flush;
  hf = apply(toList(0..14), d -> hilbertFunction(d, Jac));
  stdio << "HF " << hf << "  == binomial(12,d): " << (hf == apply(toList(0..14), d -> binomial(12,d))) << endl << flush;
) else (
  S10 = kk[z_0,z_1,z_2,p_0,p_1,p_2,q_0,q_1,q_2,w_0,w_1];
  to10 = map(S10, S, {z_0,z_1,z_2,p_0,p_1,p_2,q_0,q_1,q_2,w_0,w_1,0});
  Jac = ideal jacobian matrix{{to10 F}};
  stdio << "E3 default engine, prime " << pr << endl << flush;
  gJ = gb Jac;
  stdio << "gb done cpu " << cpuTime()-t << "  elements " << numColumns gens gJ << endl << flush;
  stdio << "dim " << dim Jac << " degree " << degree Jac << "  HF " << apply(toList(0..12), d -> hilbertFunction(d, Jac)) << endl << flush;
);
