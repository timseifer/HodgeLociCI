-- cv1: the c = 2 special locus (cubic fourfolds containing a cubic scroll, class [P1] - [P2] of disc 12) seen through the
-- node identity: a cubic threefold containing a cubic scroll has 6 nodes with one relation on linear forms.  MOD 32003.
load "tooling/node_section/NodeSection.m2";
kk = ZZ/32003; S = kk[y_0..y_4];
I = minors(2, matrix{{y_0, y_1, y_3}, {y_1, y_2, y_4}});
for sd in {1, 2} do ( setRandomSeed sd;
    V = (gens I * random(source gens I, S^{-3}))_(0,0);
    r = nodalDefect V;
    << "RESULT seed " << sd << ": singular points " << r#"singularPoints" << " ; ODP " << r#"allOrdinaryDoublePoints" << " ; conditions on forms of degree " << r#"formDegree" << ": " << r#"conditions" << " ; defect " << r#"defect" << endl);
