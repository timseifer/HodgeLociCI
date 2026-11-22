# API index

One line per exported name of the Macaulay2 package `HodgeLociCI` (version 0.1.0). Full documentation with examples:
`help <name>` after `installPackage`, or the `doc ///` blocks in `M2/HodgeLociCI/*Doc.m2`.

Result tables are HashTables with string keys and always include `"label"` (EXACT / MOD p / PROVED in an AI-written,
unreviewed note / COMPUTED ONLY). AI-generated; not reviewed by a human.

## First-order tools (excess calculator and utilities)

| Name | Signature | What it does |
| --- | --- | --- |
| `hodgeLevel` | `hodgeLevel(n,d) -> ZZ (or -infinity)` | Hodge level of the middle cohomology of a smooth degree-d hypersurface of dimension n |
| `primitiveHodgeNumbers` | `primitiveHodgeNumbers(n,d) -> List` | primitive Hodge numbers h^(n,0),...,h^(0,n) of such a hypersurface |
| `ciHilbertFunction` | `ciHilbertFunction(degs,nvars,m) -> ZZ` | Hilbert function in degree m of a complete intersection of the given degrees in nvars variables |
| `excessFromDegrees` | `excessFromDegrees(d,degF,degH,degP) -> HashTable (string keys)` | item 1 by degrees: tau, level dichotomy, lambda0, range, e_tau, codims, excess (paper 3, Thm 2) |
| `linearSubspaceCase` | `linearSubspaceCase(d,k,c) -> HashTable` | the case list of paper 3, Thm 9.7 (thm:lin) for two k-planes meeting in dimension k-c |
| `CyclePair` | `Type of HashTable` | validated data (f,h,p,M,s) with F = f^T M h + sum p_l s_l |
| `cyclePair` | `cyclePair(f,h,p,M,s, CheckSmooth=>true) -> CyclePair` | constructor with input validation (f,h,p,s lists of forms, M a c x c matrix) |
| `randomCyclePair` | `randomCyclePair(d,degF,degH,degP, CoefficientRing=>ZZ/32003, Seed=>null, Height=>3, CheckSmooth=>true) -> CyclePair` | random data of given degrees over ZZ/p or QQ |
| `excessFromData` | `excessFromData(CyclePair) -> HashTable` | item 1 by data: e_tau, rank of .det M : A_tau -> A_d, dim (0:_A det M)_tau, codims, predicted excess |
| `tangentExcess` | `tangentExcess(CyclePair,lambda) -> HashTable` | direct first-order computation of dim T NL(delta_lambda)/T V_Z in the Jacobian ring (independent of Thm 2) |
| `verifyExcess` | `verifyExcess(CyclePair) / verifyExcess(CyclePair,List) -> HashTable` | compares Theorem 2 with tangentExcess at lambda_0 and other coefficients |
| `periodPolynomial` | `periodPolynomial(phi,psi) -> RingElement` | det Jac(phi_0,psi_0,...,phi_k,psi_k) modulo the Jacobian ideal of F = sum phi_i psi_i |
| `hodgeLocusTangentCodim` | `hodgeLocusTangentCodim(F,I) -> HashTable` | codim of ((I+Jac F):m^e)_d in S_d, e = kd-2k-2; general first-order utility |
| `grothendieckResidue` | `grothendieckResidue(P,G) -> field element` | Res[P/G] for a regular sequence G of (number of variables) forms, Res[det Jac G/G] = prod deg |
| `residueFunctional` | `residueFunctional(G) -> Function` | P -> Res[P/G], with the Groebner basis computed once |
| `isSmoothHypersurface` | `isSmoothHypersurface(F) -> Boolean` | smoothness of {F=0} (over QQ: certified by reduction mod p where possible) |
| `reduceModPrime` | `reduceModPrime(CyclePair,p, CheckSmooth=>true) -> CyclePair` | reduction modulo a prime of data over QQ (explicit fallback from EXACT to MOD p) |

## Second-order checker

| Name | Signature | What it does |
| --- | --- | --- |
| `secondOrderQuadrics` | `secondOrderQuadrics(CyclePair) -> HashTable` | item 2: the lambda-independent quadrics on the excess directions E' (paper 3, Thm 9.1(3), 9.4(2), Prop 9.4') |
| `secondOrderObstruction` | `secondOrderObstruction(CyclePair,lambda, Strategy=>"Formula"\|"Pointwise"\|"Both") -> HashTable` | item 2: cliff detector, verdict + label EXACT / MOD p |
| `secondOrderFunctional` | `secondOrderFunctional(phi,psi) -> Function` | P -> sum_nu Res[P/(phi,psi with the nu-th pair squared)] = (k+1) phi_[Y](P)/kappa (paper 3, Lemma 2.1(3)) |

