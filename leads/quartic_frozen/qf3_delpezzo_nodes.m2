-- qf3: P2 of FROZEN_PREDICTION.md, after reading Kloosterman Prop. 6.1 (lambda = -1 cycle Y_t = CI of type
-- (1^(k-1), 2, 2)). Prediction (EXACT arithmetic, written before running): a hyperplane section of a quartic
-- fourfold containing a (2,2) CI surface Sigma (quartic del Pezzo) has 16 singular points on Sigma.
-- MOD 32003, random instances (seeds 1, 2, 3).
kk = ZZ/32003; R = kk[x_0..x_5]; H = kk[x_0..x_4]; use R;
toH = map(H, R, {H_0, H_1, H_2, H_3, H_4, 0});
for sd in {1, 2, 3} do (
    setRandomSeed sd;
    q1 = random(2, H); q2 = random(2, H);
    Q1 = sub(q1, {H_0=>R_0,H_1=>R_1,H_2=>R_2,H_3=>R_3,H_4=>R_4});
    Q2 = sub(q2, {H_0=>R_0,H_1=>R_1,H_2=>R_2,H_3=>R_3,H_4=>R_4});
    G = Q1 * random(2, R) + Q2 * random(2, R) + R_5 * random(3, R);
    smoothG = codim ideal(jacobian ideal G) == 6;
    W = toH G; IS = ideal(q1, q2);
    smoothS = codim(IS + minors(2, jacobian IS)) == 5;
    singS = saturate(IS + ideal jacobian ideal W);
    singW = saturate(ideal jacobian ideal W + ideal W);
    << "  seed " << sd << " points impose on forms of degree 2,3,4 (ambient P4) / on Sigma: " << toString apply({2,3,4}, e -> hilbertFunction(e, H/singS)) << " / " << toString apply({2,3,4}, e -> hilbertFunction(e, H/IS)) << endl;
    << "RESULT seed " << sd << " X smooth " << smoothG << " ; Sigma smooth " << smoothS << " ; nodes of V on Sigma: degree " << degree singS << " (dim " << dim singS << ", reduced " << (singS == radical singS) << ") ; all singular points of V: degree " << degree singW << endl);
exit 0
