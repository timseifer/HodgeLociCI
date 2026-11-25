-- T3: two 4-planes
pp = value(scriptCommandLine#1); sd = value(scriptCommandLine#2); mode = "coble";
load "/home/claude/blind_check2/lib.m2";
xs = gens R;  -- order z0 z1 z2 p0 p1 p2 q0 q1 q2  (indices 0..8)
iotaM = map(R, R, {z_0,z_2,z_1, q_0,q_2,q_1, p_0,p_2,p_1});
<< "T3: iota preserves F? " << (iotaM F == F) << endl;
sigM = map(R, R, {z_2,z_0,z_1, p_1,p_2,p_0, q_1,q_2,q_0});  -- z_k -> z_{k+2}, p_i -> p_{i+1}, q_j -> q_{j+1}
<< "T3: sigma preserves F? " << (sigM F == F) << endl;
E = id_(kk^9);
ev = i -> E_{i};
bm = (ev 1 - ev 2) | (ev 3 - ev 6) | (ev 4 - ev 8) | (ev 5 - ev 7);       -- V_-
bp = (ev 0) | (ev 1 + ev 2) | (ev 3 + ev 6) | (ev 4 + ev 8) | (ev 5 + ev 7);  -- V_+
-- check eigen-properties via the point map of iota (permutation matrix)
Piota = transpose matrix apply(9, i -> apply(9, j -> if iotaM(xs#i) == xs#j then 1_kk else 0_kk));
<< "T3: iota*bm == -bm ? " << (Piota*bm == -bm) << " ; iota*bp == bp ? " << (Piota*bp == bp) << endl;
S = kk[c_1..c_5, u_1..u_4, s];
vecS = sub(bm, S) * transpose matrix{{u_1,u_2,u_3,u_4}} + s * sub(bp, S) * transpose matrix{{c_1,c_2,c_3,c_4,c_5}};
toS = map(S, R, flatten entries vecS);
Fs = toS F;
<< "T3: F restricted to P(V_-) is zero? " << (sub(Fs, {s => 0}) == 0) << endl;
(mons, cf) = coefficients(Fs, Variables => {u_1,u_2,u_3,u_4,s});
C = kk[c_1..c_5];
Ic = ideal sub(cf, C);
<< "T3: conditions on v_+: number of nonzero coefficient equations = " << #select(flatten entries sub(cf, C), f -> f != 0) << ", degrees " << tally apply(select(flatten entries sub(cf,C), f -> f != 0), f -> first degree f) << endl;
<< "T3: locus of v_+ in P(V_+): affine dim " << dim Ic << ", degree " << degree Ic << endl << flush;
Icsat = saturate Ic;
<< "T3: saturated ideal generators degrees: " << apply(flatten entries mingens Icsat, f -> first degree f) << ", HF 0..3 " << apply(4, d -> hilbertFunction(d, C/Icsat)) << endl << flush;
lf = select(flatten entries mingens Icsat, f -> first degree f == 1);
Mlin = sub(last coefficients(matrix{lf}, Monomials => vars C), kk);  -- 5 x 4
cvec = gens ker transpose Mlin;   -- 5 x 1
<< "T3: v_+ coordinates in basis (z0, z1+z2, p0+q0, p1+q2, p2+q1): " << flatten entries cvec << endl;
vplus = bp * cvec;
PB = bm | vplus;   -- 9 x 5, basis of P
R5 = kk[y_1..y_5];
FP = (map(R5, R, flatten entries (sub(PB, R5) * transpose vars R5))) F;
<< "T3: rank of P basis = " << rank PB << "; F restricted to P identically zero? " << (FP == 0) << endl;
-- point map of sigma: coordinate x_i(v') = (sigM x_i)(v)
Psig = transpose matrix apply(9, i -> apply(9, j -> if sigM(xs#i) == xs#j then 1_kk else 0_kk));
Psig = transpose Psig;  -- so that (Psig v)_i = v_j where sigM x_i = x_j
chk = (map(R, R, flatten entries (sub(Psig, R) * transpose vars R))) F;
<< "T3: F(Psig v) == F(v) ? " << (chk == F) << "; Psig^3 == 1 ? " << (Psig^3 == id_(kk^9)) << endl;
doPair = (QB, nm) -> (
    << "---- pair (P, " << nm << ") ----" << endl;
    FQ := (map(R5, R, flatten entries (sub(QB, R5) * transpose vars R5))) F;
    << "T3: F vanishes on " << nm << "? " << (FQ == 0) << endl;
    KK := gens ker (PB | -QB);
    << "T3: dim(P ∩ " << nm << ") as linear spaces = " << numColumns KK << "  (2 = projective line); rank(P|" << nm << ") = " << rank(PB|QB) << endl;
    LB := PB * KK^{0..4};   -- 9 x 2 basis of the line
    T2 := kk[s, t];
    toT := map(T2, R, flatten entries (sub(LB, T2) * transpose vars T2));
    IL := toT J;
    ILs := saturate IL;
    << "T3: line ∩ Sing(Y): affine dim " << dim IL << ", degree (length) " << degree IL << "; saturated gens " << flatten entries gens ILs << endl;
    g := (flatten entries gens ILs)#0;
    fac := toList factor g;
    << "T3: factorisation of the binary form: " << factor g << endl;
    -- field of definition of the points
    local K; local pts;
    lin := select(fac, f -> first degree f#0 == 1);
    if #lin >= 1 then (
        K = kk;
        pts = apply(lin, f -> (h := f#0; a := coefficient(s, h); b := coefficient(t, h); -- a s + b t = 0 -> (s,t) = (b,-a)
            sub(LB, K) * matrix{{sub(b,kk)},{-sub(a,kk)}}));
        << "T3: " << #pts << " kk-rational point(s) (multiplicities " << apply(lin, f -> f#1) << ")" << endl;
    ) else (
        A1 := kk[al];
        gal := sub(sub(g, {s => A1_0, t => 1_A1}), A1);
        gAA = A1; gcg = gal; gQ = A1/ideal gal;
        K = toField gQ;
        pts = {sub(LB, K) * matrix{{sub(al, K)},{1_K}}};
        << "T3: points are conjugate over GF(p^2); working at one of them over kk[al]/(" << gal << ")" << endl;
    );
    Hs := jacobian J;  -- Hessian over R
    scan(pts, p0 -> (
        ev0 := map(K, R, flatten entries p0);
        << "  point p0 = " << flatten entries p0 << endl;
        << "  all partials vanish at p0? " << (ev0 gens J == 0) << endl;
        H0 := matrix apply(9, i -> apply(9, j -> ev0(Hs_(i,j))));
        << "  rank Hess F(p0) = " << rank H0 << endl;
        TA := gens ker H0;   -- 9 x 3 if rank 6
        << "  dim ker Hess = " << numColumns TA << "; p0 in ker? " << (H0*p0 == 0) << endl;
        S1 := sub(PB, K) | TA; S2 := sub(QB, K) | TA;
        r1 := rank S1; r2 := rank S2;
        << "  dim span(P, T_p0 A) = " << r1 << " (proj dim " << r1-1 << "); dim span(" << nm << ", T_p0 A) = " << r2 << " (proj dim " << r2-1 << ")" << endl;
        << "  Hess vanishes identically on span(P,TA)? " << (transpose(S1)*H0*S1 == 0) << "; on span(" << nm << ",TA)? " << (transpose(S2)*H0*S2 == 0) << endl;
        r12 := rank(S1 | S2);
        << "  rank(span1|span2) = " << r12 << "; dim of intersection of the two spans = " << (r1 + r2 - r12) << " (proj dim " << (r1 + r2 - r12 - 1) << ")" << endl;
        << "  dim of P ∩ T_p0A = " << (5 + 3 - r1) << endl << flush;
        if K =!= kk then (
            -- robust cross-check: regular representation K -> M_2(kk), K-rank = kk-rank / 2
            AA := gAA;  cg := gcg;   -- al^2 + c1 al + c0
            c1 := sub(coefficient(AA_0, cg), kk); c0 := sub(cg - AA_0^2 - coefficient(AA_0, cg)*AA_0, kk);
            Cg := matrix{{0_kk, -c0},{1_kk, -c1}};
            rho := e -> (l := lift(sub(e, gQ), AA); a1 := sub(coefficient(AA_0, l), kk); a0 := sub(l - coefficient(AA_0, l)*AA_0, kk); a0*id_(kk^2) + a1*Cg);
            blk := Mx -> matrix apply(numRows Mx, i -> apply(numColumns Mx, j -> rho(Mx_(i,j))));
            << "  [block check over kk] rank Hess = " << (rank blk H0)/2 << ", dim span1 = " << (rank blk S1)/2 << ", dim span2 = " << (rank blk S2)/2 << ", rank(span1|span2) = " << (rank blk(S1|S2))/2 << endl << flush;
        );
    ));
);
doPair(Psig * PB, "sigma(P)");
doPair(Psig^2 * PB, "sigma^2(P)=sigma^-1(P)");
-- extra: what is P ∩ Sing(Y)?
eqP = transpose gens ker transpose PB;   -- 4 x 9 : linear equations of P
IPlin = ideal flatten entries (sub(eqP, R) * transpose vars R);
IPA = saturate(J + IPlin);
<< "extra: P ∩ Sing(Y): affine dim " << dim IPA << ", degree " << degree IPA << ", Hilbert polynomial " << hilbertPolynomial(R/IPA, Projective => false) << endl;
<< "extra: v_+ itself: partials vanish there (v_+ in Sing Y)? " << ((map(kk, R, flatten entries vplus)) gens J == 0) << endl;
