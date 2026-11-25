-- CS2-T6 type I1: V' = J(Pi, T'), T' a non-reduced / singular irreducible degeneration of T. usage: M2 --script i1.m2 seed p typ
-- I1a: T' = cone (vertex e_5) over an elliptic sextic curve C' in P^4 (generic projection of v_2(plane cubic)); V' = J(<Pi,e_5>, C')
-- I1b: T' = projection of the rational normal scroll S(3,3) in P^7 from a line in the span of two fibres (double line)
pr = s -> (stderr << s << endl << flush);
BR = 1500; sd = value scriptCommandLine#1; p = value scriptCommandLine#2; typ = scriptCommandLine#3;
kk = ZZ/p; S = kk[x_0..x_11]; setRandomSeed(sd);
load "/home/claude/hodge/discovery/checks/cs2_t6/cslibS2.m2";
if typ == "I1a" then (
   R3 := kk[s_0..s_2]; cub := random(3, R3); RE := R3/ideal(cub);
   q6 := flatten entries basis(2, R3); A := random(kk^5, kk^6);
   fm := apply(5, k -> sum(6, j -> A_(k,j) * q6#j));
   R5 := kk[y_0..y_4, Degrees => {5:2}];
   IC := ker map(RE, R5, apply(fm, g -> sub(g, RE)));
   ITp = trim (map(S, R5, {x_0,x_1,x_2,x_3,x_4})) IC;
   ) else if typ == "I1b" then (
   Rst := kk[s_0, s_1, t_0, t_1];
   mon := flatten apply(2, i -> apply(4, j -> s_i * t_0^j * t_1^(3-j)));  -- index i*4 + j; t0=0 fibre: j = 0; t1=0 fibre: j = 3
   P3 := matrix apply(8, r -> apply(4, c -> if r == {0,4,3,7}#c then 1_kk else 0_kk));
   L := P3 * random(kk^4, kk^2);                -- center line inside the span of two fibres
   Ann := transpose gens ker transpose L;      -- 6 x 8, rows vanish on L
   Ap := random(kk^6, kk^6) * Ann;
   fm := apply(6, k -> sum(8, j -> Ap_(k,j) * mon#j));
   R6 := kk[y_0..y_5, Degrees => {6:4}];
   IT6 := ker map(Rst, R6, fm);
   ITp = trim (map(S, R6, {x_0,x_1,x_2,x_3,x_4,x_5})) IT6;
   ) else error "typ";
w = ideal(x_6..x_11);
pr("T': dim " | toString(dim(ITp + w) - 1) | " degree " | toString degree(ITp + w) | " Hilbert poly " | toString hilbertPolynomial(ITp + w, Projective => false) | "; HF 0..4 " | toString apply(5, i -> numColumns basis(i, S/(ITp + w))) | "; mingens degrees " | toString tally apply(flatten entries mingens ITp, g -> first degree g));
P5 = kk[z_0..z_5]; IT5 = (map(P5, S, {z_0,z_1,z_2,z_3,z_4,z_5,0,0,0,0,0,0})) ITp;
pr("T' singular locus (in P^5) dim: " | toString(dim(IT5 + minors(3, jacobian IT5)) - 1) | ", degree " | toString degree(IT5 + minors(3, jacobian IT5)));
IZ = trim(ITp + ideal(x_9, x_10, x_11));
B3 = super basis(3, IZ); F = (B3 * random(kk^(numColumns B3), kk^1))_(0,0);
kd = 8; typ = "I1 " | typ;
load "/home/claude/hodge/discovery/checks/cs2_t6/common_tail.m2";
