ulimit -v 2500000
cd /home/claude/hodge/discovery/checks/w3
for p in 67108837 67108819; do for s in 1 2 3 4 5 6; do k=al; [ $s -gt 3 ] && k=la
  [ -f gen_${p}_2_${s}_${k}.log ] && grep -q HISTORY gen_${p}_2_${s}_${k}.log && continue
  python3 gen_dirs.py $p 0 2 $s $k 6 > gen_${p}_2_${s}_${k}.log 2>&1; done; done
python3 gen_dirs.py 67108837 0 -1 1 al 8 > gen_67108837_-1_1_al.log 2>&1
