-- cloud-job-2 (PK2): verbatim copy of discovery t6_unsolved/c/zq431_exact.m2 (team T6c), package path made relative (working directory jobs/cloud-job-2/m2scan); timing lines added.
-- EXACT over QQ: a point of the stratum Z_431 (two 3-planes meeting in a plane on a quartic sixfold; the 5-plane V(p2,p3) tangent to X along a line of Y1 n Y2)
needsPackage("HodgeLociCI", FileName => "../../../M2/HodgeLociCI.m2");
S = QQ[x_0..x_7]; f = {x_0}; h = {x_1}; p = {x_2,x_3,x_4};
b1 = x_5 + 2*x_6 - x_7; m = x_6 - 3*x_7 + x_5;
M00 = m^2 + x_0*(x_3 + x_7) - x_1*(x_5 - 2*x_4) + x_2*x_6;
s1 = b1*m^2 + x_2*(x_5^2 - x_0*x_7) + x_3*x_6*x_7 + x_4*(x_1^2 + x_5*x_6) + x_0^2*x_7;
s2 = x_5^3 + 2*x_6^3 - x_7^3 + x_5*x_6*x_7 + x_0*x_6^2 + x_1^3 + x_2*x_3*x_4 + 3*x_3^3;
s3 = x_5^2*x_7 - x_6^2*x_5 + 5*x_7^2*x_6 + x_6^3 - x_4^3 + x_1*x_5^2 + x_0*x_1*x_2 + 2*x_4*x_7^2;
t0 = cpuTime(); D = cyclePair(f, h, p, matrix{{M00}}, {s1,s2,s3});
print("smooth", D#"smooth", D#"label");
e = excessFromData D; print("E'", e#"dimAnnDetM", "S", e#"conditionS", e#"label"); print("cpu", cpuTime() - t0);
a = secondOrderObstruction(D, 2); print("lambda=2", a#"verdict", a#"excess", a#"rankOfQuadrics", a#"commonZeroLocusDim", a#"label");
print("quadrics", a#"quadrics");
print("directions", a#"excessDirections"); print("cpu", cpuTime() - t0);
a1 = secondOrderObstruction(D, 1); print("lambda=1", a1#"verdict");
