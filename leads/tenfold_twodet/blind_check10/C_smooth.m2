-- Claim C, smoothness of F only (same seed => same instance as C_check.m2). Homogeneous F4 Groebner basis of the Jacobian ideal.
pr = s -> (stdio << s << endl << flush;);
sd = if #scriptCommandLine > 1 then value scriptCommandLine#1 else 1;
setRandomSeed sd;
kk = ZZ/32003;
S = kk[x_0..x_11];
lin8 = () -> sum(8, i -> random(kk) * x_i);
A = matrix table(3, 3, (i,j) -> lin8());
B = matrix table(3, 3, (i,j) -> lin8());
Q1 = random(2, S); Q2 = random(2, S);
F = x_10*Q1 + x_11*Q2 + det A + det B;
pr("seed " | toString sd | "; F has " | toString(#terms F) | " terms; checksum of F at (1,2,..,12): " | toString sub(F, matrix{apply(12, i -> (i+1)_kk)}));
J = ideal jacobian matrix{{F}};
t0 = cpuTime(); e0 = currentTime();
G = groebnerBasis(J, Strategy => "F4");
pr("F4 Groebner basis: " | toString numcols G | " elements, max degree " | toString max flatten degrees source G | "   [cpu " | toString(cpuTime() - t0) | " s, wall " | toString(currentTime() - e0) | " s]");
L = ideal leadTerm G;
pr("dim of the initial ideal (affine) = " | toString dim L | " => S/J Artinian (F smooth): " | toString(dim L == 0));
pr("pure powers among the lead terms: " | toString apply(12, i -> min apply(select(flatten entries gens L, m -> support m == {x_i}), m -> first degree m)));
hJ = apply(14, d -> hilbertFunction(d, L));
pr("Hilbert function of S/in(J): " | toString hJ | "; equals binomial(12,d): " | toString(hJ == apply(14, d -> binomial(12,d))));
-- sanity: the computed basis elements really lie in J? (spot check by degree-2 part and by reducing J's generators)
pr("generators of J reduce to zero modulo the computed basis: " | toString((gens J) % (forceGB G) == 0));

-- independent engine: M2's standard Buchberger, Hilbert-driven with the hint (1-T^2)^12. Every element it outputs lies in J
-- whatever the hint; so if its lead terms give the Hilbert function binomial(12,d), then HF(S/J) <= binomial(12,d), and
-- HF(S/J) >= binomial(12,d) always (12 quadrics, semicontinuity), hence equality and S/J is Artinian.
t0 = cpuTime(); e0 = currentTime();
hint = poincare ideal apply(12, i -> x_i^2);
Gh = gens gb(J, Hilbert => hint);
pr("Hilbert-driven standard gb: " | toString numcols Gh | " elements, max degree " | toString max flatten degrees source Gh | "   [cpu " | toString(cpuTime() - t0) | " s, wall " | toString(currentTime() - e0) | " s]");
Lh = ideal leadTerm Gh;
pr("same initial ideal as F4: " | toString(Lh == L) | "; dim = " | toString dim Lh | "; Hilbert function " | toString apply(14, d -> hilbertFunction(d, Lh)));
