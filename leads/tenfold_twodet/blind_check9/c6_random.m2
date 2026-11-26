-- C6 at random members of the family (D4), MOD p
runOne = (p, sd) -> (
    setRandomSeed sd;
    kk := ZZ/p;
    S := kk[x_0..x_11];
    l1 := random(1,S); l2 := random(1,S); Q1 := random(2,S); Q2 := random(2,S);
    A := matrix apply(3, i -> apply(3, j -> random(1,S)));
    B := matrix apply(3, i -> apply(3, j -> random(1,S)));
    F := l1*Q1 + l2*Q2 + det A + det B;
    I := ideal(l1,l2,Q1,Q2) + minors(2,A) + minors(2,B);
    J := ideal jacobian ideal F;
    hf := apply(9, i -> hilbertFunction(i, S/I));
    << "p=" << p << " seed=" << sd << ": HF(S/I) = " << toString hf << endl;
    << "   J subset I: " << isSubset(J, I) << ";  numgens I = " << numgens trim I << endl;
    -- honest tangent space: differentiate the parametrization with dual numbers
    T := S[eps]/(eps^2);
    toT := map(T, S);
    dvecs := {};
    m1 := flatten entries basis(1,S); m2 := flatten entries basis(2,S);
    coefEps := g -> (c := coefficients(g, Monomials => matrix{{1_T, eps}}); lift((c#1)_(1,0), S));
    for m in m1 do (
        dvecs = append(dvecs, coefEps((toT l1 + eps*toT m)*toT Q1));
        dvecs = append(dvecs, coefEps((toT l2 + eps*toT m)*toT Q2)));
    for m in m2 do (
        dvecs = append(dvecs, coefEps(toT l1*(toT Q1 + eps*toT m)));
        dvecs = append(dvecs, coefEps(toT l2*(toT Q2 + eps*toT m))));
    for i from 0 to 2 do for j from 0 to 2 do for m in m1 do (
        E := mutableMatrix(T,3,3); E_(i,j) = eps*toT m;
        dvecs = append(dvecs, coefEps det(toT ** A + matrix E));
        dvecs = append(dvecs, coefEps det(toT ** B + matrix E)));
    D := matrix{dvecs};
    cf := (coefficients(D, Monomials => basis(3,S)))#1;
    << "   #parameter directions = " << #dvecs << ", rank of differential = " << rank cf
       << ", dim I_3 = " << (binomial(14,3) - hf#3) << ", all derivatives in I: " << (D % I == 0) << endl;
    IT := ideal(l1,l2) + minors(2, A^{0,1}) + minors(2, B^{0,1});
    << "   T5: affine dim " << dim IT << ", degree " << degree IT << ", F in I(T5): " << (F % IT == 0) << endl;
    );
runOne(32003, 11);
runOne(30011, 12);
runOne(10007, 13);
