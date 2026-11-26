-- Claim A: dimension, degree and Hilbert numerator of the ideal of the 27 quadrics over several fields.
pr = s -> (stdio << s << endl << flush;);
scan({QQ, ZZ/32003, ZZ/101, ZZ/7, ZZ/5, ZZ/3, ZZ/2}, kk -> (
    R := kk[a_(1,1)..a_(3,3), b_(1,1)..b_(3,3), c_(1,1)..c_(3,3)];
    A := transpose genericMatrix(R, R_0, 3, 3);
    B := transpose genericMatrix(R, R_9, 3, 3);
    C := transpose genericMatrix(R, R_18, 3, 3);
    T := R[z_0..z_2];
    N := T_0*sub(A,T) + T_1*sub(B,T) + T_2*sub(C,T);
    mins := flatten entries gens minors(2, N);
    I := ideal flatten apply(mins, m -> apply({T_0*T_1, T_0*T_2, T_1*T_2}, mon -> lift(coefficient(mon, m), R)));
    pr(toString kk | ": dim " | toString dim I | ", degree " | toString degree I | ", numerator " | toString numerator hilbertSeries(I, Reduce => true))));
