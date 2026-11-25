-- S1 extras: smoothness, equidimensionality, primality attempts.  args: prime seed mode
pr = value(scriptCommandLine#1);
seed = value(scriptCommandLine#2);
mode = scriptCommandLine#3;
setRandomSeed(seed);
load "/home/claude/blind_check/common.m2";
(lam, xv) = drawParams();
<< "prime " << pr << " seed " << seed << " lam " << lam << " x " << xv << " mode " << mode << endl << flush;
as = asharp(lam, xv);
F = Fof(as, lam, xv);
J = ideal jacobian ideal F;
Js = saturate J;
<< "Jsat: proj dim " << dim Js - 1 << " degree " << degree Js << endl << flush;

if mode == "smooth" then (
    -- Jacobian of the 9 quadrics = Hessian of F (9x9, linear entries).  J and Jsat agree away from the origin,
    -- so at a point of X the Jacobian rank of J's generators equals that of Jsat's generators.
    H = jacobian J;   -- 9 x 9
    -- sanity: generic rank of H restricted to X should be 6 (codim of X)
    S := R/Js;
    HS := sub(H, S);
    << "rank of Hessian over function field of X (generic rank on X): " << rank HS << endl << flush;
    -- random 6x6 determinants det(c*H*d): common zeros on X = locus where rank H <= 5 (with high prob. using several)
    nd := 4;
    dets := apply(nd, k -> det(random(kk^6, kk^9) * H * random(kk^9, kk^6)));
    << "degrees of random dets: " << toString apply(dets, d -> first degree d) << endl << flush;
    scan(1..nd, k -> (
        Ik := Js + ideal take(dets, k);
        << "  X cap V(first " << k << " random 6x6 dets of Hessian): affine dim " << dim Ik << (if dim Ik <= 0 then "  (EMPTY projectively)" else ("  degree " | toString degree Ik)) << endl << flush;
        ));
    -- also: is rank >= 7 anywhere on X?  (cannot be on a 2-diml reduced X; nonzero 7x7 minors would indicate lower-diml pieces)
    d7 := apply(3, k -> det(random(kk^7, kk^9) * H * random(kk^9, kk^7)));
    << "random 7x7 dets of Hessian vanish identically on X ? " << toString apply(d7, d -> (d % Js) == 0) << endl << flush;
    );

if mode == "res" then (
    t0 = cpuTime();
    C = res Js;
    << "resolution time " << cpuTime() - t0 << endl << flush;
    << "betti: " << endl << betti C << endl << flush;
    << "projective dimension of R/Jsat: " << length C << "  (depth = " << 9 - length C << ")" << endl << flush;
    -- unmixedness test: codim Ext^i(R/Js, R) >= i+1 for all i > codim = 6
    scan(7..length C, i -> (
        E := Ext^i(comodule Js, R);
        << "  Ext^" << i << ": " << (if E == 0 then "zero" else ("codim " | toString codim E)) << endl << flush;
        ));
    X = Proj(R/Js);
    << "h^0(O_X) = " << rank HH^0(OO_X) << endl << flush;
    << "h^1(O_X) = " << rank HH^1(OO_X) << endl << flush;
    << "h^2(O_X) = " << rank HH^2(OO_X) << endl << flush;
    );

if mode == "prime" then (
    t0 = cpuTime();
    << "isPrime Jsat: " << isPrime Js << "   time " << cpuTime() - t0 << endl << flush;
    );

if mode == "radical" then (
    t0 = cpuTime();
    rJ = radical Js;
    << "radical Jsat == Jsat: " << (rJ == Js) << "   time " << cpuTime() - t0 << endl << flush;
    );

if mode == "plane" then (
    -- S2 control a=0: is the radical of the singular ideal the plane p=q=0 ?
    J0 = ideal jacobian ideal Fof(0_kk, lam, xv);
    J0s = saturate J0;
    Lpq = ideal(p_0,p_1,p_2,q_0,q_1,q_2);
    << "a=0: Jsat contained in (p,q): " << isSubset(J0s, Lpq) << endl << flush;
    -- (p,q)^N contained in Jsat for some N  <=> radical is (p,q)
    scan(1..8, N -> (
        << "   (p,q)^" << N << " subset Jsat ? " << isSubset(Lpq^N, J0s) << endl << flush;
        ));
    << "a=0: top-dimensional part: degree " << degree J0s << ", HP " << toString hilbertPolynomial(J0s, Projective=>false) << endl << flush;
    -- where is the embedded structure?  (J0s : (p,q)^infty) and  (p,q) : J0s etc
    emb = J0s : Lpq;
    << "a=0: Jsat : (p,q)  has gens degrees " << toString tally flatten degrees source mingens emb << " dim " << dim emb << endl << flush;
    ann1 = Lpq : J0s;
    << "a=0: plane residual check, (p,q):Jsat == (p,q): " << (ann1 == Lpq) << endl << flush;
    -- associated primes (cheap?)
    t0 = cpuTime();
    ap = associatedPrimes J0s;
    << "a=0: associated primes of Jsat (" << #ap << "), time " << cpuTime()-t0 << ":" << endl;
    scan(ap, P -> << "    dim(proj) " << dim P - 1 << " degree " << degree P << "  " << toString P << endl << flush);
    );

if mode == "smooth3" then (
    H = jacobian J;
    dets = apply(3, k -> det(random(kk^6, kk^9) * H * random(kk^9, kk^6)));
    t0 = cpuTime();
    I3 = Js + ideal dets;
    d3 = dim I3;
    << "X cap V(3 random 6x6 dets of the Hessian): affine dim " << d3 << (if d3 <= 0 then "  (EMPTY projectively => X smooth)" else ("  degree " | toString degree I3)) << "   time " << cpuTime()-t0 << endl << flush;
    );

if mode == "plane2" then (
    J0 = ideal jacobian ideal Fof(0_kk, lam, xv);
    J0s = saturate J0;
    Lpq = ideal(p_0,p_1,p_2,q_0,q_1,q_2);
    << "a=0: Jsat subset (p,q): " << isSubset(J0s, Lpq) << " ; (p,q)^2 subset Jsat: " << isSubset(Lpq^2, J0s) << " ; (p,q)^3 subset Jsat: " << isSubset(Lpq^3, J0s) << " ; J0 itself: (p,q)^3 subset J0: " << isSubset(Lpq^3, J0) << " dim " << dim J0 - 1 << " degree " << degree J0 << endl << flush;
    );
