-- same as c5_ranks.m2 but over ZZ/p with w a primitive cube root of unity mod p, and ranks by plain linear algebra
p = 31; while not (isPrime p and p % 3 == 1 and p > 20000) do p = p + 1; -- placeholder, replaced below
p = 30013; assert(isPrime p and p % 3 == 1);
kk = ZZ/p;
w = (select(toList(2..p-1), t -> (t^3) % p == 1))#0; w = w_kk;
<< "p = " << p << ", w = " << w << ", w^2+w+1 = " << w^2+w+1 << endl;
S = kk[x_0..x_11];
Fer = sum(12, i -> x_i^3); J = ideal jacobian ideal Fer; R = S/J; use S;
aPl = L -> (
    fs := apply(L, t -> x_(t#0) + w^(t#2)*x_(t#1));
    gs := apply(L, t -> (x_(t#0) + w^(t#2+1)*x_(t#1))*(x_(t#0) + w^(t#2+2)*x_(t#1)));
    assert(sum(6, t -> fs#t*gs#t) == Fer);
    det jacobian matrix{fs|gs});
rks = a -> (aq := sub(a,R); apply(7, k -> rank (coefficients(aq*basis(k,R), Monomials => basis(k+6,R)))#1));
P1 = {{0,1,0},{2,3,0},{4,5,0},{6,7,0},{8,9,0},{10,11,0}};
a1 = aPl P1;
<< "single plane: ranks R_k -> R_{k+6}: " << toString rks a1 << ";  colon HF: " << toString apply(8, i -> hilbertFunction(i, S/(J : ideal a1))) << endl;
for L in value("{" | concatenate between(",", lines get "pairs_m2.txt") | "}") do (
    a2 := aPl L;
    << "P1-P2: ranks " << toString rks(a1-a2) << ";  colon HF " << toString apply(8, i -> hilbertFunction(i, S/(J : ideal(a1-a2)))) << endl << flush);
d = aPl{{0,1,1},{2,3,1},{4,5,1},{6,7,1},{8,9,0},{10,11,0}} - aPl{{0,1,1},{2,3,1},{4,5,0},{6,7,2},{8,9,0},{10,11,0}} - aPl{{0,1,0},{2,3,2},{4,5,1},{6,7,1},{8,9,0},{10,11,0}} + aPl{{0,1,0},{2,3,2},{4,5,0},{6,7,2},{8,9,0},{10,11,0}};
<< "delta_2: ranks " << toString rks d << ";  colon HF " << toString apply(8, i -> hilbertFunction(i, S/(J : ideal d))) << endl;