## Fermat higher-order expansion

| Name | Signature | What it does |
| --- | --- | --- |
| `fermatRing` | `fermatRing(d,n) / fermatRing(d,n,p), Parameters=>{} -> PolynomialRing` | K[x_0..x_(n+1)] for the Fermat variety of degree d, even dimension n; K = QQ(zeta_2d) (EXACT) or ZZ/p with p = 1 mod 2d (MOD p) |
| `fermatRoot` | `fermatRoot(S) -> ring element` | the fixed primitive 2d-th root of unity z of a fermatRing |
| `fermatLinearSpaceIdeal` | `fermatLinearSpaceIdeal(S,L) -> Ideal` | L = {{a,b,e},...} means x_a = z^e x_b (e odd, pairs a perfect matching) |
| `fermatPeriodPolynomial` | `fermatPeriodPolynomial(S,L) -> RingElement` | period polynomial of a linear space in the Fermat variety (= det Jac, Villaflor normalisation; README export_c3 rule (1) for d = 3) |
| `fermatPeriod` | `fermatPeriod(P,f) -> element` | closed form Psi_P(f) of the period functional on polynomials (Pochhammer weights x pairing with P) |
| `fermatPeriodGD` | `fermatPeriodGD(P,m,k) -> element` | literal Griffiths-Dwork (pole-order) reduction of m Omega / F0^k, monomial by monomial (reference implementation) |
| `fermatPeriodForms` | `fermatPeriodForms(S), AllMonomials=>false -> List` | numerators Q of the forms defining the Hodge locus |
| `fermatDeformationMonomials` | `fermatDeformationMonomials(S), AllMonomials=>false -> List` | monomials of degree d spanning the deformations F0 - T |
| `fermatExpansion` | `fermatExpansion(P,Ts,N), Forms=>null -> Matrix` | Taylor coefficients c_1..c_N of the Hodge-locus equations along F0 - (eps T_1 + eps^2 T_2 + ...) |
| `fermatFirstOrderMatrix` | `fermatFirstOrderMatrix(P), Forms=>, Monomials=> -> Matrix` | the first-order map L at the Fermat point |
| `fermatHodgeTangent` | `fermatHodgeTangent(P) -> Matrix` | basis (one row of forms of degree d) of the tangent space of the Hodge locus at Fermat |
| `fermatPersistenceTangent` | `fermatPersistenceTangent(S,{L1,L2,...}) -> Matrix` | basis of the intersection of the (I(L_i) + Jac F0)_d: first-order deformations in which all the spaces persist |
| `fermatTangentData` | `fermatTangentData(S,{L1,..},{c1,..}) -> HashTable` | codimensions at Fermat: Hodge locus of sum c_i [L_i], each V_(L_i), their intersection; for cross-checks with item 1 |
| `fermatNextOrderSystem` | `fermatNextOrderSystem(P,Ts), Forms=>, Monomials=> -> HashTable` | order N = #Ts+1: matrix L, right-hand side, cokernel K, obstruction K.c_N, solvable?, a solution T_N |
| `fermatExtendArc` | `fermatExtendArc(P,Ts,N), Monomials=> -> HashTable` | extends an arc order by order until order N or the first obstruction |
| `fermatVerifyArc` | `fermatVerifyArc(P,Ts) / (P,Ts,N) -> HashTable` | pass / fail and the first failing order |
| `fermatReadCertificate` | `fermatReadCertificate(file), Prime=>0 -> HashTable` | parser of the session's arc / obstruction certificate text files |
| `fermatWriteCertificate` | `fermatWriteCertificate(file,HashTable)` | writes an arc / certificate in the same text format (read by the M2 and the optional Python backend) |
| `fermatVerifyCertificate` | `fermatVerifyCertificate(file or HashTable), Prime=>0 -> HashTable` | re-verifies every checkable claim of a certificate; pass / fail, first failing order |

## Options and symbols

| Name | Signature | What it does |
| --- | --- | --- |
| `NotDetermined` | `Symbol` | value returned where a number is not determined by the input (no silent fallback) |
| `Seed` | `option name` | random seed option (PB, PC may reuse the symbol) |
| `CheckSmooth` | `option name` | whether constructors test smoothness of X |
| `Parameters` | `option name` | extra polynomial parameters (degree 0) in a fermatRing |
| `Forms` | `option name` | list of numerator monomials Q |
| `AllMonomials` | `option name` | use all monomials instead of the Jacobian-ring monomial basis |
| `Prime` | `option name` | a prime p = 1 mod 2d: compute MOD p instead of exactly |
