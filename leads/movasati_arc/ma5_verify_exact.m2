-- ma5: re-verify an exact state file of ma4_exact.m2 from scratch: fermatVerifyArc over QQ(zeta_6), and the control
-- class [P1] + [P2].   EXACT.
-- usage (repository root):  M2 --script leads/movasati_arc/ma5_verify_exact.m2 lambda statefile
needsPackage("HodgeLociCI", FileName => "M2/HodgeLociCI.m2");
lam = value(scriptCommandLine#1); sf = scriptCommandLine#2;
S = fermatRing(3, 8); z = fermatRoot S;
ll = select(lines get sf, l -> #l > 0 and l#0 != "#");
Ts = apply(drop(ll, 2), l -> value l);
L1 = apply(5, i -> {2*i, 2*i+1, 1});
L2 = apply(5, i -> {2*i, 2*i+1, if i < 3 then 3 else 1});
P = fermatPeriodPolynomial(S, L1) + lam * fermatPeriodPolynomial(S, L2);
tm = cpuTime();
v = fermatVerifyArc(P, Ts);
<< "RESULT exact, lambda = " << lam << ", " << #Ts << " terms: pass " << v#"pass" << " ; first failing order " << toString v#"firstFailingOrder" << " ; cpu " << cpuTime() - tm << endl;
vc = fermatVerifyArc(fermatPeriodPolynomial(S, L1) + fermatPeriodPolynomial(S, L2), take(Ts, 3));
<< "RESULT control [P1] + [P2], 3 terms: pass " << vc#"pass" << " ; first failing order " << toString vc#"firstFailingOrder" << endl;
