load "setup.m2";
D = setupX(32003, 1); S = D#"S"; F = D#"F";
jm = jacobian matrix{{F}};
for e in {7,8,9} do (t0 = cpuTime(); G = gb(transpose jm, ChangeMatrix=>true, DegreeLimit=>e); 
  print("deg", e, "cpu", cpuTime()-t0, "gb size", numcols gens G, "mem(KB)", get "!ps -o rss= -p $PPID 2>/dev/null"); stdio << flush;);
