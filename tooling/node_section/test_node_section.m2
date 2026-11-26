-- Regression tests for NodeSection.m2 (AI-written, unreviewed).  Run from this folder:
--     M2 --script test_node_section.m2
-- Exit status 0 and a final line "ALL PASS" mean success.  Expected values and their sources are in README.md.
load "NodeSection.m2";
showRes = (nm, r) -> (<< "RESULT " << nm << ": dim Sing " << r#"singularLocusDim" << ", points " << r#"singularPoints" << ", all ODP "
    << r#"allOrdinaryDoublePoints" << ", form degree " << r#"formDegree" << ", conditions " << r#"conditions" << ", defect " << r#"defect"
    << "  [" << r#"label" << "]" << endl << flush);
chk = (nm, r, pts, odp, e, cond, def) -> (showRes(nm, r);
    assert(r#"singularPoints" === pts and r#"allOrdinaryDoublePoints" === odp and r#"formDegree" === e and r#"conditions" === cond and r#"defect" === def));

-- 1. Segre cubic threefold = Fermat cubic fourfold cut by sum x_i = 0: 10 nodes, defect 5 (classical)
setRandomSeed 1;
kk = ZZ/32003; S = kk[x_0..x_5];
chk("segre-cubic-mod-p", nodalSectionReport(sum(6, i -> x_i^3), sum(6, i -> x_i)), 10, true, 1, 5, 5);
S = QQ[x_0..x_5];
chk("segre-cubic-QQ", nodalSectionReport(sum(6, i -> x_i^3), sum(6, i -> x_i)), 10, true, 1, 5, 5);

-- 2. a general hyperplane section of a random cubic tenfold: smooth
setRandomSeed 2;
kk = ZZ/32003; S = kk[x_0..x_11];
r = nodalSectionReport(random(3, S), random(1, S)); showRes("general-section", r);
assert(r#"singularLocusDim" === -1 and r#"singularPoints" === 0 and r#"defect" === 0);

-- 3. a cubic threefold with one A_2 point: the Jacobian scheme has length 2 and is not reduced
setRandomSeed 3;
kk = ZZ/32003; S = kk[x_0..x_4];
cub = (basis(3, S, Variables => {x_1, x_2, x_3, x_4}) * random(kk^20, kk^1))_(0,0);     -- a random cubic in x_1..x_4
r = nodalDefect(x_0 * (x_1^2 + x_2^2 + x_3^2) + cub);
showRes("one-A2-point", r);
assert(r#"singularPoints" === 2 and r#"allOrdinaryDoublePoints" === false);

-- 4. Coble: the named member of leads/tenfold_coble/exact_member (section 12 of the lead note), cut by w_2 = 0
setRandomSeed 4;
kk = ZZ/32003; load "../../leads/tenfold_coble/exact_member/member.m2";
chk("coble-exact-member", nodalSectionReport(F, w_2), 72, true, 4, 71, 1);

-- 5. Pfaffian / K3 control (section 11 of the lead note): a tenfold whose P^8-section is a Pfaffian cubic
setRandomSeed 5;
kk = ZZ/32003; R9 = kk[y_0..y_8]; S = kk[u_0..u_8, t_1..t_3];
inc = map(S, R9, (vars S)_{0..8});
Lf = new MutableHashTable; scan(6, i -> scan(6, j -> if i < j then Lf#(i,j) = random(1, R9)));
Mp = matrix table(6, 6, (i,j) -> if i < j then Lf#(i,j) else if i > j then -Lf#(j,i) else 0_R9);
Psi = apply(3, k -> inc random(2, R9)); lins = apply(9, k -> random(1, S));
F0 = inc((gens pfaffians(6, Mp))_(0,0)) + sum(3, k -> S_(9+k) * Psi#k);
Fp = F0 + sum(3, k -> sum(3, l -> S_(9+k) * S_(9+l) * lins#(3*k+l)));
chk("pfaffian-k3", nodalSectionReport(Fp, t_3), 56, true, 4, 55, 1);

-- 6. the same without the terms of degree >= 2 in t: the line {u = 0} is singular; the tool must say "not finite"
r = nodalSectionReport(F0, t_3); showRes("singular-line", r);
assert(r#"singularLocusDim" === 1 and r#"singularPoints" === "not finite" and r#"defect" === "not determined");
<< "ALL PASS" << endl;
