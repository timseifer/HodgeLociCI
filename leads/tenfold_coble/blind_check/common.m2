-- common definitions (blind check). Usage: load after setting pr (prime) and seed.
kk = ZZ/pr;
R = kk[z_0..z_2, p_0..p_2, q_0..q_2];
zz = {z_0,z_1,z_2}; pp = {p_0,p_1,p_2}; qq = {q_0,q_1,q_2};
hcub = (v, l) -> v#0^3 + v#1^3 + v#2^3 + 3*l*v#0*v#1*v#2;
Mx = (xv) -> sum(3, i -> sum(3, j -> zz#((i+j)%3) * xv#((i-j+3)%3) * pp#i * qq#j));
-- derivative of M_x w.r.t. x_k
dMx = (k) -> sum(3, i -> sum(3, j -> if (i-j+3)%3 == k then zz#((i+j)%3) * pp#i * qq#j else 0_R));
Fof = (a, l, xv) -> a*hcub(zz,l) + hcub(pp,l) + hcub(qq,l) + Mx(xv);
randNonzero = () -> (c := 0_kk; while c == 0 do c = random kk; c);
-- draw random lam, x with 1+lam^3 != 0, x0 x1 x2 != 0
drawParams = () -> (
    l := random kk;
    while 1 + l^3 == 0 do l = random kk;
    xv := {randNonzero(), randNonzero(), randNonzero()};
    (l, xv));
asharp = (l, xv) -> - hcub(xv,l) / (27*(1+l^3));
