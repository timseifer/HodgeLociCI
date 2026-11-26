-- exact.m2 : EXACT (characteristic 0) checks
-- (1) identities valid for all parameters (a_coef treated as an independent variable)
B0 = QQ[la, x_0..x_2, ac];
R0 = B0[z_0..z_2,p_0..p_2,q_0..q_2];
hL = v -> v#0^3+v#1^3+v#2^3+3*la*v#0*v#1*v#2;
zz = {z_0,z_1,z_2}; pv = {p_0,p_1,p_2}; qv = {q_0,q_1,q_2}; xs = {x_0,x_1,x_2};
F0 = ac*hL(zz) + hL(pv) + hL(qv) + sum(3, i-> sum(3, j-> xs#((i-j)%3) * zz#((i+j)%3) * pv#i * qv#j));
iot = map(R0, R0, {z_0, z_2, z_1, q_0, q_2, q_1, p_0, p_2, p_1});
print("EXACT (all parameters): iota preserves F: " | toString(iot F0 == F0));
print("EXACT (all parameters): F vanishes on the (-1)-eigenspace {z_0=0, z_2=-z_1, q_0=-p_0, q_1=-p_2, q_2=-p_1}: " | toString(sub(F0, {z_0 => 0, z_2 => -z_1, q_0 => -p_0, q_1 => -p_2, q_2 => -p_1}) == 0));
-- (2) one rational instance over QQ : lam = 2, x = (1,2,3), a = -h(x)/(27(1+lam^3))
lamQ = 2; xQ = {1,2,5};
aQ = -(1 + 8 + 125 + 3*lamQ*10) / (27*(1+lamQ^3));
print("rational instance: lam=2, x=(1,2,5), a_coef = " | toString aQ);
RQ = QQ[z_0..z_2,p_0..p_2,q_0..q_2];
hQ = v -> v#0^3+v#1^3+v#2^3+3*lamQ*v#0*v#1*v#2;
zz = {z_0,z_1,z_2}; pv = {p_0,p_1,p_2}; qv = {q_0,q_1,q_2};
FQ = aQ*hQ(zz) + hQ(pv) + hQ(qv) + sum(3, i-> sum(3, j-> xQ#((i-j)%3) * zz#((i+j)%3) * pv#i * qv#j));
JQ = ideal jacobian matrix{{FQ}};
t0 = cpuTime();
print("EXACT over QQ: Sing(Y): affine dim " | toString dim JQ | ", degree " | toString degree JQ | " [" | toString(cpuTime()-t0) | " s]");
-- explicit plane over QQ
iotaQ = matrix apply(9, i -> apply(9, j -> (
   blk := j // 3; k := j % 3;
   tgt := if blk == 0 then ((-k) % 3) else if blk == 1 then (6 + ((-k)%3)) else (3 + ((-k)%3));
   if i == tgt then 1_QQ else 0_QQ)));
Em = transpose gens kernel (iotaQ + id_(QQ^9)); Ep = transpose gens kernel (iotaQ - id_(QQ^9));
RV = QQ[vv_0..vv_4, ss_0..ss_4];
Pm = sub(Em, RV) || ((matrix{{vv_0,vv_1,vv_2,vv_3,vv_4}}) * sub(Ep, RV));
cf = (coefficients(sub(FQ, (matrix{{ss_0,ss_1,ss_2,ss_3,ss_4}}) * Pm), Variables => {ss_0,ss_1,ss_2,ss_3,ss_4}))#1;
RV2 = QQ[vv_0..vv_4];
Iv = saturate(ideal sub(cf, RV2), ideal vars RV2);
print("EXACT over QQ: scheme of points v of the (+1)-eigenspace with span(P^3_-, v) in Y: (affine dim, degree) = " | toString(dim Iv, degree Iv) | "; equations: " | toString flatten entries gens gb Iv);
vsol = sub(transpose gens kernel transpose (coefficients(gens Iv, Monomials => vars RV2))#1, QQ);
P0Q = Em || (vsol * Ep);
RCQ = QQ[cc_0..cc_4];
print("EXACT over QQ: explicit 4-plane contained in Y: " | toString(sub(FQ, (vars RCQ) * sub(P0Q, RCQ)) == 0));
-- (3) an explicit smooth tenfold over QQ : pi = rows of a small integer matrix times P0Q, Phi with small integer coefficients
setRandomSeed 5;
piQ = matrix{{1,0,2,-1,3},{0,1,-1,2,1},{2,-1,0,1,1}} * P0Q;
S12 = QQ[z_0..z_2,p_0..p_2,q_0..q_2,w_0..w_2];
toS = map(S12, RQ, (vars S12)_{0..8});
Npi = transpose gens kernel piQ;
lpi = flatten entries ((vars S12)_{0..8} * transpose sub(Npi, S12));
Phi = apply(3, k -> sum(6, j -> lpi#j * sum(12, i -> random(-5,5) * S12_i)));
GQ = toS(FQ) + sum(3, k -> S12_(9+k) * Phi#k);
print("EXACT over QQ: X cap {w=0} = Y: " | toString(sub(GQ, {w_0=>0,w_1=>0,w_2=>0}) == toS FQ) | "; Lambda in X: " | toString((GQ % ideal lpi) == 0));
for pr in {32003, 30011} do (
    Sp = (ZZ/pr)[z_0..z_2,p_0..p_2,q_0..q_2,w_0..w_2];
    Gp = sub(GQ, Sp);
    gbx = groebnerBasis(ideal jacobian matrix{{Gp}}, Strategy => "F4");
    lts = flatten entries leadTerm gbx;
    print("  reduction of this X mod " | toString pr | ": singular locus affine dim " | toString dim ideal lts | ", degree " | toString degree ideal lts | "  (dim 0 mod p ==> the tenfold over QQ is smooth)");
    );
print("== exact done");
