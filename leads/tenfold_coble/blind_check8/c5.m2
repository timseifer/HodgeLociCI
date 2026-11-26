-- C5: linear algebra at a random "rung" F = G + t1 Psi1 + t2 Psi2, G = Coble section (certificate parameters, defined over F_p)
cert = value get "/home/claude/hodgelocici/leads/tenfold_coble/pairing/arcdata/certificate_32003_seed1.txt";
pr = cert#"p"; kk = ZZ/pr;
say = s -> (stdio << s << endl << flush;);
lam0 = cert#"lam"; xs0 = cert#"x";
hfun = (l, v) -> v#0^3 + v#1^3 + v#2^3 + 3*l*v#0*v#1*v#2;
R = kk[u_0..u_7];
hyp = apply(cert#"hyperplane", value);
a0 = sub(-hfun(lam0, xs0), kk) / sub(27*(1+lam0^3), kk);
coble = (z,pp,q) -> a0*hfun(lam0,z) + hfun(lam0,pp) + hfun(lam0,q) + sum(3, i -> sum(3, j -> xs0#((i-j)%3) * z#((i+j)%3) * pp#i * q#j));
G = coble(hyp_{0,1,2}, hyp_{3,4,5}, hyp_{6,7,8});
JG = ideal jacobian ideal G;
setRandomSeed 4242;
ell = sum(8, i -> random(kk)*R_i);
IC = saturate(JG, ell);
say("C: HP " | toString hilbertPolynomial(IC, Projective => false) | "  (I_C)_3 = " | toString numcols basis(3, IC));
Psi1 = random(2, R); Psi2 = random(2, R);
mons3 = basis(3, R);
cf = L -> sub((coefficients(L, Monomials => mons3))#1, kk);
cIC3 = cf super basis(3, IC);
cP1 = cf (Psi1 * vars R); cP2 = cf (Psi2 * vars R);
N = cIC3 | cP1 | cP2;
say("dim (I_C)_3 + Psi1 S_1 + Psi2 S_1 = " | toString rank N);
cs = {3, 17, 101, 2026, 31000};
A = R/IC;
ellA = sub(ell, A);
b2 = basis(2, A); b3 = basis(3, A); b4 = basis(4, A); b5 = basis(5, A);
say("HF of A = R/I_C in degrees 1..5: " | toString {numcols basis(1,A), numcols b2, numcols b3, numcols b4, numcols b5});
liftR = map(R, A, gens R);   -- set-theoretic lift of normal forms
IZ3 = (c, k) -> (
   -- (I_Z)_3 / (I_C)_3 = { f in A_3 : ell^k f in Q_c A_(k+1) }   (k = 1 suffices in theory; k = 2 as a check)
   Qc := sub(Psi1 + c*Psi2, A);
   tgt := if k == 1 then b4 else b5;
   src := if k == 1 then b2 else b3;
   M1 := sub((coefficients(ellA^k * b3, Monomials => tgt))#1, kk);
   M2 := sub((coefficients(Qc * src, Monomials => tgt))#1, kk);
   ker := matrix nullSpace mutableMatrix (M1 | -M2);
   kv := ker^(toList(0..numcols b3 - 1));
   (rank M1, rank M2, liftR(b3 * sub(kv, A))));
Js = apply(cs, c -> (
   t0 := cpuTime();
   (r1, r2, L1) := IZ3(c, 1);
   (r1b, r2b, L2) := IZ3(c, 2);
   cZ := cIC3 | cf L1;
   cZb := cIC3 | cf L2;
   J := cZ | cP2;
   say("c = " | toString c | ":  rank(mult by ell) " | toString r1 | ", rank(mult by Q_c on A_2) " | toString r2 | ";  dim (I_Z)_3 = " | toString rank cZ | " (k=2: " | toString rank cZb | ", same space: " | toString(rank(cZ | cZb) == rank cZ) | ");  dim J_c = " | toString rank J | ";  dim(J_c + N) = " | toString rank(J | N) | "   time " | toString(cpuTime() - t0));
   J));
scan(subsets(#cs, 2), pq -> say("dim(J_c + J_c') for c = " | toString cs#(pq#0) | ", " | toString cs#(pq#1) | " : " | toString rank(Js#(pq#0) | Js#(pq#1))));
U = fold((x,y) -> x | y, Js);
say("dim of the sum of all five J_c : " | toString rank U);
-- quotient W = U / N (4-dimensional): functionals vanishing on N
lk = transpose matrix nullSpace mutableMatrix transpose N;   -- rows: functionals killing N
say("functionals killing N: " | toString numrows lk);
lam4 = random(kk^4, kk^(numrows lk)) * lk;
say("rank of the 4 chosen functionals on U: " | toString rank(lam4 * U));
pl = apply(Js, J -> (
   Mj := lam4 * J;          -- 4 x 93, rank 2
   cb := mingens image Mj;  -- 4 x 2
   if numcols cb != 2 then error "not a 2-plane";
   apply(subsets(4,2), rr -> det submatrix(cb, rr, {0,1}))));
P = matrix pl;
say("Pluecker vectors (rows): rank = " | toString rank P);
-- Pluecker relation check and pairwise incidence (p.q = 0 iff lines meet)
klein = (v, w) -> v#0*w#5 - v#1*w#4 + v#2*w#3 + v#3*w#2 - v#4*w#1 + v#5*w#0;
say("each vector satisfies the Pluecker relation: " | toString all(pl, v -> klein(v,v) == 0));
say("pairwise skew (Klein pairing nonzero for all pairs): " | toString all(subsets(#pl,2), pq -> klein(pl#(pq#0), pl#(pq#1)) != 0));
