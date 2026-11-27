-- second-order sign check for (d,k,c) = (3,3,3): which lambda survives at second order (MOD 32003, one instance)
needsPackage("HodgeLociCI", FileName => "M2/HodgeLociCI.m2");
D = randomCyclePair(3, {1,1,1}, {1,1,1}, {1}, Seed => 11);
scan({1, -1, 2}, lam -> ( r := secondOrderObstruction(D, lam);
    << "RESULT (3,3,3) lambda = " << lam << " : verdict " << toString(r#"verdict") << " ; label " << r#"label" << endl));
