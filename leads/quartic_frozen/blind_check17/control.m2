runL = (pr, sd) -> (
  setRandomSeed sd;
  kk := ZZ/pr;
  R := kk[x_0..x_5]; S := kk[y_0..y_4];
  Q1 := random(2, S); Q2 := random(2, S);
  toR := map(R, S, {x_0,x_1,x_2,x_3,x_4});
  A := random(2,R); B := random(2,R); C := random(3,R);
  T := kk[y_0..y_4, z_0..z_4, Degrees=>{5:{1,0},5:{0,1}}];
  fy := map(T, R, {y_0,y_1,y_2,y_3,y_4,0});
  sy := map(T, S, {y_0,y_1,y_2,y_3,y_4}); sz := map(T, S, {z_0,z_1,z_2,z_3,z_4});
  bil := q -> (sum(5, i -> z_i * diff(y_i, sy q)));
  I := ideal(sy Q1, sy Q2, sz Q1, sz Q2, bil Q1, bil Q2);
  M := minors(2, matrix{{y_0,y_1,y_2,y_3,y_4},{z_0,z_1,z_2,z_3,z_4}});
  J := saturate(saturate(saturate(I, M), ideal(y_0..y_4)), ideal(z_0..z_4));
  print(toString{"control: Sigma with no point constraint", J == ideal 1_T, "dim", dim J})

)
for pr in {32003, 10007} do for sd in {1,2,3} do if pr==32003 and sd==1 then runL(pr,sd)
