ulimit -v 2500000
cd /home/claude/hodge/discovery/checks/w3
while pgrep -f "queue2.sh" > /dev/null; do sleep 10; done
python3 gen_dirs.py 67108837 0 -1 2 al 8 > gen_67108837_-1_2_al.log 2>&1
python3 gen_dirs.py 67108819 0 -1 4 la 8 > gen_67108819_-1_4_la.log 2>&1
