-- T4: Hilbert function of kk[z,p,q]/(9 partials, 3 random quadrics)
pp = value(scriptCommandLine#1); sd = value(scriptCommandLine#2); mode = scriptCommandLine#3;
load "/home/claude/blind_check2/lib.m2";
Phi = apply(3, k -> random(2, R));
I = J + ideal Phi;
B = R/I;
<< "T4 (" << mode << "): affine dim = " << dim I << "; HF degrees 0..9: " << apply(10, d -> hilbertFunction(d, B)) << "; total length " << sum apply(12, d -> hilbertFunction(d, B)) << endl << flush;
