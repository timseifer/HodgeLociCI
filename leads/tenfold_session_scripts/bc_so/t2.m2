load "setup.m2";
D = setupX(32003, 1); S = D#"S"; kk = D#"kk"; F = D#"F"; J = D#"J"; IV = D#"IV";
print("numcols I3", numcols D#"I3");
t0 = cpuTime(); GJ = gb J; print("gb J time", cpuTime()-t0);
print("dim J (affine; 0 => X smooth)", dim J);
print("hilbert of S/J", apply(13, i -> hilbertFunction(i, S/J)));
t0 = cpuTime(); G6 = gb(IV + J, DegreeLimit=>6); print("gb I+J time", cpuTime()-t0);
b6 = basis(6, S/(IV+J)); print("dim (S/(I+J))_6", numcols b6, b6);
