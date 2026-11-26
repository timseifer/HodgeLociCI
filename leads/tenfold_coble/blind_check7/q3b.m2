load "common.m2"
p = 32003;
if #scriptCommandLine > 1 then p = value scriptCommandLine#1;
kk = ZZ/p;
pr("===== Q3 / Q10(iii), second version with GENERAL minors  MOD " | toString p | " =====");
pr("generalised 6x6 minors m(U,U') = det(U^T Hess U'), U,U' random 9x6 constant matrices; on S: m(U,U') = kappa * tau_U * tau_U', tau = sections of K_S(3)");
pr("solutions (c,c') in H^0(O_S(3))^2 of m(U,U') c = m(U,U) c' on S  <->  H^0(K_S^{-1}) (if tau_U, tau_U' have no common curve)");
R = kk[y_0..y_8];
U0 = random(kk^9, kk^6); U1 = random(kk^9, kk^6);
minorsOf = G -> (
    Hess := matrix table(9, 9, (i,j) -> diff(R_i, diff(R_j, G)));
    (det(transpose sub(U0,R) * Hess * sub(U0,R)), det(transpose sub(U0,R) * Hess * sub(U1,R))));
L = apply(3, i -> random(1,R));
sym3 = v -> matrix{{v#0,v#1,v#2},{v#1,v#3,v#4},{v#2,v#4,v#5}};
Xs = sym3 {y_0,y_1,y_2,y_3,y_4,y_5}; Ys = sym3 {y_6,y_7,y_8,L#0,L#1,L#2};
IE = minors(2,Xs) + minors(2,Ys);
GE = det Xs + random(kk) * det Ys;
(m00, m01) = minorsOf GE;
pr("minors computed; m(U,U) nonzero on S: " | toString((m00 % IE) != 0));
Bs = lift(basis(3, R/IE), R);
Mx = ((m01 * Bs) | (-m00 * Bs)) % IE;
pr("Enriques (downstairs): h^0(O_S(3)) = " | toString numcols Bs | "; dimension of solution space = " | toString(numcols Mx - rank lift((coefficients Mx)#1, kk)));
T = kk[u_0..u_2,v_0..v_2];
mon = (a,b,c) -> {a^2,a*b,a*c,b^2,b*c,c^2};
ph = map(T, R, join(mon(u_0,u_1,u_2), take(mon(v_0,v_1,v_2),3)));
IK = ideal apply(3, i -> (mon(v_0,v_1,v_2))#(3+i) - ph(L#i));
t00 = (ph m00) % IK; t01 = (ph m01) % IK;
B6 = flatten entries lift(basis(6, T/IK), T);
vdeg = m -> sum drop(first exponents m, 3);
scan({("anti-invariant", odd), ("invariant", even)}, pq -> (
    Bt := matrix{select(B6, m -> (pq#1)(vdeg m))};
    Mt := ((t01 * Bt) | (-t00 * Bt)) % IK;
    pr("Enriques, on the K3 cover, unknowns among the " | pq#0 | " sextics (" | toString numcols Bt | " of them mod I_K3): dimension of solution space = " | toString(numcols Mt - rank lift((coefficients Mt)#1, kk)));
    ));
-- Pfaffian K3 with the same general minors
use R;
M0 = random(R^6, R^{6:-1}); M = M0 - transpose M0;
IP = pfaffians(4,M);
(n00, n01) = minorsOf((gens pfaffians(6,M))_(0,0));
Bp = lift(basis(3, R/IP), R);
Mp = ((n01 * Bp) | (-n00 * Bp)) % IP;
pr("Pfaffian K3: h^0(O_S(3)) = " | toString numcols Bp | "; dimension of solution space = " | toString(numcols Mp - rank lift((coefficients Mp)#1, kk)));
G = (gens pfaffians(6,M))_(0,0);
IZ = minors(3, submatrix(M, {0,1,2}, ));
pr("bonus: Pf^2 in the ideal of 3x3 minors of three rows (Z_W inside Y set-theoretically): " | toString((G^2 % IZ) == 0));
