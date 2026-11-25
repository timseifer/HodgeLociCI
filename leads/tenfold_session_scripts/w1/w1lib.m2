-- W1 library: cycle constructions and period-functional tangent codim (MOD p). Expects S, kk, pr defined.
w1T = () -> (
    -- AHTV elliptic ruled sextic in P^5: residual of two disjoint planes in a random net of quadrics in I(Pi1 u Pi2)
    R5 := kk[y_0..y_5]; f := {y_0,y_1,y_2}; hh := {y_3,y_4,y_5};
    qs := apply(3, k -> (Nk := random(kk^3, kk^3); sum flatten apply(3, i -> apply(3, j -> Nk_(i,j) * f#i * hh#j))));
    IT := saturate(ideal qs : intersect(ideal f, ideal hh));
    gg := map(R5, R5, random(R5^1, R5^{6:-1})); w1planes = (gg ideal f, gg ideal hh); (R5, gg IT));
w1cycle = typ -> (
    if typ == "J2T" then (
        (R5, IT) := w1T();
        (map(S, R5, {x_0,x_1,x_2,x_3,x_4,x_5})) IT + ideal(x_9, x_10, x_11))
    else if typ == "P2P2" then minors(2, genericMatrix(S, x_0, 3, 3)) + ideal(x_10, x_11)
    else if typ == "plane" then ideal(x_0..x_5)
    else error "type");
-- tangent codim of the Hodge locus via functionals annihilating (I + J)_6 (cubic tenfold: t = 6, e = 3)
w1tangent = (F, I) -> (
    J := ideal jacobian matrix{{F}};
    t1 := cpuTime();
    IJ := ideal gens gb (I + J);
    A := S/IJ; bt := lift(basis(6, A), S); m := numColumns bt;
    pr("  (I+J)_6 codim m = " | toString m | "  gb time " | toString(cpuTime()-t1));
    if m == 0 then return ({0}, 0);
    B6 := basis(6, S); NF := B6 % IJ;
    C := lift(last coefficients(NF, Monomials => bt), kk);   -- m x 12376
    idx := new MutableHashTable; mons := flatten entries B6;
    scan(#mons, i -> idx#(mons#i) = i);
    m3 := flatten entries basis(3, S);
    pos := table(m3, m3, (a,b) -> idx#(a*b));
    pairing := v -> matrix table(#m3, #m3, (i,j) -> v_(pos#i#j));   -- v: list of values on degree-6 monomials
    rows := apply(m, j -> flatten entries C^{j});
    ranks := apply(min(m, 6), j -> rank pairing(rows#j));
    rc := random(kk^1, kk^m); vr := flatten entries (rc * C);
    ranks = append(ranks, rank pairing(vr));
    (ranks, m));
-- family codim at (F, I): 364 - rank(I(3) + {phi(F)_3 : phi in Hom(I, S/I)_0} + J_F S_1)
w1codim = (F, I) -> (
    m3 := basis(3, S); cf := M -> lift(last coefficients(M, Monomials => m3), kk);
    B3 := super basis(3, I);
    t0 := cpuTime();
    Hm := Hom(module I, S^1/I); B0 := basis(0, Hm);
    pr("  Hom_0 dim = " | toString numColumns B0 | "  time " | toString(cpuTime() - t0));
    g := gens I; c := F // g; polys := flatten entries B3;
    for j from 0 to numColumns B0 - 1 do (
       phi := homomorphism(B0_{j}); q := (lift((matrix phi) * c, S))_(0,0);
       q3 := sum(select(terms q, t -> first degree t == 3)); if q3 != 0 then polys = append(polys, q3));
    JS1 := flatten entries ((jacobian matrix{{F}}) * vars S);
    r0 := rank mutableMatrix cf(matrix{flatten entries B3 | JS1}); r1 := rank mutableMatrix cf(matrix{polys | JS1});
    pr("  codim without V-moduli = " | toString(364 - r0) | "; WITH Hom_0 = " | toString(364 - r1));
    (364 - r0, 364 - r1, numColumns B0));
-- Hom(I, S/I)_0 by linear algebra over syzygies, then family codim (same output as w1codim)
w1codimLA = (F, I) -> (
    m3 := basis(3, S); cf := M -> lift(last coefficients(M, Monomials => m3), kk);
    t0 := cpuTime();
    g := mingens I; r := numColumns g; G := gb I;
    dg := apply(r, i -> first degree g_(0,i));
    sy := syz g; s := numColumns sy;
    pr("  gens " | toString r | " degrees " | toString tally dg | "; syzygies " | toString s | " time " | toString(cpuTime()-t0));
    A := S/I;
    Bs := apply(r, i -> lift(basis(dg#i, A), S));       -- standard monomials of degree d_i
    offs := {0} | accumulate(plus, 0, apply(Bs, numColumns)); N := last offs;
    colBlocks := {}; 
    rowsList := {};
    for k from 0 to s-1 do (
       ek := (degrees source sy)#k#0;
       Ek := lift(basis(ek, A), S); if numColumns Ek == 0 then continue;
       blocks := apply(r, i -> (
           if sy_(i,k) == 0 then map(kk^(numColumns Ek), kk^(numColumns Bs#i), 0)
           else lift(last coefficients((sy_(i,k) * Bs#i) % G, Monomials => Ek), kk)));
       rowsList = append(rowsList, fold((a,b) -> a | b, blocks)));
    M := fold((a,b) -> a || b, rowsList);
    K := matrix nullSpace mutableMatrix M;
    pr("  Hom_0 dim (LA) = " | toString numColumns K | "  time " | toString(cpuTime()-t0));
    c := F // g; polys := flatten entries super basis(3, I);
    for j from 0 to numColumns K - 1 do (
       q := sum(r, i -> if dg#i > 3 or c_(i,0) == 0 or numColumns(Bs#i) == 0 then 0_S else c_(i,0) * sum(numColumns(Bs#i), a -> sub(K_(offs#i + a, j), S) * (Bs#i)_(0,a)));
       q = q % G; if q != 0 then polys = append(polys, q));
    JS1 := flatten entries ((jacobian matrix{{F}}) * vars S);
    r0 := rank mutableMatrix cf(matrix{flatten entries super basis(3, I) | JS1}); r1 := rank mutableMatrix cf(matrix{polys | JS1});
    pr("  codim without V-moduli = " | toString(364 - r0) | "; WITH Hom_0 = " | toString(364 - r1));
    (364 - r0, 364 - r1, numColumns K));
-- faster: cycle inside P^8 = V(x9,x10,x11). Hom(I,S/I)_0 = Hom(I',S'/I')_0 (+) (S'/I')_1^3; batched linear algebra.
w1codimP8 = (F, I) -> (
    t0 := cpuTime();
    Sp := kk[z_0..z_8]; toP := map(Sp, S, (gens Sp) | {0_Sp,0_Sp,0_Sp}); back := map(S, Sp, take(gens S, 9));
    Ip := trim toP I; g := mingens Ip; r := numColumns g; G := gb Ip; A := Sp/Ip;
    dg := apply(r, i -> first degree g_(0,i));
    sy := syz g; s := numColumns sy; sdeg := apply(s, k -> (degrees source sy)#k#0);
    Bs := apply(r, i -> lift(basis(dg#i, A), Sp));
    offs := {0} | accumulate(plus, 0, apply(Bs, numColumns)); N := last offs;
    rowsList := {};
    for e in unique sdeg do (
       ks := select(s, k -> sdeg#k == e); Ek := lift(basis(e, A), Sp); ne := numColumns Ek;
       if ne == 0 then continue;
       -- one big row of polynomials: for each k in ks, each column block i
       P := matrix{flatten apply(ks, k -> flatten apply(r, i -> flatten entries (sy_(i,k) * Bs#i)))};
       Q := lift(last coefficients(P % G, Monomials => Ek), kk);   -- ne x (#ks * N)
       rowsList = rowsList | apply(#ks, a -> Q_{a*N .. (a+1)*N - 1}));
    pr("  rows built " | toString(cpuTime()-t0));
    M := fold((a,b) -> a || b, rowsList);
    pr("  M " | toString numRows M | " x " | toString numColumns M | " " | toString(cpuTime()-t0));
    K := matrix nullSpace mutableMatrix M;
    L1 := lift(basis(1, A), Sp); n1 := numColumns L1;
    pr("  [P8] Hom'_0 = " | toString numColumns K | " + 3 x " | toString n1 | " = " | toString(numColumns K + 3*n1) | "  time " | toString(cpuTime()-t0));
    Fp := toP F; c := Fp // g; pr("  lift done " | toString(cpuTime()-t0));
    polys := flatten entries super basis(3, I);
    for j from 0 to numColumns K - 1 do (
       q := sum(r, i -> if dg#i > 3 or c_(i,0) == 0 or numColumns(Bs#i) == 0 then 0_Sp else c_(i,0) * sum(numColumns(Bs#i), a -> sub(K_(offs#i + a, j), Sp) * (Bs#i)_(0,a)));
       q = back(q % G); if q != 0 then polys = append(polys, q));
    for a from 9 to 11 do (Ra := toP diff(S_a, F); for b from 0 to n1-1 do polys = append(polys, back(Ra * L1_(0,b))));
    m3 := basis(3, S); cf := M -> lift(last coefficients(M, Monomials => m3), kk);
    JS1 := flatten entries ((jacobian matrix{{F}}) * vars S); w1TFpolys = polys | JS1;
    r0 := rank mutableMatrix cf(matrix{flatten entries super basis(3, I) | JS1}); r1 := rank mutableMatrix cf(matrix{polys | JS1});
    pr("  codim without V-moduli = " | toString(364 - r0) | "; WITH Hom_0 = " | toString(364 - r1) | "  total time " | toString(cpuTime()-t0));
    (364 - r0, 364 - r1, numColumns K + 3*n1));
