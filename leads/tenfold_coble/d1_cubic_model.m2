-- D1: the cubic model Delta at a product point  C(w,z) + c_1(p) + c_2(q),  class [Pi] x [Gamma_phi].
-- Delta(M) = < f_beta (x) (d_1 (x) f_2 - f_1 (x) d_2), M^3 >,  M in Z* (x) P* (x) Q*  (27 variables), c_1 = c_2 = Hesse cubic h_lambda.
-- Pre-registration (written before running):
--   (i)  dDelta = 0 on the Hesse cone {A.(a X1 + b X2 + c X3)} (must hold, F_T is in the Hodge locus): a check of the model.
--   (ii) corank of Hess Delta at a Hesse point: 10 = dim of the Hesse cone means NO extra direction in the model (would contradict
--        the registry's 54 vs 55); 11 means one extra direction g (agrees with the registry: 27 - 11 = 16).
--   (iii) if 11: Delta(g) = 0 means g is unobstructed at order 2 in the model (registry: yes); and dDelta(g) = 0 would mean the
--        whole plane <M_0, g> is critical, i.e. an 11-dimensional critical cone in the cubic model.
pp = value(scriptCommandLine#1); sd = value(scriptCommandLine#2);
setRandomSeed sd; kk = ZZ/pp;
al = random kk; be = random kk; ga = random kk;
lam = -(al^3+be^3+ga^3)/(3*al*be*ga);
S = kk[m_(0,0,0)..m_(2,2,2)];
R = S[z_0..z_2, p_0..p_2, q_0..q_2];
zz = {z_0,z_1,z_2}; ps = {p_0,p_1,p_2}; qs = {q_0,q_1,q_2};
Mt = sum flatten flatten apply(3, k -> apply(3, i -> apply(3, j -> m_(k,i,j)*zz#k*ps#i*qs#j)));
M3 = Mt^3;
-- functionals on cubics in 3 variables x: d = (1/3) sum [x_i^3],  f = [x0 x1 x2] - lam sum [x_i^3]
-- apply (d_1 (x) f_2 - f_1 (x) d_2) to the (p,q)-part: result is a cubic in z with coefficients in S
cube = (v) -> apply(3, i -> v#i^3); tri = v -> v#0*v#1*v#2;
coefPQ = (F, mp, mq) -> ( -- coefficient of the monomial mp*mq (in p,q) in F, as polynomial in z over S
    (mm, cc) := coefficients(F, Variables => ps | qs, Monomials => matrix{{mp*mq}}); cc_(0,0));
dp = F -> (1/3) * sum(3, i -> F#(i));
-- N(z) = sum over pairs
Nz = 0;
scan(3, i -> ( -- d_1 picks p_i^3 (weight 1/3); f_2 picks q0q1q2 (1) and q_j^3 (-lam)
    Nz = Nz + (1/3)*( coefPQ(M3, ps#i^3, tri qs) - lam * sum(3, j -> coefPQ(M3, ps#i^3, qs#j^3)) );
    Nz = Nz - (1/3)*( coefPQ(M3, tri ps, qs#i^3) - lam * sum(3, j -> coefPQ(M3, ps#j^3, qs#i^3)) );
    ));
-- note: the lam * p_i^3 q_j^3 terms cancel between the two halves, as they must
mz = flatten entries basis(3, kk[a_0..a_2]);
zm = {z_0^3, z_0^2*z_1, z_0^2*z_2, z_0*z_1^2, z_0*z_1*z_2, z_0*z_2^2, z_1^3, z_1^2*z_2, z_1*z_2^2, z_2^3};
Ncoef = apply(zm, mon -> ( (mm, cc) := coefficients(Nz, Variables => zz, Monomials => matrix{{mon}}); lift(cc_(0,0), S)));
<< "N(z) has " << #select(Ncoef, c -> c != 0) << " nonzero coefficients (cubics in the 27 tensor entries)" << endl << flush;
-- Hesse point M_0 = al X1 + be X2 + ga X3, transformed by a random A in GL(Z)
X0 = new MutableHashTable; scan(3, k -> scan(3, i -> scan(3, j -> X0#(k,i,j) = 0_kk)));
scan(3, i -> (X0#(i,i,i) = al; X0#(i,(i+1)%3,(i+2)%3) = be; X0#(i,(i+2)%3,(i+1)%3) = ga));
Am = random(kk^3, kk^3);
pt = (k,i,j) -> sum(3, l -> Am_(k,l) * X0#(l,i,j));
idxs = flatten flatten apply(3, k -> apply(3, i -> apply(3, j -> (k,i,j))));
sb = map(kk, S, apply(idxs, t -> pt t));
<< "N vanishes at the Hesse point: " << all(Ncoef, c -> sb c == 0) << endl;
JN = jacobian matrix{Ncoef};      -- 27 x 10
<< "dN vanishes at the Hesse point: " << (sb JN == 0) << endl << flush;
-- f_beta: a random functional on z-cubics;  Delta = sum fb_i N_i
fb = apply(10, i -> random kk);
Delta = sum(10, i -> fb#i * Ncoef#i);
gradD = jacobian matrix{{Delta}};          -- 27 x 1
H = sb jacobian transpose gradD;                      -- 27 x 27 Hessian at the Hesse point
<< "corank of Hess Delta at the Hesse point (random f_beta): " << 27 - rank H << "   (10 = no extra direction, 11 = one extra)" << endl << flush;
-- tangent space of the Hesse cone: gl(Z).M0 (9) and the derivative along the curve h_lam(al,be,ga)=0
tang = {};
scan(3, k -> scan(3, l -> tang = append(tang, apply(idxs, t -> if t#0 == k then pt(l, t#1, t#2) * (det Am)^0 else 0_kk))));
-- gl(Z): M -> E_{kl} M : entry (k,i,j) gets M_0(l,i,j)
tang = apply(flatten apply(3, k -> apply(3, l -> (k,l))), kl -> apply(idxs, t -> if t#0 == kl#0 then pt(kl#1, t#1, t#2) else 0_kk));
-- curve direction: (dal, dbe, dga) tangent to h_lam at (al,be,ga): gradient g = (al^2+lam be ga, be^2 + lam al ga, ga^2 + lam al be); pick v with g.v = 0, not prop. to (al,be,ga)
gr = {al^2+lam*be*ga, be^2+lam*al*ga, ga^2+lam*al*be};
v = {gr#1, -gr#0, 0_kk};
dX = new MutableHashTable; scan(3, k -> scan(3, i -> scan(3, j -> dX#(k,i,j) = 0_kk)));
scan(3, i -> (dX#(i,i,i) = v#0; dX#(i,(i+1)%3,(i+2)%3) = v#1; dX#(i,(i+2)%3,(i+1)%3) = v#2));
tang = append(tang, apply(idxs, t -> sum(3, l -> Am_(t#0,l) * dX#(l,t#1,t#2))));
TK = transpose matrix(kk, tang);            -- 27 x 10
<< "dim tangent space of Hesse cone: " << rank TK << " ; H kills it: " << (H * TK == 0) << endl;
Kh = gens ker H;
<< "kernel of H: dim " << numColumns Kh << " ; contains tangent of Hesse cone: " << (rank(Kh | TK) == rank Kh) << endl << flush;
if numColumns Kh == 11 then (
    -- pick g in ker H not in TK
    g := null; scan(numColumns Kh, c -> if g === null and rank(TK | Kh_{c}) == 11 then g = Kh_{c});
    sg := map(kk, S, flatten entries g);
    << "Delta(g) = " << sg Delta << " ;  dDelta(g) == 0: " << (sg gradD == 0) << " rank of dN at g: " << rank sg JN << " ; N(g) == 0: " << all(Ncoef, c -> sg c == 0) << endl;
    -- third-order term along M0 + t g modulo tangent directions: cubic form restricted to kernel: c(u) = Delta(u) for u in ker H
    SK := kk[u_0..u_10];
    lin := (sub(Kh, SK)) * transpose vars SK;      -- 27 x 1
    DK := (map(SK, S, flatten entries lin)) Delta;
    << "Delta restricted to ker H (11 vars): number of terms " << #terms DK << " ; is zero: " << (DK == 0) << endl;
    gradK := (map(SK, S, flatten entries lin)) gradD;
    << "dDelta restricted to ker H is zero (ker H is a critical linear space): " << (gradK == 0) << endl;
    );
