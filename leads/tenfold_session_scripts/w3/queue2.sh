ulimit -v 2500000
cd /home/claude/hodge/discovery/checks/w3
while pgrep -f "queue1.sh" > /dev/null; do sleep 10; done
python3 hi_order2.py 67108819 0 al 12 > hi_67108819_0_al_12.log 2>&1
python3 hi_order2.py 67108837 0 la 11 > hi_67108837_0_la_11.log 2>&1
python3 hi_order2.py 67108819 0 la 11 > hi_67108819_0_la_11.log 2>&1
for p in 67108837 67108819; do for s in 1 2 3 4 5 6; do k=al; [ $s -gt 3 ] && k=la
  [ $p = 67108837 ] && [ $s = 1 ] && continue
  python3 gen_dirs.py $p 0 -1 $s $k 7 > gen7_${p}_-1_${s}_${k}.log 2>&1; done; done
python3 gen_dirs.py 67108837 0 -1 4 la 8 > gen_67108837_-1_4_la.log 2>&1
python3 gen_dirs.py 67108819 0 -1 1 al 8 > gen_67108819_-1_1_al.log 2>&1
