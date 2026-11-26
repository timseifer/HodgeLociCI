-- C5 with the package (black box): the eightfold arc read as an arc of the Fermat cubic tenfold.
-- run from the repository root:  M2 --script /home/claude/blind_check13/c5_pkg.m2 <file> <p> <N>
needsPackage("HodgeLociCI", FileName => "M2/HodgeLociCI.m2");
fn = scriptCommandLine#1; p = value scriptCommandLine#2; N = value scriptCommandLine#3;
S = fermatRing(3, 10, p);
use S;
lns = select(lines get ("leads/movasati_arc/arcs/" | fn), l -> #l > 0);
Ts = apply(drop(lns, 3), l -> value l);
L1 = apply(6, i -> {2*i, 2*i+1, 1});
L2 = apply(6, i -> {2*i, 2*i+1, if i < 3 then 3 else 1});
Pm = fermatPeriodPolynomial(S, L1) - fermatPeriodPolynomial(S, L2);
forms = fermatPeriodForms S;
print("RESULT pkg10 file " | fn | " p " | toString p | " forms " | toString(#forms) | " terms " | toString(#Ts));
t0 = cpuTime();
v = fermatVerifyArc(Pm, Ts, N);
print("RESULT pkg10 [P1]-[P2] tenfold, order " | toString N | ": pass " | toString(v#"pass") | " firstFailingOrder " | toString(v#"firstFailingOrder") | " numberOfForms " | toString(v#"numberOfForms") | "  cpu " | toString(cpuTime() - t0));
vp = fermatVerifyArc(fermatPeriodPolynomial(S, L1) + fermatPeriodPolynomial(S, L2), Ts, 2);
print("RESULT pkg10 [P1]+[P2] tenfold firstFailingOrder " | toString(vp#"firstFailingOrder"));
