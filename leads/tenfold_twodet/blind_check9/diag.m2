K = toField(QQ[w]/(w^2+w+1));
S = K[x_0..x_11];
Fer = sum(12, i -> x_i^3); J = ideal jacobian ideal Fer;
jac = L -> (
    fs := apply(L, t -> x_(t#0) + w^(t#2)*x_(t#1));
    gs := apply(L, t -> (x_(t#0) + w^(t#2+1)*x_(t#1))*(x_(t#0) + w^(t#2+2)*x_(t#1)));
    jacobian matrix{fs|gs});
P1 = {{0,1,0},{2,3,0},{4,5,0},{6,7,0},{8,9,0},{10,11,0}};
L = {{0,1,1},{2,3,0},{4,10,2},{5,11,2},{6,7,2},{8,9,0}};
M = jac L;
d1 = det M; d2 = det(M, Strategy => Cofactor); d3 = det(M, Strategy => Bareiss);
<< "default == Cofactor: " << (d1 == d2) << "; default == Bareiss: " << (d1 == d3) << endl;
<< "isHomogeneous: " << isHomogeneous d1 << " " << isHomogeneous d2 << " " << isHomogeneous d3 << "; #terms " << #terms d1 << " " << #terms d2 << " " << #terms d3 << endl;
-- expected closed form: +- 3^6 prod c_k (x_i - c_k x_j)
ex = product apply(L, t -> w^(t#2)*(x_(t#0) - w^(t#2)*x_(t#1)));
<< "Cofactor det = +-729*closed form mod J: " << ((d2 - 729*ex) % J == 0 or (d2 + 729*ex) % J == 0) << endl;
<< "default  det = +-729*closed form mod J: " << ((d1 - 729*ex) % J == 0 or (d1 + 729*ex) % J == 0) << endl;
a1 = det(jac P1, Strategy => Cofactor);
hf = a -> apply(8, i -> hilbertFunction(i, S/(J : ideal a)));
<< "HF with Cofactor dets: " << toString hf(a1 - d2) << endl;
<< "HF with default dets:  " << toString hf(det jac P1 - d1) << endl;
