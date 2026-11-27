-- qf1: prediction P1 of FROZEN_PREDICTION.md: nodes of a hyperplane section of a quartic fourfold on a plane (9) and
-- on a smooth quadric surface (12).   MOD 32003, random instances (seeds 1, 2).
kk = ZZ/32003; R = kk[x_0..x_5]; H = kk[x_0..x_4]; use R;
toH = map(H, R, {H_0, H_1, H_2, H_3, H_4, 0});
for sd in {1, 2} do (
    setRandomSeed sd;
    -- plane P = {x3 = x4 = x5 = 0}
    F = R_3 * random(3, R) + R_4 * random(3, R) + R_5 * random(3, R);
    smooth = (dim ideal(jacobian ideal F) == 0 or codim ideal(jacobian ideal F) == 6);
    V = toH F; IP = ideal(H_3, H_4);
    singP = saturate(IP + ideal jacobian ideal V);
    singAll = saturate(ideal jacobian ideal V + ideal V);
    << "RESULT seed " << sd << " plane: X smooth " << smooth << " ; nodes of V on P: degree " << degree singP << " (dim " << dim singP << ") ; all singular points of V: degree " << degree singAll << endl;
    -- smooth quadric surface Sigma = {x4 = 0, q = 0} in H = {x5 = 0}
    q = sum(select(flatten entries basis(2, R), mm -> isSubset(support mm, {R_0, R_1, R_2, R_3})), mm -> random(kk) * mm);
    G = q * random(2, R) + R_4 * random(3, R) + R_5 * random(3, R);
    smoothG = codim ideal(jacobian ideal G) == 6;
    W = toH G; IS = ideal(toH q, H_4);
    singS = saturate(IS + ideal jacobian ideal W);
    singW = saturate(ideal jacobian ideal W + ideal W);
    << "RESULT seed " << sd << " quadric surface: X smooth " << smoothG << " ; nodes of V on Sigma: degree " << degree singS << " (dim " << dim singS << ") ; all singular points of V: degree " << degree singW << endl);
