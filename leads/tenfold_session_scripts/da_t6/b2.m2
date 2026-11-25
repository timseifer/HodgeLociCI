PRIMEVAL = 32029;
load "/home/claude/hodge/discovery/t6_unsolved/e/setup_p.m2";
D = setupLambda(-1_K);
ls = lines get "/home/claude/hodge/discovery/checks/da_t6/b2_arc.txt";
Ts = apply(ls, l -> (w := separate(" ", l); value(w#1)));
C = elapsedTime fermatExpansion(D#"P", Ts, 4);
f = openOut "/home/claude/hodge/discovery/checks/da_t6/b2_pkg_cs.txt";
scan(numcols C, j -> f << toString apply(flatten entries C_{j}, a -> lift(a, ZZ)) << endl);
close f; print "done";
