load "common.m2"
p = 32003;
if #scriptCommandLine > 1 then p = value scriptCommandLine#1;
kk = ZZ/p;
pr("===== Q3 / Q10(iii): is the discriminant of the normal quadratic form a square?  MOD " | toString p | " =====");
pr("test: 6x6 minors of the 9x9 Hessian restricted to S are  m_{I,I'} = kappa * tau_I * tau_I'  with tau_I sections of K_S(3) (Pluecker coordinates of the kernel);");
pr("      solutions (c,c') in H^0(O_S(3))^2 of  m_{I0,I1} c = m_{I0,I0} c'  on S  <->  sections of K_S^{-1};  expect 1 if K_S = 0 and 0 for an Enriques surface");
R = kk[y_0..y_8];
I0 = {0,1,2,3,4,5}; I1 = {0,1,2,3,4,6};
minorsOf = G -> (
    Hess := matrix table(9, 9, (i,j) -> diff(R_i, diff(R_j, G)));
    (det submatrix(Hess, I0, I0), det submatrix(Hess, I0, I1)));
sqrtTest = (nm, IS, G) -> (
    (m00, m01) := minorsOf G;
    Bs := lift(basis(3, R/IS), R);
    Mx := ((m01 * Bs) | (-m00 * Bs)) % IS;
    cf := lift((coefficients Mx)#1, kk);
    pr(nm | ": m_{I0,I0} nonzero on S: " | toString((m00 % IS) != 0) | "; h^0(O_S(3)) = " | toString numcols Bs | "; dimension of solution space = " | toString(numcols Mx - rank cf));
    );
-- Pfaffian K3
M0 = random(R^6, R^{6:-1}); M = M0 - transpose M0;
sqrtTest("Pfaffian K3", pfaffians(4,M), (gens pfaffians(6,M))_(0,0));
-- Enriques
L = apply(3, i -> random(1,R));
sym3 = v -> matrix{{v#0,v#1,v#2},{v#1,v#3,v#4},{v#2,v#4,v#5}};
Xs = sym3 {y_0,y_1,y_2,y_3,y_4,y_5}; Ys = sym3 {y_6,y_7,y_8,L#0,L#1,L#2};
IE = minors(2,Xs) + minors(2,Ys);
GE = det Xs + random(kk) * det Ys;
sqrtTest("Enriques (downstairs)", IE, GE);
-- Enriques, on the K3 cover
T = kk[u_0..u_2,v_0..v_2];
mon = (a,b,c) -> {a^2,a*b,a*c,b^2,b*c,c^2};
ph = map(T, R, join(mon(u_0,u_1,u_2), take(mon(v_0,v_1,v_2),3)));
IK = ideal apply(3, i -> (mon(v_0,v_1,v_2))#(3+i) - ph(L#i));
(m00, m01) = minorsOf GE;
t00 = ph m00; t01 = ph m01;
B6 = flatten entries lift(basis(6, T/IK), T);
vdeg = m -> sum drop(first exponents m, 3);
scan({("invariant", even), ("anti-invariant", odd)}, pq -> (
    Bs := matrix{select(B6, m -> (pq#1)(vdeg m))};
    Mx := ((t01 * Bs) | (-t00 * Bs)) % IK;
    cf := lift((coefficients Mx)#1, kk);
    pr("Enriques, on the K3 cover, unknowns among the " | pq#0 | " sextics (" | toString numcols Bs | " of them mod I_K3): dimension of solution space = " | toString(numcols Mx - rank cf));
    ));
-- bonus: a 5-fold in the Pfaffian cubic through the K3 surface: Z_W = {M : ker M meets a fixed 3-space W} = {rank of the first three rows <= 2}
use R;
IS = pfaffians(4,M); G = (gens pfaffians(6,M))_(0,0);
IZ = trim minors(3, submatrix(M, {0,1,2}, ));
gz = gens IZ;
c3 = gz * random(kk^(numcols gz), kk^3);
jm = jacobian c3;
pr("bonus (Pfaffian case): Z_W = {rank of 3 rows of M <= 2}: dim " | toString(dim IZ - 1) | ", degree " | toString degree IZ | ", contained in Y: " | toString((G % IZ) == 0) | ", contains S: " | toString isSubset(IZ, IS) | "; smooth of codim 3 at the general point of S (some 3x3 minor of the Jacobian of 3 random generators does not vanish on S): " | toString(not isSubset(minors(3, jm), IS)));
