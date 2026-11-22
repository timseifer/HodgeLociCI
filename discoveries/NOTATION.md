# Notation used in the discoveries registry

Written by an AI agent (22 November 2026); not reviewed by a human. Consistent with `README.md` (sections
"What it does", "Terminology") and `docs/API.md` of this repository. Nothing here is, or bears on, a proof or
disproof of the Hodge conjecture.

Plain-text conventions: `x^2` is a power, `x_i` an index, `P^7` projective space, `binomial(a,b)` a binomial
coefficient, `(x)` a tensor product, `n` between two sets an intersection, `u` a union, `!=` "not equal".

## 1. The general setting (two complete-intersection cycles)

| symbol | meaning |
|---|---|
| `X`, `F`, `d`, `k`, `n` | `X = {F = 0}` is a smooth hypersurface of degree `d` in `P^(2k+1)`; its dimension is `n = 2k`. |
| `S`, `S_j`, `m` | The polynomial ring in `2k+2` variables, its part of degree `j`, its maximal homogeneous ideal. |
| `Y_1`, `Y_2` | Two complete intersections of dimension `k` inside `X`: `Y_1 = V(f, p)`, `Y_2 = V(h, p)`. For linear subspaces also written `Pi_1`, `Pi_2` or `P1`, `P2`. |
| `f`, `h`, `p` | `f = (f_0..f_(c-1))`: the equations of `Y_1` alone; `h`: those of `Y_2` alone; `p`: the `k+1-c` shared equations. All of degree between 1 and `d-1`. |
| `c` | The number of own equations of each cycle. `Y_1 n Y_2` has dimension `k - c`. For two `k`-planes meeting in `P^m`: `c = k - m`. |
| `M`, `s` | A `c x c` matrix of forms and forms `s_l` with `F = f^T M h + sum_l p_l s_l`. |
| `tau` | The level: `tau = sum_(i<c) (deg f_i + deg h_i) - (c-1) d = d - deg det M`. For two `k`-planes: `tau = 2c - (c-1)d`. (Not the Hodge level of `X`.) |
| `lambda`, `delta_lambda` | A nonzero coefficient, and the class `delta_lambda = [Y_1] + lambda [Y_2]`. For integer coefficients `(r, r')`: `lambda = r'/r`. |
| `lambda_0` | The special coefficient `(-1)^(c-1)`. |
| `NL(delta)` | The Hodge locus of a class `delta`: the germ at `X`, in the space of hypersurfaces of degree `d`, of the analytic space where the flat transport of `delta` stays a Hodge class. It can be non-reduced. |
| `V_1`, `V_2`, `V_Z` (also `V`) | `V_i = NL([Y_i])`; `V_Z = V_1 n V_2`, the locus of hypersurfaces in which both cycles persist. In the Fermat entries `V_Z` is written `V`. |
| `T` (tangent space) | `T NL`, `T V_Z`: Zariski tangent spaces at `X`, subspaces of `S_d`. `dim T NL` can exceed the dimension of the locus. |
| excess | `dim T NL(delta_lambda) - dim T V_Z`: the number of tangent directions of the Hodge locus beyond those of `V_Z`. "Excess directions": tangent directions of `NL(delta_lambda)` not tangent to `V_Z`. |
| `A`, `e_tau` | `A = S/(f, h, p, s)` (an Artinian complete intersection); `e_tau = dim A_tau`, zero if `tau < 0`. Also written `E = A_tau`. |
| the range | The inequality `(k-1)d + tau < 2k + 2`. In the range the excess is `e_tau` for every nonzero `lambda` (unreviewed note 3, Theorem 2(2)). |
| `E'` | `E' = (0 :_A det M)_tau = ker(det M : A_tau -> A_d)`: the excess directions for `lambda` not in `{0, lambda_0}`. In the range `E' = E`. |
| `(S)` | The condition that `det M : A_tau -> A_d` is surjective. |
| `K`, `K_lambda` | `K`: the forms `Q` of degree `kd - 2k - 2` whose period function has zero differential at `X` for both cycles ("dependent equations"); `K_lambda`: the same for the class `delta_lambda`. `K = 0` means there is nothing to obstruct. |
| `r` | `r = d - (kd - 2k - 2)`. The range is `r > tau`. |
| `A(Q)`, `Q_0` | The second-order coefficient: a linear form on `K` (one excess direction), or a symmetric bilinear map `E' x E' -> K^*` (several). |
| `kappa` | The constant in the period formula of a complete intersection (first-order period = `kappa` times a residue symbol). |
| `Res_S[P/(g)]` | Grothendieck residue symbol of a regular sequence `g` of `2k+2` forms, normalised by `Res[det Jac(g)/(g)] = product of the degrees`. |
| `J`, `R`, `R_j` | The Jacobian ideal of `F`; the Jacobian ring `R = S/J`; its part of degree `j`. |
| `h^(p,q)` | Hodge numbers of `X`. For cubic sixfolds `h^(4,2) = 8`; for cubic eightfolds `h^(5,3) = 45`; for quartic sixfolds `h^(5,1) = 1`. |
| verdicts | Outputs of `secondOrderObstruction`: `ALL DIE`, `SOME DIE`, `ALL SURVIVE`, `NO EXCESS`. |

