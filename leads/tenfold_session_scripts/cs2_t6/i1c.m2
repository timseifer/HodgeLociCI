-- CS2-T6 I1c count: n = h0(N_{S/P^4}(-2f)) for the cubic scroll S in P^4 (sections of N vanishing on two fibres)
pr = s -> (stderr << s << endl << flush);
kk = ZZ/32003; R = kk[x_0..x_4];
M = matrix{{x_0,x_1,x_3},{x_1,x_2,x_4}}; IS = minors(2, M);
-- fibres: kernel lines of M at points (s:t) of P^1: s*row1 + t*row2 = 0 -> f(s,t) = V(s x_0 + t x_1, s x_1 + t x_2, s x_3 + t x_4)
fib = (s, t) -> ideal(s*x_0 + t*x_1, s*x_1 + t*x_2, s*x_3 + t*x_4);
If = intersect(fib(1_kk, 0_kk), fib(0_kk, 1_kk));
pr("fibres in S: " | toString isSubset(IS, If) | ", degree " | toString degree If);
H = Hom(module IS, R^1/IS); H0 = basis(0, H); pr("h0(N_S/P4) = " | toString numColumns H0);
N = image map(R^1/IS, R^(numgens If), gens If);
n = numColumns basis(0, Hom(module IS, N)); pr("n = h0(N_S/P4(-2f)) = " | toString n);
-- control: vanishing on one fibre only
N1 = image map(R^1/IS, R^3, gens fib(1_kk, 0_kk)); pr("control h0(N(-f)) = " | toString numColumns basis(0, Hom(module IS, N1)));
