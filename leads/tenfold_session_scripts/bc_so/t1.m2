load "buildT.m2";
(IT,a,b,x0,y0) = buildT(32003, 1);
print toString (a,b,x0,y0);
print (codim IT, degree IT, hilbertPolynomial(IT, Projective=>false));
print betti res IT;
print (degrees gens IT);
W = ring IT; print (dim singularLocus (W/IT));
