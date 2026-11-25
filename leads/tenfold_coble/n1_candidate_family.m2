-- N1-N4: tests of the explicit candidate family
--     F#(z,p,q) = a h_lam(z) + h_lam(p) + h_lam(q) + M_x(z,p,q),   a = - h_lam(x) / (27 (1 + lam^3)),
--     M_x = sum_{i,j} z_{i+j} x_{i-j} p_i q_j,   h_lam(v) = v0^3+v1^3+v2^3 + 3 lam v0 v1 v2.     MOD p.
-- Pre-registration (written before running):
--   N1: Sing(F# = 0) in P^8 is a surface of degree 18 with Hilbert polynomial 9 n^2 (an abelian surface: F# is a Coble cubic),
--       while for the controls a -> 2a and a -> 0 (x generic) the singular locus has dimension < 2.
--       FAIL (dim Sing < 2 on the relation) kills the candidate as a P^8-section family with a cycle.
--   N2: with three random quadrics Phi (the w-derivatives of a random tenfold through the section), A = k[z,p,q]/(dF#, Phi) has
--       dim A_6 = 1 and the pairing A_3 x A_3 -> A_6 has rank 54.  (rank != 54: the family is not a codim-54 first-order Hodge locus.)
--   N3: the 4 derivatives of F# along the family (d/dx_k, d/dlam, with a moving accordingly) lie in the kernel of that pairing, and
--       kernel = (J-part) + these.  (FAIL: the family is not tangent to the first-order locus of its own class.)
--   N4: at a point of F_T (x on the curve, a = 0), the same derivatives lie in the kernel of the pairing of the class [V], and they
--       are NOT all in T F_T: the candidate family leaves F_T in the direction G_e.  (FAIL: the candidate is not the lead's W.)
pp = value(scriptCommandLine#1); sd = value(scriptCommandLine#2); mode = scriptCommandLine#3;   -- mode: "coble" or "ft"
setRandomSeed sd; kk = ZZ/pp;
R = kk[z_0..z_2, p_0..p_2, q_0..q_2];
zz = {z_0,z_1,z_2}; ps = {p_0,p_1,p_2}; qs = {q_0,q_1,q_2};
hes = (v, l) -> v#0^3+v#1^3+v#2^3 + 3*l*v#0*v#1*v#2;
PP = v -> v#0*v#1*v#2;
x = apply(3, i -> random kk);
lam = if mode == "ft" then -(x#0^3+x#1^3+x#2^3)/(3*x#0*x#1*x#2) else random kk;
hx = hes(x, lam);
<< "mode " << mode << " ; h_lam(x) = " << hx << " ; 1+lam^3 = " << 1+lam^3 << endl;
Mx = xx -> sum flatten flatten apply(3, i -> apply(3, j -> zz#((i+j)%3) * xx#((i-j)%3) * ps#i * qs#j));
den = 27*(1+lam^3);
aOf = (xx, l) -> - hes(xx, l) / (27*(1+l^3));
Fs = aa -> aa * hes(zz, lam) + hes(ps, lam) + hes(qs, lam) + Mx x;
a0 = aOf(x, lam);
F = Fs a0;
sing = G -> (I := ideal jacobian matrix{{G}}; Is := saturate I; (dim Is - 1, if dim Is > 0 then degree Is else 0, Is));
(d1, g1, Is) = sing F;
<< "N1: Sing(F#): dim " << d1 << " degree " << g1 << " ; Hilbert polynomial " << toString hilbertPolynomial(Is, Projective => false) << endl << flush;
<< "    number of quadrics / cubics in the ideal of Sing: " << numColumns super basis(2, Is) << " / " << numColumns super basis(3, Is) << endl;
if mode == "coble" then (
    (d2, g2, I2) := sing Fs(2*a0); << "    control a -> 2a: dim " << d2 << " degree " << g2 << endl;
    (d3, g3, I3) := sing Fs(0_kk); << "    control a -> 0 : dim " << d3 << " degree " << g3 << endl << flush;);
-- N2
Phi = apply(3, k -> random(2, R));
I = ideal jacobian matrix{{F}} + ideal Phi;
if mode == "ft" then (
    -- class [V]: use the ideal of V = J(Pi_z, T_x): quadrics dF/dz_k and the two determinant cubics (multiples of h_lam(p), h_lam(q))
    IV = ideal(apply(zz, v -> diff(v, F)) | {hes(ps, lam), hes(qs, lam)});
    << "    (ft) F in I_V: " << (F % IV == 0) << " ; dim V = " << dim IV - 1 << " degree " << degree IV << endl;
    I = IV + ideal(apply(ps | qs, v -> diff(v, F))) + ideal Phi;);
G = gb(I, DegreeLimit => 7);
A = R/I;
<< "N2: HF of A, d=0..7: " << apply(toList(0..7), d -> hilbertFunction(d, A)) << endl << flush;
b6 = basis(6, A); b3 = basis(3, A);
if numColumns b6 != 1 then (<< "STOP: dim A_6 = " << numColumns b6 << endl; exit 0);
B6 = basis(6, R); NF = B6 % G; mons6 = flatten entries B6;
s6 = lift(b6_(0,0), R);
dl = flatten entries lift(last coefficients(NF, Monomials => matrix{{s6}}), kk);
idx = new MutableHashTable; scan(#mons6, i -> idx#(mons6#i) = i);
m3 = flatten entries basis(3, R);
PM = matrix(kk, apply(m3, a -> apply(m3, b -> dl#(idx#(a*b)))));
<< "    pairing rank on S_3 = " << rank PM << " ; dim A_3 = " << numColumns b3 << endl << flush;
cf = f -> lift(last coefficients(matrix{{f}}, Monomials => matrix{m3}), kk);
inker = f -> (PM * cf f) == 0;
-- N3 / N4: derivatives along the family
use R;
dx = apply(3, k -> ( e := apply(3, i -> if i == k then 1_kk else 0_kk);
        (Mx e) - (diff(R_k, hes({z_0,z_1,z_2}, lam)) * 0 + (3*x#k^2 + 3*lam*x#((k+1)%3)*x#((k+2)%3)) / den) * hes(zz, lam)));
dadl = - (3*PP x) / den + hx * 81*lam^2 / den^2;      -- d a / d lam
dlamF = 3*PP zz * a0 + dadl * hes(zz, lam) + 3*PP ps + 3*PP qs;
dirs = dx | {dlamF};
<< "N3/N4: family derivatives in the pairing kernel: " << apply(dirs, inker) << endl;
DC = lift(last coefficients(sub(matrix{dirs}, A), Monomials => b3), kk);
K = gens ker PM; KC = lift(last coefficients(sub((matrix{m3}) * K, A), Monomials => b3), kk);
<< "    rank of kernel in A_3 = " << rank KC << " ; rank of family directions in A_3 = " << rank DC << " ; together = " << rank (KC | DC) << endl;
-- controls: wrong coefficient of the z-cubic, and plain z-cubic / plain tensor directions
bad = apply(3, k -> ( e := apply(3, i -> if i == k then 1_kk else 0_kk); (Mx e) - 2 * ((3*x#k^2 + 3*lam*x#((k+1)%3)*x#((k+2)%3)) / den) * hes(zz, lam)));
pure = apply(3, k -> ( e := apply(3, i -> if i == k then 1_kk else 0_kk); Mx e));
<< "    controls: wrong z-cubic coefficient (x2): " << apply(bad, inker) << " ; pure tensor d/dx_k without z-cubic: " << apply(pure, inker) << " ; h_lam(z) alone: " << inker hes(zz, lam) << endl;
if mode == "ft" then (
    -- T F_T inside A_3: tensor moves along the curve (x.grad h = 0 directions) and the common lam-move of everything with x fixed on its curve
    gr := apply(3, k -> 3*x#k^2 + 3*lam*x#((k+1)%3)*x#((k+2)%3));
    << "    (ft) grad h_lam(x) = " << gr << " ; the direction sum_k v_k d/dx_k with v.grad = 0 is tangent to F_T; the transversal one is G_e" << endl;
    v := {gr#1, -gr#0, 0_kk};
    tang := sum(3, k -> v#k * dx#k);
    << "    (ft) tangent combination has no z-cubic: " << (coefficient(z_0^3, tang) == 0) << " ; in kernel: " << inker tang << endl;
    );
