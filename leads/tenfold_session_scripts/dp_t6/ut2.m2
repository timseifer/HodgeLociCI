load "/home/claude/hodge/discovery/checks/dp_t6/dplib.m2";
kk = ZZ/32003; setRandomSeed 3; n = 5; nK = 314; nh = 311;
-- structure like expected: B nonzero only on 5 rows
Bs = apply(n, i -> (random(kk^5, kk^nh)) || map(kk^(nK-5), kk^nh, 0));
Qs = new HashTable from flatten apply(n, i -> apply(toList(i..n-1), j -> (i,j) => random(kk^nK, kk^1)));
t0 = cpuTime(); C = coneAnalysis(kk, Bs, Qs); print("size test", verdictOf C, C#"strata", C#"numIq", cpuTime() - t0);
