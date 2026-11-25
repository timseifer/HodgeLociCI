-- common setup: p and sd must be set by the caller
setRandomSeed sd;
kk = ZZ/p;
R = kk[y_0..y_8];
ent = new MutableHashTable;
for i from 0 to 5 do for j from i+1 to 5 do ent#(i,j) = random(1,R);
M = matrix table(6,6,(i,j)-> if i<j then ent#(i,j) else if i>j then -ent#(j,i) else 0_R);
F = (pfaffians(6,M))_0;
IS = pfaffians(4,M);
blk = L -> submatrix(M, L, L);
pf4 = L -> (pfaffians(4, blk L))_0;
tm0 = cpuTime();
tick = s -> (stdio << "   [" << s << " t=" << (cpuTime()-tm0) << "s]" << endl << flush);
