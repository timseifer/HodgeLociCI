load "setup.m2";
D = setupX(32003, 1); S = D#"S"; kk = D#"kk"; F = D#"F"; J = D#"J"; IV = D#"IV";
t0 = cpuTime(); G6 = gb(IV + J, DegreeLimit=>6); print("gb I+J deg6 time", cpuTime()-t0);
b6 = basis(6, S/(IV+J)); print("dim (S/(I+J))_6", numcols b6, toString b6);
print("dim (I+J)", dim(IV+J));
I2 = IV^2; print("hilb S/I2 deg 7,9", hilbertFunction(7, S/I2), hilbertFunction(9,S/I2));
