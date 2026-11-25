#!/bin/bash
# BC-SO3: remaining tenfold runs, sequential, resumable
B=/home/claude/hodge/discovery/checks/bc_so3
for sp in "3 31991" "4 32003" "4 31991"; do
  set -- $sp; s=$1; p=$2; X=$B/x10_s${s}_${p}
  if ! grep -q "O3NP DONE" $B/o3np_s${s}_${p}.out 2>/dev/null; then
    if [ ! -f $X/syz0deg.txt ]; then
      cd /home/claude/hodge/discovery/checks/bc_so
      n=$(ls $X/gc*.txt 2>/dev/null | wc -l)
      if [ -f $X/wgens.txt ] && [ "$n" -ge 8 ] && [ -s $X/gc7.txt ]; then R=resume; else R=; fi
      (ulimit -v 1900000; nice M2 --script ../bc_so3/t10x.m2 $s $p $R >> $B/t10x_s${s}_${p}.out 2>&1)
    fi
    cd $B; NTERM=30 nice python3 o3np.py $X $s 2500 3 > $B/o3np_s${s}_${p}.out 2>&1
  fi
done
echo ALLDONE > $B/runrest.done
