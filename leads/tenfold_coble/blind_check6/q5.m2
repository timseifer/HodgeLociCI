-- q5.m2 : the tenfold.  expects pp, sd, tag, nrep ; reads nothing else (recomputes the instance: same seed => same F as inst.m2,
-- but the point a / plane pi are re-drawn here; pi is a random plane in the explicit 4-plane and in a second 4-plane)
load "common.m2"; load "fano.m2"; load "planes.m2";
print("== Q5 instance " | tag | ": p=" | toString pp | " seed=" | toString sd | " lam=" | toString lam | " x=" | toString xx);
(P0, inf0) = iotaPlane();
pts = {}; while #pts < 2 do pts = pts | ratPointsA();
a2 = pts#1;
P1 = null; Ka2 = transpose gens kernel hessAt a2;
while P1 === null do ( (pls, dgd, cinfo) = planesThroughTangent(a2, random(kk^1,kk^3) * Ka2); if #pls == 2 then P1 = pls#0;);
S12 = kk[z_0..z_2,p_0..p_2,q_0..q_2,w_0..w_2];
toS = map(S12, R, (vars S12)_{0..8});
FS = toS F;
yv = (vars S12)_{0..8}; wv = (vars S12)_{9..11};
tenfold = (piM, withW) -> (
    Npi := transpose gens kernel piM;                 -- 6 x 9 : linear forms vanishing on pi
    lpi := flatten entries (yv * transpose sub(Npi, S12));   -- 6 linear forms
    Phi := apply(3, k -> sum(6, j -> lpi#j * (if withW then random(1, S12) else toS random(1, R))));
    G := FS + sum(3, k -> (wv_(0,k)) * Phi#k);
    (G, lpi, Phi) );
checkX = (G, lpi, label) -> (
    c1 := (sub(G, {w_0 => 0, w_1 => 0, w_2 => 0}) == FS);
    c2 := ((G % ideal lpi) == 0);
    t0 := cpuTime();
    Jx := ideal jacobian matrix{{G}};
    gbx := groebnerBasis(Jx, Strategy => "F4");
    lts := flatten entries leadTerm gbx;
    pure := select(gens S12, v -> any(lts, m -> (support m == {v})));
    dimx := dim ideal lts;
    print("Q5 [" | label | "]: X cap {w=0} = Y: " | toString c1 | "; Lambda={y in pi} contained in X: " | toString c2 | "; affine dim of singular locus (Jacobian ideal) = " | toString dimx | " (0 means X smooth); variables with a pure power among the leading terms: " | toString(#pure) | "/12; degree of Jacobian ideal: " | toString degree ideal lts | "  [" | toString(cpuTime()-t0) | " s]");
    );
for rep from 1 to nrep do (
    piM = random(kk^3, kk^5) * (if rep % 2 == 1 then P0 else P1);
    (G, lpi, Phi) = tenfold(piM, true);
    checkX(G, lpi, (if rep % 2 == 1 then "pi in explicit plane" else "pi in plane P1") | ", random Phi #" | toString rep);
    );
-- negative control : linear forms without w  (X is then singular along {y=0})
(G, lpi, Phi) = tenfold(random(kk^3, kk^5) * P0, false);
checkX(G, lpi, "CONTROL, linear factors without w: must be singular");
print("== Q5 done " | tag);
