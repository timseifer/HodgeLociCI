cd /home/claude/hodge/discovery/checks/bc_t6
for lam in -1 2; do timeout 3000 python3 step5_hensel.py 2000000011 $lam 9 8 r2 2 > hensel_s8_r2_lam$lam.log 2>&1; done
for lam in -1 2; do timeout 3000 python3 step5_hensel.py 2000000011 $lam 9 8 r1diag 1 > hensel_s8_r1diag_lam$lam.log 2>&1; done