Letters with several uses (always clear from the entry):
`h` is the list of equations of `Y_2`, or the hyperplane class on a sixfold (`h^3`), or the excess coordinate in
leading forms such as `h^2 * psi(w)`. `T` is a tangent space, or the degree-9 threefold of section 3, or (fake
linear cycles) the kernel of the Hessian at the Fermat point. `tau` is the level, or (strata of `Sigma_4`) the
normal coordinates of a stratum inside `Sigma_4`, or once the class `[T4] - 3 eta^4`. `K` is the space of forms
above, or a left-kernel vector in a certificate. `N` is a form of degree `tau`, or a `3 x 3` matrix, or the closure
of the two-determinant family. `w` is a vector of `T V`, or the linear form `x0 - c x1`, or the polynomial
`w(t1,t2,n1,n2)` of section 4. `D` is explained in section 2.

## 2. Cubics with two linear subspaces; Fermat points

| symbol | meaning |
|---|---|
| the Fermat point | The Fermat hypersurface `x_0^d + ... + x_(2k+1)^d = 0`, as a point of the space of hypersurfaces. `F_0` is its equation. |
| `z`, `zeta_m` | `z` is the fixed primitive `2d`-th root of unity of a Fermat computation: `zeta_6` for cubics, `zeta_8` for quartics. |
| pairing | A perfect matching of the coordinates, for example `(01)(23)(45)(67)`. A linear subspace of the standard type is given by equations `x_a = z^e x_b` (`e` odd) on the pairs of a pairing. In package calls it is a list of triples `{a, b, e}`. |
| Movasati point | The Fermat cubic of dimension 6 or 8 together with Movasati's pair of planes: both planes use the SAME pairing, and their roots of unity differ on exactly three pairs. `n = 6`: `P1 = {x0 = z x1, x2 = z x3, x4 = z x5, x6 = z x7}`, `P2 = {x0 = -x1, x2 = -x3, x4 = -x5, x6 = z x7}` (they meet in a point). `n = 8` (as in the certificate files): `P1 = {x0 = z x1, ..., x8 = z x9}`, `P2 = {x0 = z x1, x2 = z x3, x4 = -x5, x6 = -x7, x8 = -x9}` (they meet in a line). There `C = 0`. |
| `X1` | The pair on the Fermat cubic eightfold `P1 = {x0 = z x1, x2 = z x3, x4 = z x5, x6 = z x7, x8 = z x9}`, `P2 = {x1 = -x2, x3 = -x4, x0 = -x5, x6 = z x7, x8 = -x9}` (meeting in a line; incidence type `[6T 2T 2F]`). |
| incidence type | For two planes from two pairings: the cycle lengths of the union of the pairings, each marked `T` (the planes share a point supported on the cycle) or `F`. |
| `C` | Sixfolds, planes meeting in a point `q`: the `3 x 3` matrix of the quadratic part of `X n T_q X` at `q`. Eightfolds, planes meeting in a line: a `3 x 3` matrix `C(y)` of linear forms on the line. |
| `D` | Sixfolds: the divisor `{det C = 0}` of `V_Z` (codimension 9 in the space of cubics). Eightfolds: the invariant whose vanishing locus `Z_D` in `V` has one component of codimension 7. (At pencil-type points of `Sigma_4`, `D` is the degree-24 hypersurface `{det Q_(tau tau) = 0}`; `D_a` is a divisor class or the conic divisor; these are named in the entries.) |
| `M_lambda` (germ) | A smooth germ of dimension `dim V_Z + excess` containing `NL(delta_lambda)`; `y` is a local equation of `V_Z` in it. |
| `W_lambda` | The second component of `NL([P1] + lambda [P2])` on cubic sixfolds where `det C = 0`: `NL = {y^2 u' = 0}`, `W_lambda = {u' = 0}`, of codimension 8, meeting `V_Z` along `D`. `W_(-1)` is the case `lambda = -1`. |
| `W'` | At `X1`: the smooth germ of dimension `dim V - 6` cut out by the order-3 linear leading forms; `u` is the matrix of these forms, `ker u` its tangent space. |
| `L`, `L_P1`, `L_P2` | First-order maps at a Fermat point: `L` for the class, `L_Pi` for one plane. `ker L` is the tangent space of the Hodge locus, `ker L_P1 n ker L_P2` that of `V`. |
| arc, `eps`, `T_j`, `c_N` | An arc `F_eps = F_0 - (eps T_1 + eps^2 T_2 + ...)` through the Fermat point; `c_N` is the vector of `eps^N`-coefficients of the period functions along it. |
| `Cat(a,b)` | Catalecticant of a class: the matrix (monomials of degree `a`) x (monomials of degree `b`) of periods of the products. Its rank is `dim (R/Ann)_a`. |
| `h`, `eta` | The hyperplane class on a sixfold (`h^3` is the class of a linear section of dimension 3), resp. on an eightfold (`eta^4`). |
| `C_d` | Hassett's divisor of special cubic fourfolds of discriminant `d`. |

