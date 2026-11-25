-- EXP-T6 (ii-b): cubic tenfolds containing a degree-6 del Pezzo-type 5-fold V spanning P^9 (MOD p)
path = append(path, "/home/claude/hodge/package/HodgeLociCI/M2/"); needsPackage "HodgeLociCI";
pr = s -> (stderr << s << endl << flush);
p = 32003; kk = ZZ/p; S = kk[x_0..x_11];
setRandomSeed(scan1 = (if #scriptCommandLine > 1 then value scriptCommandLine#1 else 1));
typ = if #scriptCommandLine > 2 then scriptCommandLine#2 else "P2P2";
-- ideal of V in standard position, then random coordinates
I0 = (if typ == "P2P2" then minors(2, genericMatrix(S, x_0, 3, 3)) + ideal(x_10, x_11)   -- cone vertex e_9 over P2xP2 in x0..x8
  else if typ == "P1P1P1" then (
     -- Segre P1xP1xP1 in P^7 (x0..x7): 2x2 minors of the three flattenings of the 2x2x2 tensor; cone vertex line (x8, x9)
     T = (i,j,k) -> x_(4*i+2*j+k);
     fl1 = matrix{{T(0,0,0),T(0,0,1),T(0,1,0),T(0,1,1)},{T(1,0,0),T(1,0,1),T(1,1,0),T(1,1,1)}};
     fl2 = matrix{{T(0,0,0),T(0,0,1),T(1,0,0),T(1,0,1)},{T(0,1,0),T(0,1,1),T(1,1,0),T(1,1,1)}};
     fl3 = matrix{{T(0,0,0),T(0,1,0),T(1,0,0),T(1,1,0)},{T(0,0,1),T(0,1,1),T(1,0,1),T(1,1,1)}};
     minors(2,fl1) + minors(2,fl2) + minors(2,fl3) + ideal(x_10, x_11))
  else if typ == "W6" then (
     -- W6 = hyperplane section (trace = 0) of P2xP2: x0..x8 with x0+x4+x8 = 0 -> in P^7 ; cone vertex line (x9, x10) ; x11 = 0
     minors(2, genericMatrix(S, x_0, 3, 3)) + ideal(x_0 + x_4 + x_8, x_11))
  else error "type");
g = map(S, S, random(S^1, S^{12:-1}));
I = trim g I0;
pr("type " | typ | ": dim V = " | toString(dim I - 1) | ", degree " | toString(degree I));
B3 = super basis(3, I); pr("basis done");
F = (B3 * random(kk^(numColumns B3), kk^1))_(0,0);
J = ideal jacobian matrix{{F}};
JS1 = flatten((jacobian matrix{{F}}) * vars S);
m3 = basis(3, S); cf = M -> lift(last coefficients(M, Monomials => m3), kk);
rkFam = rank cf(B3 | JS1); rkJ = rank cf JS1; pr("ranks done");
pr("dim I_V(3) = " | toString numColumns B3 | "; rank J_F S_1 = " | toString rkJ | "; codim of family in moduli = " | toString(364 - rkFam));
if #scriptCommandLine > 3 and scriptCommandLine#3 == "full" then (
h = hodgeLocusTangentCodim(F, I, CheckSmooth => false);
pr("HL tangent codim of [V]: " | toString h#"codim" | "  (" | toString h#"label" | ")");
-- smoothness: singular locus of X
t0 = cpuTime();
sing = ideal(F) + J;
pr("dim Sing X (projective; -1 = smooth) = " | toString(dim sing - 1) | "  time " | toString(cpuTime() - t0)));
