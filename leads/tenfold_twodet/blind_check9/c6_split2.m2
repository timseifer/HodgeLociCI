-- split non-Fermat member F = F1(x0..x5) + F2(x6..x11), F_i = l_i Q_i + det(A_i), A_i = [[a,b,0],[0,c,d],[e,0,f]]
-- Then the Jacobian matrix of each of the 9 planes is block diagonal, a_T = +-alpha*beta, R = R1 (x) R2.  MOD p.
p = 32003; setRandomSeed 77; kk = ZZ/p;
half = vars0 -> (
    S1 := kk[vars0];
    r := () -> random(1,S1);
    (a,b,c,d,e,f) := (r(),r(),r(),r(),r(),r());
    l := r(); Q := random(2,S1);
    A := matrix{{a,b,0},{0,c,d},{e,0,f}};
    F1 := l*Q + det A;
    I1 := ideal(l,Q) + minors(2,A);
    J1 := ideal jacobian ideal F1;
    comps := {((a,b),(c*f,d*e)), ((a,d),(c*f,b*e)), ((c,d),(a*f,b*e))};
    al := sum apply(comps, u -> (fs := {l,u#0#0,u#0#1}; gs := {Q,u#1#0,u#1#1}; assert(sum(3,t->fs#t*gs#t) == F1); det jacobian matrix{fs|gs}));
    IT1 := ideal(l) + minors(2, A^{0,1});
    << "  smooth: " << (dim J1 == 0) << "; HF(S1/I1) = " << toString apply(5, i -> hilbertFunction(i, S1/I1))
       << "; J1 in I1: " << isSubset(J1,I1) << "; alpha in J1: " << (al % J1 == 0)
       << "; (J1:alpha) == I1: " << ((J1 : ideal al) == I1)
       << "; {l=0, rows 1,2 prop.} = 3 planes, deg " << degree IT1 << ", dim " << dim IT1 << endl << flush;
    R1 := S1/J1; aq := sub(al, R1);
    rks := apply(4, i -> rank (coefficients(aq * basis(i,R1), Monomials => basis(i+3,R1)))#1);
    << "  ranks of alpha: R1_i -> R1_{i+3}, i=0..3: " << toString rks << endl << flush;
    rks);
rA = half(toList(x_0..x_5));
rB = half(toList(x_6..x_11));
<< "rank of a_T = alpha*beta on (R1 (x) R2)_3 -> (R1 (x) R2)_9 : " << sum(4, i -> rA#i * rB#(3-i)) << "  (claimed codimension 52)" << endl;
