-- SO-T6 t1 feasibility: tenfold J2T, psi determined?  timing of the lift.  usage: M2 --script t10a.m2 seed
pr = s -> (stderr << s << endl << flush);
p = 32003; kk = ZZ/p; S = kk[x_0..x_11];
setRandomSeed(value scriptCommandLine#1);
load "/home/claude/hodge/discovery/checks/so_t6/w1lib.m2";
load "/home/claude/hodge/discovery/checks/so_t6/solib.m2";
I = trim w1cycle("J2T");
B3 = super basis(3, I); F = (B3 * random(kk^(numColumns B3), kk^1))_(0,0);
pr("I_V generator degrees: " | toString tally flatten degrees source mingens I);
(piRow, IJ, m0) = soNF(F, I);
J = ideal jacobian matrix{{F}};
t0 = cpuTime();
I2 = gens trim(I^2); pr("I^2 gens: " | toString numColumns I2 | " degrees " | toString tally flatten degrees source I2);
A2 = S/(ideal I2 + J); pr("HF of S/(I^2+J) at 6..9: " | toString apply(6..9, e -> hilbertFunction(e, A2)) | " time " | toString(cpuTime()-t0));
psi = soPsi(F, I, piRow, 5, hashTable{"order" => "IJ", "I2" => I2});
Pr = matrix{apply(3, j -> random(9, S))};
t0 = cpuTime(); v1 = psi Pr; pr("psi on 3 random P: " | toString v1 | " time (incl. GB with change matrix) " | toString(cpuTime()-t0));
t0 = cpuTime(); v1 = psi Pr; pr("again: time " | toString(cpuTime()-t0));
Jr = jacobian matrix{{F}};
Bs = apply(12, i -> random(7, S)); Arand = (I2 * random(source I2, S^{1:-9}))_(0,0);
Pc = Arand + sum(12, i -> Bs#i * Jr_(i,0));
t0 = cpuTime();
pr("c4 consistency: " | toString(psi matrix{{Pc}}) | " vs " | toString apply(piRow matrix{{sum(12, i -> diff(S_i, Bs#i))}}, a -> a/6) | " time " | toString(cpuTime()-t0));
psiJI = soPsi(F, I, piRow, 5, hashTable{"order" => "JI", "I2" => I2});
t0 = cpuTime(); pr("c4 order JI: " | toString psiJI Pr | " time " | toString(cpuTime()-t0));
-- W1's failed self-check, now with R in (I^2)_7: pi(d_b R) must vanish
pr("pi(d_b R), R in (I^2)_7 (zeros): " | toString apply(4, j -> (R := (I2 * random(source I2, S^{1:-7}))_(0,0); piRow matrix{{diff(S_(random 12), R)}})));
