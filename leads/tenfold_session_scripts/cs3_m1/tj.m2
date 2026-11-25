pr = s -> (stderr << s << endl << flush);
kk = ZZ/32003; S = kk[x_0..x_11]; F = random(3, S);
J = ideal jacobian matrix{{F}};
t1 = cpuTime(); GJ = gb(J, DegreeLimit => 6); pr("gb J deg<=6: " | toString(cpuTime()-t1) | " #gb " | toString numColumns gens GJ);
B6 = basis(6, S);
t1 = cpuTime(); NF = B6 % GJ; pr("NF of all S_6: " | toString(cpuTime()-t1));
t1 = cpuTime(); GJc = gb(J, DegreeLimit => 6, ChangeMatrix => true); pr("gb with change: " | toString(cpuTime()-t1));
t1 = cpuTime(); ch = B6_{0..199}; Ac = (ch - (ch % GJc)) // GJc; pr("lift 200: " | toString(cpuTime()-t1) | " terms " | toString sum(flatten entries Ac, a -> #terms a) | " rows " | toString numRows Ac);
