-- CS3-M2 DS probe: dims of Hom(I_V, S/I_V)_e and subspace with phi(F) = 0
pr = s -> (stderr << s << endl << flush);
sd = value scriptCommandLine#1; p = value scriptCommandLine#2;
kk = ZZ/p; S = kk[x_0..x_11]; setRandomSeed(sd);
load "/home/claude/hodge/discovery/checks/cs2_t6/tlib.m2";
B3 = super basis(3, IV); F = (B3 * random(kk^(numColumns B3), kk^1))_(0,0);
pr("X smooth along V: " | toString(dim(IV + ideal jacobian matrix{{F}}) == 0));
t0 = cpuTime();
H = Hom(module IV, S^1/IV);
pr("Hom computed " | toString(cpuTime()-t0));
g = gens IV; -- 1 x r
cF = F // g;  -- r x 1
for e in {-2,-1,0,1,2} do (
  Be := basis(e, H); n := numColumns Be;
  if n == 0 then (pr("e = " | toString e | ": dim Hom_e = 0"); continue);
  -- each column of Be is a homomorphism; homomorphism(Be_{j}) gives matrix module IV -> S/IV
  imgs := apply(n, j -> (h := homomorphism(map(H, S^{{-e}}, Be_{j})); (matrix{{1_S}} * (matrix h) * cF)_(0,0) % IV));
  B := basis(3 + e, S/IV);
  M := if all(imgs, u -> u == 0) then map(kk^(numColumns B), kk^n, 0) else lift(last coefficients(lift(matrix{imgs}, S), Monomials => lift(B,S)), kk);
  k := n - rank M;
  pr("e = " | toString e | ": dim Hom_e = " | toString n | ", dim {phi : phi(F) = 0} = " | toString k | "  t " | toString(cpuTime()-t0)));
