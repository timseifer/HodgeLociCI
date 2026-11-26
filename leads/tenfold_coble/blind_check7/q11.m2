load "common.m2"
p = 32003;
if #scriptCommandLine > 1 then p = value scriptCommandLine#1;
kk = ZZ/p;
pr("===== Q11: K3 cover of the 64 Enriques nodes MOD " | toString p | " =====");
R = kk[y_0..y_8];
L = apply(3, i -> random(1,R));
Psi = apply(2, i -> random(2,R));
T = kk[u_0..u_2,v_0..v_2];
mon = (a,b,c) -> {a^2,a*b,a*c,b^2,b*c,c^2};
ph = map(T, R, join(mon(u_0,u_1,u_2), take(mon(v_0,v_1,v_2),3)));
rel = apply(3, i -> (mon(v_0,v_1,v_2))#(3+i) - ph(L#i));
eqs = rel | {ph(Psi#0), ph(Psi#1)};
ICI = ideal eqs;
pr("degrees of the five equations: " | toString apply(eqs, e -> first degree e) | "; codim " | toString codim ICI | ", length " | toString degree ICI | ", HF(0..10) = " | toString hfList(ICI,10));
Jm = jacobian matrix{eqs};   -- 6 x 5
pr("reduced (ICI + 5x5 minors of the Jacobian matrix has empty zero set): " | toString(codim(ICI + minors(5, Jm)) == 6));
J6 = det(Jm | transpose matrix{{1_T,0,0,0,0,0}});   -- Jacobian determinant with the invariant linear form u_0
iota = map(T, T, {u_0,u_1,u_2,-v_0,-v_1,-v_2});
pr("the five equations are invariant under (x,y)->(x,-y): " | toString all(eqs, e -> iota e == e) | "; Jacobian determinant J (bordered by du_0) anti-invariant: " | toString(iota J6 == -J6) | ", degree " | toString first degree J6);
B8 = flatten entries basis(8,T);
vdeg = m -> sum drop(first exponents m, 3);
Bp = select(B8, m -> even vdeg m); Bm = select(B8, m -> odd vdeg m);
rk = Lst -> rank lift((coefficients(matrix{Lst} % ICI, Monomials => basis(8,T)))#1, kk);
pr("number of invariant / anti-invariant octic monomials: " | toString(#Bp) | " / " | toString(#Bm));
pr("rank on the 128 points of: all octics " | toString rk(B8) | "; invariant octics " | toString rk(Bp) | "; anti-invariant octics " | toString rk(Bm) | "; pull-backs of the quartics of P^8 " | toString rk(flatten entries ph basis(4,R)));
-- the same count downstairs
sym3 = v -> matrix{{v#0,v#1,v#2},{v#1,v#3,v#4},{v#2,v#4,v#5}};
use R;
IS = minors(2, sym3 {y_0,y_1,y_2,y_3,y_4,y_5}) + minors(2, sym3 {y_6,y_7,y_8,L#0,L#1,L#2});
Z = IS + ideal(Psi#0, Psi#1);
pr("downstairs: S n {Psi_1=Psi_2=0}: length " | toString degree Z | ", HF(4) = " | toString hilbertFunction(4,Z));
