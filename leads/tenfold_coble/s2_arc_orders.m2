-- Step 2: orders 2 and 3 of the Hodge condition along the explicit arc of the Coble family through a point of F_T.  MOD p.
-- Pre-registration: PREREG_step2.md.   usage: M2 --script s2_arc_orders.m2 p seed T|N [3]     (T: dx transversal, N: dx tangent)
pr = s -> (stderr << s << endl << flush);
pp = value(scriptCommandLine#1); sd = value(scriptCommandLine#2); mode = scriptCommandLine#3; do3 = (#scriptCommandLine > 4);
kk = ZZ/pp; S = kk[z_0..z_2, p_0..p_2, q_0..q_2, w_0..w_2];
setRandomSeed sd;
libdir = "../tenfold_session_scripts/";      -- run from leads/tenfold_coble/
load(libdir | "so_t6/solib.m2"); load(libdir | "so3_t6/o3lib.m2");
T0 = cpuTime(); tm = () -> toString(round(cpuTime() - T0)) | "s";
zz = {z_0,z_1,z_2}; ps = {p_0,p_1,p_2}; qs = {q_0,q_1,q_2}; ws = {w_0,w_1,w_2};
hes = (v, l) -> v#0^3+v#1^3+v#2^3 + 3*l*v#0*v#1*v#2;
x = apply(3, i -> random kk);
lam = -(x#0^3+x#1^3+x#2^3)/(3*x#0*x#1*x#2);
den = 27*(1+lam^3);
Mx = xx -> sum flatten flatten apply(3, i -> apply(3, j -> zz#((i+j)%3) * xx#((i-j)%3) * ps#i * qs#j));
F8 = hes(ps, lam) + hes(qs, lam) + Mx x;
F = F8 + sum(3, k -> ws#k * random(2, S));
I = trim ideal(ws | apply(zz, v -> diff(v, F8)) | {hes(ps, lam), hes(qs, lam)});
pr("h_lam(x) = " | toString hes(x, lam) | " ; F in I_V: " | toString(F % I == 0) | " ; dim V = " | toString(dim I - 1) | " degree " | toString degree I);
(piRow, IJ, m0) = soNF(F, I);
m3 = basis(3, S); L3 = flatten entries m3; cf = M -> lift(last coefficients(M, Monomials => m3), kk);
B6 = basis(6, S);
Pi6 = (B6 * transpose matrix{piRow B6})_(0,0);
idx = new MutableHashTable; mons = flatten entries B6; scan(#mons, i -> idx#(mons#i) = i);
pv = flatten entries lift(last coefficients(Pi6, Monomials => B6), kk);
Pm = matrix table(#L3, #L3, (i,j) -> pv#(idx#(L3#i * L3#j)));
pr("m0 = " | toString m0 | " ; rank of the first-order pairing = " | toString rank Pm | " (codim of T NL; 54 expected) " | tm());
-- the arc
gr = apply(3, k -> 3*x#k^2 + 3*lam*x#((k+1)%3)*x#((k+2)%3));
dx = if mode == "T" then apply(3, i -> random kk) else {gr#1, -gr#0, 0_kk};
a1 = - sum(3, k -> gr#k * dx#k) / den;
a2 = - (sum(3, k -> 3 * x#k * (dx#k)^2) + 3*lam*(x#0*dx#1*dx#2 + x#1*dx#0*dx#2 + x#2*dx#0*dx#1)) / den;
a3 = - hes(dx, lam) / den;
-- check: a(t) = -h_lam(x + t dx)/den at t = 1 and t = 2
chk = tv -> (- hes(apply(3, i -> x#i + tv * dx#i), lam) / den == tv * a1 + tv^2 * a2 + tv^3 * a3);
pr("mode " | mode | " : (a1, a2, a3) = " | toString(a1, a2, a3) | " ; expansion check at t = 1, 2, 5: " | toString(chk(1_kk), chk(2_kk), chk(5_kk)));
hz = hes(zz, lam);
A = Mx dx + a1 * hz; g2 = a2 * hz; g3 = a3 * hz;
E1 = Pm * cf(matrix{{A}});
pr("E1: pi(Q A) = 0 for all Q: " | toString(E1 == 0) | " ; pi(Q h_lam(z)) = 0 for all Q (must be false for the controls to have power): " | toString(Pm * cf(matrix{{hz}}) == 0));
-- engine
g = flatten entries mingens I; cs = select(g, u -> first degree u == 3);
H = o3Setup(F, g, 5, 1_kk);
pr("engine setup: m0 " | toString(H#"m0" == m0) | ", PiT == Pi6: " | toString(H#"PiT" == Pi6) | " " | tm());
lin = soPsiBlin(F, I, piRow, IJ, m0);
lcm0 = lin matrix{apply(cs, c -> c * m0)};
if any(lcm0, vc -> any(vc#1, t -> t != 0)) then error "SO-T6 route: cubic unknowns enter";
xs = apply(lcm0, vc -> vc#0);
ci = apply(cs, c -> position(g, u -> u == c));
Kv = new MutableHashTable;
scan(#cs, a -> Kv#("K", 2, {ci#a}) = xs#a);
pr("psi(c m0) for the cubic generators: " | toString xs | " " | tm());
(v2, st) = o3Eval(H, 2, m3, A^2, null);
(row2, unr) = o3Subst(v2, new HashTable from Kv);
if #unr > 0 then error("unresolved level-2 keys " | toString unr);
rhs = 3 * transpose row2;
lhs = Pm * cf(matrix{{g2}});
nz = v -> #select(flatten entries v, e -> e != 0);
pr("E2: 3 psi(Q A^2): nonzero entries " | toString nz rhs | " of 364 ; pi(Q g2): nonzero entries " | toString nz lhs);
pr("RESULT E2 (pi(Q g2) = 3 psi(Q A^2) for all 364 Q): " | toString(lhs == rhs) | "   " | tm());
pr("   controls: a2 -> 2 a2: " | toString(2*lhs == rhs) | " ; a2 -> 0: " | toString(0*lhs == rhs) | " ; solvable for some g2 at all: " | toString(rank(Pm | rhs) == rank Pm));
<< "E2 " << mode << " p " << pp << " seed " << sd << " : " << (lhs == rhs) << " ; controls " << (2*lhs == rhs) << " " << (0*lhs == rhs) << endl << flush;
if do3 then (
    (a2v, st2) = o3Eval(H, 2, m3, A * g2, null);
    a2x = o3Subst(a2v, new HashTable from Kv);
    pr("psi(Q A g2) done " | tm());
    (a3v, st3) = o3Eval(H, 3, m3, A^3, null);
    pr("psi3(Q A^3) done; keys " | toString keys a3v | " " | tm());
    K3keys = select(keys a3v, kx -> kx =!= "1" and kx#1 == 3);
    Jr = flatten entries jacobian matrix{{F}};
    if #K3keys > 0 then (
        sup = select(12, i -> degree(S_i, m0) > 0);
        I3J = matrix{flatten entries gens trim(I^3) | Jr}; n3 = numColumns I3J - 12;
        done = false;
        for j from 1 to first degree m0 do if not done then (
            m1 = S_(first sup)^j; if m0 % m1 != 0 then continue; m2 = m0 // m1;
            pr("  K3: trying j = " | toString j | " (degree " | toString(6 + j) | ") " | tm());
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
    (row3, unr3) = o3Subst(a3v, new HashTable from Kv);
    if #unr3 > 0 then pr("WARNING unresolved level-3 keys " | toString unr3);
    c3 = 6 * a2x#0 - 7 * row3;
    lhs3 = Pm * cf(matrix{{g3}});
    pr("E3: 6 psi(Q A g2) - 7 psi3(Q A^3): nonzero " | toString nz c3 | " of 364 ; pi(Q g3): nonzero " | toString nz lhs3);
    pr("RESULT E3 (pi(Q g3) = 6 psi(Q A g2) - 7 psi3(Q A^3) for all 364 Q): " | toString(lhs3 == transpose c3) | "   " | tm());
    pr("   controls: a3 -> 2 a3: " | toString(2*lhs3 == transpose c3) | " ; a3 -> 0: " | toString(0*lhs3 == transpose c3) | " ; solvable for some g3: " | toString(rank(Pm | transpose c3) == rank Pm));
    << "E3 " << mode << " p " << pp << " seed " << sd << " : " << (lhs3 == transpose c3) << " ; controls " << (2*lhs3 == transpose c3) << " " << (0*lhs3 == transpose c3) << endl << flush;
    );
