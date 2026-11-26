-- C1 part 2: singular loci, over F_p (all of lam, x, hyperplane are in F_p)
cert = value get "/home/claude/hodgelocici/leads/tenfold_coble/pairing/arcdata/certificate_32003_seed1.txt";
pr = cert#"p"; kk = ZZ/pr;
say = s -> (stdio << s << endl << flush;);
lam = cert#"lam"; xs = cert#"x";
S9 = kk[z_0..z_2, w_0..w_2, q_0..q_2];
h = (v) -> v#0^3 + v#1^3 + v#2^3 + 3*lam*v#0*v#1*v#2;
a = -(h(xs)) * (1/(27*(1+lam^3)))_kk;
coble = (z,pp,q) -> a*h(z) + h(pp) + h(q) + sum(3, i -> sum(3, j -> xs#((i-j)%3) * z#((i+j)%3) * pp#i * q#j));
F = coble({z_0,z_1,z_2},{w_0,w_1,w_2},{q_0,q_1,q_2});
J9 = ideal jacobian ideal F;
say("Coble: dim Sing (affine) = " | toString dim J9 | "  degree = " | toString degree J9 | "  HP = " | toString hilbertPolynomial(J9, Projective => false));
R = kk[u_0..u_7];
hyp = apply(cert#"hyperplane", value);
Hm = (coefficients(matrix{hyp}, Monomials => vars R))#1;
say("rank of the 9 hyperplane forms: " | toString rank Hm);
G = coble(hyp_{0,1,2}, hyp_{3,4,5}, hyp_{6,7,8});
JG = ideal jacobian ideal G;
say("G: dim Sing (affine) = " | toString dim JG | "  degree = " | toString degree JG | "  HP = " | toString hilbertPolynomial(JG, Projective => false));
say("G: Hilbert function of R/JG in degrees 0..6: " | toString apply(7, d -> hilbertFunction(d, R/JG)));
phi = map(R, S9, hyp);
IC0 = phi J9;
say("Sing(Coble) restricted to H: dim = " | toString dim IC0 | " degree = " | toString degree IC0 | "  HP = " | toString hilbertPolynomial(IC0, Projective => false));
say("JG contained in restricted ideal: " | toString isSubset(JG, IC0) | "   converse: " | toString isSubset(IC0, JG));
t0 = cpuTime();
-- saturation with respect to one general linear form (enough for a 1-dimensional scheme with no component in the hyperplane)
ell = sum(8, i -> random(kk)*R_i);
IC = saturate(JG, ell);
say("saturation time " | toString(cpuTime()-t0));
say("saturated: HP = " | toString hilbertPolynomial(IC, Projective => false) | "  generator degrees: " | toString(tally flatten degrees source gens IC));
say("number of quadrics in saturated ideal = " | toString(numcols basis(2, IC)) | "   cubics = " | toString(numcols basis(3, IC)));
say("JG == its saturation : " | toString(JG == IC));
say("Hilbert function of R/IC degrees 0..6: " | toString apply(7, d -> hilbertFunction(d, R/IC)));
"IC_cert.txt" << toString flatten entries gens IC << endl << close;
-- smoothness of C via a few random 6x6 minors of the jacobian of the quadrics of IC
Q9 = super basis(2, IC);
Jq = jacobian Q9;   -- 8 x 9
setRandomSeed 7;
mins = apply(40, i -> (rr = take(random toList(0..7), 6); cc = take(random toList(0..numcols Jq - 1), 6); det submatrix(Jq, rr, cc)));
t0 = cpuTime();
sing = IC + ideal mins;
say("dim of (IC + 40 random 6x6 minors) (0 = empty set projectively => C smooth): " | toString dim sing | "  time " | toString(cpuTime()-t0));
say("G irreducible: " | toString(#(toList factor G) == 1));
