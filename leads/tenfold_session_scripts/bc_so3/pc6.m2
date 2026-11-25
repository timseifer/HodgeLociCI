-- BC-SO3 positive control: own order-3 pipeline (derivation of c3 and the g2 freedom) with the package's closed-form
-- Fermat periods as evaluator; Fermat cubic sixfold, two 3-planes P1, P2 meeting in a point, class [P1] + lam [P2].
-- Cross-check of the order-3 coefficient with the package's own arc tool fermatNextOrderSystem (same G, g2).
needsPackage("HodgeLociCI", FileName => "/home/claude/hodgelocici/M2/HodgeLociCI.m2");
load "/home/claude/hodge/discovery/checks/bc_so/solib.m2";
pr = value(scriptCommandLine#1); sd = value(scriptCommandLine#2);
pf = x -> (print x; stdio << flush);
setRandomSeed sd;
S = fermatRing(3, 6, pr); kk = coefficientRing S; k = 3;
L1 = {{0,1,1},{2,3,1},{4,5,1},{6,7,1}}; L2 = value(scriptCommandLine#3);
I1 = fermatLinearSpaceIdeal(S, L1); I2 = fermatLinearSpaceIdeal(S, L2);
pf("P1 n P2 is a point:", dim(I1 + I2) == 1);
Pp1 = fermatPeriodPolynomial(S, L1); Pp2 = fermatPeriodPolynomial(S, L2);
-- Phi_m in the GD convention Phi_(m+1)(A.dF) = Phi_m(div A)/m (closed form rescaled)
Phi = (Pc, P) -> (q := (first degree P - 4) // 3; fermatPeriod(Pc, P) / product(q, i -> k + 1 + i));
b1 = flatten entries basis(1, S); b3 = flatten entries basis(3, S);
pairM = Pc -> matrix(kk, apply(b3, g -> apply(b1, Q -> Phi(Pc, g*Q))));     -- rows S_3, cols S_1
lK = M -> gens ker M;
runArm = (name, lam, mode) -> (
    Pc := Pp1 + lam * Pp2;
    M := pairM Pc;                       -- pi(g Q)
    TNL := gens ker transpose M;         -- g with pi(g S_1) = 0
    Kl := gens ker M;                    -- Q with pi(S_3 Q) = 0
    TS := gens ker transpose(pairM(Pp1) | pairM(Pp2));   -- both planes deform
    Gc := if mode == "TNL" then TNL * random(kk^(numcols TNL), kk^1) else TS * random(kk^(numcols TS), kk^1);
    G := (matrix{b3} * sub(Gc, S))_(0,0);
    -- order 2: pi(Q g2) = ((k+1)/2) psi(Q G^2) for all Q in S_1
    r2 := matrix(kk, {apply(b1, Q -> ((k+1)/2) * Phi(Pc, Q*G^2))});
    o2 := r2 * Kl;
    g2c := (transpose r2) // (transpose M);   -- M^T g2 = r2^T
    if (transpose M) * g2c != transpose r2 then error "order 2 not solvable";
    g2 := (matrix{b3} * sub(g2c, S))_(0,0);
    -- order 3: k pi(Q g3) = k(k+1) psi(Q G g2) - C(k+2,3) psi3(Q G^3)
    c3 := matrix(kk, {apply(b1, Q -> (k+1) * Phi(Pc, Q*G*g2) - (binomial(k+2,3)/k) * Phi(Pc, Q*G^3))});
    fr := matrix(kk, apply(numcols TNL, j -> (w := (matrix{b3} * sub(TNL_{j}, S))_(0,0);
        apply(b1, Q -> (k+1) * Phi(Pc, Q*G*w)))));     -- rows w, cols Q
    c3K := c3 * Kl; frK := fr * Kl;
    solv := rank(frK || c3K) == rank frK;
    -- package arc tool: F_eps = F0 - (eps T1 + eps^2 T2), so T1 = -G, T2 = -g2
    ns := fermatNextOrderSystem(Pc, {-G, -g2});
    pf(name | ": lam " | toString lam | ", G in " | mode | ": dim TNL " | toString numcols TNL | ", dim T_Sigma " | toString numcols TS |
       ", dim K_l " | toString numcols Kl | "; order-2 on K_l zero: " | toString(o2 == 0) |
       "; c3 on K_l: " | toString c3K | "; freedom rank " | toString rank frK |
       " => " | (if solv then "SOLVABLE" else "OBSTRUCTED") |
       " | package fermatNextOrderSystem: lowerOrdersVanish " | toString ns#"lowerOrdersVanish" | ", obstruction zero " | toString(ns#"obstruction" == 0) |
       ", solvable(fixed g2) " | toString ns#"solvable");
    (solv, c3K)
    );
arms = value(scriptCommandLine#4);
scan(arms, a -> runArm(a#0, a#1, a#2));
pf "PC6 DONE";
