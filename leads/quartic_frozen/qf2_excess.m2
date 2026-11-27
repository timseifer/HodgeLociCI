-- qf2: prediction P3 of FROZEN_PREDICTION.md at random instances (MOD 32003): first-order excess and second-order
-- verdict for (d,k,c) = (4,2,2) and (4,3,2) at lambda = 1, -1, 2.
needsPackage("HodgeLociCI", FileName => "M2/HodgeLociCI.m2");
for dkc in {(4,2,2), (4,3,2)} do (
    (d, k, c) := dkc;
    D := randomCyclePair(d, toList(c:1), toList(c:1), toList(k+1-c:1), Seed => 11);
    scan({1, -1, 2}, lam -> (
        ex := (tangentExcess(D, lam, Strategy => "Residue"))#"excess";
        vd := if ex == 0 then "no excess" else toString((secondOrderObstruction(D, lam))#"verdict");
        << "RESULT " << toString dkc << " lambda = " << lam << " : first-order excess " << ex << " ; second order: " << vd << endl)));
