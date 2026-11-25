-- SO-T6 controls c3a/c3b/c4/c1 on cubic sixfolds with two 3-planes meeting in a point (package randomCyclePair, c = 3, e = 1)
-- usage: M2 --script c3six.m2 seed
pr = s -> (stderr << s << endl << flush);
path = append(path, "/home/claude/hodge/package/HodgeLociCI/M2/"); needsPackage "HodgeLociCI";
sd = value scriptCommandLine#1;
D = randomCyclePair(3, {1,1,1}, {1,1,1}, {1}, Seed => sd);
S = D#"ring"; kk = coefficientRing S; F = D#"F"; k = 3;
load "/home/claude/hodge/discovery/checks/so_t6/solib.m2";
setRandomSeed(sd);
phi1 = D#"f" | D#"p"; psi1 = D#"g" | D#"s"; phi2 = D#"h" | D#"p"; psi2 = D#"q" | D#"s";
pr("F == sum phi psi (both): " | toString(F == sum(#phi1, i -> phi1#i*psi1#i), F == sum(#phi2, i -> phi2#i*psi2#i)));
R1 = residueFunctional(phi1 | psi1); R2 = residueFunctional(phi2 | psi2);
piRow1 = Pm -> apply(flatten entries Pm, P -> R1 P); piRow2 = Pm -> apply(flatten entries Pm, P -> R2 P);
I1 = ideal phi1; I2 = ideal phi2;
-- first-order sanity: pi_i vanishes on (I_i + J)_4
J = ideal jacobian matrix{{F}};
pr("pi_1 on random elts of (I1+J)_4 (zeros): " | toString piRow1(gens(I1 + J) * random(source gens(I1+J), S^{3:-4})));
psiA = soPsi(F, I1, piRow1, k, hashTable{"order" => "IJ"}); psiB = soPsi(F, I2, piRow2, k, hashTable{"order" => "IJ"});
psiA2 = soPsi(F, I1, piRow1, k, hashTable{"order" => "JI"});
pr("HF_7 of S/(I1^2+J), S/(I2^2+J) (0 = psi determined): " | toString(hilbertFunction(7, S/(I1^2+J)), hilbertFunction(7, S/(I2^2+J))));
-- c3a: psi_i == package secondOrderFunctional / (k+1)
L1 = secondOrderFunctional(phi1, psi1); L2 = secondOrderFunctional(phi2, psi2);
Pr = matrix{apply(5, j -> random(7, S))};
pr("c3a plane 1: mine*(k+1) " | toString apply(psiA Pr, a -> (k+1)*a) | " package " | toString apply(flatten entries Pr, P -> L1 P));
pr("c3a plane 2: mine*(k+1) " | toString apply(psiB Pr, a -> (k+1)*a) | " package " | toString apply(flatten entries Pr, P -> L2 P));
-- c4: two generator orders; and consistency psi(A + sum B_i dF_i) = pi(div B)/(k+1)
pr("c4 order IJ vs JI equal: " | toString(psiA Pr == psiA2 Pr));
Jr = jacobian matrix{{F}};
Bs = apply(8, i -> random(5, S)); Arand = (gens trim(I1^2) * random(source gens trim(I1^2), S^{1:-7}))_(0,0);
Pc = Arand + sum(8, i -> Bs#i * Jr_(i,0));
pr("c4 consistency: " | toString(psiA matrix{{Pc}}) | " vs " | toString apply(piRow1 matrix{{sum(8, i -> diff(S_i, Bs#i))}}, a -> a/(k+1)));
-- c3b: second-order test with my functionals
B3 = basis(3, S); BQ = basis(1, S);
C1 = soPairing(piRow1, BQ, B3); C2 = soPairing(piRow2, BQ, B3);
TVZ = matrix nullSpace mutableMatrix(C1 || C2);
pr("dim T V_Z = " | toString numColumns TVZ);
testLam = lam -> (
    C := C1 + lam * C2;
    TNL := matrix nullSpace mutableMatrix C; Kl := matrix nullSpace mutableMatrix transpose C;
    e := numColumns TNL - numColumns TVZ;
    psiL := Pm -> (psiA Pm) + apply(psiB Pm, a -> lam * a);
    Ge := null; for j from 0 to numColumns TNL - 1 do if rank(TVZ | TNL_{j}) > rank TVZ then (Ge = (soPolys(B3, TNL_{j}))_(0,0); break);
    Kp := flatten entries soPolys(BQ, Kl);
    hs := flatten entries soPolys(B3, TVZ);
    q := matrix{psiL matrix{apply(Kp, Q -> Q * Ge^2)}};
    Bm := matrix apply(hs, h -> psiL matrix{apply(Kp, Q -> Q * Ge * h)});
    -- c1: two random family directions
    h1 := (soPolys(B3, TVZ * random(kk^(numColumns TVZ), kk^1)))_(0,0); h2 := (soPolys(B3, TVZ * random(kk^(numColumns TVZ), kk^1)))_(0,0);
    c1 := (psiL matrix{apply(Kp, Q -> Q * h1^2)}, psiL matrix{apply(Kp, Q -> Q * h1 * h2)});
    -- c2: a direction outside T NL fails at order 1
    gout := random(3, S); c2 := rank matrix{piRow1(BQ * gout)} ;
    pr("lambda = " | toString lam | ": excess e = " | toString e | ", dim K = " | toString numColumns Kl
       | "; c1 (zeros) " | toString c1 | "; q(Ge) " | toString flatten entries q
       | "; rank B = " | toString rank Bm | ", rank [B;q] = " | toString rank(Bm || q)
       | " => " | (if rank(Bm || q) > rank Bm then "OBSTRUCTED" else "UNOBSTRUCTED"));
    );
testLam(2_kk); testLam(1_kk); testLam(3_kk); testLam(-1_kk);
for lam in {2, 1, 3, -1} do pr("package verdict lambda = " | toString lam | ": " | (secondOrderObstruction(D, lam, Strategy => "Both"))#"verdict");
