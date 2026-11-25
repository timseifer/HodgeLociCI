-- EXP-T6 (v): codim in moduli of sub-towers of TD10 = l1Q1 + l2Q2 + det A + det B (MOD p), random members
pr = s -> (stderr << s << endl << flush);
p = 32003; kk = ZZ/p; S = kk[x_0..x_11]; setRandomSeed(value scriptCommandLine#1);
m3 = basis(3, S); cf = M -> lift(last coefficients(M, Monomials => m3), kk);
rl = vs -> sum(vs, v -> random(kk) * v);
cofs = A -> flatten entries gens minors(2, A);
runF = (name, nA, nB, nl) -> (
   -- A in the first nA variables (of the 10 coordinates x0..x9 of P^9 = {x10 = x11 = 0} ... ), l1, l2 vanish on the first nl coordinate points
   vA := toList(x_0 .. x_(nA-1)); vB := toList(x_0 .. x_(nB-1)); vl := toList(x_0 .. x_(11-nl));
   A := matrix table(3, 3, (i,j) -> rl vA); B := matrix table(3, 3, (i,j) -> rl vB);
   l1 := rl vl; l2 := rl vl; Q1 := random(2, S); Q2 := random(2, S);
   F := l1*Q1 + l2*Q2 + det A + det B;
   S1 := flatten entries vars S; S2 := flatten entries basis(2, S);
   gens1 := apply(S2, m -> l1*m) | apply(S2, m -> l2*m) | apply(vl, v -> Q1*v) | apply(vl, v -> Q2*v)
           | flatten apply(cofs A, c -> apply(vA, v -> c*v)) | flatten apply(cofs B, c -> apply(vB, v -> c*v));
   JS1 := flatten entries ((jacobian matrix{{F}}) * vars S);
   r := rank cf(matrix{gens1 | JS1});
   pr(name | ": codim of family in moduli = " | toString(364 - r) | "   (rank J_F S_1 = " | toString(rank cf matrix{JS1}) | ")"));
runF("TD10 (control 52)", 12, 12, 0);
runF("TD10, A,B,l free of 1 vertex (cone-type T5 over T4)", 11, 11, 1);
runF("TD10, A,B,l free of 2 (line vertex: J-family-like)", 10, 10, 2);
runF("TD10, A,B free of 1 only", 11, 11, 0);
runF("TD10, A free of 1, B free of other? (A on 11, B on 11 shifted)", 11, 12, 0);
