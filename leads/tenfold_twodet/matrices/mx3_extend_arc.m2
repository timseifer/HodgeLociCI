-- mx3: extend T2's sixfold arc with undetermined coefficients.  EXACT over QQ(zeta_6).
-- usage (repository root): M2 --script leads/tenfold_twodet/matrices/mx3_extend_arc.m2 N [arcfile]
--   The exported arc (six_lam-1_arc.txt) is valid modulo eps^8 only.  Terms T_1..T_7 are kept (or, with arcfile, the
--   terms listed there); T_n for n beyond them gets one parameter per monomial of its type:
--     n = 1 mod 3: x0x1x6, x0x2x6, x0x3x6, x0x4x6, x1x3x6   (x2x4x6 is the normalisation, coefficient eps)
--     n = 2 mod 3: x0x6x7          n = 0 mod 3: x0x1x3, x0x2x4          (sixfold variables: x6, x7 = x8, x9 of the file)
--   The Taylor coefficients of the 8 period functions up to order N are then polynomials in the parameters;
--   their linear part is solved.  Output: which parameters are determined, and the resulting arc.
needsPackage("HodgeLociCI", FileName => "M2/HodgeLociCI.m2");
N = value(scriptCommandLine#1);
arcfile = if #scriptCommandLine > 2 then scriptCommandLine#2 else null;
D = fermatReadCertificate("M2/HodgeLociCI/data/six_lam-1_arc.txt");
S8 = D#"ring"; arc8 = D#"arc";
prev = if arcfile =!= null and fileExists arcfile then select(lines get arcfile, l -> #l > 0 and l#0 != "#") else {};
known = max(7, #prev);
typ = n -> if n % 3 == 1 then {{0,1,6},{0,2,6},{0,3,6},{0,4,6},{1,3,6}} else if n % 3 == 2 then {{0,6,7}} else {{0,1,3},{0,2,4}};
slots = flatten apply(toList(known+1..N), n -> apply(typ n, m -> (n, m)));
aa = getSymbol "aa";
S = fermatRing(3, 6, Parameters => apply(#slots, i -> aa_i)); z = fermatRoot S;
par = i -> S_(8 + i);                                              -- the parameters come after x_0..x_7
<< "variables of the ring: " << numgens S << " ; parameters: " << #slots << endl;
phi = map(S, S8, {S_0, S_1, S_2, S_3, S_4, S_5, 0, 0, S_6, S_7});
arc = apply(take(arc8, 7), T -> phi T);
use S;
if #prev > 7 then arc = arc | apply(toList(7..#prev-1), i -> value replace("zz", "z", replace("z", "(fermatRoot S)", replace("x_", "S_", prev#i))));
arc = arc | apply(toList(known+1..N), n -> sum(#slots, i -> if (slots#i)#0 == n then (par i) * product((slots#i)#1, v -> S_v) else 0_S));
L1 = {{0,1,1},{2,3,1},{4,5,1},{6,7,1}};
L2 = {{1,2,3},{3,4,3},{0,5,3},{6,7,3}};
P = fermatPeriodPolynomial(S, L1) - fermatPeriodPolynomial(S, L2);
tm = cpuTime();
E = fermatExpansion(P, arc, N);
<< "expansion " << numrows E << " x " << numcols E << " ; cpu " << cpuTime() - tm << endl << flush;
eqs = select(flatten entries E, e -> e != 0);
<< "non-zero equations: " << #eqs << " ; degrees in the parameters: " << toString tally apply(eqs, e -> first degree e) << endl;
I = ideal eqs;
G = flatten entries gens gb I;
<< "Groebner basis: " << #G << " elements ; dim of the solution set (in the " << #slots << " parameters, plus 8 for the x): " << dim I << endl;
lin = select(G, g -> first degree g <= 1);
<< "linear elements: " << #lin << endl;
red = apply(#slots, i -> (par i) % I);
scan(#slots, i -> << "  T_" << (slots#i)#0 << " " << toString (slots#i)#1 << " : " << (if red#i == par i then "FREE" else if first degree red#i == 0 and all(#slots, j -> degree(par j, red#i) == 0) then "determined" else "depends on free parameters") << endl);
isDet = i -> all(#slots, j -> degree(par j, red#i) == 0);
lastOK = known;
for n from known+1 to N do ( if all(select(toList(0..#slots-1), i -> (slots#i)#0 == n), isDet) then lastOK = n else break);
<< "RESULT terms determined up to order " << lastOK << " (equations used up to order " << N << ")" << endl;
if arcfile =!= null then (
    f := openOut arcfile;
    f << "# true arc terms T_1.. (sixfold variables x_0..x_7 = x0..x5, x8, x9 of the exported file; z = zeta_6); determined with equations up to order " << N << endl;
    Sx := (coefficientRing S)[x_0..x_7];
    scan(lastOK, k -> ( n := k + 1;
        T := if n <= known then arc#k else sum(#slots, i -> if (slots#i)#0 == n then (red#i) * product((slots#i)#1, v -> S_v) else 0_S);
        f << toString T << endl));
    close f;
    << "written " << lastOK << " terms to " << arcfile << endl);
