-- q5b.m2 : the tenfold built on exactly the planes pi used for the counts in inst.m2 / q23.py.  expects pp, sd, tag
load "common.m2";
print("== Q5b instance " | tag | ": p=" | toString pp | " seed=" | toString sd | " lam=" | toString lam | " x=" | toString xx);
dat = lines get("data_" | tag | ".txt");
getM = key -> (
    ln := select(dat, l -> #l > #key + 3 and substring(0, #key + 3, l) == key | " = ");
    sub(matrix value replace("\\]", "}", replace("\\[", "{", substring(#key + 3, ln#0))), kk));
S12 = kk[z_0..z_2,p_0..p_2,q_0..q_2,w_0..w_2];
toS = map(S12, R, (vars S12)_{0..8});
FS = toS F;
yv = (vars S12)_{0..8}; wv = (vars S12)_{9..11};
for key in {"pi_1", "pi_2", "pi_3", "pi_4"} do (
    piM = getM key;
    Npi = transpose gens kernel piM;
    lpi = flatten entries (yv * transpose sub(Npi, S12));
    Phi = apply(3, k -> sum(6, j -> lpi#j * random(1, S12)));
    G = FS + sum(3, k -> (wv_(0,k)) * Phi#k);
    c1 = (sub(G, {w_0 => 0, w_1 => 0, w_2 => 0}) == FS);
    c2 = ((G % ideal lpi) == 0);
    c3 = (ideal(lpi) + ideal(w_0,w_1,w_2) == ideal(flatten entries (yv * transpose sub(Npi, S12))) + ideal(w_0,w_1,w_2));
    t0 = cpuTime();
    gbx = groebnerBasis(ideal jacobian matrix{{G}}, Strategy => "F4");
    lts = flatten entries leadTerm gbx;
    pure = select(gens S12, v -> any(lts, m -> (support m == {v})));
    print("Q5b [" | key | " of data_" | tag | "]: X cap {w=0} = Y: " | toString c1 | "; Lambda in X: " | toString c2 | "; singular locus of X: affine dim " | toString dim ideal lts | " (0 = smooth), pure powers for " | toString(#pure) | "/12 variables, degree " | toString degree ideal lts | " [" | toString(cpuTime()-t0) | " s]");
    );
print("== Q5b done " | tag);
