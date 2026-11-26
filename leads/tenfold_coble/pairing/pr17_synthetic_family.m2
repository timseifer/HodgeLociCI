-- Section 16.7 of the lead note: the cubics det(M) - det(sM) on P(sl_3) = P^7, s a product of reflections of the form tr(XY).
-- Exploratory (first run in a scratch folder, NOT pre-registered); AI-written, unreviewed.
-- usage (from this folder):  M2 --script pr17_synthetic_family.m2 p seed numberOfReflections       MOD p.
load "detrep_lib.m2";
pp = value(scriptCommandLine#1); sd = value(scriptCommandLine#2); nrefl = value(scriptCommandLine#3); kk = ZZ/pp; setRandomSeed sd;
Rh = kk[y_0..y_7];
M = matrix{{y_0, y_1, y_2}, {y_3, y_4, y_5}, {y_6, y_7, -y_0-y_4}};
refl1 = X -> ( K := random(kk^3, kk^3); K = K - (trace K / 3) * id_(kk^3); ck := 2 / trace(K * K); X - (ck * trace(X * sub(K, Rh))) * sub(K, Rh) );
sM = M; scan(nrefl, i -> sM = refl1 sM);
G = det M - det sM;
<< nrefl << " reflections: tr equal " << (trace M == trace sM) << " ; s_2 equal " << (s2of M == s2of sM) << " ; det equal " << (det M == det sM) << endl;
J = saturate ideal jacobian matrix{{G}};
<< "G = det M - det sM: singular locus of dimension " << dim J - 1 << ", degree " << degree J << (if dim J == 2 then ", genus " | toString genus J else "") << " ; quadrics through it: " << numColumns super basis(2, J) << " ; cubics: " << numColumns super basis(3, J) << endl << flush;
B3 = basis(3, Rh);
co = L -> lift(last coefficients(matrix{L}, Monomials => B3), kk);
gl = flatten apply(8, i -> apply(8, j -> Rh_i * diff(Rh_j, G)));
bs = {matrix(kk,{{1,0,0},{0,-1,0},{0,0,0}}), matrix(kk,{{0,0,0},{0,1,0},{0,0,-1}})} | select(flatten apply(3, i -> apply(3, j -> if i != j then matrix(kk, apply(3, a -> apply(3, b -> if (a,b) == (i,j) then 1 else 0))) else null)), x -> x =!= null);
adjm = X -> matrix apply(3, i -> apply(3, j -> (-1)^(i+j) * det submatrix'(X, {j}, {i})));
aS = adjm sM;
so = select(flatten apply(8, a -> apply(8, b -> if a < b then ( K1 := sub(bs#a, Rh); K2 := sub(bs#b, Rh); trace(aS * (trace(sM * K1) * K2 - trace(sM * K2) * K1)) ) else null)), x -> x =!= null);
<< "family: rank of gl_8.G " << rank co gl << " ; of the " << #so << " variations of s " << rank co so << " ; together (affine dimension) " << rank co(gl | so) << endl << flush;
if dim J == 2 then (
    gch = map(Rh, Rh, (vars Rh) * random(kk^8, kk^8));
    MA = detRep gch det M; MB = detRep gch det sM;
    r = if instance(MA, String) or instance(MB, String) then "detRep failed" else solvePair(MA, MB);
    if instance(r, String) then << "round trip: " << r << endl else (
        T = kk[y_0..y_7, t]; lhs = det(t * id_(T^3) + sub(r#0, T)) - det(t * id_(T^3) + sub(r#1, T));
        << "round trip (scramble the two determinants by a random change of coordinates, recover matrices with equal trace and s_2): det(t + A) - det(t + B) = c G exactly: " << (lhs % ideal(sub(gch G, T)) == 0 and lhs != 0) << endl ) );
<< "DONE p " << pp << " seed " << sd << endl;
