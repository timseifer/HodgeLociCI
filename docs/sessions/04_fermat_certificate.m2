needsPackage("HodgeLociCI", FileName => "../../M2/HodgeLociCI.m2");
file = "../../tests/data/fermat/cert_n6_lam-1.txt";
C = fermatReadCertificate file;
C#"degree", C#"dimension", C#"lambda", C#"label"
netList C#"spaces"
netList C#"arc"
-- every checkable claim of the file is recomputed over Q(zeta_6)
v = fermatVerifyCertificate C;
v#"pass", v#"vanishingOrder", v#"obstructionOrder"
netList(v#"checks", Alignment => Left)
-- the same obstruction, recomputed from the arc alone: the order-5 system has no solution
r = fermatNextOrderSystem(C#"periodPolynomial", C#"arc");
r#"order", r#"lowerOrdersVanish", r#"solvable", rank r#"matrix"
r#"obstruction"
-- first-order numbers at this pair of planes (Movasati's pair (H,K) = (7,8))
t = fermatTangentData(C#"ring", C#"spaces", C#"coefficients");
t#"jointPersistenceCodimension", t#"hodgeCodimension"
-- a corrupted certificate is rejected: one coefficient of T_2 changed from -1/3 to -1/2
bad = temporaryFileName() | ".txt";
bad << replace("T_2 = \\[-1/3\\]", "T_2 = [-1/2]", get file) << close;
w = fermatVerifyCertificate bad; w#"pass", w#"firstFailingOrder"
