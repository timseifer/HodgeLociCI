load "setup.m2";
D = setupX(32003, 1); S = D#"S"; kk = D#"kk"; F = D#"F"; IV = D#"IV";
Q = S/(IV^2);
jF = sub(jacobian matrix{{F}}, Q); -- 12x1
jQ = transpose jF;
t0 = cpuTime(); GQ = gb(jQ, ChangeMatrix=>true, Syzygies=>true, DegreeLimit=>9); print("gb JQ deg9 time", cpuTime()-t0);
print("Q/J hilb 7..9", apply({6,7,8,9}, i-> hilbertFunction(i, Q/ideal jQ)));
