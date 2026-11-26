-- Claim B with the package functions (fermatRing, fermatRoot, fermatPeriodPolynomial, fermatVerifyArc,
-- fermatFirstOrderMatrix, fermatLinearSpaceIdeal, fermatReadCertificate); the arc is parsed by my own few lines.
needsPackage("HodgeLociCI", FileName => "/home/claude/hodgelocici/M2/HodgeLociCI.m2");
file = "/home/claude/hodgelocici/M2/HodgeLociCI/data/six_lam-1_arc.txt";
S = fermatRing(3, 10);
z = fermatRoot S;
print("ring: " | toString numgens S | " variables; z^2 - z + 1 = " | toString(z^2 - z + 1));
Tl = select(lines get file, s -> match("^T_[0-9]+ *=", s));
parseT = s -> (
    rhs := substring(1 + (regex("=", s))#0#0, s);
    rhs = replace("\\[", "(", rhs); rhs = replace("\\]", ")", rhs);
    rhs = replace("x([0-9]+)", "x_\\1", rhs);
    v := value rhs;
    if instance(v, ZZ) then v_S else v);
idx = apply(Tl, s -> value substring((regex("^T_([0-9]+)", s))#1, s));
print("orders present in the file: " | toString idx);
Ts = apply(Tl, parseT);
print("all T_j in S, homogeneous cubics or 0: " | toString all(Ts, T -> ring T === S and (T == 0 or (isHomogeneous T and first degree T == 3))));
-- (i)
supp = sort unique flatten apply(Ts, T -> apply(support T, index));
print("(i) variables occurring in the arc: " | toString supp | "; subset of {0..5,8,9}: " | toString isSubset(supp, {0,1,2,3,4,5,8,9}));
print("    monomials occurring: " | toString unique flatten apply(Ts, T -> flatten entries monomials T));
-- (ii)
P1 = {{0,1,1},{2,3,1},{4,5,1},{6,7,1},{8,9,1},{10,11,1}};
P2 = {{1,2,3},{3,4,3},{0,5,3},{6,7,1},{8,9,3},{10,11,1}};
I1 = fermatLinearSpaceIdeal(S, P1); I2 = fermatLinearSpaceIdeal(S, P2);
F0 = sum(12, i -> (S_i)^3);
print("(ii) F0 in I1, I2: " | toString{F0 % I1 == 0, F0 % I2 == 0} | "; dim of linear spaces (projective): " | toString{dim I1 - 1, dim I2 - 1} | "; dim of intersection (projective): " | toString(dim(I1 + I2) - 1));
p1 = fermatPeriodPolynomial(S, P1); p2 = fermatPeriodPolynomial(S, P2);
forms = fermatPeriodForms S;
print("    number of period forms: " | toString(#forms) | " degrees " | toString tally apply(forms, f -> first degree f));
t0 = cpuTime();
vm = fermatVerifyArc(p1 - p2, Ts, 9);
print("    P1 - P2: " | toString vm | "  [" | toString(cpuTime()-t0) | " s]");
vp = fermatVerifyArc(p1 + p2, Ts, 9);
print("    P1 + P2: " | toString vp);
print("    P1 alone: " | toString fermatVerifyArc(p1, Ts, 9));
print("    P2 alone: " | toString fermatVerifyArc(p2, Ts, 9));
-- (iii)
L = fermatFirstOrderMatrix(p1 - p2); L1 = fermatFirstOrderMatrix p1; L2 = fermatFirstOrderMatrix p2; Lp = fermatFirstOrderMatrix(p1 + p2);
print("(iii) size of L: " | toString{numrows L, numcols L});
print("    rank L(P1-P2) = " | toString rank L | ", rank [L_P1; L_P2] = " | toString rank(L1 || L2) | ", rank L_P1 = " | toString rank L1 | ", rank L_P2 = " | toString rank L2 | ", rank L(P1+P2) = " | toString rank Lp);
mons = fermatDeformationMonomials S;
K = coefficientRing S;
v = transpose matrix{apply(mons, m -> lift(coefficient(m, Ts#0), K))};
print("    T_1 is a combination of the 220 squarefree monomials: " | toString((matrix{mons} * promote(v, S))_(0,0) == Ts#0));
print("    L*T_1 == 0: " | toString(L*v == 0) | "; L_P1*T_1 == 0: " | toString(L1*v == 0) | "; L_P2*T_1 == 0: " | toString(L2*v == 0) | "; L(P1+P2)*T_1 == 0: " | toString(Lp*v == 0));
-- the eightfold statement of the file itself
c = fermatReadCertificate file;
S8 = c#"ring";
print("eightfold (file as is): spaces " | toString c#"spaces" | " coefficients " | toString c#"coefficients");
v8 = fermatVerifyArc(c#"periodPolynomial", c#"arc", 9);
print("    eightfold P1 + lambda P2 (lambda=-1): " | toString v8);
L8 = fermatFirstOrderMatrix(c#"periodPolynomial");
p81 = fermatPeriodPolynomial(S8, (c#"spaces")#0); p82 = fermatPeriodPolynomial(S8, (c#"spaces")#1);
print("    eightfold ranks: L(P1-P2) " | toString rank L8 | ", [L_P1;L_P2] " | toString rank(fermatFirstOrderMatrix p81 || fermatFirstOrderMatrix p82) | "; size " | toString{numrows L8, numcols L8});
print("total time " | toString cpuTime());
