needsPackage("HodgeLociCI", FileName => "../../M2/HodgeLociCI.m2");
S = ZZ/32003[x_0..x_7];
setRandomSeed 2026;
-- a cubic sixfold F = det A + det B with A, B random 3x3 matrices of linear forms
A = random(S^3, S^{3:-1}); B = random(S^3, S^{3:-1});
F = det A + det B;
isSmoothHypersurface F
-- the threefold T where rows 1, 2 of A are proportional and rows 1, 2 of B are proportional
IT = minors(2, A^{0,1}) + minors(2, B^{0,1});
dim IT - 1, degree IT, F % IT == 0
-- first-order tangent codimension of the Hodge locus of the class of T
t = hodgeLocusTangentCodim(F, IT);
t#"codim", t#"codimIJ", t#"hypothesis", t#"exponent"
t#"label"
-- for comparison: the codimension of (I(T) + J)_3 (cubics containing T, up to first-order changes of coordinates),
-- and the codimension of the tangent space of the family {det A + det B} (cubics in the ideal of all 2x2 minors)
J = ideal jacobian matrix{{F}};
hilbertFunction(3, IT + J), hilbertFunction(3, minors(2, A) + minors(2, B))
-- the Hodge number h^(4,2) of a cubic sixfold: no Hodge locus has more than 8 local equations
primitiveHodgeNumbers(6, 3)
-- the same tool on a 3-plane in a cubic sixfold (a linear cycle): codimension binomial(6,3) - 16 = 4
D = randomCyclePair(3, {1}, {1}, {1,1,1}, Seed => 2026);
(hodgeLocusTangentCodim(D#"F", ideal(D#"f" | D#"p")))#"codim"
