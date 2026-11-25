ulimit -v 2500000
cd /home/claude/hodge/discovery/checks/w3/sp_copy
while pgrep -f "gen_dirs.py 67108819 0 -1 1 al 8" > /dev/null; do sleep 10; done
for d in 67108837_s2_al 67108819_s4_la 67108837_s5_la 67108819_s2_al 67108837_s3_al 67108819_s5_la; do
  python3 run_job.py inputs/dir_$d.json 8 --threads 1 --out /home/claude/hodge/discovery/checks/w3/sp_results > /home/claude/hodge/discovery/checks/w3/sp8_$d.log 2>&1
done
