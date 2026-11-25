-- W1 (d): second-order test of the extra Hodge-tangent direction at X in F_T (MOD p)
pr = s -> (stderr << s << endl << flush);
p = 32003; kk = ZZ/p; S = kk[x_0..x_11];
setRandomSeed(value scriptCommandLine#1);
load "/home/claude/hodge/discovery/checks/w1/w1lib.m2";
I = trim w1cycle("J2T");
B3 = super basis(3, I); F = (B3 * random(kk^(numColumns B3), kk^1))_(0,0);
w1codimP8(F, I);
m3 = basis(3, S); cf = M -> lift(last coefficients(M, Monomials => m3), kk);
TF = cf(matrix{w1TFpolys}); TFb = matrix nullSpace mutableMatrix transpose TF;  -- not used
Jg = jacobian matrix{{F}}; GI = gens I | transpose Jg; nI = numColumns gens I;
IJ = ideal gens gb ideal GI;
A = S/IJ; bt = lift(basis(6, A), S); pr("m = " | toString numColumns bt); m0 = bt_(0,0);
pr("HF (I+J) at 7, 9: " | toString(hilbertFunction(7, A), hilbertFunction(9, A)));
B6 = basis(6, S); NF = B6 % IJ; C = lift(last coefficients(NF, Monomials => bt), kk);
Pi6 = (B6 * transpose sub(C, S))_(0,0);                     -- sum pi(m) m
PiI = apply(12, i -> x_i * diff(x_i, x_i * Pi6));            -- Pi_i: coefficients pi(d_i m) on S_7
L3 = flatten entries m3;
idx = new MutableHashTable; mons = flatten entries B6; scan(#mons, i -> idx#(mons#i) = i); v0 = flatten entries C^{0};
P = matrix table(#L3, #L3, (i,j) -> v0_(idx#(L3#i * L3#j)));
KP = matrix nullSpace mutableMatrix P; pr("dim T NL = " | toString numColumns KP);
piOf = M -> lift(last coefficients(M % IJ, Monomials => bt), kk);   -- row of pi values for a 1 x n matrix of degree-6 polys
gI = flatten entries gens I;
chk1 = apply(6, t -> (g := gI#(random(#gI)); R := g * random(7 - first degree g, S); b := random 12; piOf(matrix{{diff(S_b, sub(R, S))}})));
pr("self-check 1 (should be zeros): " | toString chk1);
Jm3 = jacobian m3;   -- 12 x 364, d_i of each cubic monomial
-- psi(Q m0) for all monomials Q, batched
t0 = cpuTime();
Qm0 = m0 * m3; if Qm0 % IJ != 0 then error "S_9 not in I+J";
cofm = Qm0 // GI;
divA = sum(12, i -> diff(S_i, cofm^{nI + i}));
psim0 = piOf divA;
pr("psi(Q m0) done, time " | toString(cpuTime() - t0) | ", nonzero: " | toString(#select(flatten entries psim0, v -> v != 0)));
-- functionals Q -> psi(D_j Q), for a 1 x n matrix of degree-6 polynomials D, returns n x 364 matrix
psiRows = Dm -> (
   cs := piOf Dm;                                  -- 1 x n, coefficient c_j of m0
   D0 := Dm - m0 * sub(cs, S);
   if D0 % IJ != 0 then error "deg 6 not in I+J";
   cof := D0 // GI;
   matrix apply(numColumns Dm, j -> (
      Bv := cof_{j}^{nI .. nI+11};                 -- 12 x 1
      dv := sum(12, i -> diff(S_i, Bv_(i,0)));
      row := piOf((transpose Bv) * Jm3 + dv * m3);
      flatten entries (row + cs_(0,j) * psim0))));
toPoly = v -> (m3 * sub(v, S))_(0,0);
h = toPoly(TF * random(kk^(numColumns TF), kk^1));
pr("self-check 2: rank of psi(h^2 K), K in T NL (should be 0): " | toString rank(psiRows(matrix{{h^2}}) * KP));
Ge = null; for j from 0 to numColumns KP - 1 do (if rank(TF | KP_{j}) > rank TF then (Ge = toPoly(KP_{j}); break));
qG = psiRows(matrix{{Ge^2}}) * KP; pr("q(Ge) on T NL: nonzero entries " | toString(#select(flatten entries qG, x -> x != 0)));
TFrk = rank TF; TFcols = TF * random(kk^(numColumns TF), kk^TFrk);
t0 = cpuTime();
Bm = psiRows(matrix{apply(TFrk, j -> toPoly(TFcols_{j}) * Ge)}) * KP;
pr("rank B(T F_T, Ge) = " | toString rank Bm | "; rank with q(Ge) = " | toString rank(Bm || qG) | "  time " | toString(cpuTime()-t0));
