-- VALIDATION TEST 02
-- Source:    R. Kloosterman, "On a conjecture on Hodge loci of linear combinations of linear subvarieties",
--            arXiv:2312.12363, Proposition 3.10 (first display). SOURCES.md entry B. Read by machine only.
-- Statement: for two k-planes meeting in dimension k-c on a smooth hypersurface of degree d in P^(2k+1), the tangent
--            space of NL([Pi_1],[Pi_2]) has codimension
--                2 binomial(k+d,k) - binomial(k-c+d,k-c) - (k+1)^2 - 2c(k+1) + c^2.
-- Computed:  excessFromDegrees(d, ones c, ones c, ones (k+1-c))#"codimVZ" on the grid 3 <= d <= 7, 1 <= k <= 6, 1 <= c <= k+1
--            (and, for the single plane, "codimV1" against binomial(k+d,d) - (k+1)^2: Villaflor Loyola, arXiv:2001.01019,
--            Theorem 1.1, SOURCES.md entry C2).
-- Label:     EXACT (integer arithmetic on the degrees).
-- Expected:  the published formula, evaluated here.
load (currentFileDirectory | "common.m2")

bad := {};
cnt := 0;
for d from 3 to 7 do for k from 1 to 6 do for c from 1 to k+1 do (
    t := excessFromDegrees(d, ones c, ones c, ones(k+1-c));
    want := 2*binomial(k+d,k) - (if k-c >= 0 then binomial(k-c+d,k-c) else 0) - (k+1)^2 - 2*c*(k+1) + c^2;
    cnt = cnt + 1;
    if t#"codimVZ" != want or t#"codimV1" != binomial(k+d,d) - (k+1)^2 then bad = append(bad, (d,k,c,t#"codimVZ",want));
    );
expect("number of triples (d,k,c) tested", cnt, 135);
expect("triples where codimVZ differs from Kloosterman's Proposition 3.10 or codimV1 from binomial(k+d,d)-(k+1)^2", bad, {});
-- the instances named in the task: cubic sixfold and eightfold
expect("Prop. 3.10 at (d,k,c) = (3,3,3): codimVZ", (excessFromDegrees(3, ones 3, ones 3, ones 1))#"codimVZ", 8);
expect("Prop. 3.10 at (d,k,c) = (3,4,3): codimVZ", (excessFromDegrees(3, ones 3, ones 3, ones 2))#"codimVZ", 20);
finish()
