path = append(path, "/home/claude/hodge/package/HodgeLociCI/M2/"); needsPackage "HodgeLociCI";
-- EXP-T6 (ii-b,iii): more degree-6 5-folds (cones over sextic del Pezzo-type varieties), family codim in moduli (MOD p)
pr = s -> (stderr << s << endl << flush);
p = 32003; kk = ZZ/p; S = kk[x_0..x_11];
setRandomSeed(value scriptCommandLine#1); typ = scriptCommandLine#2;
-- helper: projected/linear-section Segre P2xP2 in a subring
segre = (R, n) -> (  -- ideal in R of P2xP2 in P^8 (first 9 vars of R) cut by n random hyperplanes, then: return ideal in the 9-n remaining vars
    T := kk[t_0..t_8]; I := minors(2, genericMatrix(T, t_0, 3, 3));
    if n > 0 then (lins := random(T^1, T^{n:-1}); I = I + ideal lins);
    (I, T));
proj = (I, T, keep) -> ( -- project from a general point: eliminate after general coordinate change; keep = number of target coords
    g := map(T, T, random(T^1, T^{9:-1})); J := g I;
    -- now eliminate the last 9-keep variables
    J = eliminate(toList(T_keep .. T_8), J); J);
I0 = (
  if typ == "J2S6" then (  -- S6 in P^6 (x0..x6), vertex P^2 (x7,x8,x9), x10 = x11 = 0
      (I,T) := segre(S, 2); g := map(T, T, random(T^1, T^{9:-1})); J := eliminate(toList(T_7..T_8), g I);
      phi := map(S, T, {x_0,x_1,x_2,x_3,x_4,x_5,x_6,0,0}); phi(J) + ideal(x_10, x_11))
  else if typ == "J2Sp" then ( -- S' = projection of S6 to P^5 (x0..x5), vertex (x6,x7,x8), x9 = x10 = x11 = 0
      (I,T) := segre(S, 2); g := map(T, T, random(T^1, T^{9:-1})); J := eliminate(toList(T_6..T_8), g I);
      phi := map(S, T, {x_0,x_1,x_2,x_3,x_4,x_5,0,0,0}); phi(J) + ideal(x_9, x_10, x_11))
  else if typ == "qPiSig" then ( -- projection of P2xP2 to P^7 (x0..x7), vertex x8, x9 = x10 = x11 = 0
      (I,T) := segre(S, 0); g := map(T, T, random(T^1, T^{9:-1})); J := eliminate({T_8}, g I);
      phi := map(S, T, {x_0,x_1,x_2,x_3,x_4,x_5,x_6,x_7,0}); phi(J) + ideal(x_9, x_10, x_11))
  else if typ == "J1W6p" then ( -- W6 = P2xP2 n H projected to P^6 (x0..x6), vertex line (x7,x8), x9..x11 = 0
      (I,T) := segre(S, 1); g := map(T, T, random(T^1, T^{9:-1})); J := eliminate(toList(T_7..T_8), g I);
      phi := map(S, T, {x_0,x_1,x_2,x_3,x_4,x_5,x_6,0,0}); phi(J) + ideal(x_9, x_10, x_11))
  else if typ == "qPiSig2" then ( -- P2xP2 projected from a general line to P^6 (x0..x6), vertex x7, x8..x11 = 0
      (I,T) := segre(S, 0); g := map(T, T, random(T^1, T^{9:-1})); J := eliminate({T_7, T_8}, g I);
      phi := map(S, T, {x_0,x_1,x_2,x_3,x_4,x_5,x_6,0,0}); phi(J) + ideal(x_8, x_9, x_10, x_11))
  else if typ == "J1P13p" then ( -- P1xP1xP1 (P^7) projected from a point to P^6 (x0..x6), vertex line (x7,x8), x9..x11 = 0
      T := kk[t_0..t_7]; Tt := (i,j,k) -> t_(4*i+2*j+k);
      fl1 := matrix{{Tt(0,0,0),Tt(0,0,1),Tt(0,1,0),Tt(0,1,1)},{Tt(1,0,0),Tt(1,0,1),Tt(1,1,0),Tt(1,1,1)}};
      fl2 := matrix{{Tt(0,0,0),Tt(0,0,1),Tt(1,0,0),Tt(1,0,1)},{Tt(0,1,0),Tt(0,1,1),Tt(1,1,0),Tt(1,1,1)}};
      fl3 := matrix{{Tt(0,0,0),Tt(0,1,0),Tt(1,0,0),Tt(1,1,0)},{Tt(0,0,1),Tt(0,1,1),Tt(1,0,1),Tt(1,1,1)}};
      I := minors(2,fl1) + minors(2,fl2) + minors(2,fl3);
      g := map(T, T, random(T^1, T^{8:-1})); J := eliminate({T_7}, g I);
      phi := map(S, T, {x_0,x_1,x_2,x_3,x_4,x_5,x_6,0}); phi(J) + ideal(x_9, x_10, x_11))
  else if typ == "J2T" then ( -- T = residual of two disjoint planes in a CI of 3 quadrics f^T N_k h (P^5: x0..x5), vertex P^2 (x6,x7,x8), x9..x11 = 0
      R5 := kk[y_0..y_5]; f := {y_0,y_1,y_2}; hh := {y_3,y_4,y_5};
      qs := apply(3, k -> (Nk := random(kk^3, kk^3); sum flatten apply(3, i -> apply(3, j -> Nk_(i,j) * f#i * hh#j))));
      CI := ideal qs; P12 := intersect(ideal f, ideal hh); IT := saturate(CI : P12);
      gg := map(R5, R5, random(R5^1, R5^{6:-1})); IT = gg IT;
      phi := map(S, R5, {x_0,x_1,x_2,x_3,x_4,x_5}); phi(IT) + ideal(x_9, x_10, x_11))
  else if typ == "scr3a" then ( -- cone vertex line (x6,x7) over Segre P1xP2 (x0..x5), x8..x11 = 0 : degree-3 scroll S(0,0,1,1,1) in P^7
      minors(2, matrix{{x_0,x_1,x_2},{x_3,x_4,x_5}}) + ideal(x_8, x_9, x_10, x_11))
  else if typ == "scr3b" then ( -- cone vertex plane (x4,x5,x6) over cubic scroll surface S(1,2) in P^4 (x0..x3, x7): S(0,0,0,1,2)
      minors(2, matrix{{x_0,x_1,x_3},{x_1,x_2,x_7}}) + ideal(x_8, x_9, x_10, x_11))
  else if typ == "scr6" then ( -- smooth 5-fold scroll S(1,1,1,1,2) in P^10 (x0..x10), x11 = 0
      minors(2, matrix{{x_0,x_2,x_4,x_6,x_8,x_9},{x_1,x_3,x_5,x_7,x_9,x_10}}) + ideal(x_11))
  else if typ == "qPiSigR2" then ( -- P2xP2 projected from a RANK-2 point of P^8 to P^7 (x0..x7), vertex x8, x9..x11 = 0
      (I,T) := segre(S, 0); 
      -- change coordinates so that the center e_8 (last coordinate point) is a rank-2 matrix: center = diag(1,1,0)
      cen := matrix{{1_kk,0,0,0,1,0,0,0,0}}; 
      M0 := id_(kk^9); M0 = M0_{0..7} | transpose cen; -- columns: images of new basis vectors; last new basis vector = center
      -- new coordinates s = M0^{-1} t ; ideal in s: substitute t = M0 * s
      g := map(T, T, transpose(M0 * transpose vars T));
      J := eliminate({T_8}, g I);
      phi := map(S, T, {x_0,x_1,x_2,x_3,x_4,x_5,x_6,x_7,0}); phi(J) + ideal(x_9, x_10, x_11))
  else if typ == "ctrlVZ" then ( -- control: two 5-planes meeting in a P^2 (codim V_Z = 39 expected)
      intersect(ideal(x_6,x_7,x_8,x_9,x_10,x_11), ideal(x_0,x_1,x_2,x_9,x_10,x_11)))
  else if typ == "ctrlP5" then ideal(x_6,x_7,x_8,x_9,x_10,x_11)
  else error "type");
I = trim (map(S, S, random(S^1, S^{12:-1}))) I0;
pr("type " | typ | ": dim V = " | toString(dim I - 1) | ", degree " | toString(degree I) | ", span: linear forms in I = " | toString(numColumns super basis(1, I)));
B3 = super basis(3, I);
F = (B3 * random(kk^(numColumns B3), kk^1))_(0,0);
JS1 = flatten((jacobian matrix{{F}}) * vars S);
m3 = basis(3, S); cf = M -> lift(last coefficients(M, Monomials => m3), kk);
pr("dim I_V(3) = " | toString numColumns B3 | "; rank J_F S_1 = " | toString(rank cf JS1) | "; codim of family in moduli = " | toString(364 - rank cf(B3 | JS1)));
if #scriptCommandLine > 3 then (
  t0 := cpuTime();
  h := hodgeLocusTangentCodim(F, I, CheckSmooth => false);
  pr("HL tangent codim of [V] = " | toString h#"codim" | "; label: " | toString h#"label" | "; time " | toString(cpuTime() - t0));
  );
