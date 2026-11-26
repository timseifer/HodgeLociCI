-- C1 with the package (black box): fermatVerifyArc / fermatExpansion along the lambda = -1 arcs.
-- run from the repository root:  M2 --script /home/claude/blind_check13/c1_pkg.m2 <file> <p> <N>
needsPackage("HodgeLociCI", FileName => "M2/HodgeLociCI.m2");
fn = scriptCommandLine#1; p = value scriptCommandLine#2; N = value scriptCommandLine#3;
S = fermatRing(3, 8, p);
use S;
z = fermatRoot S;
print("RESULT pkg file " | fn | " p " | toString p | " z " | toString z);
lns = select(lines get ("leads/movasati_arc/arcs/" | fn), l -> #l > 0);
Ts = apply(drop(lns, 3), l -> value l);
print("RESULT pkg terms " | toString(#Ts));
L1 = apply(5, i -> {2*i, 2*i+1, 1});
L2 = apply(5, i -> {2*i, 2*i+1, if i < 3 then 3 else 1});
P1 = fermatPeriodPolynomial(S, L1); P2 = fermatPeriodPolynomial(S, L2);
Pm = P1 - P2; Pp = P1 + P2;
Lm = fermatFirstOrderMatrix Pm;
print("RESULT pkg firstOrderMatrix " | toString(numrows Lm) | " x " | toString(numcols Lm) | " rank " | toString(rank Lm));
t0 = cpuTime();
M = fermatExpansion(Pm, Ts, N);
print("RESULT pkg expansion [P1]-[P2] to order " | toString N | ": " | toString(numrows M) | " x " | toString(numcols M) | " zero matrix: " | toString(M == 0) | "  cpu " | toString(cpuTime() - t0));
v1 = fermatVerifyArc(P1, Ts, 1); vp = fermatVerifyArc(Pp, Ts, 2);
print("RESULT pkg [P1] alone firstFailingOrder " | toString(v1#"firstFailingOrder") | " ; [P1]+[P2] firstFailingOrder " | toString(vp#"firstFailingOrder"));
