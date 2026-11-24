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

lambda = -1: 1 run(s) EXTEND to their requested order (highest order reached: 12).
A finite order is evidence only; it cannot prove that a component exists (checks/w4 REPORT.md).

## All runs

| job | lambda | prime | seed | kind | N req | N reached | verdict | runtime s | peak RSS GB | note |
|---|---|---|---|---|---|---|---|---|---|---|
| a | -1 | 67108837 | 1 | al | 12 | 12 | EXTENDS | 7935.6 | 117.832 | arc to order 12 |

code_commit: ['1361aef15a889545373b126f8de0d453f7cba664', 'c1fd3c5d3fc260494ee7ac0664ba9aff63d9c68e']; engine_version: ['1f4eeb9d39c7', '8e8d1b39e4f3']

## Operator note (cloud lead)

The manifest has two rows for the same task. Row 1 (ERROR, exit -9) is attempt 1, killed by the cloud lead at
03:33:49Z after order 11 had completed (K.c_11 in Im DG4(v): True), because order 12 could not finish within the
original 100-minute budget; its log/sidecar are kept as runs/*.attempt1_killed_after_order11.{log,json}. It is NOT an
obstruction. The operator (Tim) then approved a longer time budget, and the identical R001 command was rerun
(03:47:05Z - 05:59:24Z, 22 threads, next to R004/R010): row 2, EXTENDS to order 12 (HISTORY ... (12, 'corrected x9
(affine)')), 7936 s, peak RSS 117.8 GB (above the 108 GB estimate; E'_11 = 9,869,427,386 terms).
check_results.py keeps the last row per log: CHECK PASS.
