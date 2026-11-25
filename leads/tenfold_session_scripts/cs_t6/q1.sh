cd /home/claude/hodge/discovery/checks/cs_t6
( for j in "a1.m2 2 32003" "a1.m2 1 31991" "d1.m2 2 32003 R22" "d1.m2 1 31991 R22" "d1.m2 2 31991 R22"; do set -- $j; nice -n 10 M2 --script $j > run_$(echo $j | tr ' ' '_').out 2>&1; done ) &
( for j in "d1.m2 1 32003 R23" "d1.m2 2 32003 R23" "d1.m2 1 32003 R33" "d1.m2 1 31991 R23" ; do nice -n 10 M2 --script $j > run_$(echo $j | tr ' ' '_').out 2>&1; done ) &
wait
