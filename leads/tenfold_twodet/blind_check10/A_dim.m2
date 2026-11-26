-- Claim A: the variety V4 of triples (A,B,C) of 3x3 matrices with no mixed monomials in the 2x2 minors of z0 A + z1 B + z2 C.
-- Independent code. Part 1: equations, dimension, degree, Jacobian ranks at random points of the claimed pieces.
kk = ZZ/32003;
R = kk[a_(1,1)..a_(3,3), b_(1,1)..b_(3,3), c_(1,1)..c_(3,3)];
A = transpose genericMatrix(R, a_(1,1), 3, 3);
B = transpose genericMatrix(R, b_(1,1), 3, 3);
C = transpose genericMatrix(R, c_(1,1), 3, 3);
T = R[z_0..z_2];
N = z_0*sub(A,T) + z_1*sub(B,T) + z_2*sub(C,T);
mins = flatten entries gens minors(2, N);
eqs = flatten apply(mins, m -> apply({z_0*z_1, z_0*z_2, z_1*z_2}, mon -> lift(coefficient(mon, m), R)));
I = ideal eqs;
print("number of equations: " | toString(#eqs) | ", all quadrics: " | toString all(eqs, e -> e == 0 or first degree e == 2) | ", numgens trimmed: " | toString numgens trim I);
print("rank of the 27 quadrics as vectors (linear independence): " | toString rank (coefficients(matrix{eqs}, Monomials => basis(2,R)))#1);
Jac = jacobian I;   -- 27 x 27
rk = pt -> rank sub(Jac, pt);
rnd = (m,n) -> random(kk^m, kk^n);
pointOf = (X,Y,Z) -> matrix{flatten entries X | flatten entries Y | flatten entries Z};
inV = pt -> (sub(gens I, pt) == 0);
-- piece (A,0,0)
scan(3, t -> (
    X := rnd(3,3); O := map(kk^3,kk^3,0);
    pt := pointOf(X,O,O);
    print("piece (A,0,0): in V4 " | toString inV pt | ", Jacobian rank " | toString rk pt)));
-- Segre cones
scan(3, t -> (
    u := rnd(3,1); pt := pointOf(u*rnd(1,3), u*rnd(1,3), u*rnd(1,3));
    print("Segre cone (common column): in V4 " | toString inV pt | ", Jacobian rank " | toString rk pt);
    v := rnd(1,3); pt = pointOf(rnd(3,1)*v, rnd(3,1)*v, rnd(3,1)*v);
    print("Segre cone (common row):    in V4 " | toString inV pt | ", Jacobian rank " | toString rk pt)));
-- 13-dimensional piece: blocks pairwise orthogonal for the polar form of det on 2x2 matrices
pol = (x,y) -> x_(0,0)*y_(1,1) + y_(0,0)*x_(1,1) - x_(0,1)*y_(1,0) - y_(0,1)*x_(1,0);
vecOf = x -> matrix{{x_(0,0), x_(0,1), x_(1,0), x_(1,1)}};
gram = matrix(kk, {{0,0,0,1},{0,0,-1,0},{0,-1,0,0},{1,0,0,0}});
randOrth = L -> (   -- random 2x2 matrix orthogonal to all in L
    M := if #L == 0 then map(kk^0, kk^4, 0) else fold((p,q) -> p || q, apply(L, x -> vecOf(x) * gram));
    K := gens ker M;
    v := K * rnd(numcols K, 1);
    matrix{{v_(0,0), v_(1,0)},{v_(2,0), v_(3,0)}});
padBlock = x -> (x | map(kk^2,kk^1,0)) || map(kk^1,kk^3,0);
scan(4, t -> (
    x := rnd(2,2); y := randOrth {x}; w := randOrth {x,y};
    P := rnd(3,3); Q := rnd(3,3);
    pt := pointOf(P*padBlock(x)*Q, P*padBlock(y)*Q, P*padBlock(w)*Q);
    print("13-dim piece: det P*det Q != 0 " | toString(det P != 0 and det Q != 0) | ", block dets " | toString{det x, det y, det w} | ", pol " | toString{pol(x,y),pol(x,w),pol(y,w)} | ", in V4 " | toString inV pt | ", Jacobian rank " | toString rk pt)));
-- special points: intersection of the two Segre cones, and points of the 13-dim piece with rank(A)=2, B,C rank 1
scan(2, t -> (
    M := rnd(3,1)*rnd(1,3); pt := pointOf(random(kk)*M, random(kk)*M, random(kk)*M);
    print("Segre cone intersection (alpha M, beta M, gamma M): in V4 " | toString inV pt | ", Jacobian rank " | toString rk pt)));
-- dimension and degree
t0 = cpuTime();
G = gb I;
print("gb time " | toString(cpuTime() - t0));
print("dim V4 (affine) = " | toString dim I | ", codim = " | toString codim I | ", degree of top-dimensional part (with multiplicity) = " | toString degree I);
hs = hilbertSeries(I, Reduce => true);
print("reduced Hilbert series numerator: " | toString numerator hs);
print("denominator: " | toString denominator hs);
print("total time " | toString cpuTime());
