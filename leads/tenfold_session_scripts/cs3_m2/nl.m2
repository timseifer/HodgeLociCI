-- CS3-M2 new cells d = 9 (b = -1) and d = 15 (b = +1). usage: M2 --script nl.m2 seed p typ
-- R5: residual of V in X n W, W = J(Pi, Y3), Y3 = residual of a P^3 Lambda in (q0, c), q0 a RANK-4 quadric of the net of T, Lambda in q0,
--     c a cubic through T and Lambda (outside q0 S_1); deg W = 5, class 5h^5 - [V], d 9
-- U15: union V u (X n P^7 n c), P^7 a random hyperplane of P^8, c random in I_V(3) (class [V] + 3h^5, d 15; V n Z' = V n P^7, a 4-fold)
pr = s -> (stderr << s << endl << flush);
BR = 1500; sd = value scriptCommandLine#1; p = value scriptCommandLine#2; typ = scriptCommandLine#3;
kk = ZZ/p; S = kk[x_0..x_11]; setRandomSeed(sd);
load "/home/claude/hodge/discovery/checks/cs2_t6/cslibS2.m2";
load "/home/claude/hodge/discovery/checks/cs2_t6/tlib.m2";
B3 = super basis(3, IV); F = (B3 * random(kk^(numColumns B3), kk^1))_(0,0);
pr("X smooth along V: " | toString(dim(IV + ideal jacobian matrix{{F}}) == 0));
u = ideal(x_9, x_10, x_11);
if typ == "R5" then (
   Rt = kk[tt]; found = null;
   while found === null do (
      a0 := random(kk^3, kk^1); a1 := random(kk^3, kk^1);
      D := det(sum(3, k -> (sub(a0_(k,0), Rt) + tt * sub(a1_(k,0), Rt)) * sub(Ns#k, Rt)));
      fs := select(apply(toList factor D, fc -> fc#0), h -> first degree h == 1);
      if #fs > 0 then (r0 := - coefficient(1_Rt, fs#0) / coefficient(tt, fs#0); found = a0 + r0 * a1));
   N0 = sum(3, k -> found_(k,0) * Ns#k); pr("rank of N at the det-zero net member: " | toString rank N0);
   -- q0 = f^T N0 h with f = x0..x2 (fB), h = x3..x5 (hA); kernel vectors give the P^3: Lambda = {f . w = 0, h . v = 0} with w in left kernel? use l1 = (row space) form
   kl = gens ker transpose N0; kr = gens ker N0;     -- f^T N0 h vanishes if f in left kernel or h in right kernel
   -- Lambda = {f orthogonal to row space complement...}: take Lambda = {f : f^T N0 = 0 restricted} x {h : ...}: P^3 = {l1(f) = 0, m1(h) = 0} with N0 = u1 w1^T + u2 w2^T
   -- simple choice: Lambda = { (f, h) : f^T N0 h = 0 identically in the 4-space }: f in span(kl, e) and h with (e^T N0) h = 0
   e = random(kk^3, kk^1); fsp = kl | e;   -- 2-dim space of f
   hcond = transpose(transpose(e) * N0);   -- h must satisfy e^T N0 h = 0 (kl^T N0 = 0 automatically)
   -- linear equations of Lambda: f orthogonal complement of fsp (1 equation in f), and hcond . h = 0 (1 equation in h)
   lf = (matrix{fB}) * gens ker transpose fsp; mh = (matrix{hA}) * hcond;
   ILam = ideal(lf_(0,0), mh_(0,0)) + ideal(x_6, x_7, x_8) + u;
   q0 = sum(3, k -> found_(k,0) * qs#k);
   pr("q0 vanishes on Lambda: " | toString(q0 % ILam == 0) | ", T n Lambda dim " | toString(dim(IT + ILam) - 1));
   M3 = intersect(IT + ideal(x_6,x_7,x_8) + u, ILam); C3 = super basis(3, M3);
   nq = numColumns super basis(3, ideal(q0) + ideal(x_6,x_7,x_8) + u) - numColumns super basis(3, ideal(x_6,x_7,x_8) + u);
   pr("dim (I_T n I_Lambda)_3 in P^5 = " | toString(numColumns C3 - numColumns super basis(3, ideal(x_6,x_7,x_8) + u)) | ", of which q0 S_1: " | toString nq);
   c = ((C3 * random(kk^(numColumns C3), kk^1))_(0,0)) % (ideal(x_6,x_7,x_8) + u);
   IY = trim saturate((ideal(q0, c) + ideal(x_6,x_7,x_8) + u) : ILam);
   pr("Y3: dim " | toString(dim IY - 1) | " degree " | toString degree IY | ", contains T: " | toString isSubset(IY, IT + ideal(x_6,x_7,x_8) + u));
   IW = trim(sub(IY, {x_6 => 0, x_7 => 0, x_8 => 0}) + u);   -- generators in x0..x5 only: cone J(Pi, Y3)
   pr("W: dim " | toString(dim IW - 1) | " degree " | toString degree IW | ", V in W: " | toString isSubset(IW, IV));
   IZ = trim saturate((IW + ideal F) : IV);
   pr("residual R: dim " | toString(dim IZ - 1) | " degree " | toString degree IZ | "; dim(R n V) " | toString(dim(IZ + IV) - 1));
   kd = 8) else (
   lH = sum(9, k -> random(kk) * x_k); c = (((super basis(3, IV)) * random(kk^(numColumns super basis(3, IV)), kk^1))_(0,0)) % u;
   IZp = ideal(lH, c, F) + u;
   pr("Z': dim " | toString(dim IZp - 1) | " degree " | toString degree IZp);
   IZ = trim intersect(IV, IZp); kd = 8);
typ = "NL " | typ;
load "/home/claude/hodge/discovery/checks/cs2_t6/common_tail.m2";
