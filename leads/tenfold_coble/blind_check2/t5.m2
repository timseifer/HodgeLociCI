-- T5: linear sections (Coble mode)
pp = value(scriptCommandLine#1); sd = value(scriptCommandLine#2); mode = "coble";
load "/home/claude/blind_check2/lib.m2";
t0 = cpuTime();
restrictF = n -> (   -- restrict F to a random P^(n-1) with n coordinates
    Rn := kk[y_0..y_(n-1)];
    A := random(kk^9, kk^n);
    assert(rank A == n);
    (Rn, (map(Rn, R, flatten entries (sub(A, Rn) * transpose vars Rn))) F, A));
-- (a) random P^6
(R7, F7, A7) = restrictF 7;
J7 = ideal jacobian matrix{{F7}};
l7 = random(1, R7);
J7s = saturate(J7, l7);
<< "T5a: Y ∩ P^6: Jacobian scheme affine dim " << dim J7 << ", degree " << degree J7 << "; HF of saturated ideal, degrees 0..5: " << apply(6, d -> hilbertFunction(d, R7/J7s)) << endl << flush;
S2 = kk[s,t];
phi = map(R7/J7s, S2, {sub(random(1,R7), R7/J7s), sub(random(1,R7), R7/J7s)});
G = (ker phi)_0; use S2;
<< "T5a: projection to a line: binary form degree " << first degree G << ", gcd(G,G') degree " << first degree gcd(G, diff(s,G)) << " (0 => 18 distinct points, each of Jacobian length 1 => nodes); factor degrees " << sort apply(toList factor G, f -> first degree f#0) << endl << flush;
-- (b) random P^7 and a quadric
(R8, F8, A8) = restrictF 8;
J8 = ideal jacobian matrix{{F8}};
<< "T5b: Sing(Y ∩ P^7): affine dim " << dim J8 << ", degree " << degree J8 << endl << flush;
Qd = random(2, R8); l8 = random(1, R8);
I36 = saturate(J8 + ideal Qd, l8);
<< "T5b: Sing(Y ∩ P^7) ∩ quadric: affine dim " << dim I36 << ", degree " << degree I36 << "; HF degrees 0..6: " << apply(7, d -> hilbertFunction(d, R8/I36)) << endl << flush;
phi = map(R8/I36, S2, {sub(random(1,R8), R8/I36), sub(random(1,R8), R8/I36)});
G = (ker phi)_0; use S2;
<< "T5b: projection to a line: binary form degree " << first degree G << ", gcd(G,G') degree " << first degree gcd(G, diff(s,G)) << endl << flush;
-- (c) random P^5
(R6, F6, A6) = restrictF 6;
J6 = ideal jacobian matrix{{F6}};
<< "T5c: Y ∩ P^5: Jacobian ideal affine dim " << dim J6 << " (0 => smooth cubic fourfold); HF of Jacobian ring: " << apply(8, d -> hilbertFunction(d, R6/J6)) << endl << flush;
<< "   time " << cpuTime()-t0 << endl << flush;
-- (d) projections of A
use R;
ell = random(1, R);
Jsat = saturate(J, ell);
QA = R/Jsat;
-- find a kk-rational point of A on a random P^6 section
found = false; tries = 0;
while not found do (
    tries = tries + 1;
    use R;
    I18 = saturate(Jsat + ideal(random(1,R), random(1,R)), ell);
    l0 = random(1,R); l1 = random(1,R);
    phi = map(R/I18, S2, {sub(l0, R/I18), sub(l1, R/I18)});
    G = (ker phi)_0; 
    lin = select(toList factor G, f -> first degree f#0 == 1);
    if #lin > 0 then (
        h = lin#0#0; use S2;
        al = sub(coefficient(s, h), kk); be = sub(coefficient(t, h), kk);
        use R;
        Ipt = saturate(I18 + ideal(al*l0 + be*l1), ell);
        if degree Ipt == 1 and dim Ipt == 1 then found = true;
    );
);
lfs = select(flatten entries mingens Ipt, f -> first degree f == 1);
Mpt = sub(last coefficients(matrix{lfs}, Monomials => vars R), kk);  -- 9 x 8
apt = gens ker transpose Mpt;  -- 9 x 1
<< "T5d: found kk-point a of A after " << tries << " random P^6 sections (18 points: degree " << degree I18 << "): a = " << flatten entries apt << endl;
<< "T5d: a in Sing(Y)? " << ((map(kk, R, flatten entries apt)) gens Jsat == 0) << endl << flush;
projHF = (pt, dmax) -> (
    -- 8 independent linear forms vanishing at pt
    Lf := flatten entries (vars R * sub(gens ker transpose pt, R));   -- 8 linear forms
    T8 := kk[w_1..w_8];
    ph := map(QA, T8, apply(Lf, f -> sub(f, QA)));
    apply(toList(1..dmax), d -> (
        Bd := basis(d, QA);
        im := ph basis(d, T8);
        cf := last coefficients(im, Monomials => Bd);
        rank sub(cf, kk))));
hfA = projHF(apt, 6);
<< "T5d: HF (degrees 1..6) of the image of A projected from a in A: " << hfA << "; second differences " << apply(4, i -> hfA#(i+2) - 2*hfA#(i+1) + hfA#i) << endl << flush;
<< "   time " << cpuTime()-t0 << endl << flush;
gpt = random(kk^9, kk^1);
hfG = projHF(gpt, 6);
<< "T5d: HF (degrees 1..6) of the image of A projected from a random point of P^8: " << hfG << "; second differences " << apply(4, i -> hfG#(i+2) - 2*hfG#(i+1) + hfG#i) << endl << flush;
<< "   time " << cpuTime()-t0 << endl << flush;
