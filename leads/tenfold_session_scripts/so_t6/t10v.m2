-- SO-T6 validation of the Option B evaluator (tenfold).  usage: M2 --script t10v.m2 seed
pr = s -> (stderr << s << endl << flush);
path = append(path, "/home/claude/hodge/package/HodgeLociCI/M2/"); needsPackage "HodgeLociCI";
sd = value scriptCommandLine#1;
kk = ZZ/32003; S = kk[x_0..x_11];
setRandomSeed(sd);
load "/home/claude/hodge/discovery/checks/so_t6/w1lib.m2";
load "/home/claude/hodge/discovery/checks/so_t6/solib.m2";
-- (i) one 5-plane in a random cubic tenfold: F = sum x_i psi_i; my psi (Option B) vs package secondOrderFunctional/(k+1)
phi = toList(x_0..x_5); ps = apply(6, i -> random(2, S)); F = sum(6, i -> phi#i * ps#i);
I = ideal phi;
(piNF, IJ, m0) = soNF(F, I);
R = residueFunctional(phi | ps);
piRow = Pm -> apply(flatten entries Pm, P -> R P);
pr("plane: pi_NF vs residue on a random sextic (proportional?): " | toString(piNF matrix{{m0}}, piRow matrix{{m0}}));
(psiB, pc) = soPsiB(F, I, piRow, IJ, m0, 0);
L = secondOrderFunctional(phi, ps);
Pr = matrix{apply(3, j -> random(9, S))};
t0 = cpuTime();
pr("c3a tenfold plane: mine*6 " | toString apply(psiB Pr, a -> 6*a) | " package " | toString apply(flatten entries Pr, P -> L P) | " time " | toString(cpuTime()-t0));
-- (ii) J2T: consistency on random A + sum B_i dF_i with A in I^2 (c4), two splittings of m0
I = trim w1cycle("J2T");
B3 = super basis(3, I); F = (B3 * random(kk^(numColumns B3), kk^1))_(0,0);
(piRow, IJ, m0) = soNF(F, I);
(psiB, pc) = soPsiB(F, I, piRow, IJ, m0, 0); (psiB2, pc2) = soPsiB(F, I, piRow, IJ, m0, 1);
pr("J2T psi(g_a m0) two splittings: " | toString pc | " / " | toString pc2);
Jr = jacobian matrix{{F}}; I2 = gens trim(I^2);
vals = apply(3, t -> (
    Bs := apply(12, i -> random(7, S)); Ar := (I2 * random(source I2, S^{1:-9}))_(0,0);
    Pc := Ar + sum(12, i -> Bs#i * Jr_(i,0));
    ((psiB matrix{{Pc}})#0, (psiB2 matrix{{Pc}})#0, (first piRow matrix{{sum(12, i -> diff(S_i, Bs#i))}}) / 6)));
pr("c4 J2T: psi(A + sum B dF) [split 0, split 1] vs pi(div B)/6: " | toString vals);
pr("c4 J2T: psi on (I^2)_9 random (zeros): " | toString psiB(I2 * random(source I2, S^{3:-9})));
