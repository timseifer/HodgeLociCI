RQ = QQ[z_0..z_2,p_0..p_2,q_0..q_2];
zz = {z_0,z_1,z_2}; pv = {p_0,p_1,p_2}; qv = {q_0,q_1,q_2};
test = (lamQ, xQ) -> (
  hQ := v -> v#0^3+v#1^3+v#2^3+3*lamQ*v#0*v#1*v#2;
  if hQ(xQ) == 0 then return null;
  aQ := -hQ(xQ) / (27*(1+lamQ^3));
  FQ := aQ*hQ(zz) + hQ(pv) + hQ(qv) + sum(3, i-> sum(3, j-> xQ#((i-j)%3) * zz#((i+j)%3) * pv#i * qv#j));
  JQ := ideal jacobian matrix{{FQ}};
  (dim JQ, degree JQ, aQ));
isCube = r -> (n := numerator r; d := denominator r; cr := t -> (s := round((abs t)^(1/3)); any({s-1,s,s+1}, u -> u^3 == abs t)); cr n and cr d);
cnt = new MutableHashTable;
special = {};
for lamQ in {2, 3} do for x0 from 0 to 5 do for x1 from -5 to 5 do for x2 from -5 to 5 do (
  if gcd(x0,x1,x2) == 1 then (
    r = test(lamQ, {x0,x1,x2});
    if r =!= null then (
      key = (lamQ, r#0, r#1, isCube(r#2));
      if cnt#?key then cnt#key = cnt#key + 1 else cnt#key = 1;
      if r#1 != 18 or isCube(r#2) then special = append(special, (lamQ, {x0,x1,x2}, r)))));
print peek cnt;
print toString special;
-- flex-tangent test: x on a flex tangent line x_i + x_j = lam x_k of the Hesse cubic h_lam ?
onFlex = (lamQ, xQ) -> #select({(0,1,2),(0,2,1),(1,2,0)}, t -> xQ#(t#0) + xQ#(t#1) == lamQ * xQ#(t#2));
print("number of rational flex tangents through x versus (degree of Sing Y):");
print toString tally apply(special, sp -> (onFlex(sp#0, sp#1), (sp#2)#1));
