-- M1 by sampling: points of the curve C = Z_a ∩ P^4 (Z_a = union of the 4-planes of Y through a point a of A), then its Hilbert function.
-- MOD p.  usage: M2 --script h5c_cycle_sampling.m2 p seed ntau
-- (h5 and h5b tried to get the same from a decomposition of Y ∩ Q_a ∩ {G=0}; those did not finish in 10 and 15 minutes.)
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
-- rational point a of A
found = false; cnt = 0;
while not found and cnt < 60 do ( cnt = cnt + 1;
    cps := decompose(Is + ideal(random(1, R), random(1, R)));
    r1 := select(cps, c -> degree c == 1);
    if #r1 > 0 then (found = true; cpt = first r1));
if not found then error "no rational point";
lin = select(flatten entries gens gb cpt, f -> first degree f == 1);
apt = flatten entries gens ker matrix(kk, apply(lin, f -> apply(gens R, v -> coefficient(v, f))));
ev = apply(9, i -> R_i => apt#i);
<< "point a on A: " << (sub(gens Is, ev) == 0) << endl;
grad = jacobian matrix{{F}};                     -- 9 x 1
HessF = jacobian transpose grad;                 -- 9 x 9, linear in y
Ha = lift(sub(HessF, ev), kk);
JA = lift(sub(jacobian Is, ev), kk);
TA = gens ker transpose JA;                      -- 9 x 3 : affine tangent space of A at a
<< "rank Hess F(a) = " << rank Ha << " ; dim T_aA (affine) = " << rank TA << " ; T_aA in ker Hess: " << (Ha * TA == 0) << endl;
-- complement of a in T_aA
am = transpose matrix{apt};
V = TA * (gens ker (matrix{{1_kk,1_kk,1_kk}} * 0 + (transpose (TA \\ am)) ));    -- two vectors of T_aA whose coordinates are orthogonal to those of a
<< "span(a, V) = T_aA: " << (rank(am | V) == 3) << endl;
yv = transpose vars R;                           -- 9 x 1
Qa = ((transpose yv) * sub(Ha, R) * yv)_(0,0);   -- tangent cone at a (up to a factor)
Bm = (transpose sub(V, R)) * HessF * sub(V, R);  -- 2 x 2 (factor 2 irrelevant up to rescaling l)
lv = (transpose sub(V, R)) * grad;               -- 2 x 1
G = Bm_(1,1) * lv_(0,0)^2 - 2 * Bm_(0,1) * lv_(0,0) * lv_(1,0) + Bm_(0,0) * lv_(1,0)^2;
G = 2 * G;                                       -- B = V^T Hess V / 2: G = l^T adj(B) l up to the constant; only the zero locus matters
<< "deg Qa = " << first degree Qa << " rank " << rank Ha << " ; deg G = " << first degree G << endl << flush;
ntau = value(scriptCommandLine#3);
-- random P^4 in P^8, parametrically
T = kk[y_0..y_4];
Lm = random(kk^9, kk^5);                                 -- point of P^8 = Lm * y
ph = map(T, R, flatten entries (sub(Lm, T) * transpose vars T));
F4 = ph F; Q4 = ph Qa; l1 = ph lv_(0,0); l2 = ph lv_(1,0); B11 = ph Bm_(0,0); B12 = ph Bm_(0,1); B22 = ph Bm_(1,1);
C5 = kk[c_1..c_5];
pts = {}; nboth = 0; nres = 0; tried = 0;
for it from 1 to ntau do (
    t1 := random kk; t2 := 1_kk; tried = tried + 1;
    lt := t1 * l1 + t2 * l2; bt := t1^2 * B11 + 2 * t1 * t2 * B12 + t2^2 * B22;
    Iw := saturate ideal(F4, Q4, lt, bt);
    if dim Iw != 1 or degree Iw != 12 then continue;
    cps := decompose Iw;
    rat := select(cps, c -> degree c == 1);
    zhere := 0;
    for c in rat do (
        lin := select(flatten entries gens gb c, f -> first degree f == 1);
        yp := flatten entries gens ker matrix(kk, apply(lin, f -> apply(gens T, v -> coefficient(v, f))));
        Y9 := flatten entries (Lm * transpose matrix{yp});                    -- the point in P^8
        e9 := apply(9, i -> R_i => Y9#i);
        -- fibre W_tau in P^8: F = Qa = l_tau = b_tau = 0 ; tangent space at the point ; is it contained in Y ?
        vt := t1 * V_{0} + t2 * V_{1};
        ltau := ((transpose sub(vt, R)) * grad)_(0,0); btau := ((transpose sub(vt, R)) * HessF * sub(vt, R))_(0,0);
        Jm := lift(sub(jacobian matrix{{F, Qa, ltau, btau}}, e9), kk);        -- 9 x 4
        Tg := gens ker transpose Jm;
        if numColumns Tg != 5 then continue;
        par := flatten entries (sub(Tg, C5) * transpose vars C5);
        onPlane := (sub(F, apply(9, i -> R_i => par#i)) == 0);
        if onPlane then (pts = append(pts, yp); zhere = zhere + 1) else nres = nres + 1);
    if zhere == 2 then nboth = nboth + 1);
<< "tau values tried: " << tried << " ; rational points on linear components (points of Z_a ∩ P^4): " << #pts << " ; tau with both: " << nboth
   << " ; rational points on the non-linear residual: " << nres << endl << flush;
-- Hilbert function of the point set, degrees 2..6
scan({2,3,4,5,6,7,8}, d -> ( Bd := basis(d, T);
    Ev := matrix apply(pts, yp -> flatten entries sub(Bd, apply(5, i -> T_i => yp#i)));
    << "   degree " << d << " : number of monomials " << numColumns Bd << " ; rank of evaluation at the " << #pts << " points = " << rank Ev
       << " ; (12 d - 1 = " << 12*d - 1 << ")" << endl << flush));
