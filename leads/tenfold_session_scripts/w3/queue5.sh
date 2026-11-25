ulimit -v 2500000
cd /home/claude/hodge/discovery/checks/w3/sp_copy
while pgrep -f "queue4.sh" > /dev/null; do sleep 10; done
for d in 67108837_s6_la 67108819_s3_al 67108819_s6_la; do
  python3 run_job.py inputs/dir_$d.json 8 --threads 1 --out /home/claude/hodge/discovery/checks/w3/sp_results > /home/claude/hodge/discovery/checks/w3/sp8_$d.log 2>&1
done
