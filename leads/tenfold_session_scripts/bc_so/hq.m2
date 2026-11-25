load "setup.m2";
D = setupX(32003, 1); S = D#"S"; IV = D#"IV"; IT = D#"IT";
print("betti IT", toString betti res IT);
I2 = IV^2; print("hilb S/I^2 deg 6..9", apply({6,7,8,9}, i -> hilbertFunction(i, S/I2)));
print("hilb S/I deg 6..9", apply({6,7,8,9}, i -> hilbertFunction(i, S/IV)));
print("numgens I2", numgens I2, "dim S_9", numcols basis(9,S));
