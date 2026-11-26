load "common.m2"
p = 32003;
if #scriptCommandLine > 1 then p = value scriptCommandLine#1;
<< "===== ENRIQUES (Q4, Q2(iii))  MOD " << p << " =====" << endl << flush;
kk = ZZ/p;
R = kk[y_0..y_8];
-- 12 coordinates: a_0..a_5 = y_0..y_5 (entries of X_s), b_0,b_1,b_2 = y_6,y_7,y_8, and b_3,b_4,b_5 random linear forms
L = apply(3, i -> random(1,R));
av = {y_0,y_1,y_2,y_3,y_4,y_5};
bv = {y_6,y_7,y_8,L#0,L#1,L#2};
sym3 = v -> matrix{{v#0,v#1,v#2},{v#1,v#3,v#4},{v#2,v#4,v#5}};
Xs = sym3 av; Ys = sym3 bv;
IS = minors(2,Xs) + minors(2,Ys);
<< "dim S = " << dim IS - 1 << ", degree = " << degree IS << ", Hilbert polynomial: " << hilbertPolynomial(IS, Projective => false) << endl << flush;
<< "HF(0..6) = " << hfList(IS,6) << "  ; 8n^2+1 = " << toList apply(0..6, n -> 8*n^2+1) << endl << flush;
<< "pdim R/I_S = " << pdim comodule IS << " (codim " << codim IS << "; equal => arithmetically Cohen-Macaulay, hence saturated and projectively normal if S smooth)" << endl << flush;
<< "betti: " << endl << betti res IS << endl << flush;
<< "number of quadric generators: " << numgens trim IS << endl << flush;
-- K3 double cover in P^5
T = kk[u_0..u_2,v_0..v_2];
mon = (a,b,c) -> {a^2,a*b,a*c,b^2,b*c,c^2};
ph = map(T, R, join(mon(u_0,u_1,u_2), take(mon(v_0,v_1,v_2),3)));
-- relations: b_3 = L0(a,b0,b1,b2) etc.
rel = apply(3, i -> (mon(v_0,v_1,v_2))#(3+i) - ph(L#i));
IK = ideal rel;
<< "K3 cover: codim " << codim IK << " degree " << degree IK << "; singular locus codim (7 = empty): " << codim(IK + minors(3, jacobian IK)) << endl << flush;
<< "fixed points of (x,y)->(x,-y) on the K3: {y=0}: codim " << codim(IK + ideal(v_0,v_1,v_2)) << ", {x=0}: codim " << codim(IK + ideal(u_0,u_1,u_2)) << " (7 = none)" << endl << flush;
-- cubics singular along S
(nc, cubs) = singCubics IS;
<< "dimension of the space of cubics of P^8 singular along S: " << nc << endl << flush;
dX = det Xs; dY = det Ys;
<< "  det X_s, det Y_s in that space and independent: " << (rank ((coefficients(cubs | matrix{{dX,dY}}, Monomials => basis(3,R)))#1) == nc) << endl << flush;
c = random kk;
G = dX + c*dY;
J = ideal jacobian ideal G;
<< "Jacobian ideal of det X + c det Y (c = " << c << "): contained in I_S: " << isSubset(J, IS) << "; Hilbert polynomial " << hilbertPolynomial(J, Projective => false) << endl << flush;
-- special members
scan({(1,0),(0,1)}, ab -> (JJ := ideal jacobian ideal(ab#0*dX + ab#1*dY); << "  member " << ab << ": sing locus dim " << dim JJ - 1 << " degree " << degree JJ << endl));
-- Hessian rank along S: test on the points S n (2 random quadrics) n ... : ideal of 6x6 minors too big; test rank<=5 locus via random 6x6 minors
-- nodes and conditions on quartics, counted on S
q1 = random(2,R); q2 = random(2,R); q3 = random(2,R);
Z = IS + ideal(q1,q2);
<< "S n two random quadrics: codim " << codim Z << " degree " << degree Z << "; HF(4) of ideal = " << hilbertFunction(4,Z) << "; HF(0..7) = " << hfList(Z,7) << endl << flush;
Zs = saturate(Z, ideal(random(1,R)));
<< "  saturated? " << (Zs == Z) << endl << flush;
<< "  => nodes " << degree Z << ", conditions on quartics " << hilbertFunction(4,Zs) << ", defect " << degree Z - hilbertFunction(4,Zs) << endl << flush;
K3q = IS + ideal(q1,q2,q3);
<< "R/(I_S,3 quadrics): HF = " << hfList(K3q,8) << endl << flush;

<< "kernel of R -> T/I_K3 equals I_S ? " << (kernel map(T/IK, R, join(mon(u_0,u_1,u_2), take(mon(v_0,v_1,v_2),3))) == IS) << endl << flush;
Jsat = saturate(J, ideal(random(1,R)));
<< "  saturation (w.r.t. a random linear form) equals I_S: " << (Jsat == IS) << endl << flush;
