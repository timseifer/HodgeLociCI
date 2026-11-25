-- C1: first-order structure at a general point of F_T, done entirely in the P^8 (9 variables). MOD p. AI-written, unreviewed.
-- usage: M2 --script c1_general_point.m2 32003 1
-- Pre-registration (written before the first run): A = k[z,p,q]/(I_V8 + (dF8/dp, dF8/dq) + (Phi_0,Phi_1,Phi_2)) is S/(I_V + J_F).
--   Expected from the registry (MOD p): dim A_6 = 1, pairing rank on S_3 = 54, codim (I_V+J)_3 = 57 (= 55 + 2 moduli of T).
--   H1: e0(z) = det M(z,.,.) lies in the pairing kernel (then the extra direction would be "add the third determinant").
--   If not, that hypothesis is dead at first order.   RESULT (25 Nov 2026): rank 54 reproduced; H1 FALSE.
pp = value(scriptCommandLine#1); sd = value(scriptCommandLine#2);
setRandomSeed sd;
kk = ZZ/pp;
R = kk[z_0..z_2, p_0..p_2, q_0..q_2];
zz = {z_0,z_1,z_2}; ps = {p_0,p_1,p_2}; qs = {q_0,q_1,q_2};
T = apply(3, k -> random(kk^3, kk^3));
Qk = apply(3, k -> (matrix{ps} * T#k * transpose matrix{qs})_(0,0));
e1 = det matrix apply(3, k -> apply(3, j -> sum(3, i -> (T#k)_(i,j) * ps#i)));
e2 = det matrix apply(3, k -> apply(3, i -> sum(3, j -> (T#k)_(i,j) * qs#j)));
e0 = det matrix apply(3, i -> apply(3, j -> sum(3, k -> (T#k)_(i,j) * zz#k)));
IV = ideal(Qk | {e1, e2});
t = cpuTime(); B3 = super basis(3, IV); << "dim I_V8(3) = " << numColumns B3 << "  t=" << cpuTime()-t << endl << flush;
F8 = (B3 * random(kk^(numColumns B3), kk^1))_(0,0);
Phi = apply(3, k -> random(2, R));
dF = apply(gens R, v -> diff(v, F8));
I = IV + ideal(drop(dF, 3)) + ideal Phi;
t = cpuTime(); G = gb(I, DegreeLimit => 7); << "gb to degree 7  t=" << cpuTime()-t << endl << flush;
A = R/I;
t = cpuTime(); << "HF of A, d=0..7: " << apply(toList(0..7), d -> hilbertFunction(d, A)) << "  t=" << cpuTime()-t << endl << flush;
b6 = basis(6, A); b3 = basis(3, A);
t = cpuTime(); B6 = basis(6, R); NF = B6 % G; << "NF  t=" << cpuTime()-t << endl << flush;
mons6 = flatten entries B6;
s6 = lift(b6_(0,0), R);
t = cpuTime(); dl = flatten entries lift(last coefficients(NF, Monomials => matrix{{s6}}), kk); << "coeffs t=" << cpuTime()-t << " #" << #dl << endl << flush;
idx = new MutableHashTable; scan(#mons6, i -> idx#(mons6#i) = i);
m3 = flatten entries basis(3, R);
t = cpuTime(); PM = matrix(kk, apply(m3, a -> apply(m3, b -> dl#(idx#(a*b))))); << "PM t=" << cpuTime()-t << endl << flush;
<< "pairing rank on S_3 = " << rank PM << " (registry: 54)" << endl << flush;
cf = f -> lift(last coefficients(matrix{{f}}, Monomials => matrix{m3}), kk);
inker = f -> (PM * cf f) == 0;
<< "H1: e0(z) in pairing kernel: " << inker e0 << " ;  e0 in (I_V+J)_3: " << ((e0 % G) == 0) << endl;
rz = sum(10, i -> random(kk) * (basis(3, R, Variables => {0,1,2}))_(0,i));
<< "controls: e1 in kernel " << inker e1 << "; random z-cubic in kernel " << inker rz << "; random cubic " << inker random(3,R) << endl << flush;
K = gens ker PM; Kpol = (matrix{m3}) * K;
KC = lift(last coefficients(sub(Kpol, A), Monomials => b3), kk);
<< "dim kernel = " << numColumns K << " ; rank of kernel in A_3 = " << rank KC << " (expect 3)" << endl << flush;
use R; zz = {z_0,z_1,z_2}; ps = {p_0,p_1,p_2}; qs = {q_0,q_1,q_2};
tens = flatten flatten apply(3, k -> apply(3, i -> apply(3, j -> zz#k*ps#i*qs#j)));
TC = lift(last coefficients(sub(matrix{tens}, A), Monomials => b3), kk);
zcub = flatten entries basis(3, R, Variables => {0,1,2});
ZC = lift(last coefficients(sub(matrix{zcub}, A), Monomials => b3), kk);
<< "rank tensors in A_3 = " << rank TC << " ; z-cubics in A_3 = " << rank ZC << " ; both = " << rank (TC|ZC) << endl;
<< "dim (kernel/I3) ∩ span(tensors) = " << rank KC + rank TC - rank (KC | TC) << endl;
<< "dim (kernel/I3) ∩ span(z-cubics) = " << rank KC + rank ZC - rank (KC | ZC) << endl;
<< "dim (kernel/I3) ∩ span(tensors, z-cubics) = " << rank KC + rank (TC|ZC) - rank (KC | TC | ZC) << endl << flush;
-- weights: for each (a,b,c) = (z-deg, p-deg, q-deg) block of cubic monomials, dimension of (kernel/I3) ∩ block-span
blocks = new MutableHashTable;
scan(m3, m -> (e := first exponents m; w := (e#0+e#1+e#2, e#3+e#4+e#5, e#6+e#7+e#8); if not blocks#?w then blocks#w = {}; blocks#w = append(blocks#w, m)));
scan(sort keys blocks, w -> (BC := lift(last coefficients(sub(matrix{blocks#w}, A), Monomials => b3), kk);
   << "block (z,p,q)-degree " << w << ": #mons " << #(blocks#w) << " rank in A_3 " << rank BC << "  ∩ kernel/I3: " << rank KC + rank BC - rank(KC|BC) << endl));
