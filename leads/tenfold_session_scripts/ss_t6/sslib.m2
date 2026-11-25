-- SS-T6 library: strata of Sigma = {X : X n L singular along a plane Pi}, L = {z=0}, Pi = {w=z=0}.
-- Tangent of the image of the incidence at X: (K_str)_3 + J_3 (all motions of L, Pi, A, B, v are linear coordinate
-- changes, whose effect on F is J_3 = S_1 . dF; ARG). Ranks with mutable (flint) matrices.
path = append(path, "../bc_so/"); load "../bc_so/setup.m2";   -- setupX (uses buildT.m2)
load "../bc_so/solib.m2";   -- hsData, coefM, pairMat, ...
load "../bc_so/order2.m2";  -- tangentData
load "../bc_so/famlib.m2";  -- nuSetup
pf = x -> (print x; stdio << flush);
rk = M -> rank mutableMatrix M;
-- ideal K of a stratum in S = kk[w_0..w_5, y_0..y_2, z_0..z_2]
stratumIdeal = (name, S) -> (
    w := take(gens S, 6); y := take(gens S, {6,8}); z := take(gens S, {9,11});
    Iz := ideal z; Iw := ideal w;
    if name == "S2" then return Iz + Iw^2;
    if name == "S3" then return Iz + Iw^3;
    if name == "S2AB" then (
        ab := flatten apply(3, a -> apply(3, b -> w#a * w#(3+b)));
        return Iz + ideal flatten apply(y, yy -> apply(ab, q -> yy*q)) + Iw^3);
    if name == "S2v" then (   -- common singular point v = e_{w_5} of all Q_k
        Iv := ideal take(w, 5);
        return Iz + ideal flatten apply(y, yy -> apply(flatten entries gens Iv^2, q -> yy*q)) + Iw^3);
    if name == "VZ" then return intersect(Iz + ideal take(w, {3,5}), Iz + ideal take(w, 3));
    error "unknown stratum"
    );
jac3 = (F) -> (S := ring F; coefM(S, 3, flatten((vars S) ** transpose(jacobian matrix{{F}}))));
K3mat = (K) -> (S := ring K; coefM(S, 3, super basis(3, K)));
-- codim in moduli (S_3 / J_3 has dim 220; S_3 has dim 364) of the space K_3 + J_3
tanCodim = (F, K) -> 364 - rk(K3mat K | jac3 F);
randomIn = (K) -> (S := ring K; b := super basis(3, K); (b * random((coefficientRing S)^(numcols b), (coefficientRing S)^1))_(0,0));
-- smoothness of X along L (cheap partial check): dim of J + (z) (affine) = 0
smoothAlongL = (F) -> (S := ring F; dim(ideal jacobian ideal F + ideal take(gens S, {9,11})) == 0);
end
