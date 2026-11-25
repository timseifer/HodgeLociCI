-- P4c: at a point of F_T (x on the curve, a = 0): the 4-plane J(Pi_z, ruling line of T) inside Y_0 = {h(p)+h(q)+M_x = 0}.
-- Pre-registration: the plane lies in Y_0; it meets Sing(Y_0) in a curve of degree 6 (the plane cubic E_0 in Pi_z plus a twisted cubic,
-- arithmetic genus 2: Hilbert polynomial 6n - 1); and h^0(N) = 2 would mean it moves in a 2-dim family, as the theta-planes of a Coble cubic do.
pp = value(scriptCommandLine#1); sd = value(scriptCommandLine#2);
setRandomSeed sd; kk = ZZ/pp;
x = apply(3, i -> random kk); lam = -(x#0^3+x#1^3+x#2^3)/(3*x#0*x#1*x#2);
hes = (v, l) -> v#0^3+v#1^3+v#2^3 + 3*l*v#0*v#1*v#2;
S9 = kk[z_0..z_2, p_0..p_2, q_0..q_2];
Z = {z_0,z_1,z_2}; Pv = {p_0,p_1,p_2}; Qv = {q_0,q_1,q_2};
Mx = sum flatten apply(3, i -> apply(3, j -> Z#((i+j)%3) * x#((i-j)%3) * Pv#i * Qv#j));
F9 = hes(Pv, lam) + hes(Qv, lam) + Mx;
-- a rational point of the curve in the p-plane: pt = x itself
pt = x;
-- q with M_x(z, pt, q) = 0 for all z: matrix (k, j) = coefficient of z_k q_j in M_x(z, pt, q)
Mm = matrix(kk, apply(3, k -> apply(3, j -> sum(3, i -> if (i+j)%3 == k then x#((i-j)%3) * pt#i else 0_kk))));
<< "det of the matrix (must be 0 since pt is on the curve): " << det Mm << endl;
qq = flatten entries gens ker Mm;
<< "q = " << qq << endl;
rows = {{1,0,0,0,0,0,0,0,0},{0,1,0,0,0,0,0,0,0},{0,0,1,0,0,0,0,0,0}, {0,0,0} | pt | {0,0,0}, {0,0,0,0,0,0} | qq};
Lin = gens ker matrix(kk, rows);
IL = ideal((vars S9) * sub(Lin, S9));
<< "F vanishes on the plane: " << (F9 % IL == 0) << endl;
Ising = saturate ideal jacobian matrix{{F9}};
C = saturate(Ising + IL);
<< "plane ∩ Sing(Y_0): dim " << dim C - 1 << " degree " << degree C << " ; Hilbert polynomial " << toString hilbertPolynomial(C, Projective => false) << endl;
<< "components of the intersection (dim, degree): " << apply(decompose C, J -> (dim J - 1, degree J)) << endl;
Rpl = S9/IL;
lf = flatten entries ((vars S9) * sub(Lin, S9));
Qc = F9 // matrix{lf};
Qr = sub(Qc, Rpl);
K = ker map(Rpl^{3}, Rpl^{4:1}, transpose Qr);
<< "dim H^0(N_{P^4/Y_0}) = " << hilbertFunction(0, K) << endl;
-- components of Sing(Y_0)
<< "Sing(Y_0) components (dim, degree): " << apply(decompose Ising, J -> (dim J - 1, degree J)) << endl;
