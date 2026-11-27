-- re1: exact (QQ) node counts for the sixfold and eightfold rungs (PREREG.md).
load "tooling/node_section/NodeSection.m2";
setRandomSeed 5;
R9 = QQ[u_0..u_8];
rl = () -> sum(9, i -> (random(-3, 3)) * R9_i);
-- Pfaffian cubic: 6 x 6 skew matrix of linear forms
M = mutableMatrix(R9, 6, 6);
for i from 0 to 5 do for j from i+1 to 5 do (f := rl(); M_(i,j) = f; M_(j,i) = -f);
Pf = pfaffians(6, matrix M); Gk = (gens Pf)_(0,0);
-- Coble member (lam = -2, x = (8,18,1))
hes = (v, lm) -> v#0^3 + v#1^3 + v#2^3 + 3*lm*v#0*v#1*v#2;
zz = {u_0,u_1,u_2}; ps = {u_3,u_4,u_5}; qs = {u_6,u_7,u_8}; lam = -2; x = {8, 18, 1};
a0 = - hes(x, lam) / (27*(1+lam^3));
Ga = a0 * hes(zz, lam) + hes(ps, lam) + hes(qs, lam) + sum flatten apply(3, i -> apply(3, j -> zz#((i+j)%3) * x#((i-j)%3) * ps#i * qs#j));
<< "a0 = " << a0 << endl;
restrictTo = (G, n) -> ( Sn := QQ[w_0..w_(n-1)]; phi := map(Sn, R9, apply(9, i -> sum(n, j -> (random(-2, 2)) * Sn_j))); phi G );
results = {};
for pr in {("K3 (Pfaffian)", Gk), ("abelian (Coble)", Ga)} do (
    (nm, G) := pr;
    G6 := restrictTo(G, 7);
    r := nodalDefect G6;
    << "RESULT sixfold rung, " << nm << ": singular points " << r#"singularPoints" << " ; all ODP " << r#"allOrdinaryDoublePoints" << " ; conditions on forms of degree " << r#"formDegree" << ": " << r#"conditions" << " ; defect " << r#"defect" << " ; " << r#"label" << endl << flush);
for pr in {("K3 (Pfaffian)", Gk), ("abelian (Coble)", Ga)} do (
    (nm, G) := pr;
    S8 := QQ[v_0..v_7, t]; phi8 := map(S8, R9, apply(9, i -> sum(8, j -> (random(-2, 2)) * S8_j)));
    Psi := sum(flatten entries basis(2, S8), mm -> random(-3, 3) * mm);
    V0 := phi8 G + t * Psi;
    r8 := nodalDefect V0;
    << "RESULT eightfold rung, " << nm << ": singular points " << r8#"singularPoints" << " ; all ODP " << r8#"allOrdinaryDoublePoints" << " ; conditions on forms of degree " << r8#"formDegree" << ": " << r8#"conditions" << " ; defect " << r8#"defect" << " ; " << r8#"label" << endl << flush);
