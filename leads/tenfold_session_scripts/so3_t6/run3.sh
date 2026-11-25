#!/bin/sh
cd /home/claude/hodge/discovery/checks/so3_t6
nice -n 10 M2 --script c2p.m2 1 31981 > c2p_1_31981.out 2>&1
nice -n 10 M2 --script t3.m2 1 32003 h > t3_h_1_32003.out 2>&1
nice -n 10 M2 --script t3.m2 2 32003 G > t3_G_2_32003.out 2>&1
nice -n 10 M2 --script t3.m2 1 31991 G > t3_G_1_31991.out 2>&1
nice -n 10 M2 --script t3.m2 2 31991 G > t3_G_2_31991.out 2>&1
nice -n 10 M2 --script t3.m2 2 32003 h > t3_h_2_32003.out 2>&1
echo done $(date -u) >> run3.log