## 3. Explicit cycles on cubics

| symbol | meaning |
|---|---|
| `A`, `B` (matrices) | Two `3 x 3` matrices of linear forms (also `N_A`, `N_B`). `I_2(A)` is the ideal of their `2 x 2` minors. |
| `det A + det B` | The family of cubic sixfolds that are sums of two `3 x 3` determinants (codimension 8); `N` is its closure. |
| `T`, `T'` | `T = {rows 1, 2 of A proportional} n {rows 1, 2 of B proportional}`: a threefold of degree 9 on `det A + det B`. `T'` (or `T_rows,cols`): the same with columns of `B`. `g = [T] - 3h^3`. |
| `V_6` | The flag threefold `P(T_P2)` = rank-one traceless `3 x 3` matrices in `P^7`, of degree 6. |
| `T5` | The quintic del Pezzo threefold `{l = 0} n {4 x 4 Pfaffians of a 5 x 5 block}` on a cubic `l*Q + Pf(M)`. |
| `TD`, `SS`, `T4` | `TD`: the family of cubic eightfolds `l*Q + det A + det B` (codimension 26); `SS` its closure; `T4` (also `T'` in check C15) the fourfold `{l = 0} n {rows 1, 2 of A proportional} n {rows 1, 2 of B proportional}` of degree 9. |
| `Sigma` | A Segre fourfold `P^2 x P^2` in a hyperplane of `P^9` (degree 6). |
| `Q(eps)`, `I_A`, `I_B`, `G_A`, `G_B`, `l` | Along the arc into `D`: the 18 quadrics annihilating the class, the two nets they split into, the two determinantal cubics with `F_eps = G_A + G_B`, and the tangent hyperplane `l` at `P1 n P2`. |

