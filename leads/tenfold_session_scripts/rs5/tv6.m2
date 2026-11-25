needsPackage("HodgeLociCI", FileName => "/home/claude/hodgelocici/M2/HodgeLociCI.m2");
S = fermatRing(3, 6); x = gens S;
L1 = {{0,1,1},{2,3,1},{4,5,1},{6,7,1}}; L2 = {{0,1,3},{2,3,3},{4,5,3},{6,7,1}};
J = ideal jacobian ideal sum(8, i -> x_i^3);
I = intersect(fermatLinearSpaceIdeal(S, L1) + J, fermatLinearSpaceIdeal(S, L2) + J);
for T in {x_1*x_3*x_5, x_0*x_2*x_4} do print("RESULT T " | toString T | " in T V_Z? " | toString(T % I == 0) | "  in I(P1)+J? " | toString(T % (fermatLinearSpaceIdeal(S, L1) + J) == 0) | "  in I(P2)+J? " | toString(T % (fermatLinearSpaceIdeal(S, L2) + J) == 0));
