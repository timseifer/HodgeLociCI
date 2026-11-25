-- S3 / S4 : Artinian quotient, pairing on cubics, kernel.   args: prime seed
pr = value(scriptCommandLine#1);
seed = value(scriptCommandLine#2);
setRandomSeed(seed);
load "/home/claude/blind_check/common.m2";
(lam, xv) = drawParams();
<< "prime " << pr << " seed " << seed << " lam " << lam << " x " << xv << endl << flush;
as = asharp(lam, xv);
F = Fof(as, lam, xv);
J = ideal jacobian ideal F;
Phi = ideal random(R^1, R^{3:-2});
I = J + Phi;
<< "S3: affine dim of R/I = " << dim I << endl << flush;
HF = apply(9, d -> hilbertFunction(d, I));
<< "S3: Hilbert function of A, degrees 0..8: " << toString HF << endl << flush;
-- definitions of the cubics D (in R, before any quotient ring is created)
c27 = 27*(1+lam^3);
hz = hcub(zz, lam);
Dk = (k, mult) -> dMx(k) - mult * ((3*(xv#k)^2 + 3*lam*(xv#((k+1)%3))*(xv#((k+2)%3))) / c27) * hz;
dadlam = -3*(xv#0)*(xv#1)*(xv#2)/c27 + hcub(xv,lam)*81*lam^2/c27^2;
Dlam = 3*as*(zz#0)*(zz#1)*(zz#2) + dadlam*hz + 3*(pp#0)*(pp#1)*(pp#2) + 3*(qq#0)*(qq#1)*(qq#2);
Dlam2 = Dlam + dadlam*hz;
Dlam0 = Dlam - dadlam*hz;
assert(ring Dlam === R and ring Dk(0,1) === R);
Js = saturate J;
<< "S4 direct: D_0,D_1,D_2,D_lam in Jsat (ideal of singular surface)? " << toString apply({Dk(0,1),Dk(1,1),Dk(2,1),Dlam}, D -> D % Js == 0) << " ; in J? " << toString apply({Dk(0,1),Dk(1,1),Dk(2,1),Dlam}, D -> D % J == 0) << endl << flush;
<< "S4 direct: dim Jsat_3 / J_3 = " << hilbertFunction(3,J) - hilbertFunction(3,Js) << " ; Jsat_4 == J_4 ? " << (hilbertFunction(4,J) == hilbertFunction(4,Js)) << endl << flush;
A = R/I;
B3 = basis(3, A);
B6 = basis(6, A);
<< "S3: dim A_3 = " << numColumns B3 << ", dim A_6 = " << numColumns B6 << endl << flush;
soc = B6_(0,0);   -- spanning element of A_6
-- delta(e) for e in A_6 : e = delta(e)*soc
delta = (e) -> (if e == 0 then 0_kk else (c := e // soc; assert(c*soc == e); sub(c, kk)));
n3 = numColumns B3;
bl = flatten entries B3;
G = matrix(kk, table(n3, n3, (i,j) -> delta(bl#i * bl#j)));
rk = rank G;
<< "S3: rank of pairing A_3 x A_3 -> A_6 (= rank of bilinear form on 165-dim space of cubics): " << rk << endl << flush;
<< "S3: dim I_3 = " << 165 - n3 << " ; kernel of form on cubics has dim " << 165 - rk << endl << flush;
-- independent recomputation directly on all 165 cubic monomials (no quotient-by-I_3 shortcut)
mons3 = flatten entries basis(3, R);
imgs = apply(mons3, m -> sub(m, A));
full = (#scriptCommandLine > 3 and scriptCommandLine#3 == "full");
if full then (
G165 = matrix(kk, table(#mons3, #mons3, (i,j) -> if i <= j then delta(imgs#i * imgs#j) else 0_kk));
G165 = G165 + transpose G165 - diagonalMatrix(kk, apply(#mons3, i -> G165_(i,i)));
<< "S3: rank of the 165x165 Gram matrix on cubic monomials: " << rank G165 << endl << flush;
);

-- S4
inKer = (D) -> (DA := sub(D, A); all(bl, b -> DA*b == 0));
inKer165 = (D) -> (DA := sub(D, A); all(imgs, b -> DA*b == 0));
scan(3, k -> << "S4: D_" << k << " in kernel: " << inKer(Dk(k,1)) << " (vs all 165 monomials: " << inKer165(Dk(k,1)) << ") ; in I_3: " << (sub(Dk(k,1),A) == 0) << endl << flush);
<< "S4: D_lam in kernel: " << inKer(Dlam) << " (vs all 165 monomials: " << inKer165(Dlam) << ") ; in I_3: " << (sub(Dlam,A) == 0) << endl << flush;
scan(3, k -> << "S4 control: D_" << k << " with doubled h(z) coefficient in kernel: " << inKer(Dk(k,2)) << endl << flush);
scan(3, k -> << "S4 control: D_" << k << " with zero h(z) coefficient in kernel: " << inKer(Dk(k,0)) << endl << flush);
-- variants of D_lam as controls
<< "S4 control: D_lam with doubled (d a#/d lam) in kernel: " << inKer(Dlam2) << " ; with (d a#/d lam) dropped: " << inKer(Dlam0) << endl << flush;
-- span of the four cubics modulo I_3
Dl = {Dk(0,1), Dk(1,1), Dk(2,1), Dlam};
cf = (D) -> last coefficients(matrix{{sub(D,A)}}, Monomials => B3);
CM = sub(fold((a,b) -> a | b, apply(Dl, cf)), kk);
<< "S4: rank of {D_0,D_1,D_2,D_lam} modulo I_3: " << rank CM << "   rank of {D_0,D_1,D_2} mod I_3: " << rank CM_{0,1,2} << endl << flush;
kerG = gens ker G;
<< "S4: dim ker of pairing on A_3: " << numColumns kerG << endl << flush;
<< "S4: rank of [ker | D's] : " << rank(kerG | CM) << "  (equal to dim ker and to rank of D's <=> D's span the kernel mod I_3)" << endl << flush;
eul = sum(3, k -> xv#k * Dk(k,1));
<< "S4 note: sum_k x_k D_k in I_3 ? " << (sub(eul, A) == 0) << " ; in J ? " << (eul % J == 0) << endl << flush;
-- is delta-pairing independent of Phi?  (D's in kernel for another random Phi, quick repeat)
Phi2 = ideal random(R^1, R^{3:-2});
A2 = R/(J+Phi2);
<< "S3 repeat with second random Phi: HF " << toString apply(8, d -> hilbertFunction(d, J+Phi2)) << endl << flush;
b2 = flatten entries basis(3, A2);
assert(all(Dl, D -> ring D === R));
<< "S4 repeat with second Phi: D_0,D_1,D_2,D_lam annihilate A_3: " << toString apply(Dl, D -> (DA := sub(D, A2); all(b2, b -> DA*b == 0))) << endl << flush;