## 4. Fake linear cycles on quartic sixfolds

| symbol | meaning |
|---|---|
| `P_m`, `pt_m` | On the Fermat quartic sixfold: `P_m = {x0 = z^(2m-1) x1, x2 = z x3, x4 = z x5, x6 = z x7}`, `m = 1..4`, the four `P^3` of one `P^4`-section; `pt_m = [z^(2m-1) : 1]`. |
| `delta` | The fake linear cycle `3[P1] + [P2] - 3[P4]`; `a = (3, 1, 0, -3)` its weights; `c_1 = z(3 - 4i)/5` its constant. |
| `Sigma_4` | The locus of quartic sixfolds having a `P^4`-section that splits into four hyperplanes (four `P^3`); codimension 38. For a random point: `F = l_1 l_2 l_3 l_4 + x5 h_2 + x6 h_3 + x7 h_4`. |
| strata of `Sigma_4` | Triple: three of the four hyperplanes through a common plane (corank 6). Pencil type: all four through a common plane (corank 12). Split pencil-type: `F = f(x3,x4) + x5 h_0 + x6 h_1 + x7 h_2` with the cubics free of `x3, x4`. |
| `E0`, `E1(j)`, `E2(j,j')` | The explained loci through the Fermat point: pencil-type points inside `Sigma_4`; cones with vertex a line over quartic surfaces carrying a divisor class; cones with vertex a point over quartic fourfolds. |
| `Phi`, `W(G)` | `Phi`: the period functional at the Fermat point in closed form; `W(G) = Phi(exp(-G))`: the function whose critical locus is the Hodge locus. `Phi8`, `Phi12`: first- and second-order functionals at a general point (degrees 8 and 12). |
| `T`, `K_Sigma` | `T`: the kernel of the Hessian of `W` at the Fermat point (dimension 311); `K_Sigma`: the radical of the cubic form on `T` (dimension 285), inside `T Sigma_4`. |
| `w`, `y_j`, `z_j` | `w = x0 - c_1 x1`; `y_j = x_(2j-2) - z x_(2j-1)`; `z_j` the remaining coordinate of the `j`-th pair modulo `y_j`. |
| `nu_t`, `q` | The candidate direction `nu_t = w x7 (x3^2 + t x3 x5 - (t^2/2) x5^2)` and the certificate form `q = x0 x6 (x2 - z x3)^2`. |
| `tau`, `nu` (strata) | Coordinates normal to a stratum inside `Sigma_4` (`tau`) and on the kernel of the normal Hessian (`nu`). |
| `w(t1,t2,n1,n2)`, `R_h`, `Res_h` | The polynomial of the pencil-type reduction (weights 1, 1, 2, 2; degree 6); `R_h = C[v0,v1,v2]/(three cubics)` and its socle functional. |

## 5. People, checks and documents named in the entries

| name | meaning |
|---|---|
| unreviewed note 1, 2, 3 | Three AI-written manuscripts of the project ("papers 1 to 3"; note 3 in version 21). Not public, not in this repository, not reviewed by a human. Theorem numbers refer to them and cannot be looked up elsewhere. |
| night run | The first phase of the project (21 to 22 November 2026): the three notes, AI referees numbered 1 to 25, a "blind agent", checks T1 to T11. |
| discovery round | The second phase (22 November 2026): teams T1 (fake linear cycles), T2 (explicit cycles), T3 (germ at Fermat points) and blind checks C1 to C21. |
| C-number | One of the independent checks C1 to C21: an AI agent that saw only the exported data or the statement and wrote its own code. |
| session files | The ledgers and scripts of the project (`LEDGER.md`, `LEDGER_DISCOVERY.md`, folders `night/`, `discovery/`). Not public. The field `session_refs` points into them. |
