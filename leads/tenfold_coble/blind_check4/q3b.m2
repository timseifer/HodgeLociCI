-- E6 over QQ (or ZZ/p with an argument): saturation of (dF8); pairing via multiplication matrices
kk = if #scriptCommandLine > 1 then ZZ/(value scriptCommandLine#1) else QQ;
load "common.m2";
stdio << "field " << toString kk << endl << flush;
stdio << "J8 = (dF8): dim " << dim J8 << " degree " << degree J8 << " HF(R/J8) " << hfl(7,J8) << " HP " << toString hilbertPolynomial(J8, Projective=>false) << endl << flush;
t = cpuTime();
Js = saturate(J8, R_0);
stdio << "saturate(J8, z_0): time " << cpuTime()-t << endl << flush;
stdio << "  HP " << toString hilbertPolynomial(Js, Projective=>false) << "  HF " << hfl(7,Js) << " dim " << dim Js << " degree " << degree Js << endl << flush;
stdio << "  min gens degrees " << toString tally flatten degrees source mingens Js << endl << flush;
stdio << "  J8 subset Js: " << isSubset(J8, Js) << endl << flush;
t = cpuTime();
Jm = J8 : ideal vars R;
stdio << "  J8:m == Js ? " << (Jm == Js) << "  time " << cpuTime()-t << endl << flush;
stdio << "  (Js : m) == Js ? " << ((Js : ideal vars R) == Js) << endl << flush;
-- pairing
t = cpuTime();
K = ISig + ideal(P2);
A = R/K;
stdio << "HF(R/K) " << apply(toList(0..8), d -> hilbertFunction(d, A)) << endl << flush;
B3 = basis(3,A); B4 = basis(4,A); B5 = basis(5,A); B6 = basis(6,A);
stdio << "standard monomial counts " << (numColumns B3, numColumns B4, numColumns B5, numColumns B6) << "  degree-6 generator " << toString B6_(0,0) << endl << flush;
mulmat = (Bsrc, Btgt) -> apply(9, i -> lift(last coefficients(A_i * Bsrc, Monomials => Btgt), kk));
X3 = mulmat(B3,B4); stdio << "X3 done " << cpuTime()-t << endl << flush;
X4 = mulmat(B4,B5); stdio << "X4 done " << cpuTime()-t << endl << flush;
X5 = mulmat(B5,B6); stdio << "X5 done " << cpuTime()-t << endl << flush;
-- for every cubic monomial x_a x_b x_c of R: row vector  lambda(x_a x_b x_c * b_j), j=1..57
m3 = flatten entries basis(3,R);
rows = apply(m3, m -> (
    e := flatten exponents m;
    v := flatten apply(9, i -> toList(e#i : i));   -- the three variable indices
    flatten entries (X5#(v#2) * X4#(v#1) * X3#(v#0))));
Gbig = matrix(kk, rows);    -- 165 x 57: pairing of all cubic monomials against the standard cubic monomials
stdio << "pairing matrix (165 cubic monomials) x (57 standard cubics): rank " << rank Gbig << "  time " << cpuTime()-t << endl << flush;
-- order-independence check: a different order of the three variables gives the same matrix
rows2 = apply(m3, m -> (
    e := flatten exponents m;
    v := flatten apply(9, i -> toList(e#i : i));
    flatten entries (X5#(v#0) * X4#(v#2) * X3#(v#1))));
stdio << "commutativity check " << (Gbig == matrix(kk, rows2)) << endl << flush;
-- Gram on the 57 standard monomials
std3 = flatten entries lift(B3, R);
pos = hashTable apply(#m3, i -> m3#i => i);
G57 = matrix(kk, apply(std3, m -> rows#(pos#m)));
stdio << "57x57 Gram on standard cubics: symmetric " << (G57 == transpose G57) << "  rank " << rank G57 << endl << flush;
