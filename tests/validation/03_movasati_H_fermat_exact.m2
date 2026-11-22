-- VALIDATION TEST 03
-- Source:    H. Movasati, arXiv:1602.06607, Section 6, eq. (21) and Table 1 (first entries H_n^3(m)); the tuple
--            (4,4,0 | 11,12); H. Movasati, arXiv:1902.00831, Tables 1 and 2, row codim(V^1) (stated there for all
--            coefficients 1 <= |r|, |r-check| <= 10); H. Movasati, arXiv:2211.11405, Appendix A, Proposition 21
--            (R. Villaflor): dim T_0 V_[Z] = dim T_0 V_Z + 1 for m = n/2-3. SOURCES.md entries A1, A2, A3.
-- Statement: H_n^3(m) = codimension of the Zariski tangent space, AT THE FERMAT POINT, of the Hodge locus of the sum of
--            two linear P^(n/2) meeting in P^m. n = 6: (H,K) = (4,4), (4,7), (6,8), (7,8), (8,8) for n/2-m = 0..4;
--            n = 8: (10,10), (10,16), (16,19), (19,20), (20,20), (20,20). In particular 8 -> 7 and 20 -> 19.
-- Computed:  fermatTangentData(S, {L1, L2}, {r, r'}) over Q(zeta_6) with the planes
--            P1: x_(2i) = z x_(2i+1) (all i), P2: x_(2i) = z^3 x_(2i+1) (i < c), = z x_(2i+1) (i >= c);
--            "hodgeCodimension" against H, "jointPersistenceCodimension" against K.
-- Label:     EXACT (linear algebra over Q(zeta_2d)).
-- Expected:  the published tables. For coefficients other than (1,1) the published statement is the row codim(V^1) of
--            arXiv:1902.00831 (c = 2, 3 only); for c = 1 other coefficients are printed as INFO without expectation.
load (currentFileDirectory | "common.m2")

Htable = new HashTable from {4 => {1,1,1,1}, 6 => {4,4,6,7,8}, 8 => {10,10,16,19,20,20}};
Ktable = new HashTable from {4 => {1,2,2,2}, 6 => {4,7,8,8,8}, 8 => {10,16,19,20,20,20}};
for n in {4,6,8} do (
    k := n//2;
    S := fermatRing(3, n);
    Hs := {}; Ks := {};
    for c from 0 to k+1 do (
        (L1, L2) := fermatSpaces(k, c);
        t := if c == 0 then fermatTangentData(S, {L1}, {1}) else fermatTangentData(S, {L1, L2}, {1, 1});
        Hs = append(Hs, t#"hodgeCodimension");
        Ks = append(Ks, t#"jointPersistenceCodimension");
        );
    expect("Fermat cubic, n = " | toString n | ": H_n^3(m) for n/2-m = 0.." | toString(k+1) | " (coefficients (1,1))", Hs, Htable#n);
    expect("Fermat cubic, n = " | toString n | ": K_n^3(m) for n/2-m = 0.." | toString(k+1), Ks, Ktable#n);
    -- other coefficients: arXiv:1902.00831, Tables 1, 2 (c = 2, 3), all r, r-check
    for c in {2, 3} do if c <= k+1 then (
        (L1, L2) := fermatSpaces(k, c);
        got := apply({{1,-1}, {1,2}, {3,-5}, {7,10}}, rr -> (fermatTangentData(S, {L1, L2}, rr))#"hodgeCodimension");
        expect("Fermat cubic, n = " | toString n | ", c = " | toString c | ": codim(V^1) for (r,r') = (1,-1), (1,2), (3,-5), (7,10)",
            got, toList(4 : (Htable#n)#c));
        );
    (L1, L2) := fermatSpaces(k, 1);
    report("Fermat cubic, n = " | toString n | ", c = 1: codimension for (r,r') = (1,-1), (1,2) (no published value used)",
        apply({{1,-1}, {1,2}}, rr -> (fermatTangentData(S, {L1, L2}, rr))#"hodgeCodimension"));
    );
-- the two pairs named in the task
S6 = fermatRing(3, 6); (L1, L2) = fermatSpaces(3, 3); t6 = fermatTangentData(S6, {L1, L2}, {1, 1});
expect("cubic sixfold, two 3-planes meeting in a point: (K, H)", {t6#"jointPersistenceCodimension", t6#"hodgeCodimension"}, {8, 7});
S8 = fermatRing(3, 8); (L1, L2) = fermatSpaces(4, 3); t8 = fermatTangentData(S8, {L1, L2}, {1, 1});
expect("cubic eightfold, two 4-planes meeting in a line: (K, H)", {t8#"jointPersistenceCodimension", t8#"hodgeCodimension"}, {20, 19});
expect("arithmetic label of the Fermat module mentions EXACT", match("EXACT", t8#"label"), true);
-- quartic fourfold, two planes meeting in a point: (4,4,0 | 11,12); and (4,4,-1 | 12,12)
S4 = fermatRing(4, 4);
(L1, L2) = fermatSpaces(2, 2); q = fermatTangentData(S4, {L1, L2}, {1, 1});
expect("Fermat quartic fourfold, m = 0: (H, K)", {q#"hodgeCodimension", q#"jointPersistenceCodimension"}, {11, 12});
(L1, L2) = fermatSpaces(2, 3); q = fermatTangentData(S4, {L1, L2}, {1, 1});
expect("Fermat quartic fourfold, m = -1: (H, K)", {q#"hodgeCodimension", q#"jointPersistenceCodimension"}, {12, 12});
finish()
