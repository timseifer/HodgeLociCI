#!/bin/bash
cd /home/claude/hodge/discovery/checks/ts_t6; ulimit -v 4000000
OMP_NUM_THREADS=1 nice -n 10 python3 tsjob.py --lam 2 --p 67108837 --gseed 0 --seed 1 --kind al --N 6 --threads 1 --out runs2v --tables tables2 --mc /home/claude/hodge/package/HodgeLociCI/jobs/cloud-job-1/inputs/mc_67108837_lam2.json > runs2v/v_g0_lam2_67108837_s1_al_N6.log 2>&1
python3 cmplog.py runs2v/v_g0_lam2_67108837_s1_al_N6.log ../w3/gen_67108837_2_1_al.log > runs2v/cmp1.out 2>&1
OMP_NUM_THREADS=1 nice -n 10 python3 tsjob.py --lam -1 --p 67108819 --gseed 0 --seed 1 --kind al --N 6 --threads 1 --out runs2v --tables tables2 --mc /home/claude/hodge/package/HodgeLociCI/jobs/cloud-job-1/inputs/mc_67108819_lam-1.json > runs2v/v_g0_lam-1_67108819_s1_al_N6.log 2>&1
python3 cmplog.py runs2v/v_g0_lam-1_67108819_s1_al_N6.log ../w3/gen_67108819_-1_1_al.log > runs2v/cmp2.out 2>&1
echo done > runs2v/done
