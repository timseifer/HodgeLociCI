-- R4 of PREREG_pairing.md: T1 by a direct count.  For a smooth k-fold Sigma in P^(2k) and a random cubic f through it,
-- N = length of Sigma n Sing{f = 0};  T1 says  3 (Sigma.Sigma)_X - m^2 = (-1)^k 2 N  for any smooth cubic 2k-fold X with
-- hyperplane section {f = 0}.  The self-intersections on the right are taken from known lattices (not from Chern classes):
--   P^2 x P^2 in an eightfold: 36 (registry, D-SEGRE-FOURFOLD)            -> N = (3*36 - 36)/2 = 36
--   G(2,5) n P^6 in a sixfold: class h^3 + P1 + P2, square -1              -> N = -(3*(-1) - 25)/2 = 14
--   P^1 x P^2 in a sixfold (cone over a cubic scroll, disc -24)            -> N = 12
--   projected Veronese surface in a fourfold: square 12, degree 4           -> N = (36 - 16)/2 = 10
-- AI-written, unreviewed.  usage: M2 --script pr4_identity.m2 p seed.   MOD p.
pp = value(scriptCommandLine#1); sd = value(scriptCommandLine#2); kk = ZZ/pp; setRandomSeed sd;
count = (nm, I, pred) -> ( R := ring I; B := super basis(3, I);
    f := (B * random(kk^(numColumns B), kk^1))_(0,0);
    Z := I + ideal jacobian matrix{{f}};
    Zs := saturate Z;
    red := (degree radical Zs == degree Zs);
    << "RESULT " << nm << ": dim Sigma " << dim I - 1 << ", degree " << degree I << " ; cubics through it " << numColumns B
       << " ; singular points of the cubic on Sigma: dim " << dim Zs - 1 << ", length " << degree Zs << ", reduced " << red << " ; predicted " << pred << endl << flush);
R8 = kk[x_0..x_8]; count("P^2 x P^2 in P^8 (k = 4)", minors(2, genericMatrix(R8, 3, 3)), 36);
R6 = kk[x_0..x_6];
Lf = new MutableHashTable; scan(5, i -> scan(5, j -> if i < j then Lf#(i,j) = random(1, R6)));
M5 = matrix table(5, 5, (i,j) -> if i < j then Lf#(i,j) else if i > j then -Lf#(j,i) else 0_R6);
count("G(2,5) n P^6 (k = 3)", pfaffians(4, M5), 14);
count("P^1 x P^2 in a hyperplane of P^6 (k = 3)", ideal(x_6) + minors(2, genericMatrix(R6, 2, 3)), 12);
R4 = kk[y_0..y_4]; P2 = kk[a, b, c];
count("projected Veronese surface in P^4 (k = 2)", ker map(P2, R4, apply(5, i -> random(2, P2))), 10);
R3 = kk[z_0..z_3, w_0..w_2];
count("P^3 in P^6 (k = 3)", ideal(w_0, w_1, w_2), 8);
<< "DONE p " << pp << " seed " << sd << endl;
