#!/bin/bash
cd /home/claude/blind_check5
for p in 2147483629 2147483587; do
  for seed in 11 12; do
    python3 runmem.py t7.py $seed 10 $p > logs_t7_seed${seed}_N10_p${p}.txt 2>&1
  done
  python3 runmem.py t7.py 13 9 $p true,i,ii,iii,iv 3,2,3 > logs_t7_seed13_sizes323_N9_p${p}.txt 2>&1
  python3 runmem.py t7.py 14 9 $p true,i,ii,iii,iv 3,3,3 small > logs_t7_seed14_sizes333_small_N9_p${p}.txt 2>&1
done
echo done > logs_t7_batch_done.txt
