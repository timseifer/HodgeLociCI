-- Supporting check for T6(ii): class of the sextic elliptic scroll T inside the transversal quadric
-- Q_z = {M_x(z*,p,q) = 0} in P^5(p,q) at a general point z* of the singular plane (F_T mode).
-- [T] = alpha*sA + beta*sB, alpha = T . (plane of the family of {q=0}), beta = T . (plane of the other family).
pp = value(scriptCommandLine#1); sd = value(scriptCommandLine#2); mode = "ft";
load "/home/claude/blind_check2/lib.m2";
R6 = kk[p_0..p_2,q_0..q_2];
zst = apply(3, i -> rnz());
pv = {p_0,p_1,p_2}; qv = {q_0,q_1,q_2};
Bm = matrix apply(3, i -> apply(3, j -> zst#((i+j)%3) * xv#((i-j+3)%3)));
<< "det B(z*) = " << det Bm << endl;
Mq = sum(3, i -> sum(3, j -> Bm_(i,j) * pv#i * qv#j));
Nk = k -> sum(3, i -> sum(3, j -> if (i+j)%3 == k then xv#((i-j+3)%3) * pv#i * qv#j else 0));
IT = ideal(Nk 0, Nk 1, Nk 2, hcub(lam, pv), hcub(lam, qv));
<< "T: affine dim " << dim IT << " (3 = surface), degree " << degree IT << "; T inside the quadric Q_z? " << (Mq % IT == 0) << endl;
ras = () -> (a := random kk; b := random kk; c := random kk; matrix{{0,a,b},{-a,0,c},{-b,-c,0}});
pc = transpose matrix{pv}; qc = transpose matrix{qv};
scan(3, t -> (
    K := ras(); Sa := inverse(Bm) * K;
    LA := ideal flatten entries (qc - sub(Sa, R6) * pc);
    K2 := ras(); Sb := transpose(inverse Bm) * K2;
    LB := ideal flatten entries (pc - sub(Sb, R6) * qc);
    << "trial " << t << ": plane A in quadric? " << (Mq % LA == 0) << ", plane B in quadric? " << (Mq % LB == 0)
       << "; dim(A ∩ B) affine = " << dim(LA+LB)
       << "; T.A: affine dim " << dim(IT+LA) << " degree " << degree(IT+LA)
       << "; T.B: affine dim " << dim(IT+LB) << " degree " << degree(IT+LB) << endl;
));
-- two planes of the same family for comparison: dim of intersection
K = ras(); K1 = ras();
LA1 = ideal flatten entries (qc - sub(inverse(Bm)*K, R6) * pc); LA2 = ideal flatten entries (qc - sub(inverse(Bm)*K1, R6) * pc);
<< "two planes of family A meet in affine dim " << dim(LA1+LA2) << " (1 = a point, as expected for the same family in Q^4)" << endl;
