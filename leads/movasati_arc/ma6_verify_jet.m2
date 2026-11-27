-- ma6: verify a jet file written by blind_check15/run8.py (T_1.. one per line, integer coefficients mod p) with the
-- package (an implementation independent of the Python code that found it).   MOD p.
-- usage (repository root):  M2 --script leads/movasati_arc/ma6_verify_jet.m2 p lambda file
needsPackage("HodgeLociCI", FileName => "M2/HodgeLociCI.m2");
pp = value(scriptCommandLine#1); lam = value(scriptCommandLine#2); f = scriptCommandLine#3;
S = fermatRing(3, 8, pp); z = fermatRoot S;
Ts = apply(select(lines get f, l -> #l > 0), l -> value l);
L1 = apply(5, i -> {2*i, 2*i+1, 1}); L2 = apply(5, i -> {2*i, 2*i+1, if i < 3 then 3 else 1});
P = fermatPeriodPolynomial(S, L1) + lam * fermatPeriodPolynomial(S, L2);
v = fermatVerifyArc(P, Ts);
<< "RESULT p = " << pp << ", lambda = " << lam << ", " << #Ts << " terms: pass " << v#"pass" << " ; first failing order " << toString v#"firstFailingOrder" << " ; z = " << toString z << endl;
vc = fermatVerifyArc(fermatPeriodPolynomial(S, L1) - fermatPeriodPolynomial(S, L2), take(Ts, 2));
<< "RESULT control: the same jet for [P1] - [P2]: pass " << vc#"pass" << " ; first failing order " << toString vc#"firstFailingOrder" << endl;
