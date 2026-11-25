-- unit tests of coneAnalysis with nonzero B
load "/home/claude/hodge/discovery/checks/dp_t6/dplib.m2";
kk = ZZ/32003; setRandomSeed 7; n = 3; nK = 6; nh = 4;
Bs = apply(n, i -> random(kk^nK, kk^nh)); ws = apply(n, i -> random(kk^nh, kk^1));
h2 = 1/2_kk;
QA = new HashTable from flatten apply(n, i -> apply(toList(i..n-1), j -> (i,j) => (if i == j then Bs#i * ws#i else h2 * (Bs#i * ws#j + Bs#j * ws#i))));
CA = coneAnalysis(kk, Bs, QA); print("A (q = B(a)w(a)) expect ALL SURVIVE:", verdictOf CA, CA#"strata");
QB = new HashTable from flatten apply(n, i -> apply(toList(i..n-1), j -> (i,j) => random(kk^nK, kk^1)));
CB = coneAnalysis(kk, Bs, QB); print("B (random q, 6x(4+1) rank drop codim 2 in P^2) expect PARTIAL dim 0:", verdictOf CB, CB#"strata");
Bz = apply(Bs, B -> (map(kk^3, kk^nh, 0)) || B^{0,1,2});
Cc = coneAnalysis(kk, Bz, QB); print("C (3 rows with B = 0, random quadrics in 3 vars) expect ALL DIE:", verdictOf Cc, Cc#"strata", Cc#"dimIq");
-- D: compression path (3 rows, 10 cols): q = B(a)w(a) -> ALL SURVIVE; E: 4 rows with B rank<=3 forced (row 4 = 0 in B) and random q -> Iq one quadric (cone dim 1 in P^2) then rank condition
Bd = apply(n, i -> random(kk^3, kk^10)); wd = apply(n, i -> random(kk^10, kk^1));
QD = new HashTable from flatten apply(n, i -> apply(toList(i..n-1), j -> (i,j) => (if i == j then Bd#i * wd#i else h2 * (Bd#i * wd#j + Bd#j * wd#i))));
CD = coneAnalysis(kk, Bd, QD); print("D (compression, q in span) expect ALL SURVIVE:", verdictOf CD, CD#"strata");
Be = apply(Bd, B -> B || map(kk^1, kk^10, 0));
QE = new HashTable from flatten apply(n, i -> apply(toList(i..n-1), j -> (i,j) => random(kk^4, kk^1)));
CE = coneAnalysis(kk, Be, QE); print("E (one pure quadric row, B full rank 3 on other rows) expect PARTIAL dim 1:", verdictOf CE, CE#"strata", CE#"numIq");
