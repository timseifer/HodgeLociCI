-- BC-SO setup: V = J(P^2,T) in P^11, random F in (I_V)_3, pi, T NL, T F_T, G_e
load "buildT.m2";
setupX = (p, sd) -> (
    (IT,a,b,x0,y0) := buildT(p, sd);
    kk := ZZ/p;
    S := kk[w_0..w_5, y_0..y_2, z_0..z_2];
    IV := ideal(z_0,z_1,z_2) + sub(IT, S);
    m3 := basis(3, S);
    I3 := super basis(3, IV);           -- basis of (I_V)_3 as a matrix with columns in S
    F := (I3 * random(kk^(numcols I3), kk^1))_(0,0);
    J := ideal jacobian ideal F;
    new HashTable from {"S"=>S,"kk"=>kk,"IV"=>IV,"IT"=>IT,"F"=>F,"J"=>J,"I3"=>I3,"curve"=>(a,b,x0,y0)}
    );
-- coefficient vectors of a 1-row matrix of forms of degree e w.r.t. monomial basis
coeffs = (e, M, S) -> sub(last coefficients(M, Monomials => basis(e, S)), coefficientRing S);
end
