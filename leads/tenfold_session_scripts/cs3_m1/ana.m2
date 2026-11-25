-- lifts of the linear forms x_9, x_10, x_11 in I(delta_t)_1 along the G arc: l(t) = l0 + t l1 + t^2 l2 + ...
-- l_j determined modulo ker C_0 = <x_9,x_10,x_11> (order by order, after fixing lower terms). usage: ana.m2 seed prime Nmax
sd = value scriptCommandLine#1; p = value scriptCommandLine#2; Nm = value scriptCommandLine#3;
tag = "G_" | toString sd | "_" | toString p;
pr = s -> (stderr << s << endl << flush; f := openOutAppend("/home/claude/hodge/discovery/checks/cs3_m1/log_ana_" | tag | ".txt"); f << s << endl; close f);
load "/home/claude/hodge/discovery/checks/cs3_m1/m1setup.m2";
load "/home/claude/hodge/discovery/checks/cs3_m1/m1ag.m2";
hx = agIndex 6;
lams = {pv} | apply(Nm, j -> value get("/home/claude/hodge/discovery/checks/cs3_m1/lam_" | tag | "_j" | toString(j+1) | ".txt"));
C = apply(lams, l -> agCat(l, 1, 6, hx));
for i from 9 to 8 do (
    ls := {transpose matrix{apply(12, a -> if a == i then 1_kk else 0_kk)}};
    for j from 1 to Nm do (
        rhs := - sum(j, q -> C#(j - q) * ls#q);
        y := rhs // C#0;
        if C#0 * y != rhs then (pr("x_" | toString i | ": no lift at order " | toString j); break);
        ls = append(ls, y);
        pr("x_" | toString i | " order " | toString j | ": l_j components on x_0..x_8 (well defined mod <x_9,x_10,x_11> once lower terms fixed): " | toString flatten entries y^{0..8}));
    );
ed = value get("/home/claude/hodge/discovery/checks/cs3_m1/eng_" | tag | "_j3.txt"); f3 = value (ed#2#2);
c3 = sub(matrix (value get("/home/claude/hodge/discovery/checks/so3_t6/t3_G_" | toString sd | "_" | toString p | "_res.txt"))#0, kk);
v = transpose(Pm * cf(matrix{{f3}}));   -- pi(Q f3) = mu_3'/5
pr("pi(Q f3) vs SO3-T6 c3: equal " | toString(v == c3) | "; v == -c3 " | toString(v == -c3) | "; on T NL both zero: " | toString(v * TNL == 0, c3 * TNL == 0) | "; rank [v; c3] = " | toString rank(v || c3) | "; v nonzero " | toString(#select(flatten entries v, a -> a != 0)) | ", c3 nonzero " | toString(#select(flatten entries c3, a -> a != 0)));
rs = value get("/home/claude/hodge/discovery/checks/so3_t6/t3_G_" | toString sd | "_" | toString p | "_res.txt");
p3 = sub(matrix rs#2, kk); p2 = sub(matrix rs#3, kk);
ab = (transpose v) // (transpose(p2 || p3));
pr("v = a psi(Q G g2) + b psi3(Q G^3) with (a, b) = " | toString flatten entries ab | " exact: " | toString(transpose(p2 || p3) * ab == transpose v) | "  (expected (6, -7))");
