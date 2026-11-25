-- generic order-2 test, given functional data
-- Fam: matrix whose columns (coef vectors on basis(d)) span T(family); piv: pi row vector on basis(sig)
-- psiFun: function G -> row vector psi(G m) on basis(sig)
tangentData = (H, piv) -> (
    S := H#"S"; d := H#"d"; q0 := H#"q0";
    P := pairMat(S, d, q0, piv);           -- rows S_d, cols S_q0
    TNL := gens ker transpose P;            -- G with G^T P = 0
    K0 := gens ker P;                       -- Q in S_q0 with pi(Q S_d) = 0
    (TNL, K0)
    );
orderTwo = (H, Fam, TNL, K0, psiFun) -> (
    S := H#"S"; d := H#"d"; q0 := H#"q0"; kk := coefficientRing S;
    bd := basis(d, S);
    -- excess directions: complement of Fam in TNL
    ex := rank(Fam | TNL) - rank Fam;
    if rank(Fam | TNL) != rank TNL then error "Fam not inside TNL";
    -- choose Ge among TNL columns not in span(Fam)
    cur := Fam; picks := {};
    for j from 0 to numcols TNL - 1 do (
        if #picks == ex then break;
        if rank(cur | TNL_{j}) > rank cur then (cur = cur | TNL_{j}; picks = append(picks, j)));
    Ge := TNL_{picks#0};
    GeP := (bd * sub(Ge, S))_(0,0);
    pv := psiFun GeP;
    Bf := pairMat(S, d, q0, pv);             -- psi(Ge u v)
    qrow := (transpose Ge) * Bf * K0;
    Bmat := (transpose Fam) * Bf * K0;
    new HashTable from {"excess"=>ex, "dimTNL"=>numcols TNL, "dimFam"=>rank Fam, "dimK0"=>numcols K0,
        "rankB"=>rank Bmat, "rankBq"=>rank(Bmat || qrow), "qzero"=>(qrow == 0), "Bzero"=>(Bmat == 0),
        "rankBfull"=>rank Bf, "Ge"=>GeP, "psiGe"=>pv}
    );
-- self-check: random h in Fam: psi(h h' K) for h' in Fam, K in K0 must vanish
famCheck = (H, Fam, K0, psiFun) -> (
    S := H#"S"; d := H#"d"; q0 := H#"q0"; kk := coefficientRing S;
    h := Fam * random(kk^(numcols Fam), kk^1);
    hP := (basis(d,S) * sub(h,S))_(0,0);
    pv := psiFun hP;
    Bf := pairMat(S, d, q0, pv);
    M := (transpose Fam) * Bf * K0;
    -- nontriviality: psi(h w K) over all w in S_d (should be nonzero)
    (rank M, rank(Bf * K0), rank Bf)
    );
end
