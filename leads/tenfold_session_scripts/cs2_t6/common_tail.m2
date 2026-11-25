-- shared tail: expects IZ (5-cycle ideal), F (cubic in I_Z), kd, typ, sd, p; prints Hodge-tangent data and family codim
J = ideal jacobian matrix{{F}};
pr("Z: dim " | toString(dim IZ - 1) | " degree " | toString degree IZ | "; mingens degrees " | toString tally apply(flatten entries mingens IZ, g -> first degree g));
pr("Z contained in X: " | toString(F % IZ == 0) | "; X smooth along Z: " | toString(dim(IZ + J) == 0));
pr("Hilbert function of Z (deg 0..4): " | toString apply(5, i -> numColumns basis(i, S/IZ)));
G6 = gb(IZ + J, DegreeLimit => 6); LT = ideal leadTerm gens G6; bt = lift(basis(6, S/LT), S); m = numColumns bt; pr("m_Z = codim (I_Z + J)_6 = " | toString m);
B6 = basis(6, S); mons = flatten entries B6; idx = new MutableHashTable; scan(#mons, i -> idx#(mons#i) = i);
L3 = flatten entries basis(3, S);
Cm = lift(last coefficients(B6 % G6, Monomials => bt), kk);
rks = apply(min(m,3), j -> (v := flatten entries Cm^{j}; rank matrix table(#L3, #L3, (a,b) -> v_(idx#(L3#a * L3#b)))));
pr("codim T NL per functional: " | toString rks);
(c0, c1, h0) = csCodimPkS2(F, IZ, kd, BR);
pr("RESULT " | typ | " seed " | toString sd | " p " | toString p | ": deg Z " | toString degree IZ | ", m_Z " | toString m | ", T NL codim " | toString rks | ", Hom_0 " | toString h0 | ", family codim w/o moduli " | toString c0 | ", WITH " | toString c1 | ", h0(N_Z/X) " | toString nZX | ", HF_Z(3) - Hom_0 " | toString(hf3Z - h0));
