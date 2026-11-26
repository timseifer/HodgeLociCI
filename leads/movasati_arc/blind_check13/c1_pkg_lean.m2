-- C1 with the package (black box), lean version: fermatExpansion along the lambda = -1 arc to order N.
needsPackage("HodgeLociCI", FileName => "M2/HodgeLociCI.m2");
fn = scriptCommandLine#1; p = value scriptCommandLine#2; N = value scriptCommandLine#3;
S = fermatRing(3, 8, p);
use S;
lns = select(lines get ("leads/movasati_arc/arcs/" | fn), l -> #l > 0);
Ts = apply(drop(lns, 3), l -> value l);
L1 = apply(5, i -> {2*i, 2*i+1, 1});
L2 = apply(5, i -> {2*i, 2*i+1, if i < 3 then 3 else 1});
Pm = fermatPeriodPolynomial(S, L1) - fermatPeriodPolynomial(S, L2);
t0 = cpuTime();
M = fermatExpansion(Pm, Ts, N);
print("RESULT pkg file " | fn | " p " | toString p | " terms " | toString(#Ts) | " expansion [P1]-[P2] to order " | toString N | ": " | toString(numrows M) | " x " | toString(numcols M) | " zero matrix: " | toString(M == 0) | "  cpu " | toString(cpuTime() - t0));
