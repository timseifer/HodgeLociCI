kk = ZZ/32003; setRandomSeed 3; n = 5; nK = 314; nh = 311;
Bs = apply(n, i -> (random(kk^5, kk^nh)) || map(kk^(nK-5), kk^nh, 0));
Qs = new HashTable from flatten apply(n, i -> apply(toList(i..n-1), j -> (i,j) => random(kk^nK, kk^1)));
A = kk[a_1..a_n]; av = gens A;
t=cpuTime(); Bcoef = fold((u,w) -> u | w, Bs); Lk = gens ker transpose Bcoef; print("ker", cpuTime()-t);
t=cpuTime(); rB = rank Bcoef; piv = rowRankProfile mutableMatrix Bcoef; print("rank/prof", cpuTime()-t);
t=cpuTime(); Qfull = sum flatten apply(n, i -> apply(toList(i..n-1), j -> sub(Qs#(i,j), A) * av#i*av#j)); print("Qfull", cpuTime()-t);
t=cpuTime(); Bfull = sum(n, i -> av#i * sub(Bs#i, A)); print("Bfull", cpuTime()-t);
t=cpuTime(); Iq = ideal flatten entries (transpose(sub(Lk, A)) * Qfull); Iq = trim Iq; print("Iq", cpuTime()-t);
