-- E6 over QQ (or ZZ/p with an argument)
kk = if #scriptCommandLine > 1 then ZZ/(value scriptCommandLine#1) else QQ;
load "common.m2";
stdio << "field " << toString kk << endl << flush;
t = cpuTime();
stdio << "J8 = (dF8): dim " << dim J8 << " degree " << degree J8 << " HF(R/J8) " << hfl(7,J8) << " HP " << toString hilbertPolynomial(J8, Projective=>false) << "  time " << cpuTime()-t << endl << flush;
-- pairing part first (cheap)
t = cpuTime();
K = ISig + ideal(P2);
A = R/K;
stdio << "HF(R/K) " << apply(toList(0..8), d -> hilbertFunction(d, A)) << "  total " << sum apply(toList(0..8), d -> hilbertFunction(d, A)) << endl << flush;
g6 = basis(6,A);
m3 = flatten entries basis(3,R);
m6 = flatten entries basis(6,R);
red = sub(matrix{m6}, A);
cf = lift(last coefficients(red, Monomials => g6), kk);
H = hashTable apply(#m6, i -> m6#i => cf_(0,i));
Gram = matrix(kk, table(#m3, #m3, (i,j) -> H#(m3#i*m3#j)));
stdio << "E6 pairing: " << #m3 << " cubic monomials, " << #m6 << " sextic monomials, degree-6 generator " << toString g6_(0,0) << endl;
stdio << "E6 pairing: Gram symmetric " << (Gram == transpose Gram) << "  rank " << rank Gram << "  time " << cpuTime()-t << endl << flush;
-- second route to the rank: 57 - dim of (0 :_{A_3} A_3) = dim of A_3 / (K : m^3)_3
K3 = K : (ideal vars R)^3;
stdio << "E6 pairing alt: HF(R/(K:m^3)) " << hfl(4, K3) << "   (rank should be the degree-3 entry)" << endl << flush;
-- saturation of J8
t = cpuTime();
Js = saturate(J8, R_0);
stdio << "saturate(J8, z_0): time " << cpuTime()-t << endl << flush;
stdio << "  HP " << toString hilbertPolynomial(Js, Projective=>false) << "  HF " << hfl(7,Js) << " dim " << dim Js << " degree " << degree Js << endl << flush;
stdio << "  min gens degrees " << toString tally flatten degrees source mingens Js << endl << flush;
stdio << "  J8 subset Js: " << isSubset(J8, Js) << endl << flush;
t = cpuTime();
Jm = J8 : ideal vars R;
stdio << "  J8:m == Js ? " << (Jm == Js) << "  time " << cpuTime()-t << endl << flush;
