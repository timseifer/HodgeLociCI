-- C3 cross-check with the package (black box): order-6 system of the lambda = 2 file jet, all 120 monomials.
needsPackage("HodgeLociCI", FileName => "M2/HodgeLociCI.m2");
fn = scriptCommandLine#1; p = value scriptCommandLine#2;
S = fermatRing(3, 8, p);
use S;
lns = select(lines get ("leads/movasati_arc/arcs/" | fn), l -> #l > 0);
Ts = apply(drop(lns, 3), l -> value l);
L1 = apply(5, i -> {2*i, 2*i+1, 1});
L2 = apply(5, i -> {2*i, 2*i+1, if i < 3 then 3 else 1});
P = fermatPeriodPolynomial(S, L1) + 2 * fermatPeriodPolynomial(S, L2);
r = fermatNextOrderSystem(P, Ts);
print("RESULT pkg3 file " | fn | " terms " | toString(#Ts) | " order " | toString(r#"order") | " lowerOrdersVanish " | toString(r#"lowerOrdersVanish") | " solvable " | toString(r#"solvable"));
ob = flatten entries r#"obstruction";
print("RESULT pkg3 obstruction entries " | toString(#ob) | " non-zero " | toString(#select(ob, c -> c != 0)));
print("RESULT pkg3 obstruction " | toString(apply(ob, c -> lift(c, ZZ))));
