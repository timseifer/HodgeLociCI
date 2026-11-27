needsPackage("HodgeLociCI", FileName => "M2/HodgeLociCI.m2");
for dkc in {(3,3,3), (4,3,2)} do (
    (d, k, c) := dkc;
    D := randomCyclePair(d, toList(c:1), toList(c:1), toList(k+1-c:1), Seed => 11);
    ex := apply({1, -1, 2}, lam -> (tangentExcess(D, lam, Strategy => "Residue"))#"excess");
    << "RESULT (d,k,c) = " << toString dkc << " lambda_0 = (-1)^(c-1) = " << (-1)^(c-1) << " ; excess at lambda = 1, -1, 2 (random instance mod 32003): " << toString ex << endl);
