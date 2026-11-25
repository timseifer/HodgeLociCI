-- L1-L4: numerical inputs of the ladder argument (PREREG_step1.md, addendum).  MOD p.  usage: M2 --script h4_ladder_inputs.m2 p seed
pp = value(scriptCommandLine#1); sd = value(scriptCommandLine#2);
setRandomSeed sd; kk = ZZ/pp;
R = kk[z_0..z_2, p_0..p_2, q_0..q_2];
zz = {z_0,z_1,z_2}; ps = {p_0,p_1,p_2}; qs = {q_0,q_1,q_2};
hes = (v, l) -> v#0^3+v#1^3+v#2^3 + 3*l*v#0*v#1*v#2;
x = apply(3, i -> random kk); lam = random kk;
Mx = xx -> sum flatten flatten apply(3, i -> apply(3, j -> zz#((i+j)%3) * xx#((i-j)%3) * ps#i * qs#j));
a0 = - hes(x, lam) / (27*(1+lam^3));
F = a0 * hes(zz, lam) + hes(ps, lam) + hes(qs, lam) + Mx x;
Is = saturate ideal jacobian matrix{{F}};
<< "Sing(Y): dim " << dim Is - 1 << " degree " << degree Is << endl << flush;
-- restriction to a random linear subspace given parametrically
restr = (n) -> ( T := kk[y_0..y_n]; ph := map(T, R, apply(9, i -> random(1, T))); (T, ph));
-- L1
(T6, ph6) = restr 6; F6 = ph6 F; J6 = ideal jacobian matrix{{F6}};
<< "L1: Y ∩ P^6: Jacobian scheme dim " << dim J6 - 1 << " degree " << degree J6 << flush;
S6 = saturate J6;
<< " ; HF of the node set, d = 1..4: " << apply(toList(1..4), d -> hilbertFunction(d, S6)) << " ; defect in degree 2 = " << degree S6 - hilbertFunction(2, S6) << endl << flush;
-- L2
(T7, ph7) = restr 7; F7 = ph7 F; S7 = saturate(saturate ideal jacobian matrix{{F7}} + ideal random(2, T7));
<< "L2: Sing(Y ∩ P^7) ∩ quadric: dim " << dim S7 - 1 << " degree " << degree S7 << " ; HF d = 1..5: " << apply(toList(1..5), d -> hilbertFunction(d, S7))
   << " ; defect in degree 3 = " << degree S7 - hilbertFunction(3, S7) << endl << flush;
-- L3
(T5, ph5) = restr 5; F5 = ph5 F; J5 = ideal jacobian matrix{{F5}};
<< "L3: Y ∩ P^5 smooth: " << (dim J5 == 0) << endl << flush;
-- L4: a rational point of A, then the projection from it
found = false; cnt = 0;
while not found and cnt < 40 do ( cnt = cnt + 1;
    Ipt := Is + ideal(random(1, R), random(1, R));
    cps := decompose Ipt;
    r1 := select(cps, c -> degree c == 1);
    if #r1 > 0 then (found = true; cpt = first r1));
if not found then (<< "L4: no rational point found in " << cnt << " tries" << endl) else (
    lin := select(flatten entries gens gb cpt, f -> first degree f == 1);
    << "L4: rational point of A found after " << cnt << " linear sections; number of linear forms vanishing at it: " << #lin << endl;
    U := kk[u_0..u_7];
    pr := map(R/Is, U, apply(take(lin, 8), f -> sub(f, R/Is)));
    Kp := ker pr;
    << "    projection of A from the point: dim " << dim Kp - 1 << " degree " << degree Kp << " (17 expected; then the projection is birational)" << endl << flush;
    -- control: projection from a general point of P^8 (not on A): degree 18
    lg := apply(8, i -> random(1, R));
    Kg := ker map(R/Is, U, apply(lg, f -> sub(f, R/Is)));
    << "    control, projection from a general point: degree " << degree Kg << " (18 expected)" << endl << flush;);
