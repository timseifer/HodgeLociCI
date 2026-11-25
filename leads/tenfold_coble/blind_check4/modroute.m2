-- Independent route for E1 (nw=3) and E3 (nw=2): S/Jac(F) as a module over R = kk[y] (9 variables),
-- using w_i^2 = -Phi_i/3; default Groebner engine on a module.   args: prime nw
pr = value scriptCommandLine#1;
nw = value scriptCommandLine#2;
kk = ZZ/pr;
load "common.m2";
use R;
dF = flatten entries jacobian matrix{{G8}};
Phis = {P0,P1,P2};
dP = apply(Phis, P -> flatten entries jacobian matrix{{P}});
subs = subsets(nw);
idx = hashTable apply(#subs, i -> subs#i => i);
third = (1_kk)/(3_kk);
cols = flatten for k from 0 to 8 list for Sset in subs list (
   v := new MutableList from apply(#subs, i -> 0_R);
   v#(idx#Sset) = v#(idx#Sset) + dF#k;
   for i from 0 to nw-1 do (
      if member(i, Sset) then ( T := select(Sset, j -> j != i); v#(idx#T) = v#(idx#T) - third*(Phis#i)*(dP#i#k) )
      else ( T2 := sort(append(Sset,i)); v#(idx#T2) = v#(idx#T2) + dP#i#k );
   );
   {toList v, #Sset}
);
Mat = map(R^(apply(subs, s -> -#s)), R^(apply(cols, c -> -(c#1)-2)), transpose matrix apply(cols, c -> c#0));
stdio << "prime " << pr << " nw " << nw << "  matrix " << numRows Mat << " x " << numColumns Mat << "  homogeneous " << isHomogeneous Mat << endl << flush;
N = coker Mat;
t = cpuTime();
gbN = gb Mat;
stdio << "gb done, cpu " << cpuTime()-t << endl << flush;
stdio << "dim N " << dim N << "  degree N " << degree N << endl << flush;
hf = apply(toList(0..14), d -> hilbertFunction(d, N));
stdio << "HF " << hf << endl;
if nw == 3 then stdio << "equals binomial(12,d) ? " << (hf == apply(toList(0..14), d -> binomial(12,d))) << endl << flush;
