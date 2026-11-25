-- quick mod p sanity run in P^8
pr = value (scriptCommandLine#1);
kk = ZZ/pr;
load "common.m2";
stdio << "prime " << pr << endl << flush;
stdio << "terms of F: " << #terms sub(F,S) << "  F8 terms " << #terms G8 << endl;
stdio << "Mtri = " << toString Mtri << endl;
t = cpuTime();
stdio << "Sigma: dim " << dim ISig << " degree " << degree ISig << " HF(R/I) " << hfl(8, ISig) << endl << flush;
Isat = saturate ISig;
stdio << "HF sat " << hfl(8, Isat) << endl;
Icm = ISig : ideal vars R;
stdio << "HF I:m " << hfl(8, Icm) << "  I:m == sat ? " << (Icm == Isat) << endl;
K = ISig + ideal(P2);
stdio << "K = I+Phi2: dim " << dim K << " HF " << hfl(8, K) << endl << flush;
J8s = saturate J8;
stdio << "J8: dim " << dim J8 << " deg " << degree J8 << " HF(R/J8) " << hfl(6,J8) << endl;
stdio << "J8sat: HP " << toString hilbertPolynomial(J8s, Projective=>false) << " HF " << hfl(6,J8s) << " gens degrees " << tally flatten degrees source mingens J8s << endl;
stdio << "time " << cpuTime()-t << endl;
