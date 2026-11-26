-- fanoA.m2 : the full scheme of 4-planes of Y through a (chart), direct degree count for Z_a.  expects pp, sd, tag
load "common.m2"; load "fano.m2"; load "planes.m2";
print("== fanoA instance " | tag | ": p=" | toString pp | " seed=" | toString sd);
pts = {}; while #pts < 4 do pts = pts | ratPointsA();
a = pts#0;
Ka = transpose gens kernel hessAt a;
-- T_aA = <a, t0, t1>
tb = random(kk^2, kk^3) * Ka;
if rank(a || tb) != 3 then error "bad t0,t1";
t0v = tb^{0}; t1v = tb^{1};
-- N7 := <t1> + random 6-space, so that <a, t0+tau*t1> meets N7 trivially for every finite tau (no rank-deficient chart points);
-- variant "generic" (chartGeneric = true) uses a random N7 instead, which meets T_aA in one vector n0 = (alpha a + beta t0 + gamma t1)
Cb = if chartGeneric then random(kk^7, kk^9) else random(kk^7, kk^7) * (t1v || random(kk^6, kk^9));
print("chart: " | (if chartGeneric then "generic N7" else "N7 containing t1"));
RT = kk[tt_(0,0)..tt_(2,3), tau, ss_0..ss_4];
T = matrix apply(3, i -> apply(4, j -> tt_(i,j)_RT));
W = (id_(RT^3) | T) * sub(Cb, RT);
Pm = sub(a, RT) || (sub(t0v, RT) + tau_RT * sub(t1v, RT)) || W;
v = (matrix{apply(5, i -> ss_i_RT)}) * Pm;
cf = (coefficients(sub(F, v), Variables => apply(5, i -> ss_i_RT)))#1;
RT2 = kk[tt_(0,0)..tt_(2,3), tau];
IC = ideal sub(cf, RT2);
Pm2 = sub(Pm, RT2);
t0 = cpuTime();
GC = ideal groebnerBasis(IC, Strategy => "F4");
print("scheme of 4-planes of Y through a (chart: P cap T_aA = <a, t0+tau*t1>, P cap N7 in a Grassmannian chart): dim = " | toString dim GC | ", degree (affine chart) = " | toString degree GC | " [" | toString(cpuTime()-t0) | " s]");
-- fibres over random tau : degree 2
print("  fibre degrees over 5 random tau: " | toString apply(5, i -> (c := random kk; Ic := ideal groebnerBasis(GC + ideal(tau_RT2 - c), Strategy => "F4"); (dim Ic, degree Ic))));
-- direct count of deg Z_a : planes through a meeting a random P^3
for rep from 1 to 3 do (
    L = random(kk^4, kk^9);
    dL = det(Pm2 || sub(L, RT2));
    t0 = cpuTime();
    IL = ideal groebnerBasis(GC + ideal dL, Strategy => "F4");
    dIL = (dim IL, degree IL);
    rIL = radical IL;
    mins = minors(5, Pm2);
    ILs = saturate(IL, mins);
    print("   after removing chart points where the 5 spanning vectors are dependent: degree " | toString degree ILs | " (dim " | toString dim ILs | ")");
    -- intersection points y = P cap L for each solution : check they are distinct via the eliminant of a generic coordinate
    print("Q1 direct (random P^3 #" | toString rep | "): scheme of 4-planes of Y through a meeting the P^3: (dim, degree) = " | toString dIL | ", degree of radical = " | toString degree rIL | " [" | toString(cpuTime()-t0) | " s]");
    );
-- irreducibility of the curve of planes: plane model in (tau, u), u a random linear form in the chart coordinates
RT3 = kk[tt_(0,0)..tt_(2,3), uu, tau, MonomialOrder => Eliminate 12];
lf = sum(12, i -> random(kk) * RT3_i);
IC3 = sub(GC, RT3) + ideal(uu_RT3 - lf);
t0 = cpuTime();
G3 = groebnerBasis(IC3, Strategy => "F4");
el = flatten entries selectInSubring(1, G3);
print("plane model of the curve of planes: " | toString(#el) | " eliminant(s), degrees in (u,tau): " | toString apply(el, f -> (degree(uu_RT3, f), degree(tau_RT3, f))) | " [" | toString(cpuTime()-t0) | " s]");
if #el > 0 then (
    f = el#0;
    R2 = kk[uu, tau];
    f2 = sub(f, R2);
    print("  factorisation over F_p: " | toString apply(toList factor f2, g -> (degree(uu_R2, g#0), degree(tau_R2, g#0), g#1)));
    if degree(uu_R2, f2) == 2 then (
        A1 = kk[tau];
        toA1 = map(A1, R2, {0_A1, A1_0});
        c2 = toA1 sub(diff(uu_R2^2, f2), R2) / 2;
        c1 = toA1 sub(diff(uu_R2, f2), {uu_R2 => 0});
        c0 = toA1 sub(f2, {uu_R2 => 0});
        c2 = toA1 (sub(diff(uu_R2, diff(uu_R2, f2)), R2)) * (1/2_kk);
        disc = c1^2 - 4*c2*c0;
        fd = toList factor disc;
        print("  leading coefficient c2(tau): degree " | toString first degree c2 | "; discriminant in tau: degree " | toString first degree disc | ", factors (degree, multiplicity): " | toString apply(fd, g -> (first degree g#0, g#1)));
        nOdd = sum apply(select(fd, g -> (g#1 % 2 == 1)), g -> first degree g#0);
        print("  number of roots of nOdd multiplicity (= finite branch points of the double cover of the tau-line): " | toString nOdd);
        );
    );
print("== fanoA done " | tag);
