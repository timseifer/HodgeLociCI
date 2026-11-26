-- Claim A, part 2: components of V4 by saturation (independent code), over ZZ/32003.
kk = ZZ/32003;
R = kk[a_(1,1)..a_(3,3), b_(1,1)..b_(3,3), c_(1,1)..c_(3,3)];
A = transpose genericMatrix(R, a_(1,1), 3, 3);
B = transpose genericMatrix(R, b_(1,1), 3, 3);
C = transpose genericMatrix(R, c_(1,1), 3, 3);
T = R[z_0..z_2];
N = z_0*sub(A,T) + z_1*sub(B,T) + z_2*sub(C,T);
mins = flatten entries gens minors(2, N);
I = ideal flatten apply(mins, m -> apply({z_0*z_1, z_0*z_2, z_1*z_2}, mon -> lift(coefficient(mon, m), R)));
tm = () -> toString cpuTime();
LA = ideal(flatten entries B | flatten entries C);
LB = ideal(flatten entries A | flatten entries C);
LC = ideal(flatten entries A | flatten entries B);
-- (1) locus where det A != 0
S1 = saturate(I, det A);
print("(1) saturate(I, det A) == (B,C entries): " | toString(S1 == LA) | "   [t=" | tm() | "]");
-- (2) locus where a 2x2 minor of A is nonzero
mA = a_(1,1)*a_(2,2) - a_(1,2)*a_(2,1);
S2 = saturate(I, mA);
print("(2) saturate(I, minor of A): dim " | toString dim S2 | " degree " | toString degree S2 | "   [t=" | tm() | "]");
IW = saturate(S2, b_(1,1));
print("    IW = saturate(that, b11): dim " | toString dim IW | " degree " | toString degree IW | " numgens " | toString numgens trim IW | " generator degrees " | toString tally flatten degrees trim IW);
print("    S2 == intersect(IW, LA): " | toString(S2 == intersect(IW, LA)));
-- same from B and C side: the 13-dim piece is symmetric
mB = b_(1,1)*b_(2,2) - b_(1,2)*b_(2,1);
IWB = saturate(saturate(I, mB), a_(1,1));
print("    same construction starting from a minor of B gives the same ideal: " | toString(IWB == IW));
mA2 = a_(2,2)*a_(3,3) - a_(2,3)*a_(3,2);
IWA2 = saturate(saturate(I, mA2), b_(1,1));
print("    same construction from another minor of A gives the same ideal: " | toString(IWA2 == IW) | "   [t=" | tm() | "]");
-- description of the 13-dim piece: common kernel and cokernel
row3 = A | B | C;        -- 3 x 9
col3 = A || B || C;      -- 9 x 3
print("    IW contains the 3x3 minors of [A|B|C] and of [A;B;C]: " | toString(isSubset(minors(3,row3), IW) and isSubset(minors(3,col3), IW)));
-- (3) locus where all 2x2 minors of A, B, C vanish
I3 = I + minors(2,A) + minors(2,B) + minors(2,C);
Scol = minors(2, row3);   -- (u a^T, u b^T, u c^T): [A|B|C] has rank <= 1
Srow = minors(2, col3);
print("(3) Segre cones: dims " | toString{dim Scol, dim Srow} | " degrees " | toString{degree Scol, degree Srow} | "; contained in V4: " | toString(isSubset(I, Scol) and isSubset(I, Srow)));
print("    dim, degree of I3 = I + all 2x2 minors of A,B,C: " | toString{dim I3, degree I3});
rest = saturate(saturate(I3, Scol), Srow);
print("    saturate(saturate(I3, Scol), Srow) == 1 (so the rank<=1 locus of V4 is the union of the two Segre cones): " | toString(rest == ideal 1_R) | "   [t=" | tm() | "]");
print("    I3 == intersect(Scol, Srow): " | toString(I3 == intersect(Scol, Srow)));
-- Segre cones are not inside the 13-dim piece, and the linear pieces neither
print("    Scol contains IW? " | toString isSubset(IW, Scol) | "; Srow contains IW? " | toString isSubset(IW, Srow) | "; LA contains IW? " | toString isSubset(IW, LA));
print("    dim (IW + Scol) = " | toString dim(IW + Scol) | ", dim (Scol + Srow) = " | toString dim(Scol + Srow) | ", dim (IW + LA) = " | toString dim(IW + LA));
-- (4) the whole thing
Iall = intersect(IW, Scol, Srow, LA, LB, LC);
print("(4) I == intersection of the six candidate component ideals: " | toString(I == Iall) | "   [t=" | tm() | "]");
print("    I contained in the intersection: " | toString isSubset(I, Iall));
hsI = hilbertSeries(I, Reduce => true); hsAll = hilbertSeries(Iall, Reduce => true);
print("    Hilbert numerators: I: " | toString numerator hsI | " ; intersection: " | toString numerator hsAll);
-- Jacobian-rank check that I is generically reduced along each piece was done in A_dim.m2.
-- (5) is IW prime / radical?
print("(5) hilbert numerator of IW: " | toString numerator hilbertSeries(IW, Reduce => true));
print("    codim of singular locus computation skipped; trying isPrime IW ...");
t0 = cpuTime();
ip = try isPrime IW else "failed";
print("    isPrime IW: " | toString ip | "   [" | toString(cpuTime() - t0) | " s]");
print("done t=" | tm());
