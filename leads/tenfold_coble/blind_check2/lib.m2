-- common setup.  Expects: pp (prime), sd (seed), mode ("coble" or "ft") defined before load.
setRandomSeed sd;
kk = ZZ/pp;
R = kk[z_0..z_2,p_0..p_2,q_0..q_2];
zs = {z_0,z_1,z_2}; ps = {p_0,p_1,p_2}; qs = {q_0,q_1,q_2};
hcub = (lam, v) -> v#0^3+v#1^3+v#2^3+3*lam*v#0*v#1*v#2;
Mform = (x, zz, pv, qv) -> sum(3, i -> sum(3, j -> zz#((i+j)%3) * x#((i-j+3)%3) * pv#i * qv#j));
rnz = () -> (c := random kk; while c == 0 do c = random kk; c);
if mode == "coble" then (
    lam = rnz(); while 1+lam^3 == 0 do lam = rnz();
    xv = {rnz(), rnz(), rnz()};
    acoef = -hcub(lam, xv)/(27*(1+lam^3));
    F = acoef*hcub(lam, zs) + hcub(lam, ps) + hcub(lam, qs) + Mform(xv, zs, ps, qs);
) else (
    xv = {rnz(), rnz(), rnz()};
    lam = -(xv#0^3+xv#1^3+xv#2^3)/(3*xv#0*xv#1*xv#2);
    while 1+lam^3 == 0 do (xv = {rnz(), rnz(), rnz()}; lam = -(xv#0^3+xv#1^3+xv#2^3)/(3*xv#0*xv#1*xv#2));
    acoef = 0_kk;
    assert(hcub(lam, xv) == 0);
    F = hcub(lam, ps) + hcub(lam, qs) + Mform(xv, zs, ps, qs);
);
J = ideal jacobian matrix{{F}};
<< "MODE " << mode << " p=" << pp << " seed=" << sd << " lam=" << lam << " x=" << xv << " a=" << acoef << endl << flush;
