-- Step B of PREREG_fermat.md (AI-written, unreviewed).  The tenfold
--   X_x : h0(r) + h0(y) + h0(p) + h0(q) + M_x(y,p,q) = 0,  M_x = sum_{i,j} x_(i-j) y_(i+j) p_i q_j,
-- cut by the P^8 {r_k = -theta y_k}, theta^3 = 1 + h0(x)/27, is the normal form of the lead note (lam = 0,
-- a = 1 - theta^3 = -h0(x)/27) and is singular along a surface of degree 18 with Hilbert polynomial 9 n^2.
-- Part 1: EXACT over QQ at x = (3,15,18), theta = 7.   Part 2: MOD 32003 at random x (every element is a cube).
h0 = (a,b,c) -> a^3 + b^3 + c^3;
runB = (kk, xv, th, nm) -> (
    S := kk[r_0..r_2, y_0..y_2, p_0..p_2, q_0..q_2];
    rs := {r_0,r_1,r_2}; ys := {y_0,y_1,y_2}; ps := {p_0,p_1,p_2}; qs := {q_0,q_1,q_2};
    M := sum flatten apply(3, i -> apply(3, j -> xv#((i-j)%3) * ys#((i+j)%3) * ps#i * qs#j));
    F := h0(r_0,r_1,r_2) + h0(y_0,y_1,y_2) + h0(p_0,p_1,p_2) + h0(q_0,q_1,q_2) + M;
    T := kk[z_0..z_2, pp_0..pp_2, qq_0..qq_2];
    f := map(T, S, {-th*z_0, -th*z_1, -th*z_2, z_0, z_1, z_2, pp_0, pp_1, pp_2, qq_0, qq_1, qq_2});
    C := f F;
    zs := {z_0,z_1,z_2}; P := {pp_0,pp_1,pp_2}; Q := {qq_0,qq_1,qq_2};
    a := -(h0(xv#0, xv#1, xv#2)) / 27;
    Nf := a * h0(z_0,z_1,z_2) + h0(pp_0,pp_1,pp_2) + h0(qq_0,qq_1,qq_2)
          + sum flatten apply(3, i -> apply(3, j -> xv#((i-j)%3) * zs#((i+j)%3) * P#i * Q#j));
    << nm << ": section equals the normal form with a = -h0(x)/27 = " << a << ": " << (C == Nf) << endl;
    J := ideal jacobian ideal C;
    I := saturate J;
    << nm << ": singular locus: projective dimension " << dim I - 1 << ", degree " << degree I
       << ", Hilbert polynomial " << toString hilbertPolynomial(I, Projective => false)
       << ", quadrics " << numgens source super basis(2, I) << endl;
    );
runB(QQ, {3, 15, 18}, 7, "EXACT QQ, x = (3,15,18), theta = 7");
kk = ZZ/32003; setRandomSeed 20261126;
scan(3, t -> (
    xv := apply(3, i -> random kk);
    c := 1 + h0(xv#0, xv#1, xv#2) / 27_kk;
    th := c^((2*32003 - 1) // 3);
    assert(th^3 == c);
    runB(kk, xv, th, "MOD 32003, random x no. " | toString(t+1));
    ));
