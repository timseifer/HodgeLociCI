-- Q1-Q3: the Pfaffian cubic sevenfold Y = {Pf(M) = 0} in P^8 and its singular K3 surface.  MOD p.
-- Pre-registration: PREREG_k3.md.   usage: M2 --script pf1_section.m2 p seed [full]
pp = value(scriptCommandLine#1); sd = value(scriptCommandLine#2); full = (#scriptCommandLine > 3);
setRandomSeed sd; kk = ZZ/pp;
R = kk[y_0..y_8];
L = new MutableHashTable; scan(6, i -> scan(6, j -> if i < j then L#(i,j) = random(1, R)));
M = matrix table(6, 6, (i,j) -> if i < j then L#(i,j) else if i > j then -L#(j,i) else 0_R);
F = (gens pfaffians(6, M))_(0,0);
IS = pfaffians(4, M);
<< "deg F = " << first degree F << " ; I_S: " << numgens trim IS << " quadrics ; dim " << dim IS - 1 << " degree " << degree IS
   << " ; Hilbert polynomial " << toString hilbertPolynomial(IS, Projective => false) << endl << flush;
J = ideal jacobian matrix{{F}};
Jsat = saturate J;
<< "Q1: Jacobian ideal: dim " << dim J - 1 << " degree " << degree J << " ; sat(J) == I_S: " << (Jsat == IS) << " ; J == I_S: " << (J == IS)
   << " ; HF of R/J and R/I_S, d = 2..5: " << apply(toList(2..5), d -> (hilbertFunction(d, R/J), hilbertFunction(d, R/IS))) << endl << flush;
Hs = jacobian transpose jacobian matrix{{F}};
cm = k -> det((transpose random(R^9, R^{k:0})) * Hs * random(R^9, R^{k:0}));       -- a random compressed k x k minor of the Hessian
I6 = IS + ideal apply(4, i -> cm 6);
<< "    Hessian rank >= 6 on S (S + four compressed 6x6 minors has no point): " << (dim I6 == 0) << " ; a compressed 7x7 minor vanishes on S: " << ((cm 7) % IS == 0) << endl << flush;
redpts = Iz -> ( T := kk[u, v]; ph := map(R/Iz, T, {sub(random(1, R), R/Iz), sub(random(1, R), R/Iz)});
    g := (ker ph)_0; (first degree g, first degree gcd(g, diff(T_0, g)) == 0));
Psi = apply(2, k -> random(2, R));
Sg = saturate(IS + ideal Psi);
<< "Q2: S ∩ {Psi1 = Psi2 = 0}: dim " << dim Sg - 1 << " degree " << degree Sg << " ; (degree of projection, squarefree) = " << redpts Sg
   << " ; HF d = 1..6: " << apply(toList(1..6), d -> hilbertFunction(d, Sg)) << endl << flush;
S7 = saturate(IS + ideal(random(1, R), random(2, R)));
<< "    one level down (linear ∩ quadric): degree " << degree S7 << " ; HF d = 1..5: " << apply(toList(1..5), d -> hilbertFunction(d, S7)) << endl;
S6 = saturate(IS + ideal(random(1, R), random(1, R)));
<< "    two levels down (S ∩ P^6): degree " << degree S6 << " ; HF d = 1..4: " << apply(toList(1..4), d -> hilbertFunction(d, S6)) << endl << flush;
restr = n -> ( T := kk[t_0..t_n]; map(T, R, apply(9, i -> random(1, T))));
ph6 = restr 6; J6 = ideal jacobian matrix{{ph6 F}};
<< "    Y ∩ P^6: Jacobian scheme dim " << dim J6 - 1 << " degree " << degree J6 << endl;
ph5 = restr 5; << "    Y ∩ P^5 smooth: " << (dim ideal jacobian matrix{{ph5 F}} == 0) << endl << flush;
-- Q3
Phi = apply(3, k -> random(2, R));
A = R/(J + ideal Phi); B = R/(IS + ideal Phi);
<< "Q3: HF of A = R/(J, Phi), d = 0..8: " << apply(toList(0..8), d -> hilbertFunction(d, A)) << endl;
<< "    HF of B = R/(I_S, Phi), d = 0..8: " << apply(toList(0..8), d -> hilbertFunction(d, B)) << endl << flush;
use R;
G = gb(IS + ideal Phi); b6 = basis(6, B);
B6 = basis(6, R); NF = B6 % G; mons6 = flatten entries B6; s6 = lift(b6_(0,0), R);
dl = flatten entries lift(last coefficients(NF, Monomials => matrix{{s6}}), kk);
idx = new MutableHashTable; scan(#mons6, i -> idx#(mons6#i) = i);
m3 = flatten entries basis(3, R);
PM = matrix(kk, apply(m3, a -> apply(m3, b -> dl#(idx#(a*b)))));
K3 = gens ker PM;
I3 = super basis(3, IS + ideal Phi);
cf = Mx -> lift(last coefficients(Mx, Monomials => matrix{m3}), kk);
<< "    pairing on cubics through the socle of B: rank " << rank PM << " ; kernel dimension " << numColumns K3 << " ; dim (I_S + Phi)_3 = " << rank cf I3
   << " ; kernel == (I_S + Phi)_3: " << (rank(K3 | cf I3) == numColumns K3 and rank cf I3 == numColumns K3) << endl;
<< "    dim (I_S)_3 = " << numColumns super basis(3, IS) << " (= 1 + dimension of the family of Pfaffian cubics in P^8 if 100)" << endl << flush;
if full then (
    S11 = kk[y_0..y_8, t_1, t_2]; inc = map(S11, R, {y_0,y_1,y_2,y_3,y_4,y_5,y_6,y_7,y_8});
    lin = () -> sum(9, i -> random(kk) * S11_i);
    f = inc F + t_1 * inc(Psi#0) + t_2 * inc(Psi#1) + t_1^2 * lin() + t_1*t_2 * lin() + t_2^2 * lin()
        + random(kk)*t_1^3 + random(kk)*t_1^2*t_2 + random(kk)*t_1*t_2^2 + random(kk)*t_2^3;
    Jf = ideal jacobian matrix{{f}}; tm = cpuTime();
    << "Q2 (full): Jacobian ideal on P^10: dim " << dim Jf - 1 << flush;
    << " degree " << degree Jf << " ; with t = 0: degree " << degree(Jf + ideal(t_1, t_2)) << " ; cpu " << cpuTime() - tm << endl << flush;);
