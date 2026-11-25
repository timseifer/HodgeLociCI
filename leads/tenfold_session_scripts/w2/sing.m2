-- W2: singularities of Z_a = Y_0 n H_a (normalised Fermat fourfold Y_0 = sum f_i h_i (f_i + h_i)), MOD p; and the scroll R
p = 1000037; kk = ZZ/p; R = kk[f_1..f_3, h_1..h_3];
Y0 = sum(1..3, i -> f_i*h_i*(f_i + h_i));
-- a point on the Fermat cubic curve h^3 sum = 0 over F_p: search
fermPt = () -> (for t from 2 to 1000 do (s3 := -(1 + t^3); for s from 1 to p-1 do (if (s^3 - s3) % p == 0 then return {1_kk, t_kk, s_kk}); ); null);
-- cheaper: choose s, t with 1 + t^3 + s^3 = 0 using cube roots when p = 2 mod 3 (here p mod 3:)
print("p mod 3 = " | toString(p % 3));
singInfo = (a, name) -> (
    Ha := a#0*f_1 + a#1*f_2 + a#2*f_3;
    I := ideal(Y0, Ha) + ideal jacobian ideal(Y0, Ha) ;
    J := ideal(Y0, Ha) + minors(2, jacobian matrix{{Y0, Ha}});
    Js := saturate J;
    print(name | ": a = " | toString a | "  dim Sing (proj) = " | toString(dim Js - 1) | "  degree = " | toString(degree Js)
          | "  on P1' part degree = " | toString(degree saturate(Js + ideal(f_1,f_2,f_3)))));
singInfo({1, -1, 2}, "lead a");
singInfo({3, 7, -5}, "random a");
singInfo({0, 1, 5}, "coord line a1=0");
singInfo({1, 1, 5}, "9-line a1=a2");
-- point of D: a = (h1^2,h2^2,h3^2) with h1^3+h2^3+h3^3 = 0; p = 2 mod 3 => every element has a unique cube root
cr = x -> x^((2*p - 1)//3);
hD = {1_kk, 2_kk, cr(-(1_kk + 8_kk))};
print("check h on Fermat cubic: " | toString(hD#0^3 + hD#1^3 + hD#2^3));
singInfo(apply(hD, x -> x^2), "D point");
-- scroll R = {rank [f;h] <= 1, sum h^3 = 0} minus planes: check R subset Y0, degree, genus
IR = saturate(minors(2, matrix{{f_1,f_2,f_3},{h_1,h_2,h_3}}) + ideal(h_1^3 + h_2^3 + h_3^3), ideal(f_1,f_2,f_3)*ideal(h_1,h_2,h_3));
print("R: dim " | toString(dim IR - 1) | " degree " | toString(degree IR) | " in Y0: " | toString(Y0 % IR == 0) | " Hilbert poly " | toString hilbertPolynomial(IR, Projective => false));
