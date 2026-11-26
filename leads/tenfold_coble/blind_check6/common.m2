-- common.m2 : expects pp (prime), sd (seed) to be defined before load
setRandomSeed sd;
kk = ZZ/pp;
R = kk[z_0..z_2,p_0..p_2,q_0..q_2];
lam = random kk;
xx = apply(3, i-> random kk);
-- optional fixed parameters (the random draws above are still made, to keep the random stream identical)
if class fixedLam =!= Symbol then (lam = fixedLam_kk; xx = apply(fixedX, c -> c_kk));
hLam = (v) -> v#0^3+v#1^3+v#2^3+3*lam*v#0*v#1*v#2;
zz = {z_0,z_1,z_2}; ppv = {p_0,p_1,p_2}; qq = {q_0,q_1,q_2};
Mx = sum(3, i-> sum(3, j-> xx#((i-j)%3) * zz#((i+j)%3) * ppv#i * qq#j));
aa = (-hLam(xx)) * (27*(1+lam^3))^(-1);
F = aa*hLam(zz) + hLam(ppv) + hLam(qq) + Mx;
gradF = jacobian matrix{{F}};      -- 9x1
J = ideal gradF;
hessF = jacobian transpose gradF;   -- 9x9 symmetric, entries linear
-- evaluate at a point given as 1x9 matrix over kk
evalAt = (G, pt) -> sub(G, pt);
