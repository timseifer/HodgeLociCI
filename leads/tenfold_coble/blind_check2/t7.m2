-- T7: second-order test E2.  OWN implementation (does not load any engine file).
-- Idea: S = kk[z,p,q,w], T = kk[z,p,q].  Jac(F) + (w) restricted to T is JT = (dF8/dx_i, G_k|_{w=0}),
-- an Artinian ideal with (T/JT)_d = 0 for d >= 7 and (T/JT)_6 one-dimensional.  Hence
-- S_9 = Jac_9 + ((w)^2)_9, and since (w)^2 is contained in I^2, psi on S_9 is forced by
--   psi((w)^2) = 0  and  psi(sum_j B_j dF/dx_j) = (1/6) pi(sum_j dB_j/dx_j).
-- For P = P0 + sum_l w_l P_l (mod (w)^2):
--   step 1: P0 = sum_j beta_j D0_j              (D0_j = dF/dx_j at w=0, j over all 12 variables)
--   step 2: P_l - sum_j beta_j D1_{j,l} = sum_j beta^l_j D0_j   (D1_{j,l} = coefficient of w_l in dF/dx_j)
--   psi(P) = (1/6) pi_T( sum_{j<=9} d beta_j/dx_j + sum_k beta^k_{w_k} ).
pp = value(scriptCommandLine#1); sd = value(scriptCommandLine#2);
setRandomSeed sd;
kk = ZZ/pp;
T = kk[z_0..z_2,p_0..p_2,q_0..q_2];
S = kk[z_0..z_2,p_0..p_2,q_0..q_2,w_0..w_2];
toT = map(T, S, (gens T) | {0_T,0_T,0_T});
toS = map(S, T, (gens S)_{0..8});
use T;
zs = {z_0,z_1,z_2}; ps = {p_0,p_1,p_2}; qs = {q_0,q_1,q_2};
hcub = (lam, v) -> v#0^3+v#1^3+v#2^3+3*lam*v#0*v#1*v#2;
Mform = (x, zz, pv, qv) -> sum(3, i -> sum(3, j -> zz#((i+j)%3) * x#((i-j+3)%3) * pv#i * qv#j));
rnz = () -> (c := random kk; while c == 0 do c = random kk; c);
xv = {rnz(), rnz(), rnz()};
lam = -(xv#0^3+xv#1^3+xv#2^3)/(3*xv#0*xv#1*xv#2);
assert(1 + lam^3 != 0); assert(hcub(lam, xv) == 0);
F8 = hcub(lam, ps) + hcub(lam, qs) + Mform(xv, zs, ps, qs);
Gk = apply(3, k -> random(2, S));
F = toS F8 + sum(3, k -> S_(9+k) * Gk#k);
<< "T7 p=" << pp << " seed=" << sd << " lam=" << lam << " x=" << xv << endl << flush;
-- arc data
dxv = {rnz(), rnz(), rnz()};
den = 27*(1+lam^3);
U = kk[tt];
tay = hcub(sub(lam,U), apply(3, i -> sub(xv#i,U) + tt*sub(dxv#i,U)));
c1 = sub(coefficient(tt, tay), kk); c2 = sub(coefficient(tt^2, tay), kk);
a1 = -c1/den; a2 = -c2/den;
-- cross-check of a1 via gradient
gradh = {3*xv#0^2 + 3*lam*xv#1*xv#2, 3*xv#1^2 + 3*lam*xv#0*xv#2, 3*xv#2^2 + 3*lam*xv#0*xv#1};
assert(c1 == sum(3, i -> gradh#i * dxv#i));
use T;
Aarc = Mform(dxv, zs, ps, qs) + a1*hcub(lam, zs);
hz = hcub(lam, zs);
<< "T7 dx=" << dxv << " a1=" << a1 << " a2=" << a2 << endl << flush;
t0 = cpuTime();
-- D0, D1
dF = apply(gens S, v -> diff(v, F));                       -- 12 partials in S
D0 = matrix{apply(dF, f -> toT f)};                         -- 1 x 12 over T
D1 = apply(3, l -> matrix{apply(dF, f -> toT diff(S_(9+l), f))});   -- for each l: 1 x 12 over T (linear forms)
JT = ideal D0;
BT = T/JT; use T;
hfJT = apply(10, d -> hilbertFunction(d, BT));
<< "T7: HF of T/JT = S/(Jac + (w)): " << hfJT << endl << flush;
assert(hfJT#6 == 1 and hfJT#7 == 0);
mstd = lift((basis(6, BT))_(0,0), T);
gJT = gb JT;
piT = f -> (r := f % gJT; coefficient(mstd, r));          -- f in T_6
piRow = M -> matrix{apply(flatten entries M, piT)};       -- on a 1-row matrix of sextics
-- pi kills the ideal of V
I0 = ideal(diff(z_0,F8), diff(z_1,F8), diff(z_2,F8), hcub(lam,ps), hcub(lam,qs));
<< "T7: V: affine dim of I0 in T = " << dim I0 << ", degree " << degree I0 << "; F8 in I0? " << (F8 % I0 == 0) << endl;
hf6 = hilbertFunction(6, T/(JT+I0)); use T;
<< "T7: dim (T/(JT+I0))_6 = " << hf6 << "  (1 => pi vanishes on (I+Jac)_6 and is unique up to scale)" << endl << flush;
-- first-order condition
b3 = basis(3, T); b2 = basis(2, T);
fo = piRow(Aarc * b3);
<< "T7: first-order condition pi(Q*A) = 0 for all 165 cubic monomials Q in z,p,q: " << (fo == 0) << endl << flush;

-- ---------- export the instance for the independent Python (dual) computation ----------
lf = f -> toString listForm f;
fn = "/home/claude/blind_check2/inst_" | toString pp | "_" | toString sd | ".txt";
fh = openOut fn;
fh << "p = " << pp << endl;
fh << "seed = " << sd << endl;
fh << "lam = " << toString lam << endl;
fh << "x = " << toString xv << endl;
fh << "dx = " << toString dxv << endl;
fh << "a1 = " << toString a1 << endl;
fh << "a2 = " << toString a2 << endl;
fh << "F8 = " << lf F8 << endl;
fh << "A = " << lf Aarc << endl;
fh << "hz = " << lf hz << endl;
fh << "mstd = " << lf mstd << endl;
scan(12, j -> fh << "D0_" << j << " = " << lf D0_(0,j) << endl);
scan(3, l -> scan(12, j -> fh << "D1_" << l << "_" << j << " = " << lf (D1#l)_(0,j) << endl));
scan(5, i -> fh << "I0_" << i << " = " << lf I0_i << endl);
close fh;
<< "instance written to " << fn << endl << flush;
if #scriptCommandLine > 3 and scriptCommandLine#3 == "export" then exit 0;
-- psi machinery
divT = M -> sum(9, j -> diff(T_j, M^{j}));    -- M: 12 x N matrix; divergence of the first 9 rows
psiOf = (P0, Pl) -> (
    -- P0: 1 x N of degree 9 (or zero), Pl: list of three 1 x N matrices of degree 8 (or zero); returns 1 x N over kk of psi-values
    N := numColumns P0;
    beta := P0 // D0;
    if D0 * beta != P0 then error "step 1 division failed";
    dv := divT beta;                              -- 1 x N, degree 6
    scan(3, l -> (
        Rl := Pl#l - (D1#l) * beta;
        bl := Rl // D0;
        if D0 * bl != Rl then error "step 2 division failed";
        dv = dv + bl^{9+l};
    ));
    (1/6_kk) * piRow dv);
zeroRow = N -> map(T^1, T^N, 0);
-- (A) Q in T_3 : P = Q A^2
A2 = Aarc^2;
qidx = value(scriptCommandLine#3);        -- list of indices into basis(3,T)
nq = #qidx;
P0 = A2 * b3_qidx;
psiA = psiOf(P0, {zeroRow nq, zeroRow nq, zeroRow nq});
<< "M2DIRECT W0 indices " << toString qidx << endl;
<< "M2DIRECT W0 exps " << toString apply(flatten entries b3_qidx, m -> first exponents m) << endl;
<< "M2DIRECT W0 psi " << toString flatten entries psiA << endl;
lhsU = piRow(hz * b3_qidx);
<< "M2DIRECT W0 piQh " << toString flatten entries lhsU << endl;
<< "M2DIRECT W0 E2 agree (a2*pi(Q h) == 3 psi(Q A^2)): " << toString apply(nq, i -> a2*lhsU_(0,i) == 3*psiA_(0,i)) << endl << flush;
<< "   time " << cpuTime()-t0 << endl << flush;
widx = value(scriptCommandLine#4);        -- list of indices into basis(2,T)
nw = #widx;
P1 = A2 * b2_widx;
scan(3, m -> (
    Pl := apply(3, l -> if l == m then P1 else zeroRow nw);
    v := psiOf(zeroRow nw, Pl);
    << "M2DIRECT W1 m= " << m << " exps " << toString apply(flatten entries b2_widx, mm -> first exponents mm) << " psi " << toString flatten entries v << endl << flush;
));
<< "   time " << cpuTime()-t0 << endl << flush;
exit 0;
<< "   time after psi(Q A^2), Q in T_3: " << cpuTime()-t0 << endl << flush;
lhsUnit = piRow(hz * b3);        -- pi(Q h(z))
rhs = 3 * psiA;
nzL = #select(flatten entries lhsUnit, e -> e != 0);
<< "T7: #Q (of 165, w-degree 0) with pi(Q h_lam(z)) != 0: " << nzL << "; #Q with psi(Q A^2) != 0: " << #select(flatten entries psiA, e -> e != 0) << endl;
ok1 = (a2 * lhsUnit == rhs);
<< "T7 E2 (w-degree 0): pi(Q*a2*h(z)) == 3 psi(Q A^2) for all 165 Q ? " << ok1 << ";  #agree = " << #select(165, i -> a2*lhsUnit_(0,i) == rhs_(0,i)) << endl;
<< "T7 E2 with 2*a2: #agree = " << #select(165, i -> 2*a2*lhsUnit_(0,i) == rhs_(0,i)) << " of 165; with 0: #agree = " << #select(165, i -> 0 == rhs_(0,i)) << " of 165" << endl;
ratios = unique apply(select(165, i -> lhsUnit_(0,i) != 0), i -> rhs_(0,i)/lhsUnit_(0,i));
<< "T7: distinct values of 3 psi(Q A^2)/pi(Q h(z)) over Q with nonzero denominator: " << ratios << "   (a2 = " << a2 << ")" << endl << flush;
-- (B) Q = w_m Q', Q' in T_2 : P = w_m Q' A^2
okB = true; cntB = 0;
P1 = A2 * b2;
scan(3, m -> (
    Pl := apply(3, l -> if l == m then P1 else zeroRow 45);
    v := psiOf(zeroRow 45, Pl);
    cntB = cntB + #select(flatten entries v, e -> e == 0);
    if v != 0 then okB = false;
));
<< "T7 E2 (w-degree 1): psi(w_m Q' A^2) == 0 (= pi(w_m Q' g2)/3) for all 135 Q = w_m Q' ? " << okB << ";  #agree = " << cntB << " of 135" << endl;
<< "T7 E2 (w-degree >= 2): 64 monomials Q; Q A^2 in (w)^2 inside I^2 and Q g2 in (w): both sides 0 by construction" << endl;
<< "   time " << cpuTime()-t0 << endl << flush;
-- (C) consistency tests of the psi framework
-- (C1) psi vanishes on I^2 beyond (w)^2 : random elements of (I0^2)_9 and of w_l (I0)_8
I0sq = I0^2;
r9 = matrix{apply(6, i -> (gens I0sq * random(source gens I0sq, T^{-9}))_(0,0))};
v1 = psiOf(r9, {zeroRow 6, zeroRow 6, zeroRow 6});
<< "T7 check C1a: psi on 6 random elements of (I0^2)_9: " << flatten entries v1 << endl;
r8 = matrix{apply(6, i -> (gens I0 * random(source gens I0, T^{-8}))_(0,0))};
v2 = apply(3, m -> flatten entries psiOf(zeroRow 6, apply(3, l -> if l == m then r8 else zeroRow 6)));
<< "T7 check C1b: psi on w_m * (6 random elements of (I0)_8), m = 0,1,2: " << v2 << endl;
-- control: psi on random degree-9 forms / on w_m * random degree-8 forms is NOT identically zero
rr9 = random(T^1, T^{6:-9});
<< "T7 control: psi on 6 random forms of degree 9 in z,p,q: " << flatten entries psiOf(rr9, {zeroRow 6, zeroRow 6, zeroRow 6}) << endl;
rr8 = random(T^1, T^{6:-8});
<< "T7 control: psi on w_0 * (6 random forms of degree 8): " << flatten entries psiOf(zeroRow 6, {rr8, zeroRow 6, zeroRow 6}) << endl;
-- control: psi on random elements of (I0)_9 (in I but not I^2): expected nonzero in general
ri9 = matrix{apply(6, i -> (gens I0 * random(source gens I0, T^{-9}))_(0,0))};
<< "T7 control: psi on 6 random elements of (I0)_9: " << flatten entries psiOf(ri9, {zeroRow 6, zeroRow 6, zeroRow 6}) << endl << flush;
<< "   time " << cpuTime()-t0 << endl << flush;
-- (C2) direct verification in S of one decomposition: sum_j B_j dF/dx_j - P in (w)^2
Ptest = (Aarc^2 * b3_(0,17));
beta = matrix{{Ptest}} // D0;
Bs = apply(12, j -> toS beta_(j,0));
scan(3, l -> (
    Rl := - (D1#l) * beta;
    bl := Rl // D0;
    Bs = apply(12, j -> Bs#j + S_(9+l) * toS bl_(j,0));
));
resid = sum(12, j -> Bs#j * dF#j) - toS Ptest;
W2 = (ideal(S_9,S_10,S_11))^2;
<< "T7 check C2: for Q = " << b3_(0,17) << ": sum_j B_j dF/dx_j - Q A^2 in (w)^2 ? " << (resid % W2 == 0) << "; residual zero? " << (resid == 0) << endl;
dvS = sum(12, j -> diff(S_j, Bs#j));
<< "T7 check C2: (1/6) pi(div B) computed in S-form = " << (1/6_kk) * piT(toT dvS) << " vs psiA entry " << psiA_(0,17) << endl << flush;
<< "   total time " << cpuTime()-t0 << endl << flush;
