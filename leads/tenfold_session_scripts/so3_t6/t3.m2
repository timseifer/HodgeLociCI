-- SO3-T6 order-3 test of the extra direction at a point X of F_T (tenfold, V = J(P^2, T), class [V]).
-- usage: M2 --script t3.m2 seed prime mode      mode "G": A = G_e (the test);  mode "h": A = random h in T F_T (control c1')
-- Arc F + tA + t^2 g2 + t^3 g3; Q in S_3, K in T NL (= left kernel of the symmetric first-order matrix Pm).
--   order 2: pi(Q g2) = 3 psi(Q A^2)  (all Q in S_3; solvable iff psi(K A^2) = 0 on T NL)
--   order 3: pi(Q g3) = (1/5) c3(Q),  c3(Q) = 6 psi(Q A g2) - 7 psi3(Q A^3);  solvable iff c3(K) = 0 on T NL after
--            g2 -> g2_0 + w (w in T NL), which adds 6 psi(K A w)  (freedom matrix, spot-checked here on random w).
-- psi_m by o3lib.m2 (characterisation: psi_m = 0 on I^m, Griffiths-Dwork); unknown constants psi(c m0) (level 2) from
-- SO-T6's lift (soPsiBlin) AND from this engine; psi3(c c' m0) (level 3) by the degree-(6+j) lift along gens(I^3) | J.
pr = s -> (stderr << s << endl << flush);
sd = value scriptCommandLine#1;
p = value scriptCommandLine#2;
mode = scriptCommandLine#3;
kk = ZZ/p; S = kk[x_0..x_11];
setRandomSeed(sd);
load "/home/claude/hodge/discovery/checks/so_t6/w1lib.m2";
load "/home/claude/hodge/discovery/checks/so_t6/solib.m2";
load "/home/claude/hodge/discovery/checks/so3_t6/o3lib.m2";
T0 = cpuTime(); tm = () -> toString(round(cpuTime() - T0)) | "s";
-- ---------------- setup: identical to SO-T6 t10f.m2 (same seeds give the same X, T NL, G_e)
I = trim w1cycle("J2T");
B3 = super basis(3, I); F = (B3 * random(kk^(numColumns B3), kk^1))_(0,0);
w1codimP8(F, I);
(piRow, IJ, m0) = soNF(F, I);
m3 = basis(3, S); L3 = flatten entries m3; cf = M -> lift(last coefficients(M, Monomials => m3), kk);
B6 = basis(6, S);
Pi6 = (B6 * transpose matrix{piRow B6})_(0,0);
idx = new MutableHashTable; mons = flatten entries B6; scan(#mons, i -> idx#(mons#i) = i);
pv = flatten entries lift(last coefficients(Pi6, Monomials => B6), kk);
Pm = matrix table(#L3, #L3, (i,j) -> pv#(idx#(L3#i * L3#j)));
TNL = matrix nullSpace mutableMatrix Pm; pr("m0 = " | toString m0 | "; dim T NL = " | toString numColumns TNL | " " | tm());
Jr = flatten entries jacobian matrix{{F}};
g = flatten entries mingens I; r = #g; dg = apply(g, u -> first degree u); GIJ = matrix{g | Jr};
uu = {x_9, x_10, x_11}; qs = select(g, u -> first degree u == 2); cs = select(g, u -> first degree u == 3);
mu2 = flatten entries basis(2, S);
Yi = flatten apply(uu, a -> apply(mu2, m -> a * m)) | flatten apply(qs, q -> apply(12, l -> q * x_l)) | cs;
nI3 = numColumns super basis(3, I);
Yj = flatten table(12, 12, (l, j) -> x_l * diff(x_j, F));
nh = #w1TFpolys - nI3 - 27 - 144; Yh = take(drop(w1TFpolys, nI3), nh);
Ysp = {}; cur = cf(matrix{Yi | Yj});
for h in Yh do (if rank(cur | cf(matrix{{h}})) > rank cur then (Ysp = append(Ysp, h); cur = cur | cf(matrix{{h}})));
rTF = rank cur;
pr("generators " | toString tally dg | "; rank T F_T = " | toString rTF | " (309); T F_T in T NL: " | toString(rank(TNL | cur) == numColumns TNL));
Ge = null; for j from 0 to numColumns TNL - 1 do if rank(cur | TNL_{j}) > rTF then (Ge = (m3 * sub(TNL_{j}, S))_(0,0); break);
stripU = f -> sum(select(terms f, t -> degree(x_9, t) + degree(x_10, t) + degree(x_11, t) == 0));
Ge = stripU Ge; Ysp = apply(Ysp, stripU);
pr("Ge in T NL, outside T F_T: " | toString(rank(TNL | cf(matrix{{Ge}})) == numColumns TNL, rank(cur | cf(matrix{{Ge}})) > rTF));
-- control direction: random element of T F_T, stripped of u-monomials (u-monomials lie in I_3 c T F_T, so still in T F_T)
hc = stripU (matrix{Yi | Yj | Ysp} * random(kk^(#Yi + #Yj + #Ysp), kk^1))_(0,0);
pr("h in T F_T: " | toString(rank(cur | cf(matrix{{hc}})) == rTF) | ", h != 0: " | toString(hc != 0));
A = if mode == "G" then Ge else hc;
-- ---------------- engine
H = o3Setup(F, g, 5, 1_kk);
pr("engine setup: m0 " | toString(H#"m0" == m0) | ", PiT == SO-T6 Pi6: " | toString(H#"PiT" == Pi6) | " " | tm());
-- level-2 constants psi(c m0): SO-T6 route (soPsiBlin) and this engine (explicit job on c m0)
lin = soPsiBlin(F, I, piRow, IJ, m0);
lcm0 = lin matrix{apply(cs, c -> c * m0)};
if any(lcm0, vc -> any(vc#1, t -> t != 0)) then error "SO-T6 route: cubic unknowns enter";
xs = apply(lcm0, vc -> vc#0);
ci = apply(cs, c -> position(g, u -> u == c));
Kv = new MutableHashTable;
scan(#cs, a -> Kv#("K", 2, {ci#a}) = xs#a);
pr("psi(c m0) (SO-T6 route): " | toString xs | " " | tm());
(vE, stE) = o3Eval(H, 2, matrix{{1_S}}, null, matrix{apply(cs, c -> c * m0)});
pr("  engine explicit c m0: known " | toString entries vE#"1" | ", symbol coefficients " | toString apply(select(keys vE, kx -> kx =!= "1"), kx -> (kx, entries vE#kx)));
(row, unr) = o3Subst(vE, new HashTable from Kv);
pr("  c3' level-2 constants: engine (after substituting) == SO-T6 route: " | toString(flatten entries row == xs) | " (identity psi(c m0) = psi(c m0) if the only symbol is K_c itself)");
-- level-2 cross-check on a nonzero value (SO-T6 nt.m2 type): psi(Ge w g), w random cubic, g = cubic generators
wr = random(3, S);
(v2c, st2c) = o3Eval(H, 2, matrix{cs}, Ge * wr, null);
(row2c, unr2c) = o3Subst(v2c, new HashTable from Kv);
psiB = soPsiBx(lin, xs);
ref2c = psiB matrix{apply(cs, c -> Ge * wr * c)};
pr("  c3' level 2, nonzero values: engine " | toString flatten entries row2c | " SO-T6 soPsiB " | toString ref2c | " AGREE " | toString(flatten entries row2c == ref2c) | " unresolved " | toString unr2c | " " | tm());
-- ---------------- order 2: g2_0
(v2, st) = o3Eval(H, 2, m3, A^2, null);
(row2, unr) = o3Subst(v2, new HashTable from Kv);
if #unr > 0 then error("unresolved level-2 keys " | toString unr);
pr("psi(Q A^2), Q in S_3: nonzero " | toString(#select(flatten entries row2, v -> v != 0)) | "; on T NL (order 2, 0 expected): nonzero " | toString(#select(flatten entries (row2 * TNL), v -> v != 0)) | " " | tm());
rhs = 3 * transpose row2;
y = rhs // Pm;
if Pm * y != rhs then error "order 2 not solvable";
g2 = (m3 * sub(y, S))_(0,0);
pr("g2_0 found (Pm y = 3 psi(. A^2)); g2_0 == 0: " | toString(g2 == 0));
-- ---------------- order 3
(a2, st) = o3Eval(H, 2, m3, A * g2, null);
a2x = o3Subst(a2, new HashTable from Kv);
pr("psi(Q A g2_0) done " | toString pairs st | " " | tm());
(a3, st3) = o3Eval(H, 3, m3, A^3, null);
pr("psi3(Q A^3) done " | toString pairs st3 | " keys " | toString keys a3 | " " | tm());
"/home/claude/hodge/discovery/checks/so3_t6/t3_" | mode | "_" | toString sd | "_" | toString p | ".txt" << toString {F, Ge, A, g2, entries row2, apply(pairs a3, kv -> (kv#0, entries kv#1)), apply(pairs a2, kv -> (kv#0, entries kv#1))} << close;
-- level-3 constants psi3(c c' m0)
K3keys = select(keys a3, kx -> kx =!= "1" and kx#1 == 3);
K3used = select(K3keys, kx -> a3#kx * TNL != 0);
pr("level-3 symbols present " | toString K3keys | "; with nonzero coefficient on T NL: " | toString K3used);
-- determination: c c' m1 = A' + sum B_i dF_i, A' in I^3 (degree 6 + j), m0 = m1 m2  =>  psi3(c c' m0) = (1/7) psi(div(m2 B))
if #K3keys > 0 then (
    sup = select(12, i -> degree(S_i, m0) > 0);
    I3J = matrix{flatten entries gens trim(I^3) | Jr}; n3 = numColumns I3J - 12;
    done = false;
    for j from 1 to first degree m0 do if not done then (
        m1 = S_(first sup)^j; if m0 % m1 != 0 then continue; m2 = m0 // m1;
        pr("  trying j = " | toString j | " (degree " | toString(6 + j) | ") " | tm());
        P3 = matrix{apply(K3keys, kx -> g#(kx#2#0) * g#(kx#2#1) * m1)};
        Gb = gb(I3J, ChangeMatrix => true, DegreeLimit => 6 + j);
        rem3 = P3 % Gb;
        pr("    remainders zero: " | toString(rem3 == 0) | " " | tm());
        if rem3 == 0 then (
            Cq = P3 // Gb;
            divs = matrix{apply(#K3keys, a -> sum(12, i -> diff(S_i, m2 * Cq_(n3 + i, a))))};
            (vd, std) = o3Eval(H, 2, matrix{{1_S}}, null, divs);
            (rowd, unrd) = o3Subst(vd, new HashTable from Kv);
            if #unrd > 0 then error "unresolved in K3 determination";
            scan(#K3keys, a -> Kv#(K3keys#a) = (1_kk / 7) * rowd_(0, a));
            pr("    psi3(c c' m0) = " | toString apply(K3keys, kx -> (kx, Kv#kx)) | " " | tm());
            done = true));
    if not done then pr("K3 UNDETERMINED up to degree 12"));
(row3, unr3) = o3Subst(a3, new HashTable from Kv);
if #unr3 > 0 then pr("WARNING unresolved level-3 keys " | toString unr3);
c3 = 6 * a2x#0 - 7 * row3;
c3T = c3 * TNL;
pr("c3 on S_3: nonzero " | toString(#select(flatten entries c3, v -> v != 0)) | " of 364; psi3(Q A^3) nonzero " | toString(#select(flatten entries row3, v -> v != 0)) | "; psi(Q A g2_0) nonzero " | toString(#select(flatten entries (a2x#0), v -> v != 0)));
pr("c3 on T NL: nonzero " | toString(#select(flatten entries c3T, v -> v != 0)) | " of " | toString numColumns TNL | "; psi3 part on T NL nonzero " | toString(#select(flatten entries (row3 * TNL), v -> v != 0)) | "; psi part on T NL nonzero " | toString(#select(flatten entries (a2x#0 * TNL), v -> v != 0)));
-- freedom spot-check: psi(K A w), w random in T NL (2 samples)
frk = {};
for s from 1 to 2 do (
    w = (m3 * sub(TNL * random(kk^(numColumns TNL), kk^1), S))_(0,0);
    (vf, stf) = o3Eval(H, 2, m3, A * w, null);
    (rowf, unrf) = o3Subst(vf, new HashTable from Kv);
    frk = append(frk, rowf * TNL);
    pr("  freedom sample " | toString s | ": psi(K A w) on T NL nonzero " | toString(#select(flatten entries (rowf * TNL), v -> v != 0)) | "; off T NL nonzero " | toString(#select(flatten entries rowf, v -> v != 0)) | " " | tm()));
Fr = fold((a, b) -> a || b, frk);
solv = (rank(Fr || c3T) == rank Fr);
pr("RESULT mode " | mode | " seed " | toString sd | " p " | toString p | ": c3 on T NL " | (if c3T == 0 then "= 0" else "!= 0") | "; freedom rank (samples) " | toString rank Fr | " => order 3 " | (if solv then "SOLVABLE (unobstructed)" else "NOT solvable on the sampled freedom (obstructed unless the full freedom matrix helps)") | "  " | tm());
"/home/claude/hodge/discovery/checks/so3_t6/t3_" | mode | "_" | toString sd | "_" | toString p | "_res.txt" << toString {entries c3, entries c3T, entries row3, entries (a2x#0), apply(keys Kv, kx -> (kx, Kv#kx))} << close;
