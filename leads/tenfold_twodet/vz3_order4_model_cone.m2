-- vz3: the model cone V_4 of PREREG_vz.md (T6, prediction P4).   MOD p.   A statement about polynomials only.
-- Nets N = z_0 A + z_1 B + z_2 C of 3 x 3 matrices; the 27 quadrics are the coefficients of z_i z_j (i < j) in
-- the 2 x 2 minors of N, i.e. the entries of the polar adjugates P(A,B), P(A,C), P(B,C).
-- usage:  M2 --script leads/tenfold_twodet/vz3_order4_model_cone.m2 p seed [dim]
pp = value(scriptCommandLine#1); sd = value(scriptCommandLine#2); kk = ZZ/pp; setRandomSeed sd;
R = kk[a_(0,0)..a_(2,2), b_(0,0)..b_(2,2), c_(0,0)..c_(2,2)];
A = transpose genericMatrix(R, a_(0,0), 3, 3); B = transpose genericMatrix(R, b_(0,0), 3, 3); C = transpose genericMatrix(R, c_(0,0), 3, 3);
Rz = R[z_0..z_2];
N = z_0 * sub(A, Rz) + z_1 * sub(B, Rz) + z_2 * sub(C, Rz);
mn = flatten entries gens minors(2, N);
eqs = flatten apply(mn, m -> apply({z_0*z_1, z_0*z_2, z_1*z_2}, mm -> sub(coefficient(mm, m), R)));
I4 = ideal eqs;
<< "number of quadrics: " << #eqs << " ; independent: " << numcols mingens I4 << endl;
Jm = jacobian I4;
rk = pt -> rank sub(Jm, pt);
ev = pt -> (sub(I4, pt) == 0);
pointOf = (a, b, c) -> matrix{flatten entries a | flatten entries b | flatten entries c};
rnd = (m, n) -> random(kk^m, kk^n);
-- (i) the common-kernel piece: g * diag-block * g', blocks pairwise orthogonal for the polar form of det on 2 x 2 matrices
blk = M2 -> (M2 | matrix{{0_kk},{0_kk}}) || matrix{{0_kk, 0_kk, 0_kk}};
polar = (X, Y) -> X_(0,0)*Y_(1,1) + X_(1,1)*Y_(0,0) - X_(0,1)*Y_(1,0) - X_(1,0)*Y_(0,1);
orthTriple = () -> (
    X := rnd(2, 2);
    while true do (
        Y := rnd(2, 2); Y = polar(X, X) * Y - polar(X, Y) * X;      -- Y orthogonal to X
        if polar(X, X) != 0 and polar(Y, Y) != 0 then break (X, Y));
    );
orth3 = () -> (
    X := rnd(2, 2); while polar(X, X) == 0 do X = rnd(2, 2);
    Y := rnd(2, 2); Y = polar(X, X) * Y - polar(X, Y) * X; while polar(Y, Y) == 0 do (Y = rnd(2, 2); Y = polar(X, X) * Y - polar(X, Y) * X);
    Z := rnd(2, 2); Z = polar(X, X) * Z - polar(X, Z) * X; Z = polar(Y, Y) * Z - polar(Y, Z) * Y;
    (X, Y, Z));
scan(3, t -> (
    (X, Y, Z) := orth3(); g := rnd(3, 3); h := rnd(3, 3);
    pt := pointOf(g * blk(X) * h, g * blk(Y) * h, g * blk(Z) * h);
    << "RESULT common kernel and cokernel, orthogonal blocks: on V_4: " << ev pt << " ; Jacobian rank " << rk pt << " (27 - rank = " << 27 - rk pt << ")" << endl));
-- (ii) the two Segre cones
scan(2, t -> (
    u := rnd(3, 1);
    pt := pointOf(u * rnd(1, 3), u * rnd(1, 3), u * rnd(1, 3));
    << "RESULT Segre cone, common column vector: on V_4: " << ev pt << " ; Jacobian rank " << rk pt << " (27 - rank = " << 27 - rk pt << ")" << endl;
    v := rnd(1, 3);
    pt = pointOf(rnd(3, 1) * v, rnd(3, 1) * v, rnd(3, 1) * v);
    << "RESULT Segre cone, common row vector: on V_4: " << ev pt << " ; Jacobian rank " << rk pt << " (27 - rank = " << 27 - rk pt << ")" << endl));
-- (iii) one invertible matrix, the other two zero
pt = pointOf(rnd(3, 3), 0 * rnd(3, 3), 0 * rnd(3, 3));
<< "RESULT (A, 0, 0), A invertible: on V_4: " << ev pt << " ; Jacobian rank " << rk pt << " (27 - rank = " << 27 - rk pt << ")" << endl;
-- (iv) z_0 C' with det C' = 0 (the cone-type directions): in the closure of the common-kernel piece
Cp = rnd(3, 2) * rnd(2, 3);
pt = pointOf(Cp, 0 * Cp, 0 * Cp);
<< "RESULT (C', 0, 0), rank C' = 2: on V_4: " << ev pt << " ; Jacobian rank " << rk pt << endl;
-- controls: generic nets of rank 3 and of rank 2 are not on V_4
pt = pointOf(rnd(3, 3), rnd(3, 3), rnd(3, 3)); << "control, random net: on V_4: " << ev pt << endl;
g = rnd(3, 2); pt = pointOf(g * rnd(2, 3), g * rnd(2, 3), g * rnd(2, 3)); << "control, random net with a common cokernel vector (rank 2): on V_4: " << ev pt << endl;
if #scriptCommandLine > 3 then (
    tm := cpuTime();
    << "RESULT dimension of V_4 (affine): " << dim I4 << " ; degree " << degree I4 << " ; cpu " << cpuTime() - tm << endl);
