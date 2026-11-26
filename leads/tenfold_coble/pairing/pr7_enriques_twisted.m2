-- R7 of PREREG_pairing.md (section 7): on the K3 cover of the Enriques surface, the 128 points over the 64 nodes have
-- one relation on octics, and it is anti-invariant.   AI-written, unreviewed.  usage: M2 --script pr7_enriques_twisted.m2 p seed
pp = value(scriptCommandLine#1); sd = value(scriptCommandLine#2); kk = ZZ/pp; setRandomSeed sd;
R = kk[a_0..a_5, b_0..b_2];
ell = apply(3, i -> random(1, R));
P5 = kk[x_0..x_2, y_0..y_2];
mon = v -> {v#0^2, v#0*v#1, v#0*v#2, v#1^2, v#1*v#2, v#2^2};
xm = mon {x_0,x_1,x_2}; ym = mon {y_0,y_1,y_2};
toK = map(P5, R, xm | take(ym, 3));
IK = ideal apply(3, i -> ym#(3+i) - toK ell#i);
-- a quadric of P^8 restricted to the P^8: substitute b_3..b_5 = ell; here the nine coordinates are already those of the P^8
Psi = apply(2, k -> toK random(2, R));
IZ = IK + ideal Psi;
<< "K3 cover: dim " << dim IK - 1 << ", degree " << degree IK << " ; preimage of the nodes: dim " << dim IZ - 1 << ", degree " << degree IZ
   << " ; reduced: " << (degree radical IZ == degree IZ) << " ; Hilbert function in degrees 6..10: " << toString apply(5, j -> hilbertFunction(6+j, P5/IZ)) << endl << flush;
B8 = flatten entries basis(8, P5);
ydeg = m -> sum(3, j -> (first exponents m)#(3+j));
inv = select(B8, m -> (ydeg m) % 2 == 0); anti = select(B8, m -> (ydeg m) % 2 == 1);
G = gens gb IZ;
rk = L -> ( N := (matrix{L}) % G; rank lift(last coefficients N, kk) );
<< "RESULT octics on the 128 points: invariant monomials " << #inv << ", rank " << rk inv << " ; anti-invariant monomials " << #anti << ", rank " << rk anti
   << " ; all octics: rank " << rk B8 << " ; predicted 64, 63, 127" << endl;
-- the pull-backs of the quartics of P^8 are among the invariant octics: their rank
q4 = flatten entries (toK basis(4, R));
<< "RESULT pull-backs of the quartics of P^8: rank " << rk q4 << " (predicted 64: no relation among the 64 nodes)" << endl;
<< "DONE p " << pp << " seed " << sd << endl;
