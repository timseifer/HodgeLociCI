-- E1 (which=1) / E3 (which=3) with other engines: M2's own "LinearAlgebra" gb algorithm, or mathicgb classic ("MGB")
pr = value scriptCommandLine#1; which = value scriptCommandLine#2; eng = scriptCommandLine#3;
kk = ZZ/pr;
load "common.m2";
use S;
t = cpuTime();
if which == 1 then ( Jac = ideal jacobian matrix{{F}}; nv = 12; tdeg = 14 ) else (
  S10 = kk[z_0,z_1,z_2,p_0,p_1,p_2,q_0,q_1,q_2,w_0,w_1];
  to10 = map(S10, S, {z_0,z_1,z_2,p_0,p_1,p_2,q_0,q_1,q_2,w_0,w_1,0});
  Jac = ideal jacobian matrix{{to10 F}}; nv = 11; tdeg = 12 );
stdio << "E" << which << " engine " << eng << " prime " << pr << endl << flush;
G = if eng == "LA" then gens gb(Jac, Algorithm => LinearAlgebra) else groebnerBasis(Jac, Strategy => "MGB");
stdio << "done cpu " << cpuTime()-t << "  elements " << numColumns G << " max degree " << max flatten degrees source G << endl << flush;
L = ideal leadTerm G;
stdio << "dim " << dim L << " degree " << degree L << " HF " << apply(toList(0..tdeg), d -> hilbertFunction(d, L)) << endl << flush;
