-- first-order Hodge loci at the Fermat point: delta_2 versus P1 - P2 (two Fermat planes meeting in a P^2). exact over Q(w)
K = toField(QQ[w]/(w^2+w+1));
S = K[x_0..x_11];
Fer = sum(12, i -> x_i^3); J = ideal jacobian ideal Fer;
aPl = L -> (
    fs := apply(L, t -> x_(t#0) + w^(t#2)*x_(t#1));
    gs := apply(L, t -> (x_(t#0) + w^(t#2+1)*x_(t#1))*(x_(t#0) + w^(t#2+2)*x_(t#1)));
    assert(sum(6, t -> fs#t*gs#t) == Fer);
    det jacobian matrix{fs|gs});
P1 = {{0,1,0},{2,3,0},{4,5,0},{6,7,0},{8,9,0},{10,11,0}};
a1 = aPl P1;
<< "single plane: HF S/(J:a_P) = " << toString apply(8, i -> hilbertFunction(i, S/(J : ideal a1))) << endl;
for L in value("{" | concatenate between(",", lines get "pairs_m2.txt") | "}") do (
    a2 := aPl L;
    pl1 := ideal apply(P1, t -> x_(t#0) + w^(t#2)*x_(t#1)); pl2 := ideal apply(L, t -> x_(t#0) + w^(t#2)*x_(t#1));
    m := 11 - codim(pl1+pl2);
    hf := apply(8, i -> hilbertFunction(i, S/(J : ideal(a1-a2))));
    << "P1-P2, dim(P1 cap P2) = " << m << ": HF S/(J:(a1-a2)) = " << toString hf << "  -> codim of first-order Hodge locus " << hf#3 << endl << flush);
