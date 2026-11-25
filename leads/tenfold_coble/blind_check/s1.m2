-- S1 / S2 : singular loci.  args: prime seed
pr = value(scriptCommandLine#1);
seed = value(scriptCommandLine#2);
setRandomSeed(seed);
load "/home/claude/blind_check/common.m2";
(lam, xv) = drawParams();
<< "prime " << pr << " seed " << seed << " lam " << lam << " x " << xv << endl << flush;
as = asharp(lam, xv);
<< "a# = " << as << "  h(x) = " << hcub(xv,lam) << endl << flush;

-- S1
F = Fof(as, lam, xv);
J = ideal jacobian ideal F;
<< "S1: J numgens " << numgens J << " dim(affine) " << dim J << " degree " << degree J << endl << flush;
t0 = cpuTime();
Js = saturate J;
<< "S1: saturation time " << cpuTime()-t0 << endl << flush;
<< "S1: Jsat projective dim " << (dim Js - 1) << " degree " << degree Js << endl << flush;
HP = hilbertPolynomial(Js, Projective => false);
<< "S1: Hilbert polynomial of R/Jsat: " << toString HP << endl << flush;
<< "S1: Hilbert function of R/Jsat degrees 0..6: " << toString apply(7, d -> hilbertFunction(d, Js)) << endl << flush;
<< "S1: Hilbert function of R/J    degrees 0..8: " << toString apply(9, d -> hilbertFunction(d, J)) << endl << flush;
gd = flatten degrees source mingens Js;
<< "S1: degrees of minimal generators of Jsat: " << toString tally gd << endl << flush;
<< "S1: number of quadrics in Jsat: " << (45 - hilbertFunction(2, Js)) << endl << flush;
<< "S1: J == Jsat ? " << (J == Js) << "  ; ideal of quadrics of Jsat == J ? " << (ideal select(flatten entries mingens Js, g -> first degree g == 2) == J) << endl << flush;
"/home/claude/blind_check/Jsat_" | toString pr | "_" | toString seed | ".txt" << toString Js << endl << close;

-- S2 controls
F2 = Fof(2*as, lam, xv);
J2 = ideal jacobian ideal F2;
<< "S2: a=2a#: dim(affine) of Jacobian ideal = " << dim J2 << " (0 means smooth hypersurface); HF 0..10: " << toString apply(11, d -> hilbertFunction(d, J2)) << endl << flush;
F0 = Fof(0_kk, lam, xv);
J0 = ideal jacobian ideal F0;
J0s = saturate J0;
<< "S2: a=0: Jsat projective dim " << (dim J0s - 1) << " degree " << degree J0s << " gens degrees " << toString tally flatten degrees source mingens J0s << endl << flush;
<< "S2: a=0: Hilbert polynomial " << toString hilbertPolynomial(J0s, Projective=>false) << endl << flush;
<< "S2: a=0: Jsat = " << toString J0s << endl << flush;
-- extra control: random a
ar = random kk;
Jr = ideal jacobian ideal Fof(ar, lam, xv);
<< "S2 extra: random a=" << ar << ": dim(affine) of Jacobian ideal = " << dim Jr << endl << flush;
