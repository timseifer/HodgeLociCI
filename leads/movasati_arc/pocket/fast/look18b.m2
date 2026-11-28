load "run18_q10_31981.m2";
nz = select(F, f -> f != 0); lin = select(nz, f -> first degree f <= 1); quad = select(nz, f -> first degree f == 2);
z0 = apply(gens R, v -> v => 0);
-- parametrise the affine solution space of the linear ones
A = matrix apply(lin, f -> apply(gens R, v -> coefficient(v, f))); b = matrix apply(lin, f -> {- sub(f, z0)});
x0 = solve(A, b);                      -- a particular solution (8 x 1)
K = gens ker A;                        -- 8 x 6
S = kk[w_0..w_(numcols K - 1)];
phi = map(S, R, flatten entries (sub(x0, S) + sub(K, S) * transpose vars S));
Q = apply(quad, f -> phi f);
<< "on the " << numcols K << "-dim affine space: " << #Q << " quadratics" << endl;
-- coefficient matrix of non-constant monomials, and constants
mons = unique flatten apply(Q, q -> select(flatten entries monomials q, m -> first degree m > 0));
C = matrix apply(Q, q -> apply(mons, m -> coefficient(m, q)));
c0 = matrix apply(Q, q -> {sub(q, apply(gens S, v -> v => 0))});
<< "rank of non-constant parts " << rank C << " (of " << numcols C << " monomials) ; rank with constants " << rank (C | c0) << endl;
<< "rank of the quadratic parts alone: " << rank matrix apply(Q, q -> apply(select(mons, m -> first degree m == 2), m -> coefficient(m, q))) << endl;
<< "rank of the linear parts alone: " << rank matrix apply(Q, q -> apply(select(mons, m -> first degree m == 1), m -> coefficient(m, q))) << endl;
J = ideal Q; << "unit ideal on the affine space: " << (J == ideal 1_S) << endl;
-- drop one quadratic at a time: does the rest have zeros?
for i to #Q-1 do (Ji = ideal drop(Q, {i,i}); << "  without quadratic " << i << ": unit " << (Ji == ideal 1_S) << (if Ji != ideal 1_S then " dim " | toString dim Ji else "") << endl);
exit 0
