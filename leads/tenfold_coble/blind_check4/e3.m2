-- E3: Jacobian scheme of F|_{w_2=0} in P^10 mod p, F4.
pr = value scriptCommandLine#1;
kk = ZZ/pr;
load "common.m2";
S10 = kk[z_0,z_1,z_2,p_0,p_1,p_2,q_0,q_1,q_2,w_0,w_1];
to10 = map(S10, S, {z_0,z_1,z_2,p_0,p_1,p_2,q_0,q_1,q_2,w_0,w_1,0});
G10 = to10 F;
Jac = ideal jacobian matrix{{G10}};
stdio << "prime " << pr << "  generators " << numgens Jac << " degrees " << toString tally flatten degrees source gens Jac << endl << flush;
t = cpuTime();
G = groebnerBasis(Jac, Strategy => "F4");
stdio << "F4 done: " << numColumns G << " elements, max degree " << max flatten degrees source G << "  cpu " << cpuTime()-t << endl << flush;
L = ideal leadTerm G;
stdio << "Jacobian scheme of X': dim(affine cone) " << dim L << "  degree " << degree L << endl << flush;
stdio << "HF " << apply(toList(0..12), d -> hilbertFunction(d, L)) << endl << flush;
Jw = Jac + ideal(w_0,w_1);
G2 = groebnerBasis(Jw, Strategy => "F4");
L2 = ideal leadTerm G2;
stdio << "after adding w_0=w_1=0: dim " << dim L2 << "  degree " << degree L2 << "  HF " << apply(toList(0..8), d -> hilbertFunction(d, L2)) << endl << flush;
-- same thing with the default engine (cross-check of this small one)
Jw2 = ideal gens gb Jw;
stdio << "default engine: dim " << dim Jw2 << " degree " << degree Jw2 << endl << flush;
-- are w_0, w_1 in the ideal in high degree?  (w_0 * all monomials of degree 8 reduce to zero)
Gf = forceGB G;
stdio << "w_0*m^7, w_1*m^7 in Jac ? " << ((gens ((ideal(w_0,w_1)) * (ideal(z_0,z_1,z_2,p_0,p_1,p_2,q_0,q_1,q_2,w_0,w_1))^5)) % Gf == 0) << endl << flush;
