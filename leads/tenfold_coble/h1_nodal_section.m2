-- H1/H2: singular points of a hyperplane section X ∩ H (H containing the P^8) and its defect.  MOD p.
-- Pre-registration: see PREREG_step1.md (H1, H2).  usage: M2 --script h1_nodal_section.m2 p seed coble|ft [full]
pp = value(scriptCommandLine#1); sd = value(scriptCommandLine#2); mode = scriptCommandLine#3;
full = (#scriptCommandLine > 4);
setRandomSeed sd; kk = ZZ/pp;
R = kk[z_0..z_2, p_0..p_2, q_0..q_2];
zz = {z_0,z_1,z_2}; ps = {p_0,p_1,p_2}; qs = {q_0,q_1,q_2};
hes = (v, l) -> v#0^3+v#1^3+v#2^3 + 3*l*v#0*v#1*v#2;
x = apply(3, i -> random kk);
lam = if mode == "ft" then -(x#0^3+x#1^3+x#2^3)/(3*x#0*x#1*x#2) else random kk;
Mx = xx -> sum flatten flatten apply(3, i -> apply(3, j -> zz#((i+j)%3) * xx#((i-j)%3) * ps#i * qs#j));
a0 = - hes(x, lam) / (27*(1+lam^3));
F = a0 * hes(zz, lam) + hes(ps, lam) + hes(qs, lam) + Mx x;
<< "mode " << mode << " ; a = " << a0 << endl;
Is = saturate ideal jacobian matrix{{F}};
<< "Sing(Y): dim " << dim Is - 1 << " degree " << degree Is << endl << flush;
-- reducedness of a finite scheme: project to a line by two random linear forms; the image is a binary form of degree = length,
-- and the scheme is reduced with that many distinct points iff the form has that degree and is squarefree
redpts = Iz -> ( T := kk[u, v]; ph := map(R/Iz, T, {sub(random(1, R), R/Iz), sub(random(1, R), R/Iz)});
    g := (ker ph)_0; d := first degree g; gu := diff(T_0, g); gv := diff(T_1, g);
    (d, gcd(g, gu) == 1 or first degree gcd(g, gu) == 0) );
Psi = apply(2, k -> random(2, R));
Sg = saturate(Is + ideal Psi);
<< "H1: Sigma = Sing(Y) ∩ {Psi1=Psi2=0}: dim " << dim Sg - 1 << " degree " << degree Sg << flush;
<< " ; (degree of projection to a line, squarefree) = " << redpts Sg << endl << flush;
<< "H2: Hilbert function of Sigma, d = 1..6: " << apply(toList(1..6), d -> hilbertFunction(d, Sg)) << endl;
<< "    defect = degree - HF(4) = " << degree Sg - hilbertFunction(4, Sg) << endl << flush;
-- control: the same count for Sigma' = Sing ∩ {cubic = quadric = 0} (5H != K + 2H + 3H - no Cayley-Bacharach relation in degree 4)
Sc = saturate(Is + ideal(random(1, R), random(2, R)));
<< "    control (linear ∩ quadric section, " << degree Sc << " points): degree - HF(4) = " << degree Sc - hilbertFunction(4, Sc) << endl << flush;
if mode == "ft" then (
    cps := decompose Is;
    << "    (ft) components of Sing(Y): " << apply(cps, c -> (dim c - 1, degree c)) << endl;
    scan(cps, c -> ( s := saturate(c + ideal Psi); << "    (ft) nodes on the component of degree " << degree c << ": " << degree s << " ; HF(4) = " << hilbertFunction(4, s) << endl)));
if full then (
    -- random completion on P^10 = P^8 + two more coordinates t_1, t_2
    S = kk[z_0..z_2, p_0..p_2, q_0..q_2, t_1, t_2];
    inc = map(S, R, {z_0,z_1,z_2,p_0,p_1,p_2,q_0,q_1,q_2});
    yv = {z_0,z_1,z_2,p_0,p_1,p_2,q_0,q_1,q_2};
    lin = () -> sum(yv, v -> random(kk) * v);
    f = inc F + t_1 * inc(Psi#0) + t_2 * inc(Psi#1) + t_1^2 * lin() + t_1*t_2 * lin() + t_2^2 * lin()
        + random(kk)*t_1^3 + random(kk)*t_1^2*t_2 + random(kk)*t_1*t_2^2 + random(kk)*t_2^3;
    J = ideal jacobian matrix{{f}};
    tm = cpuTime();
    << "H1 (full): Jacobian ideal of f on P^10: dim " << dim J - 1 << flush;
    << " degree " << degree J << " ; cpu " << cpuTime() - tm << endl << flush;
    << "    singular points off the P^8: " << (saturate(J, ideal(t_1, t_2)) != ideal(1_S)) << endl;);
