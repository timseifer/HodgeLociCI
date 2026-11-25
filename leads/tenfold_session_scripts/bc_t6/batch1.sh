cd /home/claude/hodge/discovery/checks/bc_t6
for p in 2000000089 2000000137; do
  for lam in -1 2; do
    timeout 3000 python3 step5_hensel.py $p $lam 9 8 r1 2 > hensel_s8_r1_lam${lam}_p$p.log 2>&1
  done
done
