# cloud-job-1 results (AI-generated computation, MOD p, not reviewed by a human)

Validation: PASS (Tue Nov 24 02:50:42 UTC 2026)

Machine:

```
Linux 129-153-231-100 6.8.0-1064-nvidia #67~22.04.1-Ubuntu SMP PREEMPT_DYNAMIC Thu Sep 17 21:53:31 UTC 2 x86_64 x86_64 x86_64 GNU/Linux
30
               total        used        free      shared  buff/cache   available
Mem:             222           1         219           0           2         219
Swap:              0           0           0
Python 3.10.12
numpy 1.21.5
g++ (Ubuntu 11.4.0-1ubuntu1~22.04.3) 11.4.0
```

## Headline

lambda = -1: 6 run(s) EXTEND to their requested order (highest order reached: 14).
A finite order is evidence only; it cannot prove that a component exists (checks/w4 REPORT.md).

## All runs

| job | lambda | prime | seed | kind | N req | N reached | verdict | runtime s | peak RSS GB | note |
|---|---|---|---|---|---|---|---|---|---|---|
| c | -1 | 67108819 | 0 | exarc_al | 13 | 13 | EXTENDS | 312.4 | 4.4 | arc to order 13 |
| c | -1 | 67108819 | 0 | exarc_la | 13 | 13 | EXTENDS | 506.6 | 5.52 | arc to order 13 |
| c | -1 | 67108837 | 0 | exarc_la | 13 | 13 | EXTENDS | 510.6 | 5.52 | arc to order 13 |
| c | -1 | 67108837 | 0 | exarc_al | 14 | 14 | EXTENDS | 1049.2 | 10.21 | arc to order 14 |
| c | -1 | 67108819 | 0 | exarc_al | 14 | 14 | EXTENDS | 1039.2 | 10.21 | arc to order 14 |
| c | -1 | 67108837 | 0 | exarc_la | 14 | 14 | EXTENDS | 1587.8 | 13.05 | arc to order 14 |

code_commit: ['1d72e136405a98de6a70c14bbdb1caa131ac0adf']; engine_version: ['1f4eeb9d39c7']
